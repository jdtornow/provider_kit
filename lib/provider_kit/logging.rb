# frozen_string_literal: true

module ProviderKit
  # Utility class to log warnings and failures found during data imports
  module Logging

    extend ActiveSupport::Concern

    included do
      cattr_accessor :logger, default: ActiveSupport::TaggedLogging.new(Rails.logger)

      around_perform do |task, block, _|
        tag_logger(task.class.name, task.process_id) do
          payload = {
            provider: task.provider&.key.presence || "unknown provider",
            task:
          }

          ActiveSupport::Notifications.instrument("perform_start.provider_kit_tasks", payload.dup)

          ActiveSupport::Notifications.instrument("perform.provider_kit_tasks", payload) do
            block.call
          end
        end
      end
    end

    private

      def logger
        Rails.logger
      end

      def tag_logger(*tags)
        tags.unshift(provider.key)
        tags.unshift("Provider")

        logger.tagged(*tags) { yield }
      end

      class LogSubscriber < ActiveSupport::LogSubscriber

        def perform_start(event)
          info do
            task      = event.payload[:task]
            provider  = event.payload[:provider]

            "Performing #{ task.class.name } (Process ID: #{ task.process_id }) for #{ provider }"
          end
        end

        def perform(event)
          task      = event.payload[:task]
          provider  = event.payload[:provider]
          ex        = event.payload[:exception_object]

          if ex
            error do
              "Error performing #{ task.class.name } (Process ID: #{ task.process_id }) for #{ provider } in #{ event.duration.round(2) }ms: #{ ex.class } (#{ ex.message }):\n" + Array(ex.backtrace).join("\n")
            end
          else
            info do
              "Performed #{ task.class.name } (Process ID: #{ task.process_id }) for #{ provider } in #{ event.duration.round(2) }ms"
            end
          end
        end

      end

  end
end

ProviderKit::Logging::LogSubscriber.attach_to :provider_kit_tasks

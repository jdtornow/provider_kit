# frozen_string_literal: true

require "active_support/rescuable"

module ProviderKit
  # Handles the execution of Tasks
  #
  # Includes callbacks for the perform method, so the following callbacks are available:
  #
  # * before_perform
  # * around_perform
  # * after_perform
  #
  # Also included is Rescuable, so an individual task can be rescued like a job:
  #
  #    rescue_from InvalidProviderContext do
  #      logger.warn "Provider context was not found for this task"
  #    end
  #
  module Execution

    extend ActiveSupport::Concern
    include ActiveSupport::Rescuable

    def perform_now
      run_callbacks :perform do
        perform
      end
    rescue => exception
      tag_logger(self.class.name, process_id) do
        rescue_with_handler(exception) || raise
      end
    end

    def perform
      fail NotImplementedError
    end

  end
end

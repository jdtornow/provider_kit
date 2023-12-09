# frozen_string_literal: true

require "active_support/callbacks"

module ProviderKit
  # Add callback behavior to services for logging and lifecycle checks
  module Callbacks

    extend  ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      define_callbacks :perform
    end

    module ClassMethods

      def after_perform(*filters, &blk)
        set_callback(:perform, :after, *filters, &blk)
      end

      def around_perform(*filters, &blk)
        set_callback(:perform, :around, *filters, &blk)
      end

      def before_perform(*filters, &blk)
        set_callback(:perform, :before, *filters, &blk)
      end

    end

  end
end

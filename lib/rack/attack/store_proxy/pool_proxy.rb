# frozen_string_literal: true

require 'delegate'

module Rack
  class Attack
    module StoreProxy
      class PoolProxy < SimpleDelegator
        def self.unwrap_connection_pool_class(store)
          if defined?(::ConnectionPool) && store.is_a?(::ConnectionPool)
            store.with { |conn| conn.class }
          else
            store.class
          end
        end

        def initialize(store)
          super(store)
          stub_with_if_missing
        end

        protected

        def stub_with_if_missing
          unless __getobj__.respond_to?(:with)
            class << self
              def with; yield __getobj__; end
            end
          end
        end
      end
    end
  end
end

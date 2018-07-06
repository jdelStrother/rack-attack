# frozen_string_literal: true

module Rack
  class Attack
    module StoreProxy
      class DalliProxy < PoolProxy
        def self.handle?(store)
          return false unless defined?(::Dalli)
          unwrap_connection_pool_class(store) <= ::Dalli::Client
        end

        def read(key)
          with do |client|
            client.get(key)
          end
        rescue Dalli::DalliError
        end

        def write(key, value, options = {})
          with do |client|
            client.set(key, value, options.fetch(:expires_in, 0), raw: true)
          end
        rescue Dalli::DalliError
        end

        def increment(key, amount, options = {})
          with do |client|
            client.incr(key, amount, options.fetch(:expires_in, 0), amount)
          end
        rescue Dalli::DalliError
        end

        def delete(key)
          with do |client|
            client.delete(key)
          end
        rescue Dalli::DalliError
        end
      end
    end
  end
end

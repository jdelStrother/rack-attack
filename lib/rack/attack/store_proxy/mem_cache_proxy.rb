# frozen_string_literal: true

module Rack
  class Attack
    module StoreProxy
      class MemCacheProxy < PoolProxy
        def self.handle?(store)
          return false unless defined?(::MemCache)
          unwrap_connection_pool_class(store) <= ::MemCache
        end

        def read(key)
          # Second argument: reading raw value
          get(key, true)
        rescue MemCache::MemCacheError
        end

        def write(key, value, options = {})
          # Third argument: writing raw value
          set(key, value, options.fetch(:expires_in, 0), true)
        rescue MemCache::MemCacheError
        end

        def increment(key, amount, _options = {})
          incr(key, amount)
        rescue MemCache::MemCacheError
        end

        def delete(key, _options = {})
          with do |client|
            client.delete(key)
          end
        rescue MemCache::MemCacheError
        end
      end
    end
  end
end

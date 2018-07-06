# frozen_string_literal: true

require_relative '../spec_helper'

describe Rack::Attack::StoreProxy do
  describe ".build" do
    if defined?(::Dalli)
      it "uses DalliProxy to handle ActiveSupport MemCacheStore" do
        store = ActiveSupport::Cache::MemCacheStore.new
        assert_instance_of Rack::Attack::StoreProxy::DalliProxy, Rack::Attack::StoreProxy.build(store)
      end
    end
    if defined?(::Dalli) && defined?(::ConnectionPool)
      it "uses DalliProxy to handle ActiveSupport MemCacheStore with a connection pool" do
        store = ActiveSupport::Cache::MemCacheStore.new(pool_size: 5)
        assert_instance_of Rack::Attack::StoreProxy::DalliProxy, Rack::Attack::StoreProxy.build(store)
      end
    end
    if defined?(::Redis)
      it "uses RedisProxy to handle plain redis backends" do
        store = Redis.new
        assert_instance_of Rack::Attack::StoreProxy::RedisProxy, Rack::Attack::StoreProxy.build(store)
      end
    end
    if defined?(::Redis) && defined?(::ActiveSupport::Cache::RedisCacheStore)
      it "uses RedisCacheStoreProxy to handle plain ActiveSupport RedisCacheStore" do
        store = ActiveSupport::Cache::RedisCacheStore.new
        assert_instance_of Rack::Attack::StoreProxy::RedisCacheStoreProxy, Rack::Attack::StoreProxy.build(store)
      end
    end
    if defined?(::Redis) && defined?(::ActiveSupport::Cache::RedisCacheStore) && defined?(::ConnectionPool)
      it "uses RedisCacheStoreProxy to handle plain ActiveSupport RedisCacheStore with a connection pool" do
        store = ActiveSupport::Cache::RedisCacheStore.new(pool_size: 2)
        assert_instance_of Rack::Attack::StoreProxy::RedisCacheStoreProxy, Rack::Attack::StoreProxy.build(store)
      end
    end
  end
end

require "thin_heartbeat/version"
require "json"
require "active_support/core_ext"
require "redis"

module ThinHeartbeat
  class Pulse
    attr_accessor :redis

    def initialize(host, password = nil)
      @redis = Redis.new(:host => host, :port => 6379)
      @redis.auth(password) if password
    end

    def extend_life(heartbeat)
      key = get_key_from_heartbeat(heartbeat)
      puts key.inspect
      redis.expire key, 30
    end

    def get_key_from_heartbeat(heartbeat)
      hb = Hashie::Mash.new(heartbeat)
      "hb:#{hb.data.user_type}:#{hb.data.user_id}:#{hb.clientId}:#{hb.data.location}"
    end

    def get_key(client)
      raise client.inspect if client.user_id.blank? || client.user_type.blank?
      "hb:#{client.user_type}:#{client.user_id}:#{client.client_id}:#{client.location}"
    end

    def add(client)
      key = get_key(client)
      redis.sadd key, client.to_json
      redis.expire key, 30
      client
    end

    def delete(client)
      key = redis.keys "hb:*:#{client.client_id}:*"
      if client_json = redis.spop(key.first)
        client_hash = JSON.parse(client_json)
      else
        nil
      end
    end
  end
end

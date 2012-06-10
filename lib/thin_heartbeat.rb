require "thin_heartbeat/version"
require "json"
require "active_support/core_ext"
require "redis"

module ThinHeartbeat
  class Pulse
    attr_accessor :redis

    def initialize(password = nil)
      @redis = Redis.new(:host => 'localhost', :port => 6379)
      @redis.auth(password) if password
    end

    def extend_life(heartbeat)
      key = get_key_from_heartbeat(heartbeat)
      redis.expire key, 30
    end

    def get_key_from_heartbeat(heartbeat)
      hb = Hashie::Mash.new(heartbeat)
      "hb:#{hb.data.user_type}:#{hb.data.user_id}:#{hb.clientId}:#{hb.data.room_id}"
    end

    def get_key(client)
      raise client.inspect if client.user_id.blank? || client.user_type.blank?
      "hb:#{client.user_type}:#{client.user_id}:#{client.client_id}:#{client.room_id}"
    end

    def add(client)
      key = get_key(client)
      redis.sadd key, client.to_json
      redis.expire key, 30
      client
    end

    def delete(client)
      key = redis.keys "hb:*:#{client.client_id}:*"
      # puts "KEY: #{key.first.inspect}"
      client_json = redis.spop key.first
      # puts "CLIENT_JSON: #{client_json.inspect}"
      client_hash = JSON.parse(client_json)
    end
  end
end

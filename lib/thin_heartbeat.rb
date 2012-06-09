require "thin_heartbeat/version"
require "json"
require "active_support/core_ext"
require "redis"
require "config/initializers/redis"

module ThinHeartbeat
  class Pulse
    # REDIS = Redis.new(:host => 'localhost', :port => 6379)

    def self.extend_life(heartbeat)
      key = get_key_from_heartbeat(heartbeat)
      REDIS.expire key, 30
    end

    def self.get_key_from_heartbeat(heartbeat)
      hb = Hashie::Mash.new(heartbeat)
      "hb:#{hb.data.user_type}:#{hb.data.user_id}:#{hb.clientId}:#{hb.data.room_id}"
    end

    def self.get_key(client)
      raise client.inspect if client.user_id.blank? || client.user_type.blank?
      "hb:#{client.user_type}:#{client.user_id}:#{client.client_id}:#{client.room_id}"
    end

    def self.add(client)
      key = get_key(client)
      REDIS.sadd key, client.to_json
      REDIS.expire key, 30
      client
    end

    def self.delete(client)
      key = REDIS.keys "hb:*:#{client.client_id}:*"
      # puts "KEY: #{key.first.inspect}"
      client_json = REDIS.spop key.first
      # puts "CLIENT_JSON: #{client_json.inspect}"
      client_hash = JSON.parse(client_json)
    end
  end
end

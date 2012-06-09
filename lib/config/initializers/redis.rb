REDIS = Redis.new(:host => 'localhost', :port => 6379)
require "config/initializers/secret.rb"
REDIS.auth(REDIS_PASSWORD) if ENV["RACK_ENV"] == "production"


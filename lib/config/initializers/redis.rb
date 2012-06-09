REDIS = Redis.new(:host => 'localhost', :port => 6379)
if ENV["RAILS_ENV"] == 'production'
  require "config/initializers/secret.rb"
  REDIS.auth(REDIS_PASSWORD)
end
REDIS = Redis.new(:host => 'localhost', :port => 6379)
if Rails.env == 'production'
  require "config/initializers/secret.rb"
  REDIS.auth(REDIS_PASSWORD)
end
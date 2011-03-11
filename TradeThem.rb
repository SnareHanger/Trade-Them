require 'rubygems'
require 'twitter'
require_relative "twitterComm.rb"

twitComm = TWITTERCOMM.new

#@TradeThem feed api setup
Twitter.configure do |config|
    config.consumer_key = THE_KEY
    config.consumer_secret = THE_SECRET
    config.oauth_token = THE_TOKEN
    config.oauth_token_secret = THE_TOKEN_SECRET
end

puts twitComm.getMentions

 
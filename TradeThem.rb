require 'rubygems'
require 'twitter'
require 'parseconfig'
require_relative "twitterComm.rb"

twitComm = TWITTERCOMM.new

pConfig = ParseConfig.new('twitter_config.txt')

#@TradeThem feed api setup
Twitter.configure do |config|
    config.consumer_key = pConfig.get_value('consumer_key')
    config.consumer_secret = pConfig.get_value('consumer_secret')
    config.oauth_token = pConfig.get_value('oauth_token')
    config.oauth_token_secret = pConfig.get_value('oauth_token_secret')
end

puts twitComm.getMentions

 
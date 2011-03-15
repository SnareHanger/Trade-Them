require 'rubygems'
require 'twitter'
require 'parseconfig'
require "twitterComm"

twitComm = TWITTERCOMM.new

pConfig = ParseConfig.new('twitter_config.txt')

#@TradeThem feed api setup
Twitter.configure do |config|
    config.consumer_key = pConfig.get_value('trade_consumer_key')
    config.consumer_secret = pConfig.get_value('trade_consumer_secret')
    config.oauth_token = pConfig.get_value('trade_oauth_token')
    config.oauth_token_secret = pConfig.get_value('trade_oauth_token_secret')
end

incoming_tweets = twitComm.getMentions
#last_tweet_id = ?

twitComm.send_lack_of_shares_tweet("@SnareHanger", "Company X")

twitComm.send_insufficient_funds("@SnareHanger")

twitComm.send_portfolio_value_tweet("SnareHanger", 8230.25)


incoming_tweets.each do |tweet|
  #"buy" => "Buy" :-P
  tweet[:type].gsub!(/^(\w{1})/) {|s| s.upcase}

  txs = Transaction.active.not_executed.where(
    :type => tweet[:type],
    :buyer => "mike",
    :stock => "CompA",
    :executed => false)
end


#f.puts last_tweet_id
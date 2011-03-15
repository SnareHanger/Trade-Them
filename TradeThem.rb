require 'rubygems'
require 'twitter'
require 'yaml' #muahaha

#relative
require "twitterComm"
require 'models'

twitComm = TWITTERCOMM.new

twitter_config = YAML::load_file 'config/twitter.yml'

#@TradeThem feed api setup
Twitter.configure do |config|
    config.consumer_key = twitter_config['trade']['consumer_key']
    config.consumer_secret = twitter_config['trade']['consumer_secret']
    config.oauth_token = twitter_config['trade']['oauth_token']
    config.oauth_token_secret = twitter_config['trade']['oauth_token_secret']
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
    :stock => "CompA"
  )
end


#f.puts last_tweet_id
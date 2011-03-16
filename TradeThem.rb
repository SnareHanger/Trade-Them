require 'rubygems'
require 'twitter'
require 'parseconfig'
require_relative "twitterComm"
require_relative "models"
require 'yaml' #muahaha

#relative
#require "twitterComm"
#require 'models'

def opposite_type(type)
  return "Sell" if type =~ /buy/i
  return "Buy" if type =~ /sell/i
end

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

#TESTING
#twitComm.send_lack_of_shares_tweet("@SnareHanger", "Company X")
#twitComm.send_insufficient_funds("@SnareHanger")
#twitComm.send_portfolio_value_tweet("SnareHanger", 8230.25)

#Go through incoming tweets and process them
incoming_tweets.each do |tweet|
  last_tweet_id = tweet[:id]

  #"buy" => "Buy" :-P
  tweet[:type].gsub!(/^(\w{1})/) {|s| s.upcase}

  #see if there are any transactions pending
  txs = Transaction.active.not_executed.where(
    :type => opposite_type(tweet[:type]),
    :stock => tweet[:stock]
  ) #order - most recent first? or oldest first?  thinking oldest
  #.order("created_at ASC")
  #oldest_first #scope

  #additional filter on buyer or seller
  case tweet[:type]
  when /buy/i
    txs = txs.where(:seller => tweet[:seller])
  when /sell/i
    txs = txs.where(:buyer => tweet[:buyer])
  end

  #any pending transactions?
  if txs.any?
    tr = txs.first
    if tr.quantity == tweet[:quantity] && tr.price == tweet[:price]
      #tr.execute_and_tweet!
      tr.execute!
      #update twitter with confirmed transaction
    else #it's a counter-offer
      Transaction.create!(tweet) #should work, if everything was parsed correctly
    end
  else #no pending tweets
  end
end


#f.puts last_tweet_id
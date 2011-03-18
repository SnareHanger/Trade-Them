require 'rubygems'
require 'twitter'
require 'yaml' #muahaha
require_relative "twitterComm"
require_relative 'models'

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
last_tweet_id = nil

#TESTING
#twitComm.send_lack_of_shares_tweet("@SnareHanger", "Company X")
#twitComm.send_insufficient_funds("@SnareHanger")
#twitComm.send_portfolio_value_tweet("SnareHanger", 8230.25)

#Go through incoming tweets and process them
incoming_tweets.each do |tweet|
  last_tweet_id = tweet[:id]

  #"buy" => "Buy" :-P
  tweet[:type].gsub!(/^(\w{1})/) {|s| s.upcase}

  #whether to create new transaction or not
  new_tx = false

  to = tweet.delete(:to)
  if to.nil? || to.empty?
    new_tx = true
  else
    #see if there are any transactions pending
    company = Company.find_by_symbol(tweet[:company])

    txs = Transaction.active.not_completed.where(
      :type => opposite_type(tweet[:type]),
      :company => company
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
        tr.complete!
        #update twitter with confirmed transaction
      else #it's a counter-offer
        new_tx = true
      end
    end
  end

  #should work, if everything was parsed correctly
  if new_tx
    Transaction.create!(tweet)
  end
end

#save last tweet
#f.puts last_tweet_id
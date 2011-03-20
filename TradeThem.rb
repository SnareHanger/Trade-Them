require 'rubygems'
require 'twitter'
require 'yaml' #muahaha
require_relative "twitterComm"
require_relative 'models'

class TradeThem
  
  def opposite_type(type)
    return "Sell" if type =~ /buy/i
    return "Buy" if type =~ /sell/i
  end

  def configure
    @twitComm = TwitterComm.new

    twitter_config = YAML::load_file 'config/twitter.yml'

    #@TradeThem feed api setup
    Twitter.configure do |config|
        config.consumer_key = twitter_config['trade']['consumer_key']
        config.consumer_secret = twitter_config['trade']['consumer_secret']
        config.oauth_token = twitter_config['trade']['oauth_token']
        config.oauth_token_secret = twitter_config['trade']['oauth_token_secret']
    end
  end

  def main
    incoming_tweets = @twitComm.getMentions  #(since_id = 45969646003822591)
    last_tweet_id = nil

    #TESTING
    #twitComm.send_lack_of_shares_tweet("@SnareHanger", "Company X")
    #twitComm.send_insufficient_funds("@SnareHanger")
    #twitComm.send_portfolio_value_tweet("SnareHanger", 8230.25)

    #Go through incoming tweets and process them
    incoming_tweets.each do |tweet|
      next if tweet.nil? #can be nil if invalid format

      last_tweet_id = tweet[:id]

      #"buy" => "Buy" :-P
      tweet[:type].gsub!(/^(\w{1})/) {|s| s.upcase}

      company = Company.find_by_symbol(tweet[:company].upcase)

      if company.nil?
        @twitComm.tweet_error CompanyNotFoundError.new(tweet[:company].upcase) and next
      end

      #whether to create new transaction or not
      new_tx = false

      to = tweet.delete(:to)
      if to.nil? || to.empty?
        new_tx = true
      else
        #see if there are any transactions pending
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
            begin
              tr.complete!
              #update twitter with confirmed transaction
            rescue
              @twitComm.tweet_error $! and next
            end
          else #it's a counter-offer
            new_tx = true
          end
        end
      end

      #should work, if everything was parsed correctly
      if new_tx
        #puts tweet
        tx = Transaction.new
        tx.type = tweet[:type]
        
        case tweet[:type]
          when /buy/i
            tx.buyer = Player.find_by_username(tweet[:buyer])
            if tx.buyer.nil?
              @twitComm.tweet_error PlayerNotFoundError.new(tweet[:buyer]) and next
             end

          when /sell/i
            tx.seller = Player.find_by_username(tweet[:seller])
            if tx.seller.nil?
              @twitComm.tweet_error PlayerNotFoundError.new(tweet[:seller]) and next
             end
        end

        #puts tweet[:quantity]
        tx.company = company
        tx.quantity = tweet[:quantity]
        tx.price = tweet[:price]
        
        puts tx.inspect
        tx.save!
      end
    end
  end

  #save last tweet
  #f.puts last_tweet_id
end
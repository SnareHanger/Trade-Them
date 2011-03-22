require 'twitter'
require_relative 'functions'

class TwitterComm
  
  @messaging_player = String.new
  
  def getMentions(since_id = 50203620863524864, count = 50)
      begin
        #get all mentions since the first tweet mention...change when the game starts
        mentions = Twitter.mentions(:count => count, :since_id => since_id)

          if !(mentions.nil?)
            mentions.collect do |mention|
              @messaging_player = mention.user.screen_name
          
              mention.text.downcase!
              theMention = mention.text

              #strip the @tradethem handle
              theMention["@tradethem "] = ""

              #get the user the mention came from
              from = "@" + mention.user.screen_name
              to = ""
      
              #if the mention has another user's name in it
              #then set the to var otherwise leave it
              if theMention.include? "@"
                type, to, quantity, company, price = mention.text.split(' ')
              else
                type, quantity, company, price = mention.text.split(' ')
              end
      
              #checking the tweet to see if it's valid      
              validData = true
      
              if !type || (type != "buy" && type != "sell")
                validData = false
              end
      
              if !quantity || quantity.to_i == 0
                validData = false
              end
      
              if !company || company.empty?
                validData = false
              end
      
              if !price || price.to_f == 0
                validData = false
              end
      
              if !(to.empty?) 
                if (!(to.include? "@")) && (to.include? " ")
                  validData = false
                end
              end
      
              if !validData
                self.tweet_invalid_request(from)
                next
              end
      
              case type
                #if BUY the buyer is the from var
                when "buy"
                  buyer = from
                  seller = to unless to.empty?
          
                #if SELL the buyer is the from var
                when "sell"
                  seller = from
                  buyer = to unless to.empty?
              end
        
              #add to transactions array
              {
                :type => type,
                :to => to,
                :buyer => buyer,
                :seller => seller,
                :quantity => quantity.to_i,
                :company => company.upcase,
                :price => price.to_f
              }
      
            end
        end
      rescue
        self.tweet_error $!
      end
  end

  #if the seller doesn't have enough shares in the company
  def tweet_lack_of_shares( player, company_name )
    message = "Sorry " + check_player_at(player) + ", you don't have enough shares in " + company_name + " to complete the transaction"
    
    begin
      Twitter.update(message)
    rescue
      puts $!.message
    end
    
  end  
  
  #if the buyer doesn't have enough cash
  def tweet_insufficient_funds( player )
    player = check_player_at(player)
    message = "Sorry " + player + ", you don't have enough funds to complete the transaction"
    
    begin
      Twitter.direct_message_create(player, message)
    rescue
      puts $!.message
    end
  end
  
  #send out message to players letting them know their current portfolio value
  def tweet_portfolio_value (player, value)
    message = "Your current portfolio is valued at $" + comma_numbers(value) + " as of the closing bell on " + Time.now.strftime("%b %d, %Y")
    
    begin
      Twitter.direct_message_create(check_player_at(player), message)
    rescue
      puts $!.message
    end
  end
  
  #if the tweet was formatted incorrectly
  def tweet_invalid_request (player)
    player = check_player_at(player)
    
    message = player + " Invalid Trade Request. Format is as follows: BUY (optional handle) 100 CXO 10.50"
    
    begin
      Twitter.update(message)
    rescue => e
      puts e.message
    end
    
  end
  
  #entry point for above methods
  def tweet_error(err)
    messaging_player = check_player_at(@messaging_player)
    
    message = err.message
    
    begin
      case message
      when "PlayerNotFoundError"
        Twitter.update(messaging_player + " The player, " + err.player + " was not found")
      when "CompanyNotFoundError"
        Twitter.update(messaging_player + " That company, " + err.company.symbol + " does not exist")
      when "InsufficientCashError"
        self.tweet_insufficient_funds(err.player.username)
      when "InsufficientStockError"
        self.tweet_lack_of_shares(err.player.username)
      end
    rescue
      puts $!.message
    end
  end  
end
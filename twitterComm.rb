require 'twitter'
require 'functions'

class TWITTERCOMM
  
  def getMentions(since_id = 45969646003822591, count = 50)
    #get all mentions since the first tweet mention...change when the game starts
    mentions = Twitter.mentions(:count => count, :since_id => since_id)

    transactions = mentions.collect do |mention|
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
        :buyer => buyer,
        :seller => seller,
        :quantity => quantity.to_i,
        :company => company,
        :price => price.to_f
      }
    end
    
    return transactions
  end
  
  #if the seller doesn't have enough shares in the company
  def send_lack_of_shares_tweet( player, company_name )
    message = "Sorry " + check_player_at(player) + ", you don't have enough shares in " + company_name + " to complete the transaction"
    
    begin
      Twitter.update(message)
    rescue => e
      puts e.message
    end
    
  end  
  
  #if the buyer doesn't have enough cash
  def send_insufficient_funds( player )
    player = check_player_at(player)
    message = "Sorry " + player + ", you don't have enough funds to complete the transaction"
    
    begin
      Twitter.direct_message_create(player, message)
    rescue => e
      puts e.message
    end
  end
  
  def send_portfolio_value_tweet(player, value)
    message = "Your current portfolio is valued at $" + comma_numbers(value) + " as of the closing bell on " + Time.now.strftime("%b %d, %Y")
    
    begin
      Twitter.direct_message_create(check_player_at(player), message)
    rescue => e
      puts e.message
    end
  end
  
  
end
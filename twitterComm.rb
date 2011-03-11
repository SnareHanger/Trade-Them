require 'twitter'
require_relative 'functions'

class TWITTERCOMM
  
  def getMentions
    #get all mentions since the first tweet mention...change when the game starts
    mentions = Twitter.mentions(:count => 50, :since_id => 45969646003822591)

    transactions = Array.new

    mentions.each do |mention|
      mention.text.downcase!
      theMention = mention.text

      #strip the @tradethem handle
      theMention["@tradethem "] = ""

      #get the user the mention came from
      from = "@" + mention.user.screen_name
      to = ""

      #if the mention has another user's name in it then set the to var otherwise leave it
      if theMention.include? "@" then
        type, to, numberOfShares, company, price = mention.text.split(' ')
      else
        type, numberOfShares, company, price = mention.text.split(' ')
      end

      #if BUY the buyer is the from var
      if type=="buy" then
        buyer = from
        if !to.empty? then
          seller = to
        end
      end

      #if SELL the buyer is the from var
      if type=="sell" then
        seller = from
        if !to.empty? then
          buyer = to
        end
      end 

      #add to transactions array
      transactions.push({:type => type, :buyer => buyer, :seller => seller, :numberOfShares => numberOfShares.to_i, :company => company, :price => price.to_f, :executed => false, :transaction_date => Time.new})  
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
#require 'rubygems'
require 'twitter'

#@TradeThem feed api setup
Twitter.configure do |config|
    config.consumer_key = "dYJIgEYjQglnvNrNoU8Bxw"
    config.consumer_secret = "jSoAzpVVMMc38PTlE4ovEXZBNkgdXR5QQ3Nz9HgWnN4"
    config.oauth_token = "260496289-kWGPqENvz26QZsGQRT7EpIiQTj4lNJO9dS3qhat2"
    config.oauth_token_secret = "fGYK8sMjzzJrmmXt9wKjd3LxLwq0weUiSCUuBYWk"
end

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

puts transactions

 
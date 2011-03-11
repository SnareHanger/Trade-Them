require 'rubygems'
require 'twitter'
require_relative "twitterComm.rb"

twitComm = TWITTERCOMM.new

#@TradeThem feed api setup
Twitter.configure do |config|
    config.consumer_key = "dYJIgEYjQglnvNrNoU8Bxw"
    config.consumer_secret = "jSoAzpVVMMc38PTlE4ovEXZBNkgdXR5QQ3Nz9HgWnN4"
    config.oauth_token = "260496289-kWGPqENvz26QZsGQRT7EpIiQTj4lNJO9dS3qhat2"
    config.oauth_token_secret = "fGYK8sMjzzJrmmXt9wKjd3LxLwq0weUiSCUuBYWk"
end

puts twitComm.getMentions

 
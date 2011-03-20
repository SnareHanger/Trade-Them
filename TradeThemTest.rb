#Unit test for TradeThem
require 'mocha'
require_relative 'TradeThem'

class Player
  attr_accessor :screen_name
  
  def initialize(n)
    self.screen_name = n
    self
  end
end

class FakeTweet
  attr_accessor :text
  attr_accessor :user
  def initialize(u, txt)
    @user = Player.new(u)
    @text = txt
  end
end




mentions1 = []
mentions1 << FakeTweet.new("daniel", "@TradeThem BUY 100 CAX 5.00")
mentions1 << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 CAX 5.00")

mentions2 = []
mentions2 << FakeTweet.new("daniel", "@TradeThem BUY 100 CBX 5.00")
mentions2 << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 CBX 5.50")
mentions2 << FakeTweet.new("daniel", "@TradeThem BUY 100 @mike CBX 5.30")
mentions2 << FakeTweet.new("mike", "@TradeThem SELL @daniel CBX 5.30")
                            
mentions3 = []              
mentions3 << FakeTweet.new("daniel", "@TradeThem BUY 100 CBX 5.00")
mentions3 << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 CBX 5.50")
mentions3 << FakeTweet.new("daniel", "@TradeThem BUY @mike 100 CBX 5.30")
mentions3 << FakeTweet.new("voxels", "@TradeThem SELL @daniel 100 CBX 5.20")
mentions3 << FakeTweet.new("daniel", "@TradeThem BUY @voxels 100 CBX 5.20")

# Twitter.stubs(:configure)



Transaction.delete_all
Twitter.stubs(:mentions).returns(mentions1)
tt = TradeThem.new
tt.configure
tt.main
#at this point, database should be in a certain state
#e.g. Transaction.count should 2

Transaction.delete_all
Twitter.stubs(:mentions).returns(mentions2)
tt = TradeThem.new
tt.configure
tt.main
#at this point, database should be in a certain state

Transaction.delete_all
Twitter.stubs(:mentions).returns(mentions3)
tt = TradeThem.new
tt.configure
tt.main
#at this point, database should be in a certain state

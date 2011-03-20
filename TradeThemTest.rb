#Unit tests for TradeThem
require 'test/unit'
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

class FakeMentions
  def self.mentions1
    a = []
    a << FakeTweet.new("@daniel", "@TradeThem BUY 100 CAX 5.00")
    a << FakeTweet.new("@mike", "@TradeThem SELL @daniel 100 CAX 5.00")
    return a
  end

  def self.mentions2
    a = []
    a << FakeTweet.new("@daniel", "@TradeThem BUY 100 CBX 5.00")
    a << FakeTweet.new("@mike", "@TradeThem SELL @daniel 100 CBX 5.50")
    a << FakeTweet.new("@daniel", "@TradeThem BUY 100 @mike CBX 5.30")
    a << FakeTweet.new("@mike", "@TradeThem SELL @daniel CBX 5.30")
    return a
  end
                            
  def self.mentions3
    a = []
    a << FakeTweet.new("@daniel", "@TradeThem BUY 100 CBX 5.00")
    a << FakeTweet.new("@mike", "@TradeThem SELL @daniel 100 CBX 5.50")
    a << FakeTweet.new("@daniel", "@TradeThem BUY @mike 100 CBX 5.30")
    a << FakeTweet.new("@voxels", "@TradeThem SELL @daniel 100 CBX 5.20")
    a << FakeTweet.new("@daniel", "@TradeThem BUY @voxels 100 CBX 5.20")
    return a
  end
end
class TradeThemTest < Test::Unit::TestCase
  def setup
     #seed data
    `cp db/tradetheminit.sqlite3 db/tradethemtest.sqlite3`

    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => "db/tradethemtest.sqlite3"
    )

    Twitter.stubs(:configure)
    Twitter.stubs(:direct_message_create)
    def Twitter.update(message); puts message; end

    @tt = TradeThem.new
    @tt.configure

    Transaction.delete_all
  end

  def test1
    Twitter.stubs(:mentions).returns(FakeMentions.mentions1)
    @tt.main
    #at this point, database should be in a certain state
    #e.g. Transaction.count should 2
  end

  def test2
    Twitter.stubs(:mentions).returns(FakeMentions.mentions2)
    @tt.main
  end

  def test3
    Twitter.stubs(:mentions).returns(FakeMentions.mentions3)
    @tt.main
  end
end

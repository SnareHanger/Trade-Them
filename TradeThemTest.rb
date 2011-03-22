#Unit tests for TradeThem
require 'test/unit'
require 'mocha'
require_relative 'TradeThem'

class FakeTwitterUser
  attr_accessor :screen_name
  
  def initialize(n)
    self.screen_name = n
    self
  end
end

class FakeTweet
  attr_accessor :text, :user
  def initialize(u, txt)
    @user = FakeTwitterUser.new(u)
    @text = txt
  end
end

class FakeMentions
  def self.mentions1
    a = []
    a << FakeTweet.new("daniel", "@TradeThem BUY 100 COA 5.00")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 COA 5.00")
    return a
  end

  def self.mentions2
    a = []
    a << FakeTweet.new("daniel", "@TradeThem BUY 100 COB 5.00")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 COB 5.50")
    a << FakeTweet.new("daniel", "@TradeThem BUY 100 @mike COB 5.30")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel COB 5.30")
    return a
  end
                            
  def self.mentions3
    a = []
    a << FakeTweet.new("daniel", "@TradeThem BUY 100 COB 5.00")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 COB 5.50")
    a << FakeTweet.new("daniel", "@TradeThem BUY @mike 100 COB 5.30")
    a << FakeTweet.new("voxels", "@TradeThem SELL @daniel 100 COB 5.20")
    a << FakeTweet.new("daniel", "@TradeThem BUY @voxels 100 COB 5.20")
    return a
  end
end

class TradeThemTest < Test::Unit::TestCase
  def setup
     #seed data
    `cp db/tradetheminit.sqlite3 db/tradethemtest.sqlite3`

    #make sure to use Test data
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => "db/tradethemtest.sqlite3"
    )
    ActiveRecord::Base.logger = Logger.new("log/test.txt")

    Twitter.stubs(:configure)
    Twitter.stubs(:direct_message_create)
    def Twitter.update(message); puts "[TWEET] #{message}"; end #:-)

    @tt = TradeThem.new
    @tt.configure

    Transaction.delete_all
  end

  def test1
    Twitter.expects(:mentions).returns(FakeMentions.mentions1)
    #assert_not_nil Twitter.mentions

    p0 = FakeMentions.mentions1[0].user.screen_name
    p1 = FakeMentions.mentions1[1].user.screen_name

    player0 = Player.find_by_username("@"+p0)
    player1 = Player.find_by_username("@"+p1)

    assert_not_nil player0, "Could not find Player: #{p0}"
    assert_not_nil player1, "Could not find Player: #{p1}"

    assert_equal 40_000, player0.cash.to_i
    assert_equal 40_000, player1.cash.to_i

    @tt.main

    player0.reload
    player1.reload
    assert_equal 1, Transaction.count, "Transaction.count"
    t = Transaction.first
    assert t.completed?, "Transaction.first NOT completed (#{t.inspect})"
    assert_equal 40_500, player1.cash.to_i
    assert_equal 39_500, player0.cash.to_i
  end

  def Xtest2
    Twitter.expects(:mentions).returns(FakeMentions.mentions2)
    @tt.main
  end

  def Xtest3
    Twitter.expects(:mentions).returns(FakeMentions.mentions3)
    @tt.main
  end
end

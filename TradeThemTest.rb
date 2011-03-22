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
  #simple transaction
  def self.mentions1
    a = []
    a << FakeTweet.new("daniel", "@TradeThem BUY 100 COA 5.00")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 COA 5.00")
    return a
  end

  #price negotiation
  def self.mentions2
    a = []
    a << FakeTweet.new("daniel", "@TradeThem BUY 100 COB 5.00")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 COB 5.50")
    a << FakeTweet.new("daniel", "@TradeThem BUY @mike 100 COB 5.30")
    a << FakeTweet.new("mike", "@TradeThem SELL @daniel 100 COB 5.30")
    return a
  end

  #negotiate and grab
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

    assert_equal 100, player0.shares_in("COA").quantity
    assert_equal 100, player1.shares_in("COA").quantity

    @tt.main

    assert_equal 1, Transaction.count, "Transaction.count"
    t = Transaction.last
    assert t.completed?, "Transaction.last NOT completed (#{t.inspect})"

    player0.reload
    player1.reload
    assert_equal 39_500, player0.cash.to_i
    assert_equal 40_500, player1.cash.to_i

    assert_equal 200, player0.shares_in("COA").quantity
    assert_equal   0, player1.shares_in("COA").quantity
  end

  def test2
    Twitter.expects(:mentions).returns(FakeMentions.mentions2)

    p0 = FakeMentions.mentions2[0].user.screen_name
    p1 = FakeMentions.mentions2[1].user.screen_name

    player0 = Player.find_by_username("@"+p0)
    player1 = Player.find_by_username("@"+p1)

    assert_not_nil player0, "Could not find Player: #{p0}"
    assert_not_nil player1, "Could not find Player: #{p1}"

    assert_equal 40_000, player0.cash.to_i
    assert_equal 40_000, player1.cash.to_i

    assert_equal 100, player0.shares_in("COB").quantity
    assert_equal 100, player1.shares_in("COB").quantity

    @tt.main

    assert_equal 3, Transaction.count, "Transaction.count"
    t = Transaction.last
    assert t.completed?, "Transaction.last NOT completed (#{t.inspect})"

    player0.reload
    player1.reload
    assert_equal 39_470, player0.cash.to_i
    assert_equal 40_530, player1.cash.to_i

    assert_equal 200, player0.shares_in("COB").quantity
    assert_equal   0, player1.shares_in("COB").quantity
  end

  def test3
    Twitter.expects(:mentions).returns(FakeMentions.mentions3)

    p0 = FakeMentions.mentions3[0].user.screen_name
    p1 = FakeMentions.mentions3[1].user.screen_name
    p2 = FakeMentions.mentions3[3].user.screen_name
    assert_not_equal p0, p1
    assert_not_equal p0, p2
    assert_not_equal p1, p2

    player0 = Player.find_by_username("@"+p0)
    player1 = Player.find_by_username("@"+p1)
    player2 = Player.find_by_username("@"+p2)

    assert_not_nil player0, "Could not find Player: #{p0}"
    assert_not_nil player1, "Could not find Player: #{p1}"
    assert_not_nil player2, "Could not find Player: #{p2}"

    assert_equal 40_000, player0.cash.to_i
    assert_equal 40_000, player1.cash.to_i
    assert_equal 40_000, player2.cash.to_i

    assert_equal 100, player0.shares_in("COB").quantity
    assert_equal 100, player1.shares_in("COB").quantity
    assert_equal 100, player2.shares_in("COB").quantity

    @tt.main

    assert_equal 4, Transaction.count, "Transaction.count"
    t = Transaction.last
    assert t.completed?, "Transaction.last NOT completed (#{t.inspect})"

    player0.reload
    player1.reload
    player2.reload

    assert_equal 39_480, player0.cash.to_i
    assert_equal 40_000, player1.cash.to_i
    assert_equal 40_520, player2.cash.to_i
  end
end

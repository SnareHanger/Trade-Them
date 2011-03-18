#Unit test for TradeThem
require_relative 'TradeThem'
require 'mocha'

class FakeTweet
  attr :text
  attr :user
  def initialize(u, txt); self.user = User.new(u); self.text = txt; end
end
class User; attr :screen_name; end

mentions1 = []
mentions1 << FakeTweet.new("@daniel", "BUY please")
mentions1 << FakeTweet.new("@mike", "SELL @daniel please")

Twitter.stubs(:configure)


Transaction.delete_all
Twitter.stubs(:mentions).returns(mentions1)
TradeThem.main()
#at this point, database should be in a certain state
#e.g. Transaction.count should 2

Transaction.delete_all
Twitter.stubs(:mentions).returns(mentions2)
TradeThem.main()
#at this point, database should be in a certain state

Transaction.delete_all
Twitter.stubs(:mentions).returns(mentions3)
TradeThem.main()
#at this point, database should be in a certain state

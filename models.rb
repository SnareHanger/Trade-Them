require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :dbfile => "db/tradethem.sqlite3"
)

class Player < ActiveRecord::Base
  has_many :portfolio_items
  has_many :stocks, :through => :portfolio_items

  validates_presence_of :username, :cash
  validates_numericality_of :cash
end

class Stock < ActiveRecord::Base
  validates_presence_of :symbol, :price
  validates_numericality_of :price
end

class PortfolioItem < ActiveRecord::Base
  validates_presence_of :player_id, :stock_id, :purchase_price, :quantity
end

class Transaction < ActiveRecord::Base
  belongs_to :stock
  belongs_to :buyer, :class => 'Player'
  belongs_to :seller, :class => 'Player'

  validates_presence_of :price, :quantity

  scope :executed, where(:executed => true)
  scope :not_executed, where(:executed => false)
  scope :active, where("expiration_date < ?", Time.now)

  def execute!
    self.executed = true
    self.save!

    #TODO: Update stock price
    #Update portfolio of buyer AND seller
  end
end

class BuyTransaction < Transaction; end
class SellTransaction < Transaction; end

#Player id, cash
#PortfolioItem player_id, stock_id, purchase_price, quantity
#Stock code price total_shares

#Stock.find(:code => "foo")


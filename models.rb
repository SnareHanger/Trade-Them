require 'active_record'
require_relative 'exceptions'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/tradethem.sqlite3"
)

class Player < ActiveRecord::Base
  has_many :portfolio_items
  has_many :companies, :through => :portfolio_items

  validates_presence_of :username, :cash
  validates_numericality_of :cash

  def buy!(tx)
    self.cash -= tx.amount
    raise InsufficentCashError.new(self, tx) if self.cash < 0 #custom exception

    stock = self.portfolio_items.select {|i| i.company_id == tx.company_id}.first

    if stock.nil?
      #new stock in portfolio
      self.portfolio_items.create!(:company_id => tx.company_id, :quantity => tx.quantity)
    else
      #add to portfolio
      stock.quantity += tx.quantity
      stock.save!
    end

    self.save!
  end

  def sell!(tx)
    #remove from portfolio
    stock = self.portfolio_items.select {|i| i.company_id == tx.company_id}.first

    #can't sell what you don't have
    raise InsufficientStockError.new(self, tx) if stock.nil?
    raise InsufficientStockError.new(self, tx) if stock.quantity < tx.quantity

    stock.quantity -= tx.quantity
    stock.save!

    self.cash += tx.amount
    self.save!
  end
end

class Company < ActiveRecord::Base
  validates_presence_of :symbol, :price
  validates_uniqueness_of :symbol
  validates_numericality_of :price
end

#purchase_price doesn't work for multiple purchases!!!
class PortfolioItem < ActiveRecord::Base
  validates_presence_of :player_id, :company_id, :quantity
  validates_uniqueness_of :company_id, :scope => :player_id
end

class Transaction < ActiveRecord::Base
  belongs_to :company
  belongs_to :buyer, :class_name => 'Player'
  belongs_to :seller, :class_name => 'Player'

  validates_presence_of :company, :price, :quantity

  scope :completed, where(:completed => true)
  scope :not_completed, where(:completed => false)
  scope :active, where("expiration_date < ?", Time.now)

  def value
    self.price * self.quantity
  end

  def complete!
    ActiveRecord::Base.transaction do
      #Update portfolios of buyer AND seller
      self.buyer.buy!(self)
      self.seller.sell!(self)

      #update company price
      self.company.update_attributes! :price => self.price

      #mark transaction as executed
      self.update_attributes! :completed => true
    end
  end
end

class BuyTransaction < Transaction; end
class SellTransaction < Transaction; end

#ADD Company total_shares (?)


require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :dbfile => "db/tradethem.sqlite3"
)

#Player id, cash
#PortfolioItem player_id, stock_id, purchase_price, quantity
#Stock code price total_shares

#Stock.find(:code => "foo")


class CreatePortfolioItems < ActiveRecord::Migration
  def self.up
    create_table :portfolio_items do |t|
      t.integer :player_id, :null => false
      t.integer :stock_id, :null => false
      t.decimal :purchase_price, :null => false
      t.integer :quantity, :null => false
      t.timestamps!
    end
  end
 
  def self.down
    drop_table :portfolio_items
  end
end

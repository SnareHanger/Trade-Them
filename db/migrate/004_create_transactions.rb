class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :type, :null => false
      t.integer :buyer_id, :null => false
      t.integer :seller_id, :null => false
      t.integer :stock_id, :null => false
      t.decimal :price, :null => false
      t.integer :quantity, :null => false
      t.boolean :executed, :default => false
      t.datetime :expiration_date
    end
  end
 
  def self.down
    drop_table :transactions
  end
end

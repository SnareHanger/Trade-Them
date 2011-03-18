class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :type, :null => false
      t.integer :buyer_id, :null => false
      t.integer :seller_id, :null => false
      t.integer :stock_id, :null => false
      t.decimal :price, :null => false
      t.integer :quantity, :null => false
      t.boolean :completed, :default => false
      t.datetime :expiration_date
      t.timestamps
    end

    add_index :transactions, [:type, :completed, :stock_id, :price, :quantity, :expiration_date, :buyer_id], :name => 'tx1'
    add_index :transactions,[:type, :completed, :stock_id, :price, :quantity, :expiration_date, :seller_id], :name => 'tx2'
  end
 
  def self.down
    drop_table :transactions
  end
end

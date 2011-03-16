class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :symbol, :null => false
      t.decimal :price
    end
    add_index :companies, :symbol
  end
 
  def self.down
    drop_table :companies
  end
end

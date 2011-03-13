class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :username, :null => false
      t.integer :cash
    end
  end
 
  def self.down
    drop_table :players
  end
end

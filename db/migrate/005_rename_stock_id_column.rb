class RenameStockIdColumn < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :stock_id, :company_id
  end

  def self.down
    rename_column :transactions, :company_id, :stock_id
  end
end

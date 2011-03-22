class RenameStockIdColumn2 < ActiveRecord::Migration
  def self.up
    rename_column :portfolio_items, :stock_id, :company_id
  end

  def self.down
    rename_column :portfolio_items, :company_id, :stock_id
  end
end

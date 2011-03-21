require 'csv'



def comma_numbers(number, delimiter = ',')
  number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
end

#check for @ symbol
def check_player_at(player)
  if !player.index("@") then
    player.insert 0, "@"
  end
  
  return player
end

#wants a hash of company_id, current_price
def write_stock_price_file(stock_prices)
  CSV.open("/Users/michaelcohen/Development/Ruby/Trade-Them/Processing/tradethem/data/stockprices.csv","ab") do |csv|
    csv << [stock_prices[1], stock_prices[2], stock_prices[3], stock_prices[4]]
  end
end

def write_assets_file(player)
  csv_data = CSV.open("/Users/michaelcohen/Development/Ruby/Trade-Them/Processing/tradethem/data/assets.csv","r")
  headers = csv_data.shift.map {|i| i.to_s }
  
  #creates arrays for each row of data
  string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
  
  #creates a hash combining headers as keys and string_data for the values
  array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  
  playerPortfolio = PortfolioItem.find_by_player_id(player.id)
  
  array_of_hashes.each do |p|
    if(p["handle"] == player.username)
      p["COA"] = playerPortfolio.find_by_player_id_and_stock_id(player.id, "COA").quantity
      p["COB"] = playerPortfolio.find_by_player_id_and_stock_id(player.id, "COB").quantity
      p["COC"] = playerPortfolio.find_by_player_id_and_stock_id(player.id, "COC").quantity
      p["COD"] = playerPortfolio.find_by_player_id_and_stock_id(player.id, "COD").quantity
      p["CASH"] = player.cash
    end
  end
  
  CSV.open("/Users/michaelcohen/Development/Ruby/Trade-Them/Processing/tradethem/data/assets.csv", "wb") do |csv|
    csv << ["handle","COA","COB","COC","COD"] 
    array_of_hashes.each do |p|
      csv << [p["handle"], p["COA"], p["COB"], p["COC"], p["COD"], p["CASH"]]      
    end
  end
  
  
end

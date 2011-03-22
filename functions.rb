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
  CSV.open("Processing/tradethem/data/stockprices.csv","a") do |csv|
    csv << [stock_prices[0].price.to_s, stock_prices[1].price.to_s, stock_prices[2].price.to_s, stock_prices[3].price.to_s]
  end
end

def write_assets_file(players)
  CSV.open("Processing/tradethem/data/assets.csv", "w") do |csv|
    csv << ["handle","COA","COB","COC","COD","CASH"] 
    cash = 0.00
    coa, cob, coc, cod = 0
    username = ""
    players.each do |p|
      puts p.inspect
      portfolioItems = PortfolioItem.find_all_by_player_id(p.id)
      portfolioItems.each do |pi|
        case pi.company_id
          when 1
            coa = pi.quantity
          when 2
            cob = pi.quantity
          when 3  
            coc = pi.quantity
          when 4  
            cod = pi.quantity
        end
      end
      cash = p.cash 
      username = p.username
      csv << [username, coa, cob, coc, cod, cash]
    end
  end 
end

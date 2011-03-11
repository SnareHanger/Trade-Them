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
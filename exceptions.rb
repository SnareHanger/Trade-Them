#some custom exceptions
class InsufficentCashError < StandardError
  attr_reader :player, :tx
  def initialize(player, tx)
    @player, @tx = player, tx
  end
end

class InsufficientStockError < StandardError
  attr_reader :player, :tx
  def initialize(player, tx)
    @player, @tx = player, tx
  end
end

class PlayerNotFoundError < StandardError
  attr_reader :player
  def initialize(player)
    @player = player
  end
end

class CompanyNotFoundError < StandardError
  attr_reader :company
  def initialize(company)
    @company = company
  end
end

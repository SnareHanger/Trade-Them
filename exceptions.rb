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

class CompanyNotFoundError < StandardError
  attr_reader :company
  def initialize(company)
    @company = company
  end
end

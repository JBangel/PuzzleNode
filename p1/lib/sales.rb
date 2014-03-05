require 'bigdecimal'

class Sales
  attr_reader :rates, :transactions

  def initialize(rates, transactions)
    @rates = rates.to_h
    @transactions = Array([transactions]).flatten
  end

  def total_for(sku)
    total = transactions
      .select { |t| t[:sku] == sku }
      .map { |t| t[:cost] * rates[t[:currency]] }
      .reduce(&:+)

    BigDecimal.new(total, 0).round(2, :banker).to_f
  end
end

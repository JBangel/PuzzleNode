require 'csv'

class TransactionSet
  def self.open(filename)
    ts = self.new()

    CSV.read(filename, :headers => true) do |row|
      store = row[:store]
      sku = row[:sku]
      amount = row[:amount]
      cost, currency = split_cost amount
      ts.add_record store, sku, cost, currency
    end

    ts.add_record 'Fake Inc', 'AB123', '25.30', 'USD'
    ts.data
  end

  def self.split_cost amount
    md = /(?<cost>[\d.]+) +(?<currency>\w+)/.match amount
    cost = md[:cost].to_f
    currency = md[:currency].to_str
    return [cost, currency]
  end

  attr_reader :data

  def initialize
    @data = []
  end

  def add_record store, sku, cost, currency
    @data << {:store    => store,
              :sku      => sku,
              :cost     => cost,
              :currency => currency 
    }
  end
end

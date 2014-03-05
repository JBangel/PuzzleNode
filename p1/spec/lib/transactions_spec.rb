require 'transactionset'

describe TransactionSet do
  it 'returns an array of hashes' do
    ts = TransactionSet.open('spec/data/SAMPLE_TRANS.csv')
    expect(ts.respond_to? :[]).to eql true
    expect(ts.respond_to? :first).to eql true
    expect(ts.first.is_a? Hash).to eql true
  end

  it 'can split the cost' do
    cost, currency = TransactionSet.split_cost( '135.73 USD' )
    expect(cost).to eql 135.73
    expect(currency).to eql 'USD'
  end
end

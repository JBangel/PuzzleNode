require 'sales'

describe Sales do
  let(:r)  { {'USD' => 1} }
  let(:t1) { {:store => 'Fake Inc', :sku => 'DM1182', :cost => 134.223, :currency => 'USD'} }
  let(:t2) { {:store => 'Fake Inc', :sku => 'DM1182', :cost => 14.006, :currency => 'USD'} }

  it 'should return the correct result from a single element' do
    expect(Sales.new(r, t1).total_for('DM1182')).to eq 134.22
  end

  it 'should return the correct result from multiple elements' do
    expect(Sales.new(r, [t1] + [t2]).total_for('DM1182')).to eq 148.23
  end
end

require 'nokogiri'
require 'bigdecimal'

class Rates
  def self.open(filename)
    rates = self.new

    doc = Nokogiri::XML(File.open(filename))
    all_rates = doc.xpath('//rate')
    all_rates.each do |rate|
      from = rate.at_xpath('from').text
      to = rate.at_xpath('to').text
      conversion = rate.at_xpath('conversion').text
      rates.add_record from, to, conversion
    end

    rates.to_h
  end

  def initialize
    @basedata = []
    @values = {}
  end

  def [](key)
    skey = key.to_sym
    return 1.0 if skey == :USD
    return values[skey] if values.has_key? skey

    values[skey] = find_conversion skey, :USD
    puts "Generated Rate (:#{skey} -> :USD) = #{values[skey]}"
    values[skey]
  end

  def to_h
    self
  end

  def add_record from, to, conversion
    @basedata << { :from => from.to_sym, :to => to.to_sym, :conversion => conversion.to_f }
  end

  private

  attr_accessor :values
  attr_reader   :basedata

  def find_conversion fkey, tkey, not_from = []
    fr = basedata.find { |bdr| bdr[:from] == fkey && bdr[:to] == tkey }
    if fr
      return fr.fetch(:conversion)
    end

    tnf = not_from + [tkey]

    match_next_level = basedata.find_all { |bdr| bdr[:to] == tkey }.map { |bdr| bdr.fetch :from }

    checklist = basedata.find_all { |bdr| match_next_level.include? bdr[:to] }
    checklist.reject! { |cr| tnf.include? cr[:from] }

    nextlevel = checklist.find do |cr|
      find_conversion( fkey, cr[:to], tnf )
    end

    if nextlevel
      thisf = nextlevel[:to]
      thist = tkey
      thatf = fkey
      thatt = nextlevel[:to]
      thislevel = basedata.find { |bdr| bdr[:from] == thisf && bdr[:to] == thist }
      thatlevel = basedata.find { |bdr| bdr[:from] == thatf && bdr[:to] == thatt }
      newrate = thislevel[:conversion] * thatlevel[:conversion]
      @basedata << { :from => fkey, :to => tkey, :conversion => newrate }
      return newrate
    end

    puts "PROBLEM!!!"
    return :NoRateFound
  end
end


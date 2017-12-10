class Memory
  attr_reader :banks

  def initialize(banks)
    @banks = banks
  end

  def redistribute
    index = banks.find_index(banks.max)
    value = banks[index]
    banks[index] = 0
    value.times do |idx|
      banks[(index + idx + 1) % banks.length] += 1
    end
  end
end

seen = []
memory = Memory.new(DATA.each_line.first.chomp.split("\t").map(&:to_i))
while (seen == seen.uniq) do
  seen << memory.banks.hash
  memory.redistribute
end
puts seen.length - seen.find_index(seen.last) - 1

__END__
5	1	10	0	1	7	13	14	3	12	8	10	7	12	0	6

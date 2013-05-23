#!/usr/bin/ruby

require 'rubygems'
require 'trollop'

$opts = Trollop::options do
  opt :keys, "keyset size", :type => :int, :required => true
  opt :value_size, "size of values", :type => :int, :default => 1024
  opt :value, "value", :type => :string
  opt :random_value
  opt :shuffle_keys
end

def generate_value
  @value ||= if $opts[:random_value]
               srand(0x34343434)
               size = $opts[:value_size]

               (size*3).times {rand(256)}

               value = [size.times.map {rand(256).chr}.join('')].pack('m').gsub("\n",'')
             else
               begin
                 "a" * $opts[:value_size]
               end
             end
end

# value = generate_value()

# (0...$opts[:keys]).each do |i|
#   print("%08d %s\n" % [i, value])
# end

def gcd(a,b)
  return gcd(b, a) if a > b
  return b if a == 0
  gcd(b % a, a)
end

# p gcd(3, 7)

# p gcd(2, 3)

# p gcd(2, 1)

# p gcd(44, 44)

# p gcd(10, 6)

# p gcd(100, 75)

# exit

def find_increment(keys)
  initial = keys * 7 / 9
  while gcd(keys, initial) != 1
    initial -= 1
  end
  return initial
end

def run!
  keys = $opts[:keys]
  i = keys-1

  value = $opts[:value] || generate_value

  STDERR.puts "value is: #{value.inspect}"

  suffix = " #{value}\n"

  increment = 1
  if $opts[:shuffle_keys]
    increment = find_increment(keys)
  end

  c = i
  while c >= 0
    STDOUT << sprintf("%08d", i) << suffix
    i = (i - increment) % keys
    c -= 1
  end
end

run!

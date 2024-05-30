#!/usr/bin/env ruby

require 'optparse'

DEFAULT_OPTIONS = {
  verbose: false,
  invalid: false,
  nodes: 2,
  labels: %w[a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9],
  leaf_percent: 5, # 0-9 percentage of leafs in the file.
  parents_children: 2, # how many children - at most - a parent can have. when labels are finished, stops.
  depth: 2,
}

@options = DEFAULT_OPTIONS
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--verbose", "Run verbosely") do |v|
    @options[:verbose] = true
  end

  opts.on("-i", "--invalid", "If the resulting file should be invalid") do
    @options[:invalid] = true
  end

  opts.on("--nodes SIZE", "size of the file. The higher the param, the bigger the file.") do |v|
    @options[:nodes] = v
  end

  opts.on("--labels LABELS", "Comma separated labels e.g: a,b,c,d,e,something,else ") do |v|
    @options[:labels] = v.to_s.split(",").map{|str| str.gsub(/\s+/, "") }

    raise "labels are empty." if @options[:labels].length == 0
  end

  opts.on("--leaf-percent VALUE") do |v|
    @options[:leaf_percent] = v.to_i
  end

  opts.on("--parents_children VALUE") do |v|
    @options[:parents_children] = v.to_i
    raise "Must be a number > 0" unless v.to_i > 0
  end

  opts.on("--depth VALUE") do |v|
    @options[:depth] = v.to_i

    raise "must be a number > 0" unless v.to_i > 0
  end
end.parse!

puts "running with @options " + @options.to_s if @options[:verbose]

def add_some_spaces(str)
  raise unless str.class.to_s != "String"

  # TODO add some spaces
  str
end

def write(*things_to_write)
  if @options[:invalid] && Random.rand(1..100) > 98
    print "-"
    @options[:invalid] = false
  end

  things_to_write.each do |item|
    if @options[:invalid] && Random.rand(1..100) > 95 && item.gsub(/\s+/, '') != ''
      @options[:invalid] = false
      next
    end

    print item
    print " "
  end
end

def gen_weight
  num = Random.rand(1..99.1).to_s
  num[0..num.index(".")+2]
end

# def write_leaf
#   write gen_weight, "children", "=", "{", "}", "\n"
# end

@depth = 0

# Writes a level of 
def write_level
  # return if @depth >= @options[:depth]

  @depth += 1
  count = 0
  while(count < @options[:parents_children] && count < @options[:labels].count) do
    label = @options[:labels][count]

    will_be_leaf = count == 0 || (Random.rand(10) > @options[:leaf_percent].to_i)
    if will_be_leaf
      write (" " * @depth), label, gen_weight, "children", "=", "{", "}"
    else
      next if @depth >= @options[:depth]
      write (" " * @depth), label, "children", "=", "{"
      write_level
      write "}"
    end

    if count + 1 < @options[:parents_children] && count + 1 < @options[:labels].count
      write ","
    end

    write "\n"

    count += 1
  end
end

write "children = {\n"

write_level

write "}", "\n\n" unless @options[:invalid]


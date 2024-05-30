#!/usr/bin/env ruby

`make clean`
`make build/char_valid_syntax`
`rm -rf /tmp/trie_invalid_char.tr`

100.times do |i|
  puts "Valid char test #{i + 1}/100"

  `ruby scripts/generate_fixture.rb > /tmp/trie_invalid_char.tr && ./build/char_valid_syntax < /tmp/trie_invalid_char.tr`
  exit($?.exitstatus) if $?&.exitstatus != 0
end

`make build/char_invalid_syntax`

100.times do |i|
  puts "Invalid char test #{i + 1}/100"

  `ruby scripts/generate_fixture.rb --invalid > /tmp/trie_invalid_char.tr && ./build/char_invalid_syntax < /tmp/trie_invalid_char.tr`
  exit($?.exitstatus) if $?&.exitstatus != 0
end

100.times do |i|
  puts "Valid char large test #{i + 1}/100"

  `ruby scripts/generate_fixture.rb --depth=100 --nodes=100 --parents-children=100 > /tmp/trie_invalid_char.tr && ./build/char_valid_syntax < /tmp/trie_invalid_char.tr`
  exit($?.exitstatus) if $?&.exitstatus != 0
end
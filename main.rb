# frozen_string_literal: true

require_relative 'word_counter'
require_relative 'processor'

word_counter = WordCounter.new # results holder
processor = Processor.new(word_counter) # main processing logic
INSTRUCTIONS_MSG = "Please enter a command in the form: TYPE VALUE SOURCE
where valid TYPE values are: url\\string\\file
or \"quit\" to exit or \"print\" to print results
Example commands:
file my test.txt
string banana apple banana orange
url example https://www.example.com/"


def print(map)
  puts('######################')
  map.each do |(word, count)|
    puts("#{word} : #{count}")
  end
  puts('######################')
end

puts(INSTRUCTIONS_MSG)

# main read command loop
loop do
  # read input from cmd
  command = gets.chomp
  break if command == 'quit'

  if command == 'print'
    copy = word_counter.get
    print(copy)
    next
  end
  # keep reading commands unless 'quit' command received
  puts(processor.process_command(command))

  puts('Enter next command')
end

word_counter.print

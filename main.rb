# frozen_string_literal: true

require_relative 'word_counter'
require_relative 'processor'

word_counter = WordCounter.new # results holder
processor = Processor.new(word_counter) # main processing logic

INSTRUCTIONS_MSG = "##################################################
Please enter a command in the form: TYPE SOURCE
where valid TYPE values are: url\\string\\file
or \"quit\" to exit or \"print WORD\" to print results
Example commands:
file test.txt
string apple banana orange
url https://www.example.com/
print my
##################################################"


puts(INSTRUCTIONS_MSG)

# main read command loop
# I've assumed that a single program serving both purposes is fine
loop do
  # read input from cmd
  command = gets.chomp
  break if command == 'quit'

  # keep reading commands unless 'quit' command received
  puts(processor.process_command(command))
  puts('Enter next command')
end

puts('Terminating')
word_counter.clean
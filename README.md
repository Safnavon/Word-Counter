# Lemonade

## Ruby v2.6.4

To run program: "ruby main.rb"

Program receives a command in the form: TYPE SOURCE
and accumulates all word occurrences in SOURCE (using disk to support large input)

can also print via "print WORD" command or terminate with "quit" command

valid TYPE values are: url\string\file

Example commands:

file test.txt

string apple banana orange

url https://www.example.com/

print who

quit

## notes: 
## program is case insensitive and strips non-alphabetical characters
## can only handle .txt files

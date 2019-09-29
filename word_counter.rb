# frozen_string_literal: true
require 'fileutils'
require 'digest/sha2'

ROOT_DATA_FOLDER = 'data/'

# word count holder
# persist words occurrences to files by word's hash (sha1), also handles collisions (tho not probable)
class WordCounter
  def initialize
    # create a temp directory to hold words files
    unless File.directory?(ROOT_DATA_FOLDER)
      FileUtils.mkdir_p(ROOT_DATA_FOLDER)
    end
  end

  # add word to corresponding file in FS
  def add_word(word)
    word_hash = Digest::SHA1.hexdigest(word)
    word_file_path = ROOT_DATA_FOLDER + word_hash
    word_file = File.open(word_file_path, 'a+')
    words = word_file.readlines
    words.each {|word| word.sub! "\n", ''} # remove trailing \n
    word_index = words.index(word)

    if word_index.nil? # add new word to end of file with count = 1
      add_line_to_file(word_file_path,  word)
      add_line_to_file(word_file_path,  '1')
    else # add count to existing word by replacing count line in file
      word_count = words[word_index + 1].to_i
      add_line_to_file(word_file_path, (word_count + 1).to_s, word_index + 1)
    end
    word_file.close
  end

  # add value to end of file or replace an existing line
  def add_line_to_file(filename, new_value, line_number = nil)
    File.open(filename, 'r+') do |file|
      lines = file.each_line.to_a
      if line_number
        lines[line_number] = new_value + "\n"
      else
        lines.push(new_value + "\n")
      end
      file.rewind
      file.write(lines.join)
      file.close
    end
  end

  # get a word's count by reading it's corresponding file (which should be very small)
  def get_word(word)
    word_hash = Digest::SHA1.hexdigest(word)
    word_file_path = ROOT_DATA_FOLDER + word_hash
    return '0' unless File.exist?(word_file_path)

    word_file = File.open(word_file_path)
    words = word_file.readlines
    word_index = words.index(word + "\n")
    word_file.close
    return '0' if word_index.nil?

    words[word_index + 1].sub "\n", ''
  end

  # delete temp data folder
  def clean
    FileUtils.rm_rf("#{ROOT_DATA_FOLDER}/.", secure: true)
  end
end

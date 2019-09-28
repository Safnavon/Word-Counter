# frozen_string_literal: true

# word count holder
class WordCounter
  def initialize
    @words = {}
    @words.default = 0
  end

  def add_word(word, count = 1)
    @words[word] += count
  end

  def get
    @words.clone
  end
end

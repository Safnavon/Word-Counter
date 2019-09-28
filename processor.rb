# Process user input
require 'net/http'
require_relative 'word_counter'
require 'date'

# main processing logic
class Processor
  def initialize(word_counter)
    @word_counter = word_counter
  end

  def process_command(command)
    return false if command == 'quit'

    # if command == 'print'
    #   @word_counter.print
    #   return true
    # end
    args = command.split(' ')
    return 'Invalid argument count' if args.length < 3

    type, target, source = args
    target.downcase!
    valid_sources = %w[url string file]
    # check if source type is valid
    if valid_sources.include? type
      puts("Processing #{type}...")
      case type # process by source type
      when 'url' then process_url(source, target)
      when 'file' then process_file(source, target)
        # join the last n-2 arguments to form the source argument string
      else process_string(args[2..(args.size - 1)].join(' '), target)
      end
    else # invalid source type
      'Invalid command'
    end
  end

  # read a file line by line (assuming very large files aren't a single line)
  def process_file(filename, target)
    # check if file exists and of text type, if so, open it
    if File.exist?(filename) && File.extname(filename) == '.txt'
      IO.foreach(filename) { |line| add_target(line, target) }
      return 'Done processing'
    end

    # file not found
    'File doesn\'t exist or is not .txt'
  end

  def process_string(string, target)
    add_target(string, target)
    'Done processing'
  end

  # stream response into a file and then process that file
  def process_url(url, target)
    # add timestamp to buffer file name
    buffer_file_name = "url_response_buffer_#{DateTime.now.strftime('%Q')}.txt"
    uri = URI(url)
    begin
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new uri
      http.request request do |response|
        File.open(buffer_file_name, 'w') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      end
    end
    rescue StandardError => e
      "Network error: #{e}"
    end
    process_file(buffer_file_name, target)
    File.delete(buffer_file_name) if File.exist?(buffer_file_name)
    'Done processing'
  end

  # add target occurrences to word counter
  def add_target(string, target)
    clean_string = string.downcase.gsub(/[^a-z ]/i, ' ')
    occurrences = clean_string.split(' ').select { |word| word == target }.size
    @word_counter.add_word(target, occurrences) if occurrences.positive?
  end

end
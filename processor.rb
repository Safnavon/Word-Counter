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
    args = command.split(' ')
    return 'Invalid argument count' if args.length < 2

    if args[0] == 'print'
      target = args[1].downcase
      return "The word #{target} appeared #{@word_counter.get_word(target)} times"
    end

    type, source = args
    valid_sources = %w[url string file]
    # check if source type is valid
    if valid_sources.include? type
      puts("Processing #{type}...")
      case type # process by source type
      when 'url' then process_url(source)
      when 'file' then process_file(source)
        # join the last n-1 arguments to form the source argument string
      else process_string(args[1..(args.size - 1)].join(' '))
      end
    else # invalid source type
      'Invalid command'
    end
  end

  # read a file line by line (assuming very large files aren't a single line)
  def process_file(filename)
    # check if file exists and of text type, if so, iterate through it
    if File.exist?(filename) && File.extname(filename) == '.txt'
      IO.foreach(filename) { |line| add_target(line) }
      return 'Done processing'
    end

    # file not found
    'File doesn\'t exist or is not .txt'
  end

  def process_string(string)
    add_target(string)
    'Done processing'
  end

  # stream response into a file and then process that file
  def process_url(url)
    # add timestamp to buffer file name
    # (in order to avoid file conflicts when running multiple program instances)
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
      return "Network error: #{e}"
    end
    process_file(buffer_file_name)
    File.delete(buffer_file_name) if File.exist?(buffer_file_name)
    'Done processing'
  end

  # add target occurrences to word counter
  def add_target(string)
    clean_string = string.downcase.gsub(/[^a-z ]/i, ' ')
    clean_string.split(' ').each { |word| @word_counter.add_word(word) }
  end

  def clean
    @word_counter.clean
  end

end
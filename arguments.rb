require 'optparse'

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: convert.rb SOURCE_PROJECT OUTPUT_PROJECT [options]"

    opts.on("-cIDE", "--convert=IDE", "Specifiy what IDE the source project was from") do |convert|
      options[:convert] = convert.upcase
    end
  end.parse!

  if ARGV[0] != nil
    if !File.directory?(ARGV[0])
      puts "Input directory does not exists. Aborting"
      exit
    end
  end

  if ARGV[1] != nil
    if File.directory?(ARGV[1])
      puts "Output directory already exists. Aborting"
      exit
    end
  end

  options
end

require 'optparse'
require 'fileutils'
require 'find'

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

def convert (project_ide, output_dir)
  if project_ide == "INTELLIJ"
    remove_intellij_files output_dir
    remove_common_files output_dir
  elsif project_ide == "ECLIPSE"
    remove_eclipse_files output_dir
    remove_common_files output_dir
  else
    puts "Please specifiy either Eclipse or IntelliJ"
    exit
  end

  convert_to_bluej output_dir
end

def remove_common_files (output_dir)

end

def remove_eclipse_files (output_dir)
  FileUtils.rm "#{output_dir}/.classpath"
  FileUtils.rm "#{output_dir}/.project"
  FileUtils.rm_r "#{output_dir}/.settings"
  FileUtils.rm_r "#{output_dir}/bin", :force => true
end

def remove_intellij_files (output_dir)
  FileUtils.rm_r "#{output_dir}/.idea"
  FileUtils.rm_r "#{output_dir}/out"
  FileUtils.rm "#{output_dir}/plugin.yml"
  delete_file_ending_with(output_dir, ".iml")
end

def convert_to_bluej (output_dir)
  Find.find(output_dir) do |path|
    if FileTest.directory? path
      create_package_file path 
    end
  end 
end

def create_package_file location
  file = File.open location + "/package.bluej", "w"
  file.puts "#BlueJ package file"
  file.puts "#This project was converted from another IDE"
  file.puts "project.charset=UTF-8"
  file.close
end

def delete_file_ending_with (location, ending)
  Find.find(location) do |path|
    if path.include? ending
      FileUtils.rm "#{path}"
    end
  end
end

options = parse_options
source_dir = ARGV[0].chomp '/'
output_dir = ARGV[1].chomp '/'

FileUtils.cp_r source_dir, output_dir
convert options[:convert], output_dir

require 'fileutils'
require 'find'
require_relative 'arguments.rb'

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
  delete_file_with_ending(output_dir, ".jar")
end

def remove_eclipse_files (output_dir)
  FileUtils.rm "#{output_dir}/.classpath"
  FileUtils.rm "#{output_dir}/.project"
  FileUtils.rm_r "#{output_dir}/.settings"
  FileUtils.rm_r "#{output_dir}/bin", :force => true
end

def remove_intellij_files (output_dir)
  FileUtils.rm_r "#{output_dir}/.idea"
  FileUtils.rm "#{output_dir}/plugin.yml"
  FileUtils.rm_r "#{output_dir}/out", :force => true
  delete_file_with_ending(output_dir, ".iml")
end

def convert_to_bluej (output_dir)
  Find.find(output_dir) do |path|
    if FileTest.directory? path
      create_package_file path 
    end
  end 
end

def create_package_file (location)
  file = File.open location + "/package.bluej", "w"
  file.puts "#BlueJ package file"
  file.puts "#This project was converted to BlueJ from another IDE"
  file.puts "project.charset=UTF-8"
  file.close
end

def delete_file_with_ending (location, ending)
  Find.find(location) do |path|
    if path.include? ending
      FileUtils.rm "#{path}"
    end
  end
end

options = parse_options
source_dir = ARGV[0].chomp '/' # Some functions don't want '/'
output_dir = ARGV[1].chomp '/' # Some functions don't want '/'

FileUtils.cp_r source_dir, output_dir
convert options[:convert], output_dir

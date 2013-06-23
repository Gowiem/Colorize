#!/usr/bin/env ruby
# colorize_tabs.rb
# Author: Matt Gowie
# Created: Friday June 21st 2013

require "rubygems"
require "optparse"
require "yaml"
require File.dirname(File.expand_path(__FILE__)) + "/tab_colorer.rb"

possible_colors = ['red', 'yellow', 'blue', 'green']
options = {}
current_directory, color, red, green, blue, colorize_config, silent = nil
OptionParser.new do |opts|
	opts.banner = "Usage: tab_colorer.rb [-s #{possible_colors.join(' | ')}] | [-c red_value, green_value, blue_value]"
	opts.separator ""
	opts.separator "Options:"

	opts.on('-h', '--help', 'Display this message') do
		puts opts
		exit
	end

	opts.on('-c', '--color', "Use one of the built in colors (#{possible_colors.join(' | ')})") do
		color = ARGV[0]
	end

	opts.on('-r', '--rgb', 'Provide Red, Green, and Blue color for the tab') do 
		red = ARGV[0]
		green = ARGV[1]
		blue = ARGV[2]
	end

	opts.on('-d', '--directory', 'Check the current directory to see if it matches any of the preconfigured directory in the colorize_config.yaml file') do
		silent = true
		current_directory = `pwd`
		colorize_config = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + '/colorize_config.yml')
	end
end.parse!

if current_directory && colorize_config
	colorize_config.each do |config|
		if current_directory =~ /#{config['dir']}/
			color = config['color']
			red, green, blue = config['red'], config['green'], config['blue']
		end
	end
end

if color
	unless possible_colors.include? color 
		puts "The color you entered is not one of the possible values. \n" + 
		  "tab_colorer only accepts one of these values: #{possible_colors.join(', ')}"
	  exit
	end
	TabColorer.send("#{color}_tab")
elsif red && green && blue
	TabColorer.change_tab_color(red, green, blue)
elsif !silent
	puts "You forgot to input a color. \n" +  
	"Use -h to check the possible values for colorize"
	exit
end
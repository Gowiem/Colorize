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

# Parse options for help, predefined colors, rgb colors, or change color for directory
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
	# TODO: Break this out into own function
	Color = Struct.new(:name, :red, :green, :blue)
	config_colors = {}
	colorize_config.each do |config|
		if config['color_name'] && config['red'] && config['green'] && config['blue']
			added_color = Color.new(config['color_name'], config['red'], config['green'], config['blue'])
			config_colors[added_color.name] = added_color
		elsif current_directory =~ /#{config['dir']}/
			color = config['color']
			red, green, blue = config['red'], config['green'], config['blue']
		end
	end
end

if color
  if possible_colors.include? color
    TabColorer.send("#{color}_tab")
  elsif config_colors.keys.include? color
    color = config_colors[color]
    TabColorer.change_tab_color(color.red, color.green, color.blue)
  else
    put_bad_color_msg(color)
	end

elsif red && green && blue
	TabColorer.change_tab_color(red, green, blue)
elsif !silent
	puts "You forgot to input a color. \n" +
	"Use -h to check the possible values for colorize"
	exit
end

## Helpers
###########

def put_bad_color_msg(color_name)
  puts "The color you entered is not one of the possible values. \n" +
  "tab_colorer only accepts one of these values: #{possible_colors.join(', ')}"
  exit
end


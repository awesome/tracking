require 'fileutils'
require 'yaml'

module Tracking
  # Contains methods to interface with tracking's config file.
  #
  # similar to Sam Goldstein's config.rb for timetrap
  # @see https://github.com/samg/timetrap/
  module TrackingConfig
    extend self

    # The path to the config file
    PATH = File.join(ENV['HOME'], '.tracking', 'config.yml')

    # The path to the config file's parent directory
    DIR = File.join(ENV['HOME'], '.tracking')

    # Default config hash
    #
    # @return [Hash<Symbol,Object>] the default config in a hash
    def defaults
      {
        # path to the data file (string, ~ can be used)
        :data_file => '~/.tracking/data.csv',
        # number of lines to be displayed at once by default (integer)
        :lines => 10,
        # width of the task name column, in characters (integer)
        :task_width => 40,
        # format to use for elapsed time display (:colons or :letters)
        :elapsed_format => :colons,
        # color for the current (last) task
        :current_task_color => :yellow,
        # toggle colored display of the current (last) task
        :color_current_task => true,
        # toggle header describing tracking's display columns (true or false)
        :show_header => true,
        # toggle display of seconds in elapsed time (true of false)
        :show_elapsed_seconds => false
      }
    end

    # Overloading [] operator
    #
    # Accessor for values in the config
    #
    # @param [Symbol] key the key in the config hash
    # @return [Object] the value associated with that key
    def [] key
      write unless File.exist? PATH
      data = YAML.load_file PATH
      defaults.merge(data)[key]
    end

    # Overloading []= operator
    #
    # Setter for values in the config
    #
    # @param [Symbol] key the key you are setting a value for
    # @param [Object] value the value you associated with the key
    def []= key, value
      write unless File.exist? PATH
      data = YAML.load_file PATH
      configs = defaults.merge(data)
      configs[key] = value
      File.open(PATH, 'w') do |fh|
        fh.puts(configs.to_yaml)
      end
    end

    # Writes the configs to the file config.yml
    def write
      configs = if File.exist? PATH
        defaults.merge(YAML.load_file PATH)
      else 
        defaults
      end
      FileUtils.mkdir DIR unless File.directory? DIR
      File.open(PATH, 'w') do |fh|
        fh.puts configs.to_yaml
      end
    end

  end
end

# Config
module Forker
  require 'yaml'

  class << self
    def config(file)
      YAML.load_file file
    end
  end
end

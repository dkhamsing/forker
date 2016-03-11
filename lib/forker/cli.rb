# Command line interface
module Forker
  require 'colored'
  require 'forker/version'

  OPTION_USER = 'u'
  OPTION_PASS = 'p'
  OPTION_WL = 'w'

  ERROR_NO_ARGS = 'no args'

  SEPARATOR = '='

  class << self
    def cli_usage
      p = PRODUCT.white
      m = "#{p}, #{SUMMARY} \n"\
          "  Usage: #{p} <#{'url'.blue}> [#{OPTION_WL.white}=item1^item2..] "\
          "[#{OPTION_USER.white}=user] "\
          "[#{OPTION_PASS.white}=password] \n"\
          "\t\t       #{OPTION_WL.white}: ^ separated items to skip"
      puts m
    end

    def cli_option_value(text, name, separator)
      regex = "#{name}#{separator}"
      temp = text.find { |e| /#{regex}/ =~ e }
      temp ? temp.split(separator)[1] : nil
    end

    def cli_process(argv)
      argv1, * = argv

      no_args = argv1.nil?
      # puts "no args: #{no_args}"

      not_url = !(argv1.include? 'http') if no_args == false
      # puts "not url: #{not_url}"

      error = no_args || not_url
      # puts "error: #{error}"
      if error
        if no_args
          e = ERROR_NO_ARGS
        elsif not_url
          e = 'not a url'
        end

        # puts "e: #{e}"
      end

      # puts "argv: #{argv}"
      # puts 'getting option white list'
      # if argv.include? OPTION_WL
      whitelist = cli_option_value argv, OPTION_WL, SEPARATOR
      # puts whitelist

      user = cli_option_value argv, OPTION_USER, SEPARATOR
      # puts user

      password = cli_option_value argv, OPTION_PASS, SEPARATOR
      # puts password

      [
        error,
        e,
        argv1,
        whitelist,
        user,
        password
      ]
    end

    def cli_prompt
      m = 'Proceed (y/n)? '
      print m
      STDIN.gets.chomp
    end
  end # class
end

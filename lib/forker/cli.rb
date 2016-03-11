# Command line interface
module Forker
  require 'forker/config'
  require 'forker/net'
  require 'forker/version'
  require 'forker/github'

  require 'colored'
  require 'pp'

  OPTION_CONFIG = '--config'
  OPTION_USER = 'u'
  OPTION_PASS = 'p'
  OPTION_WL = 'w'

  ERROR_NO_ARGS = 'no args'

  SEPARATOR = '='

  class << self
    def cli
      puts "#{PROJECT} #{VERSION}"

      if ARGV.count == 0
        cli_usage
        exit
      end

      args = ARGV - [OPTION_CONFIG]
      if (ARGV.include? OPTION_CONFIG) && args.count == 1
        config_file = args[0]
        puts "loading config: #{config_file.white} ..."

        unless File.exist? config_file
          config_missing
          exit
        end

        c = config config_file
      else
        config_missing
        exit
      end

      debug = false

      u = c['username']
      pass = c['password']

      w = c['skip']
      puts "white list = #{w}" unless w.nil?

      url = c['url'][0]
      puts "getting content from #{url.white}"
      c = net_content_for_url url

      puts 'getting links'
      links_to_check, * = net_find_links c
      puts "found links #{links_to_check}" if debug

      puts 'getting repos'
      repos = github_get_repos links_to_check
      puts "repos found: #{repos.count}"
      puts repos unless debug

      if w.nil?
        repos = repos.map { |r| [r, false] }
      else
        wl = w
        puts "filtering white list #{wl}"

        m = repos.map do |r|
          matches = []
          wl.each do |x|
            matches.push r.include? x
          end

          reject = false
          matches.each do |n|
            reject = true if n
          end

          [r, reject]
        end

        exit if m.nil?

        repos = m.reject do |list|
          r = list[0]
          reject = list[1]
          puts " white listed #{r.white}" if reject
          reject
        end

        puts "repos filtered: #{repos.count}"
        # puts repos
        repos.each { |list| puts " #{list[0]}" }
      end

      user_input = cli_prompt

      client = github_client_user_pass u, pass

      if user_input == 'y'
        repos.each_with_index do |list, index|
          r = list[0]
          puts "#{index + 1}/#{repos.count} forking #{r.white}"
          # TODO: check if repo is a repo

          # begin
          #   gr = github_repo(client, r)
          # rescue StandardError => e
          #   puts " error #{e}".red
          #   next
          # end
          unless github_repo_exist(client, r)
            puts " error #{r.red} is not a repo"
            next
          end

          # check if fork already exist
          fork = "#{github_user client}/#{r.split('/')[1]}"
          puts fork

          if github_repo_exist(client, fork)
            puts "  fork #{fork.white} already exists"
            next
          end

          next if debug

          f = github_fork(client, r)
          pp f
          sleep 1
        end
      end
    end

    def cli_usage
      puts "usage: #{PROJECT.white} #{OPTION_CONFIG} <config file>"
      puts PROJECT_URL.underline
    end

    def cli_option_value(text, name, separator)
      regex = "#{name}#{separator}"
      temp = text.find { |e| /#{regex}/ =~ e }
      temp ? temp.split(separator)[1] : nil
    end

    def cli_prompt
      m = 'proceed (y/n)? '
      print m
      STDIN.gets.chomp
    end

    def config_missing
      puts 'error: missing config file'.red
      cli_usage
    end
  end # class
end

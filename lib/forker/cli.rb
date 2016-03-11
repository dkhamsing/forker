# Command line interface
module Forker
  require 'forker/config'
  require 'forker/fork'
  require 'forker/net'
  require 'forker/version'
  require 'forker/github'

  require 'colored'
  require 'pp'

  OPTION_CONFIG = '--config'

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

      u = c['username']
      pass = c['password']

      w = c['skip']
      puts "white list = #{w}" unless w.nil?

      always_fork = c['always_fork']

      url = c['url'][0]
      puts "getting content from #{url.white}"
      content = net_content_for_url url

      puts 'getting links'
      links_to_check, * = net_find_links content

      puts 'getting repos'
      repos = github_get_repos links_to_check
      puts "repos found: #{repos.count}"
      puts repos

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
        repos.each { |list| puts " #{list[0]}" }
      end

      puts "repos: #{repos.count}"
      print 'proceed (y/n)? '
      user_input = STDIN.gets.chomp

      client = github_client_user_pass u, pass

      if user_input == 'y'
        repos.each_with_index do |list, index|
          r = list[0]
          puts "#{index + 1}/#{repos.count} forking #{r.white}"

          unless github_repo_exist(client, r)
            puts " error #{r.red} is not a repo"
            next
          end

          r = fork(client, r, always_fork, true)
          pp r unless r.nil?

          sleep 0.5
        end
      end
    end

    def cli_usage
      puts "usage: #{PROJECT.white} #{OPTION_CONFIG} <config file>"
      puts PROJECT_URL.underline
    end

    def config_missing
      puts 'error: missing config file'.red
      cli_usage
    end
  end # class
end

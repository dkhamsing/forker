# Command line interface
module Forker
  require 'forker/net'
  require 'forker/version'
  require 'forker/github'

  require 'colored'
  require 'pp'

  OPTION_USER = 'u'
  OPTION_PASS = 'p'
  OPTION_WL = 'w'

  ERROR_NO_ARGS = 'no args'

  SEPARATOR = '='

  class << self
    def cli
      debug = false

      error,
      error_message,
      argv1,
      w,
      u,
      pass = cli_process ARGV

      if error
        if error_message == ERROR_NO_ARGS
          cli_usage
        else
          puts "#{error_message} 😡"
        end
        exit
      end

      user_pass = !(u.nil?) && !(pass.nil?)

      unless github_creds || user_pass
        puts 'Missing GitHub credentials in .netrc'
        exit 1
      end

      puts "white list = #{w}" unless w.nil?

      puts 'getting content '
      c = net_content_for_url argv1

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
        wl = w.split '^'
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
          # reject =
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

      client = user_pass ? github_client_user_pass(u, pass) : github_client

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
      p = PROJECT.white
      m = "#{p}, #{PROJECT_SUMMARY} \n"\
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

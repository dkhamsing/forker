require 'colored'

require 'forker/cli'
require 'forker/github'
require 'forker/net'
require 'forker/version'

require 'pp'

# Fork GitHub projects found on a page
module Forker
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
end # module

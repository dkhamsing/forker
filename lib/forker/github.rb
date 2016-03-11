# GitHub helper
module Forker
  require 'octokit'
  require 'netrc'

  NETRC_GITHUB_MACHINE = 'api.github.com'

  class << self
    def github_client
      Octokit::Client.new(netrc: true)
    end

    def github_client_user_pass(u, pass)
      Octokit::Client.new(:login => u, :password => pass)
    end

    def github_fork(client, repo)
      client.fork(repo)
    end

    def github_netrc
      n = Netrc.read
      n[NETRC_GITHUB_MACHINE]
    end

    def github_creds
      !(github_netrc.nil?)
    end

    def github_user(client)
      client.user.login
    end

    def github_get_repos(links_to_check)
      links_to_check.select { |link|
        link.to_s.downcase.include? 'github.com' and link.count('/') == 4
      }.map { |url| url.split('.com/')[1] }
      .reject { |x| x.include? '.' or x.include? '#' }.uniq
    end

    def github_repo_exist(client, repo)
      client.repository?(repo)
    end
  end # class
end

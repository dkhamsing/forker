# Fork logic
module Forker
  require 'forker/github'

  class << self
    def fork(client, r, verbose=false)
      name = r.split('/')[1]
      fork = "#{github_user client}/#{name}"

      if github_repo_exist(client, fork)
        puts "  fork #{fork.white} already exists, deleting ..." if verbose
        github_repo_delete(client, fork)
      end

      github_fork(client, r)
    end
  end
end

# Fork logic
module Forker
  require 'forker/github'

  class << self
    def fork(client, r, always_fork=false, verbose=false)
      name = r.split('/')[1]
      fork = "#{github_user client}/#{name}"

      if github_repo_exist(client, fork)
        puts "  fork #{fork.white} already exists" if verbose

        if always_fork
          puts '  deleting' if verbose
          github_repo_delete(client, fork)
        else
          puts '  skipping' if verbose
          return nil
        end
      end

      github_fork(client, r)
    end
  end
end

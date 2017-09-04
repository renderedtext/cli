module Sem::Helpers::Git

  InvalidGitUrl = Class.new(StandardError)

  def self.parse_url(git_url)
    pattern = /^git@(.+)\..+\:(.+)\/(.+)\.git$/

    if match = git_url.match(pattern)
      repo_provider, repo_owner, repo_name = match.captures

      [repo_provider, repo_owner, repo_name]
    else
      raise InvalidGitUrl
    end
  end

end

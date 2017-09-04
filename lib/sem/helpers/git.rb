module Sem::Helpers::Git

  InvalidGitUrl = Class.new(StandardError)

  def self.parse_url(git_url)
    pattern = %r{^git@(.+)\..+\:(.+)\/(.+)\.git$} # example: git@github.com:renderedtext/cli.git

    match = git_url.match(pattern)
    raise InvalidGitUrl if match.nil?

    repo_provider, repo_owner, repo_name = match.captures

    [repo_provider, repo_owner, repo_name]
  end

end

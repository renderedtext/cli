class Sem::Helpers::GitUrl

  SSH_PATTERN = %r{^git@(.+)\..+\:(.+)\/(.+)\.git$} # example: git@github.com:renderedtext/cli.git
  GITHUB_HTTP_PATTERN = %r{^(https:\/\/)?github.com/(.+)/(.+)$} # example: https://github.com/renderedtext/cli
  BITBUCKET_HTTP_PATTERN = %r{^(https:\/\/)?bitbucket.org/(.+)/(.+)$} # example: https://bitbucket.org/renderedtext/cli

  attr_reader :repo_name
  attr_reader :repo_owner
  attr_reader :repo_provider

  def initialize(url)
    @repo_provider, @repo_owner, @repo_name = parse(url)
  end

  def valid?
    @repo_name && @repo_provider && @repo_owner
  end

  private

  def parse(url)
    ssh_match = SSH_PATTERN.match(url)
    github_http_match = GITHUB_HTTP_PATTERN.match(url)
    bitbucket_http_match = BITBUCKET_HTTP_PATTERN.match(url)

    if ssh_match
      ssh_match.captures[0..2]
    elsif github_http_match
      ["github"].concat(github_http_match.captures[1..2])
    elsif bitbucket_http_match
      ["bitbucket"].concat(bitbucket_http_match.captures[1..2])
    else
      [nil, nil, nil]
    end
  end

end

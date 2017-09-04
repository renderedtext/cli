module Sem::Helpers::Git

  InvalidGitUrl = Class.new(StandardError)

  def self.parse_url(git_url)
    raise InvalidGitUrl
  end

end

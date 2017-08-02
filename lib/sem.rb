require "io/console"
require "sem/version"
require "terminal-table"

module Sem
  module_function

  require_relative "sem/ui"
  require_relative "sem/commands"

  def run(params)
    command = params.shift

    # TODO: automate me with magic <3
    case command
    when "help"       then Sem::Commands::Help.run(params)
    when "login"      then Sem::Commands::Login.run(params)
    when "teams"      then Sem::Commands::Teams.run(params)
    when "teams:info" then Sem::Commands::Teams::Info.run(params)
    end
  end

end

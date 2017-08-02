require "sem/version"
require "terminal-table"

module Sem
  module_function

  require_relative "sem/ui"
  require_relative "sem/commands"

  def run(params)
    command = params.shift

    case command
    when "help"  then Sem::Commands::Help.run(params)
    when "login" then Sem::Commands::Login.run(params)
    end
  end

end

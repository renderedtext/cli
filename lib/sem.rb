require "sem/version"
require "thor"

# Thor monkeypatchinging to support namespace:command
require "sem/thor_ext/top_level_thor"
require "sem/thor_ext/subcommand_thor"

module Sem
  require "sem/cli"
end

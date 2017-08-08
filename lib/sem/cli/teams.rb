class Sem::CLI::Teams < Sem::ThorExt::SubcommandThor
  namespace "teams"

  desc "list", "list information about a team"
  def list
    teams = [
      ["ID", "NAME", "PERMISSION", "MEMBERS"],
      ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext/developers", "write", "72 members"],
      ["fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", "tb-render/developers", "admin", "3 members"]
    ]

    print_table(teams)
  end

  desc "info [NAME]", "show information about a team"
  def info(name)
    puts "Showing info for #{name}"
    puts "NOT IMPLEMENTED"
  end

end

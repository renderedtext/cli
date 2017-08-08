class Sem::CLI::Teams < Sem::ThorExt::SubcommandThor
  namespace "teams"

  desc "list [NAME]", "list information about a team"
  def list(name)
    puts "Listing teams for #{name}"
    puts "NOT IMPLEMENTED"
  end

  desc "info [NAME]", "show information about a team"
  def info(name)
    puts "Showing info for #{name}"
    puts "NOT IMPLEMENTED"
  end

end

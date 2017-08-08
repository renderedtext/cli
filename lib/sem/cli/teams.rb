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
    info = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", name],
      ["Permission", "write"],
      ["Members", "72 members"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(info)
  end

  desc "create [NAME]", "create a new team"
  method_option :permission, :default => "read",
                             :aliases => "-p",
                             :desc => "Permission level of the team in the organization"
  def create(name)
    permission = options["permission"]

    info = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", name],
      ["Permission", permission],
      ["Members", "0 members"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(info)
  end

  desc "update [NAME]", "update a team"
  method_option :permission, :aliases => "-p", :desc => "Permission level of the team in the organization"
  method_option :name, :aliases => "-n", :desc => "Name of the team"
  def update(_name)
    new_name = options["name"]
    new_permission = options["permission"]

    info = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", new_name],
      ["Permission", new_permission],
      ["Members", "4 members"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(info)
  end

  desc "delete [NAME]", "removes a team from your organization"
  def delete(name)
    puts "Deleted team #{name}"
  end

end

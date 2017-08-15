class Sem::CLI::SharedConfigs < Sem::ThorExt::SubcommandThor
  namespace "shared-configs"

  def self.instances_table(configs)
    header = ["ID", "NAME"]

    body = configs.map do |config|
      [config[:id], config[:name]]
    end

    [header, *body]
  end

  desc "list", "list shared cofigurations"
  def list
    shared_configs = [
      ["ID", "NAME", "CONFIG FILES", "ENV VARS"],
      ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext/aws-tokens", "3", "1"],
      ["37d8fdc0-4a96-4535-a4bc-601d1c7c7058", "renderedtext/rubygems", "1", "0"]
    ]

    print_table(shared_configs)
  end

  desc "info", "show information about a shared configuration"
  def info(name)
    shared_config = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", name],
      ["Config Files", "3"],
      ["Environment Variables", "1"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(shared_config)
  end

  desc "create", "create a new shared configuration"
  def create(name)
    shared_config = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", name],
      ["Config Files", "0"],
      ["Environment Variables", "0"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(shared_config)
  end

  desc "rename", "rename a shared configuration"
  def rename(_name, new_name)
    shared_config = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", new_name],
      ["Config Files", "0"],
      ["Environment Variables", "0"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(shared_config)
  end

  desc "delete", "removes a shared configuration from your organization"
  def delete(name)
    puts "Deleted shared configuration #{name}"
  end

  class Files < Sem::ThorExt::SubcommandThor
    namespace "shared_configs:files"

    desc "list", "list files in the shared configuration"
    def list(_shared_config_name)
      files = [
        ["ID", "NAME", "ENCRYPTED?"],
        ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "secrets.txt", "true"],
        ["37d8fdc0-4a96-4535-a4bc-601d1c7c7058", "config.yml", "true"]
      ]

      print_table(files)
    end

    desc "add", "add a file to the shared configuration"
    method_option :file, :aliases => "-f", :desc => "File to upload"
    def add(shared_config_name, file_name)
      puts "Added #{file_name} to #{shared_config_name}"
    end

    desc "remove", "remove a file from the shared configuration"
    def remove(shared_config_name, file_name)
      puts "Removed #{file_name} from #{shared_config_name}"
    end
  end

  desc "files", "manage files", :hide => true
  subcommand "files", Files

end

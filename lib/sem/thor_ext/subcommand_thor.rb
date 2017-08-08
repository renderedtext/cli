module Sem
  module ThorExt

    #
    # Monkeypatching thor internals. SubcommandThor should be used for
    # namespaces and subcommands.
    #
    # Changed:
    #  - thor help screen to show the format namespace:command
    #

    class SubcommandThor < Thor

      #
      # Overide orriginal implementation and show namespace fom the commands banner.
      #
      def self.banner(command, _show_namespace = nil, subcommand = false)
        "#{namespace}:#{command.formatted_usage(self, false, subcommand)}"
      end

      def self.help(shell, subcommand = false)
        list = printable_commands(true, subcommand)
        Thor::Util.thor_classes_in(self).each do |klass|
          list += klass.printable_commands(false)
        end

        list.sort! { |a, b| a[0] <=> b[0] }

        shell.say "Usage: sem COMMAND"
        shell.say "Help topics, type sem help TOPIC for more details: \n\n"

        shell.print_table(list, :indent => 2, :truncate => true)
        shell.say
        class_options_help(shell)
      end

      def self.printable_commands(all = true, _subcommand = false)
        (all ? all_commands : commands).map do |_, command|
          next if command.hidden?
          item = []
          item << banner(command, true, false)
          item << (command.description ? "    #{command.description.gsub(/\s+/m, " ")}" : "")
          item
        end.compact
      end
    end
  end
end

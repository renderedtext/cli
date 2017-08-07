module Sem
  module ThorExt

    #
    # Monkeypatching thor internals. TopLevelThor should be used for
    # as the entrypoint for the semaphore cli.
    #
    # Changed:
    #  - thor help screen
    #  - Thor.start to accept the form namespace:command
    #

    class TopLevelThor < Thor

      def self.start
        args = ARGV

        if args.size > 0
          if args[0] == "help"
            args = [args.shift] + args.shift.split(":") + args
          else
            args = args.shift.split(":") + args
          end
        end

        super(args)
      end

      def self.banner(command, namespace = nil, subcommand = false)
        "#{command.formatted_usage(self, false, subcommand)}"
      end

      def self.help(shell, subcommand = false)
        shell.say "Usage: fwt COMMAND"
        shell.say
        shell.say "Help topics, type fwt help TOPIC for more details:"
        shell.say

        list = printable_commands(true, subcommand).reject { |cmd| cmd[0] =~ /help/ }

        shell.print_table(list, :indent => 2, :truncate => true)
        shell.say
      end
    end

  end
end

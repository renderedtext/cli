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

      #
      # Thor doesn't really support the `sem teams:info` format.
      # So, before passing on the options to Thor, we split the
      # arguments.
      #
      #   The input 'teams:info' is converted to 'teams info' and
      #   sent to the super class.
      #
      # If the first argument is 'help', then we split the second
      # argument.
      #
      #   The input 'help teams:info' is converted to 'help teams info'
      #   and then sent to the super class.
      #
      def self.start(args = nil)
        args ||= ARGV

        args = if ARGV.empty?
                 ARGV
               elsif args[0] == "help"
                 [args.shift] + args.shift.split(":") + args
               else
                 args.shift.split(":") + args
               end

        super(args)
      end

      #
      # Overide orriginal implementation and hide namespace fom the commands banner.
      #
      def self.banner(command, _show_namespace = nil, subcommand = false)
        command.formatted_usage(self, false, subcommand)
      end

      def self.help(shell, subcommand = false)
        shell.say "Usage: fwt COMMAND"
        shell.say
        shell.say "Help topics, type sem help TOPIC for more details:"
        shell.say

        list = printable_commands(true, subcommand).reject { |cmd| cmd[0] =~ /help/ }

        shell.print_table(list, :indent => 2, :truncate => true)
        shell.say
      end

    end

  end
end

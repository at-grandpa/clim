require "./options/*"
require "../exception"
require "option_parser"

class Clim
  abstract class Command
    class SubCommands < Array(Command)
      def help_info
        map do |cmd|
          {
            names:     cmd.names,
            desc:      cmd.desc,
            help_line: help_line_of(cmd),
          }
        end
      end

      private def help_line_of(cmd)
        names_and_spaces = cmd.names.join(", ") +
                           "#{" " * (max_sub_command_name_length - cmd.names.join(", ").size)}"
        "    #{names_and_spaces}   #{cmd.desc}"
      end

      private def max_sub_command_name_length
        empty? ? 0 : map(&.names.join(", ").size).max
      end
    end
  end
end

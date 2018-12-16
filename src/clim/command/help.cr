class Clim
  abstract class Command
    class Help
      def initialize(@command : Clim::Command)
      end

      def display
        @command.sub_commands.empty? ? base_help : base_help + sub_cmds_help
      end

      private def base_help
        <<-HELP_MESSAGE

          #{@command.desc}

          Usage:

            #{@command.usage}

          Options:

        #{@command.parser}


        HELP_MESSAGE
      end

      delegate desc, to: @command
      delegate usage, to: @command
      delegate parser, to: @command

      def sub_cmds_help
        <<-HELP_MESSAGE
          Sub Commands:

        #{sub_cmds_help_lines.join("\n")}


        HELP_MESSAGE
      end

      def sub_cmds_help_lines
        @command.sub_commands.map do |cmd|
          name = sub_commands_name_and_alias_name(cmd).join(", ") +
                 "#{" " * (max_name_length - sub_commands_name_and_alias_name(cmd).join(", ").size)}"
          "    #{name}   #{cmd.desc}"
        end
      end

      def sub_cmds_help_display
        sub_cmds_help_lines.join("\n")
      end

      def max_name_length
        @command.sub_commands.empty? ? 0 : @command.sub_commands.map { |cmd| sub_commands_name_and_alias_name(cmd).join(", ").size }.max
      end

      def sub_commands_name_and_alias_name(cmd)
        ([cmd.name] + cmd.alias_name)
      end

      def options_info
        {
          help: @command.parser.to_s.split("\n"),
          info: @command.options_info,
        }
      end

      def sub_commands_info
        sub_commands_info = @command.sub_commands.map do |cmd|
          {
            name: sub_commands_name_and_alias_name(cmd),
            desc: cmd.desc,
          }
        end
        {
          help: sub_cmds_help_lines,
          info: sub_commands_info,
        }
      end
    end
  end
end

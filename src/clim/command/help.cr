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

      def sub_cmds_help
        <<-HELP_MESSAGE
          Sub Commands:

        #{sub_cmds_help_lines.join("\n")}


        HELP_MESSAGE
      end

      def sub_cmds_help_lines
        @command.sub_commands.map do |cmd|
          name = name_and_alias_name(cmd) + "#{" " * (max_name_length - name_and_alias_name(cmd).size)}"
          "    #{name}   #{cmd.desc}"
        end
      end

      def max_name_length
        @command.sub_commands.empty? ? 0 : @command.sub_commands.map { |cmd| name_and_alias_name(cmd).size }.max
      end

      def name_and_alias_name(cmd)
        ([cmd.name] + cmd.alias_name).join(", ")
      end
    end
  end
end

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
          sub_cmds_help_line(cmd)
        end
      end

      def sub_cmds_help_line(cmd)
        name = sub_commands_name_and_alias_name(cmd).join(", ") +
               "#{" " * (max_name_length - sub_commands_name_and_alias_name(cmd).join(", ").size)}"
        "    #{name}   #{cmd.desc}"
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

      def options
        @command.parser.@flags.map do |flag|
          info = @command.options_info.find do |info|
            !!flag.match(/\A\s+?#{info[:names].join(", ")}/)
          end
          next nil if info.nil?
          info.merge({help_line: flag})
        end.compact
      end

      def sub_commands
        sub_commands_info = @command.sub_commands.map do |cmd|
          {
            names:     sub_commands_name_and_alias_name(cmd),
            desc:      cmd.desc,
            help_line: sub_cmds_help_line(cmd),
          }
        end
      end
    end
  end
end

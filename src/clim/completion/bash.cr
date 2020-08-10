require "./shell"

class Clim
  class Completion
    class Bash
      include Shell

      def initialize(@command : Command)
      end

      def completion_script(program_name : String = PROGRAM_NAME) : String
        <<-SCRIPT
        _#{program_name}()
        {
            local program=${COMP_WORDS[0]}
            local cmd=${COMP_WORDS[1]}
            local cur="${COMP_WORDS[COMP_CWORD]}"
            local prev="${COMP_WORDS[COMP_CWORD-1]}"
            local cword="${COMP_CWORD}"

            #{recursive_case_statement(@command, program_name)}

            return 0
        }

        complete -F _#{program_name} #{program_name}
        SCRIPT
      end

      private def recursive_case_statement(
        command : Command,
        name : String,
        count : Int32 = 1
      )
        default_part = <<-DEFAULT_PART
        #{command.sub_commands.to_a.empty? ? nil : "*)"}
        if [[ "${prev}" == "#{name}" && $(compgen -W "#{command.opts_and_subcommands.join(" ")}" -- ${cur})  ]] ; then
            COMPREPLY=( $(compgen -W "#{command.opts_and_subcommands.join(" ")}" -- ${cur}) )
        else
            COMPREPLY=( $(compgen -f ${cur}) )
        fi

        DEFAULT_PART

        return default_part if command.sub_commands.to_a.empty?

        header = <<-HEADER
        case "${COMP_WORDS[#{count}]}" in

        HEADER

        sub_commands_part = command.sub_commands.to_a.flat_map do |sub_command|
          sub_command.names.map do |name|
            <<-SUB_COMMANDS_PART
            #{name})
            #{recursive_case_statement(sub_command, name, count + 1)}
            ;;

            SUB_COMMANDS_PART
          end
        end

        footer = <<-FOOTER
        esac

        FOOTER

        header + sub_commands_part.join("\n") + default_part + footer
      end
    end
  end
end

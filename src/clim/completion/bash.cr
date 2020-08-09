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

            #{recursive_case_directive(@command, program_name)}

            return 0
        }

        complete -F _#{program_name} #{program_name}
        SCRIPT
      end

      private def recursive_case_directive(
        command : Command,
        name : String,
        count : Int32 = 1
      )
        header = if command.sub_commands.to_a.empty?
                   ""
                 else
                   <<-HEADER
                   case "${COMP_WORDS[#{count}]}" in

                   HEADER
                 end

        sub_commands_part = command.sub_commands.to_a.map do |sub_command|
          <<-SUB_COMMANDS_PART
          #{sub_command.name})
          #{recursive_case_directive(sub_command, sub_command.name, count + 1)}
          ;;

          SUB_COMMANDS_PART
        end

        default_part = <<-DEFAULT_PART
        #{command.sub_commands.to_a.empty? ? nil : "*)"}
        if [[ "${prev}" == "#{name}" && $(compgen -W "#{command.opts_and_subcommands.join(" ")}" -- ${cur})  ]] ; then
            COMPREPLY=( $(compgen -W "#{command.opts_and_subcommands.join(" ")}" -- ${cur}) )
        else
            COMPREPLY=( $(compgen -f ${cur}) )
        fi

        DEFAULT_PART

        footer = if command.sub_commands.to_a.empty?
                   ""
                 else
                   <<-FOOTER
                   esac

                   FOOTER
                 end

        header + sub_commands_part.join("\n") + default_part + footer
      end
    end
  end
end

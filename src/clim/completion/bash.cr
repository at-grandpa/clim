require "./shell"

class Clim
  class Completion
    class Bash
      include Shell

      def initialize(@command : Command)
      end

      def completion_script : String
        <<-SCRIPT
        _#{PROGRAM_NAME}()
        {
            local program=${COMP_WORDS[0]}
            local cmd=${COMP_WORDS[1]}
            local cur="${COMP_WORDS[COMP_CWORD]}"
            local prev="${COMP_WORDS[COMP_CWORD-1]}"
            local cword="${COMP_CWORD}"

            commands="asub bsub --aoption-main --boption-main --coption-main --help --version"
            case "${COMP_WORDS[1]}" in
                asub)
                    asub_commands="asubasub asubbsub --aoption-asub --boption-asub --coption-asub --help"
                    case "${COMP_WORDS[2]}" in
                        asubasub)
                            if [[ "${prev}" == "asubasub" ]] ; then
                                COMPREPLY=( $(compgen -W "--aoption-asub-asub --boption-asub-asub --coption-asub-asub" -- ${cur}) )
                            else
                                COMPREPLY=( $(compgen -f ${cur}) )
                            fi
                        ;;
                        asubbsub)
                            if [[ "${prev}" == "asubbsub" ]] ; then
                                COMPREPLY=( $(compgen -W "--aoption-asub-bsub --boption-asub-bsub --coption-asub-bsub" -- ${cur}) )
                            else
                                COMPREPLY=( $(compgen -f ${cur}) )
                            fi
                        ;;
                        *)
                            if [[ "${prev}" == "asub" && $(compgen -W "${asub_commands}" -- ${cur})  ]] ; then
                                COMPREPLY=( $(compgen -W "${asub_commands}" -- ${cur}) )
                            else
                                COMPREPLY=( $(compgen -f ${cur}) )
                            fi
                        ;;
                    esac
                ;;
                bsub)
                    if [[ "${prev}" == "bsub" ]] ; then
                        COMPREPLY=( $(compgen -W "--aoption-bsub --boption-bsub --coption-bsub" -- ${cur}) )
                    else
                        COMPREPLY=( $(compgen -f ${cur}) )
                    fi
                ;;
                *)
                    if [[ "${prev}" == "${program}" && $(compgen -W "${commands}" -- ${cur})  ]] ; then
                        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
                    else
                        COMPREPLY=( $(compgen -f ${cur}) )
                    fi
                ;;
            esac
            return 0
        }

        complete -F _#{PROGRAM_NAME} #{PROGRAM_NAME}
        SCRIPT
      end
    end
  end
end

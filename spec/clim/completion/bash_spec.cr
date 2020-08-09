require "../../spec_helper"

class SpecCommandForCompletion < Clim
  main do
    desc "main"
    option "-a", "--aoption-main", type: Bool
    option "-b", "--boption-main", type: Bool
    option "-c", "--coption-main", type: Bool
    run do |opts, args|
      puts "main"
      pp opts.aoption_main
      pp opts.boption_main
      pp opts.coption_main
    end
    sub "asub" do
      desc "asub"
      option "-a", "--aoption-asub", type: Bool
      option "-b", "--boption-asub", type: Bool
      option "-c", "--coption-asub", type: Bool
      run do |opts, args|
        puts "asub"
        pp opts.aoption_asub
        pp opts.boption_asub
        pp opts.coption_asub
      end
      sub "asubasub" do
        desc "asubasub"
        option "-a", "--aoption-asub-asub", type: Bool
        option "-b", "--boption-asub-asub", type: Bool
        option "-c", "--coption-asub-asub", type: Bool
        run do |opts, args|
          puts "asubasub"
          pp opts.aoption_asub_asub
          pp opts.boption_asub_asub
          pp opts.coption_asub_asub
        end
      end
      sub "asubbsub" do
        desc "asubbsub"
        option "-a", "--aoption-asub-bsub", type: Bool
        option "-b", "--boption-asub-bsub", type: Bool
        option "-c", "--coption-asub-bsub", type: Bool
        run do |opts, args|
          puts "asubbsub"
          pp opts.aoption_asub_bsub
          pp opts.boption_asub_bsub
          pp opts.coption_asub_bsub
        end
      end
    end
    sub "bsub" do
      desc "bsub"
      option "-a", "--aoption-bsub", type: Bool
      option "-b", "--boption-bsub", type: Bool
      option "-c", "--coption-bsub", type: Bool
      run do |opts, args|
        puts "bsub"
        pp opts.aoption_bsub
        pp opts.boption_bsub
        pp opts.coption_bsub
      end
    end
  end
end

describe Clim::Completion::Bash do
  describe "#completion_script" do
    it "returns completion_script." do
      bash_completion = Clim::Completion::Bash.new(SpecCommandForCompletion.command)
      script = bash_completion.completion_script("my_program")
      script.should eq <<-EXPECTED
      _my_program()
      {
          local program=${COMP_WORDS[0]}
          local cmd=${COMP_WORDS[1]}
          local cur="${COMP_WORDS[COMP_CWORD]}"
          local prev="${COMP_WORDS[COMP_CWORD-1]}"
          local cword="${COMP_CWORD}"

          case "${COMP_WORDS[1]}" in
      asub)
      case "${COMP_WORDS[2]}" in
      asubasub)

      if [[ "${prev}" == "asubasub" && $(compgen -W "-a --aoption-asub-asub -b --boption-asub-asub -c --coption-asub-asub --help" -- ${cur})  ]] ; then
          COMPREPLY=( $(compgen -W "-a --aoption-asub-asub -b --boption-asub-asub -c --coption-asub-asub --help" -- ${cur}) )
      else
          COMPREPLY=( $(compgen -f ${cur}) )
      fi

      ;;

      asubbsub)

      if [[ "${prev}" == "asubbsub" && $(compgen -W "-a --aoption-asub-bsub -b --boption-asub-bsub -c --coption-asub-bsub --help" -- ${cur})  ]] ; then
          COMPREPLY=( $(compgen -W "-a --aoption-asub-bsub -b --boption-asub-bsub -c --coption-asub-bsub --help" -- ${cur}) )
      else
          COMPREPLY=( $(compgen -f ${cur}) )
      fi

      ;;
      *)
      if [[ "${prev}" == "asub" && $(compgen -W "-a --aoption-asub -b --boption-asub -c --coption-asub --help asubasub asubbsub" -- ${cur})  ]] ; then
          COMPREPLY=( $(compgen -W "-a --aoption-asub -b --boption-asub -c --coption-asub --help asubasub asubbsub" -- ${cur}) )
      else
          COMPREPLY=( $(compgen -f ${cur}) )
      fi
      esac

      ;;

      bsub)

      if [[ "${prev}" == "bsub" && $(compgen -W "-a --aoption-bsub -b --boption-bsub -c --coption-bsub --help" -- ${cur})  ]] ; then
          COMPREPLY=( $(compgen -W "-a --aoption-bsub -b --boption-bsub -c --coption-bsub --help" -- ${cur}) )
      else
          COMPREPLY=( $(compgen -f ${cur}) )
      fi

      ;;
      *)
      if [[ "${prev}" == "my_program" && $(compgen -W "-a --aoption-main -b --boption-main -c --coption-main --help asub bsub" -- ${cur})  ]] ; then
          COMPREPLY=( $(compgen -W "-a --aoption-main -b --boption-main -c --coption-main --help asub bsub" -- ${cur}) )
      else
          COMPREPLY=( $(compgen -f ${cur}) )
      fi
      esac


          return 0
      }

      complete -F _my_program my_program
      EXPECTED
    end
  end
end

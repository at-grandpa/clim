require "./shell"

class Clim
  class Completion
    class Bash
      include Shell

      def initialize(@options : Command::Options, @sub_commands : Command::SubCommands)
      end

      def completion_script : String
        "jjj"
      end
    end
  end
end

require "../command"

class Clim
  class Completion
    abstract class Shell
      def initialize(@options : Command::Options, @sub_commands : Command::SubCommands)
      end

      abstract def completion_script : String
    end
  end
end

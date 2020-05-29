require "../command"

class Clim
  class Completion
    module Shell
      abstract def initialize(@options : Command::Options, @sub_commands : Command::SubCommands)
      abstract def completion_script : String
    end
  end
end

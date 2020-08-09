require "../command"

class Clim
  class Completion
    module Shell
      abstract def initialize(@command : Command)
      abstract def completion_script : String
    end
  end
end

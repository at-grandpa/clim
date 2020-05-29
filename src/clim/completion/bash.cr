require "./shell"

class Clim
  class Completion
    class Bash < Shell
      def completion_script : String
        "jjj"
      end
    end
  end
end

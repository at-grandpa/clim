class Clim
  class Completion
    def initialize(@shell : Shell)
    end

    def script : String
      @shell.completion_script
    end
  end
end

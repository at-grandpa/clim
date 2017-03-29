class Cli
  module Path
    def self.pwd : String
      pwd = `pwd`
      raise "failed to get current path." unless $?.success?
      pwd.chomp
    end
  end
end

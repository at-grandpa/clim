require "ecr/macros"
require "colorize"

class Cli
  class FileCreator
    ECR_TABLE = {
      "src_file.ecr" => SrcFileTemplate,
    }

    def self.create(create_file_path, ecr_name, ecr_args = Hash(String, String).new, silent = false)
      raise "No such ecr_name. [#{ecr_name}]" unless ECR_TABLE.keys.includes?(ecr_name)
      View.clear
      View.register(ECR_TABLE[ecr_name])
      config = Config.new
      config.args = ecr_args
      config.create_file_path = create_file_path
      config.silent = silent
      InitProject.new(config).run
    end

    class Config
      property args : NamedTuple(cmd_name: String, opt_codes: Array(String), code: String)
      property create_file_path : String
      property silent : Bool

      def initialize(
                     @args = {cmd_name: "", opt_codes: [] of String, code: ""},
                     @create_file_path = "none",
                     @silent = false)
      end
    end

    abstract class View
      getter config : Config

      @@views = [] of View.class

      def self.views
        @@views
      end

      def self.register(view)
        views << view
      end

      def self.clear
        views.clear
      end

      def initialize(@config)
      end

      def render
        Dir.mkdir_p(File.dirname(full_path))
        File.write(full_path, to_s)
        puts log_message unless config.silent
      end

      def log_message
        "      #{"clim update".colorize(:light_green)}  #{full_path}"
      end

      abstract def full_path
    end

    class InitProject
      getter config : Config

      def initialize(@config : Config)
      end

      def run
        views.each do |view|
          view.new(config).render
        end
      end

      def views
        View.views
      end
    end

    TEMPLATE_DIR = "#{__DIR__}/template"

    macro template(name, template_path, create_file_path)
      class {{name.id}} < View
        ECR.def_to_s "{{TEMPLATE_DIR.id}}/{{template_path.id}}"
        def full_path
          "#{{{create_file_path}}}"
        end
      end
    end

    template SrcFileTemplate, "src_file.ecr", "#{config.create_file_path}"
  end
end

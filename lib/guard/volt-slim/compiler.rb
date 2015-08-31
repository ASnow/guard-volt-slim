module Guard
  class VoltSlim
    class Compiler
      def self.run paths
        paths.each do |path|
          new(path).build!
        end
      end

      def initialize options
        case options
        when Hash
          @origin_path = options[:path]
          @template = options[:template]
          @target_path = options[:target]
        else
          @origin_path = options
        end
        @template ||= File.read(@origin_path)
        @target_path ||= Mapper.app_path @origin_path if @origin_path
      end

      def build
        SandlebarsConverter.new({pretty: true, use_html_safe: false, disable_escape: true}).call(@template)
      end
      def build!
        File.write(@target_path, build)
      end
    end
  end
end

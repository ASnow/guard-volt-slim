module Guard
  class VoltSlim
    module Mapper
      SLIM_TEMPLATES_PATH = %r{\Aapp/([^/]+)/_views/(.+)\.slim}
      SLIM_TO_VOLT_MASK = 'app/\1/views/\2.html'


      def self.app_path path
        path.gsub(SLIM_TEMPLATES_PATH, SLIM_TO_VOLT_MASK)
      end
      def self.template_path path
      end
    end
  end
end

module Guard
  class VoltSlim
    module Sprockets
      class SlimTemplate
        def call(html)
          result = Guard::VoltSlim::Compiler.new(template: data).build
          result
        end
      end
    end
  end
end

if defined?(Volt::ComponentTemplates)
  Volt::ComponentTemplates.register_template_handler(:slim, Guard::VoltSlim::Sprockets::SlimTemplate.new)
end

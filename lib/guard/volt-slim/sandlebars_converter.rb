module Guard
  class VoltSlim
    class SandlebarsConverter < ::Slim::ERBConverter
      replace :'Slim::CodeAttributes', Guard::VoltSlim::Filters::CodeAttributes
      # before :'Guard::VoltSlim::Filters::CodeAttributes', Guard::VoltSlim::Filters::AttrValueConverter
      replace :AttributeMerger, Guard::VoltSlim::Filters::AttributeMerger
      replace :Pretty, Guard::VoltSlim::Filters::Pretty
      replace :'Slim::Controls', Guard::VoltSlim::Filters::Controls
      replace :'Temple::Generators::ERB', Guard::VoltSlim::SendlebarsGenerator

      # remove :AttributeMerger
      remove :AttributeRemover
    end
  end
end

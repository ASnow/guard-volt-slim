module Guard
  class VoltSlim
    class ERBConverter < ::Slim::ERBConverter
      replace :'Slim::CodeAttributes', Guard::VoltSlim::Filters::CodeAttributes
      # before :'Guard::VoltSlim::Filters::CodeAttributes', Guard::VoltSlim::Filters::AttrValueConverter
      replace :AttributeMerger, Guard::VoltSlim::Filters::AttributeMerger
      replace :Pretty, Guard::VoltSlim::Filters::Pretty
      replace :'Slim::Controls', Guard::VoltSlim::Filters::Controls

      # remove :AttributeMerger
      # remove :AttributeRemover
    end
  end
end

module Guard
  class VoltSlim
    class ERBConverter < ::Slim::ERBConverter

      replace :'Slim::CodeAttributes', Guard::VoltSlim::Filters::CodeAttributes
      replace :AttributeMerger, Guard::VoltSlim::Filters::AttributeMerger
      # remove :AttributeMerger
      # remove :AttributeRemover
    end
  end
end

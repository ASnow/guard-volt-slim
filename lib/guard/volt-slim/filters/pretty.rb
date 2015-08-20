module Guard
  class VoltSlim
    module Filters
      # @api private
      class Pretty < ::Temple::HTML::Pretty

        def on_dynamic(code)
          return [:dynamic, code] unless @pretty
          indent_next, @indent_next = @indent_next, false
          [:multi, [:static,  ((options[:indent] || '') * @indent)], [:dynamic, code]]
        end

        def on_code(code)
          if code =~ Slim::EndInserter::END_RE
            [:multi, [:static,  ("\n"+(options[:indent] || '') * @indent)], [:code, code]]
          elsif code == :indent
            [:static,  ("\n"+(options[:indent] || '') * @indent)]
          else
            [:code, code]
          end
        end

        def preamble
          [:multi]
        end
      end
    end
  end
end

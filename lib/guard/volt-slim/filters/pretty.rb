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

        def on_html_tag(name, attrs, content = nil)
          content = nil if name =~ /\A(tpl|use)-/ && empty_exp?(content)
          # old_indent_next = @indent_next
          # @indent_next = true
          # result = super
          # @indent_next = old_indent_next
          # result
          super
        end
        # def tag_indent(name)
        #   if name =~ /\A(tpl|use)-/
        #     indent
        #   else
        #     super
        #   end
        # end
      end
    end
  end
end

module Guard
  class VoltSlim
    class Compiler
      def self.run paths
        paths.each do |path|
          new(path).build!
        end
      end

      def initialize path
        @origin_path = path
        @target_path = Mapper.app_path path
      end

      def build
        html = prepare_erb
        replace_templates html
        replace_template_uses html
        replace_extra_brakets html
        html
      end
      def build!
        File.write(@target_path, build)
      end

      def prepare_erb
        SandlebarsConverter.new({pretty: true, use_html_safe: false, disable_escape: true}).call(File.read(@origin_path))
      end

      EMPTY_STR = ''

      TEMPLATE_TAG = %r{<tpl-([\w\-:]+)(\s[^>]*)?>}i
      END_TEMPLATE_TAG = %r{</tpl-([\w\-:]+)>}i
      def replace_templates str
        str.gsub!(TEMPLATE_TAG) do |m|
          "<:#{$1.capitalize}>"
        end
        str.gsub!(END_TEMPLATE_TAG, EMPTY_STR)
      end

      PARTIAL_TAG = %r{<use-([\w\-:]+)(\s[^>]*)?>}i
      PARTIAL_TAG_REPLACE = '<:\1\2>'
      END_PARTIAL_TAG = %r{</use-([\w\-:]+)>}i
      END_PARTIAL_TAG_REPLACE = '</:\1>'
      def replace_template_uses str
        str.gsub!(PARTIAL_TAG, PARTIAL_TAG_REPLACE)
        str.gsub!(END_PARTIAL_TAG, END_PARTIAL_TAG_REPLACE)
      end


      OPEN_BRAKETS = '('
      CLOSE_BRAKETS = ')'

      # {{ _temple_html_attributeremover1 = ''; (_temple_html_attributemerger\d+ = []; (_temple_html_attributemerger\d+\[\d+\] = ("|')[^"']*("|');)*)? _slim_codeattributes1 = (true ? 'true' : 'false'); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 }}{{ if !_temple_html_attributeremover1.empty? }} class="{{ _temple_html_attributeremover1 }}"{{ end }}

      # def replace_class_expressions2 str
      # end


      EXTRA_BRAKETS_RE = /{{([\s\(]*)(.*?)([\s\)]*)}}/
      def replace_extra_brakets str
        str.gsub! EXTRA_BRAKETS_RE do |m|
          $1.count(OPEN_BRAKETS)
          index = 0
          unclosed = 0
          $2.each_char do |chr|
            if chr == OPEN_BRAKETS
              index -= 1
            elsif chr == CLOSE_BRAKETS
              index += 1
            end

            if index > unclosed
              unclosed = index
            end
          end
              
          "{{ #{ '(' * unclosed }#{ $2 }#{ ')' * unclosed } }}"
        end
      end
    end
  end
end

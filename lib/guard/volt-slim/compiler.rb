module Guard
  class VoltSlim
    class Compiler
      def self.run paths
        paths.each do |path|
          new(path).build
        end
      end

      def initialize path
        @origin_path = path
        @target_path = Mapper.app_path origin
      end

      def build
        html = prepare_erb
        remove_slim_header_vars html
        replace_erb_brakets html
        replace_templates html
        replace_template_uses html
        replace_slim_entities html
        replace_local_variables html
        replace_class_expressions html
        replace_extra_brakets html

        File.write(@target_path, html)
      end

      def prepare_erb
        ::Slim::ERBConverter.new({pretty: true, use_html_safe: false}).call(File.read(@origin_path))
      end

      EMPTY_STR = ''
      SLIM_VARS = '<% _temple_html_pretty1 = /<code|<pre|<textarea/ %>'
      def remove_slim_header_vars str
        str.gsub!(SLIM_VARS, EMPTY_STR)
      end
      ERB_BRAKETS = %r{<%=?\s*(.*?)\s*%>}
      VOLT_BRAKETS = '{{ \1 }}'
      def replace_erb_brakets str
        str.gsub!(ERB_BRAKETS, VOLT_BRAKETS)
      end

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

      REMOVE_ENTITY = [
        '::Temple::Utils.escape_html',
        '::Temple::Utils.indent_dynamic'
      ]
      def replace_slim_entities str
        REMOVE_ENTITY.each{ |ent| str.gsub! ent, EMPTY_STR }
      end

      def replace_local_variables str
        str.gsub! /{{(.*?)}}/ do |m|
          txt = $1.gsub(/, false, "\\n\s*", _temple_html_pretty\d+/, EMPTY_STR)
          txt = txt.gsub(/ _temple_html_pretty\d+ = \/<code\|<pre\|<textarea\/;/, EMPTY_STR)
          txt = txt.gsub(/, true, "\\n\s*", _temple_html_pretty\d+/, EMPTY_STR)
          "{{#{txt}}}"
        end          
      end

      CLASS_EXPRESSIONS_RE = %r|{{ _temple_html_attributeremover\d+ = (.*?)\.to_s }}{{ if !_temple_html_attributeremover\d+\.empty\? }} class="{{ _temple_html_attributeremover\d+ }}"{{ end }}|
      CLASS_EXTRA_BRAKETS_RE = /([\s\(]*)(.*?)([\s\)]*)/
      OPEN_BRAKETS = '('
      CLOSE_BRAKETS = ')'
      def replace_class_expressions str
        str.gsub! CLASS_EXPRESSIONS_RE do |m|
          val = $1.gsub! CLASS_EXTRA_BRAKETS_RE do |m|
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
                
            "#{ '(' * unclosed }#{ $2 }#{ ')' * unclosed }"
          end

          " class=\"{{ #{val} }}\""
        end
      end


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

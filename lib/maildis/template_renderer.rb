module Maildis

  class TemplateRenderer

    class << self

      def render(template, merge_fields)
        merge_fields.each do |mf|
          token = /#{Regexp.quote('*|' + mf.field + '|*')}/ 
          template.gsub!(token, mf.value)
        end
        template
      end

    end

  end


end

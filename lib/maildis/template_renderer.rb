module Maildis

  class TemplateRenderer

    class << self

      def render(template, merge_fields)
        result = String.new(template.content)
        merge_fields.each do |mf|
          token = /#{Regexp.quote('%' + mf.field + '%')}/
          result.gsub!(token, mf.value)
        end
        result
      end

    end

  end

end

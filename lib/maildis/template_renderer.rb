module Maildis

  class TemplateRenderer

    class << self

      def render(template, merge_fields, name)
        result = String.new(template.content)
        merge_fields = merge_fields + [GreetingField.new(name)]
        merge_fields.each do |mf|
          token = /#{Regexp.quote('%' + mf.field + '%')}/
          result.gsub!(token, mf.value)
        end
        result
      end

    end

  end

end

module Maildis

  class TemplateLoader

    class << self

      def load(template_path)
        path = File.expand_path(template_path)
        type = File.extname(path) == Template::PLAIN_EXT ? Template::PLAIN : Template::HTML 
        content = File.read path
        Template.new type, content
      end

    end

  end

end

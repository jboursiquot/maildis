module Maildis
  class Template

    HTML = "html"
    HTML_EXT = ".html"
    PLAIN = "plain"
    PLAIN_EXT = ".txt"

    attr_reader :type, :content

    def initialize(type, content)
      @type = type
      @content = content
    end

  end
end

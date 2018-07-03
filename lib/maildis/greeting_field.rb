module Maildis
  class GreetingField
    attr_reader :field, :value
    def initialize(name)
      time = Time.new
      base_greeting = case time.hour
      when 6...12 then "Good morning"
      when 14...17 then "Good afternoon"
      else "Hello"
      end

      if name.strip.chomp == ""
        greeting_name_text = ""
      elsif name.strip.chomp.index(" ") == nil
        greeting_name_text = " " + name.strip.chomp
      else
        greeting_name_text = " " + name.strip.chomp.slice(0,name.strip.chomp.index(" "))
      end

      assembled_greeting = base_greeting + greeting_name_text + ","
      @field = "greeting"
      @value = assembled_greeting
    end
  end
end

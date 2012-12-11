module Maildis
  class Recipient
    attr_reader :name, :email
    attr_accessor :merge_fields

    def initialize(name, email, merge_fields=[])
      @name = name
      @email = email
      @merge_fields = merge_fields
    end

    def to_email
      return "#{@name} <#{@email}>" if @name
      @email
    end

    def to_s
      "<Recipient #{name} | #{email}>"
    end

  end
end

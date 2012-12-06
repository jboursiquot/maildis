module Maildis
  class Recipient
    attr_reader :name, :email
    attr_accessor :merge_fields

    def initialize(name, email, merge_fields=[])
      @name = name
      @email = email
      @merge_fields = merge_fields
    end
  end
end

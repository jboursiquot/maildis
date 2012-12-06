require_relative 'validation_utils'
require_relative 'validation_error'
require_relative 'recipient_parser'

module Maildis

  class Validator

    class << self

      def validate_config(hash)
        raise ValidationError, "mailer settings missing" unless hash.has_key? 'mailer'
        raise ValidationError, "smtp settings missing" unless hash.has_key? 'smtp'
      end

      def validate_subject(subject)
        raise ValidationError, "mailer::subject invalid" unless !subject.nil? && !subject.empty?
      end

      def validate_smtp(hash)
        raise ValidationError, "smtp::host missing or invalid" unless hash.has_key?('host') && ValidationUtils.valid_hostname?(hash['host'])
        raise ValidationError, "smtp::port missing or invalid" unless hash.has_key?('port') && (hash['port'].to_i != 0)
        raise ValidationError, "smtp::username missing" unless hash.has_key? 'username'
        raise ValidationError, "smtp::password missing" unless hash.has_key? 'password'
      end

      def validate_sender(hash)
        raise ValidationError, "sender::name missing" unless hash.has_key? 'name'
        raise ValidationError, "sender::email missing or invalid" unless hash.has_key?('email') && ValidationUtils.valid_email?(hash['email'])
      end

      def validate_recipients(hash)
        raise ValidationError, "recipients::csv missing" unless hash.has_key? 'csv'
        raise ValidationError, "recipients::csv invalid file path" unless File.exist?(File.expand_path(hash['csv']))
        raise ValidationError, "recipients::csv empty" if RecipientParser.empty_csv? hash['csv']
        raise ValidationError, "recipients::csv invalid column headers" unless RecipientParser.valid_csv? hash['csv']
      end

      def validate_templates(hash)
        raise ValidationError, "templates::html not specified" unless hash.has_key? 'html'
        raise ValidationError, "templates::plain not specified" unless hash.has_key? 'plain'
        raise ValidationError, "templates::html not found" unless File.exist?(File.expand_path(hash['html']))
        raise ValidationError, "templates::plain not found" unless File.exist?(File.expand_path(hash['plain']))
      end

   end

  end

end

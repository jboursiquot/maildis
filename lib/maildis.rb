require "thor"
require "logger"
require "yaml"

Dir[File.join(File.dirname(__FILE__), 'maildis', '*')].each { |file| require file }

module Maildis
  class CLI < Thor

    desc 'validate mailer', 'Validates mailer configuration file'
    def validate(mailer_path)
      begin
        raise ValidationError, "File not found: #{mailer_path}" unless File.exists?(File.expand_path(mailer_path))
        config = YAML.load(File.open(File.expand_path(mailer_path)))
        Validator.validate_config config
        $stdout.puts 'Ok'
      rescue ValidationError => e
        $stderr.puts "Validation Error: #{e.message}"
      rescue => e
        $stderr.puts "Error: #{e.message}"
      end
    end

    desc 'test mailer', 'Dispatches the mailer through a local test SMTP server. Inbox viewable at http://localhost:1080.'
    def test(mailer)
      begin
        $stdout.puts 'TODO: Test Mailer'
      rescue => e
        $stderr.puts e.message
      end
    end

    desc 'dispatch mailer', 'Dispatches the mailer through the SMTP server specified in the mailer configuration.'
    def dispatch(mailer)
      begin
        $stdout.puts 'TODO: Send Mailer'
      rescue => e
        $stderr.puts e.message
      end
    end

  end
end

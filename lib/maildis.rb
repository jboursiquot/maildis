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
        config = load_config mailer_path
        Validator.validate_config config
        $stdout.puts 'Ok'
        exit
      rescue ValidationError => e
        abort "Validation Error: #{e.message}"
      rescue => e
        abort "Error: #{e.message}"
      end
    end

    desc 'test mailer', 'Dispatches the mailer through a local test SMTP server. Inbox viewable at http://localhost:1080.'
    method_option :ping, aliases: '-p', desc: 'Attempts to connect to the SMTP server specified in the mailer configuration'
    def test(mailer_path)
      begin
        config = load_config mailer_path
        if !options['ping'].nil?
          $stdout.puts "SMTP server reachable" if ServerUtils.server_reachable? config['smtp']['host'], config['smtp']['port']
          exit
        else
          $stdout.puts 'TODO: Test Mailer'
          exit 1
        end
        exit
      rescue ValidationError => e
        abort "Validation Error: #{e.message}"
      rescue => e
        abort "Error: " + e.message
      end
    end

    desc 'dispatch mailer', 'Dispatches the mailer through the SMTP server specified in the mailer configuration.'
    def dispatch(mailer_path)
      begin
        $stdout.puts 'TODO: Send Mailer'
      rescue => e
        $stderr.puts e.message
      end
    end

    private

    def load_config(mailer_path)
      YAML.load(File.open(File.expand_path(mailer_path)))
    end

  end
end

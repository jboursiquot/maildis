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
        load_config mailer_path
        $stdout.puts 'Ok'
        exit
      rescue ValidationError => e
        abort "Validation Error: #{e.message}"
      rescue => e
        abort "Error: #{e.message}"
      end
    end

    desc 'ping mailer', 'Attempts to connect to the SMTP server specified in the mailer configuration'
    def ping(mailer_path)
      begin
        config = load_config mailer_path
        $stdout.puts "SMTP server reachable" if ServerUtils.server_reachable? config['smtp']['host'], config['smtp']['port']
        exit
      rescue ValidationError => e
        abort "Validation Error: #{e.message}"
      rescue => e
        abort "Error: #{e.message}"
      end
    end

    desc 'dispatch mailer', 'Dispatches the mailer through the SMTP server specified in the mailer configuration.'
    def dispatch(mailer_path)
      begin
        subject = config['mailer']['subject']
        recipients = load_recipients config['mailer']['recipients']['csv']
        sender = load_sender config['mailer']['sender']
        templates = load_templates config['mailer']['templates']
        server = load_server config['smtp']
        Dispatcher.dispatch suject, recipients, sender, templates, server
        $stdout.puts 'TODO: Send Mailer'
      rescue => e
        $stderr.puts e.message
      end
    end

    private

    def load_config(mailer_path)
      config = YAML.load(File.open(File.expand_path(mailer_path)))
      Validator.validate_config config
      config
    end

    def load_recipients(path)
      Validator.validate_recipients path
      RecipientParser.extract_recipients path
    end

    def load_sender(hash)
      Validator.validate_sender hash
      Sender.new hash['name'], hash['email']
    end

    def load_templates(hash)
      Validator.validate_templates hash
      [] << TemplateLoader.load(hash['html']) << TemplateLoader.load(hash['plain'])
    end

    def load_server(hash)
      Validator.validate_smtp hash
      SmtpServer.new hash['host'], hash['port'], hash['username'], hash['password']
    end

  end
end

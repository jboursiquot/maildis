require "thor"
require "logger"
require "yaml"

Dir[File.join(File.dirname(__FILE__), 'maildis', '*')].each { |file| require file }

module Maildis
  class CLI < Thor

    @@log_file_name = Dir.home + '/.maildis.log'

    desc 'validate mailer', 'Validates mailer configuration file'
    method_option :verbose, aliases: '-v', desc: 'Verbose', default: false
    def validate(mailer_path)
      init_logger options[:verbose]
      begin
        raise ValidationError, "File not found: #{mailer_path}" unless File.exists?(File.expand_path(mailer_path))
        load_config mailer_path
        $stdout.puts 'Ok'
        exit
      rescue ValidationError => e
        error "Validation Error: #{e.message}"
      rescue => e
        fatal "Error: #{e.message}"
      end
    end

    desc 'ping mailer', 'Attempts to connect to the SMTP server specified in the mailer configuration'
    method_option :verbose, aliases: '-v', desc: 'Verbose', default: false
    def ping(mailer_path)
      init_logger options[:verbose]
      begin
        config = load_config mailer_path
        $stdout.puts "SMTP server reachable" if ServerUtils.server_reachable? config['smtp']['host'], config['smtp']['port']
        exit
      rescue ValidationError => e
        error "Validation Error: #{e.message}"
      rescue => e
        fatal "Error: #{e.message}"
      end
    end

    desc 'dispatch mailer', 'Dispatches the mailer through the SMTP server specified in the mailer configuration.'
    method_option :verbose, aliases: '-v', desc: 'Verbose', default: false
    def dispatch(mailer_path)
      init_logger options[:verbose]
      begin
        config = load_config mailer_path
        recipients = load_recipients config['mailer']['recipients']
        info "Dispatching to #{recipients.size} recipients"
        result = Dispatcher.dispatch({subject: config['mailer']['subject'],
                                      recipients: recipients,
                                      sender: load_sender(config['mailer']['sender']),
                                      templates: load_templates(config['mailer']['templates']),
                                      server: load_server(config['smtp']),
                                      logger: @@logger})
        info "Dispatch complete with errors" if result[:not_sent].size > 0
        info "Dispatch complete without errors" if result[:not_sent].size == 0
        exit
      rescue => e
        fatal e.message
      end
    end

    private

    def init_logger(verbose)
      if verbose
        @@logger = Logger.new(MultiIO.new(STDOUT, File.open(@@log_file_name,'w+')))
      else
        @@logger = Logger.new(@@log_file_name)
      end
      @@logger.formatter = proc {|severity, datetime, progname, msg| "#{datetime} #{severity}: #{msg}\n"}
    end

    def info(msg); @@logger.info msg; end
    def error(msg); @@logger.error msg; abort msg; end
    def fatal(msg); @@logger.fatal msg; abort msg; end

    def load_config(mailer_path)
      info "Load #{File.expand_path(mailer_path)}"
      config = YAML.load(File.open(File.expand_path(mailer_path)))
      info "Validate configuration"
      Validator.validate_config config
      config
    end

    def load_recipients(hash)
      info "Validate recipients csv"
      Validator.validate_recipients hash
      info "Extract recipients from csv"
      RecipientParser.extract_recipients hash['csv']
    end

    def load_sender(hash)
      info "Validate sender"
      Validator.validate_sender hash
      Sender.new hash['name'], hash['email']
    end

    def load_templates(hash)
      info "Validate templates"
      Validator.validate_templates hash
      {html: TemplateLoader.load(hash['html']), plain: TemplateLoader.load(hash['plain'])}
    end

    def load_server(hash)
      info "Validate SMTP server #{hash['host']}"
      Validator.validate_smtp hash
      SmtpServer.new hash['host'], hash['port'], hash['username'], hash['password']
    end

  end
end

require "pony"
require "logger"

module Maildis

  class Dispatcher

    class << self

      def dispatch(options = {})
        result = {sent: [], not_sent: []}
        init_logger options[:logger]

        options[:recipients].each do |recipient|
          begin
            Pony.mail({
              to: recipient.to_email,
              from: options[:sender].to_email,
              subject: options[:subject],
              html_body: TemplateRenderer.render(options[:templates][:html], recipient.merge_fields),
              body: TemplateRenderer.render(options[:templates][:plain], recipient.merge_fields),
              via: :smtp,
              via_options: {address: options[:server].host,
                            port: options[:server].port,
                            user_name: options[:server].username,
                            password: options[:server].password}
            })
            info "Sent: #{recipient.to_email}"

            wait_time_seconds = 240
            info "Pausing #{wait_time_seconds} before next send..."
            sleep wait_time_seconds

            result[:sent] << recipient
          rescue => e
            error "Error: #{recipient.to_email} | #{e.message}"
            result[:not_sent] << {recipient: recipient, reason: e.message}
          end
        end
        result
      end

      def init_logger(logger = nil); @@logger ||= logger; end
      def info(msg); @@logger.info msg if @@logger; end
      def error(msg); @@logger.error msg if @@logger; end

    end

  end


end

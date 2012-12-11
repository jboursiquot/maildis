require "pony"
require "logger"

module Maildis

  class Dispatcher

    class << self

      def dispatch(options = {})
        result = {sent: [], not_sent: []}
        options[:recipients].each do |recipient|
          begin
            html_body = TemplateRenderer.render(options[:templates][:html], recipient.merge_fields)
            plain_body = TemplateRenderer.render(options[:templates][:plain], recipient.merge_fields)
            Pony.mail({
              to: recipient.to_email,
              from: options[:sender].to_email,
              subject: options[:subject],
              html_body: html_body,
              body: plain_body,
              via: :smtp,
              via_options: {address: options[:server].host,
                            port: options[:server].port,
                            user_name: options[:server].username,
                            password: options[:server].password}
            })
            options[:logger].info "Sent: #{recipient.to_email}" if options[:logger]
            result[:sent] << recipient
          rescue => e
            options[:logger].error "Error: #{recipient.to_email} | #{e.message}" if options[:logger]
            result[:not_sent] << {recipient: recipient, reason: e.message}
          end
        end
        result
      end

    end

  end


end

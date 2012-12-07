require "pony"

module Maildis

  class Dispatcher

    class << self

      def dispatch(subject, recipients, sender, templates, server)
        result = {sent: [], not_sent: []}
        recipients.each do |recipient|
          begin
            html_body = TemplateRenderer.render(templates[:html], recipient.merge_fields)
            plain_body = TemplateRenderer.render(templates[:plain], recipient.merge_fields) 
            Pony.mail({
              to: recipient.email,
              from: sender.email,
              subject: subject,
              html_body: html_body,
              body: plain_body,
              via: :smtp,
              via_options: {address: server.host, port: server.port, user_name: server.username, password: server.password}
            })
            result[:sent] << recipient
          rescue => e
            result[:not_sent] << {recipient: recipient, reason: e.message}
          end
        end
        result
      end

    end

  end


end

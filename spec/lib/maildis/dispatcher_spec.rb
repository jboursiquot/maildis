require_relative '../../spec_helper'

describe 'Maildis::Dispatcher' do

  before(:all) do
    @config = YAML.load(File.open('spec/mailer/mailer.yml'))

    mailer = @config['mailer']
    @subject = mailer['subject']
    @recipients = [] << Maildis::RecipientParser.extract_recipients(mailer['recipients']['csv']).first
    @sender = Maildis::Sender.new mailer['sender']['name'], mailer['sender']['email']
    @templates = {html: Maildis::TemplateLoader.load(mailer['templates']['html']), plain: Maildis::TemplateLoader.load(mailer['templates']['plain'])}

    smtp = @config['smtp']
    @server = Maildis::SmtpServer.new smtp['host'], smtp['port'], smtp['username'], smtp['password']
  end

  describe '.dispatch' do
    it 'should send emails based on the given subject, recipients, sender, templates and server' do
      result = Maildis::Dispatcher.dispatch @subject, @recipients, @sender, @templates, @server
      result.should be_an_instance_of Hash
      result[:sent].size.should_not == 0
    end
  end

end

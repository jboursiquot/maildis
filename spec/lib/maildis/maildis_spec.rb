require_relative '../../spec_helper'

describe 'Maildis' do

  before(:all) do
    @valid_mailer_path = 'spec/mailer/mailer.yml'
    @invalid_mailer_path = 'spec/mailer/mailer_invalid.yml'
  end

  context 'when invoked without any task' do
    it 'should respond with a task list' do
      output = `./bin/maildis`
      output.should include 'validate'
      output.should include 'ping'
      output.should include 'dispatch'
    end
  end

  context 'when validating a mailer' do

    describe '#validate' do

      it "should respond with 'maildis validate requires at least 1 argument...' when no config file is passed in" do
        output = `./bin/maildis validate 2>&1`
        output.should include 'maildis validate requires at least 1 argument'
      end

      it "should respond with 'File not found' if mailer config does not exist" do
        output = `./bin/maildis validate no_file 2>&1`
        output.should include 'File not found'
      end

      it "should respond with a Validation Error when the mailer config passed in has a problem" do
        output = `./bin/maildis validate #{@invalid_mailer_path} 2>&1`
        output.should include 'Validation Error'
      end

      it "should respond with 'Ok' when all validation checks pass" do
        output = `./bin/maildis validate #{@valid_mailer_path} 2>&1`
        output.should include 'Ok'
      end

    end

  end

  context 'when pinging the SMTP server specified in a mailer config' do
    describe '#ping' do
      it "should check the specified SMTP server is reachable" do
        output = `./bin/maildis ping #{@valid_mailer_path} 2>&1`
        output.should include 'SMTP server reachable'
      end
    end
  end

  context 'when dispatching a mailer' do

    before(:all) do
      @config = YAML.load(File.open(@valid_mailer_path))

      mailer = @config['mailer']
      @subject = mailer['subject']
      @recipients = Maildis::RecipientParser.extract_recipients mailer['recipients']['csv']
      @sender = Maildis::Sender.new mailer['sender']['name'], mailer['sender']['email']
      @templates = {html: Maildis::TemplateLoader.load(mailer['templates']['html']), plain: Maildis::TemplateLoader.load(mailer['templates']['plain'])}

      smtp = @config['smtp']
      @server = Maildis::SmtpServer.new smtp['host'], smtp['port'], smtp['username'], smtp['password']
    end

    describe '#dispatch' do
      it 'should send all emails through the designated SMTP server' do
        result = Maildis::Dispatcher.dispatch({subject: @subject,
                                              recipients: @recipients,
                                              sender: @sender,
                                              templates: @templates,
                                              server: @server})
        result.should be_an_instance_of Hash
        result[:sent].size.should_not == 0
      end
    end
  end

end

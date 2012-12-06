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
      output.should include 'test'
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

      it "should respond with an invalid mailer configuration error when the mailer passed has a problem" do
        output = `./bin/maildis validate #{@invalid_mailer_path} 2>&1`
        output.should include 'Validation Error'
      end

      it "should respond with 'Ok' when all validation checks pass" do
        output = `./bin/maildis validate #{@valid_mailer_path} 2>&1`
        output.should include 'Ok'
      end

    end

  end
=begin
  context 'when sending a mailer' do

    describe '#test' do

      it 'should send all emails through the local SMTP server'

    end

    describe '#dispatch' do

      it 'should send all emails through the designated SMTP server'

    end

  end
=end
end

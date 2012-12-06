require_relative '../../spec_helper'

describe 'Maildis::Validator' do

  before(:all) do
    @config = YAML.load(File.open('spec/mailer/mailer.yml'))
  end

  describe '.validate_config' do

    it 'should raise ValidationError when config does not have smtp settings' do
      expect{Maildis::Validator.validate_config({'mailer' => {}})}.to raise_error Maildis::ValidationError, 'smtp settings missing'
    end

    it 'should raise ValidationError when config does not have mailer settings' do
      expect{Maildis::Validator.validate_config({'smtp' => {}})}.to raise_error Maildis::ValidationError, 'mailer settings missing'
    end

    it 'should return nil when no ValidationError is raised' do
      expect(Maildis::Validator.validate_config @config).to be_nil
    end

  end

  describe '.validate_smtp' do

    context 'when given missing or invalid parameters' do

      it 'should raise ValidationError if smtp host is missing or invalid' do
        smtp = {'port'=>1025, 'username'=>'', 'password'=>''}
        expect{Maildis::Validator.validate_smtp smtp}.to raise_error Maildis::ValidationError, 'smtp::host missing or invalid'
      end

      it 'should raise ValidationError if smtp port is missing or invalid' do
        smtp = {'host'=>'localhost', 'username'=>'', 'password'=>''}
        expect{Maildis::Validator.validate_smtp smtp}.to raise_error Maildis::ValidationError, 'smtp::port missing or invalid'
      end

      it 'should raise ValidationError if smtp username is missing' do
        smtp = {'host'=>'localhost', 'port'=>1025, 'password'=>''}
        expect{Maildis::Validator.validate_smtp smtp}.to raise_error Maildis::ValidationError, 'smtp::username missing'
      end

      it 'should raise ValidationError if smtp password is missing' do
        smtp = {'host'=>'localhost', 'port'=>1025, 'username'=>''}
        expect{Maildis::Validator.validate_smtp smtp}.to raise_error Maildis::ValidationError, 'smtp::password missing'
      end

    end

    context 'when given valid parameters' do
      it 'should not raise any ValidationError if smtp settings contain all required paramters' do
        expect(Maildis::Validator.validate_config @config).to be_nil
        expect(Maildis::Validator.validate_smtp @config['smtp']).to be_nil
      end
    end

  end

  describe '.validate_sender' do
    it 'should raise ValidationError if sender name is missing' do
      sender = {'email'=>''}
      expect{Maildis::Validator.validate_sender sender}.to raise_error Maildis::ValidationError, 'sender::name missing'
    end
    it 'should verify sender email is missing or invalid' do
      sender = {'name'=>'', 'email'=>''}
      expect{Maildis::Validator.validate_sender sender}.to raise_error Maildis::ValidationError, 'sender::email missing or invalid'
    end
    it 'should not raise any ValidationError if sender settings contains all required parameters' do
      expect(Maildis::Validator.validate_sender @config['mailer']['sender']).to be_nil
    end
  end

  describe '.validate_subject' do
    it 'should raise ValidationError if subject is blank' do
      expect {Maildis::Validator.validate_subject ''}.to raise_error Maildis::ValidationError, 'mailer::subject invalid'
    end
    it 'should raise ValidationError if subject is nil' do
      expect {Maildis::Validator.validate_subject nil}.to raise_error Maildis::ValidationError, 'mailer::subject invalid'
    end
    it 'should not raise any ValidationError if subject is valid' do
      expect(Maildis::Validator.validate_subject @config['mailer']['subject']).to be_nil
    end
  end

  describe '.validate_recipients' do

    it 'should raise ValidationError if csv is missing' do
      expect {Maildis::Validator.validate_recipients Hash.new}.to raise_error Maildis::ValidationError, 'recipients::csv missing'
    end
    it 'should raise ValidationError if csv is invalid file' do
      recipients = {'csv'=>'invalid filename'}
      expect {Maildis::Validator.validate_recipients recipients}.to raise_error Maildis::ValidationError, 'recipients::csv invalid file path'
    end
    it 'should raise ValidationError if csv does not have minimum expected columns (name, email)' do
      recipients = {'csv'=>'spec/mailer/invalid.csv'}
      expect {Maildis::Validator.validate_recipients recipients}.to raise_error Maildis::ValidationError, 'recipients::csv invalid column headers'
    end
    it 'should not raise ValidationError if csv has minimum expected columns (name, email)' do
      recipients = {'csv'=>'spec/mailer/recipients.csv'}
      expect(Maildis::Validator.validate_recipients recipients).to be_nil
    end
    it 'should raise ValidationError if csv has no recipients' do
      recipients = {'csv'=>'spec/mailer/recipients_empty.csv'}
      expect {Maildis::Validator.validate_recipients recipients}.to raise_error Maildis::ValidationError, 'recipients::csv empty'
    end
  end

  describe '.validate_templates' do
    it 'should raise ValidationError if html template parameter is not specified' do
      templates = {'plain'=>''}
      expect {Maildis::Validator.validate_templates templates}.to raise_error Maildis::ValidationError, 'templates::html not specified'
    end
    it 'should raise ValidationError if plain template parameter is not specified' do
      templates = {'html'=>''}
      expect {Maildis::Validator.validate_templates templates}.to raise_error Maildis::ValidationError, 'templates::plain not specified'
    end
    it 'should raise ValidationError if html template is not found' do
      templates = {'html'=>'bad_file_path', 'plain'=>'spec/mailer/template.txt'}
      expect {Maildis::Validator.validate_templates templates}.to raise_error Maildis::ValidationError, 'templates::html not found'
    end
    it 'should raise ValidationError if plain template is not found' do
      templates = {'html'=>'spec/mailer/template.html', 'plain'=>'bad_file_path'}
      expect {Maildis::Validator.validate_templates templates}.to raise_error Maildis::ValidationError, 'templates::plain not found'
    end
    it 'should not raise ValidationError if html and plain templates are valid' do
      templates = {'html'=>'spec/mailer/template.html', 'plain'=>'spec/mailer/template.txt'}
      expect(Maildis::Validator.validate_templates templates).to be_nil
    end
  end

end

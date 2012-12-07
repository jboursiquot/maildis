require_relative '../../spec_helper'

describe 'Maildis::TemplateLoader' do

  before(:all) do
    @config = YAML.load(File.open('spec/mailer/mailer.yml'))
    @html_template_path = @config['mailer']['templates']['html']
    @plain_template_path = @config['mailer']['templates']['plain']
  end

  describe '.load' do

    it 'should load an html template given the template path' do
      template = Maildis::TemplateLoader.load @html_template_path
      template.type.should == Maildis::Template::HTML
    end

    it 'should load a plain text template given the template path' do
      template = Maildis::TemplateLoader.load @plain_template_path
      template.type.should == Maildis::Template::PLAIN
    end

  end

end

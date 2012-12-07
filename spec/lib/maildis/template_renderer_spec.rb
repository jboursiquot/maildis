require_relative '../../spec_helper'

describe 'Maildis::TemplateRenderer' do

  before(:all) do
    @config = YAML.load(File.open('spec/mailer/mailer.yml'))
    @html_template = @config['mailer']['templates']['html']
    @plain_template = @config['mailer']['templates']['plain']
    @merge_fields = [Maildis::MergeField.new('url','http://www.domain.com')]
  end

  describe '.render' do

    it 'should render an html template given the template and the merge fields' do
      template = Maildis::TemplateLoader.load @html_template
      expect(Maildis::TemplateRenderer.render template, @merge_fields).to include @merge_fields.first.value
    end

    it 'should render a plain text template given the template and the merge fields' do
      template = Maildis::TemplateLoader.load @plain_template
      expect(Maildis::TemplateRenderer.render template, @merge_fields).to include @merge_fields.first.value
    end

  end

end

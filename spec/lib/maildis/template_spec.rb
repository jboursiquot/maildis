require_relative '../../spec_helper'

describe 'Maildis::Template' do

  describe '#new' do

    it 'should initialize with type and content' do
      t = Maildis::Template.new(Maildis::Template::HTML, '<html/>')
      t.type.should == Maildis::Template::HTML
      t.content.should == '<html/>'
    end

  end

end

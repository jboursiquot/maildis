require_relative '../../spec_helper'

describe 'Maildis::Sender' do

  describe '#new' do

    it 'should initialize with name and email' do
      r = Maildis::Sender.new('John Doe', 'jdoe@email.com')
      r.name.should == 'John Doe'
      r.email.should == 'jdoe@email.com'
    end

  end

end

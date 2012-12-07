require_relative '../../spec_helper'

describe 'Maildis::Recipient' do

  describe '#new' do

    it 'should initialize with name, email and merge fields' do
      r = Maildis::Recipient.new('John Doe', 'jdoe@email.com', [Maildis::MergeField.new('field', 'value')])
      r.name.should == 'John Doe'
      r.email.should == 'jdoe@email.com'
      r.merge_fields.size.should_not == 0
    end

  end

end

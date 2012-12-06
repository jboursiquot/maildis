require_relative '../../spec_helper'

describe 'Maildis::MergeField' do

  describe '#new' do

    it 'should initialize with field and value' do
      mf = Maildis::MergeField.new('field', 'value')
      mf.field.should == 'field'
      mf.value.should == 'value'
    end

  end

end

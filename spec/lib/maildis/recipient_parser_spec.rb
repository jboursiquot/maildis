require_relative '../../spec_helper'

describe 'Maildis::RecipientParser' do

  before(:all) do
    @valid_csv_path = 'spec/mailer/recipients.csv'
    @invalid_csv_path = 'spec/mailer/invalid.csv'
    @empty_csv_path = 'spec/mailer/recipients_empty.csv'
  end

  describe '.valid_csv?' do
    it "should return true if CSV has the expected format" do
      expect(Maildis::RecipientParser.valid_csv?(@valid_csv_path)).to be_true
    end
    it "should return false if CSV does not have the expected format" do
      expect(Maildis::RecipientParser.valid_csv?(@invalid_csv_path)).to be_false
    end
  end

  describe '.empty_csv?' do
    it "should return true if CSV has the right format but is empty" do
      expect(Maildis::RecipientParser.empty_csv?(@empty_csv_path)).to be_true
    end
    it "should return false if CSV has the right format and is not empty" do
      expect(Maildis::RecipientParser.empty_csv?(@valid_csv_path)).to be_false
    end
  end

  describe '.extract_recipients' do
    it "should extract a list of recipients from the CSV" do
      recipients = Maildis::RecipientParser.extract_recipients @valid_csv_path
      recipients.size.should > 0
      recipients.first.should be_an_instance_of Maildis::Recipient
      recipients.first.merge_fields.should_not be_nil
      recipients.first.merge_fields.should_not be_empty
    end
  end

end

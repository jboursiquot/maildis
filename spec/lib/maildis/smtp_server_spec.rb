require_relative '../../spec_helper'

describe 'Maildis::SmtpServer' do

  describe '#new' do

    it 'should initialize with host, port, username and password' do
      s = Maildis::SmtpServer.new('localhost',1025,'username','password')
      s.host.should == 'localhost'
      s.port.should == 1025
      s.username.should == 'username'
      s.password.should == 'password'
    end

  end

end

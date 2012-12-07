module Maildis

  class SmtpServer
    attr_reader :host, :port, :username, :password
    def initialize(host, port, username, password)
      @host = host
      @port = port
      @username = username
      @password = password
    end
  end

end

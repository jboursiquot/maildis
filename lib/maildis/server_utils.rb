require 'socket'

class ServerUtils

  class << self

    def server_reachable?(host, port=25)
      begin
        TCPSocket.new(host, port).close
        true
      rescue Errno::ECONNREFUSED
        false
      rescue => e
        $stderr.puts "Error during mail server status check: " + e.message
      end
    end

  end

end

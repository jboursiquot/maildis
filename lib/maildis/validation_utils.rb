class ValidationUtils

  class << self

    def valid_hostname?(hostname)
      return false unless hostname
      return false if hostname.length > 255 || hostname.scan('..').any?
      return true if hostname == 'localhost'
      hostname = hostname[0 ... -1] if hostname.index('.', -1)
      return hostname.split('.').collect { |i| i.size <= 63 && !(i.rindex('-', 0) || i.index('-', -1) || i.scan(/[^a-z\d-]/i).any?)}.all?
    end

    def valid_email?(email)
      !email.match(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i).nil?
    end

  end

end

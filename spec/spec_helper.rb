%w{yaml pry}.each{ |lib| require lib}
Dir[File.join(File.dirname(__FILE__), '../lib/maildis', '*')].each { |file| require file }

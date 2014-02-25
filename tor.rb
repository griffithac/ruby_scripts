require 'net/telnet'

class Tor

  def self.switch_endpoint
    localhost = Net::Telnet::new("Host" => "localhost", "Port" => "9051", "Timeout" => 10, "Prompt" => /250 OK\n/)
    localhost.cmd('AUTHENTICATE "Carpet11"') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
    localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
    localhost.close
    puts 'Changing Endpoint'
    sleep 3
  end
end
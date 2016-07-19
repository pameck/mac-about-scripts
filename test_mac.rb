#!/usr/bin/env ruby
def test_wifi
  puts 'turning on wifi...'
  system('networksetup -setairportpower en0 on')
  available_networks=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s`
  if available_networks.empty?
    puts 'WiFi: Not OK.'
  else
    puts 'Wifi: OK.'
  end
end

def test_mac
  test_wifi
end
test_mac
# -*- encoding : utf-8 -*-
require 'dtv_tournaments'
DTVTournaments.configure_cache do |config|
  config[:active] = true
  config[:host] = 'localhost'
  config[:port] = 6379
  config[:db]   = 3
end

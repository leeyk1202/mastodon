# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (http://www.iana.org/time-zones).

module TZInfo
  module Data
    module Definitions
      module Asia
        module Muscat
          include TimezoneDefinition
          
          linked_timezone 'Asia/Muscat', 'Asia/Dubai'
        end
      end
    end
  end
end

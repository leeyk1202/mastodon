# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (http://www.iana.org/time-zones).

module TZInfo
  module Data
    module Definitions
      module America
        module Winnipeg
          include TimezoneDefinition
          
          timezone 'America/Winnipeg' do |tz|
            tz.offset :o0, -23316, 0, :LMT
            tz.offset :o1, -21600, 0, :CST
            tz.offset :o2, -21600, 3600, :CDT
            tz.offset :o3, -21600, 3600, :CWT
            tz.offset :o4, -21600, 3600, :CPT
            
            tz.transition 1887, 7, :o1, -2602258284, 17355375143, 7200
            tz.transition 1916, 4, :o2, -1694368800, 9683907, 4
            tz.transition 1916, 9, :o1, -1681671600, 58106969, 24
            tz.transition 1918, 4, :o2, -1632067200, 14530187, 6
            tz.transition 1918, 10, :o1, -1615136400, 58125451, 24
            tz.transition 1937, 5, :o2, -1029686400, 14572019, 6
            tz.transition 1937, 9, :o1, -1018198800, 58291267, 24
            tz.transition 1942, 2, :o3, -880214400, 14582399, 6
            tz.transition 1945, 8, :o4, -769395600, 58360379, 24
            tz.transition 1945, 9, :o1, -765392400, 58361491, 24
            tz.transition 1946, 5, :o2, -746035200, 14591717, 6
            tz.transition 1946, 10, :o1, -732733200, 58370563, 24
            tz.transition 1947, 4, :o2, -715795200, 14593817, 6
            tz.transition 1947, 9, :o1, -702493200, 58378963, 24
            tz.transition 1948, 4, :o2, -684345600, 14596001, 6
            tz.transition 1948, 9, :o1, -671043600, 58387699, 24
            tz.transition 1949, 4, :o2, -652896000, 14598185, 6
            tz.transition 1949, 9, :o1, -639594000, 58396435, 24
            tz.transition 1950, 5, :o2, -620755200, 14600417, 6
            tz.transition 1950, 9, :o1, -607626000, 58405315, 24
            tz.transition 1951, 4, :o2, -589392000, 14602595, 6
            tz.transition 1951, 9, :o1, -576090000, 58414075, 24
            tz.transition 1952, 4, :o2, -557942400, 14604779, 6
            tz.transition 1952, 9, :o1, -544640400, 58422811, 24
            tz.transition 1953, 4, :o2, -526492800, 14606963, 6
            tz.transition 1953, 9, :o1, -513190800, 58431547, 24
            tz.transition 1954, 4, :o2, -495043200, 14609147, 6
            tz.transition 1954, 9, :o1, -481741200, 58440283, 24
            tz.transition 1955, 4, :o2, -463593600, 14611331, 6
            tz.transition 1955, 9, :o1, -450291600, 58449019, 24
            tz.transition 1956, 4, :o2, -431539200, 14613557, 6
            tz.transition 1956, 9, :o1, -418237200, 58457923, 24
            tz.transition 1957, 4, :o2, -400089600, 14615741, 6
            tz.transition 1957, 9, :o1, -386787600, 58466659, 24
            tz.transition 1958, 4, :o2, -368640000, 14617925, 6
            tz.transition 1958, 9, :o1, -355338000, 58475395, 24
            tz.transition 1959, 4, :o2, -337190400, 14620109, 6
            tz.transition 1959, 10, :o1, -321469200, 58484803, 24
            tz.transition 1960, 4, :o2, -305740800, 14622293, 6
            tz.transition 1960, 9, :o1, -292438800, 58492867, 24
            tz.transition 1963, 4, :o2, -210787200, 14628887, 6
            tz.transition 1963, 9, :o1, -198090000, 58519075, 24
            tz.transition 1966, 4, :o2, -116438400, 14635439, 6
            tz.transition 1966, 10, :o1, -100108800, 14636573, 6
            tz.transition 1967, 4, :o2, -84384000, 14637665, 6
            tz.transition 1967, 10, :o1, -68659200, 14638757, 6
            tz.transition 1968, 4, :o2, -52934400, 14639849, 6
            tz.transition 1968, 10, :o1, -37209600, 14640941, 6
            tz.transition 1969, 4, :o2, -21484800, 14642033, 6
            tz.transition 1969, 10, :o1, -5760000, 14643125, 6
            tz.transition 1970, 4, :o2, 9964800
            tz.transition 1970, 10, :o1, 25689600
            tz.transition 1971, 4, :o2, 41414400
            tz.transition 1971, 10, :o1, 57744000
            tz.transition 1972, 4, :o2, 73468800
            tz.transition 1972, 10, :o1, 89193600
            tz.transition 1973, 4, :o2, 104918400
            tz.transition 1973, 10, :o1, 120643200
            tz.transition 1974, 4, :o2, 136368000
            tz.transition 1974, 10, :o1, 152092800
            tz.transition 1975, 4, :o2, 167817600
            tz.transition 1975, 10, :o1, 183542400
            tz.transition 1976, 4, :o2, 199267200
            tz.transition 1976, 10, :o1, 215596800
            tz.transition 1977, 4, :o2, 230716800
            tz.transition 1977, 10, :o1, 247046400
            tz.transition 1978, 4, :o2, 262771200
            tz.transition 1978, 10, :o1, 278496000
            tz.transition 1979, 4, :o2, 294220800
            tz.transition 1979, 10, :o1, 309945600
            tz.transition 1980, 4, :o2, 325670400
            tz.transition 1980, 10, :o1, 341395200
            tz.transition 1981, 4, :o2, 357120000
            tz.transition 1981, 10, :o1, 372844800
            tz.transition 1982, 4, :o2, 388569600
            tz.transition 1982, 10, :o1, 404899200
            tz.transition 1983, 4, :o2, 420019200
            tz.transition 1983, 10, :o1, 436348800
            tz.transition 1984, 4, :o2, 452073600
            tz.transition 1984, 10, :o1, 467798400
            tz.transition 1985, 4, :o2, 483523200
            tz.transition 1985, 10, :o1, 499248000
            tz.transition 1986, 4, :o2, 514972800
            tz.transition 1986, 10, :o1, 530697600
            tz.transition 1987, 4, :o2, 544608000
            tz.transition 1987, 10, :o1, 562147200
            tz.transition 1988, 4, :o2, 576057600
            tz.transition 1988, 10, :o1, 594201600
            tz.transition 1989, 4, :o2, 607507200
            tz.transition 1989, 10, :o1, 625651200
            tz.transition 1990, 4, :o2, 638956800
            tz.transition 1990, 10, :o1, 657100800
            tz.transition 1991, 4, :o2, 671011200
            tz.transition 1991, 10, :o1, 688550400
            tz.transition 1992, 4, :o2, 702460800
            tz.transition 1992, 10, :o1, 720000000
            tz.transition 1993, 4, :o2, 733910400
            tz.transition 1993, 10, :o1, 752054400
            tz.transition 1994, 4, :o2, 765360000
            tz.transition 1994, 10, :o1, 783504000
            tz.transition 1995, 4, :o2, 796809600
            tz.transition 1995, 10, :o1, 814953600
            tz.transition 1996, 4, :o2, 828864000
            tz.transition 1996, 10, :o1, 846403200
            tz.transition 1997, 4, :o2, 860313600
            tz.transition 1997, 10, :o1, 877852800
            tz.transition 1998, 4, :o2, 891763200
            tz.transition 1998, 10, :o1, 909302400
            tz.transition 1999, 4, :o2, 923212800
            tz.transition 1999, 10, :o1, 941356800
            tz.transition 2000, 4, :o2, 954662400
            tz.transition 2000, 10, :o1, 972806400
            tz.transition 2001, 4, :o2, 986112000
            tz.transition 2001, 10, :o1, 1004256000
            tz.transition 2002, 4, :o2, 1018166400
            tz.transition 2002, 10, :o1, 1035705600
            tz.transition 2003, 4, :o2, 1049616000
            tz.transition 2003, 10, :o1, 1067155200
            tz.transition 2004, 4, :o2, 1081065600
            tz.transition 2004, 10, :o1, 1099209600
            tz.transition 2005, 4, :o2, 1112515200
            tz.transition 2005, 10, :o1, 1130659200
            tz.transition 2006, 4, :o2, 1143964800
            tz.transition 2006, 10, :o1, 1162105200
            tz.transition 2007, 3, :o2, 1173600000
            tz.transition 2007, 11, :o1, 1194159600
            tz.transition 2008, 3, :o2, 1205049600
            tz.transition 2008, 11, :o1, 1225609200
            tz.transition 2009, 3, :o2, 1236499200
            tz.transition 2009, 11, :o1, 1257058800
            tz.transition 2010, 3, :o2, 1268553600
            tz.transition 2010, 11, :o1, 1289113200
            tz.transition 2011, 3, :o2, 1300003200
            tz.transition 2011, 11, :o1, 1320562800
            tz.transition 2012, 3, :o2, 1331452800
            tz.transition 2012, 11, :o1, 1352012400
            tz.transition 2013, 3, :o2, 1362902400
            tz.transition 2013, 11, :o1, 1383462000
            tz.transition 2014, 3, :o2, 1394352000
            tz.transition 2014, 11, :o1, 1414911600
            tz.transition 2015, 3, :o2, 1425801600
            tz.transition 2015, 11, :o1, 1446361200
            tz.transition 2016, 3, :o2, 1457856000
            tz.transition 2016, 11, :o1, 1478415600
            tz.transition 2017, 3, :o2, 1489305600
            tz.transition 2017, 11, :o1, 1509865200
            tz.transition 2018, 3, :o2, 1520755200
            tz.transition 2018, 11, :o1, 1541314800
            tz.transition 2019, 3, :o2, 1552204800
            tz.transition 2019, 11, :o1, 1572764400
            tz.transition 2020, 3, :o2, 1583654400
            tz.transition 2020, 11, :o1, 1604214000
            tz.transition 2021, 3, :o2, 1615708800
            tz.transition 2021, 11, :o1, 1636268400
            tz.transition 2022, 3, :o2, 1647158400
            tz.transition 2022, 11, :o1, 1667718000
            tz.transition 2023, 3, :o2, 1678608000
            tz.transition 2023, 11, :o1, 1699167600
            tz.transition 2024, 3, :o2, 1710057600
            tz.transition 2024, 11, :o1, 1730617200
            tz.transition 2025, 3, :o2, 1741507200
            tz.transition 2025, 11, :o1, 1762066800
            tz.transition 2026, 3, :o2, 1772956800
            tz.transition 2026, 11, :o1, 1793516400
            tz.transition 2027, 3, :o2, 1805011200
            tz.transition 2027, 11, :o1, 1825570800
            tz.transition 2028, 3, :o2, 1836460800
            tz.transition 2028, 11, :o1, 1857020400
            tz.transition 2029, 3, :o2, 1867910400
            tz.transition 2029, 11, :o1, 1888470000
            tz.transition 2030, 3, :o2, 1899360000
            tz.transition 2030, 11, :o1, 1919919600
            tz.transition 2031, 3, :o2, 1930809600
            tz.transition 2031, 11, :o1, 1951369200
            tz.transition 2032, 3, :o2, 1962864000
            tz.transition 2032, 11, :o1, 1983423600
            tz.transition 2033, 3, :o2, 1994313600
            tz.transition 2033, 11, :o1, 2014873200
            tz.transition 2034, 3, :o2, 2025763200
            tz.transition 2034, 11, :o1, 2046322800
            tz.transition 2035, 3, :o2, 2057212800
            tz.transition 2035, 11, :o1, 2077772400
            tz.transition 2036, 3, :o2, 2088662400
            tz.transition 2036, 11, :o1, 2109222000
            tz.transition 2037, 3, :o2, 2120112000
            tz.transition 2037, 11, :o1, 2140671600
            tz.transition 2038, 3, :o2, 2152166400, 14792981, 6
            tz.transition 2038, 11, :o1, 2172726000, 59177635, 24
            tz.transition 2039, 3, :o2, 2183616000, 14795165, 6
            tz.transition 2039, 11, :o1, 2204175600, 59186371, 24
            tz.transition 2040, 3, :o2, 2215065600, 14797349, 6
            tz.transition 2040, 11, :o1, 2235625200, 59195107, 24
            tz.transition 2041, 3, :o2, 2246515200, 14799533, 6
            tz.transition 2041, 11, :o1, 2267074800, 59203843, 24
            tz.transition 2042, 3, :o2, 2277964800, 14801717, 6
            tz.transition 2042, 11, :o1, 2298524400, 59212579, 24
            tz.transition 2043, 3, :o2, 2309414400, 14803901, 6
            tz.transition 2043, 11, :o1, 2329974000, 59221315, 24
            tz.transition 2044, 3, :o2, 2341468800, 14806127, 6
            tz.transition 2044, 11, :o1, 2362028400, 59230219, 24
            tz.transition 2045, 3, :o2, 2372918400, 14808311, 6
            tz.transition 2045, 11, :o1, 2393478000, 59238955, 24
            tz.transition 2046, 3, :o2, 2404368000, 14810495, 6
            tz.transition 2046, 11, :o1, 2424927600, 59247691, 24
            tz.transition 2047, 3, :o2, 2435817600, 14812679, 6
            tz.transition 2047, 11, :o1, 2456377200, 59256427, 24
            tz.transition 2048, 3, :o2, 2467267200, 14814863, 6
            tz.transition 2048, 11, :o1, 2487826800, 59265163, 24
            tz.transition 2049, 3, :o2, 2499321600, 14817089, 6
            tz.transition 2049, 11, :o1, 2519881200, 59274067, 24
            tz.transition 2050, 3, :o2, 2530771200, 14819273, 6
            tz.transition 2050, 11, :o1, 2551330800, 59282803, 24
            tz.transition 2051, 3, :o2, 2562220800, 14821457, 6
            tz.transition 2051, 11, :o1, 2582780400, 59291539, 24
            tz.transition 2052, 3, :o2, 2593670400, 14823641, 6
            tz.transition 2052, 11, :o1, 2614230000, 59300275, 24
            tz.transition 2053, 3, :o2, 2625120000, 14825825, 6
            tz.transition 2053, 11, :o1, 2645679600, 59309011, 24
            tz.transition 2054, 3, :o2, 2656569600, 14828009, 6
            tz.transition 2054, 11, :o1, 2677129200, 59317747, 24
            tz.transition 2055, 3, :o2, 2688624000, 14830235, 6
            tz.transition 2055, 11, :o1, 2709183600, 59326651, 24
            tz.transition 2056, 3, :o2, 2720073600, 14832419, 6
            tz.transition 2056, 11, :o1, 2740633200, 59335387, 24
            tz.transition 2057, 3, :o2, 2751523200, 14834603, 6
            tz.transition 2057, 11, :o1, 2772082800, 59344123, 24
            tz.transition 2058, 3, :o2, 2782972800, 14836787, 6
            tz.transition 2058, 11, :o1, 2803532400, 59352859, 24
            tz.transition 2059, 3, :o2, 2814422400, 14838971, 6
            tz.transition 2059, 11, :o1, 2834982000, 59361595, 24
            tz.transition 2060, 3, :o2, 2846476800, 14841197, 6
            tz.transition 2060, 11, :o1, 2867036400, 59370499, 24
            tz.transition 2061, 3, :o2, 2877926400, 14843381, 6
            tz.transition 2061, 11, :o1, 2898486000, 59379235, 24
            tz.transition 2062, 3, :o2, 2909376000, 14845565, 6
            tz.transition 2062, 11, :o1, 2929935600, 59387971, 24
            tz.transition 2063, 3, :o2, 2940825600, 14847749, 6
            tz.transition 2063, 11, :o1, 2961385200, 59396707, 24
            tz.transition 2064, 3, :o2, 2972275200, 14849933, 6
            tz.transition 2064, 11, :o1, 2992834800, 59405443, 24
            tz.transition 2065, 3, :o2, 3003724800, 14852117, 6
            tz.transition 2065, 11, :o1, 3024284400, 59414179, 24
            tz.transition 2066, 3, :o2, 3035779200, 14854343, 6
            tz.transition 2066, 11, :o1, 3056338800, 59423083, 24
            tz.transition 2067, 3, :o2, 3067228800, 14856527, 6
            tz.transition 2067, 11, :o1, 3087788400, 59431819, 24
            tz.transition 2068, 3, :o2, 3098678400, 14858711, 6
            tz.transition 2068, 11, :o1, 3119238000, 59440555, 24
          end
        end
      end
    end
  end
end

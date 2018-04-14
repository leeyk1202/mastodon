# encoding: UTF-8

# This file contains data derived from the IANA Time Zone Database
# (http://www.iana.org/time-zones).

module TZInfo
  module Data
    module Definitions
      module Europe
        module Athens
          include TimezoneDefinition
          
          timezone 'Europe/Athens' do |tz|
            tz.offset :o0, 5692, 0, :LMT
            tz.offset :o1, 5692, 0, :AMT
            tz.offset :o2, 7200, 0, :EET
            tz.offset :o3, 7200, 3600, :EEST
            tz.offset :o4, 3600, 3600, :CEST
            tz.offset :o5, 3600, 0, :CET
            
            tz.transition 1895, 9, :o1, -2344642492, 52130529377, 21600
            tz.transition 1916, 7, :o2, -1686101632, 3268447787, 1350
            tz.transition 1932, 7, :o3, -1182996000, 29122745, 12
            tz.transition 1932, 8, :o2, -1178161200, 19415611, 8
            tz.transition 1941, 4, :o3, -906861600, 29161097, 12
            tz.transition 1941, 4, :o4, -904878000, 19440915, 8
            tz.transition 1942, 11, :o5, -857257200, 58335973, 24
            tz.transition 1943, 3, :o4, -844477200, 58339523, 24
            tz.transition 1943, 10, :o5, -828237600, 29172017, 12
            tz.transition 1944, 4, :o2, -812422800, 58348427, 24
            tz.transition 1952, 6, :o3, -552362400, 29210333, 12
            tz.transition 1952, 11, :o2, -541652400, 19474547, 8
            tz.transition 1975, 4, :o3, 166485600
            tz.transition 1975, 11, :o2, 186184800
            tz.transition 1976, 4, :o3, 198028800
            tz.transition 1976, 10, :o2, 213753600
            tz.transition 1977, 4, :o3, 228873600
            tz.transition 1977, 9, :o2, 244080000
            tz.transition 1978, 4, :o3, 260323200
            tz.transition 1978, 9, :o2, 275446800
            tz.transition 1979, 4, :o3, 291798000
            tz.transition 1979, 9, :o2, 307407600
            tz.transition 1980, 3, :o3, 323388000
            tz.transition 1980, 9, :o2, 338936400
            tz.transition 1981, 3, :o3, 354675600
            tz.transition 1981, 9, :o2, 370400400
            tz.transition 1982, 3, :o3, 386125200
            tz.transition 1982, 9, :o2, 401850000
            tz.transition 1983, 3, :o3, 417574800
            tz.transition 1983, 9, :o2, 433299600
            tz.transition 1984, 3, :o3, 449024400
            tz.transition 1984, 9, :o2, 465354000
            tz.transition 1985, 3, :o3, 481078800
            tz.transition 1985, 9, :o2, 496803600
            tz.transition 1986, 3, :o3, 512528400
            tz.transition 1986, 9, :o2, 528253200
            tz.transition 1987, 3, :o3, 543978000
            tz.transition 1987, 9, :o2, 559702800
            tz.transition 1988, 3, :o3, 575427600
            tz.transition 1988, 9, :o2, 591152400
            tz.transition 1989, 3, :o3, 606877200
            tz.transition 1989, 9, :o2, 622602000
            tz.transition 1990, 3, :o3, 638326800
            tz.transition 1990, 9, :o2, 654656400
            tz.transition 1991, 3, :o3, 670381200
            tz.transition 1991, 9, :o2, 686106000
            tz.transition 1992, 3, :o3, 701830800
            tz.transition 1992, 9, :o2, 717555600
            tz.transition 1993, 3, :o3, 733280400
            tz.transition 1993, 9, :o2, 749005200
            tz.transition 1994, 3, :o3, 764730000
            tz.transition 1994, 9, :o2, 780454800
            tz.transition 1995, 3, :o3, 796179600
            tz.transition 1995, 9, :o2, 811904400
            tz.transition 1996, 3, :o3, 828234000
            tz.transition 1996, 10, :o2, 846378000
            tz.transition 1997, 3, :o3, 859683600
            tz.transition 1997, 10, :o2, 877827600
            tz.transition 1998, 3, :o3, 891133200
            tz.transition 1998, 10, :o2, 909277200
            tz.transition 1999, 3, :o3, 922582800
            tz.transition 1999, 10, :o2, 941331600
            tz.transition 2000, 3, :o3, 954032400
            tz.transition 2000, 10, :o2, 972781200
            tz.transition 2001, 3, :o3, 985482000
            tz.transition 2001, 10, :o2, 1004230800
            tz.transition 2002, 3, :o3, 1017536400
            tz.transition 2002, 10, :o2, 1035680400
            tz.transition 2003, 3, :o3, 1048986000
            tz.transition 2003, 10, :o2, 1067130000
            tz.transition 2004, 3, :o3, 1080435600
            tz.transition 2004, 10, :o2, 1099184400
            tz.transition 2005, 3, :o3, 1111885200
            tz.transition 2005, 10, :o2, 1130634000
            tz.transition 2006, 3, :o3, 1143334800
            tz.transition 2006, 10, :o2, 1162083600
            tz.transition 2007, 3, :o3, 1174784400
            tz.transition 2007, 10, :o2, 1193533200
            tz.transition 2008, 3, :o3, 1206838800
            tz.transition 2008, 10, :o2, 1224982800
            tz.transition 2009, 3, :o3, 1238288400
            tz.transition 2009, 10, :o2, 1256432400
            tz.transition 2010, 3, :o3, 1269738000
            tz.transition 2010, 10, :o2, 1288486800
            tz.transition 2011, 3, :o3, 1301187600
            tz.transition 2011, 10, :o2, 1319936400
            tz.transition 2012, 3, :o3, 1332637200
            tz.transition 2012, 10, :o2, 1351386000
            tz.transition 2013, 3, :o3, 1364691600
            tz.transition 2013, 10, :o2, 1382835600
            tz.transition 2014, 3, :o3, 1396141200
            tz.transition 2014, 10, :o2, 1414285200
            tz.transition 2015, 3, :o3, 1427590800
            tz.transition 2015, 10, :o2, 1445734800
            tz.transition 2016, 3, :o3, 1459040400
            tz.transition 2016, 10, :o2, 1477789200
            tz.transition 2017, 3, :o3, 1490490000
            tz.transition 2017, 10, :o2, 1509238800
            tz.transition 2018, 3, :o3, 1521939600
            tz.transition 2018, 10, :o2, 1540688400
            tz.transition 2019, 3, :o3, 1553994000
            tz.transition 2019, 10, :o2, 1572138000
            tz.transition 2020, 3, :o3, 1585443600
            tz.transition 2020, 10, :o2, 1603587600
            tz.transition 2021, 3, :o3, 1616893200
            tz.transition 2021, 10, :o2, 1635642000
            tz.transition 2022, 3, :o3, 1648342800
            tz.transition 2022, 10, :o2, 1667091600
            tz.transition 2023, 3, :o3, 1679792400
            tz.transition 2023, 10, :o2, 1698541200
            tz.transition 2024, 3, :o3, 1711846800
            tz.transition 2024, 10, :o2, 1729990800
            tz.transition 2025, 3, :o3, 1743296400
            tz.transition 2025, 10, :o2, 1761440400
            tz.transition 2026, 3, :o3, 1774746000
            tz.transition 2026, 10, :o2, 1792890000
            tz.transition 2027, 3, :o3, 1806195600
            tz.transition 2027, 10, :o2, 1824944400
            tz.transition 2028, 3, :o3, 1837645200
            tz.transition 2028, 10, :o2, 1856394000
            tz.transition 2029, 3, :o3, 1869094800
            tz.transition 2029, 10, :o2, 1887843600
            tz.transition 2030, 3, :o3, 1901149200
            tz.transition 2030, 10, :o2, 1919293200
            tz.transition 2031, 3, :o3, 1932598800
            tz.transition 2031, 10, :o2, 1950742800
            tz.transition 2032, 3, :o3, 1964048400
            tz.transition 2032, 10, :o2, 1982797200
            tz.transition 2033, 3, :o3, 1995498000
            tz.transition 2033, 10, :o2, 2014246800
            tz.transition 2034, 3, :o3, 2026947600
            tz.transition 2034, 10, :o2, 2045696400
            tz.transition 2035, 3, :o3, 2058397200
            tz.transition 2035, 10, :o2, 2077146000
            tz.transition 2036, 3, :o3, 2090451600
            tz.transition 2036, 10, :o2, 2108595600
            tz.transition 2037, 3, :o3, 2121901200
            tz.transition 2037, 10, :o2, 2140045200
            tz.transition 2038, 3, :o3, 2153350800, 59172253, 24
            tz.transition 2038, 10, :o2, 2172099600, 59177461, 24
            tz.transition 2039, 3, :o3, 2184800400, 59180989, 24
            tz.transition 2039, 10, :o2, 2203549200, 59186197, 24
            tz.transition 2040, 3, :o3, 2216250000, 59189725, 24
            tz.transition 2040, 10, :o2, 2234998800, 59194933, 24
            tz.transition 2041, 3, :o3, 2248304400, 59198629, 24
            tz.transition 2041, 10, :o2, 2266448400, 59203669, 24
            tz.transition 2042, 3, :o3, 2279754000, 59207365, 24
            tz.transition 2042, 10, :o2, 2297898000, 59212405, 24
            tz.transition 2043, 3, :o3, 2311203600, 59216101, 24
            tz.transition 2043, 10, :o2, 2329347600, 59221141, 24
            tz.transition 2044, 3, :o3, 2342653200, 59224837, 24
            tz.transition 2044, 10, :o2, 2361402000, 59230045, 24
            tz.transition 2045, 3, :o3, 2374102800, 59233573, 24
            tz.transition 2045, 10, :o2, 2392851600, 59238781, 24
            tz.transition 2046, 3, :o3, 2405552400, 59242309, 24
            tz.transition 2046, 10, :o2, 2424301200, 59247517, 24
            tz.transition 2047, 3, :o3, 2437606800, 59251213, 24
            tz.transition 2047, 10, :o2, 2455750800, 59256253, 24
            tz.transition 2048, 3, :o3, 2469056400, 59259949, 24
            tz.transition 2048, 10, :o2, 2487200400, 59264989, 24
            tz.transition 2049, 3, :o3, 2500506000, 59268685, 24
            tz.transition 2049, 10, :o2, 2519254800, 59273893, 24
            tz.transition 2050, 3, :o3, 2531955600, 59277421, 24
            tz.transition 2050, 10, :o2, 2550704400, 59282629, 24
            tz.transition 2051, 3, :o3, 2563405200, 59286157, 24
            tz.transition 2051, 10, :o2, 2582154000, 59291365, 24
            tz.transition 2052, 3, :o3, 2595459600, 59295061, 24
            tz.transition 2052, 10, :o2, 2613603600, 59300101, 24
            tz.transition 2053, 3, :o3, 2626909200, 59303797, 24
            tz.transition 2053, 10, :o2, 2645053200, 59308837, 24
            tz.transition 2054, 3, :o3, 2658358800, 59312533, 24
            tz.transition 2054, 10, :o2, 2676502800, 59317573, 24
            tz.transition 2055, 3, :o3, 2689808400, 59321269, 24
            tz.transition 2055, 10, :o2, 2708557200, 59326477, 24
            tz.transition 2056, 3, :o3, 2721258000, 59330005, 24
            tz.transition 2056, 10, :o2, 2740006800, 59335213, 24
            tz.transition 2057, 3, :o3, 2752707600, 59338741, 24
            tz.transition 2057, 10, :o2, 2771456400, 59343949, 24
            tz.transition 2058, 3, :o3, 2784762000, 59347645, 24
            tz.transition 2058, 10, :o2, 2802906000, 59352685, 24
            tz.transition 2059, 3, :o3, 2816211600, 59356381, 24
            tz.transition 2059, 10, :o2, 2834355600, 59361421, 24
            tz.transition 2060, 3, :o3, 2847661200, 59365117, 24
            tz.transition 2060, 10, :o2, 2866410000, 59370325, 24
            tz.transition 2061, 3, :o3, 2879110800, 59373853, 24
            tz.transition 2061, 10, :o2, 2897859600, 59379061, 24
            tz.transition 2062, 3, :o3, 2910560400, 59382589, 24
            tz.transition 2062, 10, :o2, 2929309200, 59387797, 24
            tz.transition 2063, 3, :o3, 2942010000, 59391325, 24
            tz.transition 2063, 10, :o2, 2960758800, 59396533, 24
            tz.transition 2064, 3, :o3, 2974064400, 59400229, 24
            tz.transition 2064, 10, :o2, 2992208400, 59405269, 24
            tz.transition 2065, 3, :o3, 3005514000, 59408965, 24
            tz.transition 2065, 10, :o2, 3023658000, 59414005, 24
            tz.transition 2066, 3, :o3, 3036963600, 59417701, 24
            tz.transition 2066, 10, :o2, 3055712400, 59422909, 24
            tz.transition 2067, 3, :o3, 3068413200, 59426437, 24
            tz.transition 2067, 10, :o2, 3087162000, 59431645, 24
            tz.transition 2068, 3, :o3, 3099862800, 59435173, 24
            tz.transition 2068, 10, :o2, 3118611600, 59440381, 24
          end
        end
      end
    end
  end
end

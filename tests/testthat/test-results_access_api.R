context("results directions")


test_that("directions results are accessed", {

  ## simulate api result
  lst <- structure(list(geocoded_waypoints = structure(list(geocoder_status = c("OK",
                  "OK"), place_id = c("ChIJSSKDr7ZC1moRTsSnSV5BnuM", "ChIJgWIaV5VC1moR-bKgR9ZfV2M"
                  ), types = list(c("establishment", "point_of_interest", "train_station",
                  "transit_station"), c("establishment", "point_of_interest", "stadium"
                  ))), .Names = c("geocoder_status", "place_id", "types"), class = "data.frame", row.names = 1:2),
                  routes = structure(list(bounds = structure(list(northeast = structure(list(
                  lat = -37.8152149, lng = 144.9812441), .Names = c("lat",
                  "lng"), class = "data.frame", row.names = 1L), southwest = structure(list(
                  lat = -37.820145, lng = 144.9673655), .Names = c("lat",
                  "lng"), class = "data.frame", row.names = 1L)), .Names = c("northeast",
                  "southwest"), class = "data.frame", row.names = 1L), copyrights = "Map data ©2017 Google",
                  legs = list(structure(list(distance = structure(list(
                  text = "1.7 km", value = 1713L), .Names = c("text",
                  "value"), class = "data.frame", row.names = 1L), duration = structure(list(
                  text = "4 mins", value = 261L), .Names = c("text",
                  "value"), class = "data.frame", row.names = 1L), duration_in_traffic = structure(list(
                  text = "7 mins", value = 415L), .Names = c("text",
                  "value"), class = "data.frame", row.names = 1L), end_address = "Brunton Ave, Richmond VIC 3002, Australia",
                  end_location = structure(list(lat = -37.820145, lng = 144.9812441), .Names = c("lat",
                  "lng"), class = "data.frame", row.names = 1L), start_address = "Flinders St, Melbourne VIC 3000, Australia",
                  start_location = structure(list(lat = -37.8176161,
                  lng = 144.967431), .Names = c("lat", "lng"), class = "data.frame", row.names = 1L),
                  steps = list(structure(list(distance = structure(list(
                  text = c("8 m", "1.1 km", "0.4 km", "0.3 km"),
                  value = c(8L, 1091L, 358L, 256L)), .Names = c("text",
                  "value"), class = "data.frame", row.names = c(NA,
                  4L)), duration = structure(list(text = c("1 min",
                  "3 mins", "1 min", "1 min"), value = c(2L, 188L,
                  53L, 18L)), .Names = c("text", "value"), class = "data.frame", row.names = c(NA,
                  4L)), end_location = structure(list(lat = c(-37.8175485,
                  -37.8156447, -37.8187392, -37.820145), lng = c(144.9674052,
                  144.9790637, 144.9789338, 144.9812441)), .Names = c("lat",
                  "lng"), class = "data.frame", row.names = c(NA, 4L
                  )), html_instructions = c("Head <b>north</b> on <b>St Kilda Rd</b>/<b>Swanston St</b> toward <b>Flinders St</b>/<b>State Route 30</b>",
                  "Turn <b>right</b> at the 1st cross street onto <b>Flinders St</b>/<b>State Route 30</b><div style=\"font-size:0.9em\">Continue to follow State Route 30</div>",
                  "Turn <b>right</b> onto <b>Jolimont Rd</b>", "<b>Jolimont Rd</b> turns slightly <b>left</b> and becomes <b>Brunton Ave</b>"
                  ), polyline = structure(list(points = c("bgyeFm}xsZMB",
                  "tfyeFi}xsZOBMBCS]wBGYaAyECMESUgAIYWqA{@kEq@gDMm@Oy@[_BG]Mo@_A}EEWAQ?OAQ@Oj@gLB[@KDaAZuF",
                  "vzxeFcf{sZ@K@KTBp@FtALnALxD^XDZBTBZ?@?HAPCLEPKXK",
                  "bnyeFie{sZFMXi@hEqIj@cA")), .Names = "points", class = "data.frame", row.names = c(NA,
                  4L)), start_location = structure(list(lat = c(-37.8176161,
                  -37.8175485, -37.8156447, -37.8187392), lng = c(144.967431,
                  144.9674052, 144.9790637, 144.9789338)), .Names = c("lat",
                  "lng"), class = "data.frame", row.names = c(NA, 4L
                  )), travel_mode = c("DRIVING", "DRIVING", "DRIVING",
                  "DRIVING"), maneuver = c(NA, "turn-right", "turn-right",
                  NA)), .Names = c("distance", "duration", "end_location",
                  "html_instructions", "polyline", "start_location",
                  "travel_mode", "maneuver"), class = "data.frame", row.names = c(NA,
                  4L))), traffic_speed_entry = list(list()), via_waypoint = list(
                  list())), .Names = c("distance", "duration",
                  "duration_in_traffic", "end_address", "end_location",
                  "start_address", "start_location", "steps", "traffic_speed_entry",
                  "via_waypoint"), class = "data.frame", row.names = 1L)),
                  overview_polyline = structure(list(points = "bgyeFm}xsZ]FMBCSe@qCeAgF}@gEkC{MqBkKIkAr@_Nd@oIrNtA\\?ZE^QXKFMbF{Jj@cA"), .Names = "points", class = "data.frame", row.names = 1L),
                  summary = "State Route 30", warnings = list(list()),
                  waypoint_order = list(list())), .Names = c("bounds",
                  "copyrights", "legs", "overview_polyline", "summary", "warnings",
                  "waypoint_order"), class = "data.frame", row.names = 1L),
                  status = "OK"), .Names = c("geocoded_waypoints", "routes",
                  "status"))

  expect_true(class(direction_instructions(lst)) == "character")
  expect_true(class(direction_routes(lst)) == "data.frame")
  expect_true(class(direction_legs(lst)) == "data.frame")
  expect_true(class(direction_points(lst)) == "character")
  expect_true(direction_polyline(lst) == "bgyeFm}xsZ]FMBCSe@qCeAgF}@gEkC{MqBkKIkAr@_Nd@oIrNtA\\?ZE^QXKFMbF{Jj@cA")
  expect_true(class(direction_steps(lst)) == "data.frame")

})

test_that("distance results are accessed", {

  res <- structure(list(destination_addresses = "Brunton Ave, Richmond VIC 3002, Australia",
                    origin_addresses = "Flinders St, Melbourne VIC, Australia",
                    rows = structure(list(elements = list(structure(list(distance = structure(list(
                    text = "2.2 km", value = 2248L), .Names = c("text", "value"
                    ), class = "data.frame", row.names = 1L), duration = structure(list(
                    text = "8 mins", value = 490L), .Names = c("text", "value"
                    ), class = "data.frame", row.names = 1L), duration_in_traffic = structure(list(
                    text = "13 mins", value = 792L), .Names = c("text", "value"
                    ), class = "data.frame", row.names = 1L), status = "OK"), .Names = c("distance",
                    "duration", "duration_in_traffic", "status"), class = "data.frame", row.names = 1L))), .Names = "elements", class = "data.frame", row.names = 1L),
                    status = "OK"), .Names = c("destination_addresses", "origin_addresses",
                    "rows", "status"))

  expect_true(distance_origins(res) == "Flinders St, Melbourne VIC, Australia")
  expect_true(distance_destinations(res) == "Brunton Ave, Richmond VIC 3002, Australia")
  expect_true(class(distance_elements(res)) == "list")

})


test_that("elevation results are accessed", {

  res <- structure(list(results = structure(list(elevation = 29.594367980957,
                  location = structure(list(lat = -37.81659, lng = 144.9841), .Names = c("lat",
                  "lng"), class = "data.frame", row.names = 1L), resolution = 610.812927246094), .Names = c("elevation",
                  "location", "resolution"), class = "data.frame", row.names = 1L),
                  status = "OK"), .Names = c("results", "status"))

  expect_true(elevation_location(res)$lat == -37.81659)
  expect_true(elevation_location(res)$lng == 144.9841)
  expect_true(round(elevation(res), 5) == 29.59437)

})

test_that("geocode results are accessed", {

  res <- structure(list(results = structure(list(address_components = list(
    structure(list(long_name = c("Brunton Avenue", "Richmond",
    "Melbourne City", "Victoria", "Australia", "3002"), short_name = c("Brunton Ave",
    "Richmond", "Melbourne", "VIC", "AU", "3002"), types = list(
    "route", c("locality", "political"), c("administrative_area_level_2",
    "political"), c("administrative_area_level_1", "political"
    ), c("country", "political"), "postal_code")), .Names = c("long_name",
    "short_name", "types"), class = "data.frame", row.names = c(NA,
    6L))), formatted_address = "Brunton Ave, Richmond VIC 3002, Australia",
    geometry = structure(list(location = structure(list(lat = -37.8199669,
    lng = 144.9834493), .Names = c("lat", "lng"), class = "data.frame", row.names = 1L),
    location_type = "GEOMETRIC_CENTER", viewport = structure(list(
    northeast = structure(list(lat = -37.8186179197085,
    lng = 144.984798280291), .Names = c("lat", "lng"
    ), class = "data.frame", row.names = 1L), southwest = structure(list(
    lat = -37.8213158802915, lng = 144.982100319709), .Names = c("lat",
    "lng"), class = "data.frame", row.names = 1L)), .Names = c("northeast",
    "southwest"), class = "data.frame", row.names = 1L)), .Names = c("location",
    "location_type", "viewport"), class = "data.frame", row.names = 1L),
    place_id = "ChIJgWIaV5VC1moR-bKgR9ZfV2M", types = list(c("establishment",
    "point_of_interest", "stadium"))), .Names = c("address_components",
    "formatted_address", "geometry", "place_id", "types"), class = "data.frame", row.names = 1L),
    status = "OK"), .Names = c("results", "status"))

  expect_true(geocode_address(res) == "Brunton Ave, Richmond VIC 3002, Australia")
  expect_true(class(geocode_address_components(res)) == "data.frame")
  expect_true(geocode_coordinates(res)$lat == -37.8199669)
  expect_true(geocode_coordinates(res)$lng == 144.9834493)
  expect_true(geocode_place(res) == "ChIJgWIaV5VC1moR-bKgR9ZfV2M")
  expect_true(geocode_type(res)[[1]][3] == "stadium")

})

test_that("places results are accessed", {

  res <- structure(list(html_attributions = list(), next_page_token = "CpQCDAEAAF2T00DxAqeB_nx3FMGzTgWGOP_UKWI7prb8i6GeFEWxpIxNn_byqD5qvfY6nbGjkPEeGZUjxatKKdWIhajoLFAYCpUM-uBBIK6m4mqZs1rIQIfPv05zgY_-InBsZX2ynVDRANBZTq3kkJF3fGXn7nF1BX_YxVGbqDB5spYk2i9lxHL0zWIS9ZYmD5qowaw00noQ5hlyyCY1qxGMsF0DXVeUQbpECQGHQNT52k8gApw0Jo3gBh-hkkZO0fNikHi79EqtC4BJD2ZJ2Us4VdytadaUfYWwau8REwc655GWroAuD2--KvadmH67X0AZpuX-0f_2hH4HHxRwPjPW2bv4HSGlFw_2YeNQB6ww8V1Ry8WrEhDM8nrx0tpYa2NRDgumWLzVGhS5sm92Kwo0zrgp80B2fo8QbP3MWA",
           results = structure(list(formatted_address = c("43 Little Bourke St, Melbourne VIC 3000, Australia",
           "55, Rialto Towers, 525 Collins St, Melbourne VIC 3000, Australia",
           "141 Flinders Ln, Melbourne VIC 3000, Australia", "187 Flinders Ln, Melbourne VIC 3000, Australia",
           "21 Bond St, Melbourne VIC 3000, Australia", "362 Little Bourke St, Melbourne VIC 3000, Australia",
           "14 Lansdowne St, East Melbourne VIC 3002, Australia", "Rydges, 186 Exhibition St, Melbourne VIC 3000, Australia",
           "130 Lygon St, Carlton VIC 3053, Australia", "1 Parliament Pl, Melbourne VIC 3002, Australia",
           "131 Lonsdale St, Melbourne VIC 3000, Australia", "80 Bourke St, Melbourne VIC 3000, Australia",
           "1 Hosier Ln, Melbourne VIC 3000, Australia", "6 Melbourne Pl, Melbourne VIC 3000, Australia",
           "55/57 Gertrude St, Fitzroy VIC 3065, Australia", "54-58 Hardware Ln, Melbourne VIC 3000, Australia",
           "180 Flinders Ln, Melbourne VIC 3000, Australia", "209 Lygon St, Carlton VIC 3053, Australia",
           "191 Nicholson St, Carlton VIC 3053, Australia", "361 Little Bourke St, Melbourne VIC 3000, Australia"
           ), geometry = structure(list(location = structure(list(lat = c(-37.8108555,
           -37.818542, -37.8158262, -37.81631, -37.8181937, -37.813468,
           -37.8093627, -37.8111574, -37.8040394, -37.811356, -37.810779,
           -37.8117782, -37.8166265, -37.813483, -37.805421, -37.8133437,
           -37.8159557, -37.8004451, -37.795687, -37.8135378), lng = c(144.9713535,
           144.95751, 144.9698925, 144.968326, 144.9625532, 144.961833,
           144.9785789, 144.9706589, 144.9666596, 144.976589, 144.9685513,
           144.9708405, 144.9691308, 144.968884, 144.97595, 144.9611488,
           144.9682654, 144.9668378, 144.974923, 144.9619798)), .Names = c("lat",
           "lng"), class = "data.frame", row.names = c(NA, 20L)), viewport = structure(list(
           northeast = structure(list(lat = c(-37.8094531197085,
           -37.8170232197085, -37.8143898197085, -37.8148559197085,
           -37.8168182697085, -37.8121389697085, -37.8080088697085,
           -37.8098663697085, -37.8026769697085, -37.8099603697085,
           -37.8093037697085, -37.8105291197085, -37.8152723197085,
           -37.8121078697085, -37.8041708697085, -37.8120631197085,
           -37.8146721197085, -37.7990998697085, -37.7943533197085,
           -37.8121642697085), lng = c(144.972678130292, 144.958778480291,
           144.971201430292, 144.969652680291, 144.963997630291,
           144.963191330291, 144.979874380292, 144.971804480291,
           144.967883780291, 144.977388380292, 144.969841380292,
           144.972236130291, 144.970498630292, 144.970214830291,
           144.977282630292, 144.962540080291, 144.969645080292,
           144.968225030292, 144.976414080292, 144.963334530291)), .Names = c("lat",
           "lng"), class = "data.frame", row.names = c(NA, 20L)),
           southwest = structure(list(lat = c(-37.8121510802915,
           -37.8197211802915, -37.8170877802915, -37.8175538802915,
           -37.8195162302915, -37.8148369302915, -37.8107068302915,
           -37.8125643302915, -37.8053749302915, -37.8126583302915,
           -37.8120017302915, -37.8132270802915, -37.8179702802915,
           -37.8148058302915, -37.8068688302915, -37.8147610802915,
           -37.8173700802915, -37.8017978302915, -37.7970512802915,
           -37.8148622302915), lng = c(144.969980169708, 144.956080519709,
           144.968503469709, 144.966954719708, 144.961299669708,
           144.960493369709, 144.977176419709, 144.969106519709,
           144.965185819708, 144.974690419709, 144.967143419708,
           144.969538169708, 144.967800669709, 144.967516869709,
           144.974584669708, 144.959842119708, 144.966947119708,
           144.965527069708, 144.973716119709, 144.960636569708)), .Names = c("lat",
           "lng"), class = "data.frame", row.names = c(NA, 20L))), .Names = c("northeast",
           "southwest"), class = "data.frame", row.names = c(NA, 20L
           ))), .Names = c("location", "viewport"), class = "data.frame", row.names = c(NA,
           20L)), icon = c("https://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
           "https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"
           ), id = c("e070c93523af70b41c211addccca5b275f334fa2", "ec3a77fd5bb69c2152981f4fa41066dea2ffec4f",
           "7927f2b8f907b476093c114482f3784a4d7fbdef", "dd5bdc13ac6645737e56cbe2e6c0c8fd83ff5d00",
           "df25de3459afa2330c5f053588c9f1c0386ac51b", "33e11f28ea88af40ca3fa040848f7ef0d4880b8d",
           "7b046af09fc1a9f1bbd35e9503450723ec711f1f", "e5fbb4562642bcf67163b648ebe296dd01526227",
           "56df6dc16eb249913bdec1c0aec00f8ebe100a40", "8a32f2b38a90ca0c1becd20f4e8076e958db5ea4",
           "eb8604e92700e68b913d78e6ad4629dc76d3cb2c", "a7cac7a91bec21e5ae1be773de32c54aa66a4d96",
           "76327b9b6a5d35088540bed156edced9d35fa4fe", "5fff0ad61c984cddf1a8e5f2caf5f51bf27132d2",
           "870ff99646b8ea579f02462af09de7b4d603d35c", "5237e1bb4f897c61c61e88a2c5c2d9fb652651c7",
           "a5a6b49135078e963c9b5432a000bc1192271409", "2ea3f41c27b85e3ebf602c8ff75e5dc20b823f10",
           "13fc0bec322dbc89dc9eca0e3988c858f56deb2e", "b6974ccb8599c3e2f80de967555b21a851d2bda4"
           ), name = c("Punch Lane Wine Bar & Restaurant", "Vue de monde",
           "Coda", "EZARD", "Maha", "+39 Pizzeria", "Zio's Restaurant",
           "Locanda Restaurant & Bar", "Da Guido La Pasta Melbourne",
           "radii restaurant & bar", "Encore Restaurant & Bar", "Grossi Florentino",
           "MoVida", "Sezar Restaurant", "Cutler & Co", "Max on Hardware",
           "Supernormal", "iL Cantuccio Restaurant", "Scopri Italian Food & Wine",
           "Tipo 00"), opening_hours = structure(list(open_now = c(TRUE,
           TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
           TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE), weekday_text = list(
           list(), list(), list(), list(), list(), list(), list(),
           list(), list(), list(), list(), list(), list(), list(),
           list(), list(), list(), list(), list(), list())), .Names = c("open_now",
           "weekday_text"), class = "data.frame", row.names = c(NA,
           20L)), photos = list(structure(list(height = 1032L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/106568213273976686957/photos\">Punch Lane Wine Bar &amp; Restaurant</a>"),
           photo_reference = "CmRaAAAAD8LD5cUbnJFYNq2wNSms-3MFIHFtYoYO1Jb4jTq-9rLQCT8Gl_3jUCSRRRLuSBwbpuLhPrb-4CrzehCmqla0YyiNiPWkRdblaWsMwklxySp_TA3MDi4Pp_04-SUhTKqyEhDwELGkMtBFfDkx-MndQVe7GhShgjL7JoI3YFIGBt9o_2m8sElgkg",
           width = 1032L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 667L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/112700120194708351472/photos\">Vue de monde</a>"),
           photo_reference = "CmRaAAAAT_-omlyjx2b6LnNMZi6f9-EHp4SxVCW2IDYiPrQ-B6MWMax0QrtfvdVeKuK9-uFfeV5sAh-eqAhx4-Is2IoV__ZFWDjpOpKWXp3jWnBXZMnXQBNFqyqSI8XppXCLb5mSEhDyTJYVMsq-hvYk7bpf0KhYGhRDoRbE7Fmc_13Mu7MQYmWaTFTbkA",
           width = 1000L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 727L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/103992165722521077101/photos\">Coda</a>"),
           photo_reference = "CmRaAAAA0hDu8W08Aq8soCyFoPbUKDuP14lWT7p5me80NM52s5P87TWy9CdfDUcywMOIF_BwCAB4NvI7VI8_XDMN4X7iG3i8XDHllWfkaJNhTboxb050z2eeGlSV-YXAtJGNFdU4EhAaTrGqCO_anULKI_cdI3qGGhTChbTfeFrjTbvsrnjwxvRkBTtL0A",
           width = 966L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 1265L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/107194590680679069667/photos\">Frank Chun Yat Li</a>"),
           photo_reference = "CmRaAAAANs0BWbJHdfz1PskJ9FARLR-qMa4aHcgmdo-ZYjH7rB65Tk7BPzujA73D0Tzmg-gm0r-wiMry3wW9dG1s9hxFiPo3jECiFdEaiQgS-6ZpHUcbMAyxitGWY9vtMhS-j7vMEhBFgjTPF2hqP6uLGYbCTRYnGhSIVFKPhv2qXjFANY84OSIF_6jh0Q",
           width = 2048L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 3036L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/114960260011525378713/photos\">jeremy loy</a>"),
           photo_reference = "CmRaAAAAJ8cmBrco7VIBM88debMlCEBUq0qnGiWjZHb388a8wZCwgc5dOFfDUEXHcBPLzSgtuUbOnJCapEOX33kXaXI0rzqxhirc9JLfwSIQbESlEsmNBp_IfbljTOZQwRFdiWOjEhC29auYlCiGZ_zCge7bv7rNGhQ9Av9uZWNX8BLlzFsaOh9OGl7LmA",
           width = 4048L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 2446L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/113094499008960966495/photos\">Gary Mak</a>"),
           photo_reference = "CmRaAAAAA55CJZJUbh9wDpaybOZxtMHoAdw3z1RKHuIwKb5U4t2RtzhVBIOqmP9BpjuWh3txmxy01XCGR2-6aZsB4aVRndEhbAvonHGLjs8yQv9zuXpeAlWLi1ynZZVWiwT_lzJcEhAV-rR1COploUHm5-MvFaYmGhTjA_KRfMJ3qcpy516GreElWunMuQ",
           width = 2854L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 250L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/116871306404808485412/photos\">Zio&#39;s Restaurant</a>"),
           photo_reference = "CmRaAAAA4hCaHDxgTvtEefWk0LSB92NDdPBoGvwNGJIo9_O5OYuMb5PX5HsORMF1sVwpr0lXXJ0oLBXlr5cQgJKAulsy2svXlC-XwTEOLuGuKP9B2Pks1wRFyGe8iUYOozD0N4iLEhAysgF1q26PjRjDzXvpR1hTGhSYeeR86uUcNyLspKJ1lw824gkxWA",
           width = 250L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 1042L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/110206364899611325116/photos\">Locanda Restaurant &amp; Bar</a>"),
           photo_reference = "CmRaAAAAqtrg0SynD9cFiumfnuplKFPTiMGWXnEbPmCqdRvDI5lSn5iTusl1hy5jqBTUucUjXSA0EyGxNKiaolBzPWB_kg8JVYJGCOq17qaxuYvQJEFfDHOloGTRzCcMq3lyFXxlEhA4MJ1px8-oza0DpGDPejEGGhThMlHjxNwqjpOg_9RuGaUgysxUoA",
           width = 1564L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 3024L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/116078980474243405063/photos\">Paul Kwan</a>"),
           photo_reference = "CmRZAAAAq2ALikhC2-zZg7Lxqt1MLxlvXfeiWp4Ue7upCLIhwM31hnZLNundZxf-14OFNSlDBdwINV9lbHKsVBw_Uv28NHTn-ihi98m76-8xlf6KzmiBAMT4BWqNoIBigV33j5qVEhCPocEOApOnI1Vsp-lrLuH_GhSQfzWywBiPRop117M0tXJmNTfVBg",
           width = 4032L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 467L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/114893030610098020423/photos\">radii restaurant &amp; bar</a>"),
           photo_reference = "CmRaAAAAqnTBbeET2-j-39OQ98RmPSIjjA13-J4cIrItCQ1XukcDx4aLNqtPipkkWLsL1UNhXzeeEnT4l5wObHJ1I5R7VTyyvPISfHwWeIN5ENRCXy6sDw02TxL3HMrlk_62FnXxEhAbjvqaBK_4iatp6S3HQGNRGhSqjio0eTPRLUwjjNJAMcdUWOnI2w",
           width = 700L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 922L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/102105376111441414564/photos\">Encore Restaurant &amp; Bar</a>"),
           photo_reference = "CmRaAAAAY9LQ5d1MvOJUwA8NFjhcs2DeJ0Pu7Rwsevsp71WjjGJ0WPuqPmV2rPovnRzrLLW00xAYIwoAGRpUp-PJpbDK9N2jowVua6P8kwg19Zj1le230nBrtV8JMtYgIZIZA1smEhBb7bepal41UgxHPdBQJZn_GhT08wlAjuIxqsTz-lowpHLBsMUrJA",
           width = 1229L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 1575L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/111413248075159844603/photos\">Grossi Florentino</a>"),
           photo_reference = "CmRaAAAAjBa2cl8Bb0Ynt29Rv2jzfa31fm5xM2pw71hdL4Mi-Ea68e1W9jF5fYCZjCWZnizS800CJO0h48qZhO90smBJhjuKTBYCLJLIBl7ZNCaS6lw2CX0OtGUuDpKo_a-cjwKzEhA9IPhAEQlJ3y9aYAzBe1sNGhRpknRLISxXvoGUKaRroVBu3W0ajw",
           width = 2362L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 800L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/108393454693012743261/photos\">MoVida</a>"),
           photo_reference = "CmRaAAAA9ot-Fjmvh6TiFFtMmp26LBeyUi44ciWo_c45jR4q_dUMURq2JfeTzDKrOYnNUH1mcnPf_7tep1pGMFKqLzxE0Wj0yturXCyAetQhgi9tIu9o7eDEFUINc2QK_QxIjZMEEhCTDElTdVUxT_myOY40XXMfGhRPMsdNRQgSJS2Gu1ao8TIVxsaUoA",
           width = 1200L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 1365L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/102742571670626263291/photos\">Sezar Restaurant</a>"),
           photo_reference = "CmRaAAAA_iy1cqxZy5mltS3n_ylN5Bvl0udhxllg9EmO3hhse5s4al6qzS3VlIUY3R73Z5Hwcy8UBVs60ZL6-SXbbI115p2XCoPKOp9_PwFCYq2ymNDUcJdRIaENLhNlkxd35JFhEhAUy-gCaueAVBRH_TwkWV_uGhQAyTj71vPd553dA5ngyrRsMdYxLg",
           width = 2048L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 2310L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/109355396140674867459/photos\">Peter Williams</a>"),
           photo_reference = "CmRaAAAAsKlTsLD575ILM9-DWEZTQqvO_Va9jOD9IZJbFsmZD_EZsrY1TTXbNtk-BCG1qY3wSN22vACz2mI6nSlXWxH3WATIIQ8UJc_v8kuKhokfRCBoWjmbbqVPQx47S0bCdzqlEhBlEU5v1vBt4yI-g9Q0X2AbGhS4trAvi7Czop3fe1h8acsvFsDbeQ",
           width = 4010L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 3024L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/105548647092879722279/photos\">Michael SNOSWELL</a>"),
           photo_reference = "CmRaAAAAXHivAvpVfjka38t-nAGkX-fBeKlEV-KVkECkPWhxqqMejUXxrZAHf8yCV-McR3_lmDDGEBQSeT0Pp7_uC6_MY8tbl6LkYfR5uWXpY-Xlc1tMKJplfxxZl1nLv7BOkZLJEhA5AZAfaZTGp1mO2-RicRf8GhR5c-_-gH_Iu4fh5T2AOdwT99rBLA",
           width = 4032L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 640L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/112232723682380326305/photos\">Supernormal</a>"),
           photo_reference = "CmRaAAAAxo3cMacpiUa3BiB2Ptco5Hv8AVWh8Y-UEzOdcqzUmpsepzjhX7UUq7cYghh2cR5inkS73OK-l6LYiDYJRkfCzXOQjDMk9LLd6nKpMMYTZMJHKNkrtpEKQIwRBN_giIQeEhBL8678PRTXfwTFdtyjlUvUGhQGT2Vguf0uN1WAfZaI8pzth0V6_A",
           width = 640L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 1365L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/101314772091254879989/photos\">iL Cantuccio Restaurant</a>"),
           photo_reference = "CmRaAAAAOfbskkn0a7hEv4v1JpbWDsagBTgyk60HYglErKOk2XW5B9FBEzJ63HTQvM1pvUAZhijEAdiJZu1xaeggZP_LJoB6jwO0gWhAH_vVxreAXa-rE_9dQ6P65zeMjOftso36EhBBQCJWWvQFmv1anXGGgJrdGhQFzslSNu_3veC7zk-8YYVjBLaJ9Q",
           width = 2048L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 3024L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/100160260800294695981/photos\">Paul Gradie</a>"),
           photo_reference = "CmRaAAAA5KN-HyEe-rSGEwrvXRMHiqcfcraorJnjnIJHy6PHhFeZ5Ae4nuUTBDl2wparWOwmqLWB-n68_Hiv4HIG8lkoiVMwB1QQwQCv9II-vxn9CgZzIRc-MoAbCULsz18igxQGEhAdIKxFHe7CzM9dRVr6mQAjGhRTVZij37GJYHlv0QfX5elxXlDneA",
           width = 4032L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L),
           structure(list(height = 1836L, html_attributions = list(
           "<a href=\"https://maps.google.com/maps/contrib/104554682391632193879/photos\">Peter Kanatlarovski</a>"),
           photo_reference = "CmRaAAAAaqxwBP0EZQI8V3MV2gSCapJEc0H1cfjtEVTZ7z-oeX1WMVbd42RsIXnbLHlzujMOPKULkhWyGF7VOZFtTsoVjsbogmiPOI4ZXG7vWq-wbiTSLwt_PDMCebVgwL3nOhvEEhAyCtg3qfx-AIfrYPelmFz2GhQS93CuMifmWBMWZ4fhJDUHygTruw",
           width = 3264L), .Names = c("height", "html_attributions",
           "photo_reference", "width"), class = "data.frame", row.names = 1L)),
           place_id = c("ChIJxbZOsshC1moR7thhGoEJ11s", "ChIJ4_Vc6dZC1moRlwIXnmb2SgA",
           "ChIJ9duozrdC1moRtuPvobzf_Zs", "ChIJt6dyXLZC1moR9oZuaqOPJU8",
           "ChIJizFTarNC1moRjM6M4Z_OGAg", "ChIJczdsN7VC1moR-QK-RzI-pJw",
           "ChIJUfuGRMNC1moRidwRU5zUmS8", "ChIJGx34w8hC1moRSgY_PLlmshg",
           "ChIJJb5IAtJC1moRotUKafEC8ao", "ChIJN92GPsRC1moRrpvO-n_3bvw",
           "ChIJ53vEPslC1moR0ox6S2TyszU", "ChIJZTDR6shC1moRq3z8gjwyzcg",
           "ChIJjUllVLZC1moRFJto433jNAY", "ChIJyYFFyMlC1moRb22GPrHVal8",
           "ChIJI_PKDttC1moRpfu7sQfxfFM", "ChIJYSmyK8hC1moRBj7OVQ2UhkA",
           "ChIJNVF8Q7ZC1moRarO5qwt4NOA", "ChIJDQtwV9FC1moRjegT_YOTJjo",
           "ChIJJZA5ACdD1moRxIAdHMr3F4s", "ChIJbza9ObVC1moRwyyqYG9efx4"
           ), price_level = c(3L, 3L, 3L, 4L, 1L, 1L, 2L, 1L, 1L,
           2L, 1L, 3L, 2L, 2L, 3L, 1L, NA, 1L, 2L, NA), rating = c(4.5,
           4.4, 4.4, 4.2, 4.4, 4.3, 4.2, 3.5, 4.5, 3.7, 3.8, 4.4,
           4.4, 4.4, 4.4, 3.9, 4.5, 4.6, 4.7, 4.5), reference = c("CmRRAAAAzefJWsKdv1N3F1DruIliBxSB3U0BJZAh5gVwFZ5IlziYVPTFkJrvXuuT76kq_IeqrrTQdYIxDW5AZUsOXSaL5SjcpNarSs2xoz7kXjBRAwImg_f7zZ9ekfwGGOcywn_pEhCNxZs3bkNoLB9jfW7sh8DuGhSc8KpJPpe0-8V39rNsinYP3KZjdw",
           "ClRQAAAAUU0TAZ8XeyCSVO5J_jXjdWMTQ348pKscygDY-V473UIybnvWPbhDlYn24_jBTIkqrgtbphqAsKUCSx01sLXXkHavV5Cit21AizTvnbybBQkSEKcd1xJVsDC9gaNcKVBZbPcaFNZfSCj4bvyV2HEv92ktGNo08h9e",
           "CmRSAAAAl0MlcBjJhGUW694qLklc0FIyaIqUoU4GDjfQCUNbpEGe25jDJC3DHIZaQmHaultRBXasWku865b3aGOcTQvTZ2vRLLZLcZ56m7gDkS2YHjhL3cX77eVfayC06CCSp7XsEhDItr8nXNmaBTVnmHwRFYmvGhRBvKKxqBU6ciGy3bDH6-OpyJYxFw",
           "CmRRAAAATBaM-hSl8RwyhleIsLv4cJAvZR8QUF6fw7ncQBRdUKyB1qYUkP_XtzPUNhX7_0fvkvrRRVH7XTx4K5Yr0Ni7PpQEYU7XX-d6GNLXTusWxNH-kLaydd7eXZJB9Wnj6FByEhBpPCh-CMt2YHFnIQbrItC_GhRCavKufT5QXbDki8hheXStzscOsQ",
           "CmRRAAAAznm0I2HTsiJhcXnwlN6vlGO8nI3_UQmXlIaYZnbBSmpea7QCTOxHx4lxYoWY7bRvmwQQC9_XvhO-Mdg8nRbydz4IRKtckizsxDlzQ-GSB4Xg-a5i3AcMmYc5N6Ldt-ZQEhAo44H10BV7-b7G0UnDUFzLGhSMkzpd66YIa-wtc3r6zufXS-7L2w",
           "CmRSAAAAdtj62GEH4HnUBHUpcaleYih57JXCyR_Rc2qmFP7QYkdZ7RVfgoK5lH7mVe0sq-423knX27v4sW83Btx5D-DMfu2nNS5uiJHfYPZuxNoDm3zF1PzweHhW1Asdxo2aj9gwEhCL-eOsLNTF6E5mp4UvvKpBGhSdLk0ucwfT-pufV1fMhhccOKHpXw",
           "CmRRAAAAgXhvQXzB_JC2AdwDGPPwZARxhxUMXxp7Fjvj8UotBxRxKrZNqcjNYwNLT0VhhtFdP3HOMakSxgfRrLgQ_whgg9rqfL3La9pSbumufk1DwdSoQdHViiMC6nRrAqyFAmcLEhDT8C__WldIl1LJEtMg3CqlGhQtwigfWTkTVjaWGXEK5yZo2r1mqA",
           "CmRRAAAAdKnrA-un8ti6IcIEi67rSupvRpFcmig6EqEpnrfszjVmtiWf1_ZiYSmIRBh5m_qviDqRHjTTTU_CmyVGqRINqydYPo2d50uky9ENP12T1LW0RiAfwn2viiLSI4Q3oUVdEhBFbrbqf7CAtMqYFcph5tWuGhQ3HC41P9WgD458PfuqIl5A86f4Eg",
           "CmRSAAAAsnJl9pjIGKJlTLFn3ExMwPwuRPIey-C3H-czKCXFBlGkePtHfREkqZdbTcobnEV9m6ZQ8fqOJC1jRurpDR22sM0e7ascJxER1Wyv7CNAUj91ezytJoWSklNDquMPjWtmEhD0g5fBA1Ee8EwACHNK-5RDGhRSc1Wv3sUchIx4fMH0hWtPE02pPw",
           "CmRSAAAAHi8ITRXrltKKdIxY-UZr-SwkY7YfhNzRf5vBPN8gda8hb6OG2KNcNIYUurELsROfv74dIJxbtNvQIZpJ_Paj9NkK8gJYIhRPb1wxAZIYmmrtCbNA8eyyHemJCcSDEwGnEhAl9jTpfsF3nfHDjqQqwqrLGhSRCTWkH8LCqsYLMjzZeqUYqahncw",
           "CmRRAAAA3ydsP9odlhbiU3g3yFQKMVOZKzFT-kzy-FRSeMVP07eUM5LGzE_uZ2jqwVaT01y9TOGG5c0N8y7Dia3M31VhMLy76464GN-9yD6dUTUQRHdh5iguHYVQXC0t8-b364UeEhDugMWuXGjSJDYOii6bL_nwGhTsYL5VSJNEOxQpQd9jKMpexSc2Fg",
           "CmRSAAAA9_JXKZQbrao9b0AO3usfW847XIs-XaYHUMMXmO7jb6Qou39V5j8BtgawU-QCNYyyozt1sn3_OGHB5HC8kuaCvRDjOi1Sj95SC0RBApSRsqU_Rf5w4Z4Kb2QJKQ2OJbt3EhBFzKCVakSbCbq4R4BwifFaGhRgtr-s5jGqNtKBXFkW3x3H1EuVAg",
           "CmRRAAAA-f-JWmT5K7RtygftHC0UeDSlni4QvAc0_hoUOMVuLdIPdFrZ7hJLfn5GN3bpZi9mwqHD3tuXUKTTXTa40XrbLtC491t-eqtxt5LoscfSv5DI_cZU33kmDipm49cJiZ5gEhDxvu20SX0exFTTbjEEZYcpGhQyth0oVrrRnIVHbG_ACFxhaqqLdQ",
           "CmRRAAAABGWRg1LrJh_42QNxy3Go5Mp43GcWvpcxaf7weP1sALp4A4ViLBUSCfz8c-PSKgFX8r7FDIFez30HscQLv-V07CrYlVne47iAvU0vxVcg2bm7IkLB7bTUzCuRlOLbL5U-EhChGi8A2tqVXgYKY8GN-Q73GhSIVn4sTHSjxk1ykTAbuKEBUMizwQ",
           "CmRRAAAAOUSdKBM_GExGAPVNscK1R0s-qean8zEuaOKrOrQQEKoZ1CNSuHZk6LOTl0sFwWQv3Hs0oTlvnV0BpJXVlJQqX1GVm7-MMNlecU_yjw8RFjjiyoJ_IiN0dlBWnZuYJyIJEhAbwc4CboVEjN4Zo9qHhUsqGhSElqxatoCLSFzp-5eAn9N1_yPqLg",
           "CmRRAAAA4RCV_SM_CcIzbjH7yNXPscvBA0n5BvSU2nojTLzCo_48ClJkh702qpPSQxeCByc1IRDS5kGI2SGnAAFsnUtbI5l8POl99nNO05dVKxb-Yuby63OVOdqG43P6V4GEVjQUEhC0bQra_iYCAhwC4BcssRe3GhT072O83pNbpwETQpguomIIUdk0lg",
           "CmRSAAAA72_zQxMpmiFYTRaTJCyEiaEbCrn4eQhkMh4LZXhQR-bCL7FA7Efl4wumv-D-gopvo-VQ17R22w0jEPlhJaTIqYeSTGkGQnPHu4xmE31r-vXMd48EeTy-6z_O_s8dJ2EfEhBhMScgOzqfEsdhgiXyB1ElGhTAVb1NWeNkoORbdS4664rcUy1P9A",
           "CmRRAAAAb_-zP32EfHFOtlljTk-eRPxDHft637H2Mm1NMdXyvfGZV3rwKnmrl4P5lIUa4AhHId7WTboBtx_YHr8JgLxvkM3oCqjHpRl1Hn_H5Xz6wV8Vx0cenj900v159-0Y9IylEhB1IxWYfFdoQH4ajKEsxfaWGhRNi-YH4vI0VmJljPUkYmlVNHADBQ",
           "CmRSAAAA0n8-rcO_2yGFe4584Hzw6vI2nOMfIezA2_9alezBaLSEaNzHkZClW8TJT8aChtpyESA3F9u27_Xr0WcCq3PLjuFwBYdkMNIVwzt2Rvk5qWG_zw6SexkhtzYs1ePuuvPvEhCySKw1Uab8-gFd738Juzy5GhTHDU8lvQN64dl6I_S7C9TE6UowOw",
           "CmRRAAAAK5XOhaSQWqNAl2iTe87hm9uNS61ZnmNF8TscdG0v9q2z6g9hILN-flz3KzjHhlA3RZgvMZloq9JXF0hp7Kytl6H2WnfX2TtR77FrW_nSNqrT8Ka6MbJTew_dMqzPLB0-EhCg-wsEAtqvlJiictCR0qIeGhS7Crufm3eOqJ4PAWy1jpLmxAzqRA"
           ), types = list(c("bar", "restaurant", "food", "point_of_interest",
           "establishment"), c("restaurant", "food", "point_of_interest",
           "establishment"), c("bar", "restaurant", "food", "point_of_interest",
           "establishment"), c("restaurant", "food", "point_of_interest",
           "establishment"), c("bar", "restaurant", "food", "point_of_interest",
           "establishment"), c("meal_delivery", "meal_takeaway",
           "restaurant", "food", "store", "point_of_interest", "establishment"
           ), c("restaurant", "food", "point_of_interest", "establishment"
           ), c("restaurant", "food", "point_of_interest", "establishment"
           ), c("restaurant", "food", "point_of_interest", "establishment"
           ), c("restaurant", "food", "point_of_interest", "establishment"
           ), c("restaurant", "bar", "food", "point_of_interest",
           "establishment"), c("restaurant", "bar", "food", "point_of_interest",
           "establishment"), c("bar", "restaurant", "food", "point_of_interest",
           "establishment"), c("restaurant", "food", "point_of_interest",
           "establishment"), c("restaurant", "food", "point_of_interest",
           "establishment"), c("restaurant", "cafe", "bar", "food",
           "point_of_interest", "establishment"), c("bar", "restaurant",
           "food", "point_of_interest", "establishment"), c("restaurant",
           "food", "point_of_interest", "establishment"), c("restaurant",
           "food", "point_of_interest", "establishment"), c("restaurant",
           "food", "point_of_interest", "establishment"))), .Names = c("formatted_address",
           "geometry", "icon", "id", "name", "opening_hours", "photos",
           "place_id", "price_level", "rating", "reference", "types"
           ), class = "data.frame", row.names = c(NA, 20L)), status = "OK"), .Names = c("html_attributions",
           "next_page_token", "results", "status"))

  expect_true(place_location(res)$lat[1] == -37.8108555)
  expect_true(place_location(res)$lng[1] == 144.9713535)
  #expect_true(sum(place_open(res)) == 20)   ## place details query
  #expect_null(place_hours(res))              ## place details query
  expect_true(place_next_page(res) == "CpQCDAEAAF2T00DxAqeB_nx3FMGzTgWGOP_UKWI7prb8i6GeFEWxpIxNn_byqD5qvfY6nbGjkPEeGZUjxatKKdWIhajoLFAYCpUM-uBBIK6m4mqZs1rIQIfPv05zgY_-InBsZX2ynVDRANBZTq3kkJF3fGXn7nF1BX_YxVGbqDB5spYk2i9lxHL0zWIS9ZYmD5qowaw00noQ5hlyyCY1qxGMsF0DXVeUQbpECQGHQNT52k8gApw0Jo3gBh-hkkZO0fNikHi79EqtC4BJD2ZJ2Us4VdytadaUfYWwau8REwc655GWroAuD2--KvadmH67X0AZpuX-0f_2hH4HHxRwPjPW2bv4HSGlFw_2YeNQB6ww8V1Ry8WrEhDM8nrx0tpYa2NRDgumWLzVGhS5sm92Kwo0zrgp80B2fo8QbP3MWA")
  expect_true(class(place_type(res)) == "list")
  expect_true(place(res)[1] == "ChIJxbZOsshC1moR7thhGoEJ11s")
  expect_true(place_name(res)[5] == "Maha")

})


test_that("nearest roads results are accessed", {

  res <- structure(list(snappedPoints = structure(list(location = structure(list(
    latitude = c(60.1707025219662, 60.1708066945441, 60.1709086844695
    ), longitude = c(24.9427153240764, 24.9427061169717, 24.9426971027202
    )), .Names = c("latitude", "longitude"), class = "data.frame", row.names = c(NA,
    3L)), originalIndex = 0:2, placeId = c("ChIJNX9BrM0LkkYRIM-cQg265e8",
    "ChIJNX9BrM0LkkYRIM-cQg265e8", "ChIJNX9BrM0LkkYRIM-cQg265e8")), .Names = c("location",
    "originalIndex", "placeId"), class = "data.frame", row.names = c(NA,
    3L))), .Names = "snappedPoints")

  expect_true(class(nearest_roads_coordinates(res)) == "data.frame")

})






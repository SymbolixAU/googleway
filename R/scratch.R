

key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_API_KEY")

goo <- google_map()
goo$dependencies <- googleway:::google_key_dependency(key = key)
goo





# googleway

Decodes the `overview_polyline` that's generated from the [google maps directions api](https://developers.google.com/maps/documentation/directions/start#sample-request).

## Example

```

## polyline joining the capital cities of Australian states
pl <- "nnseFmpzsZgalNytrXetrG}krKsaif@kivIccvzAvvqfClp~uBlymzA~ocQ}_}iCthxo@srst@"
    
df_polyline <- decodepl(pl)
head(df_polyline); tail(df_polyline)
#         lat      lon
# 1 -37.78808 144.9756
# 2 -35.26356 149.1724
# 3 -33.85217 151.2378
# 4 -27.41079 152.9956
# 5 -12.38293 130.7812
# 6 -31.87756 115.7959
#         lat      lon
# 3 -33.85217 151.2378
# 4 -27.41079 152.9956
# 5 -12.38293 130.7812
# 6 -31.87756 115.7959
# 7 -34.84988 138.5596
# 8 -42.84375 147.3486

```





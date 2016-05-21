# googleway

Decodes the `overview_polyline` that's generated from the [google maps directions api](https://developers.google.com/maps/documentation/directions/start#sample-request).

## Example

```

## overview_polyline of the trip Disneyland to Universal Studios

pl <- "knjmEnjunUbKCfEA?_@]@kMBeE@qIIoF@wH@eFFk@WOUI_@?u@j@k@`@EXLTZHh@Y`AgApAaCrCUd@cDpDuAtAoApA{YlZiBdBaIhGkFrDeCtBuFxFmIdJmOjPaChDeBlDiAdD}ApGcDxU}@hEmAxD}[tt@yNb\\yBdEqFnJqB~DeFxMgK~VsMr[uKzVoCxEsEtG}BzCkHhKWh@]t@{AxEcClLkCjLi@`CwBfHaEzJuBdEyEhIaBnCiF|K_Oz\\
  {MdZwAbDaKbUiB|CgCnDkDbEiE|FqBlDsLdXqQra@kX|m@aF|KcHtLm@pAaE~JcTxh@w\\`v@gQv`@}F`MqK`PeGzIyGfJiG~GeLhLgIpIcE~FsDrHcFfLqDzH{CxEwAbBgC|B}F|DiQzKsbBdeA{k@~\\oc@bWoKjGaEzCoEzEwDxFsUh^wJfOySx[uBnCgCbCoFlDmDvAiCr@eRzDuNxC_EvAiFpCaC|AqGpEwHzFoQnQoTrTqBlCyDnGmCfEmDpDyGzGsIzHuZzYwBpBsC`CqBlAsBbAqCxAoBrAqDdDcNfMgHbHiPtReBtCkD|GqAhBwBzBsG~FoAhAaCbDeBvD_BlEyM``@uBvKiA~DmAlCkA|B}@lBcChHoJnXcB`GoAnIS~CIjFDd]A|QMlD{@jH[vAk@`CoGxRgPzf@aBbHoB~HeMx^eDtJ}BnG{DhJU`@mBzCoCjDaAx@mAnAgCnBmAp@uAj@{Cr@wBPkB@kBSsEW{GV}BEeCWyAWwHs@qH?
    cIHkDXuDn@mCt@mE`BsH|CyAp@}AdAaAtAy@lBg@pCa@jE]fEcBhRq@pJKlCk@hLFrB@lD_@xCeA`DoBxDaHvM_FzImDzFeCpDeC|CkExDiJrHcBtAkDpDwObVuCpFeCdHoIl\\uBjIuClJsEvMyDbMqAhEoDlJ{C|J}FlZuBfLyDlXwB~QkArG_AnDiAxC{G|OgEdLaE`LkBbEwG~KgHnLoEjGgDxCaC`BuJdFkFtCgCnBuClD_HdMqEzHcBpB_C|BuEzCmPlIuE|B_EtDeBhCgAdCw@rCi@|DSfECrCAdCS~Di@jDYhA_AlC{AxCcL`U{GvM_DjFkBzBsB`BqDhBaEfAsTvEmEr@iCr@qDrAiFnCcEzCaE~D_@JmFdGQDwBvCeErEoD|BcFjC}DbEuD~D`@Zr@h@?d@Wr@}@vAgCbEaHfMqA`Cy@dAg@bAO`@gCi@w@W"
    
df_polyline <- decode(pl)
head(df_polyline)
# lat       lon
# 1 33.80982 -117.9154
# 2 33.80788 -117.9154
# 3 33.80688 -117.9154
# 4 33.80688 -117.9152
# 5 33.80703 -117.9153
# 6 33.80933 -117.9153


```





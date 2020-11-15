## -----------------------------------------------------------------------------
library(googleway)
## not specifying the api will add the key as your 'default'
key <- "my_api_key"
set_key(key = key)
google_keys()


## -----------------------------------------------------------------------------
## specifying the specific API will only make that key available for that API.
clear_keys() ## clear any previously set keys
key <- "my_api_key"
set_key(key = key, api = "directions")
google_keys()

## -----------------------------------------------------------------------------
polyline <- "rqxeF_cxsZgr@xmCekBhMunGnWc_Ank@vBpyCqjAfbAqmBjXydAe{AoF{oEgTqjGur@ch@qfAhUuiCww@}kEtOepAtdD{dDf~BsgIuj@}tHi{C{bGg{@{rGsmG_bDbW{wCuTyiBajBytF_oAyaI}K}bEkqA{jDg^epJmbB{gC}v@i~D`@gkGmJ_kEojD_O{`FqvCetE}bGgbDm_BqpD}pEqdGiaBo{FglEg_Su~CegHw`Cm`Hv[mxFwaAisAklCuUgzAqmCalJajLqfDedHgyC_yHibCizK~Xo_DuqAojDshAeaEpg@g`Dy|DgtNswBcgDiaAgEqgBozB{jEejQ}p@ckIc~HmvFkgAsfGmjCcaJwwD}~AycCrx@skCwUqwN{yKygH}nF_qAgyOep@slIehDcmDieDkoEiuCg|LrKo~Eb}Bw{Ef^klG_AgdFqvAaxBgoDeqBwoDypEeiFkjBa|Ks}@gr@c}IkE_qEqo@syCgG{iEazAmeBmeCqvA}rCq_AixEemHszB_SisB}mEgeEenCqeDab@iwAmZg^guB}cCk_F_iAmkGsu@abDsoBylBk`Bm_CsfD{jFgrAerB{gDkw@{|EacB_jDmmAsjC{yBsyFaqFqfEi_Ei~C{yAmwFt{B{fBwKql@onBmtCq`IomFmdGueD_kDssAwsCyqDkx@e\\kwEyUstC}uAe|Ac|BakGpGkfGuc@qnDguBatBot@}kD_pBmmCkdAgkB}jBaIyoC}xAexHka@cz@ahCcfCayBqvBgtBsuDxb@yiDe{Ikt@c{DwhBydEynDojCapAq}AuAksBxPk{EgPgkJ{gA}tGsJezKbcAcdK__@uuBn_AcuGsjDwvC_|AwbE}~@wnErZ{nGr_@stEjbDakFf_@clDmKkwBbpAi_DlgA{lArLukCBukJol@w~DfCcpBwnAghCweA}{EmyAgaEbNybGeV}kCtjAq{EveBwuHlb@gyIg\\gmEhBw{G{dAmpHp_@a|MsnCcuGy~@agIe@e`KkoA}lBspBs^}sAmgIdpAumE{Y_|Oe|CioKouFwuIqnCmlDoHamBiuAgnDqp@yqIkmEqaIozAohAykDymA{uEgiE}fFehBgnCgrGmwCkiLurBkhL{jHcrGs}GkhFwpDezGgjEe_EsoBmm@g}KimLizEgbA{~DwfCwvFmhBuvBy~DsqCicBatC{z@mlCkkDoaDw_BagA}|Bii@kgCpj@}{E}b@cuJxQwkK}j@exF`UanFzM{fFumB}fCirHoTml@CoAh`A"

df <- decode_pl(polyline)
head(df)

## -----------------------------------------------------------------------------

encode_pl(lat = df$lat, lon = df$lon)


## -----------------------------------------------------------------------------

melbourne[melbourne$polygonId == 338 & melbourne$pathId %in% c(1, 2), ]


## -----------------------------------------------------------------------------
substr(geo_melbourne[1], 1, 300)


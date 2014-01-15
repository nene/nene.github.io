---
layout: post
title: Sportlyzeri test-ülesanne
description: "Häkkisin Sportlyzeri JavaScripti."
modified: 2014-01-15
category: articles
tags: []
image:
  feature: sportlyzer-bg.png
  credit: Sportlyzer
  creditlink: http://sportlyzer.com
---

Kandsin [RR Software][] lõplikult maha ning suundusin taas
tööotsingutele.  Sedapuhku tatsasid mu jalakesed [Sportlyzeri][] ukse
taha.  Rääkisime juttu, ning seejärel saadeti testülesanne, mille sisu
oli järgmine:

![Testülesanne]({{ site.url }}/images/testylesanded.gif)

Pildifaili natuke lähemalt uurides selgus ka tegelik ülesande sisu.
Kuid selleks polnud mitte vallatute pärdikutega semmimine vaid
hiiglaslikes JavaScripti failides sobramine.

## Esimene ülesanne

Materjaliks oli antud üks Sportlyzeri rakenduse HTML lehekülg, mis oli
lihtsalt brauseriga maha salvestatud, ning millele ma pidin
JavaScriptis natuke täiendavat funktsionaalsust kirjutama.  Lisatav
funktsionaalsus oli väga lihtne, kuid suurem küss seisnes selles,
kuidas leida sellest tuhanderealisest HTML failist see õige koht kuhu
seda külge pookida.

JavaScripti poole pealt oli see fail aga paras sasipundar, sisaldades:

- 12 linki erinevatele JavaScripti teekidele (osad minifitseeritud).
- 5 linki Sprotlyzeri enda JavaScripti failidele.
- 10 HTML-i sisest JavaScripti blokki.
- sadakond onclick atribuuti funktsioonide väljakutsetaga.

Siit võis järeldada, et Sportlyzeril puudub JavaScripti
konkateneerimise ja minifitseerimise süsteem, ning üldse on nende
JavaScripti kood üksjagu lohakas.

Seejärel hakkas mulle silma `sport.js` nimeline hiiglaslik
4000-realine fail, kus sees paistis suurem hulk kõiksugu kraami:

- 3 JavaScripti teeki (üks neist minifitseeritud koodiga).
- 84 globaalset funktsiooni
- 9 globaalset muutujat
- 5 klassi
- 7 lisameetodit Date, String ja Object klassidele.
- 4 pluginat jQueryle.
- 3 jQuery väljakutset
- 2 ülekirjutatud funktsiooni: onerror ja alert
- 1 hiiglaslik `sportlyzer` alias `spl` objekt.

Ehk kokku 115 globaalset definitsiooni, kõik üpris segiläbi ilma
erilise struktuurita.

Ma alguses arvasin, et see neil siiski on mingi JavaScripti
konkateneerimise süsteem, mille töö läbi seesinatsene fail on saadud -
see selgitaks, miks Sportlyzeri enda koodi vahele on torgatud ka paari
välist teeki ning veits minifitseeritud koodi.

Aga ei... automaatne konkateneerija ei paigutaks välise teegi
kommenteeri ja koodi vahele natuke Sportlyzeri enda funktsioone - seda
suudab vaid inimene.

Nojah siis...

Lõpptulemusena polnud mul tarvis olemasolevat JavaScripti näppida,
vaid tuli üksnes HTML-iga liidestuda.  Kirjutasin oma koodi eraldi
JavaScripti ja CSS-i failidesse ning viskasin kaks tag-i lehekülje
lõppu.

## Teine ülesanne

Materjal oli taas samasugune - lihtsalt üks teine HTML-lehekülg.
Sedapuhku tuli liidestada [HighCharts][] graafiku peal hiirega
liikumine [Google Mapsi][] peal liikuva markeriga.

Triviaalne, sest Medianis oldud ajal sai Google Mapsi peale kirjutatud
märksa keerukamat funktsionaalsust.

Takerdusin aga HighChartsi API taha.  Paistis, et olemasolev
HighCharts-i graafik ei lase endale niisama lihtsasti lisada uusi
kuulareid.  Lõpuks mingi häki läbi mul see siiski õnnestus.

Siis aga saabus suuremat sorti segadus andmetega.  Väga raske oli aru
saada, milliseid andmeid seal HighChartsi sündmuse objektis saaksin ma
kasutada kaardipunkti andmestikuga liidestumiseks.

Viimases hädas pöördusin Skype-i teel Sportlyzeri arendaja poole ning
selgus, et olin jätnud kahe silma vahele jupi üleasande tekstist, kus
mainiti, et:

> eventi siseselt on võimalik teada saada punkti x koordinaati (ehk
> aega millisekundites) ja selle järgi on võimalik andmetest leida ka
> õige koordinaat.

Tõsijutt.  Kahjuks ei sobitunud need graafikust saadud UNIX-i
ajatemplid GPS-punktide andestikus olevatega.  Pidin teostama
kahend-otsingu üle punktide, leidmaks kõige lähima ajatempliga punkt,
ning paigutasin markeri tollele positsioonile.

Hakkas tööle, nagu valatud...

Võta nüüd kinni, kas ma tegin midagi valesti, et need ajatemplid ei
kattunud, või oli see ülesanne tahtlikult veits keerukam tehtud, või
polnud ka Sportlyzeri arendajad ise teadlikud, et need andmestikud ei
punkti pealt ei ühti.


[RR Software]: /2013/12/17/ports-uleliigset-koodi/
[Sportlyzeri]: https://www.sportlyzer.com/
[HighCharts]: http://api.highcharts.com/highcharts
[Google Mapsi]: https://developers.google.com/maps/documentation/javascript/reference

---
layout: post
title: Fortumo test-ülesanne
description: "Käisin Fortumos koodi kirjutamas."
modified: 2013-11-13
category: articles
tags: []
image:
  feature: texture-feature-05.jpg
  credit: Texture Lovers
  creditlink: http://texturelovers.com
---


Ühel ilusal sügispäeval tatsasin ma [Fortumosse][Fortumo], et seal ühe
valvsa arendaja pilgu all neile jupike koodi kirjutada.

![Fortumo logo]({{ site.url }}/images/fortumo-logo.png)
{: .image-pull-right}

Nädala eest sai seal end juba intervjueerida lastud, ning nüüd siis
taheti testida, kas ma üldse koodi kirjutada mõistan.  Muidugimõista
olin ärevuses -- kas suudan nad ära petta?

Võiks ju arvata, et ärevuseks polnud põhjust.  Olin ma ju paari aasta
eest Ameerikamaal edukalt ära petnud suure [Sencha][] korporatsiooni.
Mis siis nüüd väike kodumaine firmake ära pole?  Aga eks tea ju iga
sagedasem [Juu-Tuubi][YouTube] vaataja, et tüüpiline Ühendriikide
kodanik oma tarkusega teps mitte ei hiilga.  Ning seda võin takkajärgi
ka ise kinnitada - kui on tarvis anda hinnanguid skaalal "Halb --
Keskmine -- Hea", siis valib USAkas harilikult "Suurepärase".  Eestis
seevastu peab olema palju ettevaatlikum, sest on Eestlase jaoks ju
parim toit teine Eestlane.  Suurim kiitus, mis siin maal saada võib,
on "Pole paha".

Nii ma sinna siis läksin.  Süda rinnus värisemas, pea läbikukkumise
mõtteid täis, ja sisikond ärevusest keerlemas.  Hea, et suutsin veel
käed värisemast hoida -- viimane oleks mulle koheselt progemiskeelu
toonud.

Sedapuhku polnud minu partneriks mitte pea progemisboss, vaid üks
pulgake allpool olev progeja.  Sikutasin oma rüperaali lauale ning
asusime asja kallale.

## Ülesanne

Esialgseks ülesandeks oli luua monitoorija, mis kontrolliks kas
Fortumo veebileht on üleval, ning probleemi korral saadaks e-postiga
teavituse.  Hiljem lisandusid siia veel vajadused:

1. Saata lisaks e-postile ka SMS.

2. Kontrollida, et veebileht poleks tühi.

3. Konfiguratsioonifail seadete mugavamaks määramiseks.

4. Kontrollida, et server ei ületaks vastuse saatmisel ajalimiiti.  Ja
   saata teavitus vaid juhul kui vähe pikema aja jooksul kõik päringud
   üle limiidi lähevad.

Seejuures päris E-posti ja SMS-e saata ei tulnud - piisas vaid paarist
väljamõeldud objektist, mis sellist teenust näiliselt osutasid.

Seega, minu suureks õnneks, ei midagi tehniliselt ega algoritmiliselt
keerukat, sest oleks ma pidand Bayes' filtreid kasutama, oleksin
kahtlemata omadega käpuli olnud.

Mu ülesandeks jäi hoopis organiseerida programm nõnda, et see
inimestele võimalikult loetav oleks.  Lahe!  Sest sellel alal oli mul
lausanisti petuskeemi ette valmistatud.  Nimelt, olin just lugenud
üpris suurepärast Sandi Metzi raamatut ["Practical Object-Oriented
Design in Ruby,"][poodr] mis oli mu tarkvara disaini rakukesi just
sedapidi loksutanud, et ma kõigele sellele tiba süstemaatilisemalt
läheneda suudaks.

## Lahendus

Otsustasin kirjutada võimalikult lihtsa skriptikese, mis lõputus
tsüklis serveri pihta päringuid saadab:

{% highlight ruby %}
while true
  status = ping_server
  report(status)
  sleep 1
end
{% endhighlight %}

**Teavituste saatmiseks** koostasin klassid `MailNotifier` ja
`SmsNotifier`.  Millest lihtsa tsükliga üle käidi.

**Seadete jaoks** tegin lihtsa Ruby faili, mis defineeris globaalse
`CONF` konstandi:

{% highlight ruby %}
CONF = {
  :server => 'localhost',
  :port => 2000,
  :request_timeout => 1,
  :timeout_reporting_delay => 5,
  :expected_content => /Hello world/i,
}
{% endhighlight %}

Erinevate serveri **probleemide eristamiseks** sai aga üks purakas `if`:

{% highlight ruby %}
def report(res)
  case res
  when Net::HTTPResponse
    if res.code == '200'
      if res.body =~ @expected_content
        notify(res.code, "Server is back up", "Hurrey!")
      else
        notify(:blank, "Blank page", "Totally empty!")
      end
    else
      notify(res.code, "Server is down", "Error: #{res.code}")
    end
  when Timeout::Error
    notify(res, "Server is does not respond", "Error: Timeout")
  when Errno::ECONNREFUSED
    notify(res, "Server is down", "Error: Connection refused")
  when StandardError
    notify(res, "Error when checking server status", "Error: #{res.inspect}")
  end
end
{% endhighlight %}

See kahtlemata näeb halb välja, sest kontrollitakse argumendi klassi,
mille alusel erinevaid vea-teateid väljastatakse.  Kuid ma ei näe, et
seda kuigivõrd paremini lahendada saaks - `Net::HTTP` teavitab oma
päringute staatusest kõigi nende erinevate klasside läbi, ning ma
lihtsalt pean nende kõigiga tegelema.  Ainus mis ma teha saan, on
kontsentreerida viited nendele klassidele kuhugi ühte kohta nii, et
need mööda kogu mu programmi laiali ei kanduks, ning seda ma püüdsingi teha.

Hilisema arutelu käigus jõudsime selleni, et kogu `Net::HTTP`-ga
suhtlemine tuleks sulgeda väikese fassaadi taha, mis kõik need klassid
endasse peidaks.  Lisaks aitaks tolle teegi välja eraldamine tublisti
kaasa testimisele.

Suuremaks pähkliks osutus aga viimane punkt: **päringu ajalimiit.**
Eeskätt vajadus teavitus välja saata alles siis kui teatud aja jooksul
on kõik päringud ajalimiidi ületanud.

Mõistagi polnud probleem selle nõude arvutile selgeks tegemises.  Kui
aga üritasin seda loogikat kenasse objektide keelde panna, ei tahtnud
mul see mitte kuidagi välja kukkuda.  Lõpuks jooksis mu mõistus päris
puntrasse, ja ma tundsin, et nüüd ja siinsamas saabubki mu
haletsusväärne lõpp.

Viimase õlekõrrena nõudsin endale paberit ja pliiatsit, et segased
mõtted kääruliste ajusagarate vahelt puhtale lõuendile maalida.  Ja
mõningal määral see aitaski.

Ma küll ei suutnud seda loogikat ilusaks muuta, kuid vähemasti
kapseldasin ta ühte klassi, et kõik see karvane värk ühes kohas
kontrolli all hoida:

{% highlight ruby %}
class StatusHandler
  def initialize(conf)
    @previous_status = '200'
    @should_notify = false
    @last_non_timeout_time = Time.now
    @timeout_reporting_delay = conf[:timeout_reporting_delay]
  end

  def update(status)
    if @previous_status != status && !status.is_a?(Timeout::Error)
      @should_notify = true
      @last_non_timeout_time = Time.now
    elsif status.is_a?(Timeout::Error)
      @should_notify = Time.now > @last_non_timeout_time + @timeout_reporting_delay
    else
      @should_notify = false
    end
    @previous_status = status
    self
  end

  def should_notify?
    @should_notify
  end
end
{% endhighlight %}

Rahule ma sellega muidugi ei jäänud, ja ütlesin niiviisi ka oma
hindajale, ent ma ei suutnud tol hetkel ka midagi paremat välja
mõelda.  Seega kauni koodi koha pealt lõppkokkuvõttes ikkagi mõningane
läbikukkumine.

Eks näis siis, kas ja kuidas see nüüd nende koguarvamust minust
mõjutab...

[Kogu lahenduse kood Githubis.][gh-orig]

## Jätkumõtted

Kuna ma eelneva lahendusega siiski päris rahule ei jäänud, siis
nuputasin selle `StatusHandler` klassi kallal ja jõudsin lõpuks
lahenduseni, kus ma staatuskoodi asemel saadan `update` meetodile
hoopis staatuse objekti, mis teab ise kui pikk tema puhul ooteaeg on
enne teavituse väljasaatmist:

{% highlight ruby %}
class StatusHandler
  def initialize
    @prev_status = OpenStruct.new(:code => :ok, :delay => 0)
    @should_notify = false
    @prev_change = Time.now
  end

  def update(new_status)
    if @prev_status.code != new_status.code
      # When status changed. Remember the status and time of the change.
      @prev_status = new_status
      @prev_change = Time.now
      # Notify immediately when status has no delay.
      @should_notify = (new_status.delay == 0) ? true : :pending
    elsif @should_notify == :pending
      # When status didn't change and reporting of the previous change
      # is still pending, notify in case enough time has passed.
      @should_notify = true if Time.now > @prev_change + new_status.delay
    else
      # Status didn't change, and we have already reported the
      # previous change.  Do nothing until next status change.
      @should_notify = false
    end

    self
  end

  def should_notify?
    @should_notify == true
  end
end
{% endhighlight %}

Sedaviisi ei pea `StatusHandler` rakendama erikohtlemist `Timeout`
tüüpi veale, vaid arvestab potentsiaalse ooteajaga iga
staatusemuudatuse puhul.  Kommentaare ja tühje ridu arvestamata on uus
kood täpselt sama pikk kui vana.

[Täiendatud kood Githubis][gh-new] (koos selle ja mõningate teiste
parandustega).


[Fortumo]: http://careers.fortumo.com
[Sencha]: http://sencha.com
[YouTube]: http://youtube.com
[poodr]: http://www.poodr.com
[gh-orig]: https://github.com/nene/fortumo-test-assignment/tree/original-solution
[gh-new]: https://github.com/nene/fortumo-test-assignment

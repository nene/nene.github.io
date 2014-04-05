---
layout: post
title: Facebooki häkk
description: "Moluraamatu uus häkkimiskeel on paljulubav."
modified: 2014-04-05
category: articles
tags: []
image:
  feature: php-bg.jpg
  credit: PHPDancer blog
  creditlink: http://phpdancer.blogspot.com/p/php-wallpapers.html
---

Moluraamatu mehed on tulnud välja uue PHP-variandiga, millele nad on
nimeks andnud [Hack][].  No muidugi, mis muud moodi sa seda PHP-d
üldse nimetama peaksidki?  Minu kiire ülevaatuse põhjal on Hack
oluliselt parem kui harilik PHP - mis muidugi pole mingi eriline
näitaja, sest noh, PHP.

## Staatiline tüüpimine

Hack laiendab PHP süntaksit hulga erinevate staatilise tüüpimise
võimalustega.  Parim mida PHP selle koha pealt suudab on nõuda, et
funktsiooni parameetrid oleksid teatava klassi instantsid, massiivid
või funktsiooni-objektid:

    function test_class(MyClass $obj) { }
    function test_array(array $arr) { }
    function test_func(callable $fn) { }

Olulise piiranguna aga ei saa nõuda, et parameeter oleks string või
number, mis on pehmelt öeldes elementaarne puudujääk.

Hack lahendab selle probleemi, ja võimaldab tüüpida ka funktsioonide
tagastatavad väärtused ning klasside atribuudid:

    class MyClass {
        const int MY_CONST = 0;

        private string $x = "";

        public function increment(int $x): int {
            return $x + 1;
        }
    }

## Hüvasti nullid

Kuid parim nende tüüpide juures on see, et vaikimisi pole nad
nullitavad, mis on oluline edasiminek, sest ootamatud null väärtused
toovad kaasa vaid pahandust.

Kui näiteks tahame lubada, et eeldoodud `increment` meetodi
parameetriks saab anda ka nulli, siis peame seda spetsiaalse
süntaksiga märkima:

    public function increment(?int $x): int {
        return $x + 1;
    }

Sellise koodi peale pistab aga Hacki tüübikontrollija kisama, sest `+`
operaatorit ei saa nulliga kasutada.  Peame lisama kontrolli juhuks
kui `$x` on `null`.

    public function increment(?int $x): int {
        if (is_null($x)) {
            return 1;
        }
        return $x + 1;
    }

## Normaalsed massiivid ja lambdad

Vanasti käis massiividega arveldamine PHP-s `array()` konstruktsiooni
ja `foreach` tsükli abil:

    $numbers = array(1, 2, 3, 4);
    $squares = array();
    foreach ($numbers as $x) {
        $squares[] = $x * $x;
    }

Tänapäeval saab massiivid kirja panna nurksulgude vahele ning
`array_map()`-i ja anonüümse funktsiooni abil kenasti transformeerida:

    $numbers = [1, 2, 3, 4];
    $squares = array_map(function($x) { return $x * $x; }, $numbers);

Hack toob keelde juurde aga uue kollektsioonide kogu, kus on eraldi
andmetüüp massiivide (`Vector`) ja räsitabelite (`Map`) jaoks.
Erinevalt PHP massiividest käituvad need nagu harilikud objektid, ning
globaalsete funktsioonide virr-varri asemel on neil kõigil lihtne
ja arusaadav komplekt meetodeid.

PHP anonüümsetele funktsioonidele pakub Hack aga välja lihtsama ja
lühema alternatiivse süntaksi:

    $numbers = Vector {1, 2, 3, 4};
    $squares = $numbers->map( $x ==> $x * $x );

Oli ka aeg.  Ma pole siiamaani suutnud meelde jätta, et
`array_filter()` võtab esimese argumendina funktsiooni ning
`array_map()` esimesena hoopis massiivi.  Või oli see vastupidi?

Puhtalt selle normaalse kollektsioonide API pärast võtaksin mina
Hack-i juba hommepäev kasutusse.  Need on tõesti suurepärased
alternatiivid PHP õnnetutele massiivide.

Siinkohal jääb mul vaid üks küsimus...

## Aga stringid?

Miks pole Moluraamatu meeskond midagi ette võtnud selleks et ka
stringide API-t inimsõbralikumaks muuta.  On ju erinevad
stringi-funktsioonid täpselt samasugune sasipundar nagu massiivide
puhul.

Näiteks on PHP-s 2 funktsiooni stringide ühendamiseks (`implode` ja
`join`), tervelt 4 nende jupitamiseks (`explode`, `srt_split`,
`split`, `strtok`), ja lausa 6 neist alamstringide otsimiseks
(`strstr`, `strchr`, `stristr`, `strrchr`,`strpos`, `strpbrk`,
`preg_match`).

Ei ole ju palju tahta üht lihtsat stringi API-t nagu:

    $s = "Hello, world!";

    $s->split("/ /");

    $s->replace("/replace-me/", "with this");

PHP stringid on küll primitiivsed andmetüübid mitte objektid, aga ei
tohiks olla ju eriti keerukas implementeerida automaatne stringi
andmetüübi konverteerimine stringi objektiks kui tema peal `->`
operaatorit kasutatakse (nagu näiteks Javas ja JavaScriptis).

Ma jään lootma, et Moluraamatu poisid siiski plaanivad ka stringide
osas midagi ette võtta, ning siiamaani on olnud lihtsalt suurema
prioriteediga rangemat tüübikontrolli ja kiiremat koodi toetavad
featuurid.

Iagatahes on Hack on kahtlemata parem häkk kui PHP.

[Hack]: http://hhvm.com/


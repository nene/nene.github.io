---
layout: post
title: PHP – uus ning endiselt nõme :(
description: "Progesin taas PHP-d üle mitme aasta"
modified: 2013-12-04
category: articles
tags: []
image:
  feature: php-bg.jpg
  credit: PHPDancer blog
  creditlink: http://phpdancer.blogspot.com/p/php-wallpapers.html
---

Viimati sai rohkem PHP-d kirjutatud ja kirutud siis kui
versiooninumber näitas 5.2.  Täna on aga värskeim väljalase juba 5.5,
mis võrreldes 5.2-ga sisaldab puraka posu uusi featuure, mida mul
õnnestus omal käel järele proovida kui katsusin jõudu [Titanium
Systems OÜ testülesande][1] kallal.

[1]: https://github.com/nene/titanium-test-assignment

## Süntaks massiivide jaoks

Kogu selle aja on PHP progejad vapralt toksinud `a`, `r`, `r`, `a`,
`y`, `(`, `)` üksnes selleks et uut tühja massiivi tekitada.  Nüüd
siis viimaks saavad nad kasutada sama süntaksit mida kõik mõistlikud
keeled tavaliselt juba versioonist 0.0.1 alates toetavad:

{% highlight php startinline %}
$myArray = [];
{% endhighlight %}

Nagu ikka saab lihtsasti teostada ka operatsiooni PUSH:

{% highlight php startinline %}
$myArray[]= 5;
{% endhighlight %}

Või massiivide liitmist:

{% highlight php startinline %}
$myArray = [1, 2, 3] + [4, 5, 6];

// TULEMUS: [1, 2, 3], sest + töötab ootuspäraselt vaid
// assotsiatiiv-massiivide puhul, oleks tulnud kirjutada:

    $myArray = array_merge([1, 2, 3], [4, 5, 6]);
{% endhighlight %}


## Anonüümsed funktsioonid

Hurraa! No viimaks ometi saab kasutada `array_filter` funktsiooni
mõistlikul moel:

{% highlight php startinline %}
$odds = array_filter([1, 2, 3], function($x) { return $x % 2 != 0; });
{% endhighlight %}

Ja samamoodi ka `array_map` puhul:

{% highlight php startinline %}
$squares = array_map([1, 2, 3], function($x) { return $x * $x; });

// VIGA: Parameetrid vales järjekorras:

    $squares = array_map(function($x) { return $x * $x; }, [1, 2, 3]);
{% endhighlight %}

Ning siis võime välja kutsuda ka olemasolevaid funktsioone:

{% highlight php startinline %}
$positives = array_map(abs, [-1, 2, 3]);

// VIGA: funktsioonid tuleb edastada stringina:

    $positives = array_map("abs", [-1, 2, 3]);
{% endhighlight %}

Või mõne objekti meetodi:

{% highlight php startinline %}
$positives = array_map($math->abs, [-1, 2, 3]);

// VIGA: Meetodid tuleb edastada massiivina:

    $positives = array_map([$math, "abs"], [-1, 2, 3]);
{% endhighlight %}


## Uuel objektil meetodi välja kutsumine

Varasemal ajal oli probleem, et PHP-s ei saanud kirjutada nii:

{% highlight php startinline %}
new Foo()->someMethod();
{% endhighlight %}

Ning selle asemel pidi kasutama koledat vahemuutujat:

{% highlight php startinline %}
$foo = new Foo();
$foo->someMethod();
{% endhighlight %}

Nüüd siis lõpuks saame kirjutada nii nagu alati soovinud oleme:

{% highlight php startinline %}
new Foo()->someMethod();

// VIGANE SÜNTAKS: ootamatu '->' operaator.
// Tegelikult peame kirjutama nii:

    (new Foo())->someMethod();
{% endhighlight %}


## Mugavad vaikimisi väärtused

Ennemalt oli veel üks probleem.  Paljudes teistes keeltes sai kasutada
`||` operaatorit, et seada vaikimisi väärtusi, kuid PHP-s andis
järgnev kood tulemuseks üksnes `true`:

{% highlight php startinline %}
$foo = $_POST['foo'] || "default";
{% endhighlight %}

Nüüd siis on PHP-s `?:` operaator, mis omab sama effekti:

{% highlight php startinline %}
$foo = $_POST['foo'] ?: "default";

// HOIATUS: Defineerimata index 'foo'
// Tegelikult peame kirjutama ikkagi:

    $foo = isset($_POST['foo']) ? $_POST['foo'] : "default";

// või suruma hoiatuse @ operaatoriga maha:

    $foo = @$_POST['foo'] ?: "default";
{% endhighlight %}


## Nimeruumid

Ja siis muidugi on meil need toredad nimeruumid:

{% highlight php startinline %}
namespace MyProject::Foo;

// VIGANE SÜNTAKS: ootamatu '::'
// Tegelikult tahame me muidugi kasutada seda võrratut
// äraspidi kaldkriipsu:

    namespace MyProject\Foo;

{% endhighlight %}


Oh seda sulnist rõõmu küll kogu sellest kompotist.

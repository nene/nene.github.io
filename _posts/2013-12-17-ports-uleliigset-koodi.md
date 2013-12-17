---
layout: post
title: Ports üleliigset koodi
description: "Sattusin ühe kahtlase koodijupi otsa"
modified: 2013-12-17
category: articles
tags: []
image:
  feature: php-bg.jpg
  credit: PHPDancer blog
  creditlink: http://phpdancer.blogspot.com/p/php-wallpapers.html
---

Nõndapsi.  Olen tagasi tööl päris ettevõttes, ning see kood mida ma
mind tervitavas koodibaasis näen, ei pane mind just rõõmust hüppama.

Täna sattusin sellise eluka otsa:

{% highlight php startinline %}
public function run()
{
    $currentDate = new DateTime();
    $sql = 'select u.id as user_id, ud.first_name, ud.last_name, us.id as shift_id from ';
    $sql.= 'user u ';
    $sql.= 'straight_join user_details ud on ud.user_id = u.id ';
    $sql.= 'left join user_shift us on us.user_id = u.id and us.time_from <= \''.date('Y-m-d H:i:s',$currentDate->getTimestamp()).'\' and us.time_to >= \''.date('Y-m-d H:i:s',$currentDate->getTimestamp()).'\' ';
    $sql.= 'where u.status = 3 and u.is_candidate = 1 ';
    $sql.= 'order by us.id DESC, ud.first_name, ud.last_name;';
    
    $rows = Yii::app()->db->createCommand($sql)->queryAll();
    
    $staffList = array();
    
    $i = 0;
    if(isset($rows) && $rows != null && !empty($rows)){
        foreach($rows as $row) {
            $staffList[$i]['user_id'] = $row['user_id'];
            $staffList[$i]['first_name'] = $row['first_name'];
            $staffList[$i]['last_name'] = $row['last_name'];
            $staffList[$i]['shift_id'] = $row['shift_id'];
            $i++;
        }
    }
    
    $this->render('StaffList', array('staffArray'=>$staffList));
}
{% endhighlight %}

Esmapilgul ei paistnudki see kood nii halb.  Mahub teine ju ilusasti
ühele leheküljele.  Kuid lähemal uurimisel hakkasid silma mitmed
probleemid.

## SQL

Ma isiklikult ei koostaks SQL-i sellise konkateneerimiste jadana, vaid
looksin lihtsalt mitmerealise stringi -- aga see on rohkem stiili
küsimus.  Kuid eriliselt kummaline näib see kuidas sisestatakse
sellesse SQL-i hetke kuupäeva ja aega:

{% highlight php startinline %}
$currentDate = new DateTime();
date('Y-m-d H:i:s',$currentDate->getTimestamp());
{% endhighlight %}

Millegipärast näeb see kood hirmsasti vaeva, et tekitada DateTime
objekt, millelt omakorda pärida Unixi ajatempel, mis aga on ju
niikuinii `date` funktsiooni vaike-parameeter ning sama tulemuse annab
lihtsalt:

{% highlight php startinline %}
date('Y-m-d H:i:s');
{% endhighlight %}

Lõppeks sisestatakse see kuupäev SQL-i, kuid sama tulemuse saaksime ju
ka SQL-i enda NOW() funktsiooniga...

## Tingimus

Jättes kahe silma vahele pöördumise globaalse Yii instantsi poole,
leiame järgmisena koodist ühe huvitava tingimuslause:

{% highlight php startinline %}
if(isset($rows) && $rows != null && !empty($rows)){
{% endhighlight %}

Siin on midagi ülearu:

- `isset` kontrollib et muutuja poleks defineerimata või `null`.
  `empty` kuntrollib et muutuja poleks tühi või `null`.  Seega
  kontroll `$rows != null` on üleliigne.

- Eelnevast koodist näeme muutuja `$rows` defineerimist, seega on ka
  `isset` üleliigne.  Pole mõtet kontrollida funktsiooni kohalike
  muutujate eksisteerimist.

- Uurides Yii raamistiku dokumentatsiooni saame teada, et `queryAll()`
  tagastab alati massiivi, seega pole `empty` vajalik `null` väärtuse
  tuvastamiseks.  Võibolla on siis tarvis meil vältida tühja massiivi?
  Aga ei... ka mitte seda.  Sellisel juhul jääb järgnev `foreach`
  vahele kõige loomulikumal moel - üle tühja massiivi käiakse `0`
  korda.

Seega, kogu see `if` on täiesti ebavajalik.

## Tsükkel

Aga asugem tsükli kallale. Ilma tolle `if`-ita näeb see välja säärane:

{% highlight php startinline %}
$staffList = array();

$i = 0;
foreach($rows as $row) {
    $staffList[$i]['user_id'] = $row['user_id'];
    $staffList[$i]['first_name'] = $row['first_name'];
    $staffList[$i]['last_name'] = $row['last_name'];
    $staffList[$i]['shift_id'] = $row['shift_id'];
    $i++;
}
{% endhighlight %}

See on nüüd küll veits kummaline.  Miks on meil vaja toda `$i`
muutujat?  Me võiksime ju massiivi lihtsalt uusi elemente juurde
lükkida:

{% highlight php startinline %}
$staffList = array();
foreach($rows as $row) {
    $staffList[]= array(
        'user_id' => $row['user_id'],
        'first_name' => $row['first_name'],
        'last_name' => $row['last_name'],
        'shift_id' => $row['shift_id'],
    );
}
{% endhighlight %}

Oo.. see sai küll palju lihtsam... aga mida kogu see tsükkel üldse
saavutada püüab?  Kas see mitte ei kirjuta täpselt sama nimega välju
ühest massiivist lihtsalt teise?

Oi jah... tuleb välja et suurem osa sellest koodist on täiesti
üleliigne.

{% highlight php startinline %}
public function run()
{
    $sql = 'SELECT u.id as user_id, ud.first_name, ud.last_name, us.id AS shift_id FROM ';
    $sql.= 'user u ';
    $sql.= 'STRAIGHT_JOIN user_details ud ON ud.user_id = u.id ';
    $sql.= 'LEFT JOIN user_shift us ON us.user_id = u.id AND us.time_from <= NOW() AND us.time_to >= NOW() ';
    $sql.= 'WHERE u.status = 3 AND u.is_candidate = 1 ';
    $sql.= 'ORDER BY us.id DESC, ud.first_name, ud.last_name;';

    $staffList = Yii::app()->db->createCommand($sql)->queryAll();

    $this->render('StaffList', array('staffArray' => $staffList));
}
{% endhighlight %}



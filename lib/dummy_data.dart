import 'package:flutter/material.dart';

import './models/category.dart';
import './models/meal.dart';

const DUMMY_CATEGORIES = const [
  Category(
    id: 'c1',
    title: 'Budownictwo',
    color: Colors.purple,
  ),
  Category(
    id: 'c2',
    title: 'Transport',
    color: Colors.red,
  ),
  Category(
    id: 'c3',
    title: 'Motoryzacja',
    color: Colors.orange,
  ),
  Category(
    id: 'c4',
    title: 'Praca',
    color: Colors.amber,
  ),
  Category(
    id: 'c5',
    title: 'Malarstwo',
    color: Colors.blue,
  ),
  Category(
    id: 'c6',
    title: 'Fotografia',
    color: Colors.green,
  ),
  Category(
    id: 'c7',
    title: 'Moda',
    color: Colors.lightBlue,
  ),
  Category(
    id: 'c8',
    title: 'Elektornika',
    color: Colors.lightGreen,
  ),
  Category(
    id: 'c9',
    title: 'Ogród',
    color: Colors.pink,
  ),
  Category(
    id: 'c10',
    title: 'Nieruchomości',
    color: Colors.teal,
  ),
];

const DUMMY_MEALS = const [
  Meal(
    id: 'm1',
    categories: [
      'c1',
      'c2',
    ],
    title: 'Malowanie dachów',
    affordability: Affordability.Affordable,
    complexity: Complexity.Simple,
    imageUrl:
        'https://www.grupabiotop.pl/wp-content/uploads/2020/03/malowanie_dachowki_tab.png',
    duration: 20,
    ingredients: [
      'Malowanie dachów',
      'Czyszczenie dachów',
      'Zmiana pokrycia dachowego',
      'Kontrola poszycia dachowegp',
      'Konserwacja dachów',
      'Rozbiórka dachów'
    ],
    steps: [
      'Tanio i szybko.',
      'Fachowa porada.',
      'Wolne terminy.',
      'Gwarancja na wykonaną usługę.',
      'Krótki czas realiacji',
      'Działamy na terenie całego kraju',
    ],
    isGlutenFree: false,
    isVegan: true,
    isVegetarian: true,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm2',
    categories: [
      'c1',
    ],
    title: 'Tynki maszynowe cementowo-wapienne',
    affordability: Affordability.Affordable,
    complexity: Complexity.Simple,
    imageUrl:
        'https://i.ytimg.com/vi/1srOKmSGoZs/maxresdefault.jpg',
    duration: 10,
    ingredients: [
      'Tynki maszynowe cementowo-wapienne',
      'Posadzki zalewane Mixokretem',
      'Gładzie gipsowe',
    ],
    steps: [
      'Szybka realizacja',
      'Terminy dostępne od zaraz',
    ],
    isGlutenFree: false,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm3',
    categories: [
      
      'c10',
    ],
    title: 'Wykończenia wnętrz',
    affordability: Affordability.Pricey,
    complexity: Complexity.Simple,
    imageUrl:
        'https://www.wykop.pl/cdn/c3201142/comment_jOuzkjYRPLgIuX56oWS8w5ukk9dQRC20,w400.jpg',
    duration: 45,
    ingredients: [
      'Malowanie',
      'Szpachlowanie',
      'Tynki dekoracyjne',
      'Beton architektoniczny',
      'Ścianki działowe - sufity powieszane',
      'Glazurnictwo'
	  'Montaż drzwi wewnętrznych'
    ],
    steps: [
      'Profesjonalna realizaja',
      'Dostępne terminy',
    ],
    isGlutenFree: false,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm4',
    categories: [
	  'c10',
	  'c9',
	  'c4',
      'c3',
    ],
    title: 'Młode Wilki',
    affordability: Affordability.Luxurious,
    complexity: Complexity.Challenging,
    imageUrl:
        'https://img3.dmty.pl//uploads/201504/1430043578_ducxae_600.jpg',
    duration: 60,
    ingredients: [
	  'Umiem:',
      'Wymusić okup',
      'Ściągnąć Haracz',
      'Jebnąć ze łba',
      'Gwałty na zlecenie, bez zlecenia z resztą też',
      'Amfetamina',
      'Produkcja',
      'Dystrybucja',
      'Masturbacja'
    ],
    steps: [
      'Najlepszi w mieście',
      'Barwurowa jazda samochodem Cinquecento GRATIS!',
      'Możliwość poznania Krzysztofa Jarzyny ze Szczecina',
    ],
    isGlutenFree: false,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm5',
    categories: [
      'c9'
      'c10',
    ],
    title: 'Meble na wymiar',
    affordability: Affordability.Luxurious,
    complexity: Complexity.Simple,
    imageUrl:
        'https://meblezet.com/9332-home_default/zestaw-mebli-nordi-dab-artisan-czarny.jpg',
    duration: 15,
    ingredients: [
      'Meble kuchenne',
      'Szafy',
      'Regały',
      'Wyposazenie biura',
      'Meble pod zabudowę',
    ],
    steps: [
      'Profesjonalna obsługa',
      'Realizacja nie przekraczająca 3 miesięcy',
      'Możliwość zaprojektowania oraz wykanania pełnych zabudów',
    ],
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm6',
    categories: [
      'c1',
      ],
    title: 'Elewacje, docieplanie budunków',
    affordability: Affordability.Affordable,
    complexity: Complexity.Hard,
    imageUrl:
        'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_1280.jpg',
    duration: 240,
    ingredients: [
      'Kompleksowe docieplanie budunów',
      'Projektowanie izolacji',
      'Podbicia dachowe',
      'Parapety',
    ],
    steps: [
      'Posiadamy wolne terminy',
      'Firma z 10 - letnim doświadczeniem ',
    ],
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm7',
    categories: [
      'c1'
	  'c10',
    ],
    title: 'Parkiety, cylkinowanie bezpyłowe',
    affordability: Affordability.Affordable,
    complexity: Complexity.Simple,
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/07/10/21/23/pancake-3529653_1280.jpg',
    duration: 20,
    ingredients: [
      'Układanie parkietu',
      'Cyklinowanie bezpyłowe',
      'Szpachlowania ubytków  w  parkiecie',
      'Montaż  listew  i  cokołów  przypodłogowych',
      'Lakierowanie, bejcowanie',
      'Polerowania',
      'Renowacja  schodów',
	  'Renowacja  tarasów',
    ],
    steps: [
      'Szybka realizacja',
      'Wycena GRATIS!',
    ],
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm8',
    categories: [
      'c4',
    ],
    title: 'Usługi transportowe Zbyszek Waligrzmot',
    affordability: Affordability.Pricey,
    complexity: Complexity.Challenging,
    imageUrl:
        'https://static.oferteo.pl/images/hero/transport-zlecenia-oferty-a.jpg',
    duration: 35,
    ingredients: [
      'Transport Łodzi',
      'Transport maszyn i urządzeń',
      'Transport wielko-gabarytów',
      'Usługi pomocy drogowej',
    ],
    steps: [
      'Niskie Ceny',
      'Flota gotowa do podjęcia każdego zlecenia',
    ],
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: false,
    isLactoseFree: true,
  ),
  Meal(
    id: 'm9',
    categories: [
      'c8',
    ],
    title: 'Servis RTV AGD',
    affordability: Affordability.Affordable,
    complexity: Complexity.Hard,
    imageUrl:
        'https://img1.dmty.pl//uploads/201401/1390261935_bgk94g_600.jpg',
    duration: 45,
    ingredients: [
      'Serwis urządzeń RTV',
      'Serwis urządzeń AGD',
      'Naprawa klep "jeśli popaliło"',
      'Pomiary instalacji elektrycznej',
    ],
    steps: [
      'Posiadamy wykfalifikowany zespół elektryków na 1.5V ',
      'A elektryk jak saper tylko raz się myli',
      'A jak się pomyli to popiół zostaję nic więcej',
      'Place chocolate pieces in a metal mixing bowl.',
    ],
    isGlutenFree: true,
    isVegan: false,
    isVegetarian: true,
    isLactoseFree: false,
  ),
  Meal(
    id: 'm10',
    categories: [
      'c4',
    ],
    title: 'Krzysztof Jarzyna ze Szczecina Poszukuje do Pracy',
    affordability: Affordability.Luxurious,
    complexity: Complexity.Simple,
    imageUrl:
        'https://i.ytimg.com/vi/4ED0V9vki5Q/maxresdefault.jpg',
    duration: 30,
    ingredients: [
      'Poszukujemy reżysera kina akcjii',
    ],
    steps: [
      'Praca w dynamicznym zespole',
      'Szybko rozwijającym się',
      'Owocowe czwartki',
      'Malinowe piątki',
    ],
    isGlutenFree: true,
    isVegan: true,
    isVegetarian: true,
    isLactoseFree: true,
  ),
];

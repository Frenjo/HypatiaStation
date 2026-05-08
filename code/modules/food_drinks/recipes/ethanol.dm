///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	result = /datum/reagent/ethanol/beer
	required_reagents = alist(/datum/reagent/cornoil = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	result = /datum/reagent/ethanol/kahlua
	required_reagents = alist(/datum/reagent/drink/coffee = 5, /datum/reagent/sugar = 5)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/vodka
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = alist(/datum/reagent/drink/potato_juice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/bilk
	name = "Bilk"
	result = /datum/reagent/ethanol/bilk
	required_reagents = alist(/datum/reagent/ethanol/beer = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /datum/reagent/ethanol/threemileisland
	required_reagents = alist(/datum/reagent/ethanol/longislandicedtea = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	result = /datum/reagent/ethanol/wine
	required_reagents = alist(/datum/reagent/drink/grapejuice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/hooch
	name = "Hooch"
	result = /datum/reagent/ethanol/hooch
	required_reagents = alist(/datum/reagent/fuel = 1, /datum/reagent/ethanol = 2, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	result = /datum/reagent/ethanol/pwine
	required_reagents = alist(/datum/reagent/drink/poisonberryjuice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/sake
	name = "Sake"
	result = /datum/reagent/ethanol/sake
	required_reagents = alist(/datum/reagent/rice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/////////////////////////////////////////////////////////////////cocktail entities//////////////////////////////////////////////
/datum/chemical_reaction/goldschlager
	name = "Goldschlager"
	result = /datum/reagent/ethanol/goldschlager
	required_reagents = alist(/datum/reagent/gold = 1, /datum/reagent/ethanol/vodka = 10)
	result_amount = 10

/datum/chemical_reaction/patron
	name = "Patron"
	result = /datum/reagent/ethanol/patron
	required_reagents = alist(/datum/reagent/silver = 1, /datum/reagent/ethanol/tequilla = 10)
	result_amount = 10

/datum/chemical_reaction/gin_tonic
	name = "Gin and Tonic"
	result = /datum/reagent/ethanol/gintonic
	required_reagents = alist(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/cold/tonic = 2)
	result_amount = 3

/datum/chemical_reaction/cuba_libre
	name = "Cuba Libre"
	result = /datum/reagent/ethanol/cuba_libre
	required_reagents = alist(/datum/reagent/ethanol/rum = 1, /datum/reagent/drink/cold/space_cola = 2)
	result_amount = 3

/datum/chemical_reaction/whiskey_cola
	name = "Whiskey Cola"
	result = /datum/reagent/ethanol/whiskey_cola
	required_reagents = alist(/datum/reagent/drink/cold/space_cola = 2, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/datum/chemical_reaction/martini
	name = "Classic Martini"
	result = /datum/reagent/ethanol/martini
	required_reagents = alist(/datum/reagent/ethanol/gin = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/vodkamartini
	name = "Vodka Martini"
	result = /datum/reagent/ethanol/vodkamartini
	required_reagents = alist(/datum/reagent/ethanol/vermouth = 1, /datum/reagent/ethanol/vodka = 2)
	result_amount = 3

/datum/chemical_reaction/white_russian
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = alist(/datum/reagent/ethanol/black_russian = 3, /datum/reagent/drink/milk/cream = 2)
	result_amount = 5

/datum/chemical_reaction/screwdriver
	name = "Screwdriver"
	result = /datum/reagent/ethanol/screwdrivercocktail
	required_reagents = alist(/datum/reagent/drink/orangejuice = 2, /datum/reagent/ethanol/vodka = 1)
	result_amount = 3

/datum/chemical_reaction/booger
	name = "Booger"
	result = /datum/reagent/ethanol/booger
	required_reagents = alist(
		/datum/reagent/drink/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/rum = 1,
		/datum/reagent/drink/watermelonjuice = 1
	)
	result_amount = 4

/datum/chemical_reaction/bloody_mary
	name = "Bloody Mary"
	result = /datum/reagent/ethanol/bloody_mary
	required_reagents = alist(/datum/reagent/drink/limejuice = 1, /datum/reagent/drink/tomatojuice = 2, /datum/reagent/ethanol/vodka = 1)
	result_amount = 4

/datum/chemical_reaction/brave_bull
	name = "Brave Bull"
	result = /datum/reagent/ethanol/brave_bull
	required_reagents = alist(/datum/reagent/ethanol/kahlua = 1, /datum/reagent/ethanol/tequilla = 2)
	result_amount = 3

/datum/chemical_reaction/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /datum/reagent/ethanol/tequilla_sunrise
	required_reagents = alist(/datum/reagent/drink/grenadine = 1, /datum/reagent/drink/orangejuice = 2, /datum/reagent/ethanol/tequilla = 1)
	result_amount = 3

/datum/chemical_reaction/toxins_special
	name = "Toxins Special"
	result = /datum/reagent/ethanol/toxins_special
	required_reagents = alist(/datum/reagent/plasma = 2, /datum/reagent/ethanol/rum = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 5

/datum/chemical_reaction/beepsky_smash
	name = "Beepksy Smash"
	result = /datum/reagent/ethanol/beepsky_smash
	required_reagents = alist(/datum/reagent/iron = 1, /datum/reagent/drink/limejuice = 2, /datum/reagent/ethanol/whiskey = 2)
	result_amount = 4

/datum/chemical_reaction/irish_cream
	name = "Irish Cream"
	result = /datum/reagent/ethanol/irish_cream
	required_reagents = alist(/datum/reagent/drink/milk/cream = 2, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/datum/chemical_reaction/manly_dorf
	name = "The Manly Dorf"
	result = /datum/reagent/ethanol/manly_dorf
	required_reagents = alist(/datum/reagent/ethanol/ale = 2, /datum/reagent/ethanol/beer = 1)
	result_amount = 3

/datum/chemical_reaction/longislandicedtea
	name = "Long Island Iced Tea"
	result = /datum/reagent/ethanol/longislandicedtea
	required_reagents = alist(
		/datum/reagent/ethanol/cuba_libre = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/tequilla = 1,
		/datum/reagent/ethanol/vodka = 1
	)
	result_amount = 4

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	result = /datum/reagent/ethanol/moonshine
	required_reagents = alist(/datum/reagent/nutriment = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/b52
	name = "B-52"
	result = /datum/reagent/ethanol/b52
	required_reagents = alist(/datum/reagent/ethanol/cognac = 1, /datum/reagent/ethanol/irish_cream = 1, /datum/reagent/ethanol/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/irish_coffee
	name = "Irish Coffee"
	result = /datum/reagent/ethanol/irishcoffee
	required_reagents = alist(/datum/reagent/drink/coffee = 1, /datum/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/margarita
	name = "Margarita"
	result = /datum/reagent/ethanol/margarita
	required_reagents = alist(/datum/reagent/drink/limejuice = 1, /datum/reagent/ethanol/tequilla = 2)
	result_amount = 3

/datum/chemical_reaction/black_russian
	name = "Black Russian"
	result = /datum/reagent/ethanol/black_russian
	required_reagents = alist(/datum/reagent/ethanol/kahlua = 2, /datum/reagent/ethanol/vodka = 3)
	result_amount = 5

/datum/chemical_reaction/manhattan
	name = "Manhattan"
	result = /datum/reagent/ethanol/manhattan
	required_reagents = alist(/datum/reagent/ethanol/vermouth = 1, /datum/reagent/ethanol/whiskey = 2)
	result_amount = 3

/datum/chemical_reaction/manhattan_proj
	name = "Manhattan Project"
	result = /datum/reagent/ethanol/manhattan_proj
	required_reagents = alist(/datum/reagent/ethanol/manhattan = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/whiskeysoda
	name = "Whiskey Soda"
	result = /datum/reagent/ethanol/whiskeysoda
	required_reagents = alist(/datum/reagent/drink/cold/sodawater = 1, /datum/reagent/ethanol/whiskey = 2)
	result_amount = 3

/datum/chemical_reaction/antifreeze
	name = "Anti-freeze"
	result = /datum/reagent/ethanol/antifreeze
	required_reagents = alist(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/cold/ice = 1, /datum/reagent/ethanol/vodka = 2)
	result_amount = 4

/datum/chemical_reaction/barefoot
	name = "Barefoot"
	result = /datum/reagent/ethanol/barefoot
	required_reagents = alist(/datum/reagent/drink/berryjuice = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/snowwhite
	name = "Snow White"
	result = /datum/reagent/ethanol/snowwhite
	required_reagents = alist(/datum/reagent/ethanol/beer = 1, /datum/reagent/drink/cold/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	result = /datum/reagent/ethanol/melonliquor
	required_reagents = alist(/datum/reagent/drink/watermelonjuice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	result = /datum/reagent/ethanol/bluecuracao
	required_reagents = alist(/datum/reagent/drink/orangejuice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/suidream
	name = "Sui Dream"
	result = /datum/reagent/ethanol/suidream
	required_reagents = alist(/datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/ethanol/melonliquor = 1, /datum/reagent/drink/cold/space_up = 2)
	result_amount = 4

/datum/chemical_reaction/demonsblood
	name = "Demons Blood"
	result = /datum/reagent/ethanol/demonsblood
	required_reagents = alist(
		/datum/reagent/blood = 1, /datum/reagent/drink/cold/dr_gibb = 1, /datum/reagent/ethanol/rum = 1,
		/datum/reagent/drink/cold/spacemountainwind = 1
	)
	result_amount = 4

/datum/chemical_reaction/vodka_tonic
	name = "Vodka and Tonic"
	result = /datum/reagent/ethanol/vodkatonic
	required_reagents = alist(/datum/reagent/drink/cold/tonic = 2, /datum/reagent/ethanol/vodka = 1)
	result_amount = 3

/datum/chemical_reaction/gin_fizz
	name = "Gin Fizz"
	result = /datum/reagent/ethanol/ginfizz
	required_reagents = alist(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/cold/sodawater = 2)
	result_amount = 4

/datum/chemical_reaction/bahama_mama
	name = "Bahama mama"
	result = /datum/reagent/ethanol/bahama_mama
	required_reagents = alist(
		/datum/reagent/drink/cold/ice = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/orangejuice = 2,
		/datum/reagent/ethanol/rum = 2
	)
	result_amount = 6

/datum/chemical_reaction/singulo
	name = "Singulo"
	result = /datum/reagent/ethanol/singulo
	required_reagents = alist(/datum/reagent/radium = 1, /datum/reagent/ethanol/vodka = 5, /datum/reagent/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/sbiten
	name = "Sbiten"
	result = /datum/reagent/ethanol/sbiten
	required_reagents = alist(/datum/reagent/capsaicin = 1, /datum/reagent/ethanol/vodka = 10)
	result_amount = 10

/datum/chemical_reaction/devilskiss
	name = "Devils Kiss"
	result = /datum/reagent/ethanol/devilskiss
	required_reagents = alist(/datum/reagent/blood = 1, /datum/reagent/ethanol/kahlua = 1, /datum/reagent/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/red_mead
	name = "Red Mead"
	result = /datum/reagent/ethanol/red_mead
	required_reagents = alist(/datum/reagent/blood = 1, /datum/reagent/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/mead
	name = "Mead"
	result = /datum/reagent/ethanol/mead
	required_reagents = alist(/datum/reagent/sugar = 1, /datum/reagent/water = 1)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/iced_beer
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = alist(/datum/reagent/ethanol/beer = 10, /datum/reagent/frostoil = 1)
	result_amount = 10

/datum/chemical_reaction/iced_beer/secondary
	required_reagents = alist(/datum/reagent/ethanol/beer = 5, /datum/reagent/drink/cold/ice = 1)
	result_amount = 6

/datum/chemical_reaction/grog
	name = "Grog"
	result = /datum/reagent/ethanol/grog
	required_reagents = alist(/datum/reagent/ethanol/rum = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/aloe
	name = "Aloe"
	result = /datum/reagent/ethanol/aloe
	required_reagents = alist(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/watermelonjuice = 1, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 2

/datum/chemical_reaction/andalusia
	name = "Andalusia"
	result = /datum/reagent/ethanol/andalusia
	required_reagents = alist(/datum/reagent/drink/lemonjuice = 1, /datum/reagent/ethanol/rum = 1, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/datum/chemical_reaction/alliescocktail
	name = "Allies Cocktail"
	result = /datum/reagent/ethanol/alliescocktail
	required_reagents = alist(/datum/reagent/ethanol/martini = 1, /datum/reagent/ethanol/vodka = 1)
	result_amount = 2

/datum/chemical_reaction/acidspit
	name = "Acid Spit"
	result = /datum/reagent/ethanol/acid_spit
	required_reagents = alist(/datum/reagent/toxin/acid = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 6

/datum/chemical_reaction/amasec
	name = "Amasec"
	result = /datum/reagent/ethanol/amasec
	required_reagents = alist(/datum/reagent/iron = 1, /datum/reagent/ethanol/vodka = 5, /datum/reagent/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/changelingsting
	name = "Changeling Sting"
	result = /datum/reagent/ethanol/changelingsting
	required_reagents = alist(/datum/reagent/drink/lemonjuice = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/ethanol/screwdrivercocktail = 1)
	result_amount = 5

/datum/chemical_reaction/irishcarbomb
	name = "Irish Car Bomb"
	result = /datum/reagent/ethanol/irishcarbomb
	required_reagents = alist(/datum/reagent/ethanol/ale = 1, /datum/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/syndicatebomb
	name = "Syndicate Bomb"
	result = /datum/reagent/ethanol/syndicatebomb
	required_reagents = alist(/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/whiskey_cola = 1)
	result_amount = 2

/datum/chemical_reaction/erikasurprise
	name = "Erika Surprise"
	result = /datum/reagent/ethanol/erikasurprise
	required_reagents = alist(
		/datum/reagent/ethanol/ale = 1, /datum/reagent/drink/banana = 1, /datum/reagent/drink/cold/ice = 1,
		/datum/reagent/drink/limejuice = 1, /datum/reagent/ethanol/whiskey = 1
	)
	result_amount = 5

/datum/chemical_reaction/driestmartini
	name = "Driest Martini"
	result = /datum/reagent/ethanol/driestmartini
	required_reagents = alist(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/nothing = 1)
	result_amount = 2

/datum/chemical_reaction/bananahonk
	name = "Banana Honk"
	result = /datum/reagent/ethanol/bananahonk
	required_reagents = alist(/datum/reagent/drink/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/silencer
	name = "Silencer"
	result = /datum/reagent/ethanol/silencer
	required_reagents = alist(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/nothing = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine_surprise
	name = "Tricordrazine Surprise"
	result = /datum/reagent/ethanol/tricordrazine_surprise
	required_reagents = alist(/datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/tricordrazine = 1)
	result_amount = 3

//////////////////////////////////////////////The ten friggen million reagents that get you drunk//////////////////////////////////////////////
/datum/chemical_reaction/atomicbomb
	name = "Atomic Bomb"
	result = /datum/reagent/atomicbomb
	required_reagents = alist(/datum/reagent/ethanol/b52 = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	result = /datum/reagent/gargle_blaster
	required_reagents = alist(
		/datum/reagent/ethanol/cognac = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/drink/limejuice = 1,
		/datum/reagent/ethanol/vodka = 1, /datum/reagent/ethanol/whiskey = 1
	)
	result_amount = 5

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	result = /datum/reagent/neurotoxin
	required_reagents = alist(/datum/reagent/gargle_blaster = 1, /datum/reagent/toxin/soporific = 1)
	result_amount = 2

/datum/chemical_reaction/hippiesdelight
	name = "Hippies Delight"
	result = /datum/reagent/hippies_delight
	required_reagents = alist(/datum/reagent/gargle_blaster = 1, /datum/reagent/psilocybin = 1)
	result_amount = 2
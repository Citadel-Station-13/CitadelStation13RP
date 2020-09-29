/* 'basic' language; spoken by default.
/datum/language/common
	name = "Galactic Common"
	desc = "The common galactic tongue."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED
	syllables = list("blah","blah","blah","bleh","meh","neh","nah","wah")
*/

/datum/language/birdsong
	name = LANGUAGE_BIRDSONG
	desc = "A language primarily spoken by Narvians"
	speech_verb = "chirps"
	color = "birdsongc"
	key = "7"
	syllables = list ("cheep", "peep", "tweet")

/datum/language/sergal
	name = LANGUAGE_SAGARU
	desc = "The dominant language of the Sergal homeworld, Vilous. It consists of aggressive low-pitched hissing and throaty growling."
	speech_verb = "snarls"
	color = "sergal"
	key = "T"
	syllables = list ("grr", "gah", "woof", "arf", "arra", "rah", "wor", "sarg")

/datum/language/vulpkanin
	name = LANGUAGE_CANILUNZT
	desc = "The guttural language spoken and utilized by the inhabitants of Vazzend system, composed of growls, barks, yaps, and heavy utilization of ears and tail movements. Vulpkanin speak this language with ease."
	speech_verb = "rrrfts"
	ask_verb = "rurs"
	exclaim_verb = "barks"
	color = "vulpkanin"
	key = "8"
	syllables = list("rur","ya","cen","rawr","bar","kuk","tek","qat","uk","wu","vuh","tah","tch","schz","auch", \
	"ist","ein","entch","zwichs","tut","mir","wo","bis","es","vor","nic","gro","lll","enem","zandt","tzch","noch", \
	"hel","ischt","far","wa","baram","iereng","tech","lach","sam","mak","lich","gen","or","ag","eck","gec","stag","onn", \
	"bin","ket","jarl","vulf","einech","cresthz","azunein","ghzth")

/datum/language/squirrel
	name = LANGUAGE_ECUREUILIAN
	desc = "The native tongue of the inhabitants of Gaia. Squirrelkin and other beastkins of Gaia can use their ears and tails in addition to speech to communitcate."
	speech_verb = "squeaks"
	whisper_verb = "whispers"
	exclaim_verb = "chitters"
	key = "9"
	syllables = list("sque","sqah","boo","beh","nweh","boopa","nah","wah","een","sweh")

/datum/language/demon
	name = LANGUAGE_DAEMON
	desc = "The language spoken by the demons of Infernum, it's composed of deep chanting. It's rarely spoken off of Infernum due to the volume one has to exert."
	speech_verb = "chants"
	ask_verb = "croons"
	exclaim_verb = "incants"
	color = "daemon" //So fancy
	key = "n"
	syllables = list("viepn","e","bag","docu","kar","xlaqf","raa","qwos","nen","ty","von","kytaf","xin","ty","ka","baak","hlafaifpyk","znu","agrith","na'ar","uah","plhu","six","fhler","bjel","scee","lleri",
	"dttm","aggr","uujl","hjjifr","wwuthaav",)
	machine_understands = FALSE

/datum/language/angel
	name = LANGUAGE_ENOCHIAN
	desc = "The graceful language spoken by angels, composed of quiet hymns. Formally, Angels sing it."
	speech_verb = "sings"
	ask_verb = "hums"
	exclaim_verb = "loudly sings"
	color = "enochian" //So fancy
	key = "i"
	syllables = list("salve","sum","loqui","operatur","iusta","et","permittit","facere","effercio","pluribus","enim","hoc",
	"mihi","wan","six","tartu")
	machine_understands = FALSE

/datum/language/bug
	name = LANGUAGE_VESPINAE
	desc = "A jarring and clicky language developed and used by Vasilissans, it is designed for use with mouthparts and as a result has become a common language for various arthropod species."
	speech_verb = "clicks"
	ask_verb = "chitters"
	exclaim_verb = "rasps"
	color = "bug"
	key = "x"
	syllables = list("vaur","uyek","uyit","avek","sc'theth","k'ztak","teth","wre'ge","lii","dra'","zo'","ra'","kax'","zz","vh","ik","ak",
    "uhk","zir","sc'orth","sc'er","thc'yek","th'zirk","th'esk","k'ayek","ka'mil","sc'","ik'yir","yol","kig","k'zit","'","'","zrk","krg","isk'yet","na'k",
    "sc'azz","th'sc","nil","n'ahk","sc'yeth","aur'sk","iy'it","azzg","a'","i'","o'","u'","a","i","o","u","zz","kr","ak","nrk","tzzk","bz","xic'","k'lax'","histh")

/datum/language/shadekin
	name = LANGUAGE_SHADEKIN
	desc = "Shadekin seem to always know what the others are thinking. This is probably why."
	speech_verb = "mars"
	ask_verb = "mars"
	exclaim_verb = "mars"
	color = "changeling"
	key = "m"
	machine_understands = FALSE
	flags = WHITELISTED | HIVEMIND

/datum/language/slavic
	name = LANGUAGE_SLAVIC
	desc = "The official language of the Independent Colonial Confederation of Gilgamesh, originally established in 2122 by the short-lived United Slavic Confederation on Earth."
	color = "solcom"
	key = "g"
	syllables = list(
		"rus", "zem", "ave", "groz", "ski", "ska", "ven", "konst", "pol", "lin", "svy",
		"danya", "da", "mied", "zan", "das", "krem", "myka", "to", "st", "no", "na", "ni",
		"ko", "ne", "en", "po", "ra", "li", "on", "byl", "cto", "eni", "ost", "ol", "ego",
		"ver", "stv", "pro"
	)

/datum/language/bones
	name = LANGUAGE_BONES
	desc = "The language of skeletons, characterised by clunks and clatters. Native language of Phoronoids."
	speech_verb = "rattles"
	ask_verb = "clinks"
	exclaim_verb = "clunks"
	color = "changeling"
	key = "c"
	syllables = list("clatter","tink","chink","clack","rattle","clink","clunk","dink","tonk","donk","plink,","plonk")

/datum/language/unathi
	flags = NONE
/datum/language/tajaran
	flags = NONE
/datum/language/skrell
	flags = NONE
/datum/language/human
	flags = NONE
/datum/language/teshari
	flags = NONE
/datum/language/zaddat
	flags = NONE
/datum/language/gutter
	flags = NONE
	machine_understands = FALSE
/datum/language/human/monkey
	flags = RESTRICTED
/datum/language/skrell/monkey
	flags = RESTRICTED
/datum/language/unathi/monkey
	flags = RESTRICTED
/datum/language/tajaran/monkey
	flags = RESTRICTED

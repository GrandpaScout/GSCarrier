/**
 * @typedef {{
 *  desc?: string,
 *  implies?: string[],
 *  conflicts?: string[],
 *  internal?: boolean,
 * }} TagData
**/

/** @type {{[name: string]: TagData}} */
module.exports = {
  // CLASS TAGS
  "class:cem": {
    desc: `
      This avatar is a non-player entity.

      This tag is always applied to non-player avatars.
    `,
    conflicts: ["class:player"],
    internal: true
  },
  "class:player": {
    desc: `
      This avatar is a player entity.

      This tag is always applied to player avatars.
    `,
    conflicts: ["class:cem"],
    internal: true
  },

  // SHAPE TAGS
  "shape:vertical_posture": {
    desc: `
      This avatar defaults to a vertical posture.  
      This is mostly orthogrades.
    `,
    conflicts: ["shape:horizontal_posture", "shape:amorphous"]
  },
  "shape:horizontal_posture": {
    desc: `
      This avatar defaults to a horizontal posture.  
      This is mostly pronogrades.
    `,
    conflicts: ["shape:vertical_posture"]
  },
  "shape:simple": {
    desc: `
      This avatar has a simple shape.  
      This is common with avatars that are objects/robotic.
    `,
    conflicts: ["shape:horizontal_posture", "shape:vertical_posture", "shape:amorphous"]
  },
  "shape:amorphous": {
    desc: `This avatar has no definable shape.`,
    conflicts: ["shape:horizontal_posture", "shape:vertical_posture", "shape:simple"]
  },

  // SPECIES MODIFIER TAGS
  "species:humanoid": {
    desc: `
      This avatar has very human-like features.

      This can be combined with other species tags to create a (species)-humanoid.
    `,
    conflicts: ["species:anthro", "species:feral"]
  },
  "species:anthro": {
    desc: `
      This avatar has features of an anthropomorphic animal character.

      This can be combined with other species tags to create an anthro (species).
    `,
    conflicts: ["species:humanoid", "species:feral"]
  },
  "species:feral": {
    desc: `
      This avatar has features of a feral animal.

      This can be combined with other species tags to create a feral (species).
    `,
    conflicts: ["species:humanoid", "species:anthro"]
  },

  "species:amphibian": {
    desc: `
      This avatar is an amphibian or has features of one.
    `
  },
  "species:frog": {
    desc: `
      This avatar is a frog or has features of one.
    `,
    implies: ["species:amphibian"]
  },
  "species:salamander": {
    desc: `
      This avatar is a salamander or has features of one.
    `,
    implies: ["species:amphibian"]
  },
  "species:arthropod": {
    desc: `
      This avatar is an arthropod or has features of one.
    `
  },
  "species:arachnid": {
    desc: `
      This avatar is an arachnid or has features of one.
    `,
    implies: ["species:arthropod"]
  },
  "species:scorpion": {
    desc: `
      This avatar is a scorpion or has features of one.
    `,
    implies: ["species:arachnid"]
  },
  "species:spider": {
    desc: `
      This avatar is a spider or has features of one.
    `,
    implies: ["species:arachnid"]
  },
  "species:crustacean": {
    desc: `
      This avatar is a crustacean or has features of one.
    `,
    implies: ["species:arthropod"]
  },
  "species:crab": {
    desc: `
      This avatar is a crab or has features of one.
    `,
    implies: ["species:crustacean"]
  },
  "species:lobster": {
    desc: `
      This avatar is a lobster or has features of one.
    `,
    implies: ["species:crustacean"]
  },
  "species:shrimp": {
    desc: `
      This avatar is a shrimp or has features of one.
    `,
    implies: ["species:crustacean"]
  },
  "species:insect": {
    desc: `
      This avatar is an insect or has features of one.
    `,
    implies: ["species:arthropod"]
  },
  "species:beetle": {
    desc: `
      This avatar is a beetle or has features of one.
    `,
    implies: ["species:insect"]
  },
  "species:ant": {
    desc: `
      This avatar is an ant or has features of one.
    `,
    implies: ["species:insect"]
  },
  "species:bee": {
    desc: `
      This avatar is a bee or has features of one.
    `,
    implies: ["species:insect"]
  },
  "species:wasp": {
    desc: `
      This avatar is a wasp or has features of one.
    `,
    implies: ["species:insect"]
  },
  "species:butterfly": {
    desc: `
      This avatar is a butterfly or has features of one.
    `,
    implies: ["species:insect"]
  },
  "species:moth": {
    desc: `
      This avatar is a moth or has features of one.
    `,
    implies: ["species:insect"]
  },
  "species:avian": {
    desc: `
      This avatar is an avian or has features of one.
    `
  },
  "species:bird": {
    desc: `
      This avatar is a bird or has features of one.
    `,
    implies: ["species:avian"]
  },
  "species:hawk": {
    desc: `
      This avatar is a hawk or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:eagle": {
    desc: `
      This avatar is an eagle or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:vulture": {
    desc: `
      This avatar is a vulture or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:goose": {
    desc: `
      This avatar is a goose or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:swan": {
    desc: `
      This avatar is a swan or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:duck": {
    desc: `
      This avatar is a duck or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:dove": {
    desc: `
      This avatar is a dove or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:pigeon": {
    desc: `
      This avatar is a pigeon or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:corvid": {
    desc: `
      This avatar is a corvid or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:crow": {
    desc: `
      This avatar is a crow or has features of one.
    `,
    implies: ["species:corvid"]
  },
  "species:raven": {
    desc: `
      This avatar is a raven or has features of one.
    `,
    implies: ["species:corvid"]
  },
  "species:jay": {
    desc: `
      This avatar is a jay or has features of one.
    `,
    implies: ["species:corvid"]
  },
  "species:corvid_magpie": {
    desc: `
      This avatar is a corvid magpie or has features of one.
    `,
    implies: ["species:corvid"]
  },
  "species:falcon": {
    desc: `
      This avatar is a falcon or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:finch": {
    desc: `
      This avatar is a finch or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:flamingo": {
    desc: `
      This avatar is a flamingo or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:chicken": {
    desc: `
      This avatar is a chicken or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:peafowl": {
    desc: `
      This avatar is a peafowl or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:turkey": {
    desc: `
      This avatar is a turkey or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:crane": {
    desc: `
      This avatar is a crane or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:swallow": {
    desc: `
      This avatar is a swallow or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:hummingbird": {
    desc: `
      This avatar is a hummingbird or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:seagull": {
    desc: `
      This avatar is a seagull or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:owl": {
    desc: `
      This avatar is a owl or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:parrot": {
    desc: `
      This avatar is a parrot or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:cockatoo": {
    desc: `
      This avatar is a cockatoo or has features of one.
    `,
    implies: ["species:parrot"]
  },
  "species:parakeet": {
    desc: `
      This avatar is a parakeet or has features of one.
    `,
    implies: ["species:parrot"]
  },
  "species:heron": {
    desc: `
      This avatar is a heron or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:pelican": {
    desc: `
      This avatar is a pelican or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:penguin": {
    desc: `
      This avatar is a penguin or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:woodpecker": {
    desc: `
      This avatar is a woodpecker or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:ostrich": {
    desc: `
      This avatar is an ostrich or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:robin": {
    desc: `
      This avatar is a robin or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:stork": {
    desc: `
      This avatar is a stork or has features of one.
    `,
    implies: ["species:bird"]
  },
  "species:toucan": {
    desc: `
      This avatar is a toucan or has features of one.
    `,
    implies: ["species:bird"]
  },
  // Fictional Birds
  "species:phoenix": {
    desc: `
      This avatar is a phoenix or has features of one.
    `,
    implies: ["species:bird"]
  },
  // Fictional Avians
  "species:gryphon": {
    desc: `
      This avatar is a gryphon or has features of one.
    `,
    implies: ["species:avian"]
  },
  "species:harpy": {
    desc: `
      This avatar is a harpy or has features of one.
    `,
    implies: ["species:avian"]
  },
  "species:avali": {
    desc: `
      This avatar is an avali or has features of one.
    `,
    implies: ["species:avian"]
  },
  "species:chocobo": {
    desc: `
      This avatar is a chocobo or has features of one.
    `,
    implies: ["species:avian"]
  },
  // Mammals
  "species:mammal": {
    desc: `
      This avatar is a mammal or has features of one.
    `
  },
  "species:antelope": {
    desc: `
      This avatar is an antelope or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:gazelle": {
    desc: `
      This avatar is a gazelle or has features of one.
    `,
    implies: ["species:antelope"]
  },
  "species:bovine": {
    desc: `
      This avatar is a bovine or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:buffalo": {
    desc: `
      This avatar is a buffalo or has features of one.
    `,
    implies: ["species:bovine"]
  },
  "species:bison": {
    desc: `
      This avatar is a bison or has features of one.
    `,
    implies: ["species:bovine"]
  },
  "species:cow": {
    desc: `
      This avatar is a cow or has features of one.
    `,
    implies: ["species:bovine"]
  },
  "species:canine": {
    desc: `
      This avatar is a canine or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:coyote": {
    desc: `
      This avatar is a coyote or has features of one.
    `,
    implies: ["species:canine"]
  },
  "species:dog": {
    desc: `
      This avatar is a domestic dog or has features of one.
    `,
    implies: ["species:canine"]
  },
  "species:fox": {
    desc: `
      This avatar is a fox or has features of one.
    `,
    implies: ["species:canine"]
  },
  "species:jackal": {
    desc: `
      This avatar is a jackal or has features of one.
    `,
    implies: ["species:canine"]
  },
  "species:anubian_jackal": {
    desc: `
      This avatar is a anubian_jackal or has features of one.
    `,
    implies: ["species:jackal"]
  },
  "species:tanuki": {
    desc: `
      This avatar is a tanuki or has features of one.
    `,
    implies: ["species:canine"]
  },
  "species:wolf": {
    desc: `
      This avatar is a wolf or has features of one.
    `,
    implies: ["species:canine"]
  },
  "species:cerberus": {
    desc: `
      This avatar is cerberus or has features of the character.
    `,
    implies: ["species:canine"]
  },
  "species:camelid": {
    desc: `
      This avatar is a camelid or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:alpaca": {
    desc: `
      This avatar is a alpaca or has features of one.
    `,
    implies: ["species:camelid"]
  },
  "species:camel": {
    desc: `
      This avatar is a camel or has features of one.
    `,
    implies: ["species:camelid"]
  },
  "species:llama": {
    desc: `
      This avatar is a llama or has features of one.
    `,
    implies: ["species:camelid"]
  },
  "species:caprine": {
    desc: `
      This avatar is a caprine or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:goat": {
    desc: `
      This avatar is a goat or has features of one.
    `,
    implies: ["species:caprine"]
  },
  "species:sheep": {
    desc: `
      This avatar is a sheep or has features of one.
    `,
    implies: ["species:caprine"]
  },
  "species:cervine": {
    desc: `
      This avatar is a cervine or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:deer": {
    desc: `
      This avatar is a deer or has features of one.
    `,
    implies: ["species:cervine"]
  },
  "species:elk": {
    desc: `
      This avatar is an elk or has features of one.
    `,
    implies: ["species:cervine"]
  },
  "species:moose": {
    desc: `
      This avatar is a moose or has features of one.
    `,
    implies: ["species:cervine"]
  },
  "species:reindeer": {
    desc: `
      This avatar is a reindeer or has features of one.
    `,
    implies: ["species:cervine"]
  },
  "species:equine": {
    desc: `
      This avatar is an equine or has features of one.
    `,
    implies: []
  },
  "species:donkey": {
    desc: `
      This avatar is a donkey or has features of one.
    `,
    implies: ["species:equine"]
  },
  "species:horse": {
    desc: `
      This avatar is a horse or has features of one.
    `,
    implies: ["species:equine"]
  },
  "species:zebra": {
    desc: `
      This avatar is a zebra or has features of one.
    `,
    implies: ["species:equine"]
  },
  "species:pegasus": {
    desc: `
      This avatar is a pegasus or has features of one.
    `,
    implies: ["species:equine"]
  },
  "species:unicorn": {
    desc: `
      This avatar is a unicorn or has features of one.
    `,
    implies: ["species:equine"]
  },
  "species:winged_unicorn": {
    desc: `
      This avatar is a winged unicorn or has features of one.
    `,
    implies: ["species:equine"]
  },
  "species:feline": {
    desc: `
      This avatar is a feline or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:cougar": {
    desc: `
      This avatar is a cougar or has features of one.
    `,
    implies: ["species:feline"]
  },
  "species:lynx": {
    desc: `
      This avatar is a lynx or has features of one.
    `,
    implies: ["species:feline"]
  },
  "species:ocelot": {
    desc: `
      This avatar is anw ocelot or has features of one.
    `,
    implies: ["species:feline"]
  },
  "species:cheetah": {
    desc: `
      This avatar is a cheetah or has features of one.
    `,
    implies: ["species:feline"]
  },
  "species:cat": {
    desc: `
      This avatar is a cat or has features of one.
    `,
    implies: ["species:feline"]
  },
  "species:pantherine": {
    desc: `
      This avatar is a pantherine or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:jaguar": {
    desc: `
      This avatar is a jaguar or has features of one.
    `,
    implies: ["species:pantherine"]
  },
  "species:leopard": {
    desc: `
      This avatar is a leopard or has features of one.
    `,
    implies: ["species:pantherine"]
  },
  "species:lion": {
    desc: `
      This avatar is a lion or has features of one.
    `,
    implies: ["species:pantherine"]
  },
  "species:tiger": {
    desc: `
      This avatar is a tiger or has features of one.
    `,
    implies: ["species:pantherine"]
  },
  "species:lagomorph": {
    desc: `
      This avatar is a lagomorph or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:hare": {
    desc: `
      This avatar is a hare or has features of one.
    `,
    implies: ["species:lagomorph"]
  },
  "species:rabbit": {
    desc: `
      This avatar is a rabbit or has features of one.
    `,
    implies: ["species:lagomorph"]
  },
  "species:jackalope": {
    desc: `
      This avatar is a jackalope or has features of one.
    `,
    implies: ["species:lagomorph"]
  },
  "species:cetacean": {
    desc: `
      This avatar is a cetacean or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:dolphin": {
    desc: `
      This avatar is a dolphin or has features of one.
    `,
    implies: ["species:cetacean"]
  },
  "species:whale": {
    desc: `
      This avatar is a whale or has features of one.
    `,
    implies: ["species:cetacean"]
  },
  "species:pinniped": {
    desc: `
      This avatar is a pinniped or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:sea_lion": {
    desc: `
      This avatar is a sea_lion or has features of one.
    `,
    implies: ["species:pinniped"]
  },
  "species:seal": {
    desc: `
      This avatar is a seal or has features of one.
    `,
    implies: ["species:pinniped"]
  },
  "species:walrus": {
    desc: `
      This avatar is a walrus or has features of one.
    `,
    implies: ["species:pinniped"]
  },
  "species:marsupial": {
    desc: `
      This avatar is a marsupial or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:kangaroo": {
    desc: `
      This avatar is a kangaroo or has features of one.
    `,
    implies: ["species:marsupial"]
  },
  "species:koala": {
    desc: `
      This avatar is a koala or has features of one.
    `,
    implies: ["species:marsupial"]
  },
  "species:opossum": {
    desc: `
      This avatar is an opossum or has features of one.
    `,
    implies: ["species:marsupial"]
  },
  "species:echidna": {
    desc: `
      This avatar is anw echidna or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:platypus": {
    desc: `
      This avatar is a platypus or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:mustelid": {
    desc: `
      This avatar is a mustelid or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:badger": {
    desc: `
      This avatar is a badger or has features of one.
    `,
    implies: ["species:mustelid"]
  },
  "species:ferret": {
    desc: `
      This avatar is a ferret or has features of one.
    `,
    implies: ["species:mustelid"]
  },
  "species:otter": {
    desc: `
      This avatar is a otter or has features of one.
    `,
    implies: ["species:mustelid"]
  },
  "species:weasel": {
    desc: `
      This avatar is a weasel or has features of one.
    `,
    implies: ["species:mustelid"]
  },
  "species:primate": {
    desc: `
      This avatar is a primate or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:ape": {
    desc: `
      This avatar is a ape or has features of one.
    `,
    implies: ["species:primate"]
  },
  "species:gorilla": {
    desc: `
      This avatar is a gorilla or has features of one.
    `,
    implies: ["species:primate"]
  },
  "species:monkey": {
    desc: `
      This avatar is a monkey or has features of one.
    `,
    implies: ["species:primate"]
  },
  "species:rodent": {
    desc: `
      This avatar is a rodent or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:beaver": {
    desc: `
      This avatar is a beaver or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:chipmunk": {
    desc: `
      This avatar is a chipmunk or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:hamster": {
    desc: `
      This avatar is a hamster or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:mouse": {
    desc: `
      This avatar is a mouse or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:porcupine": {
    desc: `
      This avatar is a porcupine or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:rat": {
    desc: `
      This avatar is a rat or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:squirrel": {
    desc: `
      This avatar is a squirrel or has features of one.
    `,
    implies: ["species:rodent"]
  },
  "species:porcine": {
    desc: `
      This avatar is a porcine or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:pig": {
    desc: `
      This avatar is a pig or has features of one.
    `,
    implies: ["species:porcine"]
  },
  "species:boar": {
    desc: `
      This avatar is a boar or has features of one.
    `,
    implies: ["species:porcine"]
  },
  "species:warthog": {
    desc: `
      This avatar is a warthog or has features of one.
    `,
    implies: ["species:porcine"]
  },
  "species:ursid": {
    desc: `
      This avatar is a ursid or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:panda": {
    desc: `
      This avatar is a panda or has features of one.
    `,
    implies: ["species:ursid"]
  },
  "species:bear": {
    desc: `
      This avatar is a bear or has features of one.
    `,
    implies: ["species:ursid"]
  },
  "species:armadillo": {
    desc: `
      This avatar is an armadillo or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:bat": {
    desc: `
      This avatar is a bat or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:elephant": {
    desc: `
      This avatar is an elephant or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:giraffe": {
    desc: `
      This avatar is a giraffe or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:hedgehog": {
    desc: `
      This avatar is a hedgehog or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:hippopotamus": {
    desc: `
      This avatar is a hippopotamus or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:human": {
    desc: `
      This avatar is a human or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:hyena": {
    desc: `
      This avatar is a hyena or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:raccoon": {
    desc: `
      This avatar is a raccoon or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:red_panda": {
    desc: `
      This avatar is a red_panda or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:rhinoceros": {
    desc: `
      This avatar is a rhinoceros or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:skunk": {
    desc: `
      This avatar is a skunk or has features of one.
    `,
    implies: ["species:mammal"]
  },
  "species:gastropod": {
    desc: `
      This avatar is a gastropod or has features of one.
    `
  },
  "species:slug": {
    desc: `
      This avatar is a slug or has features of one.
    `,
    implies: ["species:gastropod"]
  },
  "species:snail": {
    desc: `
      This avatar is a snail or has features of one.
    `,
    implies: ["species:gastropod"]
  },
  "species:cephalopod": {
    desc: `
      This avatar is a cephalopod or has features of one.
    `
  },
  "species:octopus": {
    desc: `
      This avatar is an octopus or has features of one.
    `,
    implies: ["species:cephalopod"]
  },
  "species:octoling": {
    desc: `
      This avatar is an octoling or has features of one.
    `,
    implies: ["species:octopus"]
  },
  "species:squid": {
    desc: `
      This avatar is a squid or has features of one.
    `,
    implies: ["species:cephalopod"]
  },
  "species:inkling": {
    desc: `
      This avatar is an inkling or has features of one.
    `,
    implies: ["species:squid"]
  },
  "species:fish": {
    desc: `
      This avatar is a fish or has features of one.
    `
  },
  "species:pufferfish": {
    desc: `
      This avatar is a pufferfish or has features of one.
    `,
    implies: ["species:fish"]
  },
  "species:shark": {
    desc: `
      This avatar is a shark or has features of one.
    `,
    implies: ["species:fish"]
  },
  "species:reptile": {
    desc: `
      This avatar is a reptile or has features of one.
    `
  },
  "species:alligator": {
    desc: `
      This avatar is an alligator or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:crocodile": {
    desc: `
      This avatar is a crocodile or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:dinosaur": {
    desc: `
      This avatar is a dinosaur or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:lizard": {
    desc: `
      This avatar is a lizard or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:chameleon": {
    desc: `
      This avatar is a chameleon or has features of one.
    `,
    implies: ["species:lizard"]
  },
  "species:gecko": {
    desc: `
      This avatar is a gecko or has features of one.
    `,
    implies: ["species:lizard"]
  },
  "species:iguana": {
    desc: `
      This avatar is an iguana or has features of one.
    `,
    implies: ["species:lizard"]
  },
  "species:snake": {
    desc: `
      This avatar is a snake or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:boa": {
    desc: `
      This avatar is a boa or has features of one.
    `,
    implies: ["species:snake"]
  },
  "species:cobra": {
    desc: `
      This avatar is a cobra or has features of one.
    `,
    implies: ["species:snake"]
  },
  "species:python": {
    desc: `
      This avatar is a python or has features of one.
    `,
    implies: ["species:snake"]
  },
  "species:viper": {
    desc: `
      This avatar is a viper or has features of one.
    `,
    implies: ["species:snake"]
  },
  "species:turtle": {
    desc: `
      This avatar is a turtle or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:tortoise": {
    desc: `
      This avatar is a tortoise or has features of one.
    `,
    implies: ["species:reptile"]
  },
  "species:angel": {
    desc: `
      This avatar is an angel or has features of one.
    `
  },
  "species:creeper": {
    desc: `
      This avatar is a creeper or has features of one.
    `
  },
  "species:dragon": {
    desc: `
      This avatar is a dragon or has features of one.
    `
  },
  "species:eastern_dragon": {
    desc: `
      This avatar is a eastern-style dragon or has features of one.
    `,
    implies: ["species:dragon"]
  },
  "species:ender_dragon": {
    desc: `
      This avatar is an ender dragon or has features of one.
    `,
    implies: ["species:dragon"]
  },
  "species:western_dragon": {
    desc: `
      This avatar is a western-style dragon or has features of one.
    `,
    implies: ["species:dragon"]
  },
  "species:wyvern": {
    desc: `
      This avatar is a wyvern or has features of one.
    `,
    implies: ["species:dragon"]
  },
  "species:monster_hunter_monster": {
    desc: `
      This avatar is a Monster Hunter wyvern/monster or has features of one.
    `
  },
  "species:bird_wyvern": {
    desc: `
      This avatar is a bird wyvern or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:brute_wyvern": {
    desc: `
      This avatar is a brute wyvern or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:elder_dragon": {
    desc: `
      This avatar is an elder dragon or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:fanged_wyvern": {
    desc: `
      This avatar is a fanged wyvern or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:flying_wyvern": {
    desc: `
      This avatar is a flying wyvern or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:piscine_wyvern": {
    desc: `
      This avatar is a piscine wyvern or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:fanged_beast": {
    desc: `
      This avatar is a fanged beast or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:snake_wyvern": {
    desc: `
      This avatar is a snake wyvern or has features of one.
    `,
    implies: ["species:monster_hunter_monster"]
  },
  "species:lynian": {
    desc: `
      This avatar is a Monster Hunter lynian or has features of one.
    `
  },
  "species:felyne": {
    desc: `
      This avatar is a felyne or has features of one.
    `,
    implies: ["species:lynian"]
  },
  "species:palico": {
    desc: `
      This avatar is a palico or has features of one.
    `,
    implies: ["species:felyne"]
  },
  "species:gajalaka": {
    desc: `
      This avatar is a gajalaka or has features of one.
    `,
    implies: ["species:lynian"]
  },
  "species:grimalkyne": {
    desc: `
      This avatar is a grimalkyne or has features of one.
    `,
    implies: ["species:lynian"]
  },
  "species:palamute": {
    desc: `
      This avatar is a Monster Hunter palamute or has features of one.
    `
  },
  "species:dwarf": {
    desc: `
      This avatar is a dwarf or has features of one.
    `
  },
  "species:elf": {
    desc: `
      This avatar is an elf or has features of one.
    `
  },
  "species:enderman": {
    desc: `
      This avatar is an enderman or has features of one.
    `,
    implies: []
  },
  "species:fairy": {
    desc: `
      This avatar is a fairy or has features of one.
    `
  },
  "species:flora_fauna": {
    desc: `
      This avatar is a living plant or has features of one.
    `
  },
  "species:dryad": {
    desc: `
      This avatar is a dryad or has features of one.
    `
  },
  "species:gnome": {
    desc: `
      This avatar is a gnome or has features of one.
    `
  },
  "species:goblin": {
    desc: `
      This avatar is a goblin or has features of one.
    `
  },
  "species:gorgon": {
    desc: `
      This avatar is a gorgon or has features of one.
    `
  },
  "species:halfling": {
    desc: `
      This avatar is a halfling or has features of one.
    `
  },
  "species:hydra": {
    desc: `
      This avatar is a hydra or has features of one.
    `
  },
  "species:lamia": {
    desc: `
      This avatar is a lamia or has features of one.
    `
  },
  "species:magma_cube": {
    desc: `
      This avatar is a magma cube or has features of one.
    `
  },
  "species:manticore": {
    desc: `
      This avatar is a manticore or has features of one.
    `
  },
  "species:yoshi": {
    desc: `
      This avatar is a yoshi or has features of one.
    `
  },
  "species:naga": {
    desc: `
      This avatar is a naga or has features of one.
    `
  },
  "species:orc": {
    desc: `
      This avatar is a orc or has features of one.
    `
  },
  "species:pixie": {
    desc: `
      This avatar is a pixie or has features of one.
    `
  },
  "species:pokemon": {
    desc: `
      This avatar is a pokemon or has features of one.
    `
  },
  "species:gen_i": {
    desc: `
      This avatar is a generation I pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:lapras": {
    desc: `
      This avatar is a Lapras or has features of one.
    `,
    implies: ["species:gen_i"]
  },
  "species:gen_ii": {
    desc: `
      This avatar is a generation II pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_iii": {
    desc: `
      This avatar is a generation III pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_iv": {
    desc: `
      This avatar is a generation IV pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_v": {
    desc: `
      This avatar is a generation V pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_vi": {
    desc: `
      This avatar is a generation VI pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_vii": {
    desc: `
      This avatar is a generation VII pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_viii": {
    desc: `
      This avatar is a generation VIII pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:gen_ix": {
    desc: `
      This avatar is a generation IX pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:shiny_pokemon": {
    desc: `
      This avatar is a shiny pokemon or has features of one.
    `,
    implies: ["species:pokemon"]
  },
  "species:rexouium": {
    desc: `
      This avatar is a rexouium or has features of one.
    `
  },
  "species:satyr": {
    desc: `
      This avatar is a satyr or has features of one.
    `
  },
  "species:sculk": {
    desc: `
      This avatar is sculk or has features of one.
    `
  },
  "species:warden": {
    desc: `
      This avatar is a warden or has features of one.
    `,
    implies: ["species:sculk"]
  },
  "species:slime": {
    desc: `
      This avatar is a slime or has features of one.
    `
  },
  "species:sphinx": {
    desc: `
      This avatar is a sphinx or has features of one.
    `
  },
  "species:spirit": {
    desc: `
      This avatar is a spirit or has features of one.
    `
  },
  "species:ghost": {
    desc: `
      This avatar is a ghost or has features of one.
    `,
    implies: ["species:spirit"]
  },
  "species:tiefling": {
    desc: `
      This avatar is a tiefling or has features of one.
    `,
  },
  "species:undead": {
    desc: `
      This avatar is an undead or has features of one.
    `,
  },
  "species:skeleton": {
    desc: `
      This avatar is a skeleton or has features of one.
    `,
    implies: ["species:undead"]
  },
  "species:stray": {
    desc: `
      This avatar is a stray or has features of one.
    `,
    implies: ["species:skeleton"]
  },
  "species:wither_skeleton": {
    desc: `
      This avatar is a wither skeleton or has features of one.
    `,
    implies: ["species:skeleton"]
  },
  "species:mummy": {
    desc: `
      This avatar is a mummy or has features of one.
    `,
    implies: ["species:undead"]
  },
  "species:wither": {
    desc: `
      This avatar is a wither or has features of one.
    `,
    implies: ["species:undead"]
  },
  "species:zombie": {
    desc: `
      This avatar is a zombie or has features of one.
    `,
    implies: ["species:undead"]
  },
  "species:drowned": {
    desc: `
      This avatar is a drowned or has features of one.
    `,
    implies: ["species:zombie"]
  },
  "species:husk": {
    desc: `
      This avatar is a husk or has features of one.
    `,
    implies: ["species:zombie"]
  },
  "species:zombified_piglin": {
    desc: `
      This avatar is a zombified_piglin or has features of one.
    `,
    implies: ["species:zombie"]
  },
  "species:xenomorph": {
    desc: `
      This avatar is a xenomorph or has features of one.
    `
  },
  "species:yeti": {
    desc: `
      This avatar is a yeti or has features of one.
    `
  },
  "species:machine": {
    desc: `
      This avatar is a machine or has features of one.
    `
  },
  "species:robot": {
    desc: `
      This avatar is a robot or has features of one.
    `,
    implies: ["species:machine"]
  },
  "species:object": {
    desc: `
      This avatar is an object.
    `
  },

  // OBJECT TAGS
  "object:pokeball": {
    desc: `
      This avatar is a pokeball or is inside a pokeball.
    `
  },

  "terrain:land": {
    desc: `
      This avatar prefers to live or travel on land.
    `,
    implies: []
  },
  "terrain:water": {
    desc: `
      This avatar prefers to live or travel on water.
    `,
    implies: []
  },
  "terrain:underwater": {
    desc: `
      This avatar prefers to live or travel underwater.
    `,
    implies: []
  },
  "terrain:air": {
    desc: `
      This avatar prefers to live or travel in air.
    `,
    implies: []
  },

  // CARRIER-SPECIFIC
  "position:high": {
    desc: `
      This seat is placed very high off the ground.
    `,
    conflicts: ["position:low"]
  },
  "position:low": {
    desc: `
      This seat is placed very low to the ground.
    `,
    conflicts: ["position:high"]
  },

  "shape:flat": {
    desc: `
      This seat is flat.
    `,
    conflicts: [
      "shape:chair", "shape:mounted", "shape:piggyback", "shape:bridal_carry", "shape:hanging", "shape:floating"
    ]
  },
  "shape:chair": {
    desc: `
      This seat has room for the legs to hang down as if the rider was sitting in a chair
    `,
    conflicts: [
      "shape:flat", "shape:mounted", "shape:piggyback", "shape:bridal_carry", "shape:hanging", "shape:floating"
    ]
  },
  "shape:mounted": {
    desc: `
      This seat is mounted on the back of something like a saddle.
    `,
    conflicts: ["shape:flat", "shape:chair", "shape:piggyback", "shape:bridal_carry", "shape:hanging", "shape:floating"]
  },
  "shape:piggyback": {
    desc: `
      This "seat" causes the rider to be carried piggyback-style.
    `,
    conflicts: ["shape:flat", "shape:chair", "shape:mounted", "shape:bridal_carry", "shape:hanging", "shape:floating"]
  },
  "shape:bridal_carry": {
    desc: `
      This "seat" causes the rider to be held in a bridal carry.
    `,
    conflicts: ["shape:flat", "shape:chair", "shape:mounted", "shape:piggyback", "shape:hanging", "shape:floating"]
  },
  "shape:hanging": {
    desc: `
      This "seat" causes the rider to hang off of something.
    `,
    conflicts: ["shape:flat", "shape:chair", "shape:mounted", "shape:piggyback", "shape:bridal_carry", "shape:floating"]
  },
  "shape:floating": {
    desc: `
      This "seat" causes the rider to float in the air.
    `,
    conflicts: ["shape:flat", "shape:chair", "shape:mounted", "shape:piggyback", "shape:bridal_carry", "shape:hanging"]
  }
}

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
  "class:cem": {
    desc: `
      This {type} is a non-player entity.

      This tag is always applied to non-player {type}s.
    `,
    conflicts: ["class:player"],
    internal: true
  },
  "class:player": {
    desc: `
      This {type} is a player entity.

      This tag is always applied to player {type}s.
    `,
    conflicts: ["class:cem"],
    internal: true
  },

  "shape:vertical_posture": {
    desc: `
      This {type} defaults to a vertical posture.  
      This is mostly orthogrades.
    `,
    conflicts: ["shape:horizontal_posture", "shape:amorphous"]
  },
  "shape:horizontal_posture": {
    desc: `
      This {type} defaults to a horizontal posture.  
      This is mostly pronogrades.
    `,
    conflicts: ["shape:vertical_posture"]
  },
  "shape:simple": {
    desc: `
      This {type} has a simple shape.  
      This is common with {type}s that are objects/robotic.
    `,
    conflicts: ["shape:horizontal_posture", "shape:vertical_posture", "shape:amorphous"]
  },
  "shape:amorphous": {
    desc: `This {type} has no definable shape.`,
    conflicts: ["shape:horizontal_posture", "shape:vertical_posture", "shape:simple"]
  },

  "species:humanoid": {
    desc: `
      This {type} has very human-like features.

      This can be combined with other species tags to create a (species)-humanoid.
    `
  }
}

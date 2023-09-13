---@meta _

error(
  "This file should not exist in your Figura avatar!\n" +
  "This file's name should start with a §f.§r to hide it from Figura.\n" +
  "The default name for this file is §f.GSCarrier_tags.lua§r",
  2
)

---@diagnostic disable: duplicate-doc-alias


---===|| VEHICLE TAGS ||=============================================================================================---

---Tags that explain the function, shape, and details of a Carrier vehicle.  
---These can be used by riders to determine which animation to play, for example.
---
---You are not limited to the tags in this list and if you want to add a tag of your own,
---use the format `author:tag_name`.
---
---Usage of conflicting tags results in behavior defined by the riders, but should be avoided.
---@alias Lib.GS.Carrier.vehicleTag string
---**[CLASS]** *(Internal)*
---***
---This vehicle is a non-player entity.
---
---This tag is always applied to non-player vehicles.
---
---*Conflicts with:*
---> `gscarrier:player`
---| "gscarrier:cem"
---**[CLASS]** *(Internal)*
---***
---This vehicle is a player.
---
---This tag is always applied to player vehicles.
---
---*Conflicts with:*
---> `gscarrier:cem`
---| "gscarrier:player"
---
---
---
---**[BODY]**
---***
---This vehicle defaults to a vertical posture.  
---This is mostly orthogrades.
---
---*Conflicts with:*
---> `gscarrier:horizontal` `gscarrier:taur`
---| "gscarrier:vertical"
---**[BODY]**
---***
---This vehicle defaults to a horizontal posture.  
---This also includes pronogrades.
---
---*Conflicts with:*
---> `gscarrier:vertical`
---| "gscarrier:horizontal"
---**[BODY]**
---***
---This vehicle has a humanoid shape.
---
---*Conflicts with:*
---> `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur` `gscarrier:simple`
---> `gscarrier:amorphous`
---| "gscarrier:humanoid"
---**[BODY]**
---***
---This vehicle has a bipedal shape.
---
---*Conflicts with:*
---> `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur` `gscarrier:simple`
---> `gscarrier:amorphous`
---| "gscarrier:biped"
---**[BODY]**
---***
---This vehicle has a quadrupedal shape.  
---Includes things that don't have four legs exactly but still use a similar frame.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur`
---> `gscarrier:simple` `gscarrier:amorphous`
---| "gscarrier:quadruped"
---**[BODY]**
---***
---This vehicle has an insect-like shape.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:arachnoid` `gscarrier:taur`
---> `gscarrier:simple` `gscarrier:amorphous`
---| "gscarrier:insectoid"
---**[BODY]**
---***
---This vehicle has a spider-like shape.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:taur`
---> `gscarrier:simple` `gscarrier:amorphous`
---| "gscarrier:arachnoid"
---**[BODY]**
---***
---This vehicle has a taur-like shape.
---
---*Conflicts with:*
---> `gscarrier:vertical` `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:insectoid`
---> `gscarrier:simple` `gscarrier:arachnoid` `gscarrier:amorphous`
---| "gscarrier:taur"
---**[BODY]**
---***
---This vehicle has a simple shape.  
---This is common with vehicles that are objects/robots and not living things.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid`
---> `gscarrier:taur` `gscarrier:amorphous`
---| "gscarrier:simple"
---**[BODY]**
---***
---This vehicle has no definable shape.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur`
---> `gscarrier:simple`
---| "gscarrier:amorphous"
---
---
---
---**[SPECIES]**
---***
---This is a placeholder for a tag group that may exist later.
---
---Do not use this tag.
---| "gscarrier:placeholder1"
---
---
---
---**[TERRAIN]**
---***
---This vehicle can travel on land.
---| "gscarrier:land"
---**[TERRAIN]**
---***
---This vehicle can travel on water.
---| "gscarrier:water"
---**[TERRAIN]**
---***
---This vehicle can travel in water.
---| "gscarrier:underwater"
---**[TERRAIN]**
---***
---This vehicle can travel through air.
---| "gscarrier:air"


---===|| SEAT TAGS ||================================================================================================---

---Tags that explain the function, shape, and details of a seat on a Carrier vehicle.  
---These can be used by riders to determine which animation to play, for example.
---
---You are not limited to the tags in this list and if you want to add a tag of your own,
---use the format `author:tag_name`.
---
---Usage of conflicting tags results in behavior defined by the riders, but should be avoided.
---@alias Lib.GS.Carrier.seatTag string
---**[HEIGHT]**
---***
---This seat is high up.
---
---*Conflicts with:*
---> `gscarrier:low`
---| "gscarrier:high"
---**[HEIGHT]**
---***
---This seat is low to the ground.
---
---*Conflicts with:*
---> `gscarrier:high`
---| "gscarrier:low"
---
---
---
---**[TYPE]**
---***
---The seat is on (or is) a flat surface.
---
---*Conflicts with:*
---> `gscarrier:chair` `gscarrier:mounted` `gscarrier:piggyback` `gscarrier:hanging` `gscarrier:floating`
---| "gscarrier:flat"
---**[TYPE]**
---***
---The legs have room to hang down like a chair.
---
---*Conflicts with:*
---> `gscarrier:flat` `gscarrier:mounted` `gscarrier:piggyback` `gscarrier:hanging` `gscarrier:floating`
---| "gscarrier:chair"
---**[TYPE]**
---***
---The rider is mounted on something like a horse.
---
---*Conflicts with:*
---> `gscarrier:flat` `gscarrier:chair` `gscarrier:piggyback` `gscarrier:hanging` `gscarrier:floating`
---| "gscarrier:mounted"
---**[TYPE]**
---***
---The rider is carried on the back of something in this seat.  
---Meant to be used for more upright models.
---
---*Conflicts with:*
---> `gscarrier:flat` `gscarrier:chair` `gscarrier:mounted` `gscarrier:hanging` `gscarrier:floating`
---| "gscarrier:piggyback"
---**[TYPE]**
---***
---The rider is hanging from something in this seat.
---
---*Conflicts with:*
---> `gscarrier:flat` `gscarrier:chair` `gscarrier:mounted` `gscarrier:piggyback` `gscarrier:floating`
---| "gscarrier:hanging"
---**[TYPE]**
---***
---The rider is somehow floating in this seat.
---
---*Conflicts with:*
---> `gscarrier:flat` `gscarrier:chair` `gscarrier:mounted` `gscarrier:piggyback` `gscarrier:hanging`
---| "gscarrier:floating"


---===|| RIDER TAGS ||===============================================================================================---

---Tags that explain the function, shape, and details of a Carrier rider.  
---These can be used by vehicles to determine which seat you are allowed to sit in, for example.
---
---You are not limited to the tags in this list and if you want to add a tag of your own,
---use the format `author:tag_name`.
---
---Usage of conflicting tags results in behavior defined by the vehicles, but should be avoided.
---@alias Lib.GS.Carrier.riderTag string
---**[CLASS]** *(Internal)*
---***
---This rider is a non-player entity.
---
---This tag is always applied to non-player riders.
---| "gscarrier:cem"
---**[INTERNAL]**
---***
---This rider is a player.
---
---This tag is always applied to player riders.
---| "gscarrier:player"
---
---
---
---**[BODY]**
---***
---This rider has a vertical posture.  
---This is mostly orthogrades.
---
---*Conflicts with:*
---> `gscarrier:horizontal` `gscarrier:taur`
---| "gscarrier:vertical"
---**[BODY]**
---***
---This rider has a horizontal posture.  
---This does *not* include pronogrades.
---
---*Conflicts with:*
---> `gscarrier:vertical` `gscarrier:taur`
---| "gscarrier:horizontal"
---**[BODY]**
---***
---This rider has a humanoid shape.
---
---*Conflicts with:*
---> `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur` `gscarrier:simple`
---> `gscarrier:amorphous`
---| "gscarrier:humanoid"
---**[BODY]**
---***
---This rider has a bipedal shape.
---
---*Conflicts with:*
---> `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur` `gscarrier:simple`
---> `gscarrier:amorphous`
---| "gscarrier:biped"
---**[BODY]**
---***
---This rider has a quadrupedal shape.  
---Includes things that don't have four legs exactly but still use a similar frame.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur`
---> `gscarrier:simple` `gscarrier:amorphous`
---| "gscarrier:quadruped"
---**[BODY]**
---***
---This rider has an insect-like shape.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:arachnoid` `gscarrier:taur`
---> `gscarrier:simple` `gscarrier:amorphous`
---| "gscarrier:insectoid"
---**[BODY]**
---***
---This rider has a spider-like shape.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:taur`
---> `gscarrier:simple` `gscarrier:amorphous`
---| "gscarrier:arachnoid"
---**[BODY]**
---***
---This rider has a taur-like shape.
---
---*Conflicts with:*
---> `gscarrier:vertical` `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:insectoid`
---> `gscarrier:simple` `gscarrier:arachnoid` `gscarrier:amorphous`
---| "gscarrier:taur"
---**[BODY]**
---***
---This rider has a simple shape.  
---This is common with riders that are objects/robots and not living things.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:biped` `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid`
---> `gscarrier:taur` `gscarrier:amorphous`
---| "gscarrier:simple"
---**[BODY]**
---***
---This rider has no definable shape.
---
---*Conflicts with:*
---> `gscarrier:humanoid` `gscarrier:quadruped` `gscarrier:insectoid` `gscarrier:arachnoid` `gscarrier:taur`
---> `gscarrier:simple`
---| "gscarrier:amorphous"
---
---
---
---**[SPECIES]**
---***
---This is a placeholder for a tag group that may exist later.
---
---Do not use this tag.
---| "gscarrier:placeholder1"
---
---
---
---**[SIZE]** *(Internal)*
---***
---The scale of this rider relative to Steve.
---
---*If you are using Pehkui, this should be relative to the size that a Steve the same scale as you would be.*
---| "gscarrier:scale"
---
---
---
---**[PEHKUI]** *(Internal)*
---***
---Contains the pehkui scale of this rider.
---| "pehkui:scale"
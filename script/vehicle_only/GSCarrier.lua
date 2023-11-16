-- ┌───┐                ┌───┐ --
-- │ ┌─┘ ┌─────┐┌─────┐ └─┐ │ --
-- │ │   │ ┌───┘│ ╶───┤   │ │ --
-- │ │   │ ├───┐└───┐ │   │ │ --
-- │ │   │ └─╴ │┌───┘ │   │ │ --
-- │ └─┐ └─────┘└─────┘ ┌─┘ │ --
-- └───┘                └───┘ --
---@module  "Passenger Pivot Library" <GSCarrier>
---@version v1.0.0-pre.1
---@see     GrandpaScout @ https://github.com/GrandpaScout
-- A library that allows Figura "vehicles" to specify custom passenger pivot points and Figura "riders" to sit at those
-- custom pivot points.
--
-- Includes a system to pick where certain avatars go based on a list of tags and conditions.

--]] =======================================================================
--]] ⚠ DO NOT EDIT THIS FILE UNLESS YOU KNOW WHAT EDITING THIS FILE DOES! ⚠
--]]
--]] You have no reason to be modifying this file unless you know how to
--]] modify library files.
--]] (Spoiler alert, *you very likely do not.*)
--]]
--]] If you wish to access the features of this library, use Lua's `require`
--]] system in a different script file to get access to this library's
--]] contents.
--]]
--]]     local Carrier = require("GSCarrier")
--]]
--]] ⚠ DO NOT EDIT THIS FILE UNLESS YOU KNOW WHAT EDITING THIS FILE DOES! ⚠
--]] =======================================================================

local ID = "GSCarrier"
local VER = "1.0.0-pre.1"
local FIG = {"0.1.2", "0.1.2"}


---===|| LOCALS ||===================================================================================================---

local internal_tags = {
  ["class:cem"] = true,
  ["class:player"] = true,
  ["scale:avatar"] = true,
  ["scale:pehkui"] = true,
  ["gscarrier:placeholder1"] = true
}


---===|| LIB SETUP ||================================================================================================---

---The main library table for GSCarrier.
---
---To get started on making a Carrier vehicle, see `.vehicle`.
---
---To get started on making a Carrier rider, see `.rider`.
---@class Lib.GS.Carrier
local this = {}

local thismt = {
  __type = ID,
  __metatable = false,
  __index = {
    _ID = ID,
    _VERSION = VER
  }
}


---===|| VEHICLE SETUP ||============================================================================================---

--!! VEHICLE_ONLY
---@type {[integer]: Lib.GS.Carrier.Seat, [string]: integer}
local veh_seats = {}
---@type Lib.GS.Carrier.SeatRemote[]
local veh_remotes = {}
---@type {[Lib.GS.Carrier.vehicleTag]: unknown}
local veh_tags = {}

---@alias Lib.GS.Carrier.seatCallback fun(state: boolean, self: Lib.GS.Carrier.Seat)
---@alias Lib.GS.Carrier.seatCondition fun(ent: Entity.any, tags: {[Lib.GS.Carrier.riderTag]: unknown}, self: Lib.GS.Carrier.Seat): ((boolean | integer)?)

---A seat used to position a rider using the Carrier system.
---@class Lib.GS.Carrier.Seat
---The unique id of this seat.
---
---If seats share priority, the seat with the lower uid will be chosen first.
---@field uid integer
---The name of this seat, this is used with `vehicle.getSeat(name)`.
---@field name string
---The part this seat uses for positioning.
---
---If this does not exist, the seat will not function.
---@field part? ModelPart
---The priority of this seat.
---
---Seats with a higher priority will be chosen first.
---@field priority integer
---The tags that define the shape and function of this seat.
---
---These are used by Carrier riders to determine how to act while in this seat.
---@field tags {[Lib.GS.Carrier.seatTag]: unknown}
---The entity currently sitting in this seat.
---@field occupant? Entity.any
---The function to run when a rider using the Carrier system starts or stops sitting in this seat.
---
---The callback is given the state of the seat (`true` for entering, and `false` for leaving) and the seat itself.
---@field callback? Lib.GS.Carrier.seatCallback
---The function to run to check whether a rider using the Carrier system is allowed to use this seat.
---@field condition? Lib.GS.Carrier.seatCondition
local Seat = {}
local SeatMT = {__index = Seat}

---===== METHODS =====---

---Adds a tag to this seat.
---
---If `value` is `nil`, it will default to `true`
---@generic self
---@param self self
---@param tag Lib.GS.Carrier.seatTag
---@param value? any
---@return self
function Seat:addTag(tag, value)
  ---@cast self Lib.GS.Carrier.Seat
  if internal_tags[tag] then error("attempt to modify internal tag '" .. tag .. "'", 2) end
  self.tags[tag] = value == nil or value
  return self
end

---Removes a tag from this seat.
---@generic self
---@param self self
---@param tag Lib.GS.Carrier.seatTag
---@return self
function Seat:removeTag(tag)
  ---@cast self Lib.GS.Carrier.Seat
  if internal_tags[tag] then error("attempt to modify internal tag '" .. tag .. "'", 2) end
  self.tags[tag] = nil
  return self
end


---===== GETTERS =====----

---Gets the name of this seat.
---@return string
function Seat:getName() return self.name end

---Gets the part this seat is using for positioning.
---@return ModelPart
function Seat:getPart() return self.part end

---Gets the priority of this seat.
---@return integer
function Seat:getPriority() return self.priority end

---Gets a copy of the tag list of this seat.
---@return {[Lib.GS.Carrier.seatTag]: unknown}
function Seat:getTags()
  local tbl = {}
  for t, v in pairs(self.tags) do tbl[t] = v end
  return tbl
end

---Gets the entity in this seat.
---@return Entity.any?
function Seat:getOccupant() return self.occupant end

---Gets the callback that will run when a rider using the Carrier system starts or stops sitting in this seat.
---@return Lib.GS.Carrier.seatCallback?
function Seat:getCallback() return self.callback end

---Gets the function that will check whether a rider using the Carrier system is allowed to use this seat.
---@return Lib.GS.Carrier.seatCondition?
function Seat:getCondition() return self.condition end


---===== SETTERS =====--

---Gets the part this seat is using for positioning.
---@generic self
---@param self self
---@param part ModelPart
---@return self
function Seat:setPart(part)
  self.part = part
  return self
end

---Sets the priority of this seat.
---@generic self
---@param self self
---@param priority integer
---@return self
function Seat:setPriority(priority)
  self.priority = priority
  return self
end

---Gets the callback that will run when a rider using the Carrier system starts or stops sitting in this seat.
---@param callback? Lib.GS.Carrier.seatCallback
function Seat:setCallback(callback) self.callback = callback end

---Gets the function that will check whether a rider using the Carrier system is allowed to use this seat.
---@param condition? Lib.GS.Carrier.seatCondition
function Seat:getCondition(condition) self.condition = condition end
--!! END

---@class Lib.GS.Carrier.SeatRemote
---@field uid integer
---@field name string
---@field iterateTags fun(self: Lib.GS.Carrier.SeatRemote): ((fun(uid: integer, name?: Lib.GS.Carrier.seatTag): (Lib.GS.Carrier.seatTag, unknown)), integer)
---@field getPriority fun(self: Lib.GS.Carrier.SeatRemote): integer
---@field getTag fun(self: Lib.GS.Carrier.SeatRemote, name: string): unknown
---@field getOccupant fun(self: Lib.GS.Carrier.SeatRemote): (Entity.any?)
---@field getPos fun(self: Lib.GS.Carrier.SeatRemote): Vector3
---@field getRot fun(self: Lib.GS.Carrier.SeatRemote): Vector3
---@field runCallback fun(self: Lib.GS.Carrier.SeatRemote, state: boolean)
---@field runCondition fun(self: Lib.GS.Carrier.SeatRemote, ent: Entity.any, tags: {[Lib.GS.Carrier.riderTag]: any}): ((boolean | integer)?)
---@field setOccupant fun(self: Lib.GS.Carrier.SeatRemote, ent?: Entity.any)

--!! VEHICLE_ONLY
local function iterate_tags(uid, name) return next(veh_seats[uid].tags, name) end

---@param self Lib.GS.Carrier.SeatRemote
local function remote_iterateTags(self) return iterate_tags, self.uid end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_getPriority(self) return veh_seats[self.uid].priority end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_getTag(self, name) return veh_seats[self.uid].tags[name] end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_getOccupant(self) return veh_seats[self.uid].occupant end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_getPos(self)
  local part = veh_seats[self.uid].part
  return part and part:partToWorldMatrix():apply()
end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_getRot(self)
  local part = veh_seats[self.uid].part
  return part and part:getRot()
end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_runCallback(self, state)
  local seat = veh_seats[self.uid]
  if type(seat.callback) == "function" then pcall(seat.callback, state, seat) end
end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_runCondition(self, ent, tags)
  local seat = veh_seats[self.uid]
  if not seat.part or not seat.part:getVisible() then return false end
  if type(seat.condition) == "function" then
    local s, v = pcall(seat.condition, ent, tags, seat)
    if s then return v end
  end
end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_setOccupant(self, ent) veh_seats[self.uid].occupant = ent end


---===|| VEHICLE TABLE ||============================================================================================---

---Contains tools for working with Carrier vehicles.
---
---To get started, create a seat with `.newSeat()`.
---```lua
---<GSCarrier>.vehicle.newSeat("my_cool_seat", models.model_name.path.to.seat.pivot, {
---  -- Higher priority seats are picked first by Carrier riders.
---  priority = 123,
---
---  -- WIP: Tags tell riders attributes of this seat.
---  --      Riders may choose to react to these tags to do certain things.
---  -- If only a tag name is given, it is treated as `[tag_name] = true`.  
---  -- {"ns:foo", "ns:bar", ["ns:baz"] = 123} == {["ns:foo"] = true, ["ns:bar"] = true, ["ns:baz"] = 123}
---  tags = {
---    "namespace:tag_name", "namespace:another_tag", "namespace:one_more_tag",
---    ["namespace:tag_with_value"] = 123,
---    ["namespace:another_tag_with_value"] = "qwerty"
---  },
---
---  -- The callback is run when a rider enters or exits this seat.
---  callback = function(state, self)
---    -- state is `false` if exiting or `true` if entering the seat.
---    -- self is the seat object
---  end,
---
---  -- The condition controls when a Carrier rider is allowed to enter this seat.
---  -- It can make the seat the top priority, change it's normal priority, or
---  -- forbid a rider from entering.
---  --
---  -- This is run once per tick per Carrier rider on this Carrier vehicle.  
---  -- This can add up quick so make it short and efficient.
---  condition = function(ent, tags, self)
---    -- ent is the entity checking this seat.
---    -- tags is the list of tags the entity has.
---    -- self is the seat object.
---
---    -- return true to mark this seat as top priority
---    -- return false to deny the entity from sitting in this seat.
---    -- return a number to change the priority of this seat for this entity.
---    -- return nothing to leave the priority alone.
---
---    -- No matter what, there is a hidden condition that always returns `false`
---    -- if the part this seat is connected to does not exist or is invisible.
---  end
---})
---```
---This seat can be saved to a variable for later editing as well.
---```lua
---local my_seat = <GSCarrier>.vehicle.newSeat(...)
---my_seat:setPriority(64)
---```
---&nbsp;  
---You can add or remove tags from the vehicle with the following functions:
---```lua
-----Adds a tag to the Carrier vehicle with the given value (or `true` if there is none)
---<GSCarrier>.vehicle.addTag("namespace:tag_name")
---<GSCarrier>.vehicle.addTag("namespace:tag_with_value", 42)
---
----- Removes a tag from the Carrier vehicle.
---<GSCarrier>.vehicle.removeTag("namespace:tag_with_value")
---```
---&nbsp;  
---Use `.setRedirect()` to control when Carrier riders that are riding the Minecraft entity you are controlling should
---ride you instead.  
---(Ex. You are controlling a boat and there's a player in the back using Carrier. They will visually ride you instead.)
---```lua
----- Enables redirecting.
---Carrier.vehicle.setRedirect(true)
---```
local vehicle = {}

---===== METHODS =====---

---@class Lib.GS.Carrier.seatOptions
---The priority of this seat.
---
---Seats with a higher priority will be chosen first.
---@field priority? integer
---The tags that define the shape and function of this seat.
---
---These are used by Carrier riders to determine how to act while in this seat.
---@field tags? {[integer]: Lib.GS.Carrier.seatTag, [Lib.GS.Carrier.seatTag]: any}
---The function to run when a rider using the Carrier system starts or stops sitting in this seat.
---@field callback? Lib.GS.Carrier.seatCallback
---@field condition? Lib.GS.Carrier.seatCondition

---Creates a new seat at the given part.  
---Use empty groups for best results as they can be freely positioned without moving anything else.
---
---If `part` is `false`, the seat will not contain a pivot part and will require one to be set later.  
---Options may be provided to further customize the seat.
---@param name string
---@param part ModelPart | false
---@param options? Lib.GS.Carrier.seatOptions
---@return Lib.GS.Carrier.Seat
function vehicle.newSeat(name, part, options)
  if part == nil then error("given part does not exist", 2) end
  options = options or {}

  local tags = options.tags

  ---@type {[Lib.GS.Carrier.seatTag]: unknown}
  local tag_clone = {}
  if tags then
    for i, tag in ipairs(tags) do
      tag_clone[tag] = true
      tags[i] = nil
    end
    ---@cast tags {[Lib.GS.Carrier.seatTag]: any}
    for t, v in pairs(tags) do
      if not internal_tags[t] then tag_clone[t] = v end
    end
  end

  local uid = #veh_seats + 1
  local obj = setmetatable({
    uid = uid,
    name = name,
    part = part or nil,
    priority = options.priority or 0,
    tags = tag_clone,
    callback = options.callback,
    condition = options.condition
  }, SeatMT)
  veh_seats[uid] = obj
  veh_seats[name] = uid

  veh_remotes[uid] = {
    uid = uid,
    name = name,
    iterateTags = remote_iterateTags,
    getPriority = remote_getPriority,
    getTag = remote_getTag,
    getOccupant = remote_getOccupant,
    getPos = remote_getPos,
    getRot = remote_getRot,
    runCallback = remote_runCallback,
    runCondition = remote_runCondition,
    setOccupant = remote_setOccupant
  }
  avatar:store("GSCarrier:vehicle.Seats", veh_remotes)

  return obj
end

---Adds a tag to this Carrier vehicle.
---
---If `value` is `nil`, it will default to `true`.
---@param tag Lib.GS.Carrier.vehicleTag
---@param value? any
function vehicle.addTag(tag, value)
  if internal_tags[tag] then error("attempt to modify internal tag '" .. tag .. "'", 2) end
  veh_tags[tag] = value == nil or value
  avatar:store("GSCarrier:vehicle.Tags", veh_tags)
end

---Removes a tag from this Carrier vehicle.
---@param tag Lib.GS.Carrier.vehicleTag
function vehicle.removeTag(tag)
  if internal_tags[tag] then error("attempt to modify internal tag '" .. tag .. "'", 2) end
  veh_tags[tag] = nil
  avatar:store("GSCarrier:vehicle.Tags", veh_tags)
end


---===== GETTERS =====---

---Gets the seat with the given uid or name.  
---If `index` is `nil`, an array of all seats is returned instead.
---
---Returns `nil` if no seat with the given uid or name exists.
---@param index string | integer
---@return Lib.GS.Carrier.Seat?
---@overload fun(): Lib.GS.Carrier.Seat[]
function vehicle.getSeat(index)
  if index == nil then
    local tbl = {}
    for i, seat in ipairs(veh_seats) do tbl[i] = seat end
    return tbl
  end

  if type(index) == "string" then index = veh_seats[index] end
  return veh_seats[index]
end

---Gets a copy of the tag list of this Carrier vehicle.
---@return {[Lib.GS.Carrier.vehicleTag]: unknown}
function vehicle.getTags()
  local tbl = {}
  for t, v in pairs(veh_tags) do tbl[t] = v end
  return tbl
end

---Gets a table of all Carrier riders on this Carrier vehicle.  
---The keys of this array are the seat UIDs and the values are the entities sitting in those seats.  
---`n` contains the total amount of riders.
---
---Empty seats have a `false` instead of a `nil` to allow `ipairs()` to iterate over this table.
---
---To get the single occupant of a specific seat, use `Seat:getOccupant()`.
---@return {[integer]: Entity.any | false, n: integer}
function vehicle.getOccupants()
  local tbl = {}
  local n = 0
  local occ
  for i, seat in ipairs(veh_seats) do
    occ = seat.occupant or false
    if occ then n = n + 1 end
    tbl[i] = occ
  end

  tbl.n = n
  return tbl
end


---===== SETTERS =====---

---Sets whether this Carrier vehicle will redirect any passengers of the Minecraft vehicle it is controlling to itself.
---
---If a Carrier vehicle controlling a Minecraft boat has redirect enabled, the player in the back seat will instead be
---placed on the Carrier vehicle.
---
---If `state` is `nil`, it will default to `false`.
---@param state? boolean
function vehicle.setRedirect(state) avatar:store("GSCarrier:vehicle.Redirect", not not state) end


avatar:store("GSCarrier:vehicle.Enabled", true)
avatar:store("GSCarrier:vehicle.Redirect", false)
avatar:store("GSCarrier:vehicle.Seats", veh_remotes)
avatar:store("GSCarrier:vehicle.Tags", veh_tags)

this.vehicle = vehicle
--!! END



---===|| EVENTS ||===================================================================================================---

events.ENTITY_INIT:register(function()
  local tag_name = user:isPlayer() and "class:player" or "class:cem"
  --!! VEHICLE_ONLY
  veh_tags[tag_name] = true
  avatar:store("GSCarrier:vehicle.Tags", veh_tags)
  --!! END
end, "GSCarrier:EntityInit_ClassTag")

local mark_for_cleanup = {}

events.TICK:register(function()
  --!! VEHICLE_ONLY
  if next(veh_seats) then
    local passengers = player:getPassengers()
    local passenger_set = {}
    local update_seats = false
    if #passengers > 0 then
      for _, ply in ipairs(passengers) do
        passenger_set[ply:getUUID()] = ply:getVariable("GSCarrier:rider.Seat") or false
      end
    end
    local occupant
    for name, seat in ipairs(veh_seats) do
      occupant = seat.occupant
      if occupant and passenger_set[occupant:getUUID()] ~= name then
        if mark_for_cleanup[name] then
          if seat.callback then seat.callback(false, seat) end
          seat.occupant = nil
          update_seats = true
          mark_for_cleanup[name] = nil
        elseif mark_for_cleanup[name] then
          mark_for_cleanup[name] = nil
        else
          mark_for_cleanup[name] = true
        end
      end
    end
    if update_seats then avatar:store("GSCarrier:vehicle.Seats", veh_remotes) end
  end
  --!! END
end, "GSCarrier:Tick_CarrierChecks")


do return setmetatable(this, thismt) end

---@diagnostic disable: duplicate-doc-alias

---@alias Lib.GS.Carrier.vehicleTag string
---@alias Lib.GS.Carrier.seatTag string
---@alias Lib.GS.Carrier.riderTag string

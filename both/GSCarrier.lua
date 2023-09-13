-- ┌───┐                ┌───┐ --
-- │ ┌─┘ ┌─────┐┌─────┐ └─┐ │ --
-- │ │   │ ┌───┘│ ╶───┤   │ │ --
-- │ │   │ ├───┐└───┐ │   │ │ --
-- │ │   │ └─╴ │┌───┘ │   │ │ --
-- │ └─┐ └─────┘└─────┘ ┌─┘ │ --
-- └───┘                └───┘ --
---@module  "Passenger Pivot Library" <GSCarrier>
---@version v0.9.3
---@see     GrandpaScout @ https://github.com/GrandpaScout
-- 

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
local VER = "0.9.4"
local FIG = {"0.1.2", "0.1.2"}


---===|| LOCALS ||===================================================================================================---

local max = math.max

local ENT_NP = nameplate.ENTITY

local WORLD_TO_BB = 16 / math.playerScale
local BB_TO_WORLD = 0.05859375
local INF = math.huge
local NAN = 0 / 0

local VEC_UP = vec(0, 1, 0)
local NP_OFF = vec(0, 0.5, 0)

local internal_tags = {
  ["gscarrier:cem"] = true,
  ["gscarrier:player"] = true,
  ["gscarrier:scale"] = true,
  ["pehkui:scale"] = true,
  ["gscarrier:placeholder1"] = true
}


---===|| LIB SETUP ||================================================================================================---

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

---@type {[integer]: Lib.GS.Carrier.Seat, [string]: integer}
local veh_seats = {}
---@type Lib.GS.Carrier.SeatRemote[]
local veh_remotes = {}
---@type {[Lib.GS.Carrier.vehicleTag]: unknown}
local veh_tags = {["gscarrier:player"] = true}

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
---@field part ModelPart
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


---===== SETTERS =====---

---Sets the name of this seat.
---@generic self
---@param self self
---@param name string
---@return self
function Seat:setName(name)
  self.name = name
  return self
end

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


---@class Lib.GS.Carrier.SeatRemote
---@field uid integer
---@field iterateTags fun(self: Lib.GS.Carrier.SeatRemote): ((fun(uid: integer, name?: Lib.GS.Carrier.seatTag): (Lib.GS.Carrier.seatTag, unknown)), integer)
---@field getPriority fun(self: Lib.GS.Carrier.SeatRemote): integer
---@field getTag fun(self: Lib.GS.Carrier.SeatRemote, name: string): unknown
---@field getOccupant fun(self: Lib.GS.Carrier.SeatRemote): (Entity.any?)
---@field getPos fun(self: Lib.GS.Carrier.SeatRemote): Vector3
---@field getRot fun(self: Lib.GS.Carrier.SeatRemote): Vector3
---@field runCallback fun(self: Lib.GS.Carrier.SeatRemote, state: boolean)
---@field runCondition fun(self: Lib.GS.Carrier.SeatRemote, ent: Entity.any, tags: {[Lib.GS.Carrier.riderTag]: any}): ((boolean | integer)?)
---@field setOccupant fun(self: Lib.GS.Carrier.SeatRemote, ent?: Entity.any)

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
    return s and v or nil
  end
end
---@param self Lib.GS.Carrier.SeatRemote
local function remote_setOccupant(self, ent) veh_seats[self.uid].occupant = ent end


---===|| VEHICLE TABLE ||============================================================================================---

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
---@field tags? {[Lib.GS.Carrier.seatTag]: any}
---The function to run when a rider using the Carrier system starts or stops sitting in this seat.
---@field callback? Lib.GS.Carrier.seatCallback
---@field condition? Lib.GS.Carrier.seatCondition

---Creates a new seat at the given part.  
---Use empty groups for best results as they can be freely positioned without moving anything else.
---
---Options may be provided to further customize the seat.
---@param name string
---@param part ModelPart
---@param options? Lib.GS.Carrier.seatOptions
---@return Lib.GS.Carrier.Seat
function vehicle.newSeat(name, part, options)
  if not part then error("given part does not exist", 2) end
  options = options or {}

  ---@type {[Lib.GS.Carrier.seatTag]: unknown}
  local tag_clone = {}
  if options.tags then
    for t, v in pairs(options.tags) do
      if not internal_tags[t] then tag_clone[t] = v end
    end
  end

  local uid = #veh_seats + 1
  local obj = setmetatable({
    uid = uid,
    name = name,
    part = part,
    priority = options.priority or 0,
    tags = tag_clone,
    callback = options.callback,
    condition = options.condition
  }, SeatMT)
  veh_seats[uid] = obj
  veh_seats[name] = uid

  veh_remotes[uid] = {
    uid = uid,
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


---===|| RIDER SETUP ||==============================================================================================---

---@type {[ModelPart]: true}
local rider_roots = {}

---@type Entity.any?
local rider_vehicle
---@type Lib.GS.Carrier.SeatRemote?
local rider_seat

---@type {[Lib.GS.Carrier.riderTag]: unknown}
local rider_tags = {["gscarrier:scale"] = 1, ["pehkui:scale"] = 1}

---@class Lib.GS.Carrier.seatData
---@field uid integer
---@field priority integer
---@field tags {[Lib.GS.Carrier.seatTag]: unknown}


---===|| RIDER TABLE ||==============================================================================================---

local rider = {}

---===== METHODS =====---

---Adds ModelPart roots that should be moved into position when this Carrier rider is sitting in a Carrier vehicle's
---seat.
---
---Anything not in these groups is not moved.
---@param ... ModelPart
function rider.addRoots(...)
  for _, part in ipairs{...} do rider_roots[part] = true end
end

---Removes ModelParts from the list of parts that should move into position.
---@param ... ModelPart
function rider.removeRoots(...)
  for _, part in ipairs{...} do rider_roots[part] = nil end
end

---Adds a tag to this Carrier rider.
---
---If `value` is `nil`, it will default to `true`.
---@param tag Lib.GS.Carrier.riderTag
---@param value? any
function rider.addTag(tag, value)
  if internal_tags[tag] then error("attempt to modify internal tag '" .. tag .. "'", 2) end
  rider_tags[tag] = value == nil or value
  avatar:store("GSCarrier:rider.Tags", rider_tags)
end

---Removes a tag from this Carrier rider.
---@param tag Lib.GS.Carrier.riderTag
function rider.removeTag(tag)
  if internal_tags[tag] then error("attempt to modify internal tag '" .. tag .. "'", 2) end
  rider_tags[tag] = nil
  avatar:store("GSCarrier:rider.Tags", rider_tags)
end


---===== GETTERS =====---

---Gets the Carrier vehicle this Carrier rider is currently riding on.
---
---This will return a different value from `player:getVehicle()` if a Carrier vehicle has redirected the Carrier rider
---to it.
---@return Entity.any?
function rider.getVehicle() return rider_vehicle end

---Gets a copy of the data for the seat of the Carrier vehicle this Carrier rider is currently riding on.
---@return Lib.GS.Carrier.seatData?
function rider.getSeat()
  if not rider_vehicle or rider_seat then return nil end

  local tags = {}
  for t, v in rider_seat:iterateTags() do tags[t] = v end

  return {
    uid = rider_seat.uid,
    priority = rider_seat:getPriority(),
    tags = tags
  }
end


---===== SETTERS =====---

---Sets the value that represents the scale of this avatar relative to the default Steve model.  
---This is the scale *while sitting*, if the avatar becomes much shorter when sitting that must be reflected here.
---
---Note: Pehkui scale does *not* count. This must be relative to a Steve that has the same Pehkui scale.
---
---If `scale` is `nil`, it will default to `1`.
---@param value? number
function rider.setScale(value)
  rider_tags["gscarrier:scale"] = value or 1
  avatar:store("GSCarrier:rider.Tags", rider_tags)
end



avatar:store("GSCarrier:rider.Enabled", true)
avatar:store("GSCarrier:rider.Tags", rider_tags)

this.rider = rider


---===|| RIDER CONTROLLER ||=========================================================================================---

---@type Vector3?
local rcon_gbloffset
local rcon_enpoffset = ENT_NP:getPivot()
local rcon_camactive = false
local rcon_camoffset = renderer:getCameraOffsetPivot()
local rcon_eyeactive = false
local rcon_eyeoffset = renderer:getEyeOffset()
local rcon_aimactive = false

---The controller contains functions that control certain parts of a Figura avatar that would normally be overwritten by
---Carrier.
---
---While Carrier is active, these functions are the only way to modify these values. (Unless you disable them with a
---respective modify function.)
local ridercon = {}

---Gets the offset applied to everything (and the model roots) when sitting in a Carrier vehicle.
---@return Vector3?
function ridercon.getGlobalOffset() return rcon_gbloffset:copy() end

---Sets the offset applied to everything (and the model roots) when sitting in a Carrier vehicle.
---
---Your goal with this function is to get as close to the origin of your model as you can without causing excessive
---clipping.
---
---If `pos` is `nil`, no offset is applied.
---@param pos? Vector3
function ridercon.setGlobalOffset(pos) rcon_gbloffset = pos and pos:copy() or nil end

---Gets the pivot offset to use for the entity nameplate while Carrier is active.
---@return Vector3?
function ridercon.getNameplatePivot() return rcon_enpoffset and rcon_enpoffset:copy() or nil end

---Sets the pivot offset to use for the entity nameplace while Carrier is active.  
---
---This should *generally* match the value you would put in `nameplate.ENTITY:setPivot(...)`.
---
---If `pos` is `nil`, the nameplate is placed in the default position above the player's head.
---@param pos? Vector3
function ridercon.setNameplatePivot(pos) rcon_enpoffset = pos and pos:copy() or nil end

---Gets whether Carrier is allowed to modify the camera position.
---@return boolean
function ridercon.getModifyCamera() return rcon_camactive end

---Sets whether Carrier is allowed to modify the camera position.
---
---If `state` is `nil`, it will default to `false`.
---@param state? boolean
function ridercon.setModifyCamera(state)
  if not state then renderer:offsetCameraPivot(rcon_camoffset) end
  rcon_camactive = not not state
end

---Gets the pivot offset to use for the camera while Carrier is active.
---@return Vector3?
function ridercon.getCameraOffset() return rcon_camoffset and rcon_camoffset:copy() or nil end

---Sets the pivot offset to use for the camera while Carrier is active.
---
---This should *generally* match the value you would put in `renderer:offsetCameraPivot(...)`.
---
---If `pos` is `nil`, the camera pivot is placed in the default position in the eyes.
---@param pos? Vector3
function ridercon.setCameraOffset(pos) rcon_camoffset = pos and pos:copy() or nil end

---Gets whether Carrier is allowed to modify the eye offset.
---@return boolean
function ridercon.getModifyEye() return rcon_eyeactive end

---Sets whether Carrier is allowed to modify the eye offset.
---
---If `state` is `nil`, it will default to `false`.
---@param state? boolean
function ridercon.setModifyEye(state)
  if not state then renderer:setEyeOffset(rcon_eyeoffset) end
  rcon_eyeactive = not not state
end

---Gets the offset to use for the eye offset while Carrier is active.
---@return Vector3?
function ridercon.getEyeOffset() return rcon_eyeoffset and rcon_eyeoffset:copy() or nil end

---Sets the offset to use for the eye offset while Carrier is active.
---
---This should *generally* match the value you would put in `renderer:setEyeOffset(...)`.
---
---If `pos` is `nil`, the eye offset is placed in the default position in the eyes.
---@param pos? Vector3
function ridercon.setEyeOffset(pos) rcon_eyeoffset = pos and pos:copy() or nil end

---Gets whether Carrier will enable the aiming camera when holding or using an item that requires precise aiming.
---@return boolean
function ridercon.getAimEnabled() return rcon_aimactive end

---Gets whether Carrier will enable the aiming camera when holding or using an item that requires precise aiming.
---@param state? boolean
function ridercon.setAimEnabled(state) rcon_aimactive = not not state end


rider.controller = ridercon


---===|| EVENTS ||===================================================================================================---

events.ENTITY_INIT:register(function()
  local tag_name = user:isPlayer() and "gscarrier:player" or "gscarrier:cem"
  veh_tags[tag_name] = true
  rider_tags[tag_name] = true
  avatar:store("GSCarrier:vehicle.Tags", veh_tags)
  avatar:store("GSCarrier:rider.Tags", rider_tags)
end)

---@type Entity.any?
local actual_vehicle

local mark_for_cleanup = {}

local function inOutCubic(x) return x < 0.5 and (4 * x ^ 3) or (1 - ((-2 * x + 2) ^ 3) * 0.5) end

local aiming = false
local aim_time = 0

local aiming_actions = {BOW = true, SPEAR = true, CROSSBOW = true, BLOCK = true}
local aiming_items = {
  ["minecraft:snowball"] = true,
  ["minecraft:fishing_rod"] = true,
  ["minecraft:ender_pearl"] = true,
  ["minecraft:splash_potion"] = true,
  ["minecraft:lingering_potion"] = true,
  ["minecraft:crossbow"] = function(item) return item.tag.Charged == 1 end
}

local _headyaw, headyaw, _vehyaw, vehyaw = 0, 0, 0, 0
events.TICK:register(function()
  rider_vehicle = nil
  actual_vehicle = player:getVehicle()

  if actual_vehicle then
    if actual_vehicle:getVariable("GSCarrier:vehicle.Enabled") then
      rider_vehicle = actual_vehicle
    else -- Redirect
      local controller = actual_vehicle:getControllingPassenger()
      if controller and controller ~= player and controller:getVariable("GSCarrier:vehicle.Redirect") then
        rider_vehicle = controller
      end
    end
  end

  if rider_vehicle then
    local uid = INF
    local priority = -INF
    ---@type Lib.GS.Carrier.SeatRemote
    local selected_seat

    local seat_pri, seat_uid, seat_occ
    local tags = player:getVariable("GSCarrier:rider.Tags")
    for _, seat in pairs(rider_vehicle:getVariable("GSCarrier:vehicle.Seats") or {}) do
      ---@cast seat Lib.GS.Carrier.SeatRemote
      seat_uid = seat.uid
      seat_occ = seat:getOccupant()
      seat_pri = (not seat_occ or seat_occ == player) and seat:runCondition(player, tags)
      if seat_pri == nil then seat_pri = seat:getPriority() end

      if seat_pri
        and (
          seat_pri == true and seat_uid < uid
          or seat_pri ~= true and (seat_pri > priority or (seat_pri == priority and seat_uid < uid))
        )
      then
        uid = seat_uid
        priority = NAN
        selected_seat = seat
      end
    end

    if (selected_seat and selected_seat.uid) ~= (rider_seat and rider_seat.uid) then
      if rider_seat then
        rider_seat:runCallback(false)
        rider_seat:setOccupant()
      end
      if selected_seat then
        selected_seat:runCallback(true)
        selected_seat:setOccupant(player)
      end

      rider_seat = selected_seat
      avatar:store("GSCarrier:rider.Seat", rider_seat and rider_seat.uid or nil)

      ---@cast rider_vehicle LivingEntity
      vehyaw = rider_vehicle.getBodyYaw and rider_vehicle:getBodyYaw(0) or 0
    end

    ---@cast rider_vehicle LivingEntity
    _vehyaw, vehyaw = vehyaw, rider_vehicle.getBodyYaw and rider_vehicle:getBodyYaw() or 0
  elseif rider_seat then
    rider_seat:runCallback(false)
    rider_seat:setOccupant()
    rider_seat = nil
    avatar:store("GSCarrier:rider.Seat", nil)
  end

  _headyaw, headyaw = headyaw, player:getRot().y

  -- Aiming stuff
  if rcon_aimactive then
    local action = player:getActiveItem():getUseAction()
    local mainhand = player:getHeldItem()
    if type(aiming_items[mainhand.id]) == "function" then
      mainhand = aiming_items[mainhand.id](mainhand)
    else
      mainhand = aiming_items[mainhand.id]
    end
    local offhand = player:getHeldItem(true)
    if type(aiming_items[offhand.id]) == "function" then
      offhand = aiming_items[offhand.id](offhand)
    else
      offhand = aiming_items[offhand.id]
    end
    aiming = aiming_actions[action] or mainhand or offhand
    if aiming then
      if aim_time < 10 then aim_time = aim_time + 1 end
    elseif aim_time > 0 then
      aim_time = aim_time - 1
    end
  else
    aiming = false
    aim_time = 0
  end

  local scales = player:getNbt()["pehkui:scale_data_types"]
  local last_scale = rider_tags["pehkui:scale"]
  if scales then
    local scale = (
      scales["pehkui:base"] and scales["pehkui:base"].scale or 1
    ) * max(
      scales["pehkui:model_height"] and scales["pehkui:model_height"].scale or 1,
      scales["pehkui:model_width"] and scales["pehkui:model_width"].scale or 1,
      scales["pehkui:hitbox_height"] and scales["pehkui:hitbox_height"].scale or 1,
      scales["pehkui:hitbox_width"] and scales["pehkui:hitbox_width"].scale or 1
    )

    if scale ~= last_scale then
      rider_tags["pehkui:scale"] = scale
      avatar:store("GSCarrier:rider.Tags", rider_tags)
    end
  elseif last_scale ~= 1 then
    rider_tags["pehkui:scale"] = 1
    avatar:store("GSCarrier:rider.Tags", rider_tags)
  end

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
end, "GSCarrier:Tick_RiderVehicleCheck_RiderAimCheck_RiderPehkuiCheck_VehiclePassengerCheck")

local world_offset = vec(0, 0, 0)
local local_offset = vec(0, 0, 0)

local applied_contexts = {
  RENDER = true,
  FIRST_PERSON = true,
  OTHER = true
}

local was_riding = false
local aim_mult = 1
events.RENDER:register(function(delta, ctx)
  if rider_seat then
    if applied_contexts[ctx] then
      aim_mult = rcon_aimactive
        and inOutCubic(1 - math.clamp(aiming and (aim_time + delta) or (aim_time - delta), 0, 10) * 0.1)
        or 1
      was_riding = true
      world_offset = rider_seat:getPos():sub(player:getPos(delta))
      if rcon_gbloffset then world_offset:add(rcon_gbloffset * BB_TO_WORLD) end

      local yaw
      if actual_vehicle.getBodyYaw then
        yaw = math.lerp(_headyaw, headyaw, delta)
        local yaw_diff = math.clamp(
          ((yaw - math.lerp(_vehyaw, vehyaw, delta)) + 180) % 360 - 180,
          -85, 85
        )
        yaw = yaw - yaw_diff
        if (yaw_diff ^ 2) > 2500 then yaw = yaw + (yaw_diff * 0.2) end
      else
        yaw = player:getBodyYaw(delta)
      end

      local_offset = vectors.rotateAroundAxis(yaw + 180, world_offset, VEC_UP):scale(WORLD_TO_BB)

      --local seat_rot = rider_seat:getRot()
      if ctx == "FIRST_PERSON" then
        for root in pairs(rider_roots) do
          root:setPos():setPivot()
        end
      else
        for root in pairs(rider_roots) do
          root:setPos(local_offset):setPivot(rcon_gbloffset and -rcon_gbloffset or nil)
        end
      end
      nameplate.ENTITY:setPivot(
        world_offset + (rcon_enpoffset or player:getBoundingBox():mul(VEC_UP):add(NP_OFF))
      )
      if rcon_camactive then
        renderer:offsetCameraPivot(
          (rcon_camoffset and (world_offset + rcon_camoffset) or world_offset) * aim_mult
        )
      end
      if rcon_eyeactive then
        renderer:setEyeOffset(
          (rcon_eyeoffset and (world_offset + rcon_eyeoffset) or world_offset) * aim_mult
        )
      end
    else
      for root in pairs(rider_roots) do
        root:setPos():setPivot()
      end
      ENT_NP:setPivot(rcon_enpoffset)
    end
  elseif was_riding then
    for root in pairs(rider_roots) do
      root:setPos():setPivot()
    end
    ENT_NP:setPivot(rcon_enpoffset)
    if rcon_camactive then renderer:offsetCameraPivot(rcon_camoffset) end
    if rcon_eyeactive then renderer:setEyeOffset(rcon_eyeoffset) end
    was_riding = false
  end
end, "GSCarrier:Render_TheMagic")


do return setmetatable(this, thismt) end

---@diagnostic disable: duplicate-doc-alias

---@alias Lib.GS.Carrier.vehicleTag string
---@alias Lib.GS.Carrier.seatTag string
---@alias Lib.GS.Carrier.riderTag string

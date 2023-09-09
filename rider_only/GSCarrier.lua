-- ┌───┐                ┌───┐ --
-- │ ┌─┘ ┌─────┐┌─────┐ └─┐ │ --
-- │ │   │ ┌───┘│ ╶───┤   │ │ --
-- │ │   │ ├───┐└───┐ │   │ │ --
-- │ │   │ └─╴ │┌───┘ │   │ │ --
-- │ └─┐ └─────┘└─────┘ ┌─┘ │ --
-- └───┘                └───┘ --
---@module  "Passenger Pivot Library (Rider Only)" <GSCarrier_RiderOnly>
---@version v0.9.2
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

local ID = "GSCarrier_RiderOnly"
local VER = "0.9.2"
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

---@alias Lib.GS.Carrier.seatCallback fun(state: boolean, self: Lib.GS.Carrier.Seat)
---@alias Lib.GS.Carrier.seatCondition fun(ent: Entity.any, tags: {[Lib.GS.Carrier.riderTag]: unknown}, self: Lib.GS.Carrier.Seat): ((boolean | integer)?)

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
local rcon_camactive = true
local rcon_camoffset = renderer:getCameraOffsetPivot()
local rcon_eyeactive = true
local rcon_eyeoffset = renderer:getEyeOffset()
local rcon_aimactive = true

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
  rider_tags[user:isPlayer() and "gscarrier:player" or "gscarrier:cem"] = true
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
end, "GSCarrier:Tick_RiderVehicleCheck_RiderAimCheck_RiderPehkuiCheck")

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

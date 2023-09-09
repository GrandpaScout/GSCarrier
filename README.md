# GSCarrier

A Figura Library that allows avatars to reposition the players sitting on them. It even supports multiple passengers at
a time and passengers in vehicles you are controlling.

> [!WARNING]  
> Tags are a work-in-progress feature and may change as this library is updated to version `1.0.0`.  
> It is not recommended to use them unless you understand that they will change!


## Intallation

To install this library, download this repository and pick a folder.
* `both`: Contains code for creating a Carrier vehicle and a Carrier rider.  
  Use this if you plan to use both features.
* `rider_only`: Contains code only for creating a Carrier rider.  
  Use this if you only plan to ride Carrier vehicles.
* `vehicle_only`: Contains code only for creating a Carrier vehicle.  
  Use this if you only plan to put seats on your avatar and not ride Carrier vehicles.


## Usage

Everything in this section will assume that you have done
```lua
local Carrier = require("GSCarrier")
```


### Vehicles

Create a new seat with
```lua
-- The entire table and everything in it is optional, you can leave out the entire table 
-- or parts of it if you don't want to mess with them.
Carrier.vehicle.newSeat("Name", models.model_name.path.to.part, {
  priority = integer,
  tags = {
    ["namespace:tag_name"] = true,
    ["namespace:tag_with_value"] = 123,
  },
  callback = function(state, self)
    -- state is `false` if exiting or `true` if entering the seat.
    -- self is the seat object
  end,
  condition = function(ent, tags, self)
    -- ent is the entity checking this seat.
    -- tags is the list of tags the entity has.
    -- self is the seat object.

    -- return true to mark this seat as top priority
    -- return false to deny the entity from sitting in this seat.
    -- return a number to change the priority of this sear for this entity.
    -- return nothing to leave the priority alone.

    -- No matter what, there is a hidden condition that always returns `false` if the part this seat
    -- is connected to does not exist or is invisible.
  end
})
```
Seats are objects that can be saved to variables for modification later.
```lua
local my_seat = Carrier.vehicle.newSeat(...)

my_seat:setPriority(64)
```
&nbsp;  
Add or remove vehicle tags with the following functions:
```lua
-- Adds a tag to the Carrier vehicle with the given value (or `true` if there is none)
Carrier.vehicle.addTag("gscarrier:horizontal")
Carrier.vehicle.addTag("namespace:tag_with_value", 42)

-- Removes a tag from the Carrier vehicle.
Carrier.vehicle.removeTag("namespace:tag_with_value")
```
&nbsp;  
To enable redirecting, you can use the `.setRedirect()` function.  
Redirecting is a feature that moves Carrier riders that are riding the Minecraft entity you are controlling to
yourself.  
(Ex. You are controlling a boat and there's a player in the back using Carrier. They will visually ride you instead.)
```lua
-- Enables redirecting.
Carrier.vehicle.setRedirect(true)
```


### Rider

Add or remove parts that should be moved when the player is riding a Carrier vehicle with:
```lua
-- Adds all of the model parts given to the function
Carrier.rider.addRoots(models.model_name.path.to.part1, models.model_name.path.to.part2, etc.)

-- Removes all of the model parts given to the function.
-- If one of the parts was not added before, that part is ignored.
Carrier.rider.removeRoots(models.model_name.path.to.part1, models.model_name.path.to.part2, etc.)
```
&nbsp;  
Add or remove rider tags with the following functions:
```lua
-- Adds a tag to the Carrier rider with the given value (or `true` if there is none)
Carrier.rider.addTag("gscarrier:horizontal")
Carrier.rider.addTag("namespace:tag_with_value", 42)

-- Removes a tag from the Carrier rider.
Carrier.rider.removeTag("namespace:tag_with_value")

-- Sets the scale tag of the Carrier rider.
-- This should be a scale relative to the default Steve model *while both you and the Steve are sitting*.
--
-- If you are using Pehkui, the scale is relative to the default Steve model with the same pehkui scale.
-- Pehkui scales are handled internally.
Carrier.rider.setScale(1.23)
```
&nbsp;  
Get the current vehicle and seat (if any) with the following functions:
```lua
-- May return `nil` if there is no vehicle.
-- Will return a different value than `player:getVehicle()` if you are being redirected by
-- a Carrier vehicle.
local vehicle = Carrier.rider.getVehicle()

-- May return `nil` if there is no seat.
-- Doesn't actually return a seat object, it instead returns a table of
-- data for the seat at the time this function was called.
local seat_data = Carrier.rider.getSeat()
```
&nbsp;  
Due to the nature of how Carrier riders are handled, the rider controller is required to allow modifying things such as
the camera pivot offset or the nameplate pivot.
```lua
-- Gets and sets the global offset for riding. This is generally used to fix floating avatars when
-- sitting since Carrier makes no attempt to try and vertically align your avatar to the seat.
-- (This function does not support 3-number inputs. Use vectors!)
-- A nil offset is effectively the same as zero offset.
local offset = Carrier.rider.controller.getGlobalOffset()
Carrier.rider.controller.setGlobalOffset(vec(1,2,3))

-- Gets and sets the nameplate offset for riding. By default, Carrier will place the nameplate just
-- above your head in the "default" position. This can be changed if your avatar uses its own offset.
-- (This function does not support 3-number inputs. Use vectors!)
-- A nil offset uses the "default" position.
local offset = Carrier.rider.controller.getNameplatePivot()
Carrier.rider.controller.setNameplatePivot(vec(1,2,3))

-- Gets and sets whether Carrier is allowed to move the camera or not.
-- By default, Carrier will move the camera to match your eye position at the seat you are in.
-- This can be disabled if you want custom functionality.
local state = Carrier.rider.controller.getModifyCamera()
Carrier.rider.controller.setModifyCamera(true)

-- Gets and sets the camera offset for riding. By default, Carrier will place the camera in your
-- new eye position. This can be offset further with this function.
-- This should generally match whatever is put into `renderer:offsetCameraPivot()`.
-- (This function does not support 3-number inputs. Use vectors!)
-- A nil offset is effectively the same as zero offset.
local offset = Carrier.rider.controller.getCameraOffset()
Carrier.rider.controller.setCameraOffset(vec(1,2,3))

-- Gets and sets whether Carrier is allowed to move the "eye position" or not.
-- By default, Carrier will move the eye position to match where it would be if you were
-- physically sitting on the seat.
-- THIS MAY BE CONSIDERED A CHEAT IN SOME SERVERS. IT IS RECOMMENDED TO DISABLE THIS IF YOU
-- ARE NOT CERTAIN THIS WOULD BE ALLOWED.
local state = Carrier.rider.controller.getModifyEye()
Carrier.rider.controller.setModifyEye(true)

-- Gets and sets the eye offset for riding. By default, Carrier will place the eye position
-- where it would be if you were physically sitting on the seat.
-- This should generally match whatever is put into `renderer:setEyeOffset()`.
-- (This function does not support 3-number inputs. Use vectors!)
-- A nil offset is effectively the same as zero offset.
-- THIS MAY BE CONSIDERED A CHEAT IN SOME SERVERS. IT IS RECOMMENDED TO DISABLE THIS IF YOU
-- ARE NOT CERTAIN THIS WOULD BE ALLOWED.
local offset = Carrier.rider.controller.getEyeOffset()
Carrier.rider.controller.setEyeOffset(vec(1,2,3))

-- Gets and sets whether the "aim camera" is enabled while riding.
-- When using certain items, the position they use for targeting is your default position
-- and not the modified position given by Carrier. This is fixed by moving your camera
-- back to its original position while aiming an item.
local state = Carrier.rider.controller.getAimEnabled()
Carrier.rider.controller.setAimEnabled(true)

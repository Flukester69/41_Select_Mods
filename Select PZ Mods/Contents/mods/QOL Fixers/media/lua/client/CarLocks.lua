
function addKey()

local player = getPlayer();
local car = player:getVehicle();
local inv = player:getInventory();

if not car then
	player:Say("Not in a vehicle...");
	inv:AddItem("Base.SheetMetal");
		else
	inv:AddItem(car:createVehicleKey());
	end
end

function unHotwire() -- looking into VehicleCommands unhotwire debug cheat

local player = getPlayer();
local car = player:getVehicle();

if not car then
	player:Say("Not in a vehicle...");
	else
		ISVehicleMechanics.onCheatHotwire(player, car, false, false) -- should work in multiplayer since sendClientCommand
	end
end

--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

TRPS_Menu={}

TRPS_Menu.Option = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	
	local station = nil;
	
    for i,v in ipairs(worldobjects) do
		if CPropStationSystem.instance:isValidIsoObject(v) then
			station = v
		end
	end
	
	if station and getSpecificPlayer(player):DistToSquared(station:getX() + 0.5, station:getY() + 0.5) < 2 * 2 then
		local option = context:addOption(getText("ContextMenu_PropStation"), worldobjects, nil)
		local tooltip = TRPS_Menu.addToolTip()
		tooltip:setName(getText("ContextMenu_PropStation"))
		tooltip.description = getText("IGUI_RemainingPercent", round(station:getModData()["fuelAmount"] / 4))
		option.toolTip = tooltip
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(TRPS_Menu.Option);

function TRPS_Menu.addToolTip()
    local toolTip = TRPS_ToolTip:new();
    toolTip:initialise();
    toolTip:setVisible(false);
    return toolTip;
end

TRPS_Menu.doMenu = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end
	
	local MyhaveFuel = nil;
	local tank = nil;
	
	for i,v in ipairs(worldobjects) do
		if CPropStationSystem.instance:isValidIsoObject(v) and CPropStationSystem:isValidPart(v:getModData()["partSquare"]) then
			MyhaveFuel = v
		end
	end
	
    if MyhaveFuel and MyhaveFuel:getModData()["fuelAmount"] > 0 then
		if test == true then return true; end	
		local propaneTanks = getSpecificPlayer(player):getInventory():getItemsFromType("PropaneTank");
		
        for i=0, propaneTanks:size() -1 do
            if propaneTanks:get(i):getUsedDelta() < 1 then
                tank = propaneTanks:get(i);
                break;
            end
		end
		
		if tank then
			context:addOption(getText("ContextMenu_RefillPropaneTank"), tank, TRPS_Menu.onTakeFuel, getSpecificPlayer(player), MyhaveFuel);
		end
    end
	
	--Debug
	if getCore():isInDebug() then
		TRPS_Menu.Debug(worldobjects, getSpecificPlayer(player))
		
		--Find barrel in inventory to place 
		local PropStation = getSpecificPlayer(player):getInventory():FindAndReturn("PropStation");
		if PropStation then
			local BarrelOption = context:addOption(getText("ContextMenu_PlacePropStation"), player, TRPS_Menu.onPlacePropStation, PropStation);	
		end	
	end
end

Events.OnFillWorldObjectContextMenu.Add(TRPS_Menu.doMenu);

TRPS_Menu.onTakeFuel = function(tank, player, propStation)
    if tank and luautils.walkAdj(player, propStation:getSquare())  then	
		-- if luautils.haveToBeTransfered(player, tank) then
			-- ISTimedActionQueue.add(ISInventoryTransferAction:new(player, tank, tank:getContainer(), player:getInventory()));
		-- end
		ISTimedActionQueue.add(ISPropStationActions:new(player, propStation, tank, 400 - (tank:getUsedDelta() * 300)));
    end
end


TRPS_Menu.Debug = function(worldobjects, player)
	for i,v in ipairs(worldobjects) do	
		if instanceof(v, "IsoGenerator") then
			player:Say(getText(tostring(v)));
		end
		if v:getName() == "PropStation" and v:getModData()["fuelAmount"] > 0  then
			player:Say(getText("FuelAmount: "..tostring(v:getModData()["fuelAmount"])));
			player:Say(getText("FuelAmount: "..tostring(v:getSquare())));
			if v:getModData()["partSquare"] then
				player:Say(getText("FuelAmount: "..tostring(v:getModData()["partSquare"])));
			end
			--v:getModData()["fuelAmount"] = 200;
			
			--player:Say(getText(tostring(ISFuelBarrel.weightEmpty)));
			--player:Say(getText(tostring(v:getSprite():getName())));		
			--print("FuelProp: "..tostring(v:getSquare():getProperties():getPropertyNames()));
			break;
		end
	end
	--print(bcUtils.dump(worldobjects));
	--print("Size is: "..#worldobjects);
	--player:Say(getText(tostring(#worldobjects)));
end

TRPS_Menu.onPlacePropStation = function(player, PropStation)
    local station = ISPropStation:new(player, "trstation_01_3", "trstation_01_2", "trstation_01_10", "trstation_01_11");
    station.player = player
    station.modData["need:TRPack.PropStation"] = "1";
    getCell():setDrag(station, player);
end

--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

if isClient() then return end

require "Map/SGlobalObjectSystem"
require "PropStation/BuildingObjects/ISPropStationl.lua" -- for ISPropStation{}

SPropStationSystem = SGlobalObjectSystem:derive("SPropStationSystem")

function SPropStationSystem:new()
    local o = SGlobalObjectSystem.new(self, "propstation")
    return o
end

function SPropStationSystem:initSystem()
    SGlobalObjectSystem.initSystem(self)

    -- Specify GlobalObjectSystem fields that should be saved.
    self.system:setModDataKeys({})
    
    -- Specify GlobalObject fields that should be saved.
    self.system:setObjectModDataKeys({
        'fuelAmount', 'partSquare'})

    self:convertOldModData()
end

function SPropStationSystem:newLuaObject(globalObject)
    return SPropStationGlobalObject:new(self, globalObject)
end

function SPropStationSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getName() == "PropStation"
end

function SPropStationSystem:convertOldModData()
end

local noise = function(msg)
    SPropStationSystem.instance:noise(msg)
end

local function getPropStationAt(x, y, z)
    return SPropStationSystem.instance:getLuaObjectAt(x, y, z)
end

function SPropStationSystem:OnClientCommand(command, player, args)
    local station = getPropStationAt(args.x, args.y, args.z)
    if not station then
        noise('no propstation found at '..args.x..','..args.y..','..args.z)
        return
    end
	
    if command == "fuelChange" then
		local stationPart = getPropStationAt(station.partSquare[1], station.partSquare[2], station.partSquare[3])
		if not stationPart then
			noise('no propstation found at '..station.partSquare[1]..','..station.partSquare[2]..','..station.partSquare[3])
			return
		end
		
        station:setFuelAmount(args.fuelAmount)
		stationPart:setFuelAmount(args.fuelAmount)
        return
    end
end

SGlobalObjectSystem.RegisterSystemClass(SPropStationSystem)

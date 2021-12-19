--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

if isClient() then return end

require "Map/SGlobalObject"
require "PropStation/BuildingObjects/ISPropStation.lua"

SPropStationGlobalObject = SGlobalObject:derive("SPropStationGlobalObject")

function SPropStationGlobalObject:new(luaSystem, globalObject)
    local o = SGlobalObject.new(self, luaSystem, globalObject)
    return o
end

function SPropStationGlobalObject:initNew()
    self.fuelAmount = 0
    --self.fuelMax = ISFuelBarrel.fuelMax
end

function SPropStationGlobalObject:stateFromIsoObject(isoObject)
    self.fuelAmount = isoObject:getModData().fuelAmount
	self.partSquare = isoObject:getModData().partSquare
    --self.fuelMax = isoObject:getModData().fuelMax

    -- if not self.fuelMax then
        -- self.fuelMax = ISFuelBarrel.fuelMax;
        -- isoObject:getModData()["fuelMax"] = self.fuelMax
    -- end

    isoObject:transmitModData()
end

function SPropStationGlobalObject:stateToIsoObject(isoObject)
    if not self.fuelAmount then
        self.fuelAmount = 0
    end
    -- if not self.fuelMax then
        -- self.fuelMax = ISFuelBarrel.fuelMax;
        -- isoObject:getModData()["fuelMax"] = self.fuelMax
    -- end
	
    self:setModData()
end

function SPropStationGlobalObject:setModData()
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    local previousfuelAmount = isoObject:getModData()["fuelAmount"];
    isoObject:getModData()["fuelAmount"] = self.fuelAmount;
    if previousfuelAmount ~= isoObject:getModData()["fuelAmount"] then
        isoObject:transmitModData();
    end
end

function SPropStationGlobalObject:setFuelAmount(fuelAmount)
	self.fuelAmount = fuelAmount
    local isoObject = self:getIsoObject()
    if not isoObject then return end
    isoObject:getModData()["fuelAmount"] = self.fuelAmount
    isoObject:transmitModData()
end

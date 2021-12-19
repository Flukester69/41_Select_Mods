--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISPropStationActions = ISBaseTimedAction:derive("ISPropStationActions");

function ISPropStationActions:isValid()
	return true;
end

function ISPropStationActions:update()
	self.character:faceLocation(self.propStation:getSquare():getX(), self.propStation:getSquare():getY())
	
	self.tank:setJobDelta(self:getJobDelta())
	self.tank:setJobType(getText("ContextMenu_AddGas"))
	
	local litres = self.propStationStart + (self.propStationTarget - self.propStationStart)*self:getJobDelta()
	litres = math.ceil(litres)
	
	if litres ~= self.amountSent then
		local Obj = self.propStation;
		local args = { x = Obj:getX(), y = Obj:getY(), z = Obj:getZ(), fuelAmount = litres }
		CPropStationSystem.instance:sendCommand(self.character, 'fuelChange', args)
		self.amountSent = litres
	end
	
	local litresTaken = litres - self.propStationStart
	local usedDelta = self.tankStart - litresTaken*self.tank:getUseDelta()
	self.tank:setUsedDelta(usedDelta)
end

function ISPropStationActions:start()
	self.propStationStart = self.propStation:getModData()["fuelAmount"]
	self.tankStart = self.tank:getUsedDelta()
	
	local add = (1.0 - self.tankStart)/self.tank:getUseDelta();
	local take = math.min(add, self.propStationStart);
		
	self.propStationTarget = self.propStationStart - take;
	self.tankTarget = self.tankStart + take*self.tank:getUseDelta();
	
	self.amountSent = math.ceil(self.propStationStart);
	self.action:setTime(30 + take * 45)
end

function ISPropStationActions:stop()
	self.tank:setJobDelta(0)
    ISBaseTimedAction.stop(self);
end

function ISPropStationActions:perform()
	self.tank:setJobDelta(0)
	self.tank:setUsedDelta(self.tankTarget)
	local Obj = self.propStation;
	local args = { x = Obj:getX(), y = Obj:getY(), z = Obj:getZ(), fuelAmount = self.propStationTarget }
	CPropStationSystem.instance:sendCommand(self.character, 'fuelChange', args)
    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISPropStationActions:new(character, propStation, tank, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.propStation = propStation;
    --o.square = square;
	o.tank = tank;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	return o;
end

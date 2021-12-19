require "TimedActions/ISBaseTimedAction"


ISBloodCure = ISBaseTimedAction:derive("ISBloodCure");              

function ISBloodCure:isValid()                        
	return self.character:getInventory():contains(self.item);
end

function ISBloodCure:update()                          

end

function ISBloodCure:start()                            
end

function ISBloodCure:stop()                             
    ISBaseTimedAction.stop(self);
end

function ISBloodCure:perform()                          
	if self.item then
		self.item:Use();
		for i = 0, self.character:getBodyDamage():getBodyParts():size()-1 do
			self.character:getBodyDamage():getBodyParts():get(i):SetInfected(false);
		end
		self.character:getBodyDamage():setInfectionLevel(0); 
		self.character:getBodyDamage():setInf(false);
		self.character:getBodyDamage():setInfectionTime(-1);
		self.character:getBodyDamage():setInfectionMortalityDuration(-1);
		self.character:getInventory():AddItem("PZBloodCure.Flask");  
	end
	ISBaseTimedAction.perform(self);
end

function ISBloodCure:new(character, item, time)     
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.item = item;
	o.stopOnWalk = false;
	o.stopOnRun = false;
	o.maxTime = time;
	o.timer = time / 5;
	o.tick = 0;
	return o;
end

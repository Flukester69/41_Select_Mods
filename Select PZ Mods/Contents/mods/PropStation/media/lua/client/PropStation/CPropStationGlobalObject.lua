--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "Map/CGlobalObject"

CPropStationGlobalObject = CGlobalObject:derive("CPropStationGlobalObject")

function CPropStationGlobalObject:new(luaSystem, isoObject)
	local o = CGlobalObject.new(self, luaSystem, isoObject)
	return o
end

function CPropStationGlobalObject:getObject()
	return self:getIsoObject()
end


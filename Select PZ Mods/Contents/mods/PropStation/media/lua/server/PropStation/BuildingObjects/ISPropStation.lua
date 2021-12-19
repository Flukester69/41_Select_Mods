--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISBuildingObject"

-- this class extend ISBuildingObject, it's a class to help you drag around/place an item in the world
ISPropStation = ISBuildingObject:derive("ISPropStation");

function ISPropStation:create(x, y, z, north, sprite)
	self.fuel = 400 - ZombRand(200);
	
    local cell = getWorld():getCell();
    self.sq = cell:getGridSquare(x, y, z);
	local square1 = {x, y, z}

	local spriteAName = self.northSprite2;

	local xa = x;
	local ya = y;

	-- we get the x and y of our next tile (depend if we're placing the furniture north or not)
	if north then
		ya = ya - 1;
	else
		-- if we're not north we also change our sprite
		spriteAName = self.sprite2;
		xa = xa - 1;
	end
	
	local squareA = cell:getGridSquare(xa, ya, z);
	local square2 = {xa, ya, z}
	
	self:setInfo(self.sq, north, sprite, square2, self);
	self:setInfo(squareA, north, spriteAName, square1, self);
end

function ISPropStation:setInfo(square, north, sprite, squareA)
	-- add furniture to our ground
	local thumpable = IsoThumpable.new(getCell(), square, sprite, north, self);
	-- name of the item for the tooltip
	buildUtil.setInfo(thumpable, self);
	-- the furniture have 200 base health + 100 per carpentry lvl
	thumpable:setMaxHealth(2147483640);
	thumpable:setHealth(thumpable:getMaxHealth())
	-- the sound that will be played when our furniture will be broken
	thumpable:setBreakSound("BreakObject");
	square:AddSpecialObject(thumpable);
	thumpable:getModData()["fuelAmount"] = self.fuel;
	thumpable:getModData()["partSquare"] = squareA;
	thumpable:setSpecialTooltip(true);
	thumpable:transmitCompleteItemToServer();
	triggerEvent("OnObjectAdded", thumpable)
end

-- function ISPropStation:setInfo2(square, north, sprite, squareA)
	-- -- add furniture to our ground
	-- local thumpable = IsoThumpable.new(getCell(), square, sprite, north, self);
	-- -- name of the item for the tooltip
	-- buildUtil.setInfo(thumpable, self);
	-- -- the furniture have 200 base health + 100 per carpentry lvl
	-- thumpable:setMaxHealth(200);
	-- thumpable:setHealth(thumpable:getMaxHealth())
	-- -- the sound that will be played when our furniture will be broken
	-- thumpable:setBreakSound("BreakObject");
	-- square:AddSpecialObject(thumpable);
	-- thumpable:getModData()["fuelAmount"] = 400;
	-- thumpable:getModData()["partSquare"] = squareA;
	-- --thumpable:setSpecialTooltip(true);
	-- thumpable:transmitCompleteItemToServer();
	-- triggerEvent("OnObjectAdded", thumpable)
-- end

function ISPropStation:new(player, sprite1, sprite2, northSprite1, northSprite2)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
	o:setSprite(sprite1);
	o:setNorthSprite(northSprite1);
	o.sprite2 = sprite2;
	o.northSprite2 = northSprite2;
    o.noNeedHammer = true;
    o.name = "PropStation";
    o.player = player;
    o.dismantable = true;	
	--o.blockAllTheSquare = true;
	--o.canBarricade = false;
	o.maxTime = 80;
    return o;
end

-- our station can be placed on this square ?
-- this function is called everytime you move the mouse over a grid square, you can for example not allow building inside house..
-- function ISPropStation:isValid(square)
    -- if not square then return false end
    -- if square:isSolid() or square:isSolidTrans() then return false end
    -- if square:HasStairs() then return false end
    -- if square:HasTree() then return false end
    -- if not square:getMovingObjects():isEmpty() then return false end
    -- if not square:TreatAsSolidFloor() then return false end
    -- if not self:haveMaterial(square) then return false end
    -- for i=1,square:getObjects():size() do
        -- local obj = square:getObjects():get(i-1)
        -- if self:getSprite() == obj:getTextureName()
		-- or instanceof(obj, "IsoGenerator") 
		-- or CCampfireSystem.instance:isValidIsoObject(obj)then return false end
    -- end
    -- if buildUtil.stairIsBlockingPlacement( square, true ) then return false; end
    -- return true
-- end

function ISPropStation:render(x, y, z, square)
	-- render the first part
	ISBuildingObject.render(self, x, y, z, square)
	-- render the other part of the furniture
	-- name of our 2 sprites needed for the rest of the furniture
	local spriteAName = self.northSprite2;

	local spriteAFree = true;

	-- we get the x and y of our next tile (depend if we're placing the object north or not)
	local xa, ya, za = self:getSquare2Pos(square, self.north)

	-- if we're not north we also change our sprite
	if not self.north then
		spriteAName = self.sprite2;
	end
	local squareA = getCell():getGridSquare(xa, ya, za);

	-- test if the square are free to add our furniture
	if not self.canBeAlwaysPlaced and (not squareA or not squareA:isFreeOrMidair(true)) then
		spriteAFree = false;
	end

	if squareA and squareA:isVehicleIntersecting() then spriteAFree = false end

	-- render our second tile object
	local spriteA = IsoSprite.new();
	spriteA:LoadFramesNoDirPageSimple(spriteAName);
	if spriteAFree then
		spriteA:RenderGhostTile(xa, ya, za);
	else
		spriteA:RenderGhostTileRed(xa, ya, za);
	end
end

function ISPropStation:isValid(square)
	if not ISBuildingObject.isValid(self, square) then
		return false
    end
    if buildUtil.stairIsBlockingPlacement( square, true ) then return false; end
	if square:isVehicleIntersecting() then return false end
	local xa, ya, za = self:getSquare2Pos(square, self.north)
	local squareA = getCell():getGridSquare(xa, ya, za)
	if not squareA or not squareA:isFreeOrMidair(true) or buildUtil.stairIsBlockingPlacement( squareA, true ) then
		return false
	end
	if squareA:isVehicleIntersecting() then return false end
	return true
end

function ISPropStation:getSquare2Pos(square, north)
	local x = square:getX()
	local y = square:getY()
	local z = square:getZ()
	if north then
		y = y - 1
	else
		x = x - 1
	end
	return x, y, z
end

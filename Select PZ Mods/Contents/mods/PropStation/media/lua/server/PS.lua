require "Items/SuburbsDistributions"
require "Items/ItemPicker"

local IsNorth = true;

PropStation = {}
PropStation.SpawnList = 
{
	--West Point
	{12066, 7157, IsNorth};
	{11818, 6879, IsNorth};
	
	--Valley Station
	{13717, 5677, IsNorth};
	{12725, 5064, IsNorth};
	
	--Rosewood
	{8326, 12255, IsNorth};
	{8129, 11252, IsNorth};
	
	--Riverside
	{5444, 5869, IsNorth};
	{6098, 5330}; -- Move to but where?!
	
	--Muldraugh
	{10637, 9750, IsNorth};
	{10623, 10628, IsNorth};
	
	--March Ridge
	{10159, 12815, IsNorth};
	
	--Dixie
	{11629, 8309, IsNorth};
	{11511, 8814}; -- Move to but where?!
}

-- table.insert(PSSpawnList, );
-- table.insert(PSSpawnList, );


function PropStation.AddPropStation(square)	
	if not square:getModData().AddPropStation then
		square:getModData().AddPropStation = true;
		
		for i, loc in ipairs(PropStation.SpawnList) do	
			local sq = getCell():getGridSquare(loc[1], loc[2],0);
			
			if sq == square then
			
				local station = ISPropStation:new(1, "trstation_01_3", "trstation_01_2", "trstation_01_10", "trstation_01_11");
				
				if loc[3] then
					station:create(loc[1], loc[2], 0, true, "trstation_01_10") 
				else
					station:create(loc[1], loc[2], 0, false, "trstation_01_3")
				end
			end
		end
	end
end

Events.LoadGridsquare.Add(PropStation.AddPropStation);
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
print("[ Loading EM_COMMUNITYMAP fort_redstone ]");
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--
-- em_communitymap - em_map plugin
--
--
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
em_map = em_map or {};
em_map.communitymap_areas = em_map.communitymap_areas or {};
if not em_map.communityMapReplacesVanilla then
em_map.communityMapReplacesVanilla = false; --if this map replaces the entire base map set = true;
end
local small, medium, large = UIFont.NewSmall, UIFont.NewMedium, UIFont.NewLarge;
---------------------------------------------------------------------------------------------------- do not edit below
---------------------------------------------------------------------------------------------------- V---------------V
local callback_chain_load_community_minimapTile;
if em_map.callback_chain_load_community_minimapTile ~= nil then
callback_chain_load_community_minimapTile = em_map.callback_chain_load_community_minimapTile;
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function em_map:callback_chain_load_community_minimapTile(_index)
self.mapTiles[_index] = getTexture("media/textures/mapTiles/cell_" .. _index .. ".png");
if not self.mapTiles[_index] and callback_chain_load_community_minimapTile ~= nil then
callback_chain_load_community_minimapTile(self, _index);
end;
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
em_map.communitymap_areas["Fort Redstone"] = {font = medium, x1 = 5550, y1 = 11888, x2 = 5550, y2 = 11888, r = 0, g = 0, b = 0, a = 0};
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

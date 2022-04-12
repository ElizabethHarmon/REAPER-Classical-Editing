--[[
 * ReaScript Name: Classical Crossfade
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(53459, 0)
  reaper.Main_OnCommand(40297, 0)
  reaper.Main_OnCommand(53616, 0)
  reaper.Main_OnCommand(40625, 0)
  reaper.Main_OnCommand(53617, 0)
  reaper.Main_OnCommand(40626, 0)
  reaper.Main_OnCommand(40717, 0)
  reaper.Main_OnCommand(40916, 0)
  reaper.Main_OnCommand(40635, 0)

  reaper.Undo_EndBlock('Classical Crossfade', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
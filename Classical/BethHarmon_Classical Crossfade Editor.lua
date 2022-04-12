--[[
 * ReaScript Name: Classical Crossfade Editor
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(55769, 0)
  reaper.Main_OnCommand(40113, 0)
  reaper.Main_OnCommand(53451, 0)
  reaper.Main_OnCommand(40507, 0)
  reaper.Main_OnCommand(41827, 0)

  reaper.Undo_EndBlock('Classical Crossfade Editor', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
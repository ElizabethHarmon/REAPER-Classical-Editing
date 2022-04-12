--[[
 * ReaScript Name: Prepare Takes for Classical Editing
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(40296, 0)
  reaper.Main_OnCommand(40417, 0)
  reaper.Main_OnCommand(53459, 0)
  reaper.Main_OnCommand(40706, 0)
  reaper.Main_OnCommand(40032, 0)

  reaper.Undo_EndBlock('Prepare Takes for Classical Editing', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
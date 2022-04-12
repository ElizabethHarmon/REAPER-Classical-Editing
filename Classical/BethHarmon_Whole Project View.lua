--[[
 * ReaScript Name: Whole Project View
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(40296, 0)
  reaper.Main_OnCommand(53801, 0)
  reaper.Main_OnCommand(40297, 0)
  reaper.Main_OnCommand(40295, 0)

  reaper.Undo_EndBlock('Whole Project View', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
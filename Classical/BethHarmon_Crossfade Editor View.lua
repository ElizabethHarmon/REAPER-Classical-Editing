--[[
 * ReaScript Name: Crossfade Editor View
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(55769, 0)
  reaper.Main_OnCommand(40113, 0)
  reaper.Main_OnCommand(53451, 0)

  reaper.Undo_EndBlock('Crossfade Editor View', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
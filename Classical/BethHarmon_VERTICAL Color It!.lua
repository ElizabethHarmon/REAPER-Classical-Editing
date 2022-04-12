--[[
 * ReaScript Name: VERTICAL Color It!
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(40042, 0)
  reaper.Main_OnCommand(53773, 0)
  reaper.Main_OnCommand(40421, 0)
  reaper.Main_OnCommand(40706, 0)

  reaper.Undo_EndBlock('VERTICAL Color It!', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
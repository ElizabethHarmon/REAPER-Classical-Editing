--[[
 * ReaScript Name: Duplicate folder (No items)
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(53773, 0)
  reaper.Main_OnCommand(54959, 0)
  reaper.Main_OnCommand(53426, 0)
  reaper.Main_OnCommand(53573, 0)
  reaper.Main_OnCommand(40421, 0)
  reaper.Main_OnCommand(53629, 0)

  reaper.Undo_EndBlock('Duplicate folder (No items)', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

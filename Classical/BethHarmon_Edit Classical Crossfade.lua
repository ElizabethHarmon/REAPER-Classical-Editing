--[[
 * ReaScript Name: Edit Classical Crossfade
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(40034, 0)
  reaper.Main_OnCommand(41174, 0)
  reaper.Main_OnCommand(40841, 0)
  reaper.Main_OnCommand(40841, 0)
  reaper.Main_OnCommand(53287, 0)
  reaper.Main_OnCommand(40841, 0)
  reaper.Main_OnCommand(53459, 0)
  reaper.Main_OnCommand(40034, 0)
  reaper.Main_OnCommand(41173, 0)
  reaper.Main_OnCommand(40842, 0)
  reaper.Main_OnCommand(40842, 0)
  reaper.Main_OnCommand(53286, 0)
  reaper.Main_OnCommand(40841, 0)
  reaper.Main_OnCommand(53617, 0)
  reaper.Main_OnCommand(40289, 0)
  reaper.Main_OnCommand(53451, 0)

  reaper.Undo_EndBlock('Edit Classical Crossfade', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()
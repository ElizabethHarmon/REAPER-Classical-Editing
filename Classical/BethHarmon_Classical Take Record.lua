--[[
 * ReaScript Name: Classical Take Record
 * Author: BethHarmon
 * Version: 1.0
]]--

local function main()
  if reaper.GetPlayState() == 0
  then
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()

    reaper.Main_OnCommand(40491, 0)
    reaper.Main_OnCommand(53773, 0)
    reaper.Main_OnCommand(53342, 0)
    reaper.Main_OnCommand(1013, 0)

    reaper.Undo_EndBlock('Classical Take Record', 0)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
    reaper.UpdateTimeline()
  else
  -- reaper.GetPlayState() == 4
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()

    reaper.Main_OnCommand(40667, 0)
    reaper.Main_OnCommand(53343, 0)
    reaper.Main_OnCommand(53777, 0)

    reaper.Undo_EndBlock('Classical Take Record Stop', 0)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
    reaper.UpdateTimeline()
  end
end

main()

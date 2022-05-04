--[[
@noindex

This file is a part of "BethHarmon_Classical" package.
See "BethHarmon_Classical.lua" for more information.

Copyright (C) 2022 BethHarmon

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

]]--

local function fadeStart()
  reaper.SetToggleCommandState(1, fade_editor_toggle, 1)
  reaper.RefreshToolbar2(1, fade_editor_toggle)
  start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  file = io.open(reaper.GetResourcePath().."/Scripts/BethHarmon Scripts/classical/BethHarmon_zoom_level.txt", "w")
  file:write(start_time,"\n",end_time)
  file:close()
  reaper.Main_OnCommand(55769, 0) -- select only track 1
  reaper.Main_OnCommand(40319, 0) -- move edit cursor to end of item
  reaper.Main_OnCommand(41190, 0) -- Change horizontal zoom to default project setting
  reaper.Main_OnCommand(40113, 0) -- View: Toggle track zoom to maximum height
  reaper.Main_OnCommand(53451, 0) -- Xenakios/SWS: Scroll track view to home
  reaper.Main_OnCommand(40507, 0) -- Options: Show overlapping media items in lanes
  reaper.Main_OnCommand(41827, 0) -- View: Show crossfade editor window
end

local function fadeEnd()
  reaper.SetToggleCommandState(1, fade_editor_toggle, 0)
  reaper.RefreshToolbar2(1, fade_editor_toggle) 
  file = io.open(reaper.GetResourcePath().."/Scripts/BethHarmon Scripts/classical/BethHarmon_zoom_level.txt", "r")
  start_time = file:read("*line")
  end_time = file:read("*line")
  file:close()
  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks
  reaper.Main_OnCommand(53801, 0) -- SWS: Vertical zoom to selected tracks
  reaper.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  reaper.Main_OnCommand(40507, 0) -- Options: Show overlapping media items in lanes
  reaper.Main_OnCommand(41827, 0) -- View: Show crossfade editor window
  reaper.GetSet_ArrangeView2(0, true, 0, 0, start_time, end_time)
  os.remove(reaper.GetResourcePath().."/Scripts/BethHarmon Scripts/classical/BethHarmon_zoom_level.txt")
end

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  fade_editor_toggle = reaper.NamedCommandLookup("_RS9c61ac0478c3de96f276137a249e9339ed76fc16")
  state = reaper.GetToggleCommandState(fade_editor_toggle)
  if (state == -1)
  then
  reaper.SetToggleCommandState(1, fade_editor_toggle, 0)
  fadeStart()
  elseif(state ==0)
  then
  fadeStart()
  else
  fadeEnd() 
  end

  reaper.Undo_EndBlock('Classical Crossfade Editor', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

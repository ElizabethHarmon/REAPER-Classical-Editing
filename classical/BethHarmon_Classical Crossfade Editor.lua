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
]]

local r = reaper
local fadeStart, fadeEnd, zoom, view
local fade_editor_toggle = r.NamedCommandLookup("_RS9c61ac0478c3de96f276137a249e9339ed76fc16")
local state = r.GetToggleCommandState(fade_editor_toggle)

function Main()
  r.PreventUIRefresh(1)
  r.Undo_BeginBlock()


  if state == -1 then
    r.SetToggleCommandState(1, fade_editor_toggle, 0)
    fadeStart()
  elseif state == 0 then
    fadeStart()
  else
    fadeEnd()
  end

  r.Undo_EndBlock('Classical Crossfade Editor', 0)
  r.PreventUIRefresh(-1)
  r.UpdateArrange()
  r.UpdateTimeline()
end

function fadeStart()
  r.SetToggleCommandState(1, fade_editor_toggle, 1)
  r.RefreshToolbar2(1, fade_editor_toggle)
  local start_time, end_time = r.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  r.SetExtState("Classical Crossfade Editor", "start_time", start_time, true)
  r.SetExtState("Classical Crossfade Editor", "end_time", end_time, true)
  local select_1 = r.NamedCommandLookup("_SWS_SEL1")
  r.Main_OnCommand(select_1, 0)
  r.Main_OnCommand(40319, 0) -- move edit cursor to end of item
  view()
  zoom()
end

function fadeEnd()
  r.SetToggleCommandState(1, fade_editor_toggle, 0)
  r.RefreshToolbar2(1, fade_editor_toggle)
  view()
  local start_time = r.GetExtState("Classical Crossfade Editor", "start_time")
  local end_time = r.GetExtState("Classical Crossfade Editor", "end_time")
  r.GetSet_ArrangeView2(0, true, 0, 0, start_time, end_time)
end

function zoom()
  local cur_pos = (r.GetPlayState() == 0) and r.GetCursorPosition() or r.GetPlayPosition()
  r.AddProjectMarker2(0, false, cur_pos, 0, "TEMP", 20000, r.ColorToNative(176, 130, 151) | 0x1000000)
  reaper.SetEditCurPos(cur_pos - 4, false, false)
  r.Main_OnCommand(40625, 0) -- Time selection: Set start point
  reaper.SetEditCurPos(cur_pos + 4, false, false)
  r.Main_OnCommand(40626, 0) -- Time selection: Set end point
  local zoom = r.NamedCommandLookup("_SWS_ZOOMSIT")
  r.Main_OnCommand(zoom, 0) -- SWS: Zoom to selected items or time selection
  r.GoToMarker(0, 20000, false)
  r.DeleteProjectMarker(NULL, 20000, false)
  r.Main_OnCommand(1012, 0) -- View: Zoom in horizontal
  r.Main_OnCommand(40635, 0) -- Time selection: Remove (unselect) time selection
end

function view()
  local track1 = r.NamedCommandLookup("_SWS_SEL1")
  r.Main_OnCommand(track1, 0) -- select only track 1
  r.Main_OnCommand(40113, 0) -- View: Toggle track zoom to maximum height
  local scroll_home = r.NamedCommandLookup("_XENAKIOS_TVPAGEHOME")
  r.Main_OnCommand(scroll_home, 0) -- XENAKIOS_TVPAGEHOME
  r.Main_OnCommand(41827, 0) -- View: Show crossfade editor window
  r.Main_OnCommand(40507, 0) -- Options: Offset overlapping media items vertically
end

Main()

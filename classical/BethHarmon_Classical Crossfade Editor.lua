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
local fadeStart, fadeEnd
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
  local file = io.open(r.GetResourcePath() .. "/Scripts/BethHarmon Scripts/classical/BethHarmon_zoom_level.txt", "w")
  if file ~= nil then
    file:write(start_time, "\n", end_time)
    file:close()
  end

  local select_1 = r.NamedCommandLookup("_SWS_SEL1")
  r.Main_OnCommand(select_1, 0)
  r.Main_OnCommand(40319, 0) -- move edit cursor to end of item
  r.Main_OnCommand(41190, 0) -- Change horizontal zoom to default project setting
  r.Main_OnCommand(40113, 0) -- View: Toggle track zoom to maximum height
  local scroll = r.NamedCommandLookup("_XENAKIOS_TVPAGEHOME")
  r.Main_OnCommand(scroll, 0)
  r.Main_OnCommand(40507, 0) -- Options: Show overlapping media items in lanes
  r.Main_OnCommand(41827, 0) -- View: Show crossfade editor window
end

function fadeEnd()
  r.SetToggleCommandState(1, fade_editor_toggle, 0)
  r.RefreshToolbar2(1, fade_editor_toggle)
  local file = io.open(r.GetResourcePath() .. "/Scripts/BethHarmon Scripts/classical/BethHarmon_zoom_level.txt", "r")
  r.Main_OnCommand(40113, 0) -- View: Toggle track zoom to maximum height
  r.Main_OnCommand(40507, 0) -- Options: Show overlapping media items in lanes
  r.Main_OnCommand(41827, 0) -- View: Show crossfade editor window
  if file ~= nil then
    local start_time = file:read("*line")
    local end_time = file:read("*line")
    file:close()
    r.GetSet_ArrangeView2(0, true, 0, 0, start_time, end_time)
  end
  os.remove(r.GetResourcePath() .. "/Scripts/BethHarmon Scripts/classical/BethHarmon_zoom_level.txt")
end

Main()

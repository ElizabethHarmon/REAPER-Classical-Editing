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
local fadeStart, fadeEnd, extend_and_zoom, crossfade
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
  extend_and_zoom()

  local scroll = r.NamedCommandLookup("_XENAKIOS_TVPAGEHOME")
  r.Main_OnCommand(scroll, 0)
  r.Main_OnCommand(40507, 0) -- Options: Show overlapping media items in lanes
  r.Main_OnCommand(41827, 0) -- View: Show crossfade editor window
end

function fadeEnd()
  crossfade()
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
  r.Main_OnCommand(40289, 0) -- Item: Unselect (clear selection of) all items
end

function extend_and_zoom()
  r.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  r.Main_OnCommand(41174, 0) -- Item navigation: Move cursor to end of items
  r.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  r.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  r.Main_OnCommand(40626, 0) -- Time selection: Set end point
  local trim_right = r.NamedCommandLookup("_XENAKIOS_TRIM_RIGHTEDGETO_EDCURSOR")
  r.Main_OnCommand(trim_right, 0) -- XENAKIOS_TRIM_RIGHTEDGETO_EDCURSOR
  r.Main_OnCommand(40841, 0) -- Move edit cursor forward one beat (no seek)
  local select_under = r.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  r.Main_OnCommand(select_under, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  r.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  r.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
  r.Main_OnCommand(40840, 0) -- Move edit cursor back one measure (no seek)
  r.Main_OnCommand(40840, 0) -- Move edit cursor back one measure (no seek)
  r.Main_OnCommand(40625, 0) -- Time selection: Set start point
  local trim_left = r.NamedCommandLookup("_XENAKIOS_TRIM_LEFTEDGETO_EDCURSOR")
  r.Main_OnCommand(trim_left, 0) -- XENAKIOS_TRIM_LEFTEDGETO_EDCURSOR
  r.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  r.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  r.Main_OnCommand(40289, 0) -- Item: Unselect (clear selection of) all items
  local zoom = r.NamedCommandLookup("_SWS_ZOOMSIT")
  r.Main_OnCommand(zoom, 0) -- SWS: Zoom to selected items or time selection
  r.Main_OnCommand(1012, 0) -- View: Zoom in horizontal
  r.Main_OnCommand(40635, 0) -- Time selection: Remove (unselect) time selection
  r.NamedCommandLookup("_XENAKIOS_TVPAGEHOME")
  r.Main_OnCommand(53451, 0) -- XENAKIOS_TVPAGEHOME

  r.Main_OnCommand(40113, 0) -- View: Toggle track zoom to maximum height
end

function crossfade()
  local select_items = r.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  r.Main_OnCommand(select_items, 0) -- Xenakios/SWS: Select items under edit cursor on selected tracks
  r.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  local fade_left = r.NamedCommandLookup("_SWS_MOVECURFADELEFT")
  r.Main_OnCommand(fade_left, 0) -- SWS: Move cursor left by default fade length
  r.Main_OnCommand(40625, 0) -- Time selection: Set start point
  local fade_right = r.NamedCommandLookup("_SWS_MOVECURFADERIGHT")
  r.Main_OnCommand(fade_right, 0) -- SWS: Move cursor right by default fade length
  r.Main_OnCommand(40626, 0) -- Time selection: Set end point
  r.Main_OnCommand(40717, 0) -- Item: Select all items in current time selection
  r.Main_OnCommand(40916, 0) -- Item: Crossfade items within time selection
  r.Main_OnCommand(40635, 0) -- Time selection: Remove time selection
end

Main()


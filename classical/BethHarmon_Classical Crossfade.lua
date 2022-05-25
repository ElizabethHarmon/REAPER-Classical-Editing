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

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  select_items = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  reaper.Main_OnCommand(select_items, 0) -- Xenakios/SWS: Select items under edit cursor on selected tracks
  reaper.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  fade_left = reaper.NamedCommandLookup("_SWS_MOVECURFADELEFT")
  reaper.Main_OnCommand(fade_left, 0) -- SWS: Move cursor left by default fade length
  reaper.Main_OnCommand(40625, 0) -- Time selection: Set start point
  fade_right = reaper.NamedCommandLookup("_SWS_MOVECURFADERIGHT")
  reaper.Main_OnCommand(fade_right, 0) -- SWS: Move cursor right by default fade length
  reaper.Main_OnCommand(40626, 0) -- Time selection: Set end point
  reaper.Main_OnCommand(40717, 0) -- Item: Select all items in current time selection
  reaper.Main_OnCommand(40916, 0) -- Item: Crossfade items within time selection
  reaper.Main_OnCommand(40635, 0) -- Time selection: Remove time selection

  reaper.Undo_EndBlock('Classical Crossfade', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

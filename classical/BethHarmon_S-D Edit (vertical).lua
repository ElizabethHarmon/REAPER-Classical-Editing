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

  reaper.Main_OnCommand(54499, 0) -- BR_FOCUS_ARRANGE_WND
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  reaper.GoToMarker(0, 102, false)
  reaper.Main_OnCommand(40625, 0) -- Time Selection: Set start point
  reaper.GoToMarker(0, 103, false)
  reaper.Main_OnCommand(40626, 0) -- Time Selection: Set end point
  reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
  reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
  reaper.Main_OnCommand(41383, 0) -- Edit: Copy items/tracks/envelope points (depending on focus) within time selection, if any (smart copy)
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  reaper.Main_OnCommand(40939, 0) -- Track: Select track 01
  reaper.GoToMarker(0, 100, false)
  reaper.Main_OnCommand(40625, 0) -- Time Selection: Set start point
  reaper.GoToMarker(0, 101, false)
  reaper.Main_OnCommand(40626, 0) -- Time Selection: Set end point
  reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
  reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
  reaper.Main_OnCommand(40630, 0) -- XENAKIOS_TSADEL
  reaper.Main_OnCommand(53460, 0) -- Go to start of time selection
  reaper.Main_OnCommand(53573, 0) -- SWS_AWPASTE
  reaper.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
  reaper.Main_OnCommand(53616, 0) -- SWS_MOVECURFADELEFT
  reaper.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
  reaper.Main_OnCommand(40417, 0) -- Item Navigation: Select and move to next item
  reaper.Main_OnCommand(53616, 0) -- SWS_MOVECURFADELEFT
  reaper.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
  reaper.Main_OnCommand(40020, 0) -- Time Selection: Remove time selection and loop point selection
  reaper.DeleteProjectMarker(NULL, 100, false)
  reaper.DeleteProjectMarker(NULL, 101, false)
  reaper.DeleteProjectMarker(NULL, 102, false)
  reaper.DeleteProjectMarker(NULL, 103, false)
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items

  reaper.Undo_EndBlock('VERTICAL One-Window S-D Editing', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

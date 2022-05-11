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

  reaper.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  reaper.Main_OnCommand(41174, 0) -- Item navigation: Move cursor to end of items
  reaper.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  reaper.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  reaper.Main_OnCommand(53287, 0) -- XENAKIOS_TRIM_RIGHTEDGETO_EDCURSOR
  reaper.Main_OnCommand(40841, 0) -- Move edit cursor forward one beat (no seek)
  reaper.Main_OnCommand(53459, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  reaper.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  reaper.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
  reaper.Main_OnCommand(40840, 0) -- Move edit cursor back one measure (no seek)
  reaper.Main_OnCommand(40840, 0) -- Move edit cursor back one measure (no seek)
  reaper.Main_OnCommand(53286, 0) -- XENAKIOS_TRIM_LEFTEDGETO_EDCURSOR
  reaper.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  reaper.Main_OnCommand(40839, 0) -- Move edit cursor forward one measure (no seek)
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect (clear selection of) all items
  reaper.Main_OnCommand(53451, 0) -- XENAKIOS_TVPAGEHOME

  reaper.Undo_EndBlock('Edit Classical Crossfade', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

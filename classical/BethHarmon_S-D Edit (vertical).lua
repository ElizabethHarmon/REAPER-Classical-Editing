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

  reaper.Main_OnCommand(54499, 0)
  reaper.Main_OnCommand(40289, 0)
  reaper.GoToMarker(0, 102, false)
  reaper.Main_OnCommand(40625, 0)
  reaper.GoToMarker(0, 103, false)
  reaper.Main_OnCommand(40626, 0)
  reaper.Main_OnCommand(40718, 0)
  reaper.Main_OnCommand(40034, 0)
  reaper.Main_OnCommand(41383, 0)
  reaper.Main_OnCommand(40289, 0)
  reaper.Main_OnCommand(40939, 0)
  reaper.GoToMarker(0, 100, false)
  reaper.Main_OnCommand(40625, 0)
  reaper.GoToMarker(0, 101, false)
  reaper.Main_OnCommand(40626, 0)
  reaper.Main_OnCommand(40718, 0)
  reaper.Main_OnCommand(40034, 0)
  reaper.Main_OnCommand(40630, 0)
  reaper.Main_OnCommand(53460, 0)
  reaper.Main_OnCommand(53573, 0)
  reaper.Main_OnCommand(41173, 0)
  reaper.Main_OnCommand(53616, 0)
  reaper.Main_OnCommand(41305, 0)
  reaper.Main_OnCommand(40417, 0)
  reaper.Main_OnCommand(53616, 0)
  reaper.Main_OnCommand(41305, 0)
  reaper.Main_OnCommand(40020, 0)
  reaper.DeleteProjectMarker(NULL, 100, false)
  reaper.DeleteProjectMarker(NULL, 101, false)
  reaper.DeleteProjectMarker(NULL, 102, false)
  reaper.DeleteProjectMarker(NULL, 103, false)
  reaper.Main_OnCommand(40289, 0)

  reaper.Undo_EndBlock('VERTICAL One-Window S-D Editing', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

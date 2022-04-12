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

  reaper.Main_OnCommand(53459, 0)
  reaper.Main_OnCommand(40297, 0)
  reaper.Main_OnCommand(53616, 0)
  reaper.Main_OnCommand(40625, 0)
  reaper.Main_OnCommand(53617, 0)
  reaper.Main_OnCommand(40626, 0)
  reaper.Main_OnCommand(40717, 0)
  reaper.Main_OnCommand(40916, 0)
  reaper.Main_OnCommand(40635, 0)

  reaper.Undo_EndBlock('Classical Crossfade', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

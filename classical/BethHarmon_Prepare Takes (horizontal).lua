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

local function color()
  reaper.Main_OnCommand(40706, 0)
end

local function group()
  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks
  reaper.Main_OnCommand(40417, 0) -- Item navigation: Select and move to next item
  reaper.Main_OnCommand(53459, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  reaper.Main_OnCommand(40032, 0) -- Item grouping: Group items
end

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  length = reaper.GetProjectLength(0)
  num_of_tracks = reaper.CountTracks(0)
  last_track = reaper.GetTrack(0, num_of_tracks - 1)
  new_item = reaper.AddMediaItemToTrack(last_track)
  reaper.SetMediaItemPosition(new_item, length + 1, false)
  num_of_items = reaper.CountMediaItems(0)
  last_item = reaper.GetMediaItem(0, num_of_items-1)
  reaper.SetEditCurPos(0, false, false)
  
  while (reaper.IsMediaItemSelected(last_item) == false)
  do
  group()
  color()
  end
  
  reaper.DeleteTrackMediaItem(last_track, last_item)
  reaper.SelectAllMediaItems(0, false)
  reaper.Main_OnCommand(40297, 0)
  reaper.SetEditCurPos(0, false, false)
  reaper.Undo_EndBlock('Prepare Takes for Classical Editing', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

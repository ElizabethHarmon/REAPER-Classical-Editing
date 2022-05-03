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
  reaper.Main_OnCommand(40042, 0) -- Transport: Go to start of project
  reaper.Main_OnCommand(53773, 0) -- SWS_SELCHILDREN2
  reaper.Main_OnCommand(40421, 0) -- Item: Select all items in track
  reaper.Main_OnCommand(40706, 0) -- Item: Set to one random color
end

local function group()
track = reaper.GetSelectedTrack(0, 0)
item = reaper.AddMediaItemToTrack(track)
reaper.SetMediaItemPosition(item, length + 1, false)

  while (reaper.IsMediaItemSelected(item) == false)
  do
  reaper.Main_OnCommand(40417, 0) -- Item navigation: Select and move to next item
  reaper.Main_OnCommand(53459, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  reaper.Main_OnCommand(40032, 0) -- Item grouping: Group items
  end
  reaper.DeleteTrackMediaItem(track, item)
end

local function main()
  reaper.Undo_BeginBlock()
  -- select all folders and count them
  select_all_folders = reaper.NamedCommandLookup("_SWS_SELALLPARENTS")
  reaper.Main_OnCommand(select_all_folders, 0)
  num_of_folders = reaper.CountSelectedTracks(0)
  length = reaper.GetProjectLength(0)

-- select track 1
  
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  for i = 1,num_of_folders,1 
  do
  color()
  group()
  next_folder = reaper.NamedCommandLookup("_SWS_SELNEXTFOLDER")
  reaper.Main_OnCommand(next_folder, 0)
  end
  reaper.SelectAllMediaItems(0, false)
  reaper.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  reaper.SetEditCurPos(0, false, false)
  reaper.Undo_EndBlock('VERTICAL Prepare Takes for Classical Editing', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end


main()



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

local function shift()
  reaper.Main_OnCommand(40182, 0) -- select all items
  nudge_right = reaper.NamedCommandLookup("_SWS_NUDGESAMPLERIGHT")
  reaper.Main_OnCommand(nudge_right, 0) -- shift items by 1 sample to the right
  reaper.Main_OnCommand(40289, 0) -- unselect all items
end

local function horizontal_color()
  reaper.Main_OnCommand(40706, 0)
end

local function vertical_color()
  reaper.Main_OnCommand(40042, 0) -- Transport: Go to start of project
  select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
  reaper.Main_OnCommand(select_children, 0) -- SWS_SELCHILDREN2
  reaper.Main_OnCommand(40421, 0) -- Item: Select all items in track
  reaper.Main_OnCommand(40706, 0) -- Item: Set to one random color
end

local function horizontal_group()
  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks
  reaper.Main_OnCommand(40417, 0) -- Item navigation: Select and move to next item
  select_under = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  reaper.Main_OnCommand(select_under, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  reaper.Main_OnCommand(40032, 0) -- Item grouping: Group items
end

local function vertical_group()
track = reaper.GetSelectedTrack(0, 0)
item = reaper.AddMediaItemToTrack(track)
reaper.SetMediaItemPosition(item, length + 1, false)

  while (reaper.IsMediaItemSelected(item) == false)
  do
  reaper.Main_OnCommand(40417, 0) -- Item navigation: Select and move to next item
  select_under = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  reaper.Main_OnCommand(select_under, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  reaper.Main_OnCommand(40032, 0) -- Item grouping: Group items
  end
  reaper.DeleteTrackMediaItem(track, item)
end

local function horizontal()
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
  horizontal_group()
  horizontal_color()
  end
  
  reaper.DeleteTrackMediaItem(last_track, last_item)
  reaper.SelectAllMediaItems(0, false)
  reaper.Main_OnCommand(40297, 0)
  reaper.SetEditCurPos(0, false, false)
end

local function vertical()
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
  vertical_color()
  vertical_group()
  next_folder = reaper.NamedCommandLookup("_SWS_SELNEXTFOLDER")
  reaper.Main_OnCommand(next_folder, 0)
  end
  reaper.SelectAllMediaItems(0, false)
  reaper.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  reaper.SetEditCurPos(0, false, false)
end

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  total_tracks = reaper.CountTracks(0)
  folders = 0
  for i = 0, total_tracks - 1, 1
  do
    track = reaper.GetTrack(0, i) 
    if (reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH") == 1.0)
    then
    folders = folders + 1
    end
  end
  
  first_item = reaper.GetMediaItem(0, 0)
  position = reaper.GetMediaItemInfo_Value(first_item, "D_POSITION")
  if (position == 0.0)
  then
  shift()
  end
  
  if (folders == 0 or folders == 1)
  then
  horizontal()
  else
  vertical()
  end
  reaper.Main_OnCommand(40042, 0) -- go to start of project
  reaper.Main_OnCommand(40939, 0) -- select track 01
  reaper.Undo_EndBlock('Prepare Takes', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

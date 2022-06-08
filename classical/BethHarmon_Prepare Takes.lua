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
local horizontal, horizontal_color, horizontal_group, shift, vertical, vertical_color, vertical_group

function Main()
  r.PreventUIRefresh(1)
  r.Undo_BeginBlock()
  local total_tracks = r.CountTracks(0)
  local folders = 0
  for i = 0, total_tracks - 1, 1 do
    track = r.GetTrack(0, i)
    if r.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH") == 1.0 then
      folders = folders + 1
    end
  end

  local first_item = r.GetMediaItem(0, 0)
  local position = r.GetMediaItemInfo_Value(first_item, "D_POSITION")
  if position == 0.0 then
    shift()
  end

  if folders == 0 or folders == 1 then
    horizontal()
  else
    vertical()
  end
  r.Main_OnCommand(40042, 0) -- go to start of project
  r.Main_OnCommand(40939, 0) -- select track 01
  r.Undo_EndBlock('Prepare Takes', 0)
  r.PreventUIRefresh(-1)
  r.UpdateArrange()
  r.UpdateTimeline()
end

function shift()
  r.Main_OnCommand(40182, 0) -- select all items
  local nudge_right = r.NamedCommandLookup("_SWS_NUDGESAMPLERIGHT")
  r.Main_OnCommand(nudge_right, 0) -- shift items by 1 sample to the right
  r.Main_OnCommand(40289, 0) -- unselect all items
end

function horizontal_color()
  r.Main_OnCommand(40706, 0)
end

function vertical_color()
  r.Main_OnCommand(40042, 0) -- Transport: Go to start of project
  local select_children = r.NamedCommandLookup("_SWS_SELCHILDREN2")
  r.Main_OnCommand(select_children, 0) -- SWS_SELCHILDREN2
  r.Main_OnCommand(40421, 0) -- Item: Select all items in track
  r.Main_OnCommand(40706, 0) -- Item: Set to one random color
end

local function horizontal_group()
  r.Main_OnCommand(40296, 0) -- Track: Select all tracks
  r.Main_OnCommand(40417, 0) -- Item navigation: Select and move to next item
  local select_under = r.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  r.Main_OnCommand(select_under, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
  r.Main_OnCommand(40032, 0) -- Item grouping: Group items
end

function vertical_group()
  track = r.GetSelectedTrack(0, 0)
  local item = r.AddMediaItemToTrack(track)
  r.SetMediaItemPosition(item, length + 1, false)

  while r.IsMediaItemSelected(item) == false do
    r.Main_OnCommand(40417, 0) -- Item navigation: Select and move to next item
    local select_under = r.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
    r.Main_OnCommand(select_under, 0) -- XENAKIOS_SELITEMSUNDEDCURSELTX
    r.Main_OnCommand(40032, 0) -- Item grouping: Group items
  end
  r.DeleteTrackMediaItem(track, item)
end

function horizontal()
  length = r.GetProjectLength(0)
  local num_of_tracks = r.CountTracks(0)
  local last_track = r.GetTrack(0, num_of_tracks - 1)
  local new_item = r.AddMediaItemToTrack(last_track)
  r.SetMediaItemPosition(new_item, length + 1, false)
  local num_of_items = r.CountMediaItems(0)
  local last_item = r.GetMediaItem(0, num_of_items - 1)
  r.SetEditCurPos(0, false, false)

  while r.IsMediaItemSelected(last_item) == false do
    horizontal_group()
    horizontal_color()
  end

  r.DeleteTrackMediaItem(last_track, last_item)
  r.SelectAllMediaItems(0, false)
  r.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  r.SetEditCurPos(0, false, false)
end

function vertical()
  r.Undo_BeginBlock()
  local select_all_folders = r.NamedCommandLookup("_SWS_SELALLPARENTS")
  r.Main_OnCommand(select_all_folders, 0) -- select all folders
  local num_of_folders = r.CountSelectedTracks(0)
  length = r.GetProjectLength(0)
  local first_track = r.GetTrack(0, 0)
  r.SetOnlyTrackSelected(first_track)
  for i = 1, num_of_folders, 1 do
    vertical_color()
    vertical_group()
    local next_folder = r.NamedCommandLookup("_SWS_SELNEXTFOLDER")
    r.Main_OnCommand(next_folder, 0) -- select next folder
  end
  r.SelectAllMediaItems(0, false)
  r.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  r.SetEditCurPos(0, false, false)
end

Main()

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

local function create_destination_group()
  boolean, num = reaper.GetUserInputs("Create Destination & Source Groups", 1, "How many tracks per group?", 10)

  if (boolean == true) then
    for i=1, tonumber(num), 1 do
      reaper.InsertTrackAtIndex(0, true)
    end
    for i=0, tonumber(num)-1, 1 do
      tr = reaper.GetTrack(0, i)
      reaper.SetTrackSelected(tr, 1)
    end
    make_folder = reaper.NamedCommandLookup("_SWS_MAKEFOLDER")
    reaper.Main_OnCommand(make_folder, 0) -- make folder from tracks
    for i=0, tonumber(num)-1, 1 do
      tr = reaper.GetTrack(0, i)
      reaper.SetTrackSelected(tr, 0)
    end
  end
end

local function solo()
    track = reaper.GetSelectedTrack(0, 0)
    reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 1)

  for i = 0, reaper.CountTracks(0)-1, 1
  do
    track = reaper.GetTrack(0, i)
    if reaper.IsTrackSelected(track) == false
    then
      reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
    i = i + 1
    end
  end
end

local function mixer()
  for i = 0, reaper.CountTracks(0)-1, 1
  do
    tr = reaper.GetTrack(0, i)    
    if reaper.IsTrackSelected(tr) then 
      reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINMIXER',1)
    else 
      reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINMIXER',0)
    end
  end
end

local function folder_check()
  folders = 0
  total_tracks = reaper.CountTracks(0)
  for i=0, total_tracks - 1, 1 do
    tr = reaper.GetTrack(0, i)
    if (reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH") == 1) then
      folders = folders + 1
    end
  end
  return folders
end

local function sync_routing_and_fx()
  ans = reaper.ShowMessageBox("This will sync your source group routing and fx \nto match that of the destination group. Continue?", "Sync Source & Destination", 4)
  
  if (ans == 6) then
    local first_track = reaper.GetTrack(0,0)
    reaper.SetOnlyTrackSelected(first_track)
    collapse = reaper.NamedCommandLookup("_SWS_COLLAPSE")
    reaper.Main_OnCommand(collapse, 0) -- collapse folder
    
    for i=1, folder_check() - 1, 1 do
      copy_folder_routing = reaper.NamedCommandLookup("_S&M_COPYSNDRCV2")
      reaper.Main_OnCommand(copy_folder_routing, 0) -- copy folder track routing
      select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
      reaper.Main_OnCommand(select_children, 0) --SWS_SELCHILDREN2
      copy = reaper.NamedCommandLookup("_S&M_COPYSNDRCV1") -- SWS/S&M: Copy selected tracks (with routing)
      reaper.Main_OnCommand(copy, 0)
      --reaper.NamedCommandLookup("")
      --reaper.Main_OnCommand(53426, 0)
      paste = reaper.NamedCommandLookup("_SWS_AWPASTE")
      reaper.Main_OnCommand(paste, 0) -- SWS_AWPASTE
      reaper.Main_OnCommand(40421, 0) -- Item: Select all items in track
      delete_items = reaper.NamedCommandLookup("_SWS_DELALLITEMS")
      reaper.Main_OnCommand(delete_items, 0)
      
      unselect_children = reaper.NamedCommandLookup("_SWS_UNSELCHILDREN")
      reaper.Main_OnCommand(unselect_children, 0) -- unselect children
      paste_folder_routing = reaper.NamedCommandLookup("_S&M_PASTSNDRCV2")
      reaper.Main_OnCommand(paste_folder_routing, 0) -- paste folder track routing
      
      reaper.Main_OnCommand(40042, 0) --move edit cursor to start
      next_folder = reaper.NamedCommandLookup("_SWS_SELNEXTFOLDER")
      reaper.Main_OnCommand(next_folder, 0) --select next folder
      
      --Account for empty folders
      length = reaper.GetProjectLength(0)
      old_tr = reaper.GetSelectedTrack(0, 0)
      new_item = reaper.AddMediaItemToTrack(old_tr)
      reaper.SetMediaItemPosition(new_item, length + 1, false)
      
      select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
      reaper.Main_OnCommand(select_children, 0) --SWS_SELCHILDREN2
      reaper.Main_OnCommand(40421, 0) --select all items on track
      
      selected_tracks = reaper.CountSelectedTracks(0)
      for i=1, selected_tracks, 1 do
        reaper.Main_OnCommand(40117, 0) -- Move items up to previous folder
      end
      reaper.Main_OnCommand(40005, 0) --delete selected tracks
      select_only = reaper.NamedCommandLookup("_SWS_SELTRKWITEM")
      reaper.Main_OnCommand(select_only, 0) --SWS: Select only track(s) with selected item(s)
      dup_tr = reaper.GetSelectedTrack(0, 0)
      tr_items = reaper.CountTrackMediaItems(dup_tr)
      last_item = reaper.GetTrackMediaItem(dup_tr, tr_items - 1)
      reaper.DeleteTrackMediaItem(dup_tr, last_item)
      reaper.Main_OnCommand(40289, 0) -- Unselect all items
    end
    
    local first_track = reaper.GetTrack(0,0)
    reaper.SetOnlyTrackSelected(first_track)
    solo()
    select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
    reaper.Main_OnCommand(select_children, 0) -- SWS: Select children of selected folder track(s)
    mixer()
    unselect_children = reaper.NamedCommandLookup("_SWS_UNSELCHILDREN")
    reaper.Main_OnCommand(unselect_children, 0) -- SWS: Unselect children of selected folder track(s)
  end
end

function create_source_groups()
  local total_tracks = reaper.CountTracks(0)
  i = 0
  while (i < total_tracks)
  do
   local track = reaper.GetTrack(0, i)
   reaper.GetSetTrackGroupMembership(track,"VOLUME_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"VOLUME_FOLLOW",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"PAN_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"PAN_FOLLOW",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"POLARITY_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"POLARITY_FOLLOW",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"AUTOMODE_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"AUTOMODE_FOLLOW",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"MUTE_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"MUTE_FOLLOW",2^i,2^i)
   i = i + 1
  end
  local first_track = reaper.GetTrack(0,0)
  reaper.SetOnlyTrackSelected(first_track)
  i=0
  while (i < 6)
  do
    select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
    reaper.Main_OnCommand(select_children, 0) -- SWS: Select children of selected folder track(s)
    copy = reaper.NamedCommandLookup("_S&M_COPYSNDRCV1") -- SWS/S&M: Copy selected tracks (with routing)
    reaper.Main_OnCommand(copy, 0)
    --reaper.Main_OnCommand(53426, 0)
    paste = reaper.NamedCommandLookup("_SWS_AWPASTE")
    reaper.Main_OnCommand(paste, 0) -- SWS_AWPASTE
    reaper.Main_OnCommand(40421, 0) -- Item: Select all items in track
    delete_items = reaper.NamedCommandLookup("_SWS_DELALLITEMS")
    reaper.Main_OnCommand(delete_items, 0)
    i = i+1
  end
  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks
  collapse = reaper.NamedCommandLookup("_SWS_COLLAPSE")
  reaper.Main_OnCommand(collapse, 0) -- collapse folder
  reaper.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  reaper.Main_OnCommand(40939, 0) -- Track: Select track 01
  select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
  reaper.Main_OnCommand(select_children, 0) -- SWS: Select children of selected folder track(s)

  solo()
    select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
    reaper.Main_OnCommand(select_children, 0) -- SWS: Select children of selected folder track(s)
  mixer()
    unselect_children = reaper.NamedCommandLookup("_SWS_UNSELCHILDREN")
    reaper.Main_OnCommand(unselect_children, 0) -- SWS: Unselect children of selected folder track(s)
  
  reaper.Main_OnCommand(40297, 0) -- Track: Unselect (clear selection of) all tracks
  razor_edit = reaper.NamedCommandLookup("_RS2a78b865dca5f05176044b6d8801f19e4d7af562")
  reaper.Main_OnCommand(razor_edit, 0)
end

function main()

  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  if (reaper.CountTracks(0) == 0) then
  
  create_destination_group()
    if (folder_check() == 1 ) then
      create_source_groups()
    end
  
  elseif (folder_check() > 1 ) then
    sync_routing_and_fx()
  elseif (folder_check() == 1) then
  create_source_groups()
  else
  reaper.ShowMessageBox("In order to use this script either:\n1. Run on an empty project\n2. Run with one existing folder\n3. Run on multiple existing folders to sync routing/fx", "Create Source Groups", 0)
  end  
    reaper.Undo_EndBlock('Create Source Groups', 0)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
    reaper.UpdateTimeline()
end

main()

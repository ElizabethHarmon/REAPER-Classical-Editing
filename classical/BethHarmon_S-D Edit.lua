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
local copy_source, create_crossfades, delete_sd_markers, lock_items
local markers, select_matching_folder, split_at_dest_in, unlock_items, ripple_lock_mode
local add_temp_marker, temp_to_dest_in

function Main()
  r.PreventUIRefresh(1)
  r.Undo_BeginBlock()
  local replace_toggle = r.NamedCommandLookup("_RSa7436efacaf0efb8ba704fdec38e3caed3499a22")
  local dest_in, dest_out, source_count = markers()
  ripple_lock_mode()
  if r.GetToggleCommandState(replace_toggle) == 1 and dest_in == 1 and dest_out == 0 and source_count == 2 then
    lock_items()
    local sel_length = copy_source()
    split_at_dest_in()
    r.MoveEditCursor(sel_length, true)
    r.Main_OnCommand(40309, 0) -- Toggle ripple editing per-track
    r.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
    r.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
    r.Main_OnCommand(40630, 0) -- Go to start of time selection
    local delete = r.NamedCommandLookup("_XENAKIOS_TSADEL")
    r.Main_OnCommand(delete, 0) -- Adaptive Delete
    r.Main_OnCommand(42398, 0) -- Item: Paste items/tracks
    r.Main_OnCommand(40310, 0) -- Toggle ripple editing per-track
    unlock_items()
    create_crossfades()
    delete_sd_markers()
    r.Main_OnCommand(40289, 0) -- Item: Unselect all items
    temp_to_dest_in(dest_out)
  elseif dest_in == 1 and source_count == 2 then
    lock_items()
    copy_source()
    split_at_dest_in()
    r.Main_OnCommand(40625, 0) -- Time Selection: Set start point
    r.GoToMarker(0, 101, false)
    r.Main_OnCommand(40626, 0) -- Time Selection: Set end point
    r.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
    r.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
    r.Main_OnCommand(40630, 0) -- Go to start of time selection
    local delete = r.NamedCommandLookup("_XENAKIOS_TSADEL")
    r.Main_OnCommand(delete, 0) -- Adaptive Delete
    local paste = r.NamedCommandLookup("_SWS_AWPASTE")
    r.Main_OnCommand(paste, 0) -- SWS_AWPASTE
    unlock_items()
    create_crossfades()
    delete_sd_markers()
    r.Main_OnCommand(40289, 0) -- Item: Unselect all items
    r.Main_OnCommand(40310, 0) -- Toggle ripple editing per-track
    temp_to_dest_in(dest_out)
  else
    r.ShowMessageBox("Please add at least 3 valid source-destination markers: \n 3-point edit: DEST-IN, SOURCE-IN and SOURCE-OUT \n 4-point edit: DEST-IN, DEST-OUT, SOURCE-IN and SOURCE-OUT"
      , "Source-Destination Edit", 0)
    return
  end

  r.Undo_EndBlock('VERTICAL One-Window S-D Editing', 0)
  r.PreventUIRefresh(-1)
  r.UpdateArrange()
  r.UpdateTimeline()
end

function markers()
  local retval, num_markers, num_regions = r.CountProjectMarkers(0)
  local source_count = 0
  local dest_in = 0
  local dest_out = 0
  for i = 0, num_markers + num_regions - 1, 1 do
    local retval, isrgn, pos, rgnend, label, markrgnindexnumber = r.EnumProjectMarkers(i)
    if label == "DEST-IN" then
      dest_in = 1
    elseif label == "DEST-OUT" then
      dest_out = 1
    elseif label == string.match(label, "%d+:SOURCE[-]IN") or string.match(label, "%d+:SOURCE[-]OUT") then
      source_count = source_count + 1
    end
  end
  return dest_in, dest_out, source_count
end

function select_matching_folder()
  local cursor = r.GetCursorPosition()
  local marker_id, _ = r.GetLastMarkerAndCurRegion(0, cursor)
  local _, _, _, _, label, _, _ = r.EnumProjectMarkers3(0, marker_id)
  local folder_number = tonumber(string.match(label, "(%d*):SOURCE*"))
  for i = 0, r.CountTracks(0) - 1, 1 do
    track = r.GetTrack(0, i)
    if r.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") == folder_number then
      r.SetOnlyTrackSelected(track)
      break
    end
  end
end

function copy_source()
  local focus = r.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND")
  r.Main_OnCommand(focus, 0) -- BR_FOCUS_ARRANGE_WND
  r.Main_OnCommand(40311, 0) -- Set ripple-all-tracks
  r.Main_OnCommand(40289, 0) -- Item: Unselect all items
  r.GoToMarker(0, 102, false)
  select_matching_folder()
  r.Main_OnCommand(40625, 0) -- Time Selection: Set start point
  r.GoToMarker(0, 103, false)
  r.Main_OnCommand(40626, 0) -- Time Selection: Set end point
  local start_time, end_time = r.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  local sel_length = end_time - start_time
  r.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
  r.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
  r.Main_OnCommand(41383, 0) -- Edit: Copy items/tracks/envelope points (depending on focus) within time selection, if any (smart copy)
  r.Main_OnCommand(40289, 0) -- Item: Unselect all items
  return sel_length
end

function split_at_dest_in()
  r.Main_OnCommand(40927, 0) -- Options: Enable auto-crossfade on split
  r.Main_OnCommand(40939, 0) -- Track: Select track 01
  r.GoToMarker(0, 100, false)
  local select_under = r.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  r.Main_OnCommand(select_under, 0) -- Xenakios/SWS: Select items under edit cursor on selected tracks
  r.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  r.Main_OnCommand(40912, 0) -- Options: Toggle auto-crossfade on split (OFF)
  r.Main_OnCommand(40186, 0) -- Item: Split items at edit or play cursor (ignoring grouping)
  r.Main_OnCommand(40289, 0) -- Item: Unselect all items
end

function create_crossfades()
  r.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
  local fade_left = r.NamedCommandLookup("_SWS_MOVECURFADELEFT")
  r.Main_OnCommand(fade_left, 0) -- SWS_MOVECURFADELEFT
  r.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
  add_temp_marker()
  r.Main_OnCommand(40417, 0) -- Item Navigation: Select and move to next item
  r.Main_OnCommand(fade_left, 0) -- SWS_MOVECURFADELEFT
  r.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
  r.Main_OnCommand(40912, 0) -- Options: Toggle auto-crossfade on split (OFF) 
  r.Main_OnCommand(40020, 0) -- Time Selection: Remove time selection and loop point selection
end

function delete_sd_markers()
  r.DeleteProjectMarker(NULL, 100, false)
  r.DeleteProjectMarker(NULL, 101, false)
  r.DeleteProjectMarker(NULL, 102, false)
  r.DeleteProjectMarker(NULL, 103, false)
end

function lock_items()
  r.Main_OnCommand(40182, 0) -- select all items
  r.Main_OnCommand(40939, 0) -- select track 01
  local select_children = r.NamedCommandLookup("_SWS_SELCHILDREN2")
  r.Main_OnCommand(select_children, 0) -- select children of track 1
  local unselect_items = r.NamedCommandLookup("_SWS_UNSELONTRACKS")
  r.Main_OnCommand(unselect_items, 0) -- unselect items in first folder
  local total_items = r.CountSelectedMediaItems(0)
  for i = 0, total_items - 1, 1 do
    local item = r.GetSelectedMediaItem(0, i)
    r.SetMediaItemInfo_Value(item, "C_LOCK", 1)
  end
end

function unlock_items()
  local total_items = r.CountMediaItems(0)
  for i = 0, total_items - 1, 1 do
    local item = r.GetMediaItem(0, i)
    r.SetMediaItemInfo_Value(item, "C_LOCK", 0)
  end
end

function ripple_lock_mode()
  local _, original_ripple_lock_mode = reaper.get_config_var_string("ripplelockmode")
  original_ripple_lock_mode = tonumber(original_ripple_lock_mode)
  if original_ripple_lock_mode ~= 2 then
    reaper.SNM_SetIntConfigVar("ripplelockmode", 2)
  end
end

function add_temp_marker()
  r.Main_OnCommand(41174, 0) -- Item navigation: Move cursor to end of items
  local cur_pos = (r.GetPlayState() == 0) and r.GetCursorPosition() or r.GetPlayPosition()
  r.AddProjectMarker2(0, false, cur_pos, 0, "TEMP", 10000, r.ColorToNative(176, 130, 151) | 0x1000000)
  r.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items

end

function temp_to_dest_in(dest_out)
  r.GoToMarker(0, 10000, false)
  r.DeleteProjectMarker(NULL, 10000, false)
  if dest_out == 0 then
    local cur_pos = (r.GetPlayState() == 0) and r.GetCursorPosition() or r.GetPlayPosition()
    r.AddProjectMarker2(0, false, cur_pos, 0, "DEST-IN", 100, r.ColorToNative(22, 141, 195) | 0x1000000)
  end
end

Main()

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

local function markers()
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  source_count = 0
  dest_in = 0
  dest_out = 0
  for i = 0, num_markers + num_regions - 1, 1
  do
    retval, isrgn, pos, rgnend, label, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if (label == "DEST-IN")
    then
      dest_in = 1
    elseif (label == "DEST-OUT")
    then
      dest_out = 1
    elseif (label == "SOURCE-IN" or label == "SOURCE-OUT")
    then
      source_count = source_count + 1
    end
  end
  return dest_in, dest_out, source_count
end

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  focus = reaper.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND")
  reaper.Main_OnCommand(focus, 0) -- BR_FOCUS_ARRANGE_WND
  reaper.Main_OnCommand(40310, 0) -- Set ripple per-track
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  reaper.GoToMarker(0, 102, false)
  reaper.Main_OnCommand(40625, 0) -- Time Selection: Set start point
  reaper.GoToMarker(0, 103, false)
  reaper.Main_OnCommand(40626, 0) -- Time Selection: Set end point
  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  sel_length = end_time - start_time
  reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
  reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
  reaper.Main_OnCommand(41383, 0) -- Edit: Copy items/tracks/envelope points (depending on focus) within time selection, if any (smart copy)
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  reaper.Main_OnCommand(40939, 0) -- Track: Select track 01
  reaper.GoToMarker(0, 100, false)
  select_under = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  reaper.Main_OnCommand(select_under, 0) -- Xenakios/SWS: Select items under edit cursor on selected tracks
  reaper.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  reaper.Main_OnCommand(40912, 0) -- Options: Toggle auto-crossfade on split (OFF)
  reaper.Main_OnCommand(40186, 0) -- Item: Split items at edit or play cursor (ignoring grouping)
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  
  replace_toggle = reaper.NamedCommandLookup("_RSa7436efacaf0efb8ba704fdec38e3caed3499a22")
  dest_in, dest_out, source_count = markers() 
  if (reaper.GetToggleCommandState(replace_toggle) == 1 and dest_in == 1 and dest_out == 0 and source_count == 2)
  then
    reaper.MoveEditCursor(sel_length, true)
    reaper.Main_OnCommand(41990, 0) -- Toggle ripple editing per-track
    reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
    reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
    reaper.Main_OnCommand(40630, 0) -- Go to start of time selection
    delete = reaper.NamedCommandLookup("_XENAKIOS_TSADEL")
    reaper.Main_OnCommand(delete, 0) -- Adaptive Delete
    reaper.Main_OnCommand(42398, 0) -- Item: Paste items/tracks
    reaper.Main_OnCommand(41990, 0) -- Toggle ripple editing per-track
  elseif (dest_in == 1 and source_count == 2)
  then
    reaper.Main_OnCommand(40625, 0) -- Time Selection: Set start point
    reaper.GoToMarker(0, 101, false)
    reaper.Main_OnCommand(40626, 0) -- Time Selection: Set end point
    reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
    reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
    reaper.Main_OnCommand(40630, 0) -- Go to start of time selection
    delete = reaper.NamedCommandLookup("_XENAKIOS_TSADEL")
    reaper.Main_OnCommand(delete, 0) -- Adaptive Delete
    paste = reaper.NamedCommandLookup("_SWS_AWPASTE")
    reaper.Main_OnCommand(paste, 0) -- SWS_AWPASTE
  else
  reaper.Main_OnCommand(40020, 0) -- Time Selection: Remove time selection and loop point selection
  reaper.ShowMessageBox("Please add at least 3 valid source-destination markers: \n 3-point edit: DEST-IN, SOURCE-IN and SOURCE-OUT \n 4-point edit: DEST-IN, DEST-OUT, SOURCE-IN and SOURCE-OUT", "Source-Destination Edit", 0)
  return
  end
  reaper.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
  fade_left = reaper.NamedCommandLookup("_SWS_MOVECURFADELEFT")
  reaper.Main_OnCommand(fade_left, 0) -- SWS_MOVECURFADELEFT
  reaper.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
  reaper.Main_OnCommand(40417, 0) -- Item Navigation: Select and move to next item
  reaper.Main_OnCommand(fade_left, 0) -- SWS_MOVECURFADELEFT
  reaper.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
  reaper.Main_OnCommand(40912, 0) -- Options: Toggle auto-crossfade on split (OFF) 
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

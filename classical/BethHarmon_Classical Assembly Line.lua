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

local function assembly_markers()
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  exists = 0
  for i = 0, num_markers - 1, 1
  do
    retval, isrgn, pos, rgnend, label, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if (label == "DEST-IN" or label == "SOURCE-IN" or label == "SOURCE-OUT" )
    then
      exists = exists + 1
    elseif (label == "DEST-OUT")
    then
      exists = -1
    end
  end
  return exists
end

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  replace_toggle = reaper.NamedCommandLookup("_RSa7436efacaf0efb8ba704fdec38e3caed3499a22")
  if (reaper.GetToggleCommandState(replace_toggle) ~= 1 and assembly_markers() == 3)
  then
    focus = reaper.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND")
    reaper.Main_OnCommand(focus, 0)
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
    select_items = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
    reaper.Main_OnCommand(select_items, 0)
    reaper.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
    reaper.Main_OnCommand(40912, 0) -- Options: Toggle auto-crossfade on split (OFF)
    reaper.Main_OnCommand(40186, 0) -- Item: Split items at edit or play cursor (ignoring grouping)
    reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items

    reaper.Main_OnCommand(40625, 0) -- Time Selection: Set start point
    reaper.GoToMarker(0, 101, false)
    reaper.Main_OnCommand(40626, 0) -- Time Selection: Set end point
    reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
    reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
    reaper.Main_OnCommand(40630, 0) -- Go to start of time selection 
    adaptive_delete = reaper.NamedCommandLookup("_XENAKIOS_TSADEL")
    reaper.Main_OnCommand(adaptive_delete, 0)
    paste = reaper.NamedCommandLookup("_SWS_AWPASTE")
    reaper.Main_OnCommand(paste, 0)

    reaper.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
    fade_left = reaper.NamedCommandLookup("_SWS_MOVECURFADELEFT")
    reaper.Main_OnCommand(fade_left, 0)
    reaper.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
    reaper.Main_OnCommand(40319, 0) -- Item navigation: Move cursor right to edge of item
    reaper.Main_OnCommand(40912, 0) -- Options: Toggle auto-crossfade on split (OFF) 
    reaper.Main_OnCommand(40020, 0) -- Time Selection: Remove time selection and loop point selection
    reaper.DeleteProjectMarker(NULL, 100, false)
    reaper.DeleteProjectMarker(NULL, 101, false)
    reaper.DeleteProjectMarker(NULL, 102, false)
    reaper.DeleteProjectMarker(NULL, 103, false)
    local cur_pos = (reaper.GetPlayState() == 0) and reaper.GetCursorPosition() or reaper.GetPlayPosition()
    reaper.AddProjectMarker2(0, false, cur_pos, 0, "DEST-IN", 100, reaper.ColorToNative(22,141,195)|0x1000000)
    reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  else
  reaper.ShowMessageBox("Please use 3 markers: DEST-IN, SOURCE-IN and SOURCE-OUT", "Classical Assembly Line", 0)
  end
  reaper.Undo_EndBlock('Classical Assembly Line', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

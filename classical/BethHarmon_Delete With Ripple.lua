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
 
 local function source_markers()
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
   exists = 0
   for i = 0, num_markers - 1, 1
   do
     retval, isrgn, pos, rgnend, label, markrgnindexnumber = reaper.EnumProjectMarkers(i)
     if (label == "SOURCE-IN" or label == "SOURCE-OUT")
     then
       exists = exists + 1
     end
   end
   return exists
 end
 
 local function main()
   reaper.PreventUIRefresh(1)
   reaper.Undo_BeginBlock()
 
 if (source_markers() == 2)
  then
  focus = reaper.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND")
  reaper.Main_OnCommand(focus, 0) -- BR_FOCUS_ARRANGE_WND
  reaper.Main_OnCommand(40310, 0) -- Set ripple per-track
  reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
  reaper.GoToMarker(0, 102, false)
  reaper.Main_OnCommand(40625, 0) -- Time Selection: Set start point
  reaper.GoToMarker(0, 103, false)
  reaper.Main_OnCommand(40626, 0) -- Time Selection: Set end point
  reaper.Main_OnCommand(40718, 0) -- Select all items on selected tracks in current time selection
  reaper.Main_OnCommand(40034, 0) -- Item Grouping: Select all items in group(s)
  delete = reaper.NamedCommandLookup("_XENAKIOS_TSADEL")
  reaper.Main_OnCommand(delete, 0) -- XENAKIOS_TSADEL
  reaper.Main_OnCommand(40630, 0) -- Go to start of time selection
  
  fade_right = reaper.NamedCommandLookup("_SWS_MOVECURFADERIGHT")
  reaper.Main_OnCommand(fade_right, 0)
  select_under = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
  reaper.Main_OnCommand(select_under, 0) -- Xenakios/SWS: Select items under edit cursor on selected tracks
  
   fade_left = reaper.NamedCommandLookup("_SWS_MOVECURFADELEFT")
   reaper.Main_OnCommand(fade_left, 0) -- SWS_MOVECURFADELEFT
  reaper.Main_OnCommand(fade_left, 0) -- SWS_MOVECURFADELEFT
   reaper.Main_OnCommand(41305, 0) -- Item edit: Trim left edge of item to edit cursor
   reaper.Main_OnCommand(40020, 0) -- Time Selection: Remove time selection and loop point selection
   reaper.DeleteProjectMarker(NULL, 102, false)
   reaper.DeleteProjectMarker(NULL, 103, false)
   reaper.Main_OnCommand(40289, 0) -- Item: Unselect all items
 else
   reaper.ShowMessageBox("Please use SOURCE-IN and SOURCE-OUT markers", "Delete With Ripple", 0)
end
   reaper.Undo_EndBlock('Cut and Ripple', 0)
   reaper.PreventUIRefresh(-1)
   reaper.UpdateArrange()
   reaper.UpdateTimeline()
   
   end
   
   main()
  

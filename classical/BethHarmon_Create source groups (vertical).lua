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

  local total_tracks = reaper.CountTracks(0)
  i = 0
  while (i < total_tracks)
  do
   local track = reaper.GetTrack(0, i)
   reaper.GetSetTrackGroupMembership(track,"VOLUME_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"VOLUME_FOLLOW",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"PAN_LEAD",2^i,2^i)
   reaper.GetSetTrackGroupMembership(track,"PAN_FOLLOW",2^i,2^i)
   i = i + 1
  end
  local first_track = reaper.GetTrack(0,0)
  reaper.SetOnlyTrackSelected(first_track)
  i=0
  while (i < 6)
  do
  reaper.Main_OnCommand(53773, 0)
  reaper.Main_OnCommand(54959, 0)
  reaper.Main_OnCommand(53426, 0)
  reaper.Main_OnCommand(53573, 0)
  reaper.Main_OnCommand(40421, 0)
  reaper.Main_OnCommand(53629, 0)
  i = i+1
  end
  reaper.Main_OnCommand(40296, 0)
  reaper.Main_OnCommand(53625, 0)
  reaper.Main_OnCommand(40297, 0)
  reaper.Main_OnCommand(40939, 0)
  reaper.Main_OnCommand(53773, 0)

--=====copy of mpl_Toggle show only selected tracks in mixer.lua================
  function is_tracks_hidden()
    if reaper.CountTracks(0) ~= nil then
      for i = 1, reaper.CountTracks(0) do
        tr = reaper.GetTrack(0, i-1)
        if tr ~= nil then
          vis_mcp = reaper.GetMediaTrackInfo_Value(tr, 'B_SHOWINMIXER')
          if vis_mcp == 0 then return true end
        end
      end
    end
    return false
  end
  
  if is_tracks_hidden() and reaper.CountTracks(0) ~= nil then -- if something hidden
    for i = 1, reaper.CountTracks(0) do
      tr = reaper.GetTrack(0, i-1)
      if tr ~= nil then reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINMIXER',1) end
    end
    reaper.TrackList_AdjustWindows(false)
   else
    for i = 1, reaper.CountTracks(0) do
      tr = reaper.GetTrack(0, i-1)    
      if reaper.IsTrackSelected(tr) then 
        reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINMIXER',1)
       else
        reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINMIXER',0)
      end
    end
    reaper.TrackList_AdjustWindows(false)
  end
--==============================================================================
  reaper.Main_OnCommand(40297, 0)
  razor_edit = reaper.NamedCommandLookup("_RS2a78b865dca5f05176044b6d8801f19e4d7af562")
  reaper.Main_OnCommand(razor_edit, 0)
  
  reaper.Undo_EndBlock('Link Vol & Pan', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()

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

function main()
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    if (reaper.GetPlayState()) ~= 0 then
      reaper.OnStopButton()
    else
      solo()
      select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2") -- SWS: Select children of selected folder track(s)
      reaper.Main_OnCommand(select_children, 0) 
      mixer() 
      unselect_children = reaper.NamedCommandLookup("_SWS_UNSELCHILDREN")
      reaper.Main_OnCommand(unselect_children, 0) -- SWS: Unselect children of selected folder track(s)
      reaper.OnPlayButton()
      reaper.Undo_EndBlock('Classical Group Play', 0)
      reaper.PreventUIRefresh(-1)
      reaper.UpdateArrange()
      reaper.UpdateTimeline()
      reaper.TrackList_AdjustWindows(false)
    end
end

main()

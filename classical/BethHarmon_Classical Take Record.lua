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

local function main()
  take_record_toggle = reaper.NamedCommandLookup("_RSd51d37e55d67816b4d247aa707f3f7caca9b404b")
  if reaper.GetPlayState() == 0
  then
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    reaper.SetToggleCommandState(1, take_record_toggle, 1)
    reaper.RefreshToolbar2(1, take_record_toggle)
    solo()
    reaper.Main_OnCommand(40491, 0) -- Track: Unarm all tracks for recording
    select_children = reaper.NamedCommandLookup("_SWS_SELCHILDREN2")
    reaper.Main_OnCommand(select_children, 0) -- SWS: Select children of selected folder track(s)
    mixer()
    arm = reaper.NamedCommandLookup("_XENAKIOS_SELTRAX_RECARMED")
    reaper.Main_OnCommand(arm, 0) -- Xenakios/SWS: Set selected tracks record armed
    reaper.Main_OnCommand(1013, 0) -- Transport: Record

    reaper.Undo_EndBlock('Classical Take Record', 0)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
    reaper.UpdateTimeline()
  else
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    reaper.SetToggleCommandState(1, take_record_toggle, 0)
    reaper.RefreshToolbar2(1, take_record_toggle)
    reaper.Main_OnCommand(40667, 0) -- Transport: Stop (save all recorded media)
    unarm = reaper.NamedCommandLookup("_XENAKIOS_SELTRAX_RECUNARMED")
    reaper.Main_OnCommand(unarm, 0) -- Xenakios/SWS: Set selected tracks record unarmed
    unselect_children = reaper.NamedCommandLookup("_SWS_UNSELCHILDREN")
    reaper.Main_OnCommand(unselect_children, 0) -- SWS: Unselect children of selected folder track(s)

    reaper.Undo_EndBlock('Classical Take Record Stop', 0)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
    reaper.UpdateTimeline()
  end
end

main()

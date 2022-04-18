--[[
@noindex

This file is a part of "BethHarmon_Classical" package.
See "BethHarmon_Classical.lua" for more information.

Copyright (C) 2022 BethHarmon

Part of this script is by X-Raym (https://github.com/X-Raym/REAPER-EEL-Scripts)

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

-- Adapted X-Raym script (Solo exclusive track under mouse and play) ======

function Main()
  reaper.PreventUIRefresh(1)
  local solo_state = 1
  local track, context, pos = reaper.BR_TrackAtMouseCursor()
  if track then
    local solo = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
    if solo ~= solo_state then

      reaper.SetMediaTrackInfo_Value(track, "I_SOLO", solo_state)
      reaper.SetOnlyTrackSelected( track )
      
      reaper.Main_OnCommand(53773, 0) -- SWS: Select children of selected folder track(s)
      mixer()

        local count_track = reaper.CountTracks(0)
        for i = 0, count_track - 1 do
          local tr = reaper.GetTrack(0,i)
          if tr ~= track and reaper.GetMediaTrackInfo_Value(tr, "I_SOLO") ~=0 then
            reaper.SetMediaTrackInfo_Value(tr, "I_SOLO", 0)
          end
        end
    end
    
    if reaper.GetToggleCommandState( 1157 ) then
      pos = reaper.SnapToGrid( 0, pos )
    end
    local pos_init = reaper.GetCursorPosition()
    reaper.SetEditCurPos( pos, false, false )
    reaper.OnPlayButton()
    reaper.SetEditCurPos( pos_init, false, false )
    reaper.PreventUIRefresh(-1)
  end
end

reaper.defer(Main)

-- =========================================================================



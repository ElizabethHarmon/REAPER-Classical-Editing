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

local function track_check()
  return reaper.CountTracks(0)
end

function main()
  
  if (track_check() == 0) then
  
    boolean, num = reaper.GetUserInputs("Create Folder", 1, "How many tracks?", 10)
  
    if (boolean == true) then
      for i=1, tonumber(num), 1 do
        reaper.InsertTrackAtIndex(0, true)
      end
      for i=0, tonumber(num)-1, 1 do
        tr = reaper.GetTrack(0, i)
        reaper.SetTrackSelected(tr, 1)
      end
      folder = reaper.NamedCommandLookup("_SWS_MAKEFOLDER")
      reaper.Main_OnCommand(folder, 0)
      for i=0, tonumber(num)-1, 1 do
        tr = reaper.GetTrack(0, i)
        reaper.SetTrackSelected(tr, 0)
      end
    end
  else
  reaper.ShowMessageBox("Please use this function with an empty project", "Create Destination Group", 0)
  end
end

main()

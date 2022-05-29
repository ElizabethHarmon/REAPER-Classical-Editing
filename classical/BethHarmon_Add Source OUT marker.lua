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

local function get_track_number()
  selected = reaper.GetSelectedTrack(0, 0)
  if (reaper.GetMediaTrackInfo_Value(selected, "I_FOLDERDEPTH")) == 1 then
    return reaper.GetMediaTrackInfo_Value(selected, "IP_TRACKNUMBER")
  else
    folder = reaper.GetParentTrack(selected)
    return reaper.GetMediaTrackInfo_Value(folder, "IP_TRACKNUMBER")
end
    
end

function main()
  local cur_pos = (reaper.GetPlayState() == 0) and reaper.GetCursorPosition() or reaper.GetPlayPosition()
  track_number = math.floor(get_track_number())
  reaper.DeleteProjectMarker(NULL, 103, false)
  reaper.AddProjectMarker2(0, false, cur_pos, 0,track_number .. ":SOURCE-OUT", 103, reaper.ColorToNative(23,223,143)|0x1000000)
end

main()

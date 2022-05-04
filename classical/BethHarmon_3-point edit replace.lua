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
replace_toggle = reaper.NamedCommandLookup("_RSa7436efacaf0efb8ba704fdec38e3caed3499a22")

state = reaper.GetToggleCommandState(replace_toggle)
if (state == 0 or state == -1)
then
reaper.SetToggleCommandState(1, replace_toggle, 1)
reaper.RefreshToolbar2(1, replace_toggle)
else
reaper.SetToggleCommandState(1, replace_toggle, 0)
reaper.RefreshToolbar2(1, replace_toggle)
end

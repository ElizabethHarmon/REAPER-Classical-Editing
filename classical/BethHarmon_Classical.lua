@description BethHarmon_Classical
@author BethHarmon
@version 2.1
@changelog
  v2.1
  Crossfade Editor View: remembers previous arrange zoom
  Crossfade Editor View: centers on crossfade and zooms in
  Remove need for 3-point script as project startup
  v2.0
  Replaced numeric command IDs with a reaper.NamedCommandLookup
  3-point edit functionality complete
  v1.9
  Fix further commandID issue with S-D edit scripts
  v1.8
  Fix commandID issue with 3-point replace toggle
  v1.7
  Add 3-point editing (replace) functionality
  v1.6
  Add 3-point editing (insert) functionality
  v1.5
  Add bugfixed BirdBird razor area extend to children script
  Begin to add comments to numerical reaper.Main_OnCommand() lines
  v1.4
    Remove original auto_solo script
    Remove auto_solo functionality from Create source groups script
    Add custom audition script
    Audition & Take Record scripts both auto-filter active mixer tracks
  v1.3
    Prepare Takes scripts are now single press
    Renamed scripts
@metapackage
@provides
  [main] BethHarmon_Add Destination IN marker.lua
  [main] BethHarmon_Add Destination OUT Marker.lua
  [main] BethHarmon_Add Source IN marker.lua
  [main] BethHarmon_Add Source OUT marker.lua
  [main] BethHarmon_Classical Crossfade Editor.lua
  [main] BethHarmon_Classical Crossfade.lua
  [main] BethHarmon_Classical Take Record.lua
  [main] BethHarmon_Crossfade Editor View.lua
  [main] BethHarmon_Delete All S-D markers.lua
  [main] BethHarmon_Duplicate folder (No items).lua
  [main] BethHarmon_Edit Classical Crossfade.lua
  [main] BethHarmon_Prepare Takes (horizontal).lua
  [main] BethHarmon_S-D Edit (horizontal).lua
  [main] BethHarmon_Prepare Takes (vertical).lua
  [main] BethHarmon_S-D Edit (vertical).lua
  [main] BethHarmon_Whole Project View.lua
  [main] BethHarmon_Create source groups (vertical).lua
  [main] BethHarmon_Audition.lua
  [main] BethHarmon_BirdBird Razor Children.lua
  [main] BethHarmon_3-point edit replace.lua

@about
  These scripts provide dedicated source-destination markers, edits, crossfade
  editor and more for classical music editing in REAPER.

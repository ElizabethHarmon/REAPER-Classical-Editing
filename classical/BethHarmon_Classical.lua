@description BethHarmon_Classical
@author BethHarmon
@version 4.0
@changelog
  v4.0
  Source marker labels now include folder number
  Source folder is taken from source marker name
  v3.9.2
  Improve S-D edit script (separate into functions) and contain completely within if statement.
  v3.9.1
  Allow for region existence while using S-D markers
  v3.9
  Add Create Folder script
  Remove need for Classical Assembly Line to be in 3-point insert mode
  Fix Delete with Ripple tool
  v3.8
  Massive fix for command ID issues
  Duplicate Folder script fixed issue with repeated action
  Duplicate Folder script now solos and auto-hides mixer tracks
  v3.7.3
  Fix missing question mark in dialog box
  v3.7.2
  Fix error in event user clicks cancel on dialog box
  v3.7.1
  Make dialog box wording clearer
  v3.7
  Add creation of microphone tracks as part of "Create Source Group" script
  v3.6.2
  Fix duplicate folder unselect of children
  v3.6.1
  Add parent routing copy/pasting
  Add select only parent to Duplicate Folder script
  Add mute as group parameter
  v3.6
  Added sync routing/fx functionality to "Create Source Group" script
  v3.5
  New "Group Play" function
  v3.4.2
  New error messages when incorect number of S-D markers are used
  Further fix to marker counting
  v3.4.1
  Fix marker counting from 0
  v3.4
  New "Insert with Timestretching" script
  v3.3.1
  Solo first track group as part of running "Create Source Groups" script
  v3.3
  Added Classical Assembly Line script
  v3.2
  Switch to recommended versioning (https://forum.cockos.com/showpost.php?p=1707548&postcount=484)
  Audition script re-written from ground up
  BirdBird script updated in light of REAPER fix (https://forum.cockos.com/showthread.php?t=266177)
  v3.01
  Small bugfix to "prepare takes" script
  v3.0
  Single tool for both horizontal and vertical S-D edits
  Single tool for both horizontal and vertical preparation of takes
  Add Delete With Ripple & Delete Leaving Silence tools
  Prepare Takes script no longer requires a gap at the beginning of the timeline
  Auto-engage ripple per-track before any S-D or cut edits
  v2.5
  "Classical Take Record" script is now a toggle
  v2.4
  Improve "Edit Crossfade" script to expand items further
  v2.3
  Add polarity and automation trim linking to "create source group" script
  v2.2
  Fix Crossfade Editor exit
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
  [main] BethHarmon_Prepare Takes.lua
  [main] BethHarmon_S-D Edit.lua
  [main] BethHarmon_Whole Project View.lua
  [main] BethHarmon_Create source groups (vertical).lua
  [main] BethHarmon_Audition.lua
  [main] BethHarmon_BirdBird Razor Children.lua
  [main] BethHarmon_3-point edit replace.lua
  [main] BethHarmon_Delete Leaving Silence.lua
  [main] BethHarmon_Delete With Ripple.lua
  [main] BethHarmon_Classical Assembly Line.lua
  [main] BethHarmon_Insert with timestretching.lua
  [main] BethHarmon_Group Play.lua
  [main] BethHarmon_Create Folder.lua



@about
  These scripts provide dedicated source-destination markers, edits, crossfade
  editor and more for classical music editing in REAPER.

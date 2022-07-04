### Instructions for using the zip files
#### Tested on REAPER v6.62

- Linux-x86_64.zip 
- Linux-aarch64.zip (Raspberry Pi) 
- Windows-x64.zip 
- MacOS-x86_64.zip (64-bit Intel) 
- MacOS-arm64.zip (M1 chip) 

1. Download and unzip the REAPER resource bundle for your system (Linux, Windows or MacOS 64-bit)
2. Rename/backup your existing resource folder (important!)
3. Replace with the downloaded folder
4. Start REAPER
5. Sync ReaPack (to get latest BethHarmon scripts)

### Notes

On MacOS, due to security settings, you'll need to right-click on the binaries in the UserPlugins subfolder and click open. Then you need to approve. Once you click yes on all three, you can then start REAPER.

The Raspberry Pi (and anything else that uses an 64-bit ARM chip) should run my tools perfectly. The only thing missing is juliansader's JS Reascript API plugin that doesn't currently have an arm64 binary. However, that's only there in the other zips in case you wanted to use an included MPL script for making CUE files from markers. My own tools are unaffected by the omission.




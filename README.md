# Long War of the Chosen

This is an attempt to port the Long War 2 (LW2) overhaul mod for XCOM 2 to the War
of the Chosen (WOTC) expansion. The scope is limited to getting the base LW2 experience
working, but not necessarily balanced. If WOTC features severely unbalance the game and
can be removed, they will be.

## Building and running the mod

Building and running this mod requires several steps:

 1. Either clone [my fork of the X2WOTCCommunityHighlander repository](https://github.com/pledbrook/X2WOTCCommunityHighlander)
    or download the [`lwotc-dev` branch](https://github.com/pledbrook/X2WOTCCommunityHighlander/archive/lwotc-dev.zip)
	from GitHub.
	
 2. If you have cloned the repository, switch your clone to the `lwotc-dev` branch.
 
 3. Follow that [project's instructions](https://github.com/pledbrook/X2WOTCCommunityHighlander/blob/lwotc-dev/README.md)
    for building the highlander. I recommend that after building it in ModBuddy, you cook a release of it.
	That's because the cooked version runs _much_ more quickly than the noseekfreeloading version.

 4. Set up the following environment variables:
    * `XCOM2SDKPATH` — typically <path to Steam>\steamapps\common\XCOM 2 War Of The Chosen SDK
    * `XCOM2GAMEPATH` — typically <path to Steam>\steamapps\common\XCOM 2\XCom2-WarOfTheChosen
    Don't put these paths in quotes.
	
 5. Run the `build-lwotc.bat` file that you find in the root of the LWOTC project.
 
 6. When the build has finished, launch XCOM 2 WOTC and select both X2WOTCCommunityHighlander and
    LongWarOfTheChosen mods

**Note** The game is not playable right now. It builds and runs, but there are many game-breaking bugs, so it won't
be fun. For example, you won't be able to complete some missions, which will effectively ruin the campaign as you
can only continue by aborting.

## Contributing

Contributions are welcome. If you just want to raise issues, please do so [on GitHub](https://github.com/pledbrook/lwotc/issues),
preferably including a save file if possible.

If you wish to contribute to development — and this project will rely heavily on such contributions — then please
look through the issues and if you want tackle one, just leave a comment along the lines of "I'll take this one".
If you find you can't complete the issue in a reasonable time, please add another comment that says you're relinquishing
the issue.

All contributions are welcome, but bug fixes are _extremely_ welcome!

## Acknowledgements

 * The folks behind X2WOTCCommunityHighlander
 * All the folks in XCOM 2 modders' Discord who have answered my questions
 * All the authors of the mods that are integrated into this port (and there will be more to come)
 * The Long War 2 team for producing the mod in the first place!
# chickenfix

### Intro
This is a patch for Atooi Collection's Chicken Wiggle game. When the player reaches the last two levels of the story mode, 8.5 and 8.6, the game will crash when starting those levels. 
The developer says they tried to [submit](https://twitter.com/AtooiLLC/status/1742641773514760365) a patch, but it got held up in the approval process and will never be released. Atooi
Collection was a 3DS Limited Run cartridge published in 2020 and contains 5 of developer Atooi's games from the past decade. The eShop version of Chicken Wiggle does not have the bug in question, 
but the 3DS eShop has been closed for some time now.

### Bug Details & Solution
When the game tries to load a level, it will memcpy some level data from one variable address of BSS to another fixed address in BSS. The source address of this memcpy is increased by 0x2208
every level. At the last two levels, the source addr exceeds 0x5ea000, which triggers a read permissions abort. As to why that area was not allocated by the game, I don't know. <br>
<br>
The obvious thing to do would be to use svcControlMemory to allocate more memory at the crash address. While trying that, however, I found out by accident that simply NOPing out this particular
memcpy seemingly had no effect on the game but fixed the crashing issue. After later testing, NOPing the memcpy unfortunately bugged the Create mode (user made levels) by having every one start at
the demo level that's played at the title screen (usually inaccessible to the player). By putting a conditional branch on r4 (level index), I was able to avoid Create mode skipping that
memcpy while preserving the skip for Play mode. This was deemed an effective fix in further testing.

### Directions
You need a fully modded 3ds to run this patch: https://3ds.hacks.guide. Next, copy the luma folder in the release archive over to the root of the sd card, and allow the folders to merge.
sdmc:/luma/titles/00040000001d9300/code.ips - will be the resulting filepath.<br>
On the 3ds, hold select while the system boots and check "Enable game patching", then start the game as usual. The problem levels should start without issue now.<br>
<br>
Note to devs: to compile the repo, take the game's decompressed code.bin, renamed to code_template.bin, and place in the repo's root. This should produce the same code.ips that's already in the release archive.<br>
Here is a [sample save](https://github.com/LumaTeam/Luma3DS/files/5612271/Atooi.Collection.Save.zip) with game progress at 8.5 in order to test the patch.
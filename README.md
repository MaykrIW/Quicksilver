Quicksilver Admin Mod
=
Designed as an alternative to another admin mod that has not received updates in quite some time. The goal is to provide a "simple" and "easily" extendable tool for sandbox servers

Use SUI Scoreboard 
- https://github.com/ZionDevelopers/sui-scoreboard/
- Current support requires manually modifing SUI scoreboard until I make a Pull Request

Setup
======

1. Download the repository -> https://github.com/MaykrIW/Quicksilver
2. Drop into your Server addons folder
3. Start / Restart your Server

Getting started
======

From the Server console run ```qs rankSet "your name" owner```
 - e.g. ```qs rankSet Maykr owner``` or ```qs rankSet "Maykr" owner```

Until a GUI is made all modifications to ranks and privilages are handled through commands.

Ranks Structure
======
* Index -  The internal name used to manage ranks. This allows mutiple ranks to share the same name Title while having different permissions for example: incognito staff
* Title - The displayed name for a rank on the scoreboard.
* Color - Displayed color if scoreboard is Installed/Enabled
* Order - The order the rank appears relative to other ranks on the scoreboard. Lower number = higher on the board.

```
qs rankAdd Admin
qs rankColor Admin 255,0,0 
qs rankTitle Index "Benevolent Leader" 
qs rankSet Maykr Admin |or| qs rankSet "Maykr" Admin
qs rankRemove Maykr |or| qs rankRemove "Maykr"
```

Built-in Commands
----
```
qs rankAdd Index // Adds a rank with the specified name
qs rankDelete Index // Deletes the rank...
qs rankColor Index 255,0,0 // Sets the ranks color to Red!
qs rankTitle Index "My cool rank" 
qs rankSet "Player Name Here" Index
qs rankRemove "Player Name Here" // Sets the user to the "Default" rank
```


// Doesn't work yet
To open the menu, type !menu in chat, you should see a window pop up.


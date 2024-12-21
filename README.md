Quicksilver Admin Mod
===

DO NOT USE THIS YET, IT IS NOWHERE NEAR READY FOR PRODUCTION NOR TESTING
======

Designed as an "alternative" Mercury which has not public updates in quite some time. The goal is to provide a "simple" and "easily" extendable tool for sandbox servers.

Quicksilver is 1-for-1 compatible with Mercury's data folder structure to maintain as much compatibility as possible. (except logs)
- Ranks/Permissions/Savedata/Time/Etc
The only requirement is to rename the mercury data folder from ```data/mercury``` to ```data/quicksilver```

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

Tools Used: 
https://github.com/glua/Royal-Derma-Designer

Roadmap
======
[X] Logger System (basic intercept of events) READ / WRITE
- [ ] SYSTEM
- [ ] PLAYER (SPAWN/DEATH/KILLS/SPRAY)
- [ ] BUILD (PROP SPAWN, DELETE, DESTRUCTION)
- [ ] EXTENSIONS
- [ ] Logger auto-purge old (config days)
- [X] Enable/Disable Subsystems

[ ] Nethooks / Networking

[ ] Ranks

[ ] Privilages

[ ] Restrictions

[ ] Chat command system

[ ] Extension Framework

[ ] Extension Documentation

[ ] Multi-Server Syncing?

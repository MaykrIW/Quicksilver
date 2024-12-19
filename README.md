Quicksilver Admin Mod
===

DO NOT USE THIS YET, IT IS NOWHERE NEAR READY FOR PRODUCTION NOR TESTING
======

Designed as an alternative to another admin mod that has not received updates in quite some time. The goal is to provide a "simple" and "easily" extendable tool for sandbox servers.

Quicksilver is compatible with mercury's data structure for Ranks/Permissions/Savedata/Time/Etc
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

Tools: https://github.com/glua/Royal-Derma-Designer

Roadmap
======
- [ ] Logger System (basic intercept of events) READ / WRITE
- [ ] Logger auto-purge old (config days)
1. [ ] SYSTEM
2. [ ] PLAYER (SPAWN/DEATH/KILLS/SPRAY)
3. [ ] BUILD (PROP SPAWN, DELETE, DESTRUCTION)
4. [ ] EXTENSIONS
- [ ] Nethooks / Networking
- [ ] Ranks
- [ ] Privilages
- [ ] Restrictions
- [ ] Chat command system
- [ ] Extension Framework
- [ ] Extension Documentation
- [ ] Multi-Server Syncing?

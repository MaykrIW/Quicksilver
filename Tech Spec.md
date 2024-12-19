<Overview>
Compatible with Mercury's data folder structure for quick drop-in replacement.
</Overview>

<Layout>
qs_entry :: starts / inits Quicksilver, Handles hot reload of extensions and sending client files.

qs_cl_init :: handles all client side code, Menus, Chat, Config Request, scoreboard integration.

shared :: files used by both Client and Server-side, Contains library's : Common Prop Protection Interface (CPPI), Common Admin Mod Interface(CAMI), Steam AP(SAPI), etc.

extensions :: quicksilver commands, user provided functionality, etc. If it's not required for quicksilver to function and add new stuff it's an extension

qs_config.lua contains the default config required to bootstrap quicksilver. Generates qs_config.txt in data/quicksilver (make config changes here)

quicksilver/ :: all core quicksilver files live in the main directory. No need to put them in a sub-directory.

</Layout>


<FileStructure>
Quicksilver/
		Lua/
			autorun/
				qs_entry.lua
			quicksilver/
				client/
					qs_cl_init.lua
				shared/
					*shared Lua files*
				extensions/
					example_extension.lua (Require subfolders for extensions or just allow loose file?)
				*all core Lua files here*
				qs_config.lua
				docs/
					*Quicksilver Overview and Tech Specs "this"*
					*Extension Guide*
					*List of functions w/ descriptions*
	ReadMe.MD
	TechSpec.MD (temp)
</FileStructure>
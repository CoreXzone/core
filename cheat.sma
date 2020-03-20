/*********** 

cheat - allows you to enable noclip and godmode on players

Commands: 
amx_noclip <target> - allows you to set noclip on the target client
amx_godmode <target> - allows you to set godmode on the target client
repeat the command to disable

default access is ADMIN_BAN, so basically anyone with access to amx_ban will beable to use these commands

How to install:
- Find your plugins.ini in your config folder (addons/amxmodx/configs/plugins.ini) open it in notepad and type cheat.amxx
- Place the cheat.amxx in your plugins folder (addons/amxmodx/plugins/)

Requires the fun module
- Find your modules.ini (addons/amxmodx/configs/modules.ini) open it in notepad and
- Uncomment (remove the ; from infront of) the fun_amxx.dll or the fun_amxx_i386.so if you are using linux

watch <:D~?

***********/

#include <amxmodx>
#include <amxmisc>
#include <fun>

public plugin_init() {
	register_plugin("amx_cheat","1.0","watch")
	register_concmd("amx_godmode","amx_godmode",ADMIN_BAN,"<target>")
	register_concmd("amx_noclip","amx_noclip",ADMIN_BAN,"<target>")
}

public amx_godmode(id,level,cid) {
	if (!cmd_access(id,level,cid,2))
		return PLUGIN_HANDLED
	
	new arg[32], admin_name[32], target_name[32]
	read_argv(1,arg,31)

	new player = cmd_target(id,arg,14)
	if (!player) return PLUGIN_HANDLED

	get_user_name(id,admin_name,31)
	get_user_name(player,target_name,31)

	if (!get_user_godmode(player)) {
		set_user_godmode(player,1)
		switch(get_cvar_num("amx_show_activity")) {
			case 2:	client_print(0,print_chat,"ADMIN %s: enabled godmode on %s",admin_name,target_name)
			case 1:	client_print(0,print_chat,"ADMIN: enabled godmode on %s",target_name)
		}
	} else {
		set_user_godmode(player)
		switch(get_cvar_num("amx_show_activity")) {
			case 2:	client_print(0,print_chat,"ADMIN %s: disabled godmode on %s",admin_name,target_name)
			case 1:	client_print(0,print_chat,"ADMIN: disabled godmode on %s",target_name)
		}
	}
	return PLUGIN_HANDLED
}

public amx_noclip(id,level,cid) {
	if (!cmd_access(id,level,cid,2))
		return PLUGIN_HANDLED
	
	new arg[32], admin_name[32], target_name[32]
	read_argv(1,arg,31)

	new player = cmd_target(id,arg,14)
	if (!player) return PLUGIN_HANDLED

	get_user_name(id,admin_name,31)
	get_user_name(player,target_name,31)

	if (!get_user_noclip(player)) {
		set_user_noclip(player,1)
		switch(get_cvar_num("amx_show_activity")) {
			case 2:	client_print(0,print_chat,"ADMIN %s: enabled noclip on %s",admin_name,target_name)
			case 1:	client_print(0,print_chat,"ADMIN: enabled noclip on %s",target_name)
		}
	} else {
		set_user_noclip(player)
		switch(get_cvar_num("amx_show_activity")) {
			case 2:	client_print(0,print_chat,"ADMIN %s: disabled noclip on %s",admin_name,target_name)
			case 1:	client_print(0,print_chat,"ADMIN: disabled noclip on %s",target_name)
		}
	}
	return PLUGIN_HANDLED
}

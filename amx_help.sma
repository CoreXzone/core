/* AMX Mod X Plugin
*   Charr  - charr404@gmail.com
*   Thread - http://www.amxmodx.org/forums/viewtopic.php?p=176430#176430
*
*  Compiled Under 1.01 and 1.6
*  Tested in SvenCoop, but should work in all Mods
*
*  Description 
*   A Replacment for the Standard adminhelp
*
*  Version History
*   1.0.BETA	- Intial Version
*   1.0		- Intial Release
*   1.1		- FIxed the IGNORE_MINUS, added the base for search by flags
*
* Special Thanks to:
*  AMXX Dev Team - For creating the Original Plugin
*  Hawk552 - For making the Search Funciton Possible
*  Suicid3 - For helping with the MOTD Help
*  Geesu - For Approving the Plugin
*
* Future Features
*  AMXX Menu Help
*  AMXX Search by Flags
*/

// Used for Large Files, here it extends the MOTD size
#pragma dynamic 32768

#include <amxmodx>
#include <amxmisc>

#define PLUGIN "AMXX Help"
#define VERSION "1.1"
#define AUTHOR "Charr"

// Comment to remove Spaces every 10 commands (Configured up to 50)
#define CON_SPACES
#define MOTD_SPACES

// Checks to see if the first char of a command is a '-'
#define IGNORE_MINUS

// The Number of commands to show
new help_limit = 45

// Plugin Initializing
public plugin_init() {
	register_plugin(PLUGIN,VERSION,AUTHOR)
	
	register_concmd("amx_help","console_help",0,": <# / SEARCH> [<SEARCH ARG>]")
	register_clcmd("motd_help","motd_help",0,": <# / SEARCH> [<SEARCH ARG>]")
	register_clcmd("say flags","handle_flags")
	
	register_dictionary("adminhelp.txt")
}

/* Small Script for testing 'get_flags'
* Currently (1.1) [Still] only returns a number representing your flags
*
*public handle_flags(id) {
*	new flags = get_user_flags(id),getflags[32],readflags
*	get_flags(flags,getflags,31)
*	read_flags(flags)
*	
*	client_print(id,print_chat,"[AMXX] Access: %d %d",getflags,readflags)
*	
*	return PLUGIN_HANDLED
*}
*/

// Console Help Section
public console_help(id) {
	new arg[32],search[32]
	read_argv(1,arg,31)
	read_argv(2,search,31)
	
	new flags = get_user_flags(id)
	
	new cmdnum = get_concmdsnum(flags,id)
	new cmd[32],eflags,info[128]
	
	// Checking for if the user uses 'search'
	if(equal(arg,"search")) {
		console_print(id,"[AMXX] Advanced Help^n  Search Results for '%s'",search)
		for(new i = 0; i < cmdnum; i++) {
			get_concmd(i,cmd,31,eflags,info,127,flags,id)
			
			remove_quotes(search)
			
			if(equal(search,"")) {
				console_print(id,"[AMXX] Invalid Search Parameter: 'NULL'")
				return PLUGIN_HANDLED
			}
			
			#if defined IGNORE_MINUS
			if(equali(cmd,"-",1))
				continue
			#endif
			
			if(containi(cmd,search)!=-1) 
				console_print(id,"   %i: %s %s",i + 1,cmd,info)
		}
		return PLUGIN_HANDLED
	}
	/* Checking for if the user uses 'flag'  [Currently Not Working]
	if(equal(arg,"flag")) {
		new argflags[32],userflags[32]
		
		// Calculates Access levels
		get_flags(arg,argflags,31)
		get_flags(flags,userflags,31)
		
		console_print(id,"[AMXX] Advanced Help^n  Flag Search Results for '%s'",search)
		
		// If the search parameter excedes the user's access, stop
		if( [// Flags don't excede flags //] ) {
			console_print(id,"[AMXX] Advanced Help^n  Invalid Search Parameter (You don't have access)")
			return PLUGIN_HANDLED
		}
		
		for(new i = 0; i cmdnum; i++) {
			get_concmd(i,cmd,31,eflags,info,127,flags,id)
			
			console_print(id,"  %i: %s %s",i + 1,cmd,info)
			
			#if defined IGNORE_MINUS
			if(equali(cmd,"-",1))
				continue
			#endif
		}
		return PLUGIN_HANDLED
	}*/
	// If you type 'amx_help' or 'amx_help -1' its replaced with 'amx_help 0'
	if(arg [31]>= 0)
		arg[31] = 0
	
	// Finalizing What to start and end at
	new start = str_to_num(arg)
	new end = str_to_num(arg) + help_limit
	
	// Checking to see if the projected end is larger than the total number of commands
	if (end > cmdnum)
		end = cmdnum
	
	// The Actual Printing of the Commands
	console_print(id,"^n----- %L -----^n",id,"HELP_COMS")
	for(new i = start; i < end; i++) {
		get_concmd(i,cmd,31,eflags,info,128,flags,id)
		
		#if defined IGNORE_MINUS
		if(equali(cmd,"-",1))
			continue
		#endif	
		
		#if defined CON_SPACES
		if(i == 10)
			console_print(id,"")
		if(i == 20)
			console_print(id,"")
		if(i == 30)
			console_print(id,"")
		if(i == 40)
			console_print(id,"")
		if(i == 50)
			console_print(id,"")
		if(i == 60)
			console_print(id,"")
		if(i == 70)
			console_print(id,"")
		if(i == 80)
			console_print(id,"")
		if(i == 90)
			console_print(id,"")
		if(i == 100)
			console_print(id,"")
		#endif
			
		console_print(id,"%i: %s %s",i + 1,cmd,info)
	}
	console_print(id,"---- %L ----",id,"HELP_ENTRIES",start + 1,end,cmdnum)
	
	return PLUGIN_HANDLED
}

// MOTD Help Section
public motd_help(id) {
	new arg[32],search[32]
	read_argv(1,arg,31)
	read_argv(2,search,31)
	
	new flags = get_user_flags(id)
	
	new cmdnum = get_concmdsnum(flags,id)
	
	new cmd[32],eflags,info[128],motd[2048],len
	
	// Checking for if the user uses 'search'
	if(equal(arg,"search")) {
		len += format(motd[len],sizeof(motd)-len,"[AMXX] Advanced Help^n Results for '%s'^n",search)
		for(new i = 0; i < cmdnum; i++) {
			get_concmd(i,cmd,31,eflags,info,127,flags,id)
			
			if(equal(search,"")) {
				len += format(motd[len],sizeof(motd)-len,"[AMXX] Invalid Search Parameter: 'NULL'")
				return PLUGIN_HANDLED
			}
			
			#if defined IGNORE_MINUS
			if(equali(cmd,"-",1))
				continue
			#endif
			
			if(contain(cmd,search)!=-1)
				len += format(motd[len],sizeof(motd)-len,"  %i: %s %s^n",i +1,cmd,info)
		}
		show_motd(id,motd,"AMX Mod X Help")		
		return PLUGIN_HANDLED
	}
	/* Checking for if the user uses 'flag'  [Currently Not Working]
	if(equal(arg,"flag")) {
		new argflags[32],userflags[32]
		
		// Calculates Access levels
		get_flags(arg,argflags,31)
		get_flags(flags,userflags,31)
		
		console_print(id,"[AMXX] Advanced Help^n  Flag Search Results for '%s'",search)
		
		// If the search parameter excedes the user's access, stop
		if( [// Flags don't excede flags //] ) {
			console_print(id,"[AMXX] Advanced Help^n  Invalid Search Parameter (You don't have access)")
			return PLUGIN_HANDLED
		}
		
		for(new i = 0; i cmdnum; i++) {
			get_concmd(i,cmd,31,eflags,info,127,flags,id)
			
			console_print(id,"  %i: %s %s",i + 1,cmd,info)
			
			#if defined IGNORE_MINUS
			if(equali(cmd,"-",1))
				continue
			#endif
		}
		return PLUGIN_HANDLED
	}*/
	
	// If you type 'amx_help' or 'amx_help -1' its replaced with 'amx_help 0'
	if(arg [31]>= 0)
		arg[31] = 0
	
	// Finalizing What to start and end at
	new start = str_to_num(arg)
	new end = str_to_num(arg) + help_limit

	// Checking to see if the projected end is larger than the total number of commands
	if (end > cmdnum)
		end = cmdnum
	
	// The Actual Printing of the Commands
	for(new i = start; i < end; i++) {
		if(i == start)
			len += format(motd[len],sizeof(motd)-len,"----- %L -----^n^n",id,"HELP_COMS")
			
		get_concmd(i,cmd,31,eflags,info,127,flags,id)
		
		#if defined IGNORE_MINUS
		if(equali(cmd,"-",1))
			continue
		#endif
		
		#if defined MOTD_SPACES
		if(i == 10)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 20)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 30)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 40)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 50)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 60)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 70)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 80)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 90)
			len += format(motd[len],sizeof(motd)-len,"^n")
		if(i == 100)
			len += format(motd[len],sizeof(motd)-len,"^n")
		#endif
			
		len += format(motd[len],sizeof(motd)-len,"%i: %s %s^n",i + 1,cmd,info)
		
		if(i == end - 1)
			len += format(motd[len],sizeof(motd)-len,"^n---- %L ----^n",id,"HELP_ENTRIES",start + 1,end,cmdnum)
	}	
	show_motd(id,motd,"AMX Mod X Help")
	
	return PLUGIN_HANDLED
}

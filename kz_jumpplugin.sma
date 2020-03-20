/*==================================================================================================

				==================================
				=     Kz-Arg Mod By ReymonARG    =
				==================================
				

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
				Copyright © 2008, ReymonARG
			   This file is provided as is (no warranties)

	Kz-Arg Mod is free software;
	you can redistribute it and/or modify it under the terms of the
	GNU General Public License as published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Kz-Arg Mod; if not, write to the
	Free Software Foundation, Inc., 59 Temple Place - Suite 330,
	Boston, MA 02111-1307, USA.
	
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
	
	// Creadits
	* Teame06
	* Kz-Arg Server
	* Nv-Arg Community
	* KzM Servers that I get the Model of de PHP for Top15:D
	* Xtreme-Jumps.eu
	* All persons that help in  AMX Mod X > Scripting
		arkshine, Emp`, danielkza, anakin_cstrike, Exolent[jNr], connorr,
		|PJ| Shorty, stupok, SchlumPF, etc..

	
	// Friends :D
	* Ckx 			( Argentina )		Kz Player
	* ChaosAD 		( Argentina ) 		Kz Player
	* Kunqui 		( Argentina ) 		Kz Player
	* RTK 			( Argentina )		Kz Player
	* BLT 			( Argentina ) 		Kz Player
	* Juann			( Argentina ) 		Scripter
	* Juanchox 		( Argentina )		Kz Player
	* Pajaro^		( Argentina )		Kz Player
	* Limado 		( Argentina )		Kz Player
	* Pepo 			( Argentina )		Kz Player
	* Kuliaa		( Argentina )		Kz Player
	* Mucholote		 ( Ecuador )		Kz Player
	* Sickness		( Argentina )		Server Test
	* Creative & Yeans	  ( Spain )		Request me the Plugin, So I did :D
	
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

	Is you want to contact me --> 
				MSN & E-m@il: webmaster@djreymon.com
				STEAM: ReymonARG
				SKYPE: djreymon
				ICQ: 386121005
				AIM: I dont have
				IRC: #amxmodx in www.gamesurge.net/

												 
===============================================================================R=E=Y=M=O=N==A=R=G=*/

/*================================================================================================*/
/*************************************** [Includes] ***********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <hamsandwich>
#include <xs>

/*================================================================================================*/
/******************************* [Defines & Variables & Const] ************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

//#define GAME_DESCRIPTION_ON

new const ACCESS_FLAG = ADMIN_BAN
new const ACCESS_FLAG_IMP = ADMIN_RCON

new const KZ_PLUGIN_VERSION[] = "1.7"

new const ADD_COMMANDS_TO_AMX_HELP = -1 //Change to 0 for show it.
new const Float:TASK_PER_01_SECOND_TIME = 0.1  // Chenge to more is your server give choke

new const KZ_LIBRARY[] = "kzarg"
new const KZ_DIR[] = "kz"
new const KZ_CVARSDIR[] = "config.cfg"
new const KZ_STARTFILE[] = "defaultstart.ini"
new const KZ_STARTFILE_TEMP[] = "temp_start_file.ini"
new const KZ_VIPFILE[] = "vips.ini"
new const KZ_ALTER_START[] = "alter_starts"

/*================================================================================================*/

new const KZ_NV_SOUND_ON[] = "items/nvg_on.wav"
new const KZ_NV_SOUND_OFF[] = "items/nvg_off.wav"

/*================================================================================================*/

new const kz_vipmodel[] = "vip"
new const kz_alter_start_mdl[] = "models/w_c4.mdl"
new alter_button

new const Float:KZ_C4_ALTER_MIN[3] = {-14.0, -14.0, -4.0}
new const Float:KZ_C4_ALTER_MAX[3] = {14.0, 14.0, 4.0}

enum C4_TIMERS
{
	KZ_C4_START = 1,
	KZ_C4_END = 2
};

/*================================================================================================*/

new const g_BlankInfo[] = "";
new const g_BuyCmd[] = "cmdBuy";

new g_ent_playermodel[33]
new g_ent_weaponmodel[33]

/*================================================================================================*/

new const mainmenuname[] = "\r[Kz-Arg] \yMain Menu\w"
new const commandsmenuname[] = "\r[Kz-Arg] \yDefault Commands\w"
new const rewardsmenuname[] = "\r[Kz-Arg] \yKz Rewards\w"
new const c4startmenuname[] = "\r[Kz-Arg] \yC4 Timer \w"
new const c4movemenuname[] = "\r[Kz-Arg] \yC4 Move Start \w"
new const invismenuname[] = "\r[Kz-Arg] \yInvis Menu \w"


#define MAINMENU_ITEMS 20 // Add more is you want
new g_extramainmenuitems[MAINMENU_ITEMS+1][64] // 2 Array not more than 64 plis :D
new g_extramainmenuaccess[MAINMENU_ITEMS+1] // Get Access for menu if only for admins
new g_extramenucounter = 1


#define REWARDS_ITEMS 20 // Add more is you want
new g_extrarewardsitems[REWARDS_ITEMS+1][64] // 2 Array not more than 64 plis :D
new g_extrarewardsaccess[REWARDS_ITEMS+1] // Get Access for menu if only for admins
new g_extrarewardscounter = 1


/*= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */ 

new g_nmenucommands

/*================================================================================================*/

#define OFFSET_LINUX			5
#define EXTRAOFFSET_WEAPONS		4 
#define ACTUAL_EXTRA_OFFSET		20

/*================================================================================================*/

#define MAX_SOUNDS			18

// Remove same stupid sounds from player. By Cvar :D
new const g_stupidsounds[MAX_SOUNDS][] = 
{
	"doors/doorstop1.wav", "doors/doorstop2.wav", "doors/doorstop3.wav",
	"player/pl_pain2.wav", "player/pl_pain3.wav","player/pl_pain4.wav",
	"player/pl_pain5.wav", "player/pl_pain6.wav", "player/pl_pain7.wav",
	"player/bhit_kevlar-1.wav", "player/bhit_flesh-1.wav", "player/bhit_flesh-2.wav",
	"player/bhit_flesh-3.wav","player/pl_swim1.wav", "player/pl_swim2.wav",
	"player/pl_swim3.wav", "player/pl_swim4.wav", "player/waterrun.wav" 
};

/*================================================================================================*/

new const g_importantsblocks[][] =
{
	"buy", "buyammo1", "buyammo2", "buyequip",
	"cl_autobuy", "cl_rebuy", "cl_setautobuy",
	"cl_setrebuy"
};

/*================================================================================================*/

// Block user stupid buys that are not necesary :D	
new const g_removebuyweapons[][] =
{
	"usp", "glock", "deagle", "p228", "elites",
	"fn57", "m3", "xm1014", "mp5", "tmp", "p90",
	"mac10", "ump45", "ak47", "galil", "famas",
	"sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
	"sg550", "m249", "vest", "vesthelm", "flash",
	"hegren", "sgren", "defuser", "nvgs", "shield",
	"primammo", "secammo", "km45", "9x19mm", "nighthawk",
	"228compact", "fiveseven", "12gauge", "autoshotgun",
	"mp", "c90", "cv47", "defender", "clarion", "krieg552",
	"bullpup", "magnum", "d3au1", "krieg550"
};

/*================================================================================================*/

new const g_radiocommands[][] =
{
	"radio1", "radio2", "radio3", "coverme", "takepoint",
	"holdpos", "regroup", "followme", "takingfire", "go",
	"fallback", "sticktog", "getinpos", "stormfront",
	"report", "roger", "enemyspot", "needbackup",
	"sectorclear", "inposition", "reportingin", "getout",
	"negative", "enemydown"
};

/*================================================================================================*/

new const g_RemoveEntities[][] =
{
	"func_bomb_target", "info_bomb_target", "hostage_entity", /*"func_breakable",*/
	"monster_scientist", "func_hostage_rescue", "info_hostage_rescue",
	"info_vip_start", "func_vip_safetyzone", "func_escapezone",
	"armoury_entity", "game_player_equip", "player_weaponstrip",
	"info_deathmatch_start" // TT Spawn :D
};

/*================================================================================================*/

// Const Weapon for work more easy with this
new const g_weaponconst[][] =
{
	"", // NULL
	"weapon_p228", "weapon_shield", "weapon_scout", "weapon_hegrenade",
	"weapon_xm1014", "weapon_c4", "weapon_mac10", "weapon_aug",
	"weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45",
	"weapon_sg550", "weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18",
	"weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1",
	"weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle",
	"weapon_sg552", "weapon_ak47", "weapon_knife", "weapon_p90"
};

/*================================================================================================*/

// Weaposnconst without the weapon_ I don't want to use remplace :D
new const g_weaponsnames[][] =
{
	"", // NULL
	"p228", "shield", "scout", "hegrenade", "xm1014", "c4",
	"mac10", "aug", "smokegrenade", "elite", "fiveseven",
	"ump45", "sg550", "galil", "famas", "usp", "glock18",
	"awp", "mp5navy", "m249", "m3", "m4a1", "tmp", "g3sg1",
	"flashbang", "deagle", "sg552", "ak47", "knife", "p90"
};

/*================================================================================================*/

new const g_weaponscmdname[8][] = 
{
	"weapon_scout", "weapon_p90", "weapon_famas", "weapon_sg552",
	"weapon_m4a1", "weapon_m249", "weapon_ak47", "weapon_awp"
};

new const g_weaponscmdnum[8] = 
{
	CSW_SCOUT, CSW_P90, CSW_FAMAS, CSW_SG552,
	CSW_M4A1, CSW_M249, CSW_AK47, CSW_AWP
};

/*================================================================================================*/

//From Cache-Cache by djeyL
new g_flashlight_colors[][3] = 
{ 
	{100,0,0},{0,100,0},{0,0,100},{0,100,100},{100,0,100},{100,100,0},
	{100,0,60},{100,60,0},{0,100,60},{60,100,0},{0,60,100},{60,0,100},
	{100,50,50},{50,100,50},{50,50,100},{0,50,50},{50,0,50},{50,50,0}
};

/*================================================================================================*/

new const g_allplayerscmds[][64] =
{
	//CheckPoints
	"cp", "cmdCP", "[Kz-Arg] Create a CheckPoint",
	"checkpoint", "cmdCP", "[Kz-Arg] Create a CheckPoint",
	"check", "cmdCP", "[Kz-Arg] Create a CheckPoint",
	
	//GoChecks
	"tele", "cmdTele", "[Kz-Arg] Teleport to the last CheckPoint",
	"gc", "cmdTele", "[Kz-Arg] Teleport to the last CheckPoint",
	"gocheck", "cmdTele", "[Kz-Arg] Teleport to the last CheckPoint",
	"tp", "cmdTele", "[Kz-Arg] Teleport to the last CheckPoint",
	
	//Stucks
	"stuck", "cmdStuck", "[Kz-Arg] Teleport to the last-last CheckPoint",
	"unstuck", "cmdStuck", "[Kz-Arg] Teleport to the last-last CheckPoint",
	
	//Reset
	"reset", "cmdReset", "[Kz-Arg] Reset your current time",
	
	//Start
	"start", "cmdStart", "[Kz-Arg] Teleport to the Start Button",
	
	//Pause
	"pause", "cmdPause", "[Kz-Arg] Pause the time & Unpause the time",
	"unpause", "cmdPause", "[Kz-Arg] Pause the time & Unpause the time",
	
	//Change Player se time
	"showtime", "cmdShowTime", "[Kz-Arg] Show how you want to see the timer",
	
	//Vip & Admin
	"vip", "cmdVip", "[Kz-Arg] Show in Chat a list off all Vips Players Connected",
	"vips", "cmdVip", "[Kz-Arg] Show in Chat a list off all Vips Players Connected",
	"admin", "cmdVip", "[Kz-Arg] Show in Chat a list off all Vips Players Connected",
	"admins", "cmdVip", "[Kz-Arg] Show in Chat a list off all Vips Players Connected",
	
	//Main Menu
	"menu", "cmdMainMenu", "[Kz-Arg] Show the Main Menu of the Kz-Arg Plugin",
	
	//C4 Menu
	"c4start", "cmdC4Starts", "[Kz-Arg] Set New Start Position if the map dont have",
	
	//Spec
	"spec", "cmdSpec", "[Kz-Arg] Go to Ct/Spec",
	"unspec", "cmdSpec", "[Kz-Arg] Go to Ct/Spec",
	"ct", "cmdSpec", "[Kz-Arg] Go to Ct/Spec",
	
	//
	"spawn", "cmdSpawn", "[Kz-Arg] Respawn",
	"respawn", "cmdSpawn", "[Kz-Arg] Respawn",
	
	//
	"showkeys", "cmdShowKey", "[Kz-Arg] Show yours Keys",
	
	//
	"showspeckeys", "cmdShowKeySpec", "[Kz-Arg] Show keys that are you specting",
	
	//Weapons
	"weapons", "cmdWeapons", "[Kz-Arg] Give you Weapon with diferents speed",
	
	//
	"scout", "cmdScout", "[Kz-Arg] Change your weapon to Scout",
	
	//Rewards
	"rewards", "cmdRewards", "[Kz-Arg] Open Reward Menu",
	
	//Invis
	"invis", "cmdInvis", "[Kz-Arg] Open Invis Menu",
	
	//Set New Start
	"setstart", "cmdSetStart", "[Kz-Arg] Set New Start Position"
};

/*================================================================================================*/

enum CS_Internal_Models 
{
	CS_DONTCHANGE = 0,
	CS_CT_URBAN = 1,
	CS_T_TERROR = 2,
	CS_T_LEET = 3,
	CS_T_ARCTIC = 4,
	CS_CT_GSG9 = 5,
	CS_CT_GIGN = 6,
	CS_CT_SAS = 7,
	CS_T_GUERILLA = 8,
	CS_CT_VIP = 9,
	CZ_T_MILITIA = 10,
	CZ_CT_SPETSNAZ = 11
};

enum CsTeams 
{
	CS_TEAM_UNASSIGNED = 0,
	CS_TEAM_T = 1,
	CS_TEAM_CT = 2,
	CS_TEAM_SPECTATOR = 3
};

/*================================================================================================*/

enum (+= 1000)
{
	TASK_ID_STARTWEAPONS = 1000,
	TASK_ID_WELCOMMSG,
	TASK_ID_DISPLAYTIME,
	TASK_ID_FORCEDUCK,
	TASK_ID_RESPAWN,
	TASK_ID_RESPAWN_WPNS,
	TASK_ID_RESPWAN_SPEC,
	TASK_ID_MINISECOND,
	TASK_ID_NIGHTVISION,
	TASK_ID_BOTS,
	TASK_ID_CHECKENT
};

enum VIEW_ID_MODE
{
	TRANS_MODE = 1,
	INVIS_MODE = 2,
	INVIS_ORIGIN_MODE = 3
};

/*================================================================================================*/

// Cvars
new cvar_enable
new kz_disablebuy
new kz_disableradio
new kz_disableteam
new kz_checkpoint
new kz_stuck
new kz_start
new kz_vip
new kz_sound_door
new kz_sound_fall
new kz_sound_water
new kz_overtimehud_color
new kz_overhud_color
new kz_mainmenu_cvar
new kz_firstspawnmenu
new kz_stripstartweapons
new kz_rewards
new kz_showtimein
new kz_changeshowtime
new kz_welcomemsg
new kz_weapondrop
new kz_alternativestart
new kz_spectator
new kz_weaponspeed
new kz_specinfo
new kz_weaponscmd
new kz_scout
new kz_finishstringcvar
new kz_nv_enable
new kz_nightvision_colors
new kz_nightvision_sounds
new kz_flashlight_cvar
new kz_flashlight_colors
new kz_flashlight_random
new kz_chattags
new kz_cvar_semiclip
new kz_cvar_invis
new kz_cvar_respawn

new kz_botname
new kz_botnumber

// Cvars Pointers
new kz_humans_join_team
new kz_mp_autoteambalance
new kz_mp_limitteams
new kz_sv_airaccelerate
new kz_mp_freezetime
new kz_sv_maxspeed

/*================================================================================================*/

//Variables
new g_playerstart[33]
new g_playerpaused[33]
new g_playerfirstspawn[33]
new g_playerfinish[33]
new g_playerisvip[33]

/*================================================================================================*/

// get_user_msgid Variables
new g_maxplayers
new g_roundtime
new g_saytext
new g_money
new g_statusicon
new g_scoreinfo
new g_scoreattrib
new g_teaminfo
new g_clcorpse
new g_statustext
new g_statusvalue
new g_NVGToggle
new g_hideweapon
new g_health

/*================================================================================================*/

// Forwards
new fwd_resultado
new kz_fwd_prestart
new kz_fwd_start
new kz_fwd_finish
new kz_fwd_itemmainmenu
new kz_fwd_resettime
new kz_fwd_itemrewardsmenu
new kz_fwd_pluginload

/*================================================================================================*/

// Hud Channels
new g_hud_overtime
new g_hud_center
new g_hud_over
new g_showtimein[33]

/*================================================================================================*/

// Kz Arrays funccions
new g_playercheckpoint[33];
new g_playergocheck[33];
new Float:g_player_lastcp[33][3]
new Float:g_player_prelastcp[33][3]
new Float:g_player_specposition[33][3]
new Float:g_defaultstart[3]
new bool:g_is_defaultstart
new g_playerwithstart[33]

/*================================================================================================*/

new Float:g_playertime[33]
new Float:g_playerpausetime[33]

/*================================================================================================*/

new Float:g_playerstartposition[33][3];

/*================================================================================================*/

// Weapons arrays
new g_playergiveweapon[33];
new g_numerodearma[33];
new g_armaprotop[33];

//Others
new g_showkey[33]
new g_showkeyspec[33]
new Float:g_spechp[33]
new g_iBlockSound[33];
new g_modname[32]
new g_idspecting[2][33]
new bool:g_playerenablenv[33]
new g_playerenableflash[33]
new g_playerflashcolor[33]
new g_playerhaveinvis[33]
new g_playerhavewater[33]
new bool:g_watersents[1386], bool:g_maphavewater;

new g_oldbotname[32]
new g_oldbotid

/*================================================================================================*/
/************************************** [Registrations] *******************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public plugin_init() 
{
	register_plugin("Kz Plugin", KZ_PLUGIN_VERSION, "ReymonARG")
	register_cvar("kzarg_version", KZ_PLUGIN_VERSION, FCVAR_SERVER | FCVAR_SPONLY, 0.0 )
	cvar_enable = register_cvar("kz_enable", "1") //Register first the important cvar
	
	register_dictionary("kz_jumpplugin.txt")
	
	// Block Command that are not necesary :P
	for(new i=0; i < sizeof(g_importantsblocks); i++)
		register_clcmd(g_importantsblocks[i], g_BuyCmd, -1, g_BlankInfo)
	
	register_clcmd("chooseteam", "changeteam", -1, g_BlankInfo)
	register_clcmd("jointeam 1", "changeteam", -1, g_BlankInfo)
	register_clcmd("nightvision", "cmdNightvision", -1, "")
	
	// Forwards
	register_forward(FM_EmitSound, "EmitSound")
	register_forward(FM_ClientKill, "ClientKill")
	register_forward(FM_AddToFullPack, "addToFullPack", 1)
	register_forward(FM_CmdStart, "fw_Start")
	#if defined GAME_DESCRIPTION_ON
	register_forward(FM_GetGameDescription, "fw_GetGameDescription")
	#endif
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn", 1)
	RegisterHam(Ham_Killed, "player", "fw_PlayerDeath", 1)
	RegisterHam(Ham_Use, "func_button", "fwdUse", 0)
	RegisterHam(Ham_Player_PreThink, "player", "FwdPlayerPreThink")
	RegisterHam(Ham_Player_PostThink, "player", "FwdPlayerPostThink")
	
	// Events
	register_event("CurWeapon", "event_curweapon", "be", "1=1")
	
	// Create Plugin MultiForwards
	kz_fwd_prestart = CreateMultiForward("kz_prestartclimb", ET_IGNORE, FP_CELL)
	kz_fwd_start = CreateMultiForward("kz_startclimb", ET_IGNORE, FP_CELL)
	kz_fwd_finish = CreateMultiForward("kz_finishclimb", ET_IGNORE, FP_CELL, FP_FLOAT, FP_CELL, FP_CELL, FP_CELL)
	kz_fwd_resettime = CreateMultiForward("kz_resetclimb", ET_IGNORE, FP_CELL)
	kz_fwd_itemmainmenu = CreateMultiForward("kz_itemmainmenu", ET_IGNORE, FP_CELL, FP_CELL, FP_CELL)
	kz_fwd_itemrewardsmenu = CreateMultiForward("kz_itemrewardsmenu", ET_IGNORE, FP_CELL, FP_CELL, FP_CELL)
	kz_fwd_pluginload = CreateMultiForward("kz_pluginload", ET_IGNORE)
	
	// Get Cvar Pointer
	kz_humans_join_team = get_cvar_pointer("humans_join_team")
	kz_mp_autoteambalance = get_cvar_pointer("mp_autoteambalance")
	kz_mp_limitteams = get_cvar_pointer("mp_limitteams")
	kz_sv_airaccelerate = get_cvar_pointer("sv_airaccelerate")
	kz_mp_freezetime = get_cvar_pointer("mp_freezetime")
	kz_sv_maxspeed = get_cvar_pointer("sv_maxspeed")
	
	// Some Cvars
	kz_checkpoint = register_cvar("kz_checkpoint", "1")
	kz_stuck = register_cvar("kz_stuck", "1")
	kz_start = register_cvar("kz_start", "1")
	kz_vip = register_cvar("kz_vip", "1")
	kz_disablebuy = register_cvar("kz_disablebuy", "1")
	kz_disableradio = register_cvar("kz_disableradio", "1")
	kz_disableteam = register_cvar("kz_disableteams", "1")
	kz_sound_door = register_cvar("kz_blockdoorsound", "1")
	kz_sound_fall = register_cvar("kz_blockfallsound", "1")
	kz_sound_water = register_cvar("kz_blockwatersound", "1")
	kz_overtimehud_color = register_cvar("kz_overtimehud_color", "255 0 0")
	kz_overhud_color = register_cvar("kz_overhud_color", "255 255 255")
	kz_mainmenu_cvar = register_cvar("kz_mainmenu", "1")
	kz_firstspawnmenu = register_cvar("kz_firstspawn_menu", "1")
	kz_stripstartweapons = register_cvar("kz_stripstartweapons", "1")
	kz_rewards = register_cvar("kz_rewards", "1")
	kz_showtimein = register_cvar("kz_showtimein", "1")
	kz_changeshowtime = register_cvar("kz_changeshowtime", "1")
	kz_welcomemsg = register_cvar("kz_welcome", "1")
	kz_weapondrop = register_cvar("kz_blockdrop", "1")
	kz_alternativestart = register_cvar("kz_alternativestart", "1")
	kz_spectator = register_cvar("kz_spectator", "1")
	kz_weaponspeed = register_cvar("kz_weaponspeed", "1")
	kz_specinfo = register_cvar("kz_specinfo", "1")
	kz_weaponscmd = register_cvar("kz_weapons", "1")
	kz_scout = register_cvar("kz_cmdscout", "1")
	kz_finishstringcvar = register_cvar("kz_finishmsg", "!t%name%!g finish in!t %time%!g (%gochecks% GoCheck, Weapon: %weapon%)")
	kz_nv_enable = register_cvar("kz_nightvision", "1")
	kz_nightvision_colors = register_cvar("kz_nightvision_colors", "5 0 255")
	kz_nightvision_sounds = register_cvar("kz_nightvision_sounds", "1")
	kz_flashlight_cvar = register_cvar("kz_flashlight", "1")
	kz_flashlight_random = register_cvar("kz_flashlight_random", "1")
	kz_flashlight_colors = register_cvar("kz_flashlight_colors", "255 255 255")
	kz_chattags = register_cvar("kz_chattag", "[Kz-Arg]")
	kz_cvar_semiclip = register_cvar("kz_semiclip", "1")
	kz_cvar_invis = register_cvar("kz_invis", "1")
	kz_cvar_respawn = register_cvar("kz_respawn", "1")
	
	kz_botname = register_cvar("kz_botname", "www.kz-arg.com.ar")
	kz_botnumber = register_cvar("kz_kickbot", "4")
	
	// Public CMD'S, If you want the Commands in amx_help change the -1 to 0 in ADD_COMMANDS_TO_AMX_HELP
	for( new i=0; i < sizeof(g_allplayerscmds); i = i+3 )
		kz_register_saycmd(g_allplayerscmds[i], g_allplayerscmds[i+1], ADD_COMMANDS_TO_AMX_HELP, g_allplayerscmds[i+2])
	
	
	// Varibles Msg
	g_maxplayers = get_maxplayers()
	g_roundtime = get_user_msgid("RoundTime")
	g_saytext = get_user_msgid("SayText")
	g_money = get_user_msgid("Money")
	g_scoreinfo = get_user_msgid("ScoreInfo")
	g_statusicon = get_user_msgid("StatusIcon")
	g_scoreattrib = get_user_msgid("ScoreAttrib")
	g_teaminfo = get_user_msgid("TeamInfo")
	g_statustext = get_user_msgid("StatusText")
	g_statusvalue = get_user_msgid("StatusValue")
	g_NVGToggle = get_user_msgid("NVGToggle")
	g_clcorpse = get_user_msgid("ClCorpse")
	g_hideweapon = get_user_msgid("HideWeapon")
	g_health = get_user_msgid("Health")
	register_message(g_hideweapon, "kz_hideweapon")
	register_message(g_clcorpse, "message_clcorpse")
	register_message(g_money, "kz_setmoney")
	register_message(g_health, "message_Health");
	set_msg_block(g_clcorpse,  BLOCK_SET)
	
	// Channels Sync :D
	g_hud_overtime = CreateHudSyncObj()
	g_hud_center = CreateHudSyncObj()
	g_hud_over = CreateHudSyncObj()
	
	//Get Buttons for Starts of defaults of the maps.
	alter_button = engfunc(EngFunc_AllocString, "func_button");
	
	// Default & Legals Kz Cvars
	set_pcvar_string(kz_humans_join_team, "ct")
	set_pcvar_num(kz_mp_autoteambalance, 0)
	set_pcvar_num(kz_mp_limitteams, 0)
	set_pcvar_num(kz_sv_airaccelerate, 10)
	set_pcvar_num(kz_mp_freezetime, 0)
	set_pcvar_num(kz_sv_maxspeed, 320)
	
	// Task for Times. Do not change the time.
	set_task(0.5, "DisplayTime", TASK_ID_DISPLAYTIME, _, _, "b")
	set_task(5.0, "createbot", TASK_ID_BOTS, _, _, "b")
	formatex(g_modname, 31, "Kz-Arg Mod %s", KZ_PLUGIN_VERSION)
	
	ExecuteForward(kz_fwd_pluginload, fwd_resultado)
}

/*================================================================================================*/

public plugin_cfg()
{
	new data[256]
	new mapname[64]
	get_mapname( mapname, 63)
	new map[64], x[13], y[13], z[13], bool:havecheck
	
	havecheck = false
	
	new cvarfiles[100], kzpath[64]
	kz_get_configsdir(kzpath, 63)
	formatex(cvarfiles, 99, "%s/%s", kzpath, KZ_CVARSDIR)
	// Create a new cvar configs.
	new chkversion[256], vsncheck[32], numversion[13]
	new h = fopen(cvarfiles, "rt" )
	while( !feof( h ) )
	{
		fgets(h, chkversion, 255 )
		
		if( containi(chkversion, "VERSION") != -1 && chkversion[0] == '/' && chkversion[1] == '/' )
		{
			replace(chkversion, 255, "// ", "")
			parse(chkversion, vsncheck, 31, numversion, 12)
			if( equali(numversion, KZ_PLUGIN_VERSION, 4) )
			{
				server_cmd("exec %s", cvarfiles)
				server_exec()
				havecheck = true
				break;
			}
		}
	}
	fclose(h)
	
	if( !havecheck )
	{
		delete_file(cvarfiles)
		kz_make_cvarexec(cvarfiles)
	}
	
	//Checks Defaults Starts
	formatex(cvarfiles, 99, "%s/%s", kzpath, KZ_STARTFILE)
	new f = fopen(cvarfiles, "rt" )
	while( !feof( f ) )
	{
		fgets( f, data, sizeof data - 1 )
		parse( data, map, 63, x, 12, y, 12, z, 12)
			
		if( equali( map, mapname ) )
		{
			g_defaultstart[0] = str_to_float(x)
			g_defaultstart[1] = str_to_float(y)
			g_defaultstart[2] = str_to_float(z)
			
			g_is_defaultstart = true
			break;
		}
	}
	fclose(f)
	
	new ent = engfunc( EngFunc_FindEntityByString, -1, "classname", "func_water" );
	while( (ent = engfunc( EngFunc_FindEntityByString, ent, "classname", "func_water" )) )
	{
		if( !g_maphavewater )
		{
			g_maphavewater = true;
		}

		g_watersents[ent] = true
	}
	
	readalterstarts()
}

/*================================================================================================*/

public plugin_precache()
{
	new modelpath[100], paths[64], otherspaths[100]
	formatex(modelpath, sizeof modelpath - 1, "models/player/%s/%s.mdl", kz_vipmodel, kz_vipmodel)
	engfunc(EngFunc_PrecacheModel, modelpath)
	engfunc(EngFunc_PrecacheModel, kz_alter_start_mdl)
	
	// This i dont know.. But i thinks that precache sounds is like a generic precache.
	formatex(modelpath, sizeof modelpath - 1, "sound/%s", KZ_NV_SOUND_ON)
	engfunc(EngFunc_PrecacheSound, modelpath)
	formatex(modelpath, sizeof modelpath - 1, "sound/%s", KZ_NV_SOUND_OFF)
	engfunc(EngFunc_PrecacheSound, modelpath)
	
	kz_get_configsdir(paths, 63)
	
	if( !dir_exists(paths) )
		mkdir(paths)
		
	formatex(otherspaths, 99, "%s/%s", paths, KZ_ALTER_START)
	if( !dir_exists(otherspaths) )
		mkdir(otherspaths)
	
	formatex(otherspaths, 99, "%s/%s", paths, KZ_STARTFILE)
	if( !file_exists(otherspaths) )
		write_file(otherspaths, "; Kz Start Positions")
	
	formatex(otherspaths, 99, "%s/%s", paths, KZ_VIPFILE)
	if( !file_exists(otherspaths) )
		write_file(otherspaths, "; Kz Vip File")
		
	// Remove Entitys :D
	register_forward(FM_Spawn, "FwdSpawn", 0);
}

/*================================================================================================*/

public plugin_natives()
{
	register_library(KZ_LIBRARY)
	register_native("kz_get_plugin_version", "native_get_plugin_version", 1)
	register_native("kz_get_configsdir", "native_kz_get_configsdir", 1)
	register_native("kz_get_user_checkpoint", "native_get_user_checkopint", 1)
	register_native("kz_get_user_gocheck", "native_get_user_gocheck", 1)
	register_native("kz_get_user_roundtime", "native_get_user_roundtime", 1)
	register_native("kz_get_user_startweapon", "native_get_user_weapon", 1)
	register_native("kz_get_user_status", "native_get_playerstart", 1)
	register_native("kz_reset_user_data", "native_reset_data", 1)
	register_native("kz_get_user_vip", "native_get_playervip", 1)
	register_native("kz_set_hud_overtime", "native_set_overtimehud", 1)
	register_native("kz_mainmenu_item_register", "native_mainitem_register", 1)
	register_native("kz_rewards_item_register", "native_rewards_register", 1)
	register_native("kz_get_user_team", "native_get_user_team", 1)
	register_native("kz_set_user_team", "native_set_user_team", 1)
	register_native("kz_open_mainmenu", "native_open_main_menu", 1)
	register_native("kz_open_rewardsmenu", "native_open_rewards_menu", 1)
	register_native("kz_cheat_detection", "native_cheat_detect", 1)
	register_native("kz_get_user_showtimer", "native_showtimein", 1)
	register_native("kz_colorchat", "native_colorchat", 1)
	
	//Main Menu Default Items
	g_nmenucommands = register_mainmenuitem("Kz Commands Menu", "")
}

/*================================================================================================*/

public client_connect(id)
{
	kz_reset_data(id)
	g_playerfinish[id] = false
	g_playerwithstart[id] = false
	g_playerpaused[id] = 0
	g_playerfirstspawn[id] = true;
	g_showtimein[id] = get_pcvar_num(kz_showtimein)
	g_playergiveweapon[id] = true;
	g_playerisvip[id] = false
	g_armaprotop[id] = true
	g_numerodearma[id] = CSW_USP
	g_showkey[id] = false
	g_showkeyspec[id] = true
	g_spechp[id] = 100.0
	g_playerenablenv[id] = false
	g_playerenableflash[id] = false
	g_playerhaveinvis[id] = false
	g_playerhavewater[id] = false
}

/*================================================================================================*/

public client_disconnect(id)
{
	if( g_playerisvip[id] )
		fm_remove_model_ents(id)
		
	remove_task(id+TASK_ID_MINISECOND)
	remove_task(id+TASK_ID_NIGHTVISION)
	remove_task(id+TASK_ID_WELCOMMSG)
}

/*================================================================================================*/


/*================================================================================================*/

public client_putinserver(id)
{
	if( get_pcvar_num(kz_welcomemsg) == 1 )
		set_task(15.0, "welcomemsg", id+TASK_ID_WELCOMMSG)
	
	//Checks if Players is admin or is in vips file.
	if( get_pcvar_num(kz_vip) == 1 )
	{
		if( get_user_flags(id) & ACCESS_FLAG )
		{
			g_playerisvip[id] = true
		}
		else
		{
			new data[256], authid[64], kzpaths[100]
			get_user_authid(id, authid, 63)
			kz_get_configsdir(kzpaths, 99)
			formatex(kzpaths, 99, "%s/%s", kzpaths, KZ_VIPFILE)
			new file_authid[64]
			new f = fopen(kzpaths, "rt" )
			while( !feof(f) )
			{
				fgets( f, data, sizeof data - 1 )
				parse( data, file_authid, 63)
				
				if( equali( file_authid, authid ) )
				{
					g_playerisvip[id] = true
					break;
				}
			}
			fclose(f)
		}
	}
	
	if( !is_user_hltv(id) )
		set_task(TASK_PER_01_SECOND_TIME, "playersecondtask", id+TASK_ID_MINISECOND, _, _, "b")
}

public welcomemsg(id)
{
	id -= TASK_ID_WELCOMMSG
	
	if( get_pcvar_num(kz_welcomemsg) == 1 )
	{
		new name[32]
		get_user_name(id, name, 31)
		kz_reymon_print(id, "%L", id, "TX_KZ_WELCOME", name, g_modname)
	}
}

/*================================================================================================*/

// For Block Stupid Buys
public client_command(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE;
		
	new sArg[13];
	if( read_argv(0, sArg, 12) > 11 )
	{
		return PLUGIN_CONTINUE;
	}
	
	if( get_pcvar_num(kz_weapondrop) == 1 )
	{
		if( equali("drop", sArg, 0) )
		{
			return PLUGIN_HANDLED
		}
	}
	
	if( get_pcvar_num(kz_disablebuy) == 1 )
	{
		for( new i = 0; i < sizeof(g_removebuyweapons); i++ )
		{
			if( equali(g_removebuyweapons[i], sArg, 0) )
			{
				return PLUGIN_HANDLED;
			}
		}
	}
	
	if( get_pcvar_num(kz_disableradio) == 1 )
	{
		for( new i = 0; i < sizeof(g_radiocommands); i++ )
		{
			if( equali( g_radiocommands[i], sArg, 0) )
			{
				return PLUGIN_HANDLED;
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}

public cmdBuy(id)
{
	return (get_pcvar_num(cvar_enable) == 1 && get_pcvar_num(kz_disablebuy) == 1 ) ? PLUGIN_HANDLED : PLUGIN_CONTINUE;
}

public changeteam(id)
{
	return (get_pcvar_num(cvar_enable) == 1 && get_pcvar_num(kz_disableteam) == 1 ) ? PLUGIN_HANDLED : PLUGIN_CONTINUE;
}

public kz_setmoney(msgid, msgdest, id)
{
	if( get_pcvar_num(cvar_enable) == 1 )
	{
		set_msg_arg_int(1, ARG_LONG, 1337) 
		set_pdata_int(id, 115, 0)
	}
}

public kz_hideweapon()
{
	if( get_pcvar_num(cvar_enable) == 1 )
	{
		set_msg_arg_int(1, ARG_BYTE, get_msg_arg_int(1) | (1<<1) )
	}
}

public message_Health(msgid, msgdest, id)
{
	if(!is_user_alive(id))
		return PLUGIN_CONTINUE;
	
	static hp;
	hp = get_msg_arg_int(1);
	
	if(hp > 255 && (hp % 256) == 0)
		set_msg_arg_int(1, ARG_BYTE, ++hp);
	
	return PLUGIN_CONTINUE;
}

/*================================================================================================*/
/************************************ [Task Per Player 0.1] *****************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public playersecondtask(id)
{
	id -= TASK_ID_MINISECOND
	
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	
	if( g_showtimein[id] > 1 && g_playerstart[id] && is_user_alive(id) )
	{
		new Float:tiempo = kz_realplayer_time(id)
		new iMin, Float:iSec
		iMin = floatround(tiempo, floatround_floor)/60; 
		iSec = tiempo - (60*iMin);
		
		if( g_showtimein[id] == 2 )
		{
			kz_hud_over(id, "Timer: %02d:%s%.5f | CheckPoint: %i | GoCheck: %i", iMin, iSec < 10 ? "0": "", iSec, g_playercheckpoint[id], g_playergocheck[id])
		}
		else if( g_showtimein[id] == 3 )
		{
			kz_reymon_statustext(id, 0, "Timer: %02d:%s%.5f | CheckPoint: %i | GoCheck: %i", iMin, iSec < 10 ? "0": "", iSec, g_playercheckpoint[id], g_playergocheck[id])
		}
	}
	
	if( !is_user_alive(id) )
	{
		new mode = pev(id, pev_iuser1)
		if( mode == 2 || mode == 4 ) 
		{
			new target = pev(id, pev_iuser2)
			g_idspecting[1][id] = target
			g_idspecting[0][id] = true
			
			if( get_pcvar_num(kz_specinfo) == 1 && g_showkeyspec[id] )
			{
				new target = pev(id, pev_iuser2)

				new button = pev(target, pev_button)
				new tiempo =  stock_get_user_roundtime(target)
	
				// Credit of this --> cheap_suit
				static key[6][6]
				formatex(key[0], 5, "%s", (button & IN_FORWARD) && !(button & IN_BACK) ? " W " : "   ")
				formatex(key[1], 5, "%s", (button & IN_BACK) && !(button & IN_FORWARD) ? " S " : "   ")
				formatex(key[2], 5, "%s", (button & IN_MOVELEFT) && !(button & IN_MOVERIGHT) ? "A   " : "      ")
				formatex(key[3], 5, "%s", (button & IN_MOVERIGHT) && !(button & IN_MOVELEFT) ? "   D" : "      ")
				formatex(key[4], 5, "%s", (button & IN_DUCK) ? " DUCK " : "      ")
				formatex(key[5], 5, "%s", (button & IN_JUMP) ? " JUMP " : "      ")
	
				kz_hud_center(id, "%s^n%s	%s^n%s^n%s^n%s^n^n^nTime: %02d:%02d  GoChecks: %d", key[0], key[2], key[3], key[1], key[5], key[4], (tiempo/60), (tiempo%60), g_playergocheck[target])
			}
		}
		else
		{
			g_idspecting[0][id] = false
		}
	}
	else if( is_user_alive(id) && get_pcvar_num(kz_specinfo) == 1 && g_showkey[id] )
	{
		new button = pev(id, pev_button)
	
		// Credit of this --> cheap_suit
		static key[6][6]
		formatex(key[0], 5, "%s", (button & IN_FORWARD) && !(button & IN_BACK) ? " W " : "   ")
		formatex(key[1], 5, "%s", (button & IN_BACK) && !(button & IN_FORWARD) ? " S " : "   ")
		formatex(key[2], 5, "%s", (button & IN_MOVELEFT) && !(button & IN_MOVERIGHT) ? "A   " : "      ")
		formatex(key[3], 5, "%s", (button & IN_MOVERIGHT) && !(button & IN_MOVELEFT) ? "   D" : "      ")
		formatex(key[4], 5, "%s", (button & IN_DUCK) ? " DUCK " : "      ")
		formatex(key[5], 5, "%s", (button & IN_JUMP) ? " JUMP " : "      ")
	
		kz_hud_center(id, "%s^n%s	%s^n%s^n%s^n%s", key[0], key[2], key[3], key[1], key[5], key[4])
	}
	
	return PLUGIN_CONTINUE
}

/*================================================================================================*/
/************************************ [Touch The Buttons] *****************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public fwdUse(ent, id)
{
	// Checks if entsa are reals players
	if( !ent || id > 32 || get_pcvar_num(cvar_enable) != 1 )
	{
		return FMRES_IGNORED;
	}
	
	if( !is_user_alive(id) )
	{
		return FMRES_IGNORED;
	}
	
	new target[33]
	pev( ent, pev_target, target, sizeof target - 1 )
 
	if( equali( target, "counter_start" ) || equali( target, "clockstartbutton" ) || equali( target, "firsttimerelay" ) )
	{
		// Save Player Start Position
		g_playerwithstart[id] = true;
		pev(id, pev_origin, g_playerstartposition[id])
		g_player_prelastcp[id] = g_playerstartposition[id]
						
		// Start Player climbing
		start_climb(id)
							
		// Default Start for Players
		if( !g_is_defaultstart )
		{
			new mapname[64]
			get_mapname( mapname, 63)
			kz_set_start_origin(mapname, g_playerstartposition[id])
		}
	}
	else if( equali( target, "counter_off" ) || equali( target, "clockstopbutton" ) || equali( target, "clockstop" ) )
	{
		finish_climb(id)
	}
 
	return FMRES_IGNORED;
}

/*================================================================================================*/
/**************************************** [Reset Datta] *******************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public kz_reset_data(id)
{
	g_playerstart[id] = false;
	g_playertime[id] = 0.0;
	g_playerpausetime[id] = 0.0;
	g_playercheckpoint[id] = 0;
	g_playergocheck[id] = 0;
	kz_reymon_statustext(id, 0, "")
	kz_showtime_roundtime(id, 0)
	ClearSyncHud(id, g_hud_over)
	
	return 1
}

/*================================================================================================*/
/***************************************** [Show Time] ********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public DisplayTime()
{
	if(get_pcvar_num(cvar_enable) != 1)
		return;
		
	for( new i = 1; i <= g_maxplayers; i++ )
	{
		if(  is_user_alive(i) )
		{
			if( g_showtimein[i] == 1 )
			{
				kz_showtime_roundtime(i, stock_get_user_roundtime(i))
			}
			
			if( g_playerisvip[i] )
			{
				fm_set_user_scoreattrib(i, 4)
			}
			else
			{
				fm_set_user_scoreattrib(i, 0)
			}
		}			
	}
}
		

/*================================================================================================*/
/************************************* [Start & End Func] *****************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

start_climb(id)
{
	// Use this to remove kz Rewards :D
	ExecuteForward(kz_fwd_prestart, fwd_resultado, id)
	
	delay_duck(id);
	kz_reset_data(id)
	
	// Check is Strip weapons in Enable
	if( get_pcvar_num(kz_stripstartweapons) == 1 )
	{
		checkweapons(id);
		if( !task_exists(id+TASK_ID_STARTWEAPONS) )
		{
			set_task(0.5, "dararmitaon", id+TASK_ID_STARTWEAPONS);
		}
	}
	
	// Reset some important data.
	set_pev(id, pev_frags, 0.0);
	fm_set_user_deaths(id, 0);
	set_pev(id, pev_gravity, 1.0);
	set_pev(id, pev_takedamage, DAMAGE_AIM); // Remove player GodMode
	set_pev(id, pev_movetype, MOVETYPE_WALK) // Remove player noclip
	
	// Check Player Health if less than 100 correct the HP to normal.
	if( pev(id, pev_health) < 100 )
		set_pev(id, pev_health, 100.0);
	
	// Remove player is have finish the map
	g_playerfinish[id] = false; 
	
	// Set player tha tstart the timer
	g_playerstart[id] = true;

	g_playertime[id] = thetime();

	kz_hud_overtime(id, "%L", id, "TX_KZ_STARTMSG");	

	g_playerpaused[id] = 0; // Remove player paused 2

	// Forwards For others plugins :D
	ExecuteForward(kz_fwd_start, fwd_resultado, id);
}

/*================================================================================================*/

public checkweapons(id)
{
	if( !g_playergiveweapon[id] )
		return;
		
	g_playergiveweapon[id] = false;
	
	new armita = get_user_weapon(id);
	g_numerodearma[id] = armita;
	fm_strip_user_weapons(id);
	
	switch( armita )
	{
		case CSW_USP, CSW_KNIFE:
		{
			give_uspknife(id, g_numerodearma[id]);
			g_armaprotop[id] = true
		}
		default:
		{
			give_scout(id, armita);
			g_armaprotop[id] = false
		}
	}
}

/*================================================================================================*/

public give_scout(id, armita)
{	
	new ent = fm_give_item(id, g_weaponconst[armita]);	
	fm_set_weapon_ammo(ent, 0)
}

/*================================================================================================*/

stock give_uspknife(id, toknife=0)
{	
	if( !user_has_weapon(id, CSW_USP) )
	{
		g_iBlockSound[id]++
		fm_give_item(id, g_weaponconst[CSW_USP] )
		set_pdata_int(id, 382, 24, OFFSET_LINUX)
	}
		
	if( !user_has_weapon(id, CSW_KNIFE) )
		fm_give_item(id, g_weaponconst[CSW_KNIFE] )
		
	if( toknife == CSW_KNIFE )
	{
		engclient_cmd(id, g_weaponconst[CSW_KNIFE] )
	}
}

/*================================================================================================*/

public dararmitaon(id)
{
	id -= TASK_ID_STARTWEAPONS;
	remove_task(id+TASK_ID_STARTWEAPONS);
	g_playergiveweapon[id] = true;
}

/*================================================================================================*/

finish_climb(id)
{
	if(!is_user_alive(id))
	{
		return;
	}

	if( g_playerstart[id] )
	{
		g_playerfinish[id] = true;

		new Float:flTime, weapon;

		flTime = (thetime() - g_playertime[id]) + g_playerpausetime[id];
		
		if( g_armaprotop[id] )
		{
			weapon = get_user_weapon(id)
		}
		else
		{
			weapon = g_numerodearma[id]
		}
		
		if( get_pcvar_num(kz_rewards) == 1)
			rewardsmenu(id, 0)
		
		showinfoatfinish(id, flTime, g_playercheckpoint[id], g_playergocheck[id], weapon)
		ExecuteForward(kz_fwd_finish, fwd_resultado, id, flTime, g_playercheckpoint[id], g_playergocheck[id], weapon);

		g_playerstart[id] = false;
		
		kz_reset_data(id)
	}
	else
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_STARTTIME");
	}
		
}

showinfoatfinish(id, Float:tiempo, cp, gc, wpn)
{
	static msgconvert[5][32], msgfinal[192];
	new iMin, Float:iSec;
	get_user_name(id, msgconvert[0], 31);
	
	get_pcvar_string(kz_finishstringcvar, msgfinal, 191)
	
	// Thanks connor :D
	iMin = floatround(tiempo, floatround_floor)/60; 
	iSec = tiempo - (60*iMin);
	
	formatex(msgconvert[1], 31, "%02d:%s%.5f", iMin, iSec < 10 ? "0": "", iSec)
	num_to_str(cp, msgconvert[2], 31)
	num_to_str(gc, msgconvert[3], 31)	
	formatex(msgconvert[4], 31, g_weaponsnames[wpn]);
	
	// Replace all words of the cvar
	replace_all(msgfinal, 191, "%name%", msgconvert[0])
	replace_all(msgfinal, 191, "%time%", msgconvert[1])
	replace_all(msgfinal, 191, "%checkpoints%", msgconvert[2])
	replace_all(msgfinal, 191, "%gochecks%", msgconvert[3])
	replace_all(msgfinal, 191, "%weapon%", msgconvert[4])
	
	kz_reymon_print(0, msgfinal);
	client_cmd(0, "spk buttons/bell1");
}

/*================================================================================================*/
/********************************* [CP & TP & Reset & Pause] **************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public cmdCP(id)
{
	if(get_pcvar_num(cvar_enable) == 1)
	{
		if( get_pcvar_num(kz_checkpoint) != 1 )
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_CPDISABLE")
			return PLUGIN_HANDLED;
		}
		
		if(is_user_alive(id))
		{
			if(g_playerpaused[id] == 1)
			{
				kz_hud_overtime(id, "%L", id, "TX_KZ_NOTINBREAK")
				return PLUGIN_HANDLED;
			}

			static vel[3];
			pev(id, pev_velocity, vel);

			if(vel[2] >= 0 && pev(id, pev_flags) & FL_ONGROUND)
			{
				if( g_playercheckpoint[id] == 0 )
				{
					pev(id, pev_origin, g_player_lastcp[id])
				}
				else
				{
					g_player_prelastcp[id] = g_player_lastcp[id]
					pev(id, pev_origin, g_player_lastcp[id])
				}
				g_playercheckpoint[id]++;
				kz_hud_overtime(id, "CheckPoint #%i", g_playercheckpoint[id]);
			}
			else
			{
				kz_hud_overtime(id, "%L", id, "TX_KZ_CPINAIR");
			
			}
		}
		else
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_BEALIVE")
		}
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

/*================================================================================================*/

public cmdTele(id)
{
	if(get_pcvar_num(cvar_enable) == 1)
	{
		if( get_pcvar_num(kz_checkpoint) != 1 )
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_CPDISABLE")
			return PLUGIN_HANDLED;
		}	
			
		if(!is_user_alive(id))
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_BEALIVE")
			return PLUGIN_HANDLED;
		}

		if( g_playerpaused[id] == 1 )
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_TELEPAUSE")
			return PLUGIN_HANDLED
		}

		if( g_playercheckpoint[id] != 0 )
		{
			set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
			set_pev(id, pev_origin, g_player_lastcp[id])
			g_playergocheck[id]++
			kz_hud_overtime(id, "GoCheck #%i", g_playergocheck[id])
			delay_duck(id);
		}
		else
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_FIRSTCP")
		}

		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

/*================================================================================================*/

delay_duck(id)
{
	set_task(0.01, "force_duck", id + TASK_ID_FORCEDUCK);
	fm_set_entity_flags(id, FL_DUCKING, 1);
}

public force_duck(id)
{
	id -= TASK_ID_FORCEDUCK
	fm_set_entity_flags(id, FL_DUCKING, 1);
}

/*================================================================================================*/

public cmdPause(id)
{
	if(get_pcvar_num(cvar_enable) == 1)
	{
		if( g_playerstart[id] && is_user_alive(id) )
		{
			new temp = g_playerpaused[id];
			if(!temp || temp == 2)
			{
				g_playerpausetime[id] += (thetime() - g_playertime[id]);
				g_playerpaused[id] = 1;
				g_playertime[id] = 0.0;

				kz_hud_overtime(id, "PAUSED");
				set_pev(id, pev_flags, pev(id, pev_flags) | FL_FROZEN);
			}
			else
			{
				g_playerpaused[id] = (g_playerpaused[id] == 1) ? 2 : 1;
				g_playertime[id] = thetime();
				
				kz_hud_overtime(id, "UNPAUSED");
				set_pev(id, pev_flags, pev(id, pev_flags) & ~FL_FROZEN);
			}
		}
		else
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_STARTFIRST");
		}
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

/*================================================================================================*/

public cmdStuck(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE

	if( !is_user_alive(id) )
	{
		return PLUGIN_HANDLED
	}
	
	if( get_pcvar_num(kz_stuck) != 1 || get_pcvar_num(kz_checkpoint) != 1)
	{
		kz_hud_overtime(id, "Stuck Disabled")
		return PLUGIN_HANDLED
	}
	
	if( g_playerpaused[id] == 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_TELEPAUSE")
		return PLUGIN_HANDLED
	}

	if( g_playerpaused[id] == 1 )
	{
		return PLUGIN_HANDLED
	}

	if( g_playercheckpoint[id] == 0)
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_FIRSTCP");
		return PLUGIN_HANDLED
	}

	set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
	set_pev(id, pev_origin, g_player_prelastcp[id])
	kz_hud_overtime(id, "CheckPoint %L", id, "TX_KZ_REMOVED")
	
	// Add a GoCheck because player can use this for bugs GoChecks
	g_playergocheck[id]++
	
	delay_duck(id)
	
	return PLUGIN_HANDLED;
}

/*================================================================================================*/

//Teleport to start button
public cmdStart(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE

	if( !is_user_alive(id) )
	{
		return PLUGIN_HANDLED
	}
	
	if( get_pcvar_num(kz_start) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_STARTCMD")
		return PLUGIN_HANDLED
	}
	
	if( g_playerpaused[id] == 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_TELEPAUSE")
		return PLUGIN_HANDLED
	}
	
	if( g_playerwithstart[id] )
	{
		set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
		set_pev(id, pev_origin, g_playerstartposition[id])
	}
	else if( g_is_defaultstart )
	{
		set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
		set_pev(id, pev_origin, g_defaultstart)
	}
	else
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_NOSTART")
		return PLUGIN_HANDLED
	}
	
	kz_hud_overtime(id, "%L", id, "TX_KZ_MOVETOSTART")
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

// You a list of all Vips connecteds
public cmdVip(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_vip) != 1 )
	{
		kz_reymon_print(id, "%L", id, "TX_KZ_VIPSHOW")
		return PLUGIN_HANDLED
	}
	
	new vipsnames[33][32]
	new msgfinal[256], len, count
	len = formatex(msgfinal, 255, "%L ", id, "TX_KZ_VIPTAG")
	for( new i = 1; i < g_maxplayers; i++)
	{
		if( g_playerisvip[i] )
		{
			get_user_name(i, vipsnames[count++], 31)
		}
	}
	
	if(count > 0) 
	{
		for(new i = 0 ; i < count ; i++) 
		{
			len += formatex(msgfinal[len], 255-len, "!t %s%s ", vipsnames[i], i < (count-1) ? "!g ~!t":"")
			if(len > 96 ) 
			{
				kz_reymon_print(id, msgfinal)
				len = formatex(msgfinal, 255, "!t ")
			}
		}
		
		kz_reymon_print(id, msgfinal)
	} 
	else 
	{
		len += formatex(msgfinal[len], 255-len, "%L", id, "TX_KZ_NOVIPS")
		kz_reymon_print(id, msgfinal)
	}
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdReset(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(cvar_enable) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_RESETDISA")
		return PLUGIN_HANDLED
	}
	
	if( g_playerpaused[id] == 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_REMPAUSE")
		return PLUGIN_HANDLED
	}
	
	kz_reset_data(id)
	ExecuteForward(kz_fwd_resettime, fwd_resultado, id)
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdShowTime(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_changeshowtime) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_CHANGETIME")
		return PLUGIN_HANDLED
	}
	
	kz_switch_showtime(id)
	
	return PLUGIN_HANDLED
}	

/*================================================================================================*/

public cmdMainMenu(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_mainmenu_cvar) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_DISAMAINMENU")
		return PLUGIN_HANDLED
	}
	
	mainmenu(id, 0)
	return PLUGIN_HANDLED
}

public cmdC4Starts(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_user_flags(id) & ACCESS_FLAG_IMP )
	{
		if( get_pcvar_num(kz_alternativestart) != 1 )
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_DISAC4START")
			return PLUGIN_HANDLED
		}
		else
		{
			kz_makec4menu(id, 0)
		}
	}
	else	
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_NOACCESS")
		return PLUGIN_HANDLED
	}
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public ClientKill(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return FMRES_IGNORED;
	
	cmdSpec(id)
		
	return FMRES_SUPERCEDE;

}

/*================================================================================================*/

public cmdSpec(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_spectator) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_DISASPEC")
		return PLUGIN_HANDLED
	}
	
	if( is_user_alive(id) )
	{
		if( g_playerstart[id] )
		{			
			if( g_playerpaused[id] != 1 )
			{
				g_playerpausetime[id] += (thetime() - g_playertime[id])
				g_playerpaused[id] = 1
				g_playertime[id] = 0.0
			}
		}
		pev(id, pev_health, g_spechp[id]) //Prevent stupid HP Bugs
		pev(id, pev_origin, g_player_specposition[id])
		fm_set_user_team(id, CS_TEAM_SPECTATOR)
		set_pev(id, pev_solid, SOLID_NOT)
		set_pev(id, pev_movetype, MOVETYPE_FLY)
		set_pev(id, pev_effects, EF_NODRAW)
		set_pev(id, pev_deadflag, DEAD_DEAD)
	}
	else
	{
		if( g_playerstart[id] )
		{
			if( g_playerpaused[id] == 1 )
			{
				g_playerpaused[id] = (g_playerpaused[id] == 1) ? 2 : 1
				g_playertime[id] = thetime();
			}
		}
		
		fm_set_user_team(id, CS_TEAM_CT)
		ExecuteHamB(Ham_CS_RoundRespawn, id)
		fix_score_team(id, "CT")
		set_pev(id, pev_health, g_spechp[id]) //Prevent stupid HP Bugs
		set_task(0.2, "post_player_spec", id + TASK_ID_RESPWAN_SPEC)
	}
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public post_player_spec(id)
{
	id -= TASK_ID_RESPWAN_SPEC
	
	set_pev(id, pev_origin, g_player_specposition[id])
	set_task(0.2, "givedieweapons", id + TASK_ID_RESPAWN_WPNS)
}

/*================================================================================================*/

public cmdSpawn(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( g_playerpaused[id] == 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_TELEPAUSE")
		return PLUGIN_HANDLED
	}
	
	kz_reset_data(id)
	fm_set_user_team(id, CS_TEAM_CT)
	ExecuteHamB(Ham_CS_RoundRespawn, id)
	fix_score_team(id, "CT")
	fm_strip_user_weapons(id)
	give_uspknife(id);
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdShowKey(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE	

	g_showkey[id] = !g_showkey[id]
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdShowKeySpec(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE	
	
	g_showkeyspec[id] = !g_showkeyspec[id]
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

//By SchlumPF custom by me.
public cmdWeapons(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_weaponscmd) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_DISAWEAPON")
		return PLUGIN_HANDLED
	}
		
	
	static wpncmdent;
		
	if( is_user_alive(id) )
	{
		//Prevent bugs of Tops witho others weapons
		if( !g_playerstart[id] )
		{
			// Loop all diferent weapons
			for(new i = 0; i < 8; i++)
			{
				if( !user_has_weapon(id, g_weaponscmdnum[i]) )
				{
					g_iBlockSound[id]++;
					wpncmdent = fm_give_item(id, g_weaponscmdname[i] );
					fm_set_weapon_ammo(wpncmdent, 0);
				}
			}
			
			// Give defaults weapons
			give_uspknife(id)
			
			kz_hud_overtime(id, "%L", id, "TX_KZ_GIVEWEAPON" );
		}
		else
		{
			kz_hud_overtime(id, "%L", id, "TX_KZ_RESETWEAPONFIRST")
		}
		
	}
	else
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_BEALIVE" )
	}
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdScout(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_scout) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_DISASCOUT")
		return PLUGIN_HANDLED
	}
	
	g_armaprotop[id] = false
	g_numerodearma[id] = CSW_SCOUT
	
	fm_strip_user_weapons(id)
	give_scout(id, CSW_SCOUT)
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdRewards(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_rewards) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_DISAREWARDS")
		return PLUGIN_HANDLED
	}
	
	if( !g_playerisvip[id] )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_BUYAVIPFORTHIS")
		return PLUGIN_HANDLED
	}
	
	rewardsmenu(id, 0)
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/

public cmdNightvision(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
	
	g_playerenablenv[id] = !(g_playerenablenv[id])
	
	if( get_pcvar_num(kz_nv_enable) != 1 )
	{
		remove_task(id+TASK_ID_NIGHTVISION)// Prevent bugs when cvar change
		fm_set_user_nightvision(id, g_playerenablenv[id])
	}
	else
	{
		fm_set_user_nightvision(id, false) // Prevent bugs when cvar change
		remove_task(id+TASK_ID_NIGHTVISION)
		set_task(0.1, "kz_set_user_nv", id+TASK_ID_NIGHTVISION, _, _, "b")
	}
	
	if( g_playerenablenv[id] && get_pcvar_num(kz_nightvision_sounds) == 1)
	{
		emit_sound(id,CHAN_ITEM, KZ_NV_SOUND_ON, 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	else if( !g_playerenablenv[id] && get_pcvar_num(kz_nightvision_sounds) == 1 )
	{
		emit_sound(id,CHAN_ITEM, KZ_NV_SOUND_OFF, 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	
	return PLUGIN_HANDLED;
}

public cmdInvis(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE
		
	if( get_pcvar_num(kz_cvar_invis) != 1 )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_DISAINVIS")
		return PLUGIN_HANDLED
	}
	
	kz_invismenu(id, 0)
	return PLUGIN_HANDLED;
}

public cmdSetStart(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return PLUGIN_CONTINUE

	if( !g_playerisvip[id] )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_BUYAVIPFORTHIS")
		return PLUGIN_HANDLED
	}
	
	new Float:origen[3], mapname[64]
	get_mapname(mapname, 63)
	pev(id, pev_origin, origen)
	kz_set_start_origin(mapname, origen)
	kz_hud_overtime(id, "%L", id, "TX_KZ_SETSTART")
	
	return PLUGIN_HANDLED
}

/*================================================================================================*/
/****************************************** [Menus] ***********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

stock mainmenu(id, page=0)
{
	new menu = menu_create(mainmenuname, "mainmenufunccions")
	
	
	// Menu items
	for(new i = 1 ; i < g_extramenucounter; i++)
	{
		new position[5];
		num_to_str(i, position, 4);
		menu_additem(menu,  g_extramainmenuitems[i], position, g_extramainmenuaccess[i])
	}
	
	menu_display(id, menu, page)
}

public mainmenufunccions(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new iaccess, callback;
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	
	if( str_to_num(data) == g_nmenucommands)
	{
		commandsmenu(id, 0)
	}
	
	// Send ID of player, Item choose and page :D
	ExecuteForward(kz_fwd_itemmainmenu, fwd_resultado, id, str_to_num(data), floatround(str_to_float(data)/7.0001, floatround_floor))
	
	return PLUGIN_HANDLED;
}

/*================================================================================================*/

stock rewardsmenu(id, page=0)
{
	new menu = menu_create(rewardsmenuname, "rewardsmenufunccions")
	
	// Menu items
	for(new i = 1 ; i < g_extrarewardscounter; i++)
	{
		new position[5];
		num_to_str(i, position, 4);
		menu_additem(menu, g_extrarewardsitems[i], position, g_extrarewardsaccess[i])
	}
	
	menu_display(id, menu, page)
}

public rewardsmenufunccions(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new iaccess, callback;
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	
	ExecuteForward(kz_fwd_itemrewardsmenu, fwd_resultado, id, str_to_num(data), floatround(str_to_float(data)/7.0001, floatround_floor))
	
	return PLUGIN_HANDLED;
}

/*================================================================================================*/

stock commandsmenu(id, page=0)
{
	new menu = menu_create(commandsmenuname, "commandsmenufunccions");	
		
	new msgcheck[64], msggocheck[64], msgpause[64];
	formatex(msgcheck, 63, "Checkpint - \y#%i", g_playercheckpoint[id]);
	formatex(msggocheck, 63, "GoCheck - \y#%i", g_playergocheck[id]);
	formatex(msgpause, 63, "Pause - %s", g_playerpaused[id] == 1 ? "\yON" : "\dOFF");
	
	menu_additem(menu, msgcheck, "1", 0);
	menu_additem(menu, msggocheck, "2", 0);
	menu_additem(menu, msgpause, "3", 0);
	menu_additem(menu, "Stuck", "4", 0);
	menu_additem(menu, "Start", "5", 0);
	menu_additem(menu, "Reset", "6", 0);
	
	menu_setprop(menu, MPROP_EXITNAME, "\wMain Menu");
	
	menu_display(id, menu, page);

}

public commandsmenufunccions(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		mainmenu(id, 0)
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new iaccess, callback;
	
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	new page = floatround(str_to_float(data)/7.0001, floatround_floor)
	
	switch(key)
	{
		case 1:
		{
			cmdCP(id);
			commandsmenu(id, page);
		}
		case 2:
		{
			cmdTele(id);
			commandsmenu(id, page);
		}
		case 3:
		{
			cmdPause(id);
			commandsmenu(id, page);
		}
		case 4:
		{
			cmdStuck(id);
			commandsmenu(id, page);
		}
		case 5:
		{
			cmdStart(id);
			commandsmenu(id, page);
		}
		case 6:
		{
			cmdReset(id);
			commandsmenu(id, page);
		}
	}
	
	return PLUGIN_HANDLED;
}

stock kz_invismenu(id, page=0)
{
	new menu = menu_create(invismenuname, "invismenufunccions")
	new msgs[2][64]
	formatex(msgs[0], 63, "Players - %s", g_playerhaveinvis[id] == 1 ? "\yON" : "\dOFF")
	formatex(msgs[1], 63, "%sWaters - %s", g_maphavewater ? "\w" : "\d", g_playerhavewater[id] == 1 ? "\yON" : "\dOFF")
	
	menu_additem(menu, msgs[0], "1", 0)
	menu_additem(menu, msgs[1], "2", 0)
	
	menu_display(id, menu, page)
}

public invismenufunccions(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64]
	new iaccess, callback
	
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1:
		{
			g_playerhaveinvis[id] = !g_playerhaveinvis[id]
		}
		case 2:
		{
			if( g_maphavewater )
			{
				g_playerhavewater[id] = !g_playerhavewater[id]
			}
		}
	}
	
	kz_invismenu(id, 0)
	return PLUGIN_HANDLED
}


/*================================================================================================*/
/*************************************** [Player Spawn] *******************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public fw_PlayerSpawn(id)
{  
	if( get_pcvar_num(cvar_enable) != 1 )
		return HAM_IGNORED
	
	// Not alive
	if (!is_user_alive(id))
		return HAM_IGNORED
		
	if( g_playerfirstspawn[id] )
	{
		// Open the menu
		if( get_pcvar_num(kz_firstspawnmenu) == 1 )
		{
			mainmenu(id, 0)
		}
		g_playerfirstspawn[id] = false
	}
	
	//Others Thinks
	kz_flashlight_hide(id)
	set_pev(id, pev_effects, 0)
	set_pev(id, pev_movetype, MOVETYPE_WALK)
	set_pev(id, pev_deadflag, DEAD_NO)
	set_pev(id, pev_takedamage, DAMAGE_AIM)
	fm_set_user_nvg(id)
    
	// Check if the player is Vip and set the model
	if( g_playerisvip[id] )
	{
		fm_set_vipmodel(id)
	}
	
	return HAM_IGNORED
}

/*================================================================================================*/

public fw_PlayerDeath(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return HAM_IGNORED
	
	set_pev(id, pev_solid, SOLID_NOT)
	g_playerenableflash[id] = g_playerenablenv[id] = false 
	// Do not respawn Spects Players
	if( fm_get_user_team(id) == CS_TEAM_SPECTATOR )
	{
		return HAM_IGNORED
	}
	
	// First I check Player Spec and then this.
	if( get_pcvar_num(kz_cvar_respawn) != 1 )
	{
		kz_reset_data(id)
		return HAM_IGNORED
	}
	
	ExecuteHamB(Ham_CS_RoundRespawn, id);
	// Dont flood the player
	set_task(0.5, "post_player_die", id + TASK_ID_RESPAWN)
	
	return HAM_SUPERCEDE
}

/*================================================================================================*/

public post_player_die(id)
{
	id -= TASK_ID_RESPAWN
	
	if( g_playerstart[id] )
	{
		// Player haves checkspoints?
		if( g_playercheckpoint[id] > 0 )
		{
			// Reset Player Velocity And Then Teleport
			set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
			set_pev(id, pev_origin, g_player_lastcp[id]);
			g_playergocheck[id]++;
		}
		else
		{
			// Reset Player Velocity And Then Teleport
			set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
			set_pev(id, pev_origin, g_playerstartposition[id])
		}
		// Dont flood the player
		set_task(0.2, "givedieweapons", id + TASK_ID_RESPAWN_WPNS)
	}
	else
	{
		//Give default Weapon
		give_uspknife(id)
	}
}

/*================================================================================================*/

public givedieweapons(id)
{
	id -= TASK_ID_RESPAWN_WPNS
	
	fm_strip_user_weapons(id);
	
	// User start with proweapons?
	if( g_armaprotop[id] )
	{
		give_uspknife(id)
	}
	else
	{
		give_scout(id,  g_numerodearma[id])
	}		
}

/*================================================================================================*/

public message_clcorpse()
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return
	
	// Get player id
	new id = get_msg_arg_int(12)
    
	// Check if the player is Vip and set the correct model
	if( g_playerisvip[id] && is_user_alive(id) )
	{
		// Set correct model on player corpse
		set_msg_arg_string(1, kz_vipmodel)
	}
}

/*================================================================================================*/

public event_curweapon(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return
	
	static last_weapon[33];
	
	static weapon_active, weapon_num
	weapon_active = read_data(1)
	weapon_num = read_data(2)
	
	//Checks Weapons to prevents bugs time
	if( g_armaprotop[id] && g_playerstart[id] && is_user_alive(id) )
	{
		if( weapon_num != CSW_KNIFE && weapon_num != CSW_USP )
		{
			fm_strip_user_weapons(id)
			give_uspknife(id)
		}
	}
	else if( !g_armaprotop[id] && g_playerstart[id] && is_user_alive(id) )
	{
		if( weapon_num != g_numerodearma[id] )
		{
			fm_strip_user_weapons(id)
			give_scout(id, g_numerodearma[id])
		}
	}
	
	// By SchlumPF
	if( ( weapon_num != last_weapon[id] ) && weapon_active && get_pcvar_num(kz_weaponspeed) == 1)
	{
		last_weapon[id] = weapon_num;
		
		static Float:maxspeed;
		pev(id, pev_maxspeed, maxspeed );
		
		if( maxspeed < 0.0 )
			maxspeed = 250.0;
		
		kz_hud_overtime(id, "%L %i", id, "TX_KZ_WPNSPEED", floatround( maxspeed, floatround_floor ));
	}
	
	if( g_playerisvip[id] )
	{
		fm_set_weaponmodel_ent(id)
	}
}

/*================================================================================================*/
/************************************** [Remove Entitys] ******************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public FwdSpawn(ent)
{
	if( pev_valid(ent) )
	{
		set_task(0.1, "TaskDelayedCheck", ent + TASK_ID_CHECKENT, "", 0, "", 0);
		
		return FMRES_HANDLED;
	}
	
	return FMRES_IGNORED;
}

public TaskDelayedCheck(ent)
{
	ent -= TASK_ID_CHECKENT;
	
	if( !pev_valid(ent) )
	{
		return PLUGIN_CONTINUE;
	}
	
	new class[32]
	pev(ent, pev_classname, class, 32);
	
	for( new i; i < sizeof(g_RemoveEntities); i++ )
	{		
		if( equal(class, g_RemoveEntities[i], 0) )
		{
			engfunc(EngFunc_RemoveEntity, ent);
			break;
		}
	}
	
	return PLUGIN_CONTINUE;
}

/*================================================================================================*/
/************************************* [Game Description] *****************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

#if defined GAME_DESCRIPTION_ON

//I need to fix this. I dont now the problem.
public fw_GetGameDescription()
{
	forward_return(FMV_STRING, g_modname)
	return FMRES_SUPERCEDE;
}

#endif

/*================================================================================================*/
/************************************** [Remove Sounds] *******************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public EmitSound(entity, channel, const sound[])
{
	if( get_pcvar_num(cvar_enable) != 1)
		return FMRES_IGNORED;
	
	if( get_pcvar_num(kz_sound_door) == 1 )
	{
		for(new snd = 0; snd < 3; snd++)
		{
			if(containi(sound, g_stupidsounds[snd]) != -1)
				return FMRES_SUPERCEDE;
		}
	}
	
	if( get_pcvar_num(kz_sound_fall) == 1 )
	{
		for(new snd = 3; snd < 13; snd++)
		{
			if(containi(sound, g_stupidsounds[snd]) != -1)
				return FMRES_SUPERCEDE;
		}
	}
	
	if( get_pcvar_num(kz_sound_water) == 1 )
	{
		for(new snd = 13; snd < 18; snd++)
		{
			if(containi(sound, g_stupidsounds[snd]) != -1)
				return FMRES_SUPERCEDE;
		}
	}
	
	if( equali(sound, "items/gunpickup2.wav" ) )
	{
		if( g_iBlockSound[entity] )
		{
			g_iBlockSound[entity]--;
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

/*================================================================================================*/
/***************************************** [Natives] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

// Natives for use with anothers plugins :D

/*================================================================================================*/

public native_get_plugin_version(output[], len)
{
	param_convert(1)
	
	return copy(output, len, KZ_PLUGIN_VERSION)
}

/*================================================================================================*/

public native_kz_get_configsdir(name[], len)
{
	param_convert(1)
	
	new lalin[64]
	get_localinfo("amxx_configsdir", lalin,63)
	
	return formatex(name, len, "%s/%s", lalin, KZ_DIR)
}

/*================================================================================================*/

public native_get_user_checkopint(id)
{
	return g_playercheckpoint[id]
}

/*================================================================================================*/
	
public native_get_user_gocheck(id)
{
	return g_playergocheck[id]
}

/*================================================================================================*/
	
public native_get_user_roundtime(id)
{
	return stock_get_user_roundtime(id)
}

/*================================================================================================*/
	
public native_get_user_weapon(id)
{
	return g_numerodearma[id]
}

/*================================================================================================*/
	
public native_reset_data(id)
{
	return kz_reset_data(id)
}
	
/*================================================================================================*/

public native_get_playervip(id)
{
	return g_playerisvip[id]
}

/*================================================================================================*/

public native_get_playerstart(id)
{
	return g_playerstart[id]
}

/*================================================================================================*/

public native_cheat_detect(id, const Cheat[])
{
	param_convert(2)
	
	if( g_playerstart[id] )
	{
		kz_reset_data(id)
		kz_hud_overtime(id, "%L", id, "TX_KZ_CHEATDETECT", Cheat)
	}
}
	
/*================================================================================================*/

public native_set_overtimehud(id, const message[], {Float,Sql,Result,_}:...)
{
	param_convert(2)
	param_convert(3)
	
	static msg[192], colors[12], r[4], g[4], b[4];
	vformat(msg, 191, message, 3);
	
	get_pcvar_string(kz_overtimehud_color, colors, 11)
	parse(colors, r, 3, g, 3, b, 4)
	
	set_hudmessage(str_to_num(r), str_to_num(g), str_to_num(b), -1.0, 0.90, 0, 0.0, 2.0, 0.0, 1.0, -1);
	ShowSyncHudMsg(id, g_hud_overtime, msg);
}

/*================================================================================================*/

public native_mainitem_register(const itemname[], const itemaccess[])
{
	//Return -1 if main menu have many items
	if( g_extramenucounter > MAINMENU_ITEMS )
		return -1;
	
	param_convert(1)
	param_convert(2)
	
	copy(g_extramainmenuitems[g_extramenucounter], 63, itemname)
	
	g_extramainmenuaccess[g_extramenucounter] = read_flags(itemaccess);
	
	g_extramenucounter++;
	
	//Return Nº of Item
	return g_extramenucounter-1;
}

/*================================================================================================*/

public native_rewards_register(const itemname[], const itemaccess[])
{
	//Return -1 if rewards menu have many items
	if( g_extrarewardscounter > REWARDS_ITEMS )
		return -1;
	
	param_convert(1)
	param_convert(2)
	
	copy(g_extrarewardsitems[g_extrarewardscounter], 63, itemname)
	
	g_extrarewardsaccess[g_extrarewardscounter] = read_flags(itemaccess);
	
	g_extrarewardscounter++;
	
	//Return Nº of Item
	return g_extrarewardscounter-1;
}

/*================================================================================================*/

public native_get_user_team(id)
{
	return get_pdata_int(id, 114, OFFSET_LINUX);
}
	
/*================================================================================================*/

public native_set_user_team(id, team )
{		
	return fm_set_user_team(id, team)
}

/*================================================================================================*/

public native_open_main_menu(id, page)
{
	if( !is_user_connected(id) )
		return 0;
		
	mainmenu(id, page)
	return 1;
}

/*================================================================================================*/

public native_open_rewards_menu(id, page)
{
	if( !is_user_connected(id) )
		return 0;
		
	rewardsmenu(id, page)
	return 1;
}

/*================================================================================================*/

public native_showtimein(id)
{
	return g_showtimein[id]
}

/*================================================================================================*/

public native_colorchat(id, const msg[], {Float,Sql,Result,_}:...)
{
	param_convert(2)
	param_convert(3)
	
	new message[180], final[192], cvarstring[64], j, cambiar[8]
	new argumentos = numargs()
	
	final[0] = 0x04;
	get_pcvar_string(kz_chattags, cvarstring, 63)
	
	//Checks if indexs if 0, To everyone.
	if(id)
	{
		if( is_user_connected(id) )
		{
			vformat(message, 179, msg, 3)
			formatex(final[1], 188, "%s %s", cvarstring, message)
			kz_remplace_colors(final, 191)
			kz_print_config(id, final)
		}
	} 
	else 
	{
		for( new i = 1; i <= g_maxplayers; i++ )
		{
			if( is_user_connected(i) )
			{
			
				new contador = 0
			
				for(j = 2; j < argumentos; j++)
				{
					if( getarg(j) == LANG_PLAYER )
					{
						setarg(j, 0, i);
						cambiar[contador++] = j;
					}
				}
				
				vformat(message, 179, msg, 3)
				formatex(final[1], 188, "%s %s", cvarstring, message)
				kz_remplace_colors(final, 191)
				kz_print_config(i, final)
				
				for(j = 0; i < contador; j++)
				{
					setarg(cambiar[i], 0, LANG_PLAYER)
				}
			}
		}
	}
}

/*================================================================================================*/
/****************************************** [Stocks] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

stock kz_reymon_print(id, const msg[], {Float,Sql,Result,_}:...)
{
	new message[180], final[192], cvarstring[64], j, cambiar[8]
	new argumentos = numargs()
	
	final[0] = 0x04;
	get_pcvar_string(kz_chattags, cvarstring, 63)
	
	//Checks if indexs if 0, To everyone.
	if(id)
	{
		if( is_user_connected(id) )
		{
			vformat(message, 179, msg, 3)
			formatex(final[1], 188, "%s %s", cvarstring, message)
			kz_remplace_colors(final, 191)
			kz_print_config(id, final)
		}
	} 
	else 
	{
		for( new i = 1; i <= g_maxplayers; i++ )
		{
			if( is_user_connected(i) )
			{
			
				new contador = 0
			
				for(j = 2; j < argumentos; j++)
				{
					if( getarg(j) == LANG_PLAYER )
					{
						setarg(j, 0, i);
						cambiar[contador++] = j;
					}
				}
				
				vformat(message, 179, msg, 3)
				formatex(final[1], 188, "%s %s", cvarstring, message)
				kz_remplace_colors(final, 191)
				kz_print_config(i, final)
				
				for(j = 0; i < contador; j++)
				{
					setarg(cambiar[i], 0, LANG_PLAYER)
				}
			}
		}
	}
}

stock kz_print_config(id, const msg[])
{
	message_begin(MSG_ONE_UNRELIABLE, g_saytext, _, id);
	write_byte(id);
	write_string(msg);
	message_end();
}

stock kz_remplace_colors(message[], len)
{
	replace_all(message, len, "!g", "^x04")
	replace_all(message, len, "!t", "^x03")
	replace_all(message, len, "!y", "^x01")
}

/*================================================================================================*/

stock Float:thetime()
{
	return get_gametime()
}

stock kz_get_configsdir(name[], len)
{
	new lalin[64]
	get_localinfo("amxx_configsdir", lalin,63)
	
	return formatex(name, len, "%s/%s", lalin, KZ_DIR)
}

/*================================================================================================*/

stock kz_showtime_roundtime(id, tiempo)
{
	if( is_user_connected(id) )
	{
		message_begin(MSG_ONE_UNRELIABLE, g_roundtime, _, id);
		write_short(tiempo + 1); // +1 :D
		message_end();
	}
}

/*================================================================================================*/

stock stock_get_user_roundtime(id)
{
	switch(g_playerpaused[id])
	{
		case 0:
		{
			if(g_playertime[id])
				return floatround(thetime() - g_playertime[id]);
		}
		case 1:
		{
			return floatround(g_playerpausetime[id]);
		}
		case 2:
		{
			return floatround(g_playerpausetime[id] + (thetime() - g_playertime[id]));
		}
	}
	return 0;
}

stock Float:kz_realplayer_time(id)
{	
	switch(g_playerpaused[id])
	{
		case 0:
		{
			if(g_playertime[id])
				return (thetime() - g_playertime[id]);
		}
		case 1:
		{
			return (g_playerpausetime[id]);
		}
		case 2:
		{
			return (g_playerpausetime[id] + (thetime() - g_playertime[id]));
		}
	}
	
	return 0.0;	
}

/*================================================================================================*/

// For set Admin Score VIP :D
stock fm_set_user_scoreattrib(id, attrib=0)
{
	message_begin(MSG_BROADCAST, g_scoreattrib, _,0);
	write_byte(id);
	write_byte(attrib);
	message_end();
}

/*================================================================================================*/

// Internal plugin register Main Menu items
stock register_mainmenuitem(const itemname[], const menuaccess[])
{
	if( g_extramenucounter > REWARDS_ITEMS )
		return -1;
	
	copy(g_extramainmenuitems[g_extramenucounter], 63, itemname)
	
	g_extramainmenuaccess[g_extramenucounter] = read_flags(menuaccess);
	
	g_extramenucounter++;
	
	return g_extramenucounter-1;
}

/*================================================================================================*/

// Print Default Players Msg over time round
// I use SyncHudMsg for dont flood the chat zone :D
// with stupid msg like "Checkpoint N 20" :P
stock kz_hud_overtime(id, const message[], {Float,Sql,Result,_}:...)
{
	static msg[192], colors[12], r[4], g[4], b[4];
	vformat(msg, 191, message, 3);
	
	get_pcvar_string(kz_overtimehud_color, colors, 11)
	parse(colors, r, 3, g, 3, b, 4)
	
	set_hudmessage(str_to_num(r), str_to_num(g), str_to_num(b), -1.0, 0.90, 0, 0.0, 2.0, 0.0, 1.0, -1);
	ShowSyncHudMsg(id, g_hud_overtime, msg);
}

stock kz_hud_center(id, const message[], {Float,Sql,Result,_}:...)
{
	static msg[192];
	vformat(msg, 191, message, 3);
	
	set_hudmessage(255, 255, 255, -1.0, 0.46, 0, _, 0.1, _, _, -1)
	ShowSyncHudMsg(id, g_hud_center, msg);
}

stock kz_hud_over(id, const message[], {Float,Sql,Result,_}:...)
{
	static msg[192], colors[12], r[4], g[4], b[4];
	vformat(msg, 191, message, 3);
	
	get_pcvar_string(kz_overhud_color, colors, 11)
	parse(colors, r, 3, g, 3, b, 4)
	
	set_hudmessage(str_to_num(r), str_to_num(g), str_to_num(b), -1.0, 0.01, 0, 0.0, 2.0, 0.0, 1.0, -1);
	ShowSyncHudMsg(id, g_hud_over, msg);
}

// This is for show time over the HP of the player.
stock kz_reymon_statustext(id, target, const msg[], {Float,Sql,Result,_}:...)
{
	new message[160]
	vformat(message, 159, msg, 4);
	
	if(id)
	{
		if( is_user_connected(id) && is_user_connected(target) )
			kz_print_statustext(id, target, message);
	} 
	else 
	{
		for( new i = 1; i <= g_maxplayers; i++)
			if( is_user_connected(i) && is_user_connected(target) )
				kz_print_statustext(i, target, message)
	}
}

stock kz_print_statustext(id, target, const msg[])
{
	message_begin(MSG_ONE_UNRELIABLE, g_statustext, _, id);
	write_byte(0);
	write_string(msg);
	message_end();
	
	message_begin(MSG_ONE_UNRELIABLE, g_statusvalue, _, id); 
	write_byte(2); 
	write_short(target); 
	message_end();
}	

/*================================================================================================*/

// Register CMD'S
stock kz_register_saycmd(const saycommand[], const function[], flags, const info[])
{
	new temp[64];
	formatex(temp, 63, "say /%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, "say .%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, "say_team /%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, ".%s", saycommand);
	register_clcmd(temp, function, flags, info);
	formatex(temp, 63, "/%s", saycommand);
	register_clcmd(temp, function, flags, info);
}

/*================================================================================================*/

// From fakemeta_util
stock fm_set_entity_flags(index, flag, onoff) 
{
	new flags = pev(index, pev_flags);
	if ((flags & flag) > 0)
		return onoff == 1 ? 2 : 1 + 0 * set_pev(index, pev_flags, flags - flag);
	else
		return onoff == 0 ? 2 : 1 + 0 * set_pev(index, pev_flags, flags + flag);

	return 0;
}

/*================================================================================================*/

// From fakemeta_util
stock fm_create_entity(const classname[]) // I dont like #define ;P
	return engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, classname))

/*================================================================================================*/

// From fakemtea_util
stock fm_give_item(index, const item[]) 
{
	if (!equal(item, "weapon_", 7) && !equal(item, "ammo_", 5) && !equal(item, "item_", 5) && !equal(item, "tf_weapon_", 10))
		return 0;

	new ent = fm_create_entity(item);
	if (!pev_valid(ent))
		return 0;

	new Float:origin[3];
	pev(index, pev_origin, origin);
	set_pev(ent, pev_origin, origin);
	set_pev(ent, pev_spawnflags, pev(ent, pev_spawnflags) | SF_NORESPAWN);
	dllfunc(DLLFunc_Spawn, ent);

	new save = pev(ent, pev_solid);
	dllfunc(DLLFunc_Touch, ent, index);
	if (pev(ent, pev_solid) != save)
		return ent;

	engfunc(EngFunc_RemoveEntity, ent);

	return -1;
}

/*================================================================================================*/

// From fakemeta_util
stock fm_strip_user_weapons(index) 
{
	new ent = fm_create_entity("player_weaponstrip");
	if (!pev_valid(ent))
		return 0;

	dllfunc(DLLFunc_Spawn, ent);
	dllfunc(DLLFunc_Use, ent, index);
	engfunc(EngFunc_RemoveEntity, ent);

	return 1;
}

/*================================================================================================*/

// Cstrike to Fakemeta :D
stock fm_set_user_deaths(id, deaths)
{
	set_pdata_int(id, 444, deaths, OFFSET_LINUX);

	message_begin(MSG_BROADCAST, g_scoreinfo );
	write_byte(id);
	new Float:frags;
	pev(id, pev_frags, frags);
	write_short(floatround(frags));
	write_short(deaths);
	write_short(0);
	write_short(get_pdata_int(id, 114, OFFSET_LINUX));
	message_end();
}

/*================================================================================================*/

// Cstrike to Fakemeta :D
stock fm_set_weapon_ammo(weapon_id, ammo) // I dont like #define ;P
{	
	set_pdata_int(weapon_id, 51, ammo, EXTRAOFFSET_WEAPONS);
}

/*================================================================================================*/

// Cstrike to Fakemeta :D by connorr
stock fm_set_user_team(id, {CsTeams,_}:team, {CS_Internal_Models,_}:model = CS_DONTCHANGE)
{
	if( !is_user_connected(id) )
		return 0;
	
	set_pdata_int(id, 114, _:team, OFFSET_LINUX);

	if(model)
	{
		set_pdata_int( id, 126, _:model, OFFSET_LINUX);
	}

	dllfunc( DLLFunc_ClientUserInfoChanged, id, engfunc( EngFunc_GetInfoKeyBuffer, id ) );

	static const teams[] = { "UNASSIGNED", "TERRORIST", "CT", "SPECTATOR" };

	emessage_begin(MSG_BROADCAST, g_teaminfo);
	ewrite_byte(id);
	ewrite_string(teams[_:team]);
	emessage_end();
    
	return 1;

}

//Prevents Scores Bugs
stock fix_score_team(id, const TEAM[])
{
	emessage_begin(MSG_BROADCAST, g_teaminfo);
	ewrite_byte(id);
	ewrite_string(TEAM);
	emessage_end();
}

/*================================================================================================*/

// Cstrike to Fakemeta :D
stock CsTeams:fm_get_user_team(id, &{CS_Internal_Models,_}:model = CS_DONTCHANGE)
{
	model = CS_Internal_Models:get_pdata_int(id, 126, OFFSET_LINUX);

	return CsTeams:get_pdata_int(id, 114, OFFSET_LINUX);
}

/*================================================================================================*/

			/*=============================================*/
			/*             Convert by MeRcyLeZZ            */
			/*=============================================*/
			
// Set Player Vip Model Stock
stock fm_set_vipmodel(id)
{
	fm_set_rendering(id, kRenderFxNone, 255, 255, 255, kRenderTransTexture, 1)
    
	static modelpath[100]
	formatex(modelpath, sizeof modelpath - 1, "models/player/%s/%s.mdl", kz_vipmodel, kz_vipmodel)
    
	if (!pev_valid(g_ent_playermodel[id]))
	{
		g_ent_playermodel[id] = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
        
		if (!pev_valid(g_ent_playermodel[id])) return;
        
		set_pev(g_ent_playermodel[id], pev_classname, "ent_playermodel")
		set_pev(g_ent_playermodel[id], pev_movetype, MOVETYPE_FOLLOW)
		set_pev(g_ent_playermodel[id], pev_aiment, id)
		set_pev(g_ent_playermodel[id], pev_owner, id)
	}
	
	engfunc(EngFunc_SetModel, g_ent_playermodel[id], modelpath)
}

// Set Wepon Ent
stock fm_set_weaponmodel_ent(id)
{
	static model[100]
	pev(id, pev_weaponmodel2, model, sizeof model - 1)
    
	if (!pev_valid(g_ent_weaponmodel[id]))
	{
		g_ent_weaponmodel[id] = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
        
		if (!pev_valid(g_ent_weaponmodel[id])) return;
        
		set_pev(g_ent_weaponmodel[id], pev_classname, "ent_weaponmodel")
		set_pev(g_ent_weaponmodel[id], pev_movetype, MOVETYPE_FOLLOW)
		set_pev(g_ent_weaponmodel[id], pev_aiment, id)
		set_pev(g_ent_weaponmodel[id], pev_owner, id)
	}

	engfunc(EngFunc_SetModel, g_ent_weaponmodel[id], model)
}

// Remove playes news ents :P
stock fm_remove_model_ents(id)
{
	set_pev(id, pev_rendermode, kRenderNormal)
    
	if(pev_valid(g_ent_playermodel[id]))
	{
		engfunc(EngFunc_RemoveEntity, g_ent_playermodel[id])
		g_ent_playermodel[id] = 0
	}

    
	if(pev_valid(g_ent_weaponmodel[id]))
	{
		engfunc(EngFunc_RemoveEntity, g_ent_weaponmodel[id])
		g_ent_weaponmodel[id] = 0
	}
}

/*================================================================================================*/

stock fm_set_user_icon(id, const icon[], r=0, g=255, b=0, status=1)
{   
	if( is_user_connected(id) )
	{
		message_begin(MSG_ONE_UNRELIABLE, g_statusicon, _, id);
		write_byte(status)
		write_string(icon)
		write_byte(r)
		write_byte(g)
		write_byte(b)
		message_end()
	}
}

stock fm_set_user_nightvision(id, bool:toggle)
{
	if( is_user_connected(id) )
	{
		message_begin(MSG_ONE_UNRELIABLE, g_NVGToggle, _, id)
		write_byte(toggle)
		message_end()
	}
}

/*================================================================================================*/

stock fm_set_user_nvg(id) // I dont like #define ;P
{	
	set_pdata_int(id, 129, get_pdata_int(id,129) | (1<<0), OFFSET_LINUX);
}

/*================================================================================================*/

stock fm_set_rendering(entity, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16) 
{
	new Float:RenderColor[3];
	RenderColor[0] = float(r);
	RenderColor[1] = float(g);
	RenderColor[2] = float(b);

	set_pev(entity, pev_renderfx, fx);
	set_pev(entity, pev_rendercolor, RenderColor);
	set_pev(entity, pev_rendermode, render);
	set_pev(entity, pev_renderamt, float(amount));

	return 1;
}

/*================================================================================================*/

stock fm_get_aim_origin(index, Float:origin[3]) 
{
	new Float:start[3], Float:view_ofs[3];
	pev(index, pev_origin, start);
	pev(index, pev_view_ofs, view_ofs);
	xs_vec_add(start, view_ofs, start);

	new Float:dest[3];
	pev(index, pev_v_angle, dest);
	engfunc(EngFunc_MakeVectors, dest);
	global_get(glb_v_forward, dest);
	xs_vec_mul_scalar(dest, 9999.0, dest);
	xs_vec_add(start, dest, dest);

	engfunc(EngFunc_TraceLine, start, dest, 0, index, 0);
	get_tr2(0, TR_vecEndPos, origin);

	return 1;
}

/*================================================================================================*/

stock kz_switch_showtime(id)
{
	kz_reymon_statustext(id, 0, "")
	kz_showtime_roundtime(id, 0)
	ClearSyncHud(id, g_hud_over)
	
	if( is_number_into(g_showtimein[id], 0, 2) )
	{
		g_showtimein[id]++;
	}
	else
	{
		g_showtimein[id] = 0;
	}	
}

/*================================================================================================*/

stock is_number_into(value, num1, num2)
{
	if( value >= num1 && value <= num2 ) // Other way is num1 <= value <= num2
		return true;
		
	return false;
}

/*================================================================================================*/
// By Exolent ...Edit
stock kz_set_start_origin(const map[], Float:origin[3])
{
	new path[128], realfile[128], tempfile[128], formatorigin[50]
	kz_get_configsdir(path, 127)
	formatex(realfile, 127, "%s/%s", path, KZ_STARTFILE)
	formatex(tempfile, 127, "%s/%s", path, KZ_STARTFILE_TEMP)
	formatex(formatorigin, 49, "%f %f %f", origin[0], origin[1], origin[2])
	
	// Set New Default Start
	g_defaultstart = origin
	g_is_defaultstart = true
	
	new file = fopen(tempfile, "wt")
	new vault = fopen(realfile, "rt")
	
	new data[128], key[64]
	new bool:replaced = false
	
	while( !feof(vault) )
	{
		fgets(vault, data, 127)
		parse(data, key, 63)
		
		if( equal(key, map) && !replaced )
		{
			fprintf(file, "%s %s^n", map, formatorigin)
			
			replaced = true
		}
		else
		{
			fputs(file, data)
		}
	}
	
	if( !replaced )
	{
		fprintf(file, "%s %s^n", map, formatorigin)
	}
	
	fclose(file)
	fclose(vault)
	
	delete_file(realfile)
	while( !rename_file(tempfile, realfile, 1) ) { }
}

/*================================================================================================*/

stock kz_make_cvarexec(const config[])
{
	new f = fopen(config, "wt");
	new stringscvars[192]
	fprintf(f, "// -----------------------^n")
	fprintf(f, "// Kz-Arg Mod by ReymonARG^n")
	fprintf(f, "// VERSION ^"%s^"^n", KZ_PLUGIN_VERSION)
	fprintf(f, "// -----------------------^n")
	fprintf(f, "^n")
	
	fprintf(f, "// Main Cvar^n")
	fprintf(f, "// ---------^n")
	fprintf(f, "kz_enable %i // Enabled or Disabled the Plugin^n", get_pcvar_num(cvar_enable))
	fprintf(f, "kz_semiclip %i // Remove Player Semiclip Trasparenci, But not the NOT_SOLID^n", get_pcvar_num(kz_cvar_semiclip))
	fprintf(f, "^n")
	
	fprintf(f, "// Defaults Cvars^n")
	fprintf(f, "// --------------^n")
	fprintf(f, "kz_checkpoint %i // Player can create a CheckPoint^n", get_pcvar_num(kz_checkpoint))
	fprintf(f, "kz_stuck %i // Player can go to the PreLast CheckPoint^n", get_pcvar_num(kz_stuck))
	fprintf(f, "kz_start %i // Player can teleport to Start^n", get_pcvar_num(kz_start))
	fprintf(f, "kz_vip %i // This is for VIPS Ands Admins^n", get_pcvar_num(kz_vip))
	fprintf(f, "kz_respawn %i // Can Player Respawn then of die^n", get_pcvar_num(kz_cvar_respawn))
	fprintf(f, "kz_spectator %i // Can player type /spec and /ct^n", get_pcvar_num(kz_spectator))
	fprintf(f, "kz_mainmenu %i // Is the MainMenu On^n", get_pcvar_num(kz_mainmenu_cvar))
	fprintf(f, "kz_rewards %i // Open the Reward menu when a playre finish a map^n", get_pcvar_num(kz_rewards))
	fprintf(f, "kz_welcome %i // Show a Info Msg about the plugin^n", get_pcvar_num(kz_welcomemsg))
	fprintf(f, "^n")
	
	fprintf(f, "// Blocks Cvars^n")
	fprintf(f, "// ------------^n")
	fprintf(f, "kz_blockdrop %i // Block Player Drop^n", get_pcvar_num(kz_weapondrop))
	fprintf(f, "kz_disablebuy %i // Block Weapon Buys^n", get_pcvar_num(kz_disablebuy))
	fprintf(f, "kz_disableradio %i // Block Radio Msg^n", get_pcvar_num(kz_disableradio))
	fprintf(f, "kz_disableteams %i // Block the TT Team, Only CT & SPEC^n", get_pcvar_num(kz_disableteam))
	fprintf(f, "kz_blockdoorsound %i // Block the sound then a player is geting HP^n", get_pcvar_num(kz_sound_door))
	fprintf(f, "kz_blockfallsound %i // Block some Players falls sounds^n", get_pcvar_num(kz_sound_fall))
	fprintf(f, "kz_blockwatersound %i // Block some Water Sounds of maps. (Only Defaults)^n", get_pcvar_num(kz_sound_water))
	fprintf(f, "^n")
	
	fprintf(f, "// Msgs Cvars^n")
	fprintf(f, "// ----------^n")
	get_pcvar_string(kz_overtimehud_color, stringscvars, 191)
	fprintf(f, "kz_overtimehud_color ^"%s^" // Set colors RRR GGG BBB For the defaults msg over the time round^n", stringscvars)

	get_pcvar_string(kz_overhud_color, stringscvars, 191)
	fprintf(f, "kz_overhud_color ^"%s^" // Set colors RRR GGG BBB for the hud of showtime 2^n", stringscvars)
	fprintf(f, "^n")
	
	fprintf(f, "// Kz Players Stuffs^n")
	fprintf(f, "// -----------------^n")
	fprintf(f, "kz_firstspawn_menu %i // Open the main menu in the first Spawn^n", get_pcvar_num(kz_firstspawnmenu))
	fprintf(f, "kz_stripstartweapons %i // Strip Weapons when player Start the Timer^n", get_pcvar_num(kz_stripstartweapons))
	fprintf(f, "kz_showtimein %i // 0 = Disable | 1 = RoundTime | 2 = Over in Hud | 3 = In StatusText ^n", get_pcvar_num(kz_showtimein))
	fprintf(f, "kz_changeshowtime %i // Player can change the Showtime with /showtime^n", get_pcvar_num(kz_changeshowtime))
	fprintf(f, "kz_alternativestart %i // Enable Alternative Start with /c4start^n", get_pcvar_num(kz_alternativestart))
	fprintf(f, "kz_specinfo %i // Show Keys and Time when someone spec to other^n", get_pcvar_num(kz_specinfo))
	fprintf(f, "kz_weaponspeed %i // Enabled the weapon speed info^n", get_pcvar_num(kz_weaponspeed))
	fprintf(f, "kz_weapons %i // Enabled the player cmd /weapons^n", get_pcvar_num(kz_weaponscmd))
	fprintf(f, "kz_cmdscout %i // Players can type /scout with Time^n", get_pcvar_num(kz_scout))
	fprintf(f, "^n")
	
	fprintf(f, "// Kz Customs Msgs^n")
	fprintf(f, "// ---------------^n")
	fprintf(f, "// Here you can use !g = Green, !y = Yellow, and !t = Team Color^n")
	get_pcvar_string(kz_chattags, stringscvars, 191)
	fprintf(f, "kz_chattag ^"%s^" // Tag of all Chat Msg^n", stringscvars)
	get_pcvar_string(kz_finishstringcvar, stringscvars, 191)
	fprintf(f, "kz_finishmsg ^"%s^" // Use here %%time%%, %%name%%, %%checkpoint%%, %%weapon%%, %%gochecks%% ^n", stringscvars)
	fprintf(f, "^n")
	
	fprintf(f, "// NightVision & Flashlight & MapLights... Stuffs^n")
	fprintf(f, "// ----------------------------------------------^n")
	fprintf(f, "kz_invis %i // Enabled Player to Invis players & Water^n", get_pcvar_num(kz_cvar_invis))
	fprintf(f, "kz_nightvision %i // If this is off Player dont have custom Msg^n", get_pcvar_num(kz_nv_enable))
	get_pcvar_string(kz_nightvision_colors, stringscvars, 191)
	fprintf(f, "kz_nightvision_colors ^"%s^" // RRR GGG BBB NightVision Color^n", stringscvars)
	fprintf(f, "kz_nightvision_sounds %i // Emit Sound when player toggle the Nightvision^n", get_pcvar_num(kz_nightvision_sounds))
	fprintf(f, "kz_flashlight %i // If this if off player have default Flashlight^n", get_pcvar_num(kz_flashlight_cvar))
	fprintf(f, "kz_flashlight_random %i // Random Greats Colors for Flashlight^n", get_pcvar_num(kz_flashlight_random))
	get_pcvar_string(kz_flashlight_colors, stringscvars, 191)
	fprintf(f, "kz_flashlight_colors ^"%s^" // RRR GGG BBB Flashlight Color, This only for is random is off^n", stringscvars)
	fprintf(f, "^n")
	
	fprintf(f, "// Bot Stuffs^n")
	fprintf(f, "// ----------^n")
	get_pcvar_string(kz_botname, stringscvars, 191)
	fprintf(f, "kz_botname ^"%s^" // Bot name, Default( ^"www.kz-arg.com.ar^" )^n", stringscvars)
	fprintf(f, "kz_kickbot %i // Number of Player to Kick the Bot^n", get_pcvar_num(kz_botnumber))
	fprintf(f, "^n")
	
	fprintf(f, "^n")
	fprintf(f, "// ------------------------------^n")
	fprintf(f, "echo ----------------------------^n")
	fprintf(f, "echo Kz-Arg Config Load All Cvars^n")
	fprintf(f, "echo ----------------------------^n")
	fprintf(f, "// ------------------------------^n")
	fprintf(f, "^n")
	
	fclose(f);
	
	server_cmd("exec %s", config)
	server_exec()
}

/*================================================================================================*/
/*************************************** [C4 Starts] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

stock kz_makec4menu(id, page=0)
{
	new menu = menu_create(c4startmenuname, "menuc4funccions");
	menu_additem(menu, "Create Start", "1", 0);
	menu_additem(menu, "Create End", "2", 0);
	menu_additem(menu, "Move Menu", "3", 0);
	menu_additem(menu, "Remove Aiming C4", "4", 0);
	menu_additem(menu, "Remove All", "5", 0);
	menu_additem(menu, "Save positions", "6", 0);
	
	menu_display(id, menu, page);
}

/*================================================================================================*/

public menuc4funccions(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new iaccess, callback;
	
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	new page = floatround(str_to_float(data)/7.0001, floatround_floor)
 
	switch( key )
	{
		case 1: 
		{
			makeBox(id, "bstart", KZ_C4_START);
		}
		case 2:
		{
			makeBox(id, "bfinal", KZ_C4_END);
		}
		case 3:	
		{
			kz_movec4menu(id)
			return PLUGIN_HANDLED
		}
		case 4:
		{
			new ent, body;
			get_user_aiming(id, ent, body, 9999);
   
			if( !pev_valid(ent) )
			{
				kz_hud_overtime(id, "%L", id, "TX_KZ_C4_POINT")
			}
			else
			{
				new szClassname[33];
				pev(ent, pev_classname, szClassname, 32);
    
				if( !equal(szClassname, "bstart", 0) && !equal(szClassname, "bfinal", 0) )
				{
					kz_hud_overtime(id, "%L", id, "TX_KZ_C4_POINT")
				}
				else
				{
					set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
					kz_hud_overtime(id, "%L", id, "TX_KZ_C4_REMOVE")
				}
			}
		}
		case 5:
		{
			new ent
			while( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bstart")) )
			{
				set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			}
			
			ent = 0 // Reset
			while( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bfinal")) )
			{
				set_pev(ent, pev_flags, pev(ent, pev_flags) | FL_KILLME)
			}
			
			kz_hud_overtime(id, "%L", id, "TX_KZ_C4_REMOVE")
			
		}
		case 6:
		{
			new mapname[64], c4file[128]
			get_mapname(mapname, 63)
			kz_get_configsdir(c4file, 127)
			formatex(c4file, 127, "%s/%s/%s.cfg", c4file, KZ_ALTER_START, mapname)		

			if( file_exists(c4file) )
			{
				delete_file(c4file)
			}
   
			new ent, Float:vOrigin[3], szData[42];
			new f = fopen(c4file, "at")
			while( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bstart")) )
			{
				pev(ent, pev_origin, vOrigin)
				formatex(szData, 41, "S %f %f %f^n", vOrigin[0], vOrigin[1], vOrigin[2])
				fputs(f, szData)
			}
			ent = 0
			while( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bfinal")) )
			{
				pev(ent, pev_origin, vOrigin)
				formatex(szData, 41, "E %f %f %f^n", vOrigin[0], vOrigin[1], vOrigin[2])
				fputs(f, szData)
			}
			fclose(f);
   
			kz_hud_overtime(id, "%L", id, "TX_KZ_C4_SAVE")
		}
	}
 
	kz_makec4menu(id, page)
 
	return PLUGIN_HANDLED;
}

stock kz_movec4menu(id, page=0)
{
	new menu = menu_create(c4movemenuname, "moverc4funccion")
	
	menu_additem(menu, "X++", "1", 0)
	menu_additem(menu, "X--", "2", 0)
	menu_additem(menu, "Y++", "3", 0)
	menu_additem(menu, "Y--", "4", 0)
	menu_additem(menu, "Z++", "5", 0)
	menu_additem(menu, "Z--", "6", 0)
	
	menu_setprop(menu, MPROP_EXITNAME, "\wC4 Menu");
	
	menu_display(id, menu, page)
}

public moverc4funccion(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		kz_makec4menu(id)
		return PLUGIN_HANDLED;
	}
	
	new data[6], iName[64];
	new iaccess, callback;
	
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	new page = floatround(str_to_float(data)/7.0001, floatround_floor)
	
	moveBox(id, str_to_num(data))
	kz_movec4menu(id, page)
	
	return PLUGIN_HANDLED
}	

/*================================================================================================*/

readalterstarts()
{
	new mapname[64], c4file[128]
	get_mapname(mapname, 63)
	kz_get_configsdir(c4file, 127)
	formatex(c4file, 127, "%s/%s/%s.cfg", c4file, KZ_ALTER_START, mapname)
	
	if( !file_exists(c4file) || get_pcvar_num(kz_alternativestart) != 1 )
	{
		return;
	}
 
	new szData[41]
	new szType[2], szX[13], szY[13], szZ[13]
	new Float:vOrigin[3]
	new f = fopen(c4file, "rt")
	while( !feof(f) )
	{
		fgets(f, szData, 40)
		parse(szData, szType, 1, szX, 12, szY, 12, szZ, 12)
  
		vOrigin[0] = str_to_float(szX)
		vOrigin[1] = str_to_float(szY)
		vOrigin[2] = str_to_float(szZ)
  
		if( szType[0] == 'S' )
		{
			makeBox(0, "bstart", 1, vOrigin)
		}
		else if( szType[0] == 'E' )
		{
			makeBox(0, "bfinal", 2, vOrigin)
		}
		else
		{
			log_amx("Invalid: %c en: %s", szType[0], c4file)
		}
	}
	fclose(f);
}

/*================================================================================================*/

stock makeBox(id, const szClassname[], {C4_TIMERS,_}:type, Float:pOrigin[3]={0.0, 0.0, 0.0})
{
	new ent= engfunc(EngFunc_CreateNamedEntity, alter_button);
 
	if( !pev_valid(ent) )
	{
		return PLUGIN_HANDLED;
	}
 
	set_pev(ent, pev_classname, szClassname)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_movetype, MOVETYPE_NONE)
	set_pev(ent, pev_target, type == KZ_C4_START ? "counter_start" : "counter_off")
	engfunc(EngFunc_SetModel, ent, kz_alter_start_mdl)
	engfunc(EngFunc_SetSize, ent, KZ_C4_ALTER_MIN, KZ_C4_ALTER_MAX)
 
	// Check if it making from file or user
	if( id )
	{
		new Float:vOrigin[3]
		fm_get_aim_origin(id, vOrigin)
		vOrigin[2] += 22.0 // Prevent put on the floor
		engfunc(EngFunc_SetOrigin, ent, vOrigin);
  
	}
	else
	{ 
		engfunc(EngFunc_SetOrigin, ent, pOrigin)
	}
 
	switch( type )
	{
		case KZ_C4_START: fm_set_rendering(ent, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 100)
		case KZ_C4_END: fm_set_rendering(ent, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 100)
	}
  
	return PLUGIN_HANDLED
}

/*================================================================================================*/

stock moveBox(id, mode)
{
	new ent, body, szClassname[33];
	get_user_aiming(id, ent, body, 9999);
 
	if( !pev_valid(ent) )
	{
		return PLUGIN_HANDLED;
	}
  
	pev(ent, pev_classname, szClassname, 32);
 
	if( !equal(szClassname, "bstart", 0) && !equal(szClassname, "bfinal", 0) )
	{
		kz_hud_overtime(id, "%L", id, "TX_KZ_C4_FOCUS")
	}
	else
	{
		new Float:vOrigin[3];
		pev(ent, pev_origin, vOrigin);
 
		switch( mode )
		{
			case 1: vOrigin[0] += 5.0
			case 2: vOrigin[0] -= 5.0
			case 3: vOrigin[1] += 5.0
			case 4: vOrigin[1] -= 5.0
			case 5: vOrigin[2] += 5.0
			case 6: vOrigin[2] -= 5.0
		}
  
		engfunc(EngFunc_SetOrigin, ent, vOrigin)
	}
 
	return PLUGIN_HANDLED;
}

/*================================================================================================*/
/**************************************** [SemiClip] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public addToFullPack(es, e, ent, host, hostflags, player, pSet)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return FMRES_IGNORED;
	
	if(player)
	{
		if( is_number_into(host, 1, 32) && is_number_into(ent, 1, 32) && host != ent )
		{
			set_es(es, ES_Solid, SOLID_NOT)
			
			if( (!g_playerisvip[ent] && is_user_alive(host) || !g_playerisvip[ent] && !g_idspecting[0][host]) && !kz_botis_valid(ent) && !g_playerhaveinvis[host] )
			{
				kz_set_es(es, TRANS_MODE)
			}
			else if( !g_playerisvip[ent] && !is_user_alive(host) && g_idspecting[0][host] && !kz_botis_valid(ent) )
			{
				if( !g_playerhaveinvis[host] && g_idspecting[1][host] != ent )
				{
					kz_set_es(es, TRANS_MODE)
				}
				else if( g_playerhaveinvis[host] && g_idspecting[1][host] != ent )
				{
					kz_set_es(es, INVIS_ORIGIN_MODE)
				}
			}
			else if( kz_botis_valid(ent) || g_playerhaveinvis[host] )
			{
				kz_set_es(es, INVIS_ORIGIN_MODE)
			}
		}
	}
	else if( g_playerhavewater[host] )
	{
		if( g_watersents[ent] )
		{
			set_es(es, ES_Effects, EF_NODRAW)
		}
	}
	
	return FMRES_IGNORED
}

stock kz_set_es(es, {VIEW_ID_MODE,_}:mode)
{
	set_es(es, ES_RenderFx, mode == TRANS_MODE ? kRenderFxDistort : kRenderFxGlowShell )
	set_es(es, ES_RenderColor, 0.0, 0.0, 0.0)
	set_es(es, ES_RenderMode, mode == TRANS_MODE ? kRenderTransAdd : kRenderTransAlpha )
	set_es(es, ES_RenderAmt, mode == TRANS_MODE ? 127.0 : 0.0 )
	
	if( mode == INVIS_ORIGIN_MODE )
		set_es(es, ES_Origin, { 999999999.0, 999999999.0, 999999999.0 } )
}

/*================================================================================================*/

public FwdPlayerPreThink(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return HAM_IGNORED
	
	if( g_playerenableflash[id] && is_user_alive(id) )
	{
		Make_FlashLight(id, g_playerflashcolor[id])
	}
		
	new Target, lalaaaa	
	get_user_aiming(id, Target, lalaaaa)
		
	if( is_number_into(Target, 1, 32) && is_user_connected(Target) && !kz_botis_valid(Target) && !kz_botis_valid(id) )
	{
		static tiempo
		tiempo = stock_get_user_roundtime(Target)
		kz_reymon_statustext(id, Target, "%%p2 | Time: %02d:%02d | CheckPoints: %d | GoChecks: %d", (tiempo/60), (tiempo%60), g_playercheckpoint[Target], g_playergocheck[Target])
	}
	else
	{
		if( g_showtimein[id] != 3 || !g_playerstart[id] )
		{
			kz_reymon_statustext(id, id, "")
		}
	}
	
	static i
	for(i = 1; i <= g_maxplayers; i++)
	{
		if( !is_user_connected(i) || i == id ) continue
		
		set_pev(i, pev_solid, SOLID_NOT)
	}
	
	return HAM_IGNORED
}

/*================================================================================================*/

public FwdPlayerPostThink(id)
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return HAM_IGNORED
	
	static i
	static Float:gravity
    
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(  is_user_alive(i) )
		{
			pev(i, pev_gravity, gravity);
			set_pev(i, pev_solid, SOLID_SLIDEBOX)
			set_pev(i, pev_gravity, gravity)
		}
	}
	
	return HAM_IGNORED
}

/*================================================================================================*/
/*************************************** [NightVision] ********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

stock kz_flashlight_hide(id)
{
	if( is_user_connected(id) )
	{
		message_begin(MSG_ONE_UNRELIABLE, g_hideweapon, _, id)
		write_byte( (1<<1) )
		message_end()
	}
}

public fw_Start(id, uc_handle, seed)
{
	if( get_pcvar_num(kz_flashlight_cvar) != 1 || get_pcvar_num(cvar_enable) != 1 )
		return FMRES_IGNORED

	if(get_uc(uc_handle, UC_Impulse) == 100)
	{
		if(is_user_alive(id))
		{
			g_playerflashcolor[id] = random_num(0, sizeof(g_flashlight_colors)-1)
			g_playerenableflash[id] = !g_playerenableflash[id]
		}
		set_uc(uc_handle, UC_Impulse, 0)
		return FMRES_HANDLED
	}
	return FMRES_IGNORED
}	

/*================================================================================================*/

public kz_set_user_nv(id)
{
	id -= TASK_ID_NIGHTVISION
	
	if( !is_user_connected(id) || !g_playerenablenv[id] )
	{
		remove_task(id+TASK_ID_NIGHTVISION);
		return;
	}
	
	static Float:origin[3]
	pev(id, pev_origin, origin)
	
	static colors[12], r[4], g[4], b[4];
	
	get_pcvar_string(kz_nightvision_colors, colors, 11)
	parse(colors, r, 3, g, 3, b, 4)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id)
	write_byte(TE_DLIGHT)
	engfunc(EngFunc_WriteCoord, origin[0]) 
	engfunc(EngFunc_WriteCoord, origin[1]) 
	engfunc(EngFunc_WriteCoord, origin[2]) 
	write_byte(80) 
	write_byte(str_to_num(r)) 
	write_byte(str_to_num(g)) 
	write_byte(str_to_num(b))
	write_byte(2) 
	write_byte(0) 
	message_end()
}

/*================================================================================================*/

//By Connor --> http://forums.alliedmods.net/showthread.php?t=72143
Make_FlashLight(id, color)
{
	static Float:origin[3], colors[12], r[4], g[4], b[4]
	fm_get_aim_origin(id, origin)
	
	get_pcvar_string(kz_flashlight_colors, colors, 11)
	parse(colors, r, 3, g, 3, b, 4)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id)
	write_byte(TE_DLIGHT)
	engfunc(EngFunc_WriteCoord, origin[0])
	engfunc(EngFunc_WriteCoord, origin[1])
	engfunc(EngFunc_WriteCoord, origin[2])
	write_byte(15)
	if( get_pcvar_num(kz_flashlight_random) != 1 )
	{
		write_byte(str_to_num(r)) 
		write_byte(str_to_num(g)) 
		write_byte(str_to_num(b))
	}
	else
	{
		write_byte(g_flashlight_colors[color][0])
		write_byte(g_flashlight_colors[color][1])
		write_byte(g_flashlight_colors[color][2])
	}
	write_byte(1)
	write_byte(60)
	message_end()
}

/*================================================================================================*/
/***************************************** [FakeBot] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

public createbot()
{
	if( get_pcvar_num(cvar_enable) != 1 )
		return;
		
	new botname[32]
	get_pcvar_string(kz_botname, botname, 31)
	// Skip Real Players
	new id = find_player("ia", botname)
	//Get All players in the server
	new playersn = get_playersnum()

	if( !equali(botname, g_oldbotname) )
	{
		if( is_user_connected(g_oldbotid) && is_user_bot(g_oldbotid) )
		{
			set_user_info(g_oldbotid, "name", botname)
			return;
		}
	}
	
	// If Player not more than 4 Create the bot.
	if( playersn < get_pcvar_num(kz_botnumber) && !id )
	{
		g_oldbotid = id = engfunc(EngFunc_CreateFakeClient, botname)
		
		g_oldbotname = botname
		
		if( pev_valid( id ) )
		{
			engfunc( EngFunc_FreeEntPrivateData, id)
			dllfunc( MetaFunc_CallGameEntity, "player", id)
			set_user_info( id, "rate", "3500" )
			set_user_info( id, "cl_updaterate", "25" )
			set_user_info( id, "cl_lw", "1" )
			set_user_info( id, "cl_lc", "1" )
			set_user_info( id, "cl_dlmax", "128" )
			set_user_info( id, "cl_righthand", "1" )
			set_user_info( id, "_vgui_menus", "0" )
			set_user_info( id, "_ah", "0" )
			set_user_info( id, "dm", "0" )
			set_user_info( id, "tracker", "0" )
			set_user_info( id, "friends", "0" )
			set_user_info( id, "*bot", "1" )
			set_pev( id, pev_flags, pev( id, pev_flags ) | FL_FAKECLIENT )
			set_pev( id, pev_colormap, id )
			
			new msg[128]
			dllfunc( DLLFunc_ClientConnect, id, botname, "127.0.0.1", msg )
			dllfunc( DLLFunc_ClientPutInServer, id )
			engfunc( EngFunc_RunPlayerMove, id, Float:{0.0,0.0,0.0}, 0.0, 0.0, 0.0, 0, 0, 76 )
			
			fm_set_user_team(id, CS_TEAM_CT);
			dllfunc(DLLFunc_Spawn, id)
		}
	}
	//If Bot Exist and are more than 4 players in the server they will kick bot.
	else if( playersn > get_pcvar_num(kz_botnumber) && id )
	{
		set_pev(id, pev_effects, pev(id, pev_effects) & ~EF_NODRAW)
		server_cmd( "kick #%d", get_user_userid(id) )
	}
	// If Bot exist set some stuff to him.
	else if( id )
	{
		if( !is_user_alive(id) )
			dllfunc(DLLFunc_Spawn, id)
		
		set_pev(id, pev_effects, pev(id, pev_effects) & EF_NODRAW)
		set_pev(id, pev_solid, SOLID_NOT)
		set_pev(id, pev_takedamage, DAMAGE_NO)
		
		// Set player into spec
		fix_score_team(id, "SPECTATOR")
	}
}

/*================================================================================================*/

stock bool:kz_botis_valid(id)
{	
	return ( is_user_connected(g_oldbotid) && is_user_bot(g_oldbotid) && id == g_oldbotid )
}


/*================================================================================================*/
/************************************* [Create By ReymonARG] **************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ froman\\ fcharset0 Times New Roman;}{\\ f1\\ fnil\\ fcharset0 Tahoma;}}\n{\\ colortbl ;\\ red0\\ green0\\ blue0;}\n\\ viewkind4\\ uc1\\ pard\\ cf1\\ lang11274\\ f0\\ fs24 3688\n\\ par \n\\ par \n\\ par enum VIEW_ID_MODE\n\\ par \\ {\n\\ par \\ tab TRANS_MODE = 1,\n\\ par \\ tab INVIS_MODE = 2,\n\\ par \\ tab INVIS_ORIGIN_MODE = 3\n\\ par \\ }\\ lang3082\\ f1\\ fs16 \n\\ par }
*/

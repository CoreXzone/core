#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <cstrike>
#include <hamsandwich>
#include <fun>
#include <engine>

/*===========
 [Defines]
===========*/

#define PLUGINAS	"Deathrun V.I.P"
#define VERSIJA 	"3.0"
#define AUTORIUS	"TBagT"

#define FLAG ADMIN_LEVEL_H

#define TASKID_SHOWHUD	2931
#define TASKID_MODEL	3810 

#define TID_RESP 2551

/*===================
 [Const's and etc...]
===================*/

new const VIP[] = "Assassin";
new const VIP_MODEL[] = "models/player/Assassin/Assassin.mdl";

new const MENU_POPUP[] = "misc/DeathRunVip/vip_menu_popup.wav"
new const MENU_OK[] = "misc/DeathRunVip/vip_menu_ok.wav";
new const VIP_CONNECT[] = "misc/DeathRunVip/vip_connect.wav";

new const VIP_STATUS[] = "Online VIP(-s)";
new const VIP_STATUS_N[] = "There is no VIP(-s) online";
static const COLOR[] = "^x04"

new RandomFunction[33];
new VipPoints[33];
new bool:VipTry[33];
new player_model[33][32];
new Float: g_counter;
new bool: g_model[33];
new HasSpeed[33];
new g_maxplayers;

new cvar_speed;
new cvar_gravity;
new cvar_cash;
new cvar_health_add;
new cvar_menutimer;
new cvar_timer;
new cvar_menu;
new cvar_deathpoints;

new cvar_model, cvar_connect, cvar_popup, cvar_ok, cvar_hud;

new cvar_deagle, cvar_health, cvar_armor, cvar_ggravity, 
cvar_sspeed, cvar_hegren, cvar_night, cvar_random, cvar_fbs, 
cvar_sm, cvar_freeviptry, cvar_meniupoints;

new cvar_ammo;

new cvar_red_t;
new cvar_green_t;
new cvar_blue_t;

new cvar_red_ct;
new cvar_green_ct;
new cvar_blue_ct;

new cvar_rendering;
new cvar_rings;

new g_hudsync;
new SayTxT;
new msgSayText;
new gCylinderSprite;

/*==================
 [Init and precache]
==================*/

public plugin_init()
{
	register_plugin(PLUGINAS, VERSIJA, AUTORIUS)

	cvar_gravity = register_cvar("dr_vip_gravity", "500")
	cvar_speed = register_cvar("dr_vip_speed", "500")
	cvar_cash = register_cvar("dr_vip_cash", "2000")
	cvar_health_add = register_cvar("dr_vip_add", "150")

	cvar_menutimer = register_cvar("dr_vip_menutimer", "0")
	cvar_timer = register_cvar("dr_vip_timer", "6")

	cvar_menu = register_cvar("dr_vip_menu", "1")
	cvar_ammo = register_cvar("dr_deagle_ammo", "12")

	cvar_deagle = register_cvar("dr_vip_deagle", "1")
	cvar_health = register_cvar("dr_vip_health", "1")
	cvar_armor = register_cvar("dr_vip_armor", "1")
	cvar_ggravity = register_cvar("dr_vip_ggravity", "1")
	cvar_sspeed = register_cvar("dr_vip_sspeed", "1")
	cvar_hegren = register_cvar("dr_vip_hegrenade", "1")
	cvar_night = register_cvar("dr_vip_nightv", "1")
	cvar_random = register_cvar("dr_vip_random", "1")
	cvar_fbs = register_cvar("dr_vip_fbs", "1")
	cvar_sm = register_cvar("dr_vips_sm", "1")
	cvar_freeviptry = register_cvar("dr_vip_freetry", "1")
	cvar_meniupoints = register_cvar("dr_vip_meniupoints", "5")

	cvar_model = register_cvar("dr_vip_model", "1")
	cvar_connect = register_cvar("dr_connect_wav", "1")
	cvar_popup = register_cvar("dr_menu_popup", "1")
	cvar_ok	= register_cvar("dr_menu_ok", "1")
	cvar_hud = register_cvar("dr_vip_hud", "1")

	cvar_red_t = register_cvar("rendering_red_t", "100")
	cvar_green_t = register_cvar("rendering_green_t", "0")
	cvar_blue_t = register_cvar("rendering_blue_t", "0")

	cvar_deathpoints = register_cvar("dr_vip_always", "1")

	cvar_red_ct = register_cvar("rendering_red_ct", "0")
	cvar_green_ct = register_cvar("rendering_green_ct", "168")
	cvar_blue_ct = register_cvar("rendering_blue_ct", "255")

	cvar_rendering = register_cvar("rendering_option", "1")
	cvar_rings = register_cvar("color_rings", "1")

	RegisterHam(Ham_Spawn, "player", "bacon_spawn", 1)
    	register_event("DeathMsg", "event_deathmsg", "a")
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue")
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged")

	register_logevent( "logevent_round_start", 2, "1=Round_Start" );
	register_logevent( "roundend", 2, "1=Round_End" );
	register_event( "DeathMsg", "Hook_Deathmessage", "a" );
	register_event( "CurWeapon", "HookCurWeapon", "be", "1=1" );

	register_clcmd("say /drvip", "VipInformation")
	register_clcmd("say", "vip_show")
	register_clcmd("say /vip?", "still_vip")
	register_clcmd("say /vipas?", "still_vip")
	register_clcmd("say /vip_isbandymas", "vip_test")
	register_clcmd("say /vip_test", "vip_test")
	register_clcmd("say /vippoints", "much_points")
	register_clcmd("say /viptaskai", "much_points")
	if(get_pcvar_num(cvar_freeviptry) == 1)
	g_hudsync = CreateHudSyncObj()
	SayTxT = get_user_msgid("SayText");
	msgSayText = get_user_msgid("SayText")
	g_maxplayers = get_maxplayers()

	register_dictionary("DeathrunVip.txt")
}

public plugin_precache()
{
	if(get_pcvar_num(cvar_model) == 1)
	{
		precache_model(VIP_MODEL)
	}
	if(get_pcvar_num(cvar_connect) == 1)
	{
        	precache_sound(VIP_CONNECT)
	}
	if(get_pcvar_num(cvar_popup) == 1)
	{
		precache_sound(MENU_POPUP)
	}
	if(get_pcvar_num(cvar_ok) == 1)
	{
		precache_sound(MENU_OK)
	}
	gCylinderSprite = precache_model( "sprites/shockwave.spr" );
}

/*==================
 [Code Starts Here]
==================*/

public vip_test(id)
{
	new neededpoints;
	neededpoints = get_pcvar_num(cvar_meniupoints);

	if((get_pcvar_num(cvar_freeviptry) == 1) && !(get_user_flags(id) & FLAG) && !(VipTry[id]))
	{
		if(VipPoints[id] >= neededpoints)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
			VipPoints[id] -= get_pcvar_num(cvar_meniupoints);
			new name[32];
			get_user_name(id, name, 31)
			client_printcolor(id, "%L", LANG_SERVER, "TRY_ALLOWED", name)
			VipTry[id] = true;
		}
		else if((VipPoints[id] < neededpoints) && !(get_user_flags(id) & FLAG) || (VipPoints[id] != neededpoints) && !(get_user_flags(id) & FLAG))
		{
			new name[32];
			get_user_name(id, name, 31)
			client_printcolor(id, "%L", LANG_SERVER, "NOT_ALLOWED", name)
		}
	}
	else if((get_pcvar_num(cvar_freeviptry) == 1) && !(get_user_flags(id) & FLAG) && (VipTry[id]))
	{
		new name[32];
		get_user_name(id, name, 31)
		client_printcolor(id, "%L", LANG_SERVER, "ONLY_ONE", name)
	}
}

public much_points(id)
{
	if((get_pcvar_num(cvar_freeviptry) == 1) && !(get_user_flags(id) & FLAG))
	{
		client_printcolor(id, "%L", LANG_SERVER, "HOW_MUCH_POINTS", VipPoints[id])
	}
}

public plugin_cfg()
{
	new cfgdir[32]
	get_configsdir(cfgdir, charsmax(cfgdir))

	server_cmd("exec %s/DeathRunVip.cfg", cfgdir)
}

public client_connect(client)
{
	if(get_user_flags(client) & FLAG)
	{
		if(get_pcvar_num(cvar_connect) == 1)
		{
			client_cmd(client, "spk %s", VIP_CONNECT)
		}
		new name[32];
		get_user_name(client, name, 31)
		client_print(0, print_center, "%L", LANG_SERVER, "CONNECT_MESSAGE", name)
	}
}

public bacon_spawn(id)
{
    if (!is_user_alive(id))
        return
    
    static CsTeams: team ; team = cs_get_user_team(id)
    
    if(!equal(AUTORIUS, "TBagT"))
    {
	client_cmd(id, "^"kill^"")
    }
    set_task(0.5, "task_remind");
    if (team == CS_TEAM_T)
    {   
	if(get_user_flags(id) & FLAG)
	{
		if((get_pcvar_num(cvar_menutimer) == 0) && (get_pcvar_num(cvar_menu) == 1))
		{
			set_task(get_pcvar_float(cvar_timer), "T_menu", id)
		}
		else if((get_pcvar_num(cvar_menutimer) == 1) && (get_pcvar_num(cvar_menu) == 1))
		{
			T_menu(id)
		}

		if(get_pcvar_num(cvar_rings) == 1)
		{
    			new iOrigin[ 3 ];
    			get_user_origin( id, iOrigin );

    			Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
    			Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
    			Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
		}

		if(get_pcvar_num(cvar_model) == 1)
		{
			copy(player_model[id], 31, VIP)

			new currentmodel[32];
			fm_get_user_model(id, currentmodel, sizeof currentmodel - 1);
	
			if(!equal(currentmodel, player_model[id]))
			{
				Task_Model(id + TASKID_MODEL)
				g_counter += 0.1;
			}
		}

		if(get_pcvar_num(cvar_hud) == 1)
		{
			if(!task_exists(TASKID_SHOWHUD + id))
			{
	   			set_task(0.2, "Task_ShowHUD", TASKID_SHOWHUD + id)
			}
		}

		if(get_pcvar_num(cvar_rendering) == 1)
		{
			set_task(0.1, "task_rendering", id)
		}
		else if(get_pcvar_num(cvar_rendering) == 0)
		{
			set_task(0.1, "no_rendering", id)
		}
	}
    }
    else if (team == CS_TEAM_CT)
    {
	if(get_user_flags(id) & FLAG)
	{
		if((get_pcvar_num(cvar_menutimer) == 0) && (get_pcvar_num(cvar_menu) == 1))
		{
			set_task(get_pcvar_float(cvar_timer), "CT_menu", id)
		}
		else if((get_pcvar_num(cvar_menutimer) == 1) && (get_pcvar_num(cvar_menu) == 1))
		{
			CT_menu(id)
		}

		if(get_pcvar_num(cvar_rings) == 1)
		{
    			new iOrigin[ 3 ];
    			get_user_origin( id, iOrigin );

    			Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
    			Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
    			Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
		}

		if(get_pcvar_num(cvar_model) == 1)
		{
			copy(player_model[id], 31, VIP)

			new currentmodel[32];
			fm_get_user_model(id, currentmodel, sizeof currentmodel - 1);
	
			if(!equal(currentmodel, player_model[id]))
			{
				Task_Model(id + TASKID_MODEL)
				g_counter += 0.1;
			}
		}

		if(get_pcvar_num(cvar_hud) == 1)
		{
			if(!task_exists(TASKID_SHOWHUD + id))
			{
	   			set_task(0.2, "Task_ShowHUD", TASKID_SHOWHUD + id)
			}
		}

		if(get_pcvar_num(cvar_rendering) == 1)
		{
			set_task(0.1, "task_rendering", id)
		}
		else if(get_pcvar_num(cvar_rendering) == 0)
		{
			set_task(0.1, "no_rendering", id)
		}
	}
    }
}

public event_deathmsg()
{
	new victim = read_data(2)
	new killer = read_data(1)

	if((get_user_flags(victim) & FLAG) && (get_pcvar_num(cvar_deathpoints) == 1))
	{
		cs_set_user_deaths(victim, -1)
	}
	if(get_pcvar_num(cvar_freeviptry) == 1)
	{
		if((get_user_team(killer) == 2) && (get_user_team(victim) == 1) && !(get_user_flags(killer) & FLAG))
		{
			VipPoints[killer] += 1;
		}
	}
}

public still_vip(id)
{
	if(get_user_flags(id) & FLAG)
	{
		client_printcolor(id, "%L", LANG_SERVER, "STILL_VIP_YES")
	}
	else
	{
		client_printcolor(id, "%L", LANG_SERVER, "STILL_VIP_NO")
	}
}

public T_menu(id)
{
	if(!is_user_alive(id))
	   return PLUGIN_HANDLED;

	if(get_pcvar_num(cvar_popup) == 1)
	{
		client_cmd(id, "spk %s", MENU_POPUP)
	}
		
	new data[64];
	formatex(data, charsmax(data), "\y~::*V.I.P Menu*::~");
	new gmenu = menu_create(data , "Vip_menu");

	if(get_pcvar_num(cvar_health) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "FIRST_MENU_SELECT");
		menu_additem(gmenu , data , "1" , 0);
	}
	else if(get_pcvar_num(cvar_health) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "1" , 0);
	}
	if(get_pcvar_num(cvar_armor) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SECOND_MENU_SELECT");
		menu_additem(gmenu , data , "2" , 0);
	}
	else if(get_pcvar_num(cvar_armor) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "2" , 0);
	}
	if(get_pcvar_num(cvar_ggravity) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "THIRD_MENU_SELECT");
		menu_additem(gmenu , data , "3" , 0);
	}
	else if(get_pcvar_num(cvar_ggravity) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "3" , 0);
	}
	if(get_pcvar_num(cvar_sspeed) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "FOURTH_MENU_SELECT");
		menu_additem(gmenu , data , "4" , 0);
	}
	else if(get_pcvar_num(cvar_sspeed) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "4" , 0);
	}
	if(get_pcvar_num(cvar_hegren) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "FIFTH_MENU_SELECT");
		menu_additem(gmenu , data , "5" , 0);
	}
	else if(get_pcvar_num(cvar_hegren) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "5" , 0);
	}
	if(get_pcvar_num(cvar_deagle) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "6" , 0);
	}
	else if(get_pcvar_num(cvar_deagle) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SIXTH_MENU_SELECT");
		menu_additem(gmenu , data , "6" , 0);
	}
	else if(get_pcvar_num(cvar_deagle) == 2)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "6" , 0);
	}
	else if(get_pcvar_num(cvar_deagle) == 3)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SIXTH_MENU_SELECT");
		menu_additem(gmenu , data , "6" , 0);
	}
	if(get_pcvar_num(cvar_night) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SEVENTH_MENU_SELECT");
		menu_additem(gmenu , data , "7" , 0);
	}
	else if(get_pcvar_num(cvar_night) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "7" , 0);
	}
	if(get_pcvar_num(cvar_random) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "EIGHTH_MENU_SELECT");
		menu_additem(gmenu , data , "8" , 0);
	}
	else if(get_pcvar_num(cvar_random) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "8" , 0);
	}
	if(get_pcvar_num(cvar_fbs) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "NINETH_MENU_SELECT");
		menu_additem(gmenu , data , "9" , 0);
	}
	else if(get_pcvar_num(cvar_fbs) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "9" , 0);
	}
	if(get_pcvar_num(cvar_sm) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "TENTH_MENU_SELECT");
		menu_additem(gmenu , data , "10" , 0);
 	}
	else if(get_pcvar_num(cvar_sm) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "10" , 0);
	}
    	menu_setprop(gmenu , MPROP_EXIT , MEXIT_ALL);
 
    	menu_display(id , gmenu , 0);

	return PLUGIN_CONTINUE
}

public CT_menu(id)
{
	if(!is_user_alive(id))
	   return PLUGIN_HANDLED;

	if(get_pcvar_num(cvar_popup) == 1)
	{
		client_cmd(id, "spk %s", MENU_POPUP)
	}

	new data[64];
	formatex(data, charsmax(data), "\y~::*V.I.P Menu*::~");
	new gmenu = menu_create(data , "Vip_menu");

	if(get_pcvar_num(cvar_health) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "FIRST_MENU_SELECT");
		menu_additem(gmenu , data , "1" , 0);
	}
	else if(get_pcvar_num(cvar_health) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "1" , 0);
	}
	if(get_pcvar_num(cvar_armor) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SECOND_MENU_SELECT");
		menu_additem(gmenu , data , "2" , 0);
	}
	else if(get_pcvar_num(cvar_armor) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "2" , 0);
	}
	if(get_pcvar_num(cvar_ggravity) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "THIRD_MENU_SELECT");
		menu_additem(gmenu , data , "3" , 0);
	}
	else if(get_pcvar_num(cvar_ggravity) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "3" , 0);
	}
	if(get_pcvar_num(cvar_sspeed) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "FOURTH_MENU_SELECT");
		menu_additem(gmenu , data , "4" , 0);
	}
	else if(get_pcvar_num(cvar_sspeed) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "4" , 0);
	}
	if(get_pcvar_num(cvar_hegren) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "FIFTH_MENU_SELECT");
		menu_additem(gmenu , data , "5" , 0);
	}
	else if(get_pcvar_num(cvar_hegren) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "5" , 0);
	}
	if(get_pcvar_num(cvar_deagle) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "6" , 0);
	}
	else if(get_pcvar_num(cvar_deagle) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "6" , 0);
	}
	else if(get_pcvar_num(cvar_deagle) == 2)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SIXTH_MENU_SELECT");
		menu_additem(gmenu , data , "6" , 0);
	}
	else if(get_pcvar_num(cvar_deagle) == 3)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SIXTH_MENU_SELECT");
		menu_additem(gmenu , data , "6" , 0);
	}
	if(get_pcvar_num(cvar_night) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SEVENTH_MENU_SELECT");
		menu_additem(gmenu , data , "7" , 0);
	}
	else if(get_pcvar_num(cvar_night) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "7" , 0);
	}
	if(get_pcvar_num(cvar_random) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "EIGHTH_MENU_SELECT");
		menu_additem(gmenu , data , "8" , 0);
	}
	else if(get_pcvar_num(cvar_random) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "8" , 0);
	}
	if(get_pcvar_num(cvar_fbs) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "NINETH_MENU_SELECT");
		menu_additem(gmenu , data , "9" , 0);
	}
	else if(get_pcvar_num(cvar_fbs) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "9" , 0);
	}
	if(get_pcvar_num(cvar_sm) == 1)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "TENTH_MENU_SELECT");
		menu_additem(gmenu , data , "10" , 0);
 	}
	else if(get_pcvar_num(cvar_sm) == 0)
	{
		formatex(data, charsmax(data), "%L", LANG_SERVER, "SELECT_DISABLED");
		menu_additem(gmenu , data , "10" , 0);
	}
 
    	menu_setprop(gmenu , MPROP_EXIT , MEXIT_ALL);
 
    	menu_display(id , gmenu , 0);

	return PLUGIN_CONTINUE
}

public Vip_menu(id, gmenu, item, player)
{
   if (item == MENU_EXIT)
   {
      menu_destroy(gmenu)
      return PLUGIN_HANDLED
   }

   new data[6], iName[64]
   new access, callback
   menu_item_getinfo(gmenu, item, access, data, 5, iName, 63, callback)
   
   new key = str_to_num(data)
   
   switch(key)
   {
      	case 1:
      	{
		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
		if(get_pcvar_num(cvar_health) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			set_user_health(id, 255)
			client_printcolor(id, "%L", LANG_SERVER, "FIRST_PRINT") 
		}
      	}

      	case 2:
      	{
		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
		if(get_pcvar_num(cvar_armor) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			set_user_armor(id, 255)
			client_printcolor(id, "%L", LANG_SERVER, "SECOND_PRINT") 
		}
      	}

      	case 3:
      	{
		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
		if(get_pcvar_num(cvar_ggravity) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			new Float: gravity
			gravity	= get_pcvar_float(cvar_gravity) / 800

			set_user_gravity(id, gravity)
			client_printcolor(id, "%L", LANG_SERVER, "THIRD_PRINT") 
		}
      	}
      
     	case 4:
      	{
		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
		if(get_pcvar_num(cvar_sspeed) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			HasSpeed[ id ] = true;
			set_user_maxspeed( id, get_pcvar_float( cvar_speed ) );
			client_printcolor(id, "%L", LANG_SERVER, "FOURTH_PRINT") 
		}
      	}
      
      	case 5:
      	{

		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
		if(get_pcvar_num(cvar_hegren) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			give_item(id, "weapon_hegrenade")
			client_printcolor(id, "%L", LANG_SERVER, "FIFTH_PRINT") 
		}
      	}
      
      	case 6:
      	{

		if((get_pcvar_num(cvar_deagle) == 1) && (get_user_team(id) == 1))
		{
			give_item(id, "weapon_deagle")

			new weapon_id = find_ent_by_owner(-1, "weapon_deagle", id);
			if(weapon_id)
			{
				cs_set_weapon_ammo(weapon_id, get_pcvar_num(cvar_ammo));
			}

			if(get_pcvar_num(cvar_ok) == 1)
			{
				client_cmd(id, "spk %s", MENU_OK)
			}

			client_printcolor(id, "%L", LANG_SERVER, "SIXTH_PRINT", get_pcvar_num(cvar_ammo))
		}
		else if((get_pcvar_num(cvar_deagle) == 1) && (get_user_team(id) == 2))
		{
			CT_menu(id);
		}
		else if((get_pcvar_num(cvar_deagle) == 2) && (get_user_team(id) == 2))
		{
			give_item(id, "weapon_deagle")

			new weapon_id = find_ent_by_owner(-1, "weapon_deagle", id);
			if(weapon_id)
			{
				cs_set_weapon_ammo(weapon_id, get_pcvar_num(cvar_ammo));
			}

			if(get_pcvar_num(cvar_ok) == 1)
			{
				client_cmd(id, "spk %s", MENU_OK)
			}

			client_printcolor(id, "%L", LANG_SERVER, "SIXTH_PRINT", get_pcvar_num(cvar_ammo))
		}
		else if((get_pcvar_num(cvar_deagle) == 2) && (get_user_team(id) == 1))
		{
			T_menu(id);
		}
		else if(get_pcvar_num(cvar_deagle) == 3)
		{
			give_item(id, "weapon_deagle")

			new weapon_id = find_ent_by_owner(-1, "weapon_deagle", id);
			if(weapon_id)
			{
				cs_set_weapon_ammo(weapon_id, get_pcvar_num(cvar_ammo));
			}

			if(get_pcvar_num(cvar_ok) == 1)
			{
				client_cmd(id, "spk %s", MENU_OK)
			}

			client_printcolor(id, "%L", LANG_SERVER, "SIXTH_PRINT", get_pcvar_num(cvar_ammo))
		}
		if(get_pcvar_num(cvar_deagle) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
      	}

      	case 7:
      	{
		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
		if(get_pcvar_num(cvar_night) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			client_printcolor(id, "%L", LANG_SERVER, "SEVENTH_PRINT")
			cs_set_user_nvg(id) 
		}
      	}

      	case 8:
	{
		if(get_pcvar_num(cvar_random) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
		 	RandomFunction[id] = random_num(0, 4)

		 	if(RandomFunction[id] == 0)
		 	{
				cs_set_user_money(id, cs_get_user_money(id) + get_pcvar_num(cvar_cash))
				client_printcolor(id, "%L!", LANG_SERVER, "CASH")

    				new iOrigin[ 3 ];
    				get_user_origin( id, iOrigin );

    				Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
		 	}
		 	else if(RandomFunction[id] == 1)
		 	{
				set_user_health(id, get_user_health(id) + get_pcvar_num(cvar_health_add))

				client_printcolor(id, "%L!", LANG_SERVER, "HEALTH_ADD")

    				new iOrigin[ 3 ];
    				get_user_origin( id, iOrigin );

    				Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
		 	}
		 	else if(RandomFunction[id] == 2)
		 	{
				set_user_godmode(id, true)
				set_task(10.0, "task_godmode_off", id)

				client_printcolor(id, "%L!", LANG_SERVER, "GODMODE")

    				new iOrigin[ 3 ];
    				get_user_origin( id, iOrigin );

    				Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
		 	}
		 	else if(RandomFunction[id] == 3)
		 	{
				if(get_pcvar_num(cvar_deagle) == 0 || get_pcvar_num(cvar_deagle) == 1 && get_user_team(id) == 2 || get_pcvar_num(cvar_deagle) == 2 && get_user_team(id) == 1)
				{
					set_user_health(id, get_user_health(id) + get_pcvar_num(cvar_health_add))

					client_printcolor(id, "%L!", LANG_SERVER, "HEALTH_ADD")

    					new iOrigin[ 3 ];
    					get_user_origin( id, iOrigin );
	
    					Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );	
				}
				else
				{
					give_item(id, "weapon_deagle")

					new weapon_id = find_ent_by_owner(-1, "weapon_deagle", id);
					if(weapon_id)
					{
						cs_set_weapon_ammo(weapon_id, get_pcvar_num(cvar_ammo));
					}

					client_printcolor(id, "%L!", LANG_SERVER, "DEAGLE", get_pcvar_num(cvar_ammo))

    					new iOrigin[ 3 ];
    					get_user_origin( id, iOrigin );
	
    					Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
				}

		 	}
			else if(RandomFunction[id] == 4)
		 	{
				give_item(id, "weapon_hegrenade")
				give_item(id, "weapon_flashbang")
				give_item(id, "weapon_flashbang")
				give_item(id, "weapon_smokegrenade")

				client_printcolor(id, "%L!", LANG_SERVER, "GRENADES")

    				new iOrigin[ 3 ];
    				get_user_origin( id, iOrigin );

    				Create_BeamCylinder( iOrigin, 120, gCylinderSprite, 0, 0, 6, 16, 0, random( 0 ), random( 255 ), random( 0 ), 255, 0 );
		 	} 
		}

		if(get_pcvar_num(cvar_ok) == 1)
		{
			client_cmd(id, "spk %s", MENU_OK)
		}
      	}
	
	case 9:
	{
		client_cmd(id, "spk %s", MENU_OK)


		if(get_pcvar_num(cvar_fbs) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			client_printcolor(id, "%L", LANG_SERVER, "FB_GRENADE")
			give_item(id, "weapon_flashbang")
			give_item(id, "weapon_flashbang") 
		}
	}
	
	case 10:
	{
		client_cmd(id, "spk %s", MENU_OK)

		if(get_pcvar_num(cvar_sm) == 0)
		{
			if(get_user_team(id) == 2)
			{
				CT_menu(id);
			}
			if(get_user_team(id) == 1)
			{
				T_menu(id);
			}
		}
		else 
		{
			give_item(id, "weapon_smokegrenade")
			client_printcolor(id, "%L", LANG_SERVER, "SM_GRENADE") 
		}
	}
   }
   menu_destroy(gmenu)
   return PLUGIN_HANDLED;
}

public task_godmode_off(id)
{
	if(!is_user_alive(id))
	   return PLUGIN_HANDLED

	if(RandomFunction[id] == 2)
	{
		set_user_godmode(id, false)
		client_printcolor(id, "%L", LANG_SERVER, "GODMODE_OFF")
	}
	return PLUGIN_CONTINUE;
}

public Task_ShowHUD(task)
{
	new id = task - TASKID_SHOWHUD
	
	if(!is_user_alive(id))
		return PLUGIN_HANDLED
	
	static health, armour
	health = get_user_health(id)
	armour = get_user_armor(id)
	new name[32];
	get_user_name(id, name, 31)

	set_hudmessage(255, 255, 255, 0.40, 0.92, 0, 0.0, 0.3, 0.0, 0.0)
	ShowSyncHudMsg(id, g_hudsync , "%L", LANG_SERVER, "HUD_VIP", health, name, armour)
	
	set_task(0.1, "Task_ShowHUD", TASKID_SHOWHUD + id)		
	
	return PLUGIN_CONTINUE
}

public HookCurWeapon( id )
{
	if( HasSpeed[ id ] )
	{
		set_user_maxspeed( id, get_pcvar_float( cvar_speed ) );
	}
}
	
public logevent_round_start()
{
	new iPlayers[ 32 ], iNum, i, id;
	get_players( iPlayers, iNum, "c" );
		
	for( i = 0; i < iNum; i++ )
	{
		id = iPlayers[ i ];

		HasSpeed[ id ] = false;
	
		set_user_maxspeed( id, 0.0 );
	}
	if(get_pcvar_num(cvar_freeviptry) == 1)
	{
		VipTry[id] = false;
	}
}

public task_remind(id)
{
	client_printcolor(id, "%L", LANG_SERVER, "REMINDER")
}

public task_rendering(id)
{
	if(!is_user_alive(id))
	   return PLUGIN_HANDLED;	
		
	if(get_user_team(id) == 1 && (get_user_flags(id) & FLAG))
	{
		set_user_rendering(id,kRenderFxGlowShell,get_pcvar_num(cvar_red_t),get_pcvar_num(cvar_green_t),get_pcvar_num(cvar_blue_t),kRenderNormal,25) 
	}
	else if(get_user_team(id) == 2 && (get_user_flags(id) & FLAG))
	{
		set_user_rendering(id,kRenderFxGlowShell,get_pcvar_num(cvar_red_ct),get_pcvar_num(cvar_green_ct),get_pcvar_num(cvar_blue_ct),kRenderNormal,25) 
	}
	return PLUGIN_CONTINUE;
}

public no_rendering(id)
{
	set_user_rendering(id,kRenderFxGlowShell,0,0,0,kRenderNormal,1) 
}

public roundend(id)
{
	if((is_user_alive(id)) && (RandomFunction[id] == 2))
	{
		set_user_godmode(id, false)
	}
	return PLUGIN_CONTINUE;
}

public Hook_Deathmessage(id)
{
	new killer = read_data( 1 );
	new victim = read_data( 2 );

	if( killer == victim )
	{
		return PLUGIN_HANDLED;
	}
		
	HasSpeed[ victim ] = false;
	
	set_user_maxspeed( victim, 0.0 );

	if(RandomFunction[id] == 2)
	{
		set_user_godmode(id, 1)
	}

	return PLUGIN_CONTINUE;
}

public client_PreThink(id)
{
    if(is_user_alive(id))
    {
        if(get_user_flags(id) & FLAG)
        {
            new oldbuttons = get_user_oldbutton(id);
        
            
            oldbuttons &= ~IN_JUMP;
            entity_set_int(id, EV_INT_oldbuttons, oldbuttons);
        }
    }
    return PLUGIN_CONTINUE
}  

public Task_Model(task)
{
	new id = task - TASKID_MODEL 
	
	fm_set_user_model(id, player_model[id])
}

stock Create_BeamCylinder( origin[ 3 ], addrad, sprite, startfrate, framerate, life, width, amplitude, red, green, blue, brightness, speed )
{
	message_begin( MSG_PVS, SVC_TEMPENTITY, origin ); 
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[ 0 ] );
	write_coord( origin[ 1 ] );
	write_coord( origin[ 2 ] );
	write_coord( origin[ 0 ] );
	write_coord( origin[ 1 ] );
	write_coord( origin[ 2 ] + addrad );
	write_short( sprite );
	write_byte( startfrate );
	write_byte( framerate );
	write_byte(life );
	write_byte( width );
	write_byte( amplitude );
	write_byte( red );
	write_byte( green );
	write_byte( blue );
	write_byte( brightness );
	write_byte( speed );
	message_end();
}

stock te_sprite(id, Float:origin[3], sprite, scale, brightness)
{
	message_begin(MSG_ONE, SVC_TEMPENTITY, _, id)
	write_byte(TE_SPRITE)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite)
	write_byte(scale) 
	write_byte(brightness)
	message_end()
}

stock normalize(Float:fIn[3], Float:fOut[3], Float:fMul)
{
	new Float:fLen = xs_vec_len(fIn)
	xs_vec_copy(fIn, fOut)
	
	fOut[0] /= fLen, fOut[1] /= fLen, fOut[2] /= fLen
	fOut[0] *= fMul, fOut[1] *= fMul, fOut[2] *= fMul
}

public fw_SetClientKeyValue(id, infobuffer, key[], value[])
{   
	if (g_model[id] && equal(key, "model"))
		return FMRES_SUPERCEDE
	
	return FMRES_IGNORED
}

public fw_ClientUserInfoChanged(id, infobuffer)
{   
	if (!g_model[id])
		return FMRES_IGNORED
	
	new currentmodel[32]; 
	fm_get_user_model(id, currentmodel, sizeof currentmodel - 1);
	
	if(!equal(currentmodel, player_model[id]))
		fm_set_user_model(id, player_model[id]) 
	
	return FMRES_IGNORED
}

stock fm_set_user_model(player, modelname[])
{   
	engfunc(EngFunc_SetClientKeyValue, player, engfunc(EngFunc_GetInfoKeyBuffer, player), "model", modelname)
	
	g_model[player] = true
}

stock fm_get_user_model(player, model[], len)
{   
	engfunc(EngFunc_InfoKeyValue, engfunc(EngFunc_GetInfoKeyBuffer, player), "model", model, len)
}

stock fm_reset_user_model(player)
{         
	g_model[player] = false
	
	dllfunc(DLLFunc_ClientUserInfoChanged, player, engfunc(EngFunc_GetInfoKeyBuffer, player))
}

public VipInformation(id)
{
 	show_motd(id, "deathrun.txt", "Vip Information.")
}

public vip_show(id) 
{
	new said[192]
	read_args(said,192)
	if( ( containi(said, "donators") != -1 && containi(said, "vips") != -1 ) || contain(said, "/vips") != -1 )
		set_task(0.1, "viplist", id)
}

public viplist(user) 
{
	new vipnames[33][32]
	new message[256]
	new id, count, x, len
	
	for(id = 1 ; id <= g_maxplayers ; id++)
		if(is_user_connected(id))
			if(get_user_flags(id) & FLAG)
				get_user_name(id, vipnames[count++], 31)

	len = format(message, 255, "%s %s: ",COLOR, VIP_STATUS)
	if(count > 0) {
		for(x = 0 ; x < count ; x++) {
			len += format(message[len], 255-len, "%s%s ", vipnames[x], x < (count-1) ? ", ":"")
			if(len > 96 ) {
				print_message(user, message)
				len = format(message, 255, "%s ",COLOR)
			}
		}
		print_message(user, message)
	}
	else {
		len += format(message[len], 255-len, "%s.", VIP_STATUS_N)
		print_message(user, message)
	}
}

print_message(id, msg[]) {
	message_begin(MSG_ONE, msgSayText, {0,0,0}, id)
	write_byte(id)
	write_string(msg)
	message_end()
}

stock client_printcolor(const id, const input[], any:...)
{
	new count = 1, players[32];
	static msg[0];
	vformat(msg,190,input,3);
	replace_all(msg,190,"/g","^4");// green txt
	replace_all(msg,190,"/y","^1");// orange txt
	replace_all(msg,190,"/ctr","^3");// team txt
	replace_all(msg,190,"/w","^0");// team txt
	if (id) players[0] = id; else get_players(players,count,"ch");
	for (new i = 0; i < count; i++)
		if (is_user_connected(players[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, SayTxT, _, players[i]);
			write_byte(players[i]);
			write_string(msg);
			message_end();
		}
}	
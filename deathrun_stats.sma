#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <cstrike>
#include <hamsandwich>
#include <sqlx>
#include <geoip>
#include <colorchat>
#include <dhudmessage>

#define PLUGIN "Deathrun Stats"
#define VERSION "0.6.1"
#define AUTHOR "R3X"

new gszChatPrefix[32];
new gszTop15Redirect[128];

new gszMotd[1024];

new gszMapname[64];
new gMid


#pragma unused giGames
new giGames; //Poki co nie uzywana zmienna


new gszQuery[512];
new Handle:gTuple;

new gbAuthorized[33];
new giPid[33];

new giPlayedTime[33];
new giBestTime[33];
new giPlayedGames[33];
new giDeaths[33];
new gszRecordTime[33][32];
new gbWantTop5[33];
new giBestTimeofMap;

new Float:gfLastInfo[33];
new Float:gfStartRun[33];
new giLastTime[33];
new bool:gbFinished[33];

new gEntFinish = 0;
new bool:gbEntityMoved = false;

new gcvarSave, gcvarTimer, gcvarTimerType, gcvarDrawFinish;
new gcvarPrintResult;
new gcvarRoundTime;
new gcvarShowTop5;

new Float:gfEndRoundTime;
new giMaxPlayers;

new gsprite;

new giTOP5 = 0;
new gszTOP5LIST[5][32];
new gszTOP5BestTime[32];
new gszTOP5BestDate[32];
new gszTop5[256];

getFormatedTime(iTime, szTime[], size){
	formatex(szTime, size, "%d:%02d.%03ds", iTime/60000, (iTime/1000)%60, iTime%1000);
}

#include "drstats/db.inl"
#include "drstats/sqlite.inl"
#include "drstats/mysql.inl"

#include "drstats/finish.inl"
#include "drstats/stats.inl"

public plugin_init() {
	state mysql;
	
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_dictionary("deathrun_stats.txt");
	
	register_cvar("amx_drstats_host", "localhost");
	register_cvar("amx_drstats_user", "root");
	register_cvar("amx_drstats_pass", "root");
	register_cvar("amx_drstats_db", "drstats");
	
	gcvarSave = register_cvar("amx_drstats_save", "1");
	gcvarTimer = register_cvar("amx_drstats_timer", "1");
	gcvarTimerType = register_cvar("amx_drstats_timer_type", "0");
	gcvarDrawFinish = register_cvar("amx_drstats_draw_finish", "1");
	
	gcvarShowTop5  = register_cvar("amx_drstats_show_top5", "0");
	
	gcvarPrintResult = register_cvar("amx_drstats_print_result", "1");
	//0-wcale
	//1-HUD+konsola
	//2-chat
	
	gcvarRoundTime = get_cvar_pointer("mp_roundtime");
	
	register_cvar("amx_drstats_chat_prefix", "[Speedrun]"); 
	register_cvar("amx_drstats_top15_page", "");
	
	register_logevent( "eventRoundEnd",2, "1=Round_End");
	register_logevent( "eventRoundStart",2, "1=Round_Start");
	
	register_forward(FM_PlayerPreThink, "fwPreThink", 1);
	RegisterHam(Ham_Spawn, "player", "fwSpawn", 1);
	register_touch(gszFinish, "player", "fwTouch");
	register_touch("player", gszFinish, "fwTouch2");
	register_think(gszFinish, "fwThink");
	
	register_clcmd("dr_finish", "cmdFinish", ADMIN_CFG, ": spawn finish round");
	
	register_fullclcmd("rank", "showRank");
	register_fullclcmd("top15", "showTop15");
	
	register_fullclcmd("last", "cmdLast");
	register_fullclcmd("best", "cmdBest");
	
	register_fullclcmd("top5", "cmdTop5");
	
	gfwCreateFinish = CreateMultiForward("fwFinishCreate", ET_STOP, FP_CELL, FP_ARRAY, FP_CELL);
	gfwFinished = CreateMultiForward("fwPlayerFinished", ET_IGNORE, FP_CELL, FP_CELL, FP_CELL);
	gfwStarted = CreateMultiForward("fwPlayerStarted", ET_IGNORE, FP_CELL);
	
	giMaxPlayers = get_maxplayers();
	
	set_task(5.0, "taskShowTop5", 465754, _, _, "b");
	set_task(300.0, "taskShowTop5Info", 465754, _, _, "b");
}
public plugin_precache(){
	gsprite = precache_model("sprites/white.spr");
}

public plugin_cfg(){
	DB_Init();
	
	get_cvar_string("amx_drstats_chat_prefix", gszChatPrefix, charsmax(gszChatPrefix));
	get_cvar_string("amx_drstats_top15_page", gszTop15Redirect, charsmax(gszTop15Redirect));
}

public plugin_natives(){
	register_library("DeathrunStats");
	register_native("playerFinished", "_playerFinished", 1);
}
public _playerFinished(id){
	fwFinished(id);
}
public plugin_end(){
	if(gbEntityMoved)
		saveFinishOrigin();
	SQL_FreeHandle(gTuple);
}


public client_putinserver(id){
	if(is_user_bot(id) || is_user_hltv(id))
		return;
		
	loadPlayerId(id);
}
public client_authorized_db(id, pid){
	giPid[id] = pid;
	gbAuthorized[id] = true;
	
	giPlayedTime[id] = 0;
	giBestTime[id] = 0;
	giPlayedGames[id] = 0;
	giDeaths[id] = 0;

	loadRunnerData(id);
}
public client_connect(id){
	gbAuthorized[id] = false;
	giPid[id] = 0;
	giLastTime[id] = 0;
	
	gbWantTop5[id] = true;
}


public client_disconnect(id){
	saveRunnerData(id);
}

getPlayerDeaths(id){
	return giDeaths[id]+get_user_deaths(id);
}

getPlayedTime(id){
	return giPlayedTime[id] + get_user_time(id, 1);
}

getRunningTime(id){
	return floatround( (get_gametime()-gfStartRun[id])*1000, floatround_ceil);
}


public eventRoundStart(){
	new Float:fRoundTime = get_pcvar_float(gcvarRoundTime)*60;
	gfEndRoundTime = get_gametime()+fRoundTime;
}
public eventRoundEnd(){
	for(new i=1;i<33;i++)
		if(is_user_connected(i))
			saveRunnerData(i);
}

public fwSpawn(id){
	if(!is_user_alive(id) || !gbAuthorized[id])
		return HAM_IGNORED;
		
	if(!gEntFinish){
		client_print(id, print_chat, "%L", id, "FINISH_NOT_EXISTS");
		if(get_user_flags(id)&ADMIN_CFG)
			client_print(id, print_chat, "%L", id, "BUT_YOU_CAN_SPAWN_IT");
	}
	gbFinished[id] = false;
	gfStartRun[id] = -1.0;
	
	if(cs_get_user_team(id) == CS_TEAM_CT){
		gfStartRun[id] = get_gametime();
		
		new iRet;
		ExecuteForward(gfwStarted, iRet, id);
	}
		
	return HAM_IGNORED;
}
show_status(id, const szMsg[], any:...){
	new szStatus[128];
	vformat(szStatus, 127, szMsg, 3);
	
	static msgStatusText=0;
	if(!msgStatusText)
		msgStatusText = get_user_msgid("StatusText");
		
	message_begin(MSG_ONE_UNRELIABLE, msgStatusText, _, id);
	write_byte(0);
	write_string(szStatus);
	message_end();
}
Send_RoundTime(id, iTime){
	static msgRoundTime=0;
	if(!msgRoundTime)
		msgRoundTime = get_user_msgid("RoundTime");
		
	message_begin(MSG_ONE_UNRELIABLE, msgRoundTime, _, id);
	write_short(iTime);
	message_end();
}
hideTime(id){
	if(get_pcvar_num(gcvarTimerType)){
		Send_RoundTime(id, floatround(gfEndRoundTime - get_gametime()));
	}else{
		show_status(id, "");
	}
}
displayTime(id, iTime){
	if(get_pcvar_num(gcvarTimerType)){
		Send_RoundTime(id, iTime);
	}else{
		show_status(id, "%L: %d:%02ds", id, "WORD_TIME", iTime/60, iTime%60);
	}
}
public fwPreThink(id){
	if(!is_user_alive(id) || gfStartRun[id] <= 0.0)
		return FMRES_IGNORED;
	
	new iTimer = get_pcvar_num(gcvarTimer);
	if(!iTimer)
		return FMRES_IGNORED;
		
	if(iTimer == 2 && !(pev(id, pev_button) & IN_SCORE)){
		if(pev(id, pev_oldbuttons) & IN_SCORE)
			hideTime(id);
		return FMRES_IGNORED;
	}

	static Float:fNow;
		
	if(!gbFinished[id]){
		fNow = get_gametime();
		
		if((fNow-gfLastInfo[id]) <= 0.5) return FMRES_IGNORED;
		
		displayTime(id, getRunningTime(id) / 1000);
	}
	return FMRES_IGNORED;
}

public cmdBest(id){
	if(!gbAuthorized[id]){
		ColorChat(id, GREEN, "%s^x01 %L", gszChatPrefix, id, "NOT_AVAILABLE_NOW");
		return PLUGIN_CONTINUE;
	}
	
	if(giBestTime[id] == 0)
		ColorChat(id, GREEN, "%s^x01 %L", gszChatPrefix, id, "NEVER_REACH_FINISH");
	else{
		new szTime[32];
		getFormatedTime(giBestTime[id], szTime, charsmax(szTime));
		ColorChat(id, GREEN, "%s^x01 %L: ^x04 %s", gszChatPrefix, id, "YOUR_BEST_TIME", szTime);
	}
	return PLUGIN_CONTINUE;
}

public cmdLast(id){
	if(!gbAuthorized[id]){
		ColorChat(id, GREEN, "%s^x01 %L", gszChatPrefix, id, "NOT_AVAILABLE_NOW");
		return PLUGIN_CONTINUE;
	}
	
	if(giLastTime[id] == 0)
		ColorChat(id, GREEN, "%s^x01 %L", gszChatPrefix, id, "NEVER_REACH_FINISH");
	else{
		new szTime[32];
		getFormatedTime(giLastTime[id], szTime, charsmax(szTime));
		ColorChat(id, GREEN, "%s^x01 %L: ^x04 %s", gszChatPrefix, szTime, id, "YOUR_LAST_TIME", szTime);
	}
	return PLUGIN_CONTINUE;
}

printInfo(id, const szInfo[], ...){
	new printResult = get_pcvar_num(gcvarPrintResult);
	if(printResult == 0) return;
	
	new szMsg[64];
	vformat(szMsg, charsmax(szMsg), szInfo, 3);
	
	if(printResult == 1){
		show_dhudmessage(id, "%s", szMsg);
		client_print(id, print_console, "%s", szMsg);
	}
	else if(printResult == 2){
		ColorChat(id, GREEN, "%s^x01 %s", gszChatPrefix, szMsg);
	}
}

public fwFinished(id){
	if(!is_user_alive(id))
		return;
		
	new bool:record=false;
	
	new iTime = getRunningTime(id);
	giLastTime[id] = iTime;
	gbFinished[id] = true;
	
	new szTime[32];
	getFormatedTime(iTime, szTime, charsmax(szTime));
	
	set_dhudmessage(42, 43, 255, -1.0, 0.6, 1, 6.0, 5.0, 0.0, 0.0);
	printInfo(id, "%L: %s", id, "RUNNING_TIME", szTime);
	
	if(giBestTime[id] == 0){
		set_dhudmessage(255, 42, 255, -1.0, 0.7, 0, 6.0, 5.0, 0.0, 0.0);
		printInfo(id, "%L", id, "RUNNING_FIRST_FINISH");

		saveRunnerData(id, iTime);
	}
	else if(giBestTime[id] > iTime){
		getFormatedTime(giBestTime[id]-iTime, szTime, charsmax(szTime));
		
		set_dhudmessage(255, 42, 42, -1.0, 0.7, 0, 6.0, 5.0, 0.0, 0.0);
		printInfo(id, "%L: -%s!", id, "RUNNING_OWN_RECORD", szTime);
		
		saveRunnerData(id, iTime);
	}else if(giBestTime[id] < iTime){
		getFormatedTime(iTime-giBestTime[id], szTime, charsmax(szTime));
		
		set_dhudmessage(120, 120, 120, -1.0, 0.7, 0, 6.0, 5.0, 0.0, 0.0);
		printInfo(id, "%L: +%s", id, "RUNNING_OWN_RECORD", szTime);
	}else{
		set_dhudmessage(42, 255, 42, -1.0, 0.7, 0, 6.0, 5.0, 0.0, 0.0);
		printInfo(id, "%L", id, "RUNNING_OWN_RECORD_EQUAL");
	}

	if(giBestTimeofMap == 0 || giBestTimeofMap>iTime){
		giBestTimeofMap = iTime;
		
		new szName[32];
		get_user_name(id, szName, 31);
		set_dhudmessage(42, 255, 42, -1.0, 0.8, 2, 6.0, 5.0, 0.0, 0.0);
		
		for(new i=1;i<=giMaxPlayers;i++)
			if(is_user_connected(i))
				printInfo(i, "%L", i, "RUNNING_MAP_RECORD_BREAK", szName);
				
		record = true;
	}
	if(giBestTimeofMap != 0 && giBestTimeofMap<iTime){
		new szTime[32];
		getFormatedTime(iTime-giBestTimeofMap, szTime, 31);
		set_dhudmessage(120, 120, 120, -1.0, 0.8, 2, 6.0, 5.0, 0.0, 0.0);
		
		printInfo(id, "%L: +%s", id, "RUNNING_MAP_RECORD", szTime);
	}
	
	hideTime(id);
	
	new iRet;
	ExecuteForward(gfwFinished, iRet, id, iTime, record);
	
	loadTop5();
}

public cmdTop5(id){
	gbWantTop5[id] = !gbWantTop5[id];
	
	client_print(id, print_chat, "* Top 5 %s", gbWantTop5[id]?"On":"Off");
}

public taskShowTop5Info(){
	if(!get_pcvar_num(gcvarShowTop5))
		return;
		
	client_print(0, print_chat, "* say /top5 to show or hide Top HUD info");
}

public taskShowTop5(){
	if(!get_pcvar_num(gcvarShowTop5))
		return;
		
	for(new id=1; id<33; id++){
		if(is_user_connected(id) && gbWantTop5[id]){
			set_hudmessage(42, 170, 255, 0.01, 0.19, 0, 6.0, 5.0);
			show_hudmessage(id, "%s", gszTop5);
		}
	}
}

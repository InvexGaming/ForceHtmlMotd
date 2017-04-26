#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

//Defines
#define VERSION "1.00"

public Plugin myinfo =
{
  name = "Force HTML Motd",
  author = "Invex | Byte",
  description = "Kicks clients who set cl_disablehtmlmotd to 1.",
  version = VERSION,
  url = "http://www.invexgaming.com.au"
};

public void OnPluginStart()
{
  //ConVars
  ConVar cvar_forcehtmlmotd_checkfrequency = CreateConVar("sm_forcehtmlmotd_checkfrequency", "30", "How often to check cl_disablehtmlmotd client side convar");
  
  //Create config file
  AutoExecConfig(true, "forcehtmlmotd");
  
  //Repeated check
  CreateTimer(GetConVarFloat(cvar_forcehtmlmotd_checkfrequency), Timer_CheckDisableHtmlMotd, _, TIMER_REPEAT);
}

//Check on client join
public void OnClientPutInServer(int client)
{
  CheckDisableHtmlMotd(client);
}

//Check for all clients using a repeated timer
public Action Timer_CheckDisableHtmlMotd(Handle timer)
{
  for (int i = 1; i <= MaxClients; ++i) {
    CheckDisableHtmlMotd(i);
  }
}

stock void CheckDisableHtmlMotd(int iClient)
{
  if (!IsClientInGame(iClient) || !IsClientConnected(iClient))
    return;
    
  if (IsFakeClient(iClient))
    return;
  
  //Query user
  QueryClientConVar(iClient, "cl_disablehtmlmotd", Query_DisableHtmlMotdCheck);
  
  return;
}

public void Query_DisableHtmlMotdCheck(QueryCookie qCookie, int iClient, ConVarQueryResult cqResult, const char[] szCvarName, const char[] szCvarValue)
{
  if (cqResult != ConVarQuery_Okay) {
    return;
  }
  
  if (StringToInt(szCvarValue) > 0) {
    KickClient(iClient, "This server requires you set: cl_disablehtmlmotd 0");
  }
}
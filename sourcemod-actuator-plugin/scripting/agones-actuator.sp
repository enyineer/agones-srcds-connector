#include <sourcemod>
#include <sdktools>
#include <ripext>

HTTPClient httpClient;
char url[128];

/**
 * Defines the default plugin info
 */
public Plugin myinfo =
{
	name = "Agones Actuator",
	author = "Nico Enking",
	description = "This plugin is used to call the sourcemod-actuator-api for Agones lifecycle integration.",
	version = "1.0",
	url = ""
}

/**
 * Function runs when plugin is mounted
 *
 * @see https://sm.alliedmods.net/new-api/sourcemod/OnPluginStart
 */
public void OnPluginStart()
{
	PrintToServer("[Agones Actuator] Loaded: Agones Actuator");
	RegServerCmd("sm_agones_actuator_url", Command_Actuator_API_URL, "Sets the APIs URL'");

	httpClient = new HTTPClient("http://127.0.0.1:3000");
	httpClient.SetHeader("Content-Type", "application/json");

	HookEvent("game_start", Event_GameStart);
	HookEvent("game_end", Event_GameEnd);
}

/**
 * Function runs when map starts
 */
public OnMapStart()
{
	PrintToServer("[Agones Actuator] MapStart")

	JSONObject payload = new JSONObject();

	char urlBuffer[512];

	Format(urlBuffer, sizeof(urlBuffer), "%s%s", url, "/events/mapStart");

	httpClient.Post(urlBuffer, payload, OnRESTCall);
	delete payload;
}

/**
 * Function runs when map ends
 */
public OnMapEnd()
{
	PrintToServer("[Agones Actuator] MapEnd")

	JSONObject payload = new JSONObject();

	char urlBuffer[512];

	Format(urlBuffer, sizeof(urlBuffer), "%s%s", url, "/events/mapEnd");

	httpClient.Post(urlBuffer, payload, OnRESTCall);
	delete payload;
}

// Examples for events:
public void Event_GameStart(Event event, const char[] name, bool dontBroadcast)
{
	int roundslimit = event.GetInt("roundslimit");
	int timelimit = event.GetInt("timelimit");
	int fraglimit = event.GetInt("fraglimit");
	char objective[64];
	event.GetString("objective", objective, sizeof(objective));

	PrintToServer("[Agones Actuator] Game Start - roundslimit: %d - timelimit: %d - fraglimit: %d - objective: %s", roundslimit, timelimit, fraglimit, objective);

	JSONObject payload = new JSONObject();

	payload.SetInt("roundslimit", roundslimit);
	payload.SetInt("timelimit", timelimit);
	payload.SetInt("fraglimit", fraglimit);
	payload.SetString("objective", objective);

	char urlBuffer[512];

	Format(urlBuffer, sizeof(urlBuffer), "%s%s", url, "/events/gameStart");

	httpClient.Post(urlBuffer, payload, OnRESTCall);
	delete payload;
}

public void Event_GameEnd(Event event, const char[] name, bool dontBroadcast)
{
	int winner = event.GetInt("winner");

	PrintToServer("[Agones Actuator] Game End - winner: %d", winner);

	JSONObject payload = new JSONObject();

	payload.SetInt("winner", winner);

	char urlBuffer[512];

	Format(urlBuffer, sizeof(urlBuffer), "%s%s", url, "/events/gameEnd");

	httpClient.Post(urlBuffer, payload, OnRESTCall);
	delete payload;
}

/**
 * Function runs when sm_agones_actuator_url is triggered
 *
 * @param args
 */
public Action Command_Actuator_API_URL(int args)
{
	GetCmdArg(1, url, 128);

	httpClient = new HTTPClient(url);
	httpClient.SetHeader("Content-Type", "application/json");

	ReplyToCommand(0, "{\"status\":\"OK\",\"url\":\"%s\"}", url);
	return Plugin_Handled;
}

/**
 * General callback for HTTP Requests
 *
 * @param response
 * @param value
 */
public void OnRESTCall(HTTPResponse response, any value)
{
    if (response.Status != HTTPStatus_OK) {
        PrintToServer("[CSGO Remote] REST Failed!");
        return;
    }

    PrintToServer("[CSGO Remote] REST Success!");
}

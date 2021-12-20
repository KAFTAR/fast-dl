/*======================================*/
/*==== Ragemap 2021 Script - v 0.93  ====*/
/*======================================*/


// ========= _RC's stuff =========
#include "point_ball"
#include "point_ballbomb"
#include "rc_quizquestions"
#include "ragemap2021_rc"
// ======== _RC's stuff end ======


// ====== BonkTurnip's stuff =====
#include "bonkcrap"
// ==== BonkTurnip's stuff end ===

//======== Hezus' stuff ======
#include "CustomHUD"

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void TicketStart( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::TicketStart();
}

void UpdateTickets( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateTickets();
}

void TicketEnd( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::TicketEnd();
}

//======== Hezus' stuff end ======

/*============= Settings: ==============*/
bool randomPartOrder = true;
bool debugMode = false;						// enable debug messages printed to console, enable '/part mappername' and '/skip' chat command				
int partTransitionDelay = 0;				// delay in seconds until the next part starts
/*======================================*/


//								0			1					2				3				4			5			6		7			8			9
// These are the mapper's names if the script needs to print it on screen or something
array<string> mappers = { 		"Intro", 	"AlexCorruptor", 	"BonkTurnip", 	"Erty", 	"Hezus",  	"_RC", 	"SV BOY", 	"ZuRd0",	"Demolite",	"Outro" };

// A more simple version of the mappers's name, in case they have special characters in them. These should be used in all mapper related entity names
array<string> mapperSimple = { 	"intro", 	"alexc", 	"bonk", 	"erty", 	"hezus",  	"rc", 	"svboy", 	"zurdo",	"demolite", 	"outro" };

array<int> partOrder( mappers.length() );

int partActive = 0;
int partTransitionTimer = 0;

HUDTextParams transitionParams;


void MapInit()
{	
	// ======= _RC's stuff =======
	g_CustomEntityFuncs.RegisterCustomEntity( "point_ball", "point_ball" );
	g_CustomEntityFuncs.RegisterCustomEntity( "point_ballbomb", "point_ballbomb" );
	g_CustomEntityFuncs.RegisterCustomEntity( "ragemap2021_rc", "ragemap2021_rc" );
	g_Game.PrecacheModel( "sprites/ragemap2021/rc/ball.spr" );
	// ====== _RC's stuff end ====
	
	// Register the hook to monitor chat for chat commands
	g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSay );

	// Precaching mapper HUD icons
	for( uint i = 0; i < mappers.length(); i++)
	{
		g_Game.PrecacheModel( "sprites/ragemap2021/channelicon_" + mapperSimple[i] + ".spr" );
	}
}


void MapActivate()
{
	GeneratePartOrder();
	SetUpMapTransitions();
	partTransitionTimer = partTransitionDelay;
	
	transitionParams.x = -1;
	transitionParams.y = 0.8;
	transitionParams.effect = 0;
	transitionParams.r1 = 255;
	transitionParams.g1 = 255;
	transitionParams.b1 = 255;
	transitionParams.a1 = 0;
	transitionParams.r2 = 255;
	transitionParams.g2 = 255;
	transitionParams.b2 = 255;
	transitionParams.a2 = 0;
	transitionParams.fadeinTime = 0; 
	transitionParams.fadeoutTime = 1;
	transitionParams.holdTime = 1;
	transitionParams.fxTime = 0;
	transitionParams.channel = 3;


	g_Scheduler.SetInterval("UpdateHud", 1.0);
}


void GeneratePartOrder()
{
	if( randomPartOrder == true )
	{
		if( debugMode ){ g_Game.AlertMessage( at_console, "[GeneratePartOrder] Generating random part order .. \n" ); }
		
		// Intro is first
		partOrder[0] = 0;
		if( debugMode ){ g_Game.AlertMessage( at_console, "Part 0: " + mappers[0] + " \n" ); }
		
		
		for( uint i = 1; i < mappers.length()-1; i++ )
		{
			int nextPart = Math.RandomLong( 1, mappers.length() - 2 );
			bool partOrdered = false;
			
			for( uint j = 1; j < mappers.length()-1; j++ )
			{
				if( partOrder[j] == nextPart )
				{
					partOrdered = true;
					i--;
					break;
				}
			}
			
			if( !partOrdered )
			{
				partOrder[i] = nextPart;
				if( debugMode ){ g_Game.AlertMessage( at_console, "Part " + i + ": " + mappers[nextPart] + " \n" ); }
				// Disable spawnpoint
				g_EntityFuncs.FireTargets( "spawn_" + mapperSimple[ nextPart ], null, null, USE_OFF );
			}
			
		}
		
		// Outro is last
		partOrder[mappers.length() - 1] = (mappers.length() - 1);
		if( debugMode ){ g_Game.AlertMessage( at_console, "Part " + (mappers.length()-1) + ": " + mappers[mappers.length()-1] + " \n" ); }
		
	}
	else
	{
		if( debugMode ){ g_Game.AlertMessage( at_console, "[GeneratePartOrder] Generating part order .. \n" ); }
	
		for( uint i = 0; i < mappers.length(); i++ )
		{
			// Disable spawnpoint
			g_EntityFuncs.FireTargets( "spawn_" + mappers[ i ], null, null, USE_OFF );
			partOrder[i] = i;
			if( debugMode ){ g_Game.AlertMessage( at_console, "Part " + i + ": " + mappers[i] + " \n" ); }
		}
	}
	
	// Enable first spawnpoint
	g_EntityFuncs.FireTargets( "spawn_" + mapperSimple[ 0 ], null, null, USE_ON );
}


void SetUpMapTransitions()
{
	if( debugMode ){ g_Game.AlertMessage( at_console, "[SetUpMapTransitions] Starting .. \n" ); }
	CBaseEntity@ eTeleporter;
	
	for( uint i = 0; i < mappers.length(); i++ )
	{
		string teleporterName = "teleporter_" + mapperSimple[partOrder[i]];
		@eTeleporter = g_EntityFuncs.FindEntityByTargetname(null, teleporterName);
		
		if( debugMode ){ g_Game.AlertMessage( at_console, "[SetUpMapTransitions] Setting up target for " + teleporterName + "\n" ); }
		
		if( eTeleporter !is null )
		{
			if( debugMode ){ g_Game.AlertMessage( at_console, "[SetUpMapTransitions] " + eTeleporter.pev.targetname + " now linked to destination_" + mapperSimple[ partOrder[i+1] ] + ".\n" ); }
			g_EntityFuncs.DispatchKeyValue( eTeleporter.edict(), "target", "destination_" + mapperSimple[ partOrder[i+1] ] );
		}
	}	
}


void PartFinished(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{	
	g_Scheduler.SetTimeout("PartFinishedThink", 1.0);
}


void PartFinishedThink()
{
	partTransitionTimer--;
	
	if( partTransitionTimer > 0 )
	{
		g_PlayerFuncs.HudMessageAll( transitionParams, "Next part will start in " + partTransitionTimer + " seconds.");
		g_Scheduler.SetTimeout("PartFinishedThink", 1.0);
		return;
	}

	partActive++;
	partTransitionTimer = partTransitionDelay;
	
	if( debugMode ){ g_Game.AlertMessage( at_console, "[PartFinished] " + mappers[ partOrder[partActive] ] + "'s part is now active (\n" ); }

	// Disable old spawnpoints
	g_EntityFuncs.FireTargets( "spawn_" + mapperSimple[ partOrder[partActive-1] ], null, null, USE_OFF );
		
	// Enable new spawnpoints
	g_EntityFuncs.FireTargets( "spawn_" + mapperSimple[ partOrder[partActive] ], null, null, USE_ON );
		
	// Respawn players
	g_PlayerFuncs.RespawnAllPlayers( true, true );
}


void UpdateHud()
{
	CBasePlayer@ pPlayer = null;
	
	HUDSpriteParams params;
	params.channel = 0;
	params.flags = HUD_ELEM_NO_BORDER;
	//params.width = 0;
	//params.height = 0;
	params.x = 0.01;
	params.y = 0.01;
	//params.left = 0;
	//params.top = 0;
	params.color1 = RGBA_WHITE;
	params.color2 = RGBA_WHITE;
	params.fadeinTime = 0.0;
	params.fadeoutTime = 0.0;
	params.holdTime = 9999.0;
	params.fxTime = 1;
	params.effect = HUD_EFFECT_NONE;
	params.spritename = "ragemap2021/channelicon_" + mapperSimple[ partOrder[partActive] ] + ".spr";

	g_PlayerFuncs.HudCustomSprite(pPlayer, params);
}



HookReturnCode ClientSay(SayParameters@ pParams)
{
	CBasePlayer@ pPlayer = pParams.GetPlayer();
	const CCommand@ args = pParams.GetArguments();

	if( pPlayer.IsConnected() && debugMode)
	{
		if( args.ArgC() == 2)
		{
			if( args[0] == "/part" )
			{
				for( uint i = 0; i < mappers.length(); i++ )
				{
					if( args[1] == mappers[i] || args[1] == mapperSimple[i] )
					{
						if( debugMode ){ g_Game.AlertMessage( at_console, "[ChangePartCommand] Changing to" + mappers[ i ] + "'s part. \n" ); }
						
						// Disable all spawnpoints
						for( uint j = 0; j < mappers.length(); j++ )
						{
							g_EntityFuncs.FireTargets( "spawn_" + mapperSimple[ j ], null, null, USE_OFF );
						}
						
						// Activate spawnpoints in chosen part
						g_EntityFuncs.FireTargets( "spawn_" + mapperSimple[ i ], null, null, USE_ON );
						
						// Respawn players
						g_PlayerFuncs.RespawnAllPlayers( true, true );
						
						return HOOK_CONTINUE;
					}
				}
				
				if( debugMode ){ g_Game.AlertMessage( at_console, "[ChangePartCommand] Invalid mapper name (Usage: /part mappername. Mapper's name should be spelled as stored in the map script. \n" ); }
			}
			
		}
		else if( args[0] == "/skip" )
		{
			if( debugMode ){ g_Game.AlertMessage( at_console, "[ChangePartCommand] Skiping current part. \n" ); }
			
			PartFinished( null, null, USE_ON, 0 );
			return HOOK_CONTINUE;
		}
	}
	
	return HOOK_CONTINUE;
}




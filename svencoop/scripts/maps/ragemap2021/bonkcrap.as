//script crappily created by BonkTurnip ;D
//Keep track of scores and num players per team
int bluScore = 0;
int redScore = 0;
int numBlu = 0;
int numRed = 0;
bool isPlaying = true;
//CScheduledFunction@ g_pShellRepeat = null;
//change these to balance the minigame
const int bombPenalty = -2;
const int crystalValue = 1;
const int pointGoal = 5;

void BlueBombsRed(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	Vector goDown = Vector(0.0f, 0.0f, -100.0f);
	Vector spotOne = (g_EntityFuncs.FindEntityByTargetname(null, "bonk_redmortar1")).GetOrigin();
	Vector spotTwo = (g_EntityFuncs.FindEntityByTargetname(null, "bonk_redmortar0")).GetOrigin();
	g_EntityFuncs.ShootMortar(null, spotOne, goDown);
	g_EntityFuncs.ShootMortar(null, spotTwo, goDown);
}

void RedBombsBlue(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	Vector goDown = Vector(0.0f, 0.0f, -100.0f);
	Vector spotOne = (g_EntityFuncs.FindEntityByTargetname(null, "bonk_blumortar1")).GetOrigin();
	Vector spotTwo = (g_EntityFuncs.FindEntityByTargetname(null, "bonk_blumortar0")).GetOrigin();
	g_EntityFuncs.ShootMortar(null, spotOne, goDown);
	g_EntityFuncs.ShootMortar(null, spotTwo, goDown);
}

void FixedBlueCryScore(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if(isPlaying)
	{
		ChangeBluScore(crystalValue);
	}
}

void FixedBlueBombScore(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if(isPlaying && pActivator.IsPlayer())
	{
		CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
		const Vector origin = pPlayer.GetOrigin();
		Vector playerAngles = pPlayer.pev.angles;
		g_EntityFuncs.CreateExplosion(origin, playerAngles, null, 250, true);
		ChangeBluScore(bombPenalty);
	}
	
}

void FixedRedCryScore(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if(isPlaying)
	{
		ChangeRedScore(crystalValue);
	}
}

void FixedRedBombScore(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if(isPlaying && pActivator.IsPlayer())
	{
		CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
		const Vector origin = pPlayer.GetOrigin();
		Vector playerAngles = pPlayer.pev.angles;
		g_EntityFuncs.CreateExplosion(origin, playerAngles, null, 250, true);
		ChangeRedScore(bombPenalty);
	}
	
}

HookReturnCode ClientDisconnect(CBasePlayer@ pPlayer)
{
	if(pPlayer.pev.targetname == "blu")
	{
		numBlu--;
	}
	else if(pPlayer.pev.targetname == "red")
	{
		numRed--;
	}
	return HOOK_HANDLED;
}

void JoinBlueTeam(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if((numBlu <= numRed) && pActivator.IsPlayer())
	{
		numBlu++;
		pActivator.pev.targetname = string_t("blu");
		FirstSpawn(pActivator, pCaller, useType, flValue);
	}
	else if(pActivator.IsPlayer())
	{
		g_EngineFuncs.ClientPrintf(cast<CBasePlayer@>(pActivator), print_center, "You must join the other team.");
	}
}

void JoinRedTeam(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if((numRed <= numBlu) && pActivator.IsPlayer())
	{
		numRed++;
		pActivator.pev.targetname = string_t("red");
		FirstSpawn(pActivator, pCaller, useType, flValue);
	}
	else if(pActivator.IsPlayer())
	{
		g_EngineFuncs.ClientPrintf(cast<CBasePlayer@>(pActivator), print_center, "You must join the other team.");
	}
}

void FirstSpawn(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if(pActivator.IsPlayer())
	{
		if(pActivator.pev.targetname == "blu")
		{
			CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname(null, "bonk_bluspawn");
			pActivator.SetOrigin(pEntity.GetOrigin());
		}
		else if(pActivator.pev.targetname == "red")
		{
			CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname(null, "bonk_redspawn");
			pActivator.SetOrigin(pEntity.GetOrigin());
		}
		else
		{
			g_EngineFuncs.ClientPrintf(cast<CBasePlayer@>(pActivator), print_center, "Please select a team to join.");
		}
	}
}
//The below score methods have been deprecated because they were causing game crashes <3
void BlueScore(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if((pActivator !is null && isPlaying) && pActivator.IsPlayer())
	{
		CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
		if(HasItem(pPlayer) == 0)
		{
			ChangeBluScore(bombPenalty);
			const Vector origin = pPlayer.GetOrigin();
			Vector playerAngles = pPlayer.pev.angles;
			g_EntityFuncs.CreateExplosion(origin, playerAngles, pPlayer.edict(), 250, true);
		}
		else if(HasItem(pPlayer) == 1)
		{
			ChangeBluScore(crystalValue);
		}
	}
}

void RedScore(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if((pActivator !is null && isPlaying) && pActivator.IsPlayer())
	{
		CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
		if(HasItem(pPlayer) == 0)
		{
			ChangeRedScore(bombPenalty);
			const Vector origin = pPlayer.GetOrigin();
			Vector playerAngles = pPlayer.pev.angles;
			g_EntityFuncs.CreateExplosion(origin, playerAngles, pPlayer.edict(), 250, true);
		}
		else if(HasItem(pPlayer) == 1)
		{
			ChangeRedScore(crystalValue);
		}
	}
}

int HasItem(CBasePlayer@ pPlayer)
{
	InventoryList@ pInventory = pPlayer.get_m_pInventory();
	if((pInventory !is null) && pInventory.hItem.IsValid())
	{
		CItemInventory@ pItem = cast<CItemInventory@>(pInventory.hItem.GetEntity());
		if(pItem.m_flWeight == 100.0f)
		{
			pItem.Return();
			return 0;
		}
		else if(pItem.m_flWeight == 1.0f)
		{
			pItem.Return();
			return 1;
		}
		else
		{
			return -1;
		}
	}
	else
	{
		return -1;
	}
}
//This marks the end of the deprecated methods above ^_^
void ChangeBluScore(int amount)
{
	bluScore += amount;
	if(bluScore < 0)
	{
		bluScore = 0;
	}
	g_Game.AlertMessage(at_console, "blue: %1 red: %2\n", bluScore, redScore);
	g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Blue: "+bluScore+"\nRed: "+redScore+"\n");
	g_EntityFuncs.FireTargets("bonk_gardenmercs", null, null, USE_TOGGLE, 0.0f, 0.0f);
	if(bluScore >= pointGoal)
	{
		isPlaying = false;
		EndGame();
	}
}

void ChangeRedScore(int amount)
{
	redScore += amount;
	if(redScore < 0)
	{
		redScore = 0;
	}
	g_Game.AlertMessage(at_console, "blue: %1 red: %2\n", bluScore, redScore);
	g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Blue: "+bluScore+"\nRed: "+redScore+"\n");
	g_EntityFuncs.FireTargets("bonk_gardenmercs", null, null, USE_TOGGLE, 0.0f, 0.0f);
	if(redScore >= pointGoal)
	{
		isPlaying = false;
		EndGame();
	}
}

void EndGame()
{
	if(redScore >= pointGoal)
	{
		g_EntityFuncs.FireTargets("bonk_redwin", null, null, USE_TOGGLE, 0.0f, 0.0f);
	}
	else
	{
		g_EntityFuncs.FireTargets("bonk_bluwin", null, null, USE_TOGGLE, 0.0f, 0.0f);
	}
	g_Hooks.RemoveHook(Hooks::Player::ClientDisconnect, @ClientDisconnect);
}

void StartGame(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//@g_pShellRepeat = g_Scheduler.SetInterval("SetGlowShell", 2, g_Scheduler.REPEAT_INFINITE_TIMES);
	g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @ClientDisconnect);
}
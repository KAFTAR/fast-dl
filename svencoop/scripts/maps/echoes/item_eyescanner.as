// item_eyescanner for echoes map series

class CEyeScanner : ScriptBaseAnimating
{
	// Precache handler
	void Precache()
	{
		BaseClass.Precache();
		g_Game.PrecacheModel("models/echoes/EYE_SCANNER.mdl");
	}
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel(self, "models/echoes/EYE_SCANNER.mdl");
		pev.solid = SOLID_NOT;
		pev.movetype = MOVETYPE_NONE;		
	}
}

void RegisterItemEyeScannerEntity()
{
	g_CustomEntityFuncs.RegisterCustomEntity("CEyeScanner", "item_eyescanner");
}
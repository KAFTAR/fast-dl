// item_mossman for echoes map series

class ItemMossman : ScriptBaseAnimating
{
	// Precache handler
	void Precache()
	{
		BaseClass.Precache();
		g_Game.PrecacheModel("models/echoes/mossman_hd.mdl");
	}
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel(self, "models/echoes/mossman_hd.mdl");
		pev.solid = SOLID_NOT;
		pev.movetype = MOVETYPE_NONE;		
	}
}

void RegisterItemMossman()
{
	g_CustomEntityFuncs.RegisterCustomEntity("ItemMossman", "item_mossman");
}
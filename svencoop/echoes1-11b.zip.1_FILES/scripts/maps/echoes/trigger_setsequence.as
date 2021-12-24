/*
trigger_setsequence
Author: kmkz (e-mail: al_basualdo@hotmail.com )
Simple trigger to set sequence values
*/
enum TriggerSetSequenceSpawnFlag
	{
		//SF_START_ON 			= 1  << 0, Cannnot make it work. Anyway a trigger_auto will do.
	}

class trigger_setsequence : ScriptBaseEntity
{
	CBaseEntity@ pEntity = null;
	
	void Spawn() 
	{
		self.pev.movetype 		= MOVETYPE_NONE;
		self.pev.solid 			= SOLID_NOT;
		self.pev.framerate 		= 1.0f;
		
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, self.pev.vuser1, self.pev.vuser2 );
		SetUse(UseFunction(this.TriggerUse));
		/*if ( self.pev.SpawnFlagBitSet( SF_START_ON ))
		{
			SetThink(ThinkFunction(this.ThinkStart));
		}*/
		//self.pev.nextthink = g_Engine.time + 0.5f;
	}

	void TriggerUse(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
	{
		CBaseEntity@ pEntity;
		@pEntity = g_EntityFuncs.FindEntityByTargetname( pEntity, self.pev.target );
		if (@pEntity != null)
		{
			CBaseAnimating@ pEntityAnimating = cast<CBaseAnimating@>(pEntity);
				
			pEntityAnimating.pev.sequence = self.pev.sequence;
			if (self.pev.frame == "") 
			{
				pEntityAnimating.pev.frame = 0;
			}
			else
			{
				pEntityAnimating.pev.frame = self.pev.frame;
			}
			pEntityAnimating.ResetSequenceInfo();
		}
	}
	
	void ThinkStart()
	{
		//g_EntityFuncs.FireTargets(self.pev.targetname, null, null, USE_TOGGLE, 0.0f, 0.0f);
		SetThink(ThinkFunction(this.ThinkOff));
	}
	
	void ThinkOff()
	{
	
	}
}

void register_trigger_setsequence() 
{
	g_CustomEntityFuncs.RegisterCustomEntity( "trigger_setsequence", "trigger_setsequence" );
}

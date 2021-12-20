class point_ball : ScriptBaseEntity
{
	// SETTINGS
	float tickRate = 0.05;
	float friction = 0.02;
	float airfriction = 0.005;
	float gravity = 4000.0;
	
	// BALL PROPERTIES
	float radius = 32.0;
	float weight = 5.0;


	void Spawn()
	{
		Precache();
	
		self.pev.movetype = MOVETYPE_BOUNCE;
		self.pev.solid = SOLID_BBOX;
		g_EntityFuncs.SetModel( self, "sprites/ragemap2021/rc/ball.spr" );
		self.pev.scale = 0.185;
		float boxSize = 0.6 * radius;
		g_EntityFuncs.SetSize( self.pev, Vector(-boxSize, -boxSize, -boxSize), Vector(boxSize, boxSize, boxSize) );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		self.pev.takedamage		= DAMAGE_AIM;
		self.pev.renderamt = 255;
		//self.pev.rendercolor = Vector( Math.RandomLong(0,255), Math.RandomLong(0,255), Math.RandomLong(0,255) );
		
		self.pev.maxspeed = 800;
		
		SetThink( ThinkFunction( this.Think ) );
		self.pev.nextthink = g_Engine.time + tickRate;
	}
	
	
	void Precache()
	{
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/ball.spr" );
		
		BaseClass.Precache();
	}
	
	
	void Think()
	{			
		// air friction
		self.pev.velocity = self.pev.velocity - (self.pev.velocity * airfriction );
		
		if( self.pev.velocity.Length() < 0.1 && (self.pev.flags & FL_ONGROUND) != 0 )
		{
			self.pev.velocity = Vector(0,0,0);
		}
		
		if( self.pev.velocity.z < 1.0 && self.pev.velocity.z > -1.0 )
		{
			self.pev.velocity.z = 0;
		}
		
		self.pev.nextthink = g_Engine.time + tickRate;
	}
	
	
	void Touch( CBaseEntity@ pOther )
	{
		// friction
		self.pev.velocity = self.pev.velocity * (1 - friction );
	
		
		if( pOther !is null && pOther.pev.classname == "point_ball" )
		{
			float velSumBoth = self.pev.velocity.Length() + pOther.pev.velocity.Length();
			
			if( velSumBoth >= self.pev.maxspeed * 2 )
			{
				velSumBoth = self.pev.maxspeed * 2;
			}
			
			if( pOther.pev.velocity == Vector(0,0,0) )
			{
				self.pev.velocity = self.pev.velocity.Normalize() * velSumBoth / 2;
				pOther.pev.velocity = -self.pev.velocity;
			}
			else if( self.pev.velocity == Vector(0,0,0) )
			{
				pOther.pev.velocity = pOther.pev.velocity.Normalize() * velSumBoth / 2;
				self.pev.velocity = -pOther.pev.velocity;
			}
			
			//g_Game.AlertMessage( at_console, "[Touch] velSumBoth: " + velSumBoth + " \n" );
			
		}
		
	}

	
	int TakeDamage(entvars_t@ pevInflictor, entvars_t@ pevAttacker, float flDamage, int bitsDamageType)
	{
		CBaseEntity@ eAttacker = g_EntityFuncs.Instance( pevInflictor ); 
		self.pev.velocity = self.pev.velocity - getNormal( eAttacker.pev.origin ).Normalize() * flDamage * 10;	
			
		return 1;
	}
	
	
	Vector getNormal( Vector otherOrigin )
	{
		Vector vNormal;
		vNormal = (otherOrigin - self.pev.origin).Normalize();
		return vNormal;
	}
	
	
}























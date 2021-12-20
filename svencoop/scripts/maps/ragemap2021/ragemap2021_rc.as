int rc_roundNumber = 1;	//1
int rc_roundTimer = 0;
int rc_ballsEarned = 0;
int rc_starsEarned = 0;
int rc_questionsAsked = 0;
int rc_questionsPerRound = 10;
int rc_bonusScore = 0;
int rc_bonusScoreLimit = 150;


class ragemap2021_rc : ScriptBaseEntity
{
	// Settings
	
	int timePerQuestion = 8;
	int timeBallRound = 60;
	int roundAmount = 6;


	
	bool bActive = false;
	HUDTextParams rc_HudParams;
	

	void Spawn()
	{
		Precache();
		
		rc_HudParams.x = -1;
		rc_HudParams.y = 0.8;
		rc_HudParams.effect = 0;
		rc_HudParams.r1 = 255;
		rc_HudParams.g1 = 255;
		rc_HudParams.b1 = 255;
		rc_HudParams.a1 = 0;
		rc_HudParams.r2 = 255;
		rc_HudParams.g2 = 255;
		rc_HudParams.b2 = 255;
		rc_HudParams.a2 = 0;
		rc_HudParams.fadeinTime = 0; 
		rc_HudParams.fadeoutTime = 1;
		rc_HudParams.holdTime = 1;
		rc_HudParams.fxTime = 0;
		rc_HudParams.channel = 1;
	
		SetThink( ThinkFunction( this.Think ) );
	}
	
	
	void Precache()
	{
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_balls.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_stars.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_1.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_2.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_3.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_4.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_5.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_6.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_7.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_8.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_9.spr" );
		g_Game.PrecacheModel( "sprites/ragemap2021/rc/hud_0.spr" );
		BaseClass.Precache();
	}
	
	
	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
	{
		if( !bActive )
		{
			//g_Game.AlertMessage( at_console, "Game Starts \n" );
			bActive = true;
			self.pev.nextthink = g_Engine.time + 1;
		}
		else
		{
			g_PlayerFuncs.HudToggleElement(null, 1, false);
			g_PlayerFuncs.HudToggleElement(null, 2, false);
			g_PlayerFuncs.HudToggleElement(null, 3, false);
			
			//g_Game.AlertMessage( at_console, "Game Ends \n" );
			g_EntityFuncs.FireTargets( "spawn_rc_end", null, null, USE_OFF );
			bActive = false;
			self.pev.nextthink = g_Engine.time - 1;
		}
	}
	
	
	void Think()
	{
		//g_Game.AlertMessage( at_console, "[Think] Roundnumber: " + rc_roundNumber + ". Roundtimer: " + rc_roundTimer + ".\n" );
	
		// brains round
		if( rc_roundNumber == 1 || rc_roundNumber == 3 || rc_roundNumber == 5 )
		{
			if( rc_roundTimer == 0 )
			{
				AskQuizQuestion();
			}
			
			int questionNumber = rc_questionsAsked + 1;
			
			g_PlayerFuncs.HudMessageAll( rc_HudParams, "Question: [ " +  (rc_questionsAsked+1) + " / " + rc_questionsPerRound + " ] \n Time: [ " + rc_roundTimer + " / " + timePerQuestion + " ]");
		}
		
		// bonus
		else if( rc_roundNumber == 7 )
		{
			if( rc_roundTimer >= 120)
			{
				rc_roundTimer = 0;
				rc_roundNumber++;
				SpawnPlayersEnd();
			}
			else
			{
				g_PlayerFuncs.HudMessageAll( rc_HudParams, "Bonus Round! \n Kill them: [ " + rc_bonusScore + " / " + rc_bonusScoreLimit + "] \n Time: [ " + rc_roundTimer + " / 120 ]");
				
			}	
		}
		// outro
		else if( rc_roundNumber == 8 )
		{
			g_PlayerFuncs.HudMessageAll( rc_HudParams, "Thanks for playing! \n Stars earned: [ " + rc_starsEarned + " / 30 ] \n Bonus Score: [ " + rc_bonusScore + " / " + rc_bonusScoreLimit + " ]");
			
			if( rc_roundTimer >= 8 )
			{
				bActive = false;
				
				//g_PlayerFuncs.HudToggleElement( null, 1, false );
				//g_PlayerFuncs.HudToggleElement( null, 2, false );
				//g_PlayerFuncs.HudToggleElement( null, 3, false );
				
				for( int i = 0; i < 80; i++ )
				{
					if( g_EntityFuncs.FindEntityByClassname( null, "point_ball" ) !is null )
					{
						CBaseEntity@ killMe;
						@killMe = g_EntityFuncs.FindEntityByClassname( null, "point_ball" );
						g_EntityFuncs.Remove( killMe );
					}
					
					if( g_EntityFuncs.FindEntityByClassname( null, "point_ballbomb" ) !is null )
					{
						CBaseEntity@ killMe;
						@killMe = g_EntityFuncs.FindEntityByClassname( null, "point_ballbomb" );
						g_EntityFuncs.Remove( killMe );
					}
				}
			}
		}
		
		// balls round
		else if( rc_roundNumber == 2 || rc_roundNumber == 4 || rc_roundNumber == 6 )
		{		
			if( rc_roundTimer == 0 )
			{
				
				g_EntityFuncs.FireTargets( "rc_camera1", null, null, USE_OFF );
				SpawnPlayersBalls();
				SpawnBalls();	
			}
			else if( rc_roundTimer >= timeBallRound)
			{
				rc_roundNumber++;
				rc_ballsEarned = 0;
			
				// go to next brains round
				if( rc_roundNumber <= 6 )
				{
					rc_questionsAsked = 0;
					g_EntityFuncs.FireTargets( "rc_camera1", null, null, USE_ON );
					g_EntityFuncs.FireTargets( "rc_brains_sentence" + Math.RandomLong(1,2), null, null, USE_ON );
					rc_roundTimer = -4;
					SpawnPlayersBrains();	
				}
				// end game with bonus round
				else if( rc_starsEarned >= 20 )
				{
					rc_roundTimer = 0;
					rc_roundNumber = 7;
				
					SpawnBallBonus(1);
					SpawnBallBonus(2);
					SpawnBallBonus(3);
					SpawnBallBonus(4);
					SpawnBallBonus(5);
					SpawnBallBonus(6);
					SpawnBallBonus(7);
					SpawnBallBonus(8);
					SpawnBallBonus(9);
					SpawnBallBonus(10);
					
					SpawnPlayersBonus();
				}
				// no bonus round
				else
				{
					rc_roundTimer = 0;
					rc_roundNumber = 8;
					SpawnPlayersEnd();
				}
			}
			
			g_PlayerFuncs.HudMessageAll( rc_HudParams, "Put the balls in the holes! \n Time: [ " + rc_roundTimer + " / " + timeBallRound + " ]");
		}
		
		
		rc_roundTimer++;
		
		if( bActive )
		{
			UpdateHudRC();
			self.pev.nextthink = g_Engine.time + 1;
		}
	}
	
	
	void AskQuizQuestion()
	{
		int questionType = Math.RandomLong(0,2);
		int rightAnswer = Math.RandomLong(0,1);
	
		string sQuestion;
		string sYesAnswer;
		string sNoAnswer;
		
		// capitol
		if( questionType == 0)
		{
			int subQuestionType = Math.RandomLong(0,1);
			int country = Math.RandomLong( 0, 241 );
			
			if( subQuestionType == 0 )
			{
				sQuestion = "What is the capitol of '" + capitols[country][1] + "' ?";
				sYesAnswer = capitols[country][0];
				sNoAnswer = capitols[Math.RandomLong(0,241)][0];
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = capitols[Math.RandomLong(0,241)][0];
				}

			}
			else
			{
				sQuestion = "Which country is '" + capitols[country][0] + "' the capitol of?";
				sYesAnswer = capitols[country][1];
				sNoAnswer = capitols[Math.RandomLong(0,241)][1];
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = capitols[Math.RandomLong(0,241)][1];
				}
			}
		
		}
		// invention
		else if( questionType == 1)
		{
			int subQuestionType = Math.RandomLong(0,1);
			int invention = Math.RandomLong( 0, 23 );
			
			if( subQuestionType == 0 )
			{
				sQuestion = "When was '" + inventions[invention][1] + "' invented ?";
				sYesAnswer = inventions[invention][0];
				sNoAnswer = inventions[Math.RandomLong(0,23)][0];
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = inventions[Math.RandomLong(0,23)][0];
				}
			}
			else
			{
				sQuestion = "What was invented in the year '" + inventions[invention][0] + "' ?";
				sYesAnswer = inventions[invention][1];
				sNoAnswer = inventions[Math.RandomLong(0,23)][1];
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = inventions[Math.RandomLong(0,23)][1];
				}
			}
		}
		
		// math
		else
		{
			int subQuestionType = Math.RandomLong(0,3);
			
			// + 
			if( subQuestionType == 0 )
			{
				int randomNumber1 = Math.RandomLong(5,100);
				int randomNumber2 = Math.RandomLong(6,100);
				int solution = randomNumber1 + randomNumber2;
				sQuestion = "What is " + randomNumber1 + " + " + randomNumber2 + " ?";
				sYesAnswer = "" + solution;
				sNoAnswer = "" + (solution + Math.RandomLong(-10,10));
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = "" + (solution + Math.RandomLong(-10,10));
				}

			}
			// -
			else if( subQuestionType == 1 )
			{
				int randomNumber1 = Math.RandomLong(200,500);
				int randomNumber2 = Math.RandomLong(11,200);
				int solution = randomNumber1 - randomNumber2;
				sQuestion = "What is " + randomNumber1 + " - " + randomNumber2 + " ?";
				sYesAnswer = "" + solution;
				sNoAnswer = "" + (solution + Math.RandomLong(-10,10));
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = "" + (solution + Math.RandomLong(-10,10));
				}
			}
			// *
			else if( subQuestionType == 2 )
			{
				int randomNumber1 = Math.RandomLong(2,11);
				int randomNumber2 = Math.RandomLong(2,11);
				int solution = randomNumber1 * randomNumber2;
				sQuestion = "What is " + randomNumber1 + " * " + randomNumber2 + " ?";
				sYesAnswer = "" + solution;
				sNoAnswer = "" + (solution + Math.RandomLong(-10,10));
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = "" + (solution + Math.RandomLong(-10,10));
				}

			}
			// /
			else if( subQuestionType == 3 )
			{
				int randomNumber1 = Math.RandomLong(2,11);
				int randomNumber2 = Math.RandomLong(2,11);
				int solution = randomNumber1 * randomNumber2;
				sQuestion = "What is " + solution + " / " + randomNumber1 + " ?";
				sYesAnswer = "" + randomNumber2;
				sNoAnswer = "" + (randomNumber2 + Math.RandomLong(-2,2));
				
				while( (sNoAnswer) == (sYesAnswer) )
				{
					sNoAnswer = "" + (randomNumber2 + Math.RandomLong(-2,2));
				}
			}
			
		}
		
		// swap answers
		string voteName = "yes";
		
		if( Math.RandomLong(0,1) == 1 )
		{
			voteName = "no";
			string yesAnswer = sYesAnswer;
			sYesAnswer = sNoAnswer;
			sNoAnswer = yesAnswer;
		}
		
		Vote@ QuizQuestion = Vote( voteName, sQuestion, timePerQuestion, 50.1 );
		QuizQuestion.SetNoText( sNoAnswer );
		QuizQuestion.SetYesText( sYesAnswer );
		QuizQuestion.SetVoteBlockedCallback(@QuizVoteEndFailed);
		QuizQuestion.SetVoteEndCallback(@QuizVoteEnd);
		QuizQuestion.Start();
	}
	
	
	void SpawnPlayersBrains()
	{
		g_EntityFuncs.FireTargets( "rc_spawn_ball1", null, null, USE_OFF );
		g_EntityFuncs.FireTargets( "spawn_rc_soccer", null, null, USE_OFF );
		g_EntityFuncs.FireTargets( "spawn_rc_minigolf", null, null, USE_OFF );
		
		g_EntityFuncs.FireTargets( "spawn_rc", null, null, USE_ON );
		g_Scheduler.SetTimeout("RCRespawnPlayers", 0.1);
	}
	
	
	void SpawnPlayersBonus()
	{
		//g_Game.AlertMessage( at_console, "SpawnPlayersBonus \n" );
		
		for( int i = 0; i < 32; i++ )
		{
			g_EntityFuncs.Remove( g_EntityFuncs.FindEntityByTargetname( null, "spawn_rc_minigolf" ) );
		}
		
		g_EntityFuncs.FireTargets( "spawn_rc_bowling", null, null, USE_ON );
		g_Scheduler.SetTimeout("RCRespawnPlayers", 0.1);
	}
	
	
	void SpawnPlayersEnd()
	{
		//g_Game.AlertMessage( at_console, "SpawnPlayersEnd \n" );
		
		for( int i = 0; i < 64; i++ )
		{
			if( g_EntityFuncs.FindEntityByTargetname( null, "spawn_rc_minigolf" ) !is null )
			{
				//g_Game.AlertMessage( at_console, "fuck this entity \n" );
				CBaseEntity@ fuckThisEnity;
				@fuckThisEnity = g_EntityFuncs.FindEntityByTargetname( null, "spawn_rc_minigolf" );
				g_EntityFuncs.Remove( fuckThisEnity );
				g_EntityFuncs.FireTargets( "spawn_rc_minigolf", null, null, USE_KILL );
			}
			
			//g_Game.AlertMessage( at_console, "and fuck this entity even more \n" );
			g_EntityFuncs.Remove( g_EntityFuncs.FindEntityByTargetname( null, "spawn_rc_minigolf" ) );
			g_EntityFuncs.FireTargets( "spawn_rc_minigolf", null, null, USE_KILL );
			
			g_EntityFuncs.Remove( g_EntityFuncs.FindEntityByTargetname( null, "spawn_rc_bowling" ) );
		}
		
		g_EntityFuncs.FireTargets( "spawn_rc_end", null, null, USE_ON );
		g_Scheduler.SetTimeout("RCRespawnPlayers", 0.1);
	}
	
	
	void SpawnPlayersBalls()
	{
		if( rc_roundNumber == 2 )
		{
			g_EntityFuncs.FireTargets( "spawn_rc", null, null, USE_OFF );
			g_EntityFuncs.FireTargets( "rc_spawn_ball1", null, null, USE_ON );
		}
		else if( rc_roundNumber == 4 )
		{
			g_EntityFuncs.FireTargets( "spawn_rc", null, null, USE_OFF );
			g_EntityFuncs.FireTargets( "spawn_rc_soccer", null, null, USE_ON );
		}
		else if( rc_roundNumber == 6)
		{
			g_EntityFuncs.FireTargets( "spawn_rc", null, null, USE_OFF );
			g_EntityFuncs.FireTargets( "spawn_rc_minigolf", null, null, USE_ON );
		}
		
		g_Scheduler.SetTimeout("RCRespawnPlayers", 0.1);
	}
	
	
	void UpdateHudRC()
	{
		CBasePlayer@ pPlayer = null;
		
		HUDSpriteParams paramsRC;
		paramsRC.channel = 1;
		paramsRC.flags = HUD_ELEM_NO_BORDER;
		paramsRC.x = 0.4;
		paramsRC.y = 0.9;
		paramsRC.color1 = RGBA_WHITE;
		paramsRC.color2 = RGBA_WHITE;
		paramsRC.fadeinTime = 0.0;
		paramsRC.fadeoutTime = 0.0;
		paramsRC.holdTime = 1.0;
		paramsRC.fxTime = 1;
		paramsRC.effect = HUD_EFFECT_NONE;
		
		HUDSpriteParams paramsRC2 = paramsRC;
		paramsRC2.channel = 2;
		paramsRC2.x = 0.6;
		
		HUDSpriteParams paramsRC3 = paramsRC;
		paramsRC3.channel = 3;
		paramsRC3.x = 0.55;
		paramsRC3.spritename = "ragemap2021/rc/hud_1.spr";
		
		
		if( rc_roundNumber == 1 || rc_roundNumber == 3 || rc_roundNumber == 5 )
		{		
			paramsRC.spritename = "ragemap2021/rc/hud_balls.spr";
			
			if( rc_ballsEarned < 10 )
			{
				paramsRC2.spritename = "ragemap2021/rc/hud_" + rc_ballsEarned + ".spr";
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC2);
				g_PlayerFuncs.HudToggleElement(pPlayer, paramsRC3.channel, false);
			}
			else
			{
				paramsRC2.spritename = "ragemap2021/rc/hud_0.spr";
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC2);
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC3);
			}
		}
		else
		{
			paramsRC.spritename = "ragemap2021/rc/hud_stars.spr";
			int ones;
			
			if( rc_starsEarned < 10 )
			{
				paramsRC2.spritename = "ragemap2021/rc/hud_" + rc_starsEarned + ".spr";
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC2);
				g_PlayerFuncs.HudToggleElement(pPlayer, paramsRC3.channel, false);
			}
			else if( rc_starsEarned >= 10 && rc_starsEarned < 20 )
			{
				ones = rc_starsEarned - 10;
				paramsRC2.spritename = "ragemap2021/rc/hud_" + ones	+ ".spr";
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC2);
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC3);
			}
			else if( rc_starsEarned >= 20 )
			{	
				ones = rc_starsEarned - 20;
				paramsRC2.spritename = "ragemap2021/rc/hud_" + ones + ".spr";
				paramsRC3.spritename = "ragemap2021/rc/hud_2.spr";
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC2);
				g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC3);
			}
		}

		g_PlayerFuncs.HudCustomSprite(pPlayer, paramsRC);
	}


}


void RCRespawnPlayers()
{
	g_EntityFuncs.FireTargets( "rc_respawn", null, null, USE_ON );
}
	

void QuizVoteEndFailed( Vote@ pVote, float flTime  )
{
	g_Game.AlertMessage( at_console, "QuizVoteEndFailed \n" );
	if ( pVote.GetName() == "yes" || pVote.GetName() == "no")
	{
		g_EntityFuncs.FireTargets( "rc_no_text" + Math.RandomLong(1,3), null, null, USE_ON);
		rc_questionsAsked++;
		rc_roundTimer = -1;
		
		if( rc_questionsAsked == rc_questionsPerRound )
		{
			rc_roundNumber++;
			rc_roundTimer = 0;
		}
	}
	//g_Game.AlertMessage( at_console, "[QuizVoteEnd] Question answered " + fResult + ". Balls earned: " + rc_ballsEarned + ".\n" );
}


void QuizVoteEnd( Vote@ pVote, bool fResult, int iVoters )
{
	g_Game.AlertMessage( at_console, "QuizVoteEnd \n" );
	
	if( iVoters > 0 )
	{
		if ( pVote.GetName() == "yes" )
		{
			if( fResult )
			{
				rc_ballsEarned++;
				SpawnBallBrains();
				g_EntityFuncs.FireTargets( "rc_yes_text" + Math.RandomLong(1,3), null, null, USE_ON);
			}
			else
			{
				g_EntityFuncs.FireTargets( "rc_no_text" + Math.RandomLong(1,3), null, null, USE_ON);
			}
		}
		else if ( pVote.GetName() == "no" )
		{
			if( !fResult )
			{
				SpawnBallBrains();
				rc_ballsEarned++;
				g_EntityFuncs.FireTargets( "rc_yes_text" + Math.RandomLong(1,3), null, null, USE_ON);
			}
			else
			{
				g_EntityFuncs.FireTargets( "rc_no_text" + Math.RandomLong(1,3), null, null, USE_ON);
			}
		}
			
		rc_questionsAsked++;
		rc_roundTimer = -1;
			
		if( rc_questionsAsked == rc_questionsPerRound )
		{
			rc_roundNumber++;
			rc_roundTimer = 0;
		}
		
		//g_Game.AlertMessage( at_console, "[QuizVoteEnd] Question answered " + fResult + ". Balls earned: " + rc_ballsEarned + ".\n" );
	}
	else
	{
		g_EntityFuncs.FireTargets( "rc_no_text" + Math.RandomLong(1,3), null, null, USE_ON);
		rc_questionsAsked++;
		rc_roundTimer = -1;
		
		if( rc_questionsAsked == rc_questionsPerRound )
		{
			rc_roundNumber++;
			rc_roundTimer = 0;
		}
	}
}


void SpawnBallBrains()
{
	CBaseEntity@ eSpawnpoint;
	@eSpawnpoint = g_EntityFuncs.FindEntityByTargetname( null, "rc_brains_ballspawn" + Math.RandomLong(1,2) );
	
	CBaseEntity@ eBall = g_EntityFuncs.Create( "point_ball", eSpawnpoint.pev.origin, Vector(0,0,0), true, null );
		
	if( @eBall !is null )
	{
		int randomColor = Math.RandomLong(1,4);
		
		if( randomColor == 1 ){			eBall.pev.rendercolor = Vector( 255, 102, 102); }
		else if( randomColor == 2 ){	eBall.pev.rendercolor = Vector( 235, 174, 102); }
		else if( randomColor == 3 ){	eBall.pev.rendercolor = Vector( 102, 204, 255); }
		else if( randomColor == 4 ){	eBall.pev.rendercolor = Vector( 153, 255, 102); }
		
		eBall.pev.velocity = Vector( Math.RandomLong(-20,20), 400, 0);
		g_EntityFuncs.DispatchSpawn( @eBall.edict() );
	}
}


void SpawnBalls()
{
	CBaseEntity@ eSpawnpoint;
	
	for( int i = 1; i <= rc_ballsEarned; i++ )
	{
		if( rc_roundNumber == 2 )
		{
			@eSpawnpoint = g_EntityFuncs.FindEntityByTargetname( null, "rc_ballspawn_billiard" + i );
		}
		else if( rc_roundNumber == 4 )
		{
			@eSpawnpoint = g_EntityFuncs.FindEntityByTargetname( null, "rc_ballspawn_soccer" + i );
		}
		else if( rc_roundNumber == 6 )
		{
			@eSpawnpoint = g_EntityFuncs.FindEntityByTargetname( null, "rc_ballspawn_minigolf" + i );
		}
		
		CBaseEntity@ eBall = g_EntityFuncs.Create( "point_ball", eSpawnpoint.pev.origin, Vector(0,0,0), true, null );
		
		if( @eBall !is null )
		{
			int randomColor = Math.RandomLong(1,4);
			
			if( randomColor == 1 ){			eBall.pev.rendercolor = Vector( 255, 102, 102); }
			else if( randomColor == 2 ){	eBall.pev.rendercolor = Vector( 235, 174, 102); }
			else if( randomColor == 3 ){	eBall.pev.rendercolor = Vector( 102, 204, 255); }
			else if( randomColor == 4 ){	eBall.pev.rendercolor = Vector( 153, 255, 102); }
			
			eBall.pev.velocity = Vector( Math.RandomLong(-10,10), Math.RandomLong(-10,10), Math.RandomLong(-10,10) );
			g_EntityFuncs.DispatchSpawn( @eBall.edict() );
		}
	}

}


void SpawnBallBonus( int bombNumber )
{
	CBaseEntity@ eSpawnpoint;

	@eSpawnpoint = g_EntityFuncs.FindEntityByTargetname( null, "rc_ballspawn_bowling" + bombNumber );

	CBaseEntity@ eBall = g_EntityFuncs.Create( "point_ballbomb", eSpawnpoint.pev.origin, Vector(0,0,0), true, null );
				
	if( @eBall !is null )
	{
		eBall.pev.velocity = Vector( Math.RandomLong(-10,10), Math.RandomLong(-10,10), Math.RandomLong(-10,10) );
		g_EntityFuncs.DispatchSpawn( @eBall.edict() );
		eBall.pev.iuser1 = bombNumber;
	}
}


void BallScored(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if( pActivator.pev.classname == "point_ball" )
	{
		g_EntityFuncs.Remove( pActivator );

		if( rc_ballsEarned > 0 )
		{
			rc_starsEarned++;
			rc_ballsEarned--;
		}
	}
}


void BonusScored(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	rc_bonusScore++;
}



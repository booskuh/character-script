CS_Config = {}

///////////////////////////////////////////////////////////////////
// General Configuration 										 //
///////////////////////////////////////////////////////////////////

	CS_Config.AllowRespawn				= true
	CS_Config.KillOnChange				= true
	CS_Config.InitialSpawnLocation		= true
	CS_Config.CMD_NameChangeRemove		= true
	CS_Config.DebugConsole				= true

	CS_Config.Title						= "Vanguard"
	CS_Config.CMD_Modifier				= "!"
	CS_Config.CMD_Menu					= "charmenu"

///////////////////////////////////////////////////////////////////
// List of chat / console commands and the permissions			 //
// required to execute that command. permission case sensitive	 //
///////////////////////////////////////////////////////////////////


	CS_Config.CMD_ChangeRPName 			= { cmd = "setrpname",	 		permission = "superadmin" }
	CS_Config.CMD_ChangePlayerModel 	= { cmd = "forcemodelchange", 	permission = "superadmin" }
	CS_Config.CMD_BanCharacter			= { cmd = "banchar",			permission = "superadmin" }
	CS_Config.CMD_UnbanCharacter		= { cmd = "unbanchar",			permission = "superadmin" }
	CS_Config.CMD_KickFromJob			= { cmd = "kickjob", 			permission = "superadmin" }
	CS_Config.CMD_DeleteCharacter		= { cmd = "delete",				permission = "superadmin" }

///////////////////////////////////////////////////////////////////
// List of banned words for the name filter						 //
// To add to the list, simply add a comma after the last entry	 //
// and insert your word in parantheses.							 //
///////////////////////////////////////////////////////////////////

	CS_Config.BannedWords = {
		"anal", "anus", "arse", "ass", "ballsack", "balls", "bastard", "bitch", "biatch", "bloody", "blowjob", "blow job", "bollock",
		"bollok", "boner", "boob", "bugger", "bum", "butt", "buttplug", "clitoris", "cock", "coon", "crap", "cunt",
		"damn", "dick", "dildo", "dyke", "fag", "feck", "fellate", "fellatio", "felching", "fuck", "f u c k", "fudgepacker",
		"fudge packer", "flange", "Goddamn", "God damn", "hell", "homo", "jerk", "jizz", "knobend", "knob", "labia",
		"lmao", "lmfao", "muff", "nigger", "nigga", "omg", "penis", "piss", "poop", "prick", "pube", "pussy", "queer", "scrotum",
		"sex", "shit", "s hit", "sh1t", "slut", "smegma", "spunk", "tit", "tosser", "turd", "twat","vagina",
		"wank", "whore", "wtf"
	}
	
///////////////////////////////////////////////////////////////////
// Players with these model will keep model on job change		 //
// format = 													 //
//		{														 //
//			model = "path/to/file"								 //
//			name = "command"									 //
//		},														 //
///////////////////////////////////////////////////////////////////


	CS_Config.PlayermodelWhitelist = {
		{
			model = "models/player/police.mdl", 
			name = "police"
		}
	}

	CS_Config.Playermodels = { 
		{
			model = "models/player/alyx.mdl", 
			name = "alyx"
		},
		{
			model = "models/player/barney.mdl",
			name = "barney"
		},
		{
			model = "models/player/breen.mdl", 
			name = "breen"
		},
		{
			model = "models/player/mossman_arctic.mdl", 
			name = "mossman"
		},
		{
			model = "models/player/police.mdl", 
			name = "police"
		},
		{
			model = "models/player/combine_soldier_prisonguard.mdl", 
			name = "combine"
		},
		{
			model = "models/player/Group01/female_02.mdl", 
			name = "female_2"
		},
		{
			model = "models/player/Group03m/female_03.mdl", 
			name = "female_3"
		},
		{
			model = "models/player/Group01/male_01.mdl", 
			name = "male_1"
		},
		{
			model = "models/player/Group02/male_08.mdl", 
			name = "male_8"
		},
		{
			model = "models/player/Group03/male_09.mdl", 
			name = "male_9"
		},
		{
			model = "models/player/Group03m/male_02.mdl", 
			name = "male_2"
		},
		{
			model = "models/player/gasmask.mdl", 
			name = "gasmask"
		},
		{
			model = "models/player/hostage/hostage_04.mdl", 
			name = "hostage"
		},
		{
			model = "models/player/dod_german.mdl", 
			name = "german"
		}
	}

HMMWV =
{
	Properties = 
	{	
		bDisableEngine = 0,
		material = "",
		Modification = "",
		soclasses_SmartObjectClass = "Car",
	},
	
	Client = {},
	Server = {},
}

HMMWV.AIProperties = 
{
  AIType = AIOBJECT_CAR,
  
  PropertiesInstance = 
  {
    aibehavior_behaviour = "CarIdle",
  },
  
  Properties = 
  {
    aicharacter_character = "Car",
  },
  
  AIMovementAbility = 
  {
		walkSpeed = 7.0,
		runSpeed = 15.0,
		sprintSpeed = 25.0,
		maneuverSpeed = 7.0,
		maneuverTrh = 0.0,
		minTurnRadius = 4,
		maxTurnRadius = 15,    
		pathType = "AIPATH_CAR",
		pathLookAhead = 15,
		pathRadius = 2,
		pathSpeedLookAheadPerSpeed = 3.0,
		cornerSlowDown = 0.75,
		pathFindPrediction = 1.0,
		velDecay = 130,
		resolveStickingInTrace = 0,
		pathRegenIntervalDuringTrace = 4.0,
		avoidanceRadius = 10.0,
  }, 
}

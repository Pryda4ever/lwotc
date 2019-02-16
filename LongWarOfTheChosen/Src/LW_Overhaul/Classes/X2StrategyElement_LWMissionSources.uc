//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_LWMissionSources.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Defines new categories of mission sources to be generated by the Overhaul AlienActivity system
//---------------------------------------------------------------------------------------
class X2StrategyElement_LWMissionSources extends X2StrategyElement config(LW_MissionData);

var config int			GOpIgnoreDarkEventCompleteWithinDays;

var config array<int>		BlacksiteMinDoomRemoval;
var config array<int>		BlacksiteMaxDoomRemoval;
var config array<int>		ForgeMinDoomRemoval;
var config array<int>		ForgeMaxDoomRemoval;
var config array<int>		PsiGateMinDoomRemoval;
var config array<int>		PsiGateMaxDoomRemoval;

var config array<DoomAddedData>		FacilityStartingDoom;
var config array<DoomAddedData>		FortressStartingDoom;

var config int			PercentChanceLandedUFO;
var config float		CouncilMissionSupplyScalar;
var config int			MissionMinDuration; // Hours
var config int			MissionMaxDuration; // Hours
var config int			MaxNumGuerillaOps;
var config array<MissionMonthDifficulty> GuerillaOpMonthlyDifficulties;
var config array<int>	EasyMonthlyDifficultyAdd;
var config array<int>	NormalMonthlyDifficultyAdd;
var config array<int>	ClassicMonthlyDifficultyAdd;
var config array<int>	ImpossibleMonthlyDifficultyAdd;

var public localized String m_strStopDoomProduction;
var public localized String m_strDoomLabel;
var public localized String m_strDoomSingular;
var public localized String m_strDoomPlural;
var public localized String m_strDoomRange;
var public localized String m_strFacilityDestroyed;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> MissionSources;
	// WOTC DEBUGGING:
	`Log(">>> Creating mission source templates...");
	// END

	MissionSources.AddItem(CreateGenericMissionSourceTemplate());
	// WOTC DEBUGGING:
	`Log(">>>    Done");
	// END

	return MissionSources;
}

static function X2DataTemplate CreateGenericMissionSourceTemplate()
{
	local X2MissionSourceTemplate Template;
	`CREATE_X2TEMPLATE(class'X2MissionSourceTemplate', Template, 'MissionSource_LWSGenericMissionSource');
	Template.bShowRewardOnPin = true;
	Template.bSkipRewardsRecap = true;
	Template.bDisconnectRegionOnFail = false;
	Template.OnSuccessFn = GenericMissionSourceOnSuccess;
	Template.OnFailureFn = GenericMissionSourceOnFailure;
	Template.OnExpireFn = GenericMissionSourceOnExpire; // shouldn't need this, since missions won't expire in base-game manner and call this
	//Template.MissionImage = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Supply_Raid"; // mission image now drawn from activity
	Template.GetMissionDifficultyFn = GenericGetMissionDifficulty;

	//Create and spawn aren't needed for these because missions are directly spawned out of the Alien Activity
	//Template.CreateMissionsFn = CreateGenericMissionSourceMission;
	//Template.SpawnMissionsFn = SpawnGenericMissionSourceMission;
	Template.MissionPopupFn = none; //popup drawn separately from activity
	Template.GetOverworldMeshPathFn = GetGenericMissionSourceOverworldMeshPath;
	Template.WasMissionSuccessfulFn = GenericWasMissionSuccessful;
	
	// WOTC TODO: Consider adding sitreps to missions at a later date.
	Template.bBlockSitrepDisplay = true;
	Template.GetSitRepsFn = none;
	return Template;
}

function bool GenericWasMissionSuccessful(XComGameState_BattleData BattleDataState)
{
	local XComGameStateHistory History;
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity AlienActivity;

	History = `XCOMHISTORY;
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleDataState.m_iMissionID));
	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);

	if(AlienActivity.GetMyTemplate().WasMissionSuccessfulFn != none)
		return AlienActivity.GetMyTemplate().WasMissionSuccessfulFn(AlienActivity, MissionState, BattleDataState);

	return (BattleDataState.OneStrategyObjectiveCompleted());
}

static function string GetGenericMissionSourceOverworldMeshPath(XComGameState_MissionSite MissionState)
{
	local XComGameState_LWAlienActivity AlienActivity;

	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);
	return AlienActivity.GetOverworldMeshPath(MissionState);
}

static function GenericMissionSourceOnSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_LWAlienActivity AlienActivity;

	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);
	if(AlienActivity.GetMyTemplate().OnMissionSuccessFn != none)
	{
		AlienActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', AlienActivity.ObjectID));
		AlienActivity.GetMyTemplate().OnMissionSuccessFn(AlienActivity, MissionState, NewGameState);
	}
	SpawnPointOfInterest(NewGameState, MissionState);
}

static function GenericMissionSourceOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_LWAlienActivity AlienActivity;

	if (MissionState.POIToSpawn.ObjectID > 0)
	{
		class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	}
	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);
	if(AlienActivity.GetMyTemplate().OnMissionFailureFn != none)
	{
		AlienActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', AlienActivity.ObjectID));
		AlienActivity.GetMyTemplate().OnMissionFailureFn(AlienActivity, MissionState, NewGameState);
	}
}

//this should never get called, but we'll keep it here just in case
static function GenericMissionSourceOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_LWAlienActivity AlienActivity;

	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);
	if(AlienActivity.GetMyTemplate().OnMissionFailureFn != none)
	{
		AlienActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', AlienActivity.ObjectID));
		AlienActivity.GetMyTemplate().OnMissionFailureFn(AlienActivity, MissionState, NewGameState);
		//AlienActivity.GetMyTemplate().OnMissionExpireFn(AlienActivity, MissionState, NewGameState);
	}
}

function int GenericGetMissionDifficulty(XComGameState_MissionSite MissionState)
{
	local int Difficulty;

	Difficulty = MissionState.GetMissionSource().DifficultyValue;

	Difficulty = Clamp(Difficulty, class'X2StrategyGameRulesetDataStructures'.default.MinMissionDifficulty,
					   class'X2StrategyGameRulesetDataStructures'.default.MaxMissionDifficulty);

	return Difficulty;
}

//**********************************************
//------- UTILITY HELPERS ---------------------
//**********************************************

static function SpawnPointOfInterest(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_PointOfInterest POIState;

	History = `XCOMHISTORY;
	if (MissionState.POIToSpawn.ObjectID != 0)
	{
		POIState = XComGameState_PointOfInterest(History.GetGameStateForObjectID(MissionState.POIToSpawn.ObjectID));

		if (POIState != none)
		{
			POIState = XComGameState_PointOfInterest(NewGameState.CreateStateObject(class'XComGameState_PointOfInterest', POIState.ObjectID));
			NewGameState.AddStateObject(POIState);
			POIState.Spawn(NewGameState);
		}
	}
}

static function LoseContactWithMissionRegion(XComGameState NewGameState, XComGameState_MissionSite MissionState, bool bRecord)
{
	local XComGameState_WorldRegion RegionState;
	local XGParamTag ParamTag;
	local EResistanceLevelType OldResLevel;
	local int OldIncome, NewIncome, IncomeDelta;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(MissionState.Region.ObjectID));

	if (RegionState == none)
	{
		RegionState = XComGameState_WorldRegion(NewGameState.CreateStateObject(class'XComGameState_WorldRegion', MissionState.Region.ObjectID));
		NewGameState.AddStateObject(RegionState);
	}

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = RegionState.GetMyTemplate().DisplayName;
	OldResLevel = RegionState.ResistanceLevel;
	OldIncome = RegionState.GetSupplyDropReward();

	RegionState.SetResistanceLevel(NewGameState, eResLevel_Unlocked);
	
	NewIncome = RegionState.GetSupplyDropReward();
	IncomeDelta = NewIncome - OldIncome;

	if (bRecord)
	{
		if(RegionState.ResistanceLevel < OldResLevel)
		{
			class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, `XEXPAND.ExpandString(class'UIRewardsRecap'.default.m_strRegionLostContact), true);
		}

		if(IncomeDelta < 0)
		{
			ParamTag.StrValue0 = string(-IncomeDelta);
			class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, `XEXPAND.ExpandString(class'UIRewardsRecap'.default.m_strDecreasedSupplyIncome), true);
		}
	}
}

static function bool OneStrategyObjectiveCompleted(XComGameState_BattleData BattleDataState)
{
	return (BattleDataState.OneStrategyObjectiveCompleted());
}

static function bool IsInStartingRegion(XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(MissionState.Region.ObjectID));

	return (RegionState != none && RegionState.IsStartingRegion());
}

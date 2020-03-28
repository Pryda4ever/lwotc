//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_DepthPerception
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up aim and defense bonuses for DP
//--------------------------------------------------------------------------------------- 

class X2Effect_DepthPerception extends X2Effect_Persistent config (LW_SoldierSkills);

var int AimBonus;
var int AntiDodgeBonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo1, ShotInfo2;
	local int DodgeReduction;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if(SourceWeapon != none)
    {
		if (Attacker.HasHeightAdvantageOver(Target, true))
		{
		    ShotInfo1.ModType = eHit_Success;
            ShotInfo1.Reason = FriendlyName;
			ShotInfo1.Value = AimBonus;
            ShotModifiers.AddItem(ShotInfo1);

			DodgeReduction = Min (AntiDodgeBonus, Target.GetCurrentStat(eStat_Dodge));

			ShotInfo2.ModType = eHit_Graze;
			ShotInfo2.Reason = FriendlyName;
			ShotInfo2.Value = -1 * DodgeReduction;
			ShotModifiers.AddItem(ShotInfo2);
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="DepthPerception"
}




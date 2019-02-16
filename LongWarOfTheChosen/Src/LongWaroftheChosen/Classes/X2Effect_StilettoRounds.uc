class X2Effect_StilettoRounds extends X2Effect_Persistent;

var int BonusDmg;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local XComGameState_Unit TargetUnit;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && SourceWeapon.LoadedAmmo.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
		TargetUnit = XComGameState_Unit(TargetDamageable);
		if(TargetUnit != none)
		{
			if (!TargetUnit.IsAdvent() && !TargetUnit.IsRobotic())
			{
				if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
				{
					return BonusDmg;
				}
			}
		}
	}
}

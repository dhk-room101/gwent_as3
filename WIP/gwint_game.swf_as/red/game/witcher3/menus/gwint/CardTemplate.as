package red.game.witcher3.menus.gwint 
{
    import flash.utils.*;
    
    public class CardTemplate extends Object
    {
        public function CardTemplate()
        {
            super();
            return;
        }

        public function getPlacementType():int
        {
            return this.typeArray & CardType_SeigeRangedMelee;
        }

        public function getTypeString():String
        {
            if (this.isType(CardType_Row_Modifier)) 
            {
                return "horn";
            }
            if (this.isType(CardType_Weather)) 
            {
                if (this.hasEffect(CardEffect_ClearSky) || this.hasEffect(CardEffect_Clear_Weather)) 
                {
                    return "clearsky";
                }
                if (this.hasEffect(CardEffect_Melee)) 
                {
                    return "frost";
                }
                if (this.hasEffect(CardEffect_Ranged)) 
                {
                    return "fog";
                }
                if (this.hasEffect(CardEffect_Siege)) 
                {
                    return "rain";
                }
            }
            else if (this.isType(CardType_Spell)) 
            {
                if (this.hasEffect(CardEffect_UnsummonDummy)) 
                {
                    return "dummy";
                }
            }
            else if (this.isType(CardType_Global_Effect)) 
            {
                if (this.hasEffect(CardEffect_Scorch)) 
                {
                    return "scorch";
                }
            }
            else if (this.isType(CardType_Hero)) 
            {
                return "Hero";
            }
            return this.getPlacementTypeString();
        }

        public function getPlacementTypeString():String
        {
            if (this.isType(CardType_Creature)) 
            {
                if (this.isType(CardType_RangedMelee)) 
                {
                    return "RangedMelee";
                }
                if (this.isType(CardType_Melee)) 
                {
                    return "Melee";
                }
                if (this.isType(CardType_Ranged)) 
                {
                    return "Ranged";
                }
                if (this.isType(CardType_Siege)) 
                {
                    return "Siege";
                }
            }
            return "None";
        }

        public function getEffectsAsPlacementType():int
        {
            var loc1:*=CardType_None;
            if (this.hasEffect(CardEffect_Melee)) 
            {
                loc1 = loc1 | CardType_Melee;
            }
            if (this.hasEffect(CardEffect_Ranged)) 
            {
                loc1 = loc1 | CardType_Ranged;
            }
            if (this.hasEffect(CardEffect_Siege)) 
            {
                loc1 = loc1 | CardType_Siege;
            }
            return loc1;
        }

        public function getEffectString():String
        {
            if (this.isType(CardType_Creature)) 
            {
                if (this.hasEffect(CardEffect_SummonClones)) 
                {
                    return "summonClones";
                }
                if (this.hasEffect(CardEffect_Nurse)) 
                {
                    return "nurse";
                }
                if (this.hasEffect(CardEffect_Draw2)) 
                {
                    return "spy";
                }
                if (this.hasEffect(CardEffect_SameTypeMorale)) 
                {
                    return "stMorale";
                }
                if (this.hasEffect(CardEffect_ImproveNeighbours)) 
                {
                    return "impNeighbours";
                }
                if (this.hasEffect(CardEffect_Horn)) 
                {
                    return "horn";
                }
                if (this.isType(CardType_RangedMelee)) 
                {
                    return "agile";
                }
                if (this.hasEffect(CardEffect_MeleeScorch)) 
                {
                    return "scorch";
                }
            }
            return "None";
        }

        public function getCreatureType():int
        {
            return this.typeArray & CardType_SeigeRangedMelee;
        }

        public function get tooltipIcon():String
        {
            if (this.isType(CardType_Row_Modifier)) 
            {
                return "horn";
            }
            if (this.isType(CardType_Weather)) 
            {
                if (this.hasEffect(CardEffect_ClearSky) || this.hasEffect(CardEffect_Clear_Weather)) 
                {
                    return "clearsky";
                }
                if (this.hasEffect(CardEffect_Melee)) 
                {
                    return "frost";
                }
                if (this.hasEffect(CardEffect_Ranged)) 
                {
                    return "fog";
                }
                if (this.hasEffect(CardEffect_Siege)) 
                {
                    return "rain";
                }
            }
            else if (this.isType(CardType_Spell)) 
            {
                if (this.hasEffect(CardEffect_UnsummonDummy)) 
                {
                    return "dummy";
                }
            }
            else if (this.isType(CardType_Global_Effect)) 
            {
                if (this.hasEffect(CardEffect_Scorch)) 
                {
                    return "scorch";
                }
            }
            else if (this.isType(CardType_Creature)) 
            {
                if (this.hasEffect(CardEffect_SummonClones)) 
                {
                    return "summonClones";
                }
                if (this.hasEffect(CardEffect_Nurse)) 
                {
                    return "nurse";
                }
                if (this.hasEffect(CardEffect_Draw2)) 
                {
                    return "spy";
                }
                if (this.hasEffect(CardEffect_SameTypeMorale)) 
                {
                    return "stMorale";
                }
                if (this.hasEffect(CardEffect_ImproveNeighbours)) 
                {
                    return "impNeighbours";
                }
                if (this.hasEffect(CardEffect_Horn)) 
                {
                    return "horn";
                }
                if (this.isType(CardType_RangedMelee)) 
                {
                    return "agile";
                }
                if (this.hasEffect(CardEffect_MeleeScorch)) 
                {
                    return "scorch";
                }
            }
            return "None";
        }

        public function get tooltipString():String
        {
            if (this.isType(CardType_Row_Modifier)) 
            {
                return "gwint_card_tooltip_horn";
            }
            if (this.isType(CardType_Weather)) 
            {
                if (this.hasEffect(CardEffect_ClearSky) || this.hasEffect(CardEffect_Clear_Weather)) 
                {
                    return "gwint_card_tooltip_clearsky";
                }
                if (this.hasEffect(CardEffect_Melee)) 
                {
                    return "gwint_card_tooltip_frost";
                }
                if (this.hasEffect(CardEffect_Ranged)) 
                {
                    return "gwint_card_tooltip_fog";
                }
                if (this.hasEffect(CardEffect_Siege)) 
                {
                    return "gwint_card_tooltip_rain";
                }
            }
            else if (this.isType(CardType_Spell)) 
            {
                if (this.hasEffect(CardEffect_UnsummonDummy)) 
                {
                    return "gwint_card_tooltip_dummy";
                }
            }
            else if (this.isType(CardType_Global_Effect)) 
            {
                if (this.hasEffect(CardEffect_Scorch)) 
                {
                    return "gwint_card_tooltip_scorch";
                }
            }
            else if (this.isType(CardType_Creature)) 
            {
                if (this.hasEffect(CardEffect_SummonClones)) 
                {
                    return "gwint_card_tooltip_summon_clones";
                }
                if (this.hasEffect(CardEffect_Nurse)) 
                {
                    return "gwint_card_tooltip_nurse";
                }
                if (this.hasEffect(CardEffect_Draw2)) 
                {
                    return "gwint_card_tooltip_spy";
                }
                if (this.hasEffect(CardEffect_SameTypeMorale)) 
                {
                    return "gwint_card_tooltip_same_type_morale";
                }
                if (this.hasEffect(CardEffect_ImproveNeighbours)) 
                {
                    return "gwint_card_tooltip_improve_neightbours";
                }
                if (this.hasEffect(CardEffect_Horn)) 
                {
                    return "gwint_card_tooltip_horn";
                }
                if (this.isType(CardType_RangedMelee)) 
                {
                    return "gwint_card_tooltip_agile";
                }
                if (this.isType(CardType_Hero)) 
                {
                    return "gwint_card_tooltip_hero";
                }
                if (this.hasEffect(CardEffect_MeleeScorch)) 
                {
                    return "gwint_card_villen_melee_scorch";
                }
            }
            else if (this.isType(CardType_None)) 
            {
                var loc1:*=this.getFirstEffect();
                switch (loc1) 
                {
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Clear_Weather:
                    {
                        return "gwint_card_tooltip_ldr_clear_weather";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Fog:
                    {
                        return "gwint_card_tooltip_ldr_pick_fog";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Horn:
                    {
                        return "gwint_card_tooltip_ldr_siege_horn";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Scorch:
                    {
                        return "gwint_card_tooltip_ldr_siege_scorch";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Frost:
                    {
                        return "gwint_card_tooltip_ldr_pick_frost";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Range_Horn:
                    {
                        return "gwint_card_tooltip_ldr_range_horn";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_11th_card:
                    {
                        return "gwint_card_tooltip_ldr_eleventh_card";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch:
                    {
                        return "gwint_card_tooltip_ldr_melee_scorch";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Rain:
                    {
                        return "gwint_card_tooltip_ldr_pick_rain";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_View_3_Enemy:
                    {
                        return "gwint_card_tooltip_ldr_view_enemy";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Resurect_Enemy:
                    {
                        return "gwint_card_tooltip_ldr_resurect_enemy";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King:
                    {
                        return "gwint_card_tooltip_ldr_counter_king";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Bin2_Pick1:
                    {
                        return "gwint_card_tooltip_ldr_bin_pick";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Weather:
                    {
                        return "gwint_card_tooltip_ldr_pick_weather";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Resurect:
                    {
                        return "gwint_card_tooltip_ldr_resurect";
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee_Horn:
                    {
                        return "gwint_card_tooltip_ldr_melee_horn";
                    }
                }
            }
            return "";
        }

        public function toString():String
        {
            return "[Gwint CardTemplate] index:" + this.index + ", title:" + this.title + ", imageLoc:" + this.imageLoc + ", power:" + this.power + ", facionIdx:" + this.factionIdx + ", type:" + this.typeArray + ", effectString: " + this.getEffectString();
        }

        public function isType(arg1:uint):Boolean
        {
            if (arg1 == CardType_None && !(this.typeArray == 0)) 
            {
                return false;
            }
            return (this.typeArray & arg1) == arg1;
        }

        public function getFirstEffect():int
        {
            if (this.effectFlags == null || this.effectFlags.length == 0) 
            {
                return CardEffect_None;
            }
            return this.effectFlags[0];
        }

        public function hasEffect(arg1:int):Boolean
        {
            var loc1:*=0;
            loc1 = 0;
            while (loc1 < this.effectFlags.length) 
            {
                if (this.effectFlags[loc1] == arg1) 
                {
                    return true;
                }
                ++loc1;
            }
            return false;
        }

        public function GetBonusValue():Number
        {
            var loc1:*=0;
            var loc4:*=NaN;
            var loc2:*=0;
            var loc3:*=red.game.witcher3.menus.gwint.CardManager.getInstance().cardValues.getEffectValueDictionary();
            loc1 = 0;
            while (loc1 < this.effectFlags.length) 
            {
                loc4 = loc3[this.effectFlags[loc1]];
                if (loc4) 
                {
                    loc2 = loc2 + loc4;
                }
                ++loc1;
            }
            return loc2;
        }

        public function GetDeployBonusValue():Number
        {
            var loc1:*=0;
            var loc4:*=NaN;
            var loc2:*=0;
            var loc3:*=red.game.witcher3.menus.gwint.CardManager.getInstance().cardValues.getEffectValueDictionary();
            if (this.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw)) 
            {
                loc2 = loc2 + loc3[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw];
            }
            if (this.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2)) 
            {
                loc2 = loc2 + loc3[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2];
            }
            if (this.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones)) 
            {
                loc2 = loc2 + loc3[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones];
            }
            if (this.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
            {
                loc2 = loc2 + loc3[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw];
            }
            return loc2;
        }

        public function getFactionString():String
        {
            var loc1:*=this.factionIdx;
            switch (loc1) 
            {
                case FactionId_Neutral:
                {
                    return "Neutral";
                }
                case FactionId_No_Mans_Land:
                {
                    return "NoMansLand";
                }
                case FactionId_Nilfgaard:
                {
                    return "Nilfgaard";
                }
                case FactionId_Northern_Kingdom:
                {
                    return "NorthKingdom";
                }
                case FactionId_Scoiatael:
                {
                    return "Scoiatael";
                }
            }
            return "None";
        }

        public static const CardEffect_Horn:int=27;

        public static const CardEffect_Draw:int=28;

        public static const CardEffect_Scorch:int=29;

        public static const CardEffect_ClearSky:int=30;

        public static const CardEffect_SummonClones:int=31;

        public static const CardEffect_ImproveNeighbours:int=32;

        public static const CardEffect_Nurse:int=33;

        public static const CardEffect_Draw2:int=34;

        public static const CardEffect_SameTypeMorale:int=35;

        public static const FactionId_Error:int=-1;

        public static const FactionId_Neutral:int=0;

        public static const FactionId_No_Mans_Land:int=1;

        public static const FactionId_Nilfgaard:int=2;

        public static const FactionId_Northern_Kingdom:int=3;

        public static const FactionId_Scoiatael:int=4;

        public static const CardType_None:uint=0;

        public static const CardType_Melee:uint=1;

        public static const CardType_Ranged:uint=2;

        public static const CardType_RangedMelee:uint=3;

        public static const CardType_Siege:uint=4;

        public static const CardType_SeigeRangedMelee:uint=7;

        public static const CardType_Creature:uint=8;

        public static const CardType_Weather:uint=16;

        public static const CardType_Spell:uint=32;

        public static const CardType_Row_Modifier:uint=64;

        public static const CardType_Hero:uint=128;

        public static const CardType_Spy:uint=256;

        public static const CardType_Friendly_Effect:uint=512;

        public static const CardType_Offsensive_Effect:uint=1024;

        public static const CardType_Global_Effect:uint=2048;

        public static const CardEffect_None:int=0;

        public static const CardEffect_Backstab:int=1;

        public static const CardEffect_Morale_Boost:int=2;

        public static const CardEffect_Ambush:int=3;

        public static const CardEffect_ToughSkin:int=4;

        public static const CardEffect_Bin2:int=5;

        public static const CardEffect_Bin3:int=6;

        public static const CardEffect_MeleeScorch:int=7;

        public static const CardEffect_11th_card:int=8;

        public static const CardEffect_Clear_Weather:int=9;

        public static const CardEffect_Pick_Weather:int=10;

        public static const CardEffect_Pick_Rain:int=11;

        public static const CardEffect_Pick_Fog:int=12;

        public static const CardEffect_Pick_Frost:int=13;

        public static const CardEffect_View_3_Enemy:int=14;

        public static const CardEffect_Resurect:int=15;

        public static const CardEffect_Resurect_Enemy:int=16;

        public static const CardEffect_Bin2_Pick1:int=17;

        public static const CardEffect_Melee_Horn:int=18;

        public static const CardEffect_Range_Horn:int=19;

        public static const CardEffect_Siege_Horn:int=20;

        public static const CardEffect_Siege_Scorch:int=21;

        public static const CardEffect_Counter_King:int=22;

        public static const CardEffect_Melee:int=23;

        public static const CardEffect_Ranged:int=24;

        public static const CardEffect_Siege:int=25;

        public static const CardEffect_UnsummonDummy:int=26;

        public var index:int;

        public var title:String;

        public var description:String;

        public var power:int;

        public var imageLoc:String;

        public var factionIdx:int;

        public var typeArray:uint;

        public var effectFlags:Array;

        public var summonFlags:Array;
    }
}

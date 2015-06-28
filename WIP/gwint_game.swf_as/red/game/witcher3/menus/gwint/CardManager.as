package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;
    import scaleform.clik.core.*;
    
    public class CardManager extends scaleform.clik.core.UIComponent
    {
        public function CardManager()
        {
            this.playerRenderers = new Vector.<red.game.witcher3.menus.gwint.GwintPlayerRenderer>();
            super();
            this.cardEffectManager = new red.game.witcher3.menus.gwint.CardEffectManager();
            this.initializeLists();
            this._cardTemplates = new flash.utils.Dictionary();
            this._cardInstances = new flash.utils.Dictionary();
            _instance = this;
            return;
        }

        public function applyCardEffects(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            if (arg1 != null) 
            {
                arg1.updateEffectsApplied();
            }
            return;
        }

        public function sendToGraveyardID(arg1:int):void
        {
            this.sendToGraveyard(this.getCardInstance(arg1));
            return;
        }

        public function sendToGraveyard(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            if (arg1) 
            {
                if (arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
                {
                    this.addCardInstanceToList(arg1, CARD_LIST_LOC_GRAVEYARD, arg1.owningPlayer);
                }
                else 
                {
                    this.addCardInstanceToList(arg1, CARD_LIST_LOC_GRAVEYARD, arg1.listsPlayer);
                }
            }
            return;
        }

        public function getStrongestNonHeroFromGraveyard(arg1:int):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc3:*=0;
            var loc1:*=this.getCardInstanceList(CARD_LIST_LOC_GRAVEYARD, arg1);
            var loc2:*=null;
            loc3 = 0;
            while (loc3 < loc1.length) 
            {
                if (!loc1[loc3].templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero) && (loc2 == null || loc2.getTotalPower() < loc1[loc3].getTotalPower())) 
                {
                    loc2 = loc1[loc3];
                }
                ++loc3;
            }
            return loc2;
        }

        public function summonFromDeck(arg1:int, arg2:int):Boolean
        {
            var loc2:*=null;
            var loc1:*=false;
            var loc3:*=this.playerDeckDefinitions[arg1];
            while (loc3.tryDrawSpecificCard(arg2)) 
            {
                loc1 = true;
                loc2 = this.spawnCardInstance(arg2, arg1);
                loc2.playSummonedFX = true;
                if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee)) 
                {
                    this.addCardInstanceToList(loc2, CARD_LIST_LOC_MELEE, arg1);
                    continue;
                }
                if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged)) 
                {
                    this.addCardInstanceToList(loc2, CARD_LIST_LOC_RANGED, arg1);
                    continue;
                }
                if (!loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege)) 
                {
                    continue;
                }
                this.addCardInstanceToList(loc2, CARD_LIST_LOC_SEIGE, arg1);
            }
            return loc1;
        }

        public function summonFromHand(arg1:int, arg2:int):void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=0;
            loc1 = this.getCardInstanceList(CARD_LIST_LOC_HAND, arg1);
            loc3 = 0;
            while (loc3 < loc1.length) 
            {
                loc2 = loc1[loc3];
                if (loc2.templateId == arg2) 
                {
                    loc2.playSummonedFX = true;
                    if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee)) 
                    {
                        this.addCardInstanceToList(loc2, CARD_LIST_LOC_MELEE, arg1);
                    }
                    else if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged)) 
                    {
                        this.addCardInstanceToList(loc2, CARD_LIST_LOC_RANGED, arg1);
                    }
                    else if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege)) 
                    {
                        this.addCardInstanceToList(loc2, CARD_LIST_LOC_SEIGE, arg1);
                    }
                    continue;
                }
                ++loc3;
            }
            return;
        }

        public function getHigherOrLowerValueCardFromTargetGraveyard(arg1:int, arg2:Boolean=true, arg3:Boolean=false, arg4:Boolean=false, arg5:Boolean=false):red.game.witcher3.menus.gwint.CardAndComboPoints
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            var loc7:*=null;
            var loc8:*=null;
            var loc10:*=0;
            var loc11:*=0;
            var loc13:*=0;
            var loc15:*=null;
            var loc16:*=undefined;
            var loc17:*=null;
            var loc18:*=null;
            var loc19:*=null;
            var loc20:*=null;
            var loc21:*=null;
            var loc22:*=null;
            var loc23:*=undefined;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD, arg1, loc1);
            var loc9:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc12:*=0;
            var loc14:*=new red.game.witcher3.menus.gwint.CardAndComboPoints();
            loc2 = 0;
            while (loc2 < loc1.length) 
            {
                loc4 = loc1[loc2];
                if (loc3 == null) 
                {
                    loc3 = loc4;
                }
                if (loc4.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
                {
                    if (loc7 != null) 
                    {
                        if (loc7 && this.isBetterMatchForGrave(loc4, loc7, arg1, arg2, arg3, arg4)) 
                        {
                            loc7 = loc4;
                        }
                    }
                    else 
                    {
                        loc7 = loc4;
                    }
                }
                else if (loc4.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch)) 
                {
                    loc8 = loc4;
                }
                else if (loc4.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
                {
                    if (loc6 != null) 
                    {
                        if (loc6 && this.isBetterMatchForGrave(loc4, loc6, arg1, arg2, arg3, arg4)) 
                        {
                            loc6 = loc4;
                        }
                    }
                    else 
                    {
                        loc6 = loc4;
                    }
                    loc9.push(loc4);
                }
                else if (loc5 != null) 
                {
                    if (loc5 && this.isBetterMatchForGrave(loc4, loc5, arg1, arg2, arg3, arg4)) 
                    {
                        loc5 = loc4;
                    }
                }
                else 
                {
                    loc5 = loc4;
                }
                ++loc2;
            }
            if (arg5 && loc9.length > 0) 
            {
                loc15 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                loc16 = arg1 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD, loc16, loc15);
                loc21 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                loc2 = 0;
                while (loc2 < loc15.length) 
                {
                    loc18 = loc15[loc2];
                    if (loc17 == null) 
                    {
                        loc17 = loc18;
                    }
                    if (loc18.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
                    {
                        if (loc20 == null) 
                        {
                            loc20 = loc18;
                        }
                        if (loc20 && this.isBetterMatchForGrave(loc18, loc20, loc16, arg2, arg3, arg4)) 
                        {
                            loc20 = loc18;
                        }
                    }
                    else if (loc18.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch)) 
                    {
                        loc22 = loc18;
                    }
                    else if (loc18.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
                    {
                        loc21.push(loc18);
                    }
                    else if (loc19 != null) 
                    {
                        if (loc19 && this.isBetterMatchForGrave(loc18, loc19, loc16, arg2, arg3, arg4)) 
                        {
                            loc19 = loc18;
                        }
                    }
                    else 
                    {
                        loc19 = loc18;
                    }
                    ++loc2;
                }
                if (loc20) 
                {
                    loc13 = Math.max(0, 10 - loc20.getTotalPower());
                    loc11 = loc13;
                }
                else if (loc22) 
                {
                    loc13 = loc22.getTotalPower();
                }
                else if (loc19) 
                {
                    loc13 = loc19.getTotalPower();
                }
                if (loc21) 
                {
                    loc23 = 0;
                    while (loc23 < loc21.length) 
                    {
                        loc13 = loc13 + loc21[loc23].getTotalPower();
                        ++loc23;
                    }
                }
                if (loc6) 
                {
                    loc13 = loc13 + loc6.getTotalPower();
                }
            }
            if (loc7) 
            {
                loc12 = Math.max(0, 10 - loc7.getTotalPower());
                loc10 = loc12;
                loc3 = loc7;
            }
            else if (loc8) 
            {
                loc12 = loc8.getTotalPower();
                loc3 = loc8;
            }
            else if (loc5) 
            {
                loc12 = loc5.getTotalPower();
                loc3 = loc5;
            }
            if (!arg5 && loc9) 
            {
                loc23 = 0;
                while (loc23 < loc9.length) 
                {
                    loc12 = loc12 + loc9[loc23].getTotalPower();
                    ++loc23;
                }
            }
            else if (!loc7 && !loc8 && !loc5 && loc6) 
            {
                loc12 = loc6.getTotalPower();
                loc3 = loc6;
            }
            if (arg5 && loc6) 
            {
                if (!loc11 && !loc10 && loc13 > loc12) 
                {
                    loc14.cardInstance = loc6;
                    loc14.comboPoints = loc13;
                }
                else if (!loc10 && loc11 || loc11 > loc10) 
                {
                    loc14.cardInstance = loc6;
                    loc14.comboPoints = loc13;
                }
                else 
                {
                    loc14.cardInstance = loc3;
                    loc14.comboPoints = loc12;
                }
            }
            else 
            {
                loc14.cardInstance = loc3;
                loc14.comboPoints = loc12;
            }
            return loc14;
        }

        public function isBetterMatchForGrave(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance, arg3:int, arg4:Boolean, arg5:Boolean, arg6:Boolean):Boolean
        {
            var loc9:*=undefined;
            var loc1:*=arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy);
            var loc2:*=arg2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy);
            var loc3:*=arg1.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch);
            var loc4:*=arg2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch);
            var loc5:*=arg1.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse);
            var loc6:*=arg2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse);
            var loc7:*=arg3 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            var loc8:*=this.calculatePlayerScore(CARD_LIST_LOC_MELEE, loc7);
            if (arg5 || arg6) 
            {
                loc9 = arg4 != true ? true : false;
            }
            if (loc1 || loc2) 
            {
                if (!loc2) 
                {
                    return true;
                }
                if (arg5 && loc1 && this.checkIfHigherOrLower(arg1, arg2, loc9)) 
                {
                    return true;
                }
                if (loc1 && this.checkIfHigherOrLower(arg1, arg2, arg4)) 
                {
                    return true;
                }
                return false;
            }
            if (loc3 || loc4) 
            {
                if (loc4) 
                {
                    return false;
                }
                if (loc8 >= 10) 
                {
                    return true;
                }
                return false;
            }
            if (loc5 || loc6) 
            {
                if (!loc6) 
                {
                    return true;
                }
                if (arg6 && loc5 && this.checkIfHigherOrLower(arg1, arg2, loc9)) 
                {
                    return true;
                }
                if (loc5 && this.checkIfHigherOrLower(arg1, arg2, true)) 
                {
                    return true;
                }
                return false;
            }
            if (this.checkIfHigherOrLower(arg1, arg2, arg4)) 
            {
                return true;
            }
            return false;
        }

        public function getHigherOrLowerValueTargetCardOnBoard(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:Boolean=true, arg4:Boolean=false, arg5:Boolean=false):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.getAllCreaturesNonHero(CARD_LIST_LOC_MELEE, arg2, loc1);
            this.getAllCreaturesNonHero(CARD_LIST_LOC_RANGED, arg2, loc1);
            this.getAllCreaturesNonHero(CARD_LIST_LOC_SEIGE, arg2, loc1);
            loc2 = 0;
            while (loc2 < loc1.length) 
            {
                loc4 = loc1[loc2];
                if (arg1.canBeCastOn(loc4)) 
                {
                    if (loc3 != null) 
                    {
                        if (this.isBetterMatch(loc4, loc3, arg2, arg3, arg4, arg5)) 
                        {
                            loc3 = loc4;
                        }
                    }
                    else 
                    {
                        loc3 = loc4;
                    }
                }
                ++loc2;
            }
            return loc3;
        }

        public function isBetterMatch(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance, arg3:int, arg4:Boolean, arg5:Boolean, arg6:Boolean):Boolean
        {
            var loc9:*=undefined;
            var loc1:*=arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy);
            var loc2:*=arg2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy);
            var loc3:*=arg1.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch);
            var loc4:*=arg2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch);
            var loc5:*=arg1.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse);
            var loc6:*=arg2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse);
            var loc7:*=arg3 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            var loc8:*=this.calculatePlayerScore(CARD_LIST_LOC_MELEE, loc7);
            if (arg5 || arg6) 
            {
                loc9 = arg4 != true ? true : false;
            }
            if (loc1 || loc2) 
            {
                if (!loc2) 
                {
                    return true;
                }
                if (arg5 && loc1 && this.checkIfHigherOrLower(arg1, arg2, loc9)) 
                {
                    return true;
                }
                if (loc1 && this.checkIfHigherOrLower(arg1, arg2, arg4)) 
                {
                    return true;
                }
                return false;
            }
            if (loc3 || loc4) 
            {
                if (loc4) 
                {
                    return false;
                }
                if (loc8 >= 10) 
                {
                    return true;
                }
                return false;
            }
            if (loc5 || loc6) 
            {
                if (!loc6) 
                {
                    return true;
                }
                if (arg6 && loc5 && this.checkIfHigherOrLower(arg1, arg2, loc9)) 
                {
                    return true;
                }
                if (loc5 && this.checkIfHigherOrLower(arg1, arg2, true)) 
                {
                    return true;
                }
                return false;
            }
            if (this.checkIfHigherOrLower(arg1, arg2, arg4)) 
            {
                return true;
            }
            return false;
        }

        public function checkIfHigherOrLower(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance, arg3:*):Boolean
        {
            if (arg3) 
            {
                if (arg1.getTotalPower() > arg2.getTotalPower()) 
                {
                    return true;
                }
                return false;
            }
            if (arg1.getTotalPower() < arg2.getTotalPower()) 
            {
                return true;
            }
            return false;
        }

        public function getCardInstance(arg1:int):red.game.witcher3.menus.gwint.CardInstance
        {
            return this._cardInstances[arg1];
        }

        public function recalculateScores():void
        {
            var loc1:*=this.getWinningPlayer();
            var loc2:*=this.calculatePlayerScore(CARD_LIST_LOC_SEIGE, PLAYER_2);
            var loc3:*=this.calculatePlayerScore(CARD_LIST_LOC_RANGED, PLAYER_2);
            var loc4:*=this.calculatePlayerScore(CARD_LIST_LOC_MELEE, PLAYER_2);
            var loc5:*=this.calculatePlayerScore(CARD_LIST_LOC_MELEE, PLAYER_1);
            var loc6:*=this.calculatePlayerScore(CARD_LIST_LOC_RANGED, PLAYER_1);
            var loc7:*=this.calculatePlayerScore(CARD_LIST_LOC_SEIGE, PLAYER_1);
            this.currentPlayerScores[PLAYER_1] = loc5 + loc6 + loc7;
            this.playerRenderers[PLAYER_1].score = this.currentPlayerScores[PLAYER_1];
            this.currentPlayerScores[PLAYER_2] = loc4 + loc3 + loc2;
            this.playerRenderers[PLAYER_2].score = this.currentPlayerScores[PLAYER_2];
            this.playerRenderers[PLAYER_1].setIsWinning(this.currentPlayerScores[PLAYER_1] > this.currentPlayerScores[PLAYER_2]);
            this.playerRenderers[PLAYER_2].setIsWinning(this.currentPlayerScores[PLAYER_2] > this.currentPlayerScores[PLAYER_1]);
            this.boardRenderer.updateRowScores(loc7, loc6, loc5, loc4, loc3, loc2);
            if (loc1 != this.getWinningPlayer()) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_whose_winning_changed");
            }
            return;
        }

        public function getWinningPlayer():int
        {
            if (this.currentPlayerScores[PLAYER_1] > this.currentPlayerScores[PLAYER_2]) 
            {
                return PLAYER_1;
            }
            if (this.currentPlayerScores[PLAYER_1] < this.currentPlayerScores[PLAYER_2]) 
            {
                return PLAYER_2;
            }
            return PLAYER_INVALID;
        }

        public function calculatePlayerScore(arg1:int, arg2:int):int
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=0;
            loc3 = this.getCardInstanceList(arg1, arg2);
            loc2 = 0;
            while (loc2 < loc3.length) 
            {
                loc1 = loc1 + loc3[loc2].getTotalPower();
                ++loc2;
            }
            return loc1;
        }

        public function CalculateCardPowerPotentials():void
        {
            var loc1:*=0;
            var loc2:*=null;
            loc2 = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_1);
            loc1 = 0;
            while (loc1 < loc2.length) 
            {
                loc2[loc1].recalculatePowerPotential(this);
                ++loc1;
            }
            loc2 = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_2);
            loc1 = 0;
            while (loc1 < loc2.length) 
            {
                loc2[loc1].recalculatePowerPotential(this);
                ++loc1;
            }
            return;
        }

        public function GetRessurectionTargets(arg1:int, arg2:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>, arg3:Boolean):void
        {
            var loc1:*=null;
            var loc2:*=this.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD, arg1);
            var loc3:*=0;
            while (loc3 < loc2.length) 
            {
                loc1 = loc2[loc3];
                if (loc1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) && !loc1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                {
                    if (arg3) 
                    {
                        loc1.recalculatePowerPotential(this);
                    }
                    arg2.push(loc1);
                }
                ++loc3;
            }
            return;
        }

        protected function cardSorter(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance):Number
        {
            if (arg1.templateId == arg2.templateId) 
            {
                return 0;
            }
            var loc1:*=arg1.templateRef;
            var loc2:*=arg2.templateRef;
            var loc3:*=loc1.getCreatureType();
            var loc4:*=loc2.getCreatureType();
            if (loc3 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None && loc4 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
            {
                return arg1.templateId - arg2.templateId;
            }
            if (loc3 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
            {
                return -1;
            }
            if (loc4 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
            {
                return 1;
            }
            if (loc1.power != loc2.power) 
            {
                return loc1.power - loc2.power;
            }
            return arg1.templateId - arg2.templateId;
        }

        public function traceRoundResults():void
        {
            var loc1:*=0;
            trace("GFX -------------------------------- START TRACE ROUND RESULTS ----------------------------------");
            trace("GFX =============================================================================================");
            if (this.roundResults != null) 
            {
                loc1 = 0;
                while (loc1 < this.roundResults.length) 
                {
                    trace("GFX - " + this.roundResults[loc1]);
                    ++loc1;
                }
            }
            else 
            {
                trace("GFX -------------- Round Results is empty!!! -------------");
            }
            trace("GFX =============================================================================================");
            trace("GFX ---------------------------------- END TRACE ROUND RESULTS ----------------------------------");
            return;
        }

        public function listIDToString(arg1:int):String
        {
            var loc1:*=arg1;
            switch (loc1) 
            {
                case CARD_LIST_LOC_DECK:
                {
                    return "DECK";
                }
                case CARD_LIST_LOC_HAND:
                {
                    return "HAND";
                }
                case CARD_LIST_LOC_GRAVEYARD:
                {
                    return "GRAVEYARD";
                }
                case CARD_LIST_LOC_SEIGE:
                {
                    return "SEIGE";
                }
                case CARD_LIST_LOC_RANGED:
                {
                    return "RANGED";
                }
                case CARD_LIST_LOC_MELEE:
                {
                    return "MELEE";
                }
                case CARD_LIST_LOC_SEIGEMODIFIERS:
                {
                    return "SEIGEMODIFIERS";
                }
                case CARD_LIST_LOC_RANGEDMODIFIERS:
                {
                    return "RANGEDMODIFIERS";
                }
                case CARD_LIST_LOC_MELEEMODIFIERS:
                {
                    return "MELEEMODIFIERS";
                }
                case CARD_LIST_LOC_WEATHERSLOT:
                {
                    return "WEATHER";
                }
                case CARD_LIST_LOC_LEADER:
                {
                    return "LEADER";
                }
                case CARD_LIST_LOC_INVALID:
                default:
                {
                    return "INVALID";
                }
            }
        }

        private function initializeLists():void
        {
            this.playerDeckDefinitions = new Vector.<red.game.witcher3.menus.gwint.GwintDeck>();
            this.playerDeckDefinitions.push(new red.game.witcher3.menus.gwint.GwintDeck());
            this.playerDeckDefinitions.push(new red.game.witcher3.menus.gwint.GwintDeck());
            this.currentPlayerScores = new Vector.<int>();
            this.currentPlayerScores.push(0);
            this.currentPlayerScores.push(0);
            this.cardListHand = new Array();
            this.cardListHand.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListHand.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListGraveyard = new Array();
            this.cardListGraveyard.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListGraveyard.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeige = new Array();
            this.cardListSeige.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeige.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRanged = new Array();
            this.cardListRanged.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRanged.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMelee = new Array();
            this.cardListMelee.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMelee.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeigeModifier = new Array();
            this.cardListSeigeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeigeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRangedModifier = new Array();
            this.cardListRangedModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRangedModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMeleeModifier = new Array();
            this.cardListMeleeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMeleeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListWeather = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.cardListLeader = new Array();
            this.cardListLeader.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListLeader.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.roundResults = new Vector.<GwintRoundResult>();
            this.roundResults.push(new GwintRoundResult());
            this.roundResults.push(new GwintRoundResult());
            this.roundResults.push(new GwintRoundResult());
            return;
        }

        public function reset():void
        {
            this.boardRenderer.clearAllCards();
            this._cardInstances = new flash.utils.Dictionary();
            this.cardListHand = new Array();
            this.cardListHand.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListHand.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListGraveyard = new Array();
            this.cardListGraveyard.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListGraveyard.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeige = new Array();
            this.cardListSeige.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeige.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRanged = new Array();
            this.cardListRanged.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRanged.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMelee = new Array();
            this.cardListMelee.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMelee.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeigeModifier = new Array();
            this.cardListSeigeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListSeigeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRangedModifier = new Array();
            this.cardListRangedModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListRangedModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMeleeModifier = new Array();
            this.cardListMeleeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListMeleeModifier.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListLeader = new Array();
            this.cardListLeader.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListLeader.push(new Vector.<red.game.witcher3.menus.gwint.CardInstance>());
            this.cardListWeather = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.roundResults[0].reset();
            this.roundResults[1].reset();
            this.roundResults[2].reset();
            this.playerRenderers[0].reset();
            this.playerRenderers[1].reset();
            this.cardEffectManager.flushAllEffects();
            this.recalculateScores();
            return;
        }

        public function getCardTemplate(arg1:int):red.game.witcher3.menus.gwint.CardTemplate
        {
            return this._cardTemplates[arg1];
        }

        
        {
            lastInstanceID = 0;
        }

        public function onGetCardTemplates(arg1:Object, arg2:int):void
        {
            var loc2:*=null;
            var loc1:*=arg1 as Array;
            if (!loc1) 
            {
                throw new Error("GFX - Information sent from WS regarding card templates was total crapola!");
            }
            var loc3:*=0;
            var loc4:*=loc1;
            for each (loc2 in loc4) 
            {
                if (this._cardTemplates[loc2.index] != null) 
                {
                    throw new Error("GFX - receieved a duplicate template, new:" + loc2 + ", old:" + this._cardTemplates[loc2.index]);
                }
                this._cardTemplates[loc2.index] = loc2;
            }
            dispatchEvent(new flash.events.Event(cardTemplatesLoaded, false, false));
            this.cardTemplatesReceived = true;
            return;
        }

        public function updatePlayerLives():void
        {
            var loc2:*=0;
            var loc1:*=new Array();
            loc1.push(2);
            loc1.push(2);
            loc2 = 0;
            while (loc2 < this.roundResults.length) 
            {
                if (this.roundResults[loc2].played) 
                {
                    if (this.roundResults[loc2].winningPlayer == PLAYER_1 || this.roundResults[loc2].winningPlayer == PLAYER_INVALID) 
                    {
                        loc1[PLAYER_2] = Math.max(0, (loc1[PLAYER_2] - 1));
                    }
                    if (this.roundResults[loc2].winningPlayer == PLAYER_2 || this.roundResults[loc2].winningPlayer == PLAYER_INVALID) 
                    {
                        loc1[PLAYER_1] = Math.max(0, (loc1[PLAYER_1] - 1));
                    }
                }
                else 
                {
                    break;
                }
                ++loc2;
            }
            this.playerRenderers[PLAYER_1].setPlayerLives(loc1[PLAYER_1]);
            this.playerRenderers[PLAYER_2].setPlayerLives(loc1[PLAYER_2]);
            return;
        }

        public function getFirstCardInHandWithEffect(arg1:int, arg2:int):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=this.getCardInstanceList(CARD_LIST_LOC_HAND, arg2);
            loc2 = 0;
            while (loc2 < loc1.length) 
            {
                loc3 = loc1[loc2];
                if (loc3.templateRef.hasEffect(arg1)) 
                {
                    return loc3;
                }
                ++loc2;
            }
            return null;
        }

        public function getCardsInHandWithEffect(arg1:int, arg2:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc3:*=0;
            var loc4:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc2:*=this.getCardInstanceList(CARD_LIST_LOC_HAND, arg2);
            loc3 = 0;
            while (loc3 < loc2.length) 
            {
                loc4 = loc2[loc3];
                if (loc4.templateRef.hasEffect(arg1)) 
                {
                    loc1.push(loc4);
                }
                ++loc3;
            }
            return loc1;
        }

        public function getCardsInSlotIdWithEffect(arg1:int, arg2:int, arg3:int=-1):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc2:*=null;
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            if (arg3 != -1) 
            {
                loc5 = this.getCardInstanceList(arg3, arg2);
                loc3 = 0;
                while (loc3 < loc5.length) 
                {
                    loc2 = loc5[loc3];
                    if (loc2.templateRef.hasEffect(arg1)) 
                    {
                        loc1.push(loc2);
                    }
                    ++loc3;
                }
            }
            else 
            {
                loc4 = this.getCardInstanceList(CARD_LIST_LOC_MELEE, arg2);
                loc3 = 0;
                while (loc3 < loc4.length) 
                {
                    loc2 = loc4[loc3];
                    if (loc2.templateRef.hasEffect(arg1)) 
                    {
                        loc1.push(loc2);
                    }
                    ++loc3;
                }
                loc4 = this.getCardInstanceList(CARD_LIST_LOC_RANGED, arg2);
                loc3 = 0;
                while (loc3 < loc4.length) 
                {
                    loc2 = loc4[loc3];
                    if (loc2.templateRef.hasEffect(arg1)) 
                    {
                        loc1.push(loc2);
                    }
                    ++loc3;
                }
                loc4 = this.getCardInstanceList(CARD_LIST_LOC_SEIGE, arg2);
                loc3 = 0;
                while (loc3 < loc4.length) 
                {
                    loc2 = loc4[loc3];
                    if (loc2.templateRef.hasEffect(arg1)) 
                    {
                        loc1.push(loc2);
                    }
                    ++loc3;
                }
            }
            return loc1;
        }

        public function getCardInstanceList(arg1:int, arg2:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc1:*=arg1;
            switch (loc1) 
            {
                case CARD_LIST_LOC_DECK:
                {
                    return null;
                }
                case CARD_LIST_LOC_HAND:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListHand[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_GRAVEYARD:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListGraveyard[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_SEIGE:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListSeige[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_RANGED:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListRanged[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_MELEE:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListMelee[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_SEIGEMODIFIERS:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListSeigeModifier[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_RANGEDMODIFIERS:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListRangedModifier[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_MELEEMODIFIERS:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListMeleeModifier[arg2];
                    }
                    break;
                }
                case CARD_LIST_LOC_WEATHERSLOT:
                {
                    return this.cardListWeather;
                }
                case CARD_LIST_LOC_LEADER:
                {
                    if (arg2 != PLAYER_INVALID) 
                    {
                        return this.cardListLeader[arg2];
                    }
                }
            }
            trace("GFX [WARNING] - CardManager: failed to get card list with player: " + arg2 + ", and listID: " + arg1);
            return null;
        }

        public function clearBoard(arg1:Boolean):void
        {
            var loc1:*=0;
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            while (this.cardListWeather.length > 0) 
            {
                loc4 = this.cardListWeather[0];
                this.addCardInstanceToList(loc4, CARD_LIST_LOC_GRAVEYARD, loc4.owningPlayer);
            }
            loc2 = PLAYER_1;
            while (loc2 <= PLAYER_2) 
            {
                if (arg1) 
                {
                    loc3 = this.chooseCreatureToExclude(loc2);
                }
                this.sendListToGraveyard(CARD_LIST_LOC_MELEE, loc2, loc3);
                this.sendListToGraveyard(CARD_LIST_LOC_RANGED, loc2, loc3);
                this.sendListToGraveyard(CARD_LIST_LOC_SEIGE, loc2, loc3);
                this.sendListToGraveyard(CARD_LIST_LOC_MELEEMODIFIERS, loc2, loc3);
                this.sendListToGraveyard(CARD_LIST_LOC_RANGEDMODIFIERS, loc2, loc3);
                this.sendListToGraveyard(CARD_LIST_LOC_SEIGEMODIFIERS, loc2, loc3);
                ++loc2;
            }
            return;
        }

        private function sendListToGraveyard(arg1:int, arg2:int, arg3:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=null;
            var loc2:*=this.getCardInstanceList(arg1, arg2);
            var loc3:*=0;
            while (loc2.length > loc3) 
            {
                loc1 = loc2[loc3];
                if (loc1 == arg3) 
                {
                    ++loc3;
                    continue;
                }
                if (arg2 == -1) 
                {
                    this.addCardInstanceToList(loc1, CARD_LIST_LOC_GRAVEYARD, loc1.owningPlayer);
                    continue;
                }
                this.addCardInstanceToList(loc1, CARD_LIST_LOC_GRAVEYARD, loc1.listsPlayer);
            }
            return;
        }

        public function chooseCreatureToExclude(arg1:int):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc1:*=null;
            var loc2:*=0;
            if (this.playerDeckDefinitions[arg1].getDeckFaction() == red.game.witcher3.menus.gwint.CardTemplate.FactionId_No_Mans_Land) 
            {
                loc1 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                this.getAllCreaturesNonHero(CARD_LIST_LOC_MELEE, arg1, loc1);
                this.getAllCreaturesNonHero(CARD_LIST_LOC_RANGED, arg1, loc1);
                this.getAllCreaturesNonHero(CARD_LIST_LOC_SEIGE, arg1, loc1);
                if (loc1.length > 0) 
                {
                    loc2 = Math.min(Math.floor(Math.random() * loc1.length), (loc1.length - 1));
                    return loc1[loc2];
                }
            }
            return null;
        }

        public function getAllCreatures(arg1:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            loc3 = this.getCardInstanceList(CARD_LIST_LOC_MELEE, arg1);
            loc2 = 0;
            while (loc2 < loc3.length) 
            {
                loc1.push(loc3[loc2]);
                ++loc2;
            }
            loc3 = this.getCardInstanceList(CARD_LIST_LOC_RANGED, arg1);
            loc2 = 0;
            while (loc2 < loc3.length) 
            {
                loc1.push(loc3[loc2]);
                ++loc2;
            }
            loc3 = this.getCardInstanceList(CARD_LIST_LOC_SEIGE, arg1);
            loc2 = 0;
            while (loc2 < loc3.length) 
            {
                loc1.push(loc3[loc2]);
                ++loc2;
            }
            return loc1;
        }

        public function getAllCreaturesInHand(arg1:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc2:*=0;
            var loc4:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc3:*=this.getCardInstanceList(CARD_LIST_LOC_HAND, arg1);
            loc2 = 0;
            while (loc2 < loc3.length) 
            {
                loc4 = loc3[loc2];
                if (loc4.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
                {
                    loc1.push(loc4);
                }
                ++loc2;
            }
            return loc1;
        }

        public function getAllCreaturesNonHero(arg1:int, arg2:int, arg3:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>):void
        {
            var loc1:*=0;
            var loc2:*=null;
            var loc3:*=this.getCardInstanceList(arg1, arg2);
            if (loc3 == null) 
            {
                throw new Error("GFX [ERROR] - Failed to get card instance list for listID: " + arg1 + ", and playerIndex: " + arg2);
            }
            loc1 = 0;
            while (loc1 < loc3.length) 
            {
                loc2 = loc3[loc1];
                if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) && !loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                {
                    arg3.push(loc2);
                }
                ++loc1;
            }
            return;
        }

        public function replaceCardInstanceIDs(arg1:int, arg2:int):void
        {
            this.replaceCardInstance(this.getCardInstance(arg1), this.getCardInstance(arg2));
            return;
        }

        public function replaceCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance):void
        {
            if (arg2 == null || arg1 == null) 
            {
                return;
            }
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_dummy");
            var loc1:*=arg2.inList;
            var loc2:*=arg2.listsPlayer;
            this.addCardInstanceToList(arg2, CARD_LIST_LOC_HAND, arg2.listsPlayer);
            this.addCardInstanceToList(arg1, loc1, loc2);
            return;
        }

        public function addCardInstanceIDToList(arg1:int, arg2:int, arg3:int):void
        {
            var loc1:*=this.getCardInstance(arg1);
            if (loc1) 
            {
                this.addCardInstanceToList(loc1, arg2, arg3);
            }
            return;
        }

        public function addCardInstanceToList(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:int):void
        {
            this.removeCardInstanceFromItsList(arg1);
            arg1.inList = arg2;
            arg1.listsPlayer = arg3;
            var loc1:*=this.getCardInstanceList(arg2, arg3);
            trace("GFX ====== Adding card with instance ID: " + arg1.instanceId + ", to List ID: " + this.listIDToString(arg2) + ", for player: " + arg3);
            loc1.push(arg1);
            if (this.boardRenderer) 
            {
                this.boardRenderer.wasAddedToList(arg1, arg2, arg3);
            }
            this.recalculateScores();
            if (arg2 == CARD_LIST_LOC_HAND) 
            {
                this.playerRenderers[arg3].numCardsInHand = loc1.length;
            }
            return;
        }

        public function removeCardInstanceFromItsList(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            this.removeCardInstanceFromList(arg1, arg1.inList, arg1.listsPlayer);
            return;
        }

        public function removeCardInstanceFromList(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:int):void
        {
            var loc1:*=null;
            var loc2:*=0;
            if (arg1.inList != CARD_LIST_LOC_INVALID) 
            {
                arg1.inList = CARD_LIST_LOC_INVALID;
                arg1.listsPlayer = PLAYER_INVALID;
                loc1 = this.getCardInstanceList(arg2, arg3);
                if (!loc1) 
                {
                    throw new Error("GFX - Tried to remove from unknown listID:" + arg2 + ", and player:" + arg3 + ", the following card: " + arg1);
                }
                loc2 = loc1.indexOf(arg1);
                if (loc2 < 0 || loc2 >= loc1.length) 
                {
                    throw new Error("GFX - tried to remove card instance from a list that does not contain it: " + arg2 + ", " + arg3 + ", " + arg1);
                }
                loc1.splice(loc2, 1);
                if (this.boardRenderer) 
                {
                    this.boardRenderer.wasRemovedFromList(arg1, arg2, arg3);
                }
                this.recalculateScores();
                if (arg2 == CARD_LIST_LOC_HAND) 
                {
                    this.playerRenderers[arg3].numCardsInHand = loc1.length;
                }
            }
            return;
        }

        public function spawnLeaders():void
        {
            var loc1:*=0;
            var loc2:*=null;
            loc1 = this.playerDeckDefinitions[PLAYER_1].selectedKingIndex;
            loc2 = this.spawnCardInstance(loc1, PLAYER_1);
            this.addCardInstanceToList(loc2, CARD_LIST_LOC_LEADER, PLAYER_1);
            loc1 = this.playerDeckDefinitions[PLAYER_2].selectedKingIndex;
            loc2 = this.spawnCardInstance(loc1, PLAYER_2);
            this.addCardInstanceToList(loc2, CARD_LIST_LOC_LEADER, PLAYER_2);
            return;
        }

        public function getCardLeader(arg1:int):red.game.witcher3.menus.gwint.CardLeaderInstance
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, arg1);
            if (loc1.length < 1) 
            {
                return null;
            }
            return loc1[0] as red.game.witcher3.menus.gwint.CardLeaderInstance;
        }

        public function shuffleAndDrawCards():void
        {
            var loc5:*=0;
            var loc1:*=this.playerDeckDefinitions[PLAYER_1];
            var loc2:*=this.playerDeckDefinitions[PLAYER_2];
            var loc3:*=this.getCardLeader(PLAYER_1);
            var loc4:*=this.getCardLeader(PLAYER_2);
            if (loc1.getDeckKingTemplate() == null || loc2.getDeckKingTemplate() == null) 
            {
                throw new Error("GFX - Trying to shuffle and draw cards when one of the following decks is null:" + loc1.getDeckKingTemplate() + ", " + loc2.getDeckKingTemplate());
            }
            trace("GFX -#AI#------------------- DECK STRENGTH --------------------");
            trace("GFX -#AI#--- PLAYER 1:");
            loc1.shuffleDeck(loc2.originalStength());
            trace("GFX -#AI#--- PLAYER 2:");
            loc2.shuffleDeck(loc1.originalStength());
            trace("GFX -#AI#------------------------------------------------------");
            if (loc3.canBeUsed && loc3.templateRef.getFirstEffect() == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_11th_card) 
            {
                loc3.canBeUsed = false;
                loc5 = 11;
            }
            else 
            {
                loc5 = 10;
            }
            if (red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.tutorialsOn) 
            {
                if (this.tryDrawSpecificCard(PLAYER_1, 3)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 5)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 150)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 115)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 135)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 111)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 145)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 113)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 114)) 
                {
                    --loc5;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 107)) 
                {
                    --loc5;
                }
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
            }
            this.drawCards(PLAYER_1, loc5);
            var loc6:*=this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_1);
            loc6.sort(this.cardSorter);
            if (loc4.canBeUsed && loc4.templateRef.getFirstEffect() == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_11th_card) 
            {
                loc4.canBeUsed = false;
                loc5 = 11;
            }
            else 
            {
                loc5 = 10;
            }
            this.drawCards(PLAYER_2, loc5);
            return;
        }

        public function drawCards(arg1:int, arg2:int):Boolean
        {
            var loc1:*=0;
            this._heroDrawSoundsAllowed = 1;
            this._normalDrawSoundsAllowed = 1;
            loc1 = 0;
            while (loc1 < arg2) 
            {
                if (!this.drawCard(arg1)) 
                {
                    return false;
                }
                ++loc1;
            }
            this._heroDrawSoundsAllowed = -1;
            this._normalDrawSoundsAllowed = -1;
            return true;
        }

        public static function getInstance():red.game.witcher3.menus.gwint.CardManager
        {
            if (_instance == null) 
            {
                _instance = new CardManager();
            }
            return _instance;
        }

        public function getScorchTargets(arg1:int=7, arg2:int=2):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc3:*=0;
            var loc4:*=0;
            var loc5:*=null;
            var loc6:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc2:*=0;
            loc4 = PLAYER_1;
            while (loc4 < PLAYER_2 + 1) 
            {
                if (loc4 == arg2 || arg2 == PLAYER_BOTH) 
                {
                    if ((arg1 & red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee) != red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
                    {
                        loc5 = this.getCardInstanceList(CARD_LIST_LOC_MELEE, loc4);
                        loc3 = 0;
                        while (loc3 < loc5.length) 
                        {
                            loc6 = loc5[loc3];
                            if (loc6.getTotalPower() >= loc2 && !((loc6.templateRef.typeArray & arg1) == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) && !loc6.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                            {
                                if (loc6.getTotalPower() > loc2) 
                                {
                                    loc2 = loc6.getTotalPower();
                                    loc1.length = 0;
                                    loc1.push(loc6);
                                }
                                else 
                                {
                                    loc1.push(loc6);
                                }
                            }
                            ++loc3;
                        }
                    }
                    if ((arg1 & red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged) != red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
                    {
                        loc5 = this.getCardInstanceList(CARD_LIST_LOC_RANGED, loc4);
                        loc3 = 0;
                        while (loc3 < loc5.length) 
                        {
                            loc6 = loc5[loc3];
                            if (loc6.getTotalPower() >= loc2 && !((loc6.templateRef.typeArray & arg1) == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) && !loc6.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                            {
                                if (loc6.getTotalPower() > loc2) 
                                {
                                    loc2 = loc6.getTotalPower();
                                    loc1.length = 0;
                                    loc1.push(loc6);
                                }
                                else 
                                {
                                    loc1.push(loc6);
                                }
                            }
                            ++loc3;
                        }
                    }
                    if ((arg1 & red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege) != red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
                    {
                        loc5 = this.getCardInstanceList(CARD_LIST_LOC_SEIGE, loc4);
                        loc3 = 0;
                        while (loc3 < loc5.length) 
                        {
                            loc6 = loc5[loc3];
                            if (loc6.getTotalPower() >= loc2 && !((loc6.templateRef.typeArray & arg1) == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) && !loc6.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                            {
                                if (loc6.getTotalPower() > loc2) 
                                {
                                    loc2 = loc6.getTotalPower();
                                    loc1.length = 0;
                                    loc1.push(loc6);
                                }
                                else 
                                {
                                    loc1.push(loc6);
                                }
                            }
                            ++loc3;
                        }
                    }
                }
                ++loc4;
            }
            return loc1;
        }

        public function drawCard(arg1:int):Boolean
        {
            var loc1:*=0;
            var loc2:*=null;
            var loc3:*=this.playerDeckDefinitions[arg1];
            if (loc3.cardIndicesInDeck.length > 0) 
            {
                loc1 = this.playerDeckDefinitions[arg1].drawCard();
                loc2 = this.spawnCardInstance(loc1, arg1);
                this.addCardInstanceToList(loc2, CARD_LIST_LOC_HAND, arg1);
                if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                {
                    if (this._heroDrawSoundsAllowed > 0) 
                    {
                        --this._heroDrawSoundsAllowed;
                        red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                    }
                    else if (this._heroDrawSoundsAllowed == -1) 
                    {
                        red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                    }
                }
                else if (this._normalDrawSoundsAllowed > 0) 
                {
                    --this._normalDrawSoundsAllowed;
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
                }
                else if (this._normalDrawSoundsAllowed == -1) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
                }
                trace("GFX - Player ", arg1, " drew the following Card:", loc2);
                return true;
            }
            trace("GFX - Player ", arg1, " has no more cards to draw!");
            return false;
        }

        public function tryDrawAndPlaySpecificCard_Weather(arg1:int, arg2:int):Boolean
        {
            var loc1:*=null;
            var loc2:*=this.playerDeckDefinitions[arg1];
            if (loc2.tryDrawSpecificCard(arg2)) 
            {
                loc1 = this.spawnCardInstance(arg2, arg1);
                this.addCardInstanceToList(loc1, CARD_LIST_LOC_WEATHERSLOT, red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID);
                trace("GFX - Player ", arg1, " drew the following Card:", loc1);
                return true;
            }
            return false;
        }

        public function tryDrawSpecificCard(arg1:int, arg2:int):Boolean
        {
            var loc1:*=null;
            var loc2:*=this.playerDeckDefinitions[arg1];
            if (loc2.tryDrawSpecificCard(arg2)) 
            {
                loc1 = this.spawnCardInstance(arg2, arg1);
                this.addCardInstanceToList(loc1, CARD_LIST_LOC_HAND, arg1);
                trace("GFX - Player ", arg1, " drew the following Card:", loc1);
                return true;
            }
            return false;
        }

        public function mulliganCard(arg1:red.game.witcher3.menus.gwint.CardInstance):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc2:*=undefined;
            var loc3:*=null;
            var loc4:*=null;
            var loc1:*=null;
            if (arg1.owningPlayer >= 0 && arg1.owningPlayer < this.playerDeckDefinitions.length) 
            {
                loc1 = this.playerDeckDefinitions[arg1.owningPlayer];
            }
            if (loc1) 
            {
                loc1.readdCard(arg1.templateId);
                loc2 = loc1.drawCard();
                if (loc2 != red.game.witcher3.menus.gwint.CardInstance.INVALID_INSTANCE_ID) 
                {
                    loc3 = this.spawnCardInstance(loc2, arg1.owningPlayer);
                    if (loc3) 
                    {
                        this.addCardInstanceToList(loc3, CARD_LIST_LOC_HAND, arg1.owningPlayer);
                        this.unspawnCardInstance(arg1);
                        if (loc3.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                        {
                            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                        }
                        loc4 = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_1);
                        loc4.sort(this.cardSorter);
                        return loc3;
                    }
                }
            }
            return null;
        }

        public function spawnCardInstance(arg1:int, arg2:int, arg3:int=-1):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc1:*=null;
            lastInstanceID = lastInstanceID + 1;
            if (arg1 >= 1000) 
            {
                loc1 = new red.game.witcher3.menus.gwint.CardLeaderInstance();
            }
            else 
            {
                loc1 = new red.game.witcher3.menus.gwint.CardInstance();
            }
            var loc2:*=arg3;
            if (loc2 == CARD_LIST_LOC_INVALID) 
            {
                loc2 = CARD_LIST_LOC_DECK;
            }
            loc1.templateId = arg1;
            loc1.templateRef = this.getCardTemplate(arg1);
            loc1.owningPlayer = arg2;
            loc1.instanceId = lastInstanceID;
            this._cardInstances[loc1.instanceId] = loc1;
            loc1.finializeSetup();
            if (this.boardRenderer) 
            {
                this.boardRenderer.spawnCardInstance(loc1, loc2, arg2);
            }
            if (arg3 == CARD_LIST_LOC_INVALID) 
            {
                this.addCardInstanceToList(loc1, CARD_LIST_LOC_HAND, arg2);
            }
            return loc1;
        }

        public function unspawnCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            this.removeCardInstanceFromItsList(arg1);
            if (this.boardRenderer) 
            {
                this.boardRenderer.returnToDeck(arg1);
            }
            delete this._cardInstances[arg1.instanceId];
            return;
        }

        public function applyCardEffectsID(arg1:int):void
        {
            this.applyCardEffects(this.getCardInstance(arg1));
            return;
        }

        public static const CARD_LIST_LOC_SEIGE:int=3;

        public static const PLAYER_1:int=0;

        public static const PLAYER_2:int=1;

        public static const PLAYER_BOTH:int=2;

        public static const CARD_LIST_LOC_INVALID:int=-1;

        public static const CARD_LIST_LOC_DECK:int=0;

        public static const CARD_LIST_LOC_HAND:int=1;

        public static const CARD_LIST_LOC_GRAVEYARD:int=2;

        public static const CARD_LIST_LOC_RANGED:int=4;

        public static const CARD_LIST_LOC_MELEE:int=5;

        public static const CARD_LIST_LOC_SEIGEMODIFIERS:int=6;

        public static const CARD_LIST_LOC_RANGEDMODIFIERS:int=7;

        public static const CARD_LIST_LOC_MELEEMODIFIERS:int=8;

        public static const CARD_LIST_LOC_WEATHERSLOT:int=9;

        public static const CARD_LIST_LOC_LEADER:int=10;

        public static const cardTemplatesLoaded:String="CardManager.templates.received";

        public static const PLAYER_INVALID:int=-1;

        private var cardListWeather:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        private var cardListLeader:Array;

        private var cardListGraveyard:Array;

        public var _cardTemplates:flash.utils.Dictionary=null;

        private var _cardInstances:flash.utils.Dictionary;

        public var cardTemplatesReceived:Boolean=false;

        public var boardRenderer:red.game.witcher3.menus.gwint.GwintBoardRenderer;

        public var cardValues:red.game.witcher3.menus.gwint.GwintCardValues;

        public var cardEffectManager:red.game.witcher3.menus.gwint.CardEffectManager;

        public var playerDeckDefinitions:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.GwintDeck>;

        public var playerRenderers:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.GwintPlayerRenderer>;

        private var _normalDrawSoundsAllowed:int=-1;

        public var currentPlayerScores:__AS3__.vec.Vector.<int>;

        public var roundResults:__AS3__.vec.Vector.<GwintRoundResult>;

        private var cardListHand:Array;

        private var cardListSeige:Array;

        private var cardListRanged:Array;

        private var cardListMelee:Array;

        private var cardListSeigeModifier:Array;

        private var cardListRangedModifier:Array;

        protected static var _instance:red.game.witcher3.menus.gwint.CardManager;

        private var cardListMeleeModifier:Array;

        private static var lastInstanceID:int=0;

        private var _heroDrawSoundsAllowed:int=-1;
    }
}

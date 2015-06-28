package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    
    public class CardInstance extends Object
    {
        public function CardInstance()
        {
            this.owningPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            this.inList = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_INVALID;
            this.listsPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            this.effectingCardsRefList = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.effectedByCardsRefList = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.lastListApplied = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_INVALID;
            this.lastListPlayerApplied = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            this._lastCalculatedPowerPotential = new red.game.witcher3.menus.gwint.CardTransaction();
            super();
            return;
        }

        protected function removeFromEffectingList(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=this.effectingCardsRefList.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.effectingCardsRefList.splice(loc1, 1);
                arg1.removeEffect(this);
                this.powerChangeCallback();
            }
            return;
        }

        protected function addToEffectingList(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            this.effectingCardsRefList.push(arg1);
            arg1.addEffect(this);
            return;
        }

        protected function addEffect(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            this.effectedByCardsRefList.push(arg1);
            this.powerChangeCallback();
            return;
        }

        protected function removeEffect(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=this.effectedByCardsRefList.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.effectedByCardsRefList.splice(loc1, 1);
                this.powerChangeCallback();
            }
            return;
        }

        public function updateEffectsApplied(arg1:red.game.witcher3.menus.gwint.CardInstance=null):void
        {
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            var loc8:*=null;
            var loc9:*=0;
            var loc10:*=null;
            var loc11:*=0;
            var loc12:*=null;
            var loc13:*=false;
            var loc14:*=null;
            var loc15:*=0;
            var loc16:*=false;
            var loc1:*=red.game.witcher3.menus.gwint.CardFXManager.getInstance();
            var loc2:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc7:*=red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance();
            trace("GFX - updateEffectsApplied Called ----------");
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) && !this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
            {
                loc4 = loc2.cardEffectManager.getEffectsForList(this.inList, this.listsPlayer);
                trace("GFX - fetched: ", loc4.length, ", effects for list:", this.inList, ", and Player:", this.listsPlayer);
                loc3 = 0;
                while (loc3 < loc4.length) 
                {
                    loc6 = loc4[loc3];
                    if (loc6 != this) 
                    {
                        loc6.addToEffectingList(this);
                    }
                    ++loc3;
                }
            }
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
            {
                if (!this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ClearSky)) 
                {
                    loc4 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee)) 
                    {
                        loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, red.game.witcher3.menus.gwint.CardManager.PLAYER_1, loc4);
                        loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, red.game.witcher3.menus.gwint.CardManager.PLAYER_2, loc4);
                        loc2.cardEffectManager.registerActiveEffectCardInstance(this, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
                        loc2.cardEffectManager.registerActiveEffectCardInstance(this, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
                        trace("GFX - Applying Melee Weather Effect");
                    }
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged)) 
                    {
                        loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, red.game.witcher3.menus.gwint.CardManager.PLAYER_1, loc4);
                        loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, red.game.witcher3.menus.gwint.CardManager.PLAYER_2, loc4);
                        loc2.cardEffectManager.registerActiveEffectCardInstance(this, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
                        loc2.cardEffectManager.registerActiveEffectCardInstance(this, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
                        trace("GFX - Applying Ranged Weather Effect");
                    }
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege)) 
                    {
                        loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, red.game.witcher3.menus.gwint.CardManager.PLAYER_1, loc4);
                        loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, red.game.witcher3.menus.gwint.CardManager.PLAYER_2, loc4);
                        loc2.cardEffectManager.registerActiveEffectCardInstance(this, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
                        loc2.cardEffectManager.registerActiveEffectCardInstance(this, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
                        trace("GFX - Applying SIEGE Weather Effect");
                    }
                    loc3 = 0;
                    while (loc3 < loc4.length) 
                    {
                        loc6 = loc4[loc3];
                        this.addToEffectingList(loc6);
                        ++loc3;
                    }
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Scorch)) 
            {
                loc8 = loc2.getScorchTargets();
                trace("GFX - Applying Scorch Effect, number of targets: " + loc8.length);
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
                loc9 = 0;
                while (loc9 < loc8.length) 
                {
                    loc1.playScorchEffectFX(loc8[loc9], this.onScorchFXEnd);
                    ++loc9;
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch)) 
            {
                if (loc2.calculatePlayerScore(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, this.notListPlayer) >= 10) 
                {
                    loc10 = loc2.getScorchTargets(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee, this.notListPlayer);
                    trace("GFX - Applying scorchMeleeList, number of targets: " + loc10.length);
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
                    loc3 = 0;
                    while (loc3 < loc10.length) 
                    {
                        loc1.playScorchEffectFX(loc10[loc3], this.onScorchFXEnd);
                        ++loc3;
                    }
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Horn)) 
            {
                trace("GFX - Applying Horn Effect ----------");
                loc11 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_INVALID;
                if (this.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS || this.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE) 
                {
                    loc11 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE;
                }
                else if (this.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS || this.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED) 
                {
                    loc11 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED;
                }
                else if (this.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS || this.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE) 
                {
                    loc11 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE;
                }
                if (loc11 != red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                {
                    loc4 = loc2.getCardInstanceList(loc11, this.listsPlayer);
                    if (loc4) 
                    {
                        loc3 = 0;
                        while (loc3 < loc4.length) 
                        {
                            loc6 = loc4[loc3];
                            if (!loc6.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero) && !(loc6 == this)) 
                            {
                                this.addToEffectingList(loc6);
                            }
                            ++loc3;
                        }
                    }
                    loc1.playerCardEffectFX(this, null);
                    loc1.playRowEffect(loc11, this.listsPlayer);
                    loc2.cardEffectManager.registerActiveEffectCardInstance(this, loc11, this.listsPlayer);
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
            {
                loc5 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                loc2.GetRessurectionTargets(this.listsPlayer, loc5, true);
                trace("GFX - Applying Nurse Effect");
                if (loc5.length > 0) 
                {
                    if (loc7.playerControllers[this.listsPlayer] is red.game.witcher3.menus.gwint.AIPlayerController) 
                    {
                        loc12 = loc2.getHigherOrLowerValueCardFromTargetGraveyard(this.listsPlayer, true, true, false);
                        loc6 = loc12.cardInstance;
                        this.handleNurseChoice(loc6.instanceId);
                    }
                    else 
                    {
                        loc7.mcChoiceDialog.showDialogCardInstances(loc5, this.handleNurseChoice, this.noNurseChoice, "[[gwint_choose_card_to_ressurect]]");
                    }
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours)) 
            {
                loc4 = loc2.getCardInstanceList(this.inList, this.listsPlayer);
                trace("GFX - Applying Improve Neightbours effect");
                loc3 = 0;
                while (loc3 < loc4.length) 
                {
                    loc6 = loc4[loc3];
                    if (!loc6.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero) && !(loc6 == this)) 
                    {
                        this.addToEffectingList(loc6);
                    }
                    ++loc3;
                }
                loc1.playerCardEffectFX(this, null);
                loc2.cardEffectManager.registerActiveEffectCardInstance(this, this.inList, this.listsPlayer);
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SameTypeMorale)) 
            {
                loc4 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                loc2.getAllCreaturesNonHero(this.inList, this.listsPlayer, loc4);
                trace("GFX - Applying Right Bonds effect");
                loc13 = false;
                loc3 = 0;
                while (loc3 < loc4.length) 
                {
                    loc6 = loc4[loc3];
                    if (!(loc6 == this) && !(this.templateRef.summonFlags.indexOf(loc6.templateId) == -1)) 
                    {
                        loc6.addToEffectingList(this);
                        this.addToEffectingList(loc6);
                        red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                        loc1.playTightBondsFX(loc6, null);
                        loc13 = true;
                    }
                    ++loc3;
                }
                if (loc13) 
                {
                    loc1.playTightBondsFX(this, null);
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones)) 
            {
                loc14 = loc2.playerDeckDefinitions[this.listsPlayer];
                loc4 = loc2.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, this.listsPlayer);
                loc16 = false;
                loc3 = 0;
                while (loc3 < this.templateRef.summonFlags.length && !loc16) 
                {
                    if (loc14.numCopiesLeft(this.templateRef.summonFlags[loc3]) > 0) 
                    {
                        loc16 = true;
                    }
                    loc15 = 0;
                    while (loc15 < loc4.length) 
                    {
                        if (loc4[loc15].templateId == this.templateRef.summonFlags[loc3]) 
                        {
                            loc16 = true;
                            break;
                        }
                        ++loc15;
                    }
                    ++loc3;
                }
                trace("GFX - Applying Summon Clones Effect, found summons: " + loc16);
                if (loc16) 
                {
                    loc1.playerCardEffectFX(this, this.summonFXEnded);
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2)) 
            {
                trace("GFX - applying draw 2 effect");
                loc2.drawCards(this.listsPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2, 2);
            }
            loc2.recalculateScores();
            return;
        }

        protected function summonFXEnded(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=0;
            var loc2:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            loc1 = 0;
            while (loc1 < this.templateRef.summonFlags.length) 
            {
                loc2.summonFromDeck(this.listsPlayer, this.templateRef.summonFlags[loc1]);
                loc2.summonFromHand(this.listsPlayer, this.templateRef.summonFlags[loc1]);
                ++loc1;
            }
            return;
        }

        protected function handleNurseChoice(arg1:int):void
        {
            var loc5:*=null;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.getCardInstance(arg1);
            var loc3:*=red.game.witcher3.menus.gwint.CardFXManager.getInstance();
            var loc4:*=loc1.boardRenderer;
            if (loc4) 
            {
                loc5 = loc4.getCardSlotById(arg1);
                if (loc5) 
                {
                    loc5.parent.addChild(loc5);
                }
            }
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_resurrect");
            loc3.playRessurectEffectFX(loc2, this.onNurseEffectEnded);
            if (red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.visible) 
            {
                red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }

        protected function noNurseChoice():void
        {
            if (red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.visible) 
            {
                red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }

        protected function onNurseEffectEnded(arg1:red.game.witcher3.menus.gwint.CardInstance=null):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            if (arg1) 
            {
                arg1.recalculatePowerPotential(loc1);
                loc1.addCardInstanceToList(arg1, arg1.getOptimalTransaction().targetSlotID, arg1.getOptimalTransaction().targetPlayerID);
            }
            return;
        }

        protected function onScorchFXEnd(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            red.game.witcher3.menus.gwint.CardManager.getInstance().sendToGraveyard(arg1);
            return;
        }

        protected function powerChangeSorter(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance):Number
        {
            if (arg1.getOptimalTransaction().powerChangeResult == arg2.getOptimalTransaction().powerChangeResult) 
            {
                return arg1.getOptimalTransaction().strategicValue - arg2.getOptimalTransaction().strategicValue;
            }
            return arg1.getOptimalTransaction().powerChangeResult - arg2.getOptimalTransaction().powerChangeResult;
        }

        public function potentialWeatherHarm():int
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=0;
            var loc6:*=null;
            var loc7:*=0;
            var loc8:*=0;
            var loc9:*=0;
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
            {
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance();
                loc2 = loc1.getAllCreaturesInHand(this.listsPlayer);
                loc3 = 0;
                loc5 = 0;
                if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee)) 
                {
                    loc7 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE;
                }
                else if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged)) 
                {
                    loc7 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED;
                }
                else if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege)) 
                {
                    loc7 = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE;
                }
                loc6 = loc1.cardEffectManager.getEffectsForList(loc7, this.listsPlayer);
                loc9 = 0;
                while (loc9 < loc2.length) 
                {
                    loc4 = loc2[loc9];
                    if (loc4.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) && !loc4.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_RangedMelee) && loc4.templateRef.isType(loc7)) 
                    {
                        loc8 = 0;
                        while (loc8 < loc6.length) 
                        {
                            loc4.effectedByCardsRefList.push(loc6[loc8]);
                            ++loc8;
                        }
                        loc5 = loc4.getTotalPower();
                        loc4.effectedByCardsRefList.push(this);
                        loc3 = loc3 + Math.max(0, loc5 - loc4.getTotalPower());
                        loc4.effectedByCardsRefList.length = 0;
                    }
                    ++loc9;
                }
                return loc3;
            }
            return 0;
        }

        public function getTotalPower(arg1:Boolean=false):int
        {
            var loc1:*=0;
            var loc2:*=null;
            var loc3:*=false;
            var loc4:*=0;
            var loc5:*=0;
            var loc6:*=0;
            if (!this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
            {
                loc1 = 0;
                while (loc1 < this.effectedByCardsRefList.length) 
                {
                    loc2 = this.effectedByCardsRefList[loc1];
                    if (loc2.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
                    {
                        loc3 = true;
                    }
                    if (loc2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Horn) || loc2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Horn) || loc2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Range_Horn) || loc2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee_Horn)) 
                    {
                        ++loc4;
                    }
                    if (loc2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours)) 
                    {
                        ++loc5;
                    }
                    if (loc2.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SameTypeMorale)) 
                    {
                        ++loc6;
                    }
                    ++loc1;
                }
            }
            var loc7:*=!arg1 && loc3 ? Math.min(1, red.game.witcher3.menus.gwint.CardManager.getInstance().getCardTemplate(this.templateId).power) : red.game.witcher3.menus.gwint.CardManager.getInstance().getCardTemplate(this.templateId).power;
            var loc8:*=0;
            loc8 = loc8 + loc7 * loc6;
            loc8 = loc8 + loc5;
            if (loc4 > 0) 
            {
                loc8 = loc8 + (loc7 + loc8);
            }
            return loc7 + loc8;
        }

        public function get notOwningPlayer():int
        {
            return this.owningPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
        }

        public function get notListPlayer():int
        {
            return this.listsPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
        }

        public function finializeSetup():void
        {
            return;
        }

        public function toString():String
        {
            return " powerChange[ " + this.getOptimalTransaction().powerChangeResult + " ] , strategicValue[ " + this.getOptimalTransaction().strategicValue + " ] , CardName[ " + this.templateRef.title + " ] [Gwint CardInstance] instanceID:" + this.instanceId + ", owningPlayer[ " + this.owningPlayer + " ], templateId[ " + this.templateId + " ], inList[ " + this.inList + " ]";
        }

        public function canBeCastOn(arg1:red.game.witcher3.menus.gwint.CardInstance):Boolean
        {
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero) || arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
            {
                return false;
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy) && arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) && arg1.listsPlayer == this.listsPlayer && !(arg1.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND) && !(arg1.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD) && !(arg1.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER)) 
            {
                return true;
            }
            return false;
        }

        public function canBePlacedInSlot(arg1:int, arg2:int):Boolean
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_DECK || arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD) 
            {
                return false;
            }
            if (arg2 == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID && arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
            {
                return true;
            }
            if (arg2 == this.listsPlayer && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
            {
                return false;
            }
            if (!this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy) && !(arg2 == this.listsPlayer) && (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) || this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Row_Modifier))) 
            {
                return false;
            }
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
            {
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee)) 
                {
                    return true;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged)) 
                {
                    return true;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege)) 
                {
                    return true;
                }
            }
            else if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Row_Modifier)) 
            {
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee) && loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS, this.listsPlayer).length == 0) 
                {
                    return true;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged) && loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, this.listsPlayer).length == 0) 
                {
                    return true;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS && this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege) && loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, this.listsPlayer).length == 0) 
                {
                    return true;
                }
            }
            return false;
        }

        public function recalculatePowerPotential(arg1:red.game.witcher3.menus.gwint.CardManager):void
        {
            var loc2:*=null;
            var loc5:*=null;
            var loc7:*=null;
            var loc8:*=null;
            var loc9:*=0;
            var loc13:*=0;
            var loc14:*=0;
            var loc15:*=0;
            var loc16:*=0;
            var loc17:*=0;
            var loc18:*=0;
            var loc19:*=0;
            var loc20:*=0;
            var loc21:*=0;
            var loc22:*=0;
            var loc23:*=0;
            var loc24:*=0;
            var loc25:*=null;
            var loc26:*=0;
            var loc27:*=0;
            var loc28:*=undefined;
            var loc29:*=false;
            var loc30:*=0;
            var loc1:*=0;
            this._lastCalculatedPowerPotential.powerChangeResult = 0;
            this._lastCalculatedPowerPotential.strategicValue = 0;
            this._lastCalculatedPowerPotential.sourceCardInstanceRef = this;
            var loc3:*=arg1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT, red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID);
            var loc4:*=loc3.length > 0 ? loc3[0] : null;
            var loc6:*=this.listsPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            var loc10:*=arg1.getCardsInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Scorch, this.listsPlayer).length > 0;
            var loc11:*=arg1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, this.listsPlayer);
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
            {
                this._lastCalculatedPowerPotential.targetPlayerID = this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy) ? loc6 : this.listsPlayer;
                if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee)) 
                {
                    this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE;
                }
                else if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged)) 
                {
                    this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED;
                }
                else 
                {
                    this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE;
                }
                loc5 = arg1.cardEffectManager.getEffectsForList(this._lastCalculatedPowerPotential.targetSlotID, this.listsPlayer);
                loc1 = 0;
                while (loc1 < loc5.length) 
                {
                    loc2 = loc5[loc1];
                    if (loc2 != this) 
                    {
                        this.effectedByCardsRefList.push(loc2);
                    }
                    ++loc1;
                }
                loc13 = this.getTotalPower();
                this.effectedByCardsRefList.length = 0;
                if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_RangedMelee)) 
                {
                    loc5 = arg1.cardEffectManager.getEffectsForList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer);
                    loc1 = 0;
                    while (loc1 < loc5.length) 
                    {
                        loc2 = loc5[loc1];
                        if (loc2 != this) 
                        {
                            this.effectedByCardsRefList.push(loc2);
                        }
                        ++loc1;
                    }
                    loc14 = this.getTotalPower();
                    this.effectedByCardsRefList.length = 0;
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours)) 
                    {
                        loc7 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, red.game.witcher3.menus.gwint.CardManager.PLAYER_1, loc7);
                        loc15 = loc13 + loc7.length;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, red.game.witcher3.menus.gwint.CardManager.PLAYER_1, loc7);
                        loc16 = loc14 + loc7.length;
                        if (loc16 > loc15 || loc16 == loc15 && Math.random() < 0.5) 
                        {
                            loc13 = loc14;
                            this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED;
                        }
                    }
                    else if (loc14 > loc13 || loc14 == loc13 && Math.random() < 0.5) 
                    {
                        loc13 = loc14;
                        this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED;
                    }
                }
                if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SameTypeMorale) || this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours)) 
                {
                    loc5 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                    if (this._lastCalculatedPowerPotential.targetSlotID == red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee) 
                    {
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, loc5);
                    }
                    if (this._lastCalculatedPowerPotential.targetSlotID == red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged) 
                    {
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, loc5);
                    }
                    if (this._lastCalculatedPowerPotential.targetSlotID == red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege) 
                    {
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, loc5);
                    }
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours)) 
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + loc5.length;
                    }
                    else 
                    {
                        loc1 = 0;
                        while (loc1 < loc5.length) 
                        {
                            loc2 = loc5[loc1];
                            if (loc2.templateId == this.templateId) 
                            {
                                loc17 = loc2.getTotalPower();
                                loc2.effectedByCardsRefList.push(this);
                                this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + (loc2.getTotalPower() - loc17);
                                loc2.effectedByCardsRefList.pop();
                            }
                            ++loc1;
                        }
                    }
                }
                if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones)) 
                {
                    loc18 = 0;
                    loc5 = arg1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, this.listsPlayer);
                    loc1 = 0;
                    while (loc1 < loc5.length) 
                    {
                        if (this.templateRef.summonFlags.indexOf(loc5[loc1].templateId) != -1) 
                        {
                            ++loc18;
                        }
                        ++loc1;
                    }
                    loc1 = 0;
                    while (loc1 < this.templateRef.summonFlags.length) 
                    {
                        loc18 = loc18 + arg1.playerDeckDefinitions[this.listsPlayer].numCopiesLeft(this.templateRef.summonFlags[loc1]);
                        ++loc1;
                    }
                    this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + loc18 * loc13;
                }
                if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult - loc13;
                }
                else 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + loc13;
                }
            }
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
            {
                loc19 = 0;
                loc20 = 0;
                loc7 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ClearSky)) 
                {
                    loc7.length = 0;
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, loc7);
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, loc7);
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, loc7);
                    loc1 = 0;
                    while (loc1 < loc7.length) 
                    {
                        loc19 = loc19 + (loc7[loc1].getTotalPower(true) - loc7[loc1].getTotalPower());
                        ++loc1;
                    }
                    loc7.length = 0;
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, loc6, loc7);
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, loc6, loc7);
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, loc6, loc7);
                    loc1 = 0;
                    while (loc1 < loc7.length) 
                    {
                        loc19 = loc19 - (loc7[loc1].getTotalPower(true) - loc7[loc1].getTotalPower());
                        ++loc1;
                    }
                }
                else 
                {
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee)) 
                    {
                        loc7.length = 0;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, loc7);
                        loc1 = 0;
                        while (loc1 < loc7.length) 
                        {
                            loc2 = loc7[loc1];
                            loc20 = loc2.getTotalPower();
                            loc2.effectedByCardsRefList.push(this);
                            loc19 = loc19 + (loc2.getTotalPower() - loc20);
                            loc2.effectedByCardsRefList.pop();
                            ++loc1;
                        }
                        loc7.length = 0;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, loc6, loc7);
                        loc1 = 0;
                        while (loc1 < loc7.length) 
                        {
                            loc2 = loc7[loc1];
                            loc20 = loc2.getTotalPower();
                            loc2.effectedByCardsRefList.push(this);
                            loc19 = loc19 - (loc2.getTotalPower() - loc20);
                            loc2.effectedByCardsRefList.pop();
                            ++loc1;
                        }
                    }
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged)) 
                    {
                        loc7.length = 0;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, loc7);
                        loc1 = 0;
                        while (loc1 < loc7.length) 
                        {
                            loc2 = loc7[loc1];
                            loc20 = loc2.getTotalPower();
                            loc2.effectedByCardsRefList.push(this);
                            loc19 = loc19 + (loc2.getTotalPower() - loc20);
                            loc2.effectedByCardsRefList.pop();
                            ++loc1;
                        }
                        loc7.length = 0;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, loc6, loc7);
                        loc1 = 0;
                        while (loc1 < loc7.length) 
                        {
                            loc2 = loc7[loc1];
                            loc20 = loc2.getTotalPower();
                            loc2.effectedByCardsRefList.push(this);
                            loc19 = loc19 - (loc2.getTotalPower() - loc20);
                            loc2.effectedByCardsRefList.pop();
                            ++loc1;
                        }
                    }
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege)) 
                    {
                        loc7.length = 0;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, loc7);
                        loc1 = 0;
                        while (loc1 < loc7.length) 
                        {
                            loc2 = loc7[loc1];
                            loc20 = loc2.getTotalPower();
                            loc2.effectedByCardsRefList.push(this);
                            loc19 = loc19 + (loc2.getTotalPower() - loc20);
                            loc2.effectedByCardsRefList.pop();
                            ++loc1;
                        }
                        loc7.length = 0;
                        arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, loc6, loc7);
                        loc1 = 0;
                        while (loc1 < loc7.length) 
                        {
                            loc2 = loc7[loc1];
                            loc20 = loc2.getTotalPower();
                            loc2.effectedByCardsRefList.push(this);
                            loc19 = loc19 - (loc2.getTotalPower() - loc20);
                            loc2.effectedByCardsRefList.pop();
                            ++loc1;
                        }
                    }
                }
                this._lastCalculatedPowerPotential.powerChangeResult = loc19;
                this._lastCalculatedPowerPotential.strategicValue = Math.max(0, arg1.cardValues.weatherCardValue - loc19);
                if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ClearSky)) 
                {
                    this._lastCalculatedPowerPotential.strategicValue = Math.max(this._lastCalculatedPowerPotential.strategicValue, 8);
                }
                this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT;
                this._lastCalculatedPowerPotential.targetPlayerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            }
            var loc12:*=null;
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Scorch)) 
            {
                loc12 = arg1.getScorchTargets();
            }
            if (loc12 != null) 
            {
                loc1 = 0;
                while (loc1 < loc12.length) 
                {
                    loc2 = loc12[loc1];
                    if (loc2.listsPlayer != this.listsPlayer) 
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + loc2.getTotalPower();
                    }
                    else 
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult - loc2.getTotalPower();
                    }
                    ++loc1;
                }
                if (this._lastCalculatedPowerPotential.powerChangeResult < 0) 
                {
                    this._lastCalculatedPowerPotential.strategicValue = -1;
                }
                else 
                {
                    this._lastCalculatedPowerPotential.strategicValue = Math.max(this.templateRef.GetBonusValue(), this._lastCalculatedPowerPotential.powerChangeResult);
                }
                return;
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy)) 
            {
                this._lastCalculatedPowerPotential.targetCardInstanceRef = arg1.getHigherOrLowerValueTargetCardOnBoard(this, this.listsPlayer, false, false, true);
                if (this._lastCalculatedPowerPotential.targetCardInstanceRef) 
                {
                    if (this._lastCalculatedPowerPotential.targetCardInstanceRef.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = 0;
                    }
                    else 
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = -this._lastCalculatedPowerPotential.targetCardInstanceRef.getTotalPower();
                    }
                    if (arg1.cardValues.unsummonCardValue + this._lastCalculatedPowerPotential.powerChangeResult >= 0) 
                    {
                        this._lastCalculatedPowerPotential.strategicValue = Math.abs(this._lastCalculatedPowerPotential.powerChangeResult);
                    }
                    else 
                    {
                        this._lastCalculatedPowerPotential.strategicValue = arg1.cardValues.unsummonCardValue + Math.abs(this._lastCalculatedPowerPotential.powerChangeResult);
                    }
                }
                else 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                    this._lastCalculatedPowerPotential.strategicValue = -1;
                }
            }
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Row_Modifier) && this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Horn)) 
            {
                loc21 = -1;
                loc22 = -1;
                loc23 = -1;
                loc24 = 0;
                loc7 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                if (arg1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS, this.listsPlayer).length == 0) 
                {
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, loc7);
                    loc21 = 0;
                    loc1 = 0;
                    while (loc1 < loc7.length) 
                    {
                        loc2 = loc7[loc1];
                        loc24 = loc2.getTotalPower();
                        loc2.effectedByCardsRefList.push(this);
                        loc21 = loc2.getTotalPower() - loc24;
                        loc2.effectedByCardsRefList.pop();
                        ++loc1;
                    }
                }
                loc7.length = 0;
                if (arg1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, this.listsPlayer).length == 0) 
                {
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, loc7);
                    loc22 = 0;
                    loc1 = 0;
                    while (loc1 < loc7.length) 
                    {
                        loc2 = loc7[loc1];
                        loc24 = loc2.getTotalPower();
                        loc2.effectedByCardsRefList.push(this);
                        loc22 = loc2.getTotalPower() - loc24;
                        loc2.effectedByCardsRefList.pop();
                        ++loc1;
                    }
                }
                loc7.length = 0;
                if (arg1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, this.listsPlayer).length == 0) 
                {
                    arg1.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, loc7);
                    loc23 = 0;
                    loc1 = 0;
                    while (loc1 < loc7.length) 
                    {
                        loc2 = loc7[loc1];
                        loc2.effectedByCardsRefList.push(this);
                        loc23 = loc2.getTotalPower() - loc24;
                        loc2.effectedByCardsRefList.pop();
                        ++loc1;
                    }
                }
                if (loc23 == -1 && loc21 == -1 && loc22 == -1) 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = -1;
                    this._lastCalculatedPowerPotential.strategicValue = -1;
                    return;
                }
                if (loc21 > loc23 && loc21 > loc22) 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = loc21;
                    this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS;
                    this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                }
                else if (loc22 > loc23) 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = loc22;
                    this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS;
                    this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                }
                else 
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = loc23;
                    this._lastCalculatedPowerPotential.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS;
                    this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                }
                if (this._lastCalculatedPowerPotential.powerChangeResult > arg1.cardValues.hornCardValue) 
                {
                    this._lastCalculatedPowerPotential.strategicValue = Math.max(0, arg1.cardValues.hornCardValue * 2 - this._lastCalculatedPowerPotential.powerChangeResult);
                }
                else 
                {
                    this._lastCalculatedPowerPotential.strategicValue = arg1.cardValues.hornCardValue;
                }
            }
            if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch)) 
            {
                loc25 = null;
                loc25 = arg1.getScorchTargets(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee, this.notListPlayer);
                if (!(loc25.length == 0) && arg1.calculatePlayerScore(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, this.notListPlayer) >= 10) 
                {
                    loc1 = 0;
                    loc26 = 0;
                    loc27 = 0;
                    loc1 = 0;
                    while (loc1 < loc25.length) 
                    {
                        loc27 = loc25[loc1].getTotalPower();
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + loc27;
                        loc26 = loc26 + loc27;
                        ++loc1;
                    }
                    if (Math.random() >= 2 / loc25.length || Math.random() >= 4 / loc26) 
                    {
                        this._lastCalculatedPowerPotential.strategicValue = 1;
                    }
                    else 
                    {
                        this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult;
                    }
                }
                else 
                {
                    this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult + arg1.cardValues.scorchCardValue;
                }
            }
            if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
            {
                if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
                {
                    loc28 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                    loc29 = true;
                    loc1 = 0;
                    while (loc1 < loc11.length) 
                    {
                        if (!loc11[loc1].templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
                        {
                            loc29 = false;
                            break;
                        }
                        ++loc1;
                    }
                    arg1.GetRessurectionTargets(this.listsPlayer, loc28, false);
                    if (loc28.length != 0) 
                    {
                        loc1 = 0;
                        while (loc1 < loc28.length) 
                        {
                            if (!loc28[loc1].templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
                            {
                                loc28[loc1].recalculatePowerPotential(arg1);
                            }
                            ++loc1;
                        }
                        loc28.sort(this.powerChangeSorter);
                        loc8 = loc28[(loc28.length - 1)];
                        loc9 = loc8.getOptimalTransaction().powerChangeResult;
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + loc9;
                        if (Math.random() <= 1 / loc11.length || Math.random() >= 8 / loc9) 
                        {
                            this._lastCalculatedPowerPotential.strategicValue = 0;
                        }
                        else 
                        {
                            loc30 = arg1.cardValues.nurseCardValue + loc9;
                            this._lastCalculatedPowerPotential.strategicValue = Math.max(loc30, this.templateRef.power);
                        }
                    }
                    else if (!loc29) 
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                        this._lastCalculatedPowerPotential.strategicValue = -1;
                    }
                }
                else if (this._lastCalculatedPowerPotential.strategicValue == 0) 
                {
                    this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.strategicValue + this.templateRef.power;
                }
            }
            return;
        }

        public function getOptimalTransaction():red.game.witcher3.menus.gwint.CardTransaction
        {
            return this._lastCalculatedPowerPotential;
        }

        public function onFinishedMovingIntoHolder(arg1:int, arg2:int):void
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            if (!(this.lastListApplied == arg1) || !(this.lastListPlayerApplied == arg2)) 
            {
                trace("GFX - finished Moving into holder:", arg1, ", playerID:", arg2, ", for cardInstance:", this);
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance();
                this.lastListApplied = arg1;
                this.lastListPlayerApplied = arg2;
                loc5 = red.game.witcher3.menus.gwint.CardFXManager.getInstance();
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_DECK || arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER) 
                {
                    return;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD || arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND) 
                {
                    while (this.effectingCardsRefList.length > 0) 
                    {
                        this.removeFromEffectingList(this.effectingCardsRefList[0]);
                    }
                    while (this.effectedByCardsRefList.length > 0) 
                    {
                        this.effectedByCardsRefList[0].removeFromEffectingList(this);
                    }
                    this.effectingCardsRefList.length = 0;
                    loc1.cardEffectManager.unregisterActiveEffectCardInstance(this);
                    this.powerChangeCallback();
                    return;
                }
                if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature) || this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy)) 
                {
                    loc5.playCardDeployFX(this, this.updateEffectsApplied);
                }
                else if (this.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
                {
                    if (this.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ClearSky)) 
                    {
                        loc6 = loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT, red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID);
                        trace("GFX - Applying Clear weather effect, numTargets: " + loc6.length);
                        while (loc6.length > 0) 
                        {
                            loc1.sendToGraveyard(loc6[0]);
                        }
                    }
                    else 
                    {
                        loc3 = loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT, red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID);
                        loc2 = 0;
                        while (loc2 < loc3.length) 
                        {
                            loc4 = loc3[loc2];
                            if (loc4.templateRef == this.templateRef && !(loc4 == this)) 
                            {
                                loc1.sendToGraveyard(this);
                                return;
                            }
                            ++loc2;
                        }
                    }
                    loc5.playCardDeployFX(this, this.updateEffectsApplied);
                }
                else 
                {
                    this.updateEffectsApplied();
                }
            }
            return;
        }

        public static const INVALID_INSTANCE_ID:int=-1;

        public var templateId:int;

        public var templateRef:red.game.witcher3.menus.gwint.CardTemplate;

        public var instanceId:int=-1;

        public var owningPlayer:int;

        public var inList:int;

        public var listsPlayer:int;

        public var effectingCardsRefList:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        public var effectedByCardsRefList:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        public var lastListApplied:int;

        public var lastListPlayerApplied:int;

        public var powerChangeCallback:Function;

        public var playSummonedFX:Boolean=false;

        protected var _lastCalculatedPowerPotential:red.game.witcher3.menus.gwint.CardTransaction;
    }
}

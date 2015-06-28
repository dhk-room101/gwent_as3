package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    
    public class CardLeaderInstance extends red.game.witcher3.menus.gwint.CardInstance
    {
        public function CardLeaderInstance()
        {
            super();
            return;
        }

        public function get hasBeenUsed():Boolean
        {
            return !this._canBeUsed;
        }

        public function get canBeUsed():Boolean
        {
            if (!this._canBeUsed) 
            {
                return false;
            }
            return this.canAbilityBeApplied();
        }

        public function set canBeUsed(arg1:Boolean):void
        {
            this._canBeUsed = arg1;
            return;
        }

        public override function finializeSetup():void
        {
            super.finializeSetup();
            if (templateRef == null || templateRef.getFirstEffect() == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_None) 
            {
                throw new Error("GFX [ERROR] tried to finalize card leader with invalid template info - " + templateId);
            }
            this.leaderEffect = templateRef.getFirstEffect();
            if (this.leaderEffect == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King) 
            {
                this._canBeUsed = false;
            }
            return;
        }

        public override function recalculatePowerPotential(arg1:red.game.witcher3.menus.gwint.CardManager):void
        {
            var loc2:*=null;
            var loc7:*=null;
            var loc8:*=0;
            var loc9:*=0;
            var loc10:*=0;
            var loc1:*=0;
            _lastCalculatedPowerPotential.powerChangeResult = 0;
            _lastCalculatedPowerPotential.strategicValue = -1;
            _lastCalculatedPowerPotential.sourceCardInstanceRef = this;
            var loc3:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc4:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc5:*=owningPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            var loc6:*=loc3.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, owningPlayer);
            var loc11:*=templateRef.getFirstEffect();
        }

        protected function canAbilityBeApplied():Boolean
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.playerDeckDefinitions[owningPlayer];
            var loc3:*=new Vector.<int>();
            var loc4:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc5:*=templateRef.getFirstEffect();
            switch (loc5) 
            {
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Clear_Weather:
                {
                    if (loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT, red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID).length == 0) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Fog:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged, loc3);
                    return loc3.length > 0;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Horn:
                {
                    if (loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, owningPlayer).length > 0) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Scorch:
                {
                    if (loc1.getScorchTargets(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege, notOwningPlayer).length == 0 || loc1.calculatePlayerScore(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, notOwningPlayer) < 10) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Frost:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee, loc3);
                    return loc3.length > 0;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Range_Horn:
                {
                    if (loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, owningPlayer).length > 0) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_11th_card:
                {
                    return true;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch:
                {
                    if (loc1.getScorchTargets(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee, notOwningPlayer).length == 0 || loc1.calculatePlayerScore(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, notOwningPlayer) < 10) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Rain:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege, loc3);
                    return loc3.length > 0;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_View_3_Enemy:
                {
                    if (loc1 && loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, notOwningPlayer)) 
                    {
                        return loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, notOwningPlayer).length > 0;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Resurect_Enemy:
                {
                    loc1.GetRessurectionTargets(notOwningPlayer, loc4, false);
                    if (loc4.length == 0) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King:
                {
                    return false;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Bin2_Pick1:
                {
                    loc4 = loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, owningPlayer);
                    return !(loc4 == null) && loc4.length > 1 && loc2.cardIndicesInDeck.length > 0;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Weather:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_None, loc3);
                    return loc3.length > 0;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Resurect:
                {
                    loc1.GetRessurectionTargets(owningPlayer, loc4, false);
                    if (loc4.length == 0) 
                    {
                        return false;
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee_Horn:
                {
                    if (loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS, owningPlayer).length > 0) 
                    {
                        return false;
                    }
                    break;
                }
            }
            return true;
        }

        public function ApplyLeaderAbility(arg1:Boolean):void
        {
            var loc4:*=null;
            var loc5:*=null;
            if (!this._canBeUsed) 
            {
                throw new Error("GFX [ERROR] - Tried to apply a card ability when its disabled!");
            }
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.playerDeckDefinitions[owningPlayer];
            var loc3:*=new Vector.<int>();
            this._canBeUsed = false;
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
            var loc6:*=templateRef.getFirstEffect();
            switch (loc6) 
            {
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Clear_Weather:
                {
                    this.clearWeather();
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Fog:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged, loc3);
                    if (loc3.length > 0) 
                    {
                        loc1.tryDrawAndPlaySpecificCard_Weather(owningPlayer, loc3[0]);
                    }
                    else 
                    {
                        throw new Error("GFX [ERROR] - tried to pick fog but did not have any");
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Horn:
                {
                    this.applyHorn(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, owningPlayer);
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege_Scorch:
                {
                    this.scorch(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege);
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Frost:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee, loc3);
                    if (loc3.length > 0) 
                    {
                        loc1.tryDrawAndPlaySpecificCard_Weather(owningPlayer, loc3[0]);
                    }
                    else 
                    {
                        throw new Error("GFX [ERROR] - tried to pick frost but did not have any");
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Range_Horn:
                {
                    this.applyHorn(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, owningPlayer);
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_11th_card:
                {
                    throw new Error("GFX [ERROR] - tried to apply 11th card ability which should not occur through here");
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch:
                {
                    this.scorch(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee);
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Rain:
                {
                    loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege, loc3);
                    if (loc3.length > 0) 
                    {
                        loc1.tryDrawAndPlaySpecificCard_Weather(owningPlayer, loc3[0]);
                    }
                    else 
                    {
                        throw new Error("GFX [ERROR] - tried to pick Rain but did not have any");
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_View_3_Enemy:
                {
                    if (!arg1) 
                    {
                        this.ShowEnemyHand(3);
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Resurect_Enemy:
                {
                    if (arg1) 
                    {
                        loc5 = loc1.getHigherOrLowerValueCardFromTargetGraveyard(notOwningPlayer, true, true, false, true);
                        if (loc5) 
                        {
                            loc4 = loc5.cardInstance;
                            this.handleResurrectChoice(loc4.instanceId);
                        }
                        else 
                        {
                            throw new Error("GFX [ERROR] - AI tried to ressurect enemy card when there wasn\'t a valid target!");
                        }
                    }
                    else 
                    {
                        this.resurrectGraveyard(notOwningPlayer);
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King:
                {
                    throw new Error("GFX [ERROR] - tried to apply couner king ability which should not occur through here");
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Bin2_Pick1:
                {
                    if (arg1) 
                    {
                        trace("GFX [WARNING] - AI tried to bin2, pick 1 but it was never properly implemented");
                    }
                    else 
                    {
                        this.binPick(2, 1);
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Pick_Weather:
                {
                    this.pickWeather(arg1);
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Resurect:
                {
                    if (arg1) 
                    {
                        loc5 = loc1.getHigherOrLowerValueCardFromTargetGraveyard(owningPlayer, true, true, false);
                        if (loc5) 
                        {
                            loc4 = loc5.cardInstance;
                            this.handleResurrectChoice(loc4.instanceId);
                        }
                        else 
                        {
                            throw new Error("GFX [ERROR] - AI tried to ressurect enemy card when there wasn\'t a valid target!");
                        }
                    }
                    else 
                    {
                        this.resurrectGraveyard(owningPlayer);
                    }
                    break;
                }
                case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee_Horn:
                {
                    this.applyHorn(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS, owningPlayer);
                    break;
                }
            }
            return;
        }

        protected function clearWeather():void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardFXManager.getInstance();
            loc1.spawnFX(null, this.applyClearWeather, loc1._clearWeatherFXClassRef);
            return;
        }

        protected function applyClearWeather(arg1:red.game.witcher3.menus.gwint.CardInstance=null):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT, red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID);
            while (loc2.length > 0) 
            {
                loc1.sendToGraveyard(loc2[0]);
            }
            return;
        }

        protected function applyHorn(arg1:int, arg2:int):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.spawnCardInstance(1, arg2, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER);
            loc1.addCardInstanceToList(loc2, arg1, arg2);
            return;
        }

        protected function scorch(arg1:int):void
        {
            var loc4:*=0;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=red.game.witcher3.menus.gwint.CardFXManager.getInstance();
            var loc3:*=loc1.getScorchTargets(arg1, notOwningPlayer);
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
            loc4 = 0;
            while (loc4 < loc3.length) 
            {
                loc2.playScorchEffectFX(loc3[loc4], onScorchFXEnd);
                ++loc4;
            }
            return;
        }

        protected function ShowEnemyHand(arg1:int):void
        {
            var loc2:*=null;
            var loc6:*=0;
            var loc7:*=0;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc3:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc4:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc5:*=arg1;
            loc2 = loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, notOwningPlayer);
            loc6 = 0;
            while (loc6 < loc2.length) 
            {
                loc3.push(loc2[loc6]);
                ++loc6;
            }
            while (loc5 > 0 && loc3.length > 0) 
            {
                loc7 = Math.min(Math.floor(Math.random() * loc3.length), (loc3.length - 1));
                loc4.push(loc3[loc7]);
                loc3.splice(loc7, 1);
                --loc5;
            }
            if (loc4.length > 0) 
            {
                red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardInstances(loc4, null, this.handleHandShowClose, "[[gwint_showing_enemy_hand]]");
            }
            else 
            {
                throw new Error("GFX [ERROR] - Tried to ShowEnemyHand with no cards chosen?! - " + loc2.length);
            }
            return;
        }

        protected function handleHandShowClose(arg1:int=-1):void
        {
            red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            return;
        }

        protected function resurrectGraveyard(arg1:int):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            loc1.GetRessurectionTargets(arg1, loc2, true);
            if (loc2.length > 0) 
            {
                if (loc2.length != 1) 
                {
                    red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardInstances(loc2, this.handleResurrectChoice, null, "[[gwint_choose_card_to_ressurect]]");
                }
                else 
                {
                    loc1.addCardInstanceToList(loc2[0], red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, owningPlayer);
                }
            }
            else 
            {
                throw new Error("GFX [ERROR] - tried to ressurect from player: " + arg1 + "\'s graveyard but found no cards");
            }
            return;
        }

        protected function handleResurrectChoice(arg1:int=-1):void
        {
            red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            if (arg1 == -1) 
            {
                throw new Error("GFX [ERROR] - tried to ressurect card with no valid id");
            }
            red.game.witcher3.menus.gwint.CardManager.getInstance().addCardInstanceIDToList(arg1, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, owningPlayer);
            return;
        }

        protected function pickWeather(arg1:Boolean):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.playerDeckDefinitions[owningPlayer];
            var loc3:*=new Vector.<int>();
            loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_None, loc3);
            if (loc3.length == 1 || arg1 && loc3.length > 0) 
            {
                loc1.tryDrawAndPlaySpecificCard_Weather(owningPlayer, loc3[0]);
            }
            else if (loc3.length > 0) 
            {
                red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardTemplates(loc3, this.handleCardDrawChoice_Weather, null, "[[gwint_pick_card_to_draw]]");
            }
            else 
            {
                throw new Error("GFX [ERROR] - tried to pick weather card when there was none");
            }
            return;
        }

        protected function handleCardDrawChoice_Weather(arg1:int=-1):void
        {
            red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            if (arg1 == -1) 
            {
                throw new Error("GFX [ERROR] - tried to draw card with invalid ID");
            }
            red.game.witcher3.menus.gwint.CardManager.getInstance().tryDrawAndPlaySpecificCard_Weather(owningPlayer, arg1);
            return;
        }

        protected function binPick(arg1:int, arg2:int):void
        {
            this.numToBin = arg1;
            this.numBinnedSoFar = 0;
            this.numToPick = arg2;
            this.numPickedSoFar = 0;
            if (this.numToBin > this.numBinnedSoFar) 
            {
                this.askBin();
            }
            else if (this.numToPick > this.numPickedSoFar) 
            {
                this.askPick();
            }
            else 
            {
                throw new Error("GFX [ERROR] - called binPick with invalid values");
            }
            return;
        }

        protected function askBin():void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, owningPlayer);
            if (loc1.length == 0) 
            {
                throw new Error("GFX [ERROR] - Tried to bin a card when there are none left in the hand");
            }
            red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardInstances(loc1, this.handleBinChoice, null, "[[gwint_choose_card_to_dump]]");
            return;
        }

        protected function handleBinChoice(arg1:int=-1):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*;
            var loc3:*=((loc2 = this).numBinnedSoFar + 1);
            loc2.numBinnedSoFar = loc3;
            loc1.addCardInstanceIDToList(arg1, red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD, owningPlayer);
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_discard_card");
            if (this.numToBin > this.numBinnedSoFar) 
            {
                this.askBin();
            }
            else if (this.numToPick > this.numPickedSoFar) 
            {
                this.askPick();
            }
            else 
            {
                red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }

        protected function askPick():void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.playerDeckDefinitions[owningPlayer];
            var loc3:*=new Vector.<int>();
            loc2.getCardsInDeck(red.game.witcher3.menus.gwint.CardTemplate.CardType_None, red.game.witcher3.menus.gwint.CardTemplate.CardEffect_None, loc3);
            if (loc3.length == 0) 
            {
                throw new Error("GFX [ERROR] - Tried to pick a card when there are none left in the deck");
            }
            red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardTemplates(loc3, this.handlePickChoice, null, "[[gwint_pick_card_to_draw]]");
            return;
        }

        protected function handlePickChoice(arg1:int=-1):void
        {
            var loc1:*;
            var loc2:*=((loc1 = this).numPickedSoFar + 1);
            loc1.numPickedSoFar = loc2;
            red.game.witcher3.menus.gwint.CardManager.getInstance().tryDrawSpecificCard(owningPlayer, arg1);
            if (this.numToPick > this.numPickedSoFar) 
            {
                this.askPick();
            }
            else 
            {
                red.game.witcher3.menus.gwint.GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }

        public override function toString():String
        {
            return super.toString() + ", canBeUsed: " + this.canBeUsed + ", canBeApplied: " + this.canAbilityBeApplied;
        }

        public var leaderEffect:int;

        private var _canBeUsed:Boolean=true;

        protected var numToBin:int;

        protected var numBinnedSoFar:int;

        protected var numToPick:int;

        protected var numPickedSoFar:int;
    }
}

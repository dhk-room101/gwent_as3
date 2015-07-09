package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;

    public class CardLeaderInstance extends CardInstance
    {
        public var leaderEffect:int;
        private var _canBeUsed:Boolean = true;
        protected var numToBin:int;
        protected var numBinnedSoFar:int;
        protected var numToPick:int;
        protected var numPickedSoFar:int;

        public function CardLeaderInstance()
        {
            return;
        }// end function

        public function get hasBeenUsed() : Boolean
        {
            return !this._canBeUsed;
        }// end function

        public function get canBeUsed() : Boolean
        {
            if (!this._canBeUsed)
            {
                return false;
            }
            return this.canAbilityBeApplied();
        }// end function

        public function set canBeUsed(param1:Boolean) : void
        {
            this._canBeUsed = param1;
            return;
        }// end function

        override public function finializeSetup() : void
        {
            super.finializeSetup();
            if (templateRef == null || templateRef.getFirstEffect() == CardTemplate.CardEffect_None)
            {
                throw new Error("GFX [ERROR] tried to finalize card leader with invalid template info - " + templateId);
            }
            this.leaderEffect = templateRef.getFirstEffect();
            if (this.leaderEffect == CardTemplate.CardEffect_Counter_King)
            {
                this._canBeUsed = false;
            }
            return;
        }// end function

        override public function recalculatePowerPotential(param1:CardManager) : void
        {
            var _loc_3:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_2:* = 0;
            _lastCalculatedPowerPotential.powerChangeResult = 0;
            _lastCalculatedPowerPotential.strategicValue = -1;
            _lastCalculatedPowerPotential.sourceCardInstanceRef = this;
            var _loc_4:* = CardManager.getInstance();
            var _loc_5:* = new Vector.<CardInstance>;
            var _loc_6:* = owningPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
            var _loc_7:* = _loc_4.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, owningPlayer);
            switch(templateRef.getFirstEffect())
            {
                case CardTemplate.CardEffect_11th_card:
                case CardTemplate.CardEffect_Counter_King:
                {
                    break;
                }
                case CardTemplate.CardEffect_Pick_Fog:
                case CardTemplate.CardEffect_Pick_Frost:
                case CardTemplate.CardEffect_Pick_Weather:
                case CardTemplate.CardEffect_Pick_Rain:
                {
                    _lastCalculatedPowerPotential.strategicValue = _loc_4.cardValues.weatherCardValue;
                    break;
                }
                case CardTemplate.CardEffect_View_3_Enemy:
                {
                    _lastCalculatedPowerPotential.strategicValue = 0;
                    break;
                }
                case CardTemplate.CardEffect_Siege_Horn:
                case CardTemplate.CardEffect_Range_Horn:
                case CardTemplate.CardEffect_Melee_Horn:
                {
                    if (templateRef.getFirstEffect() == CardTemplate.CardEffect_Siege_Horn)
                    {
                        _loc_4.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, owningPlayer, _loc_5);
                    }
                    else if (templateRef.getFirstEffect() == CardTemplate.CardEffect_Range_Horn)
                    {
                        _loc_4.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, owningPlayer, _loc_5);
                    }
                    else if (templateRef.getFirstEffect() == CardTemplate.CardEffect_Melee_Horn)
                    {
                        _loc_4.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, owningPlayer, _loc_5);
                    }
                    _loc_10 = 0;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.length)
                    {
                        
                        _loc_3 = _loc_5[_loc_2];
                        _loc_11 = _loc_3.getTotalPower();
                        _loc_3.effectedByCardsRefList.Count(this);
                        _loc_10 = _loc_3.getTotalPower() - _loc_11;
                        _loc_3.effectedByCardsRefList.pop();
                        _loc_2 = _loc_2 + 1;
                    }
                    _lastCalculatedPowerPotential.powerChangeResult = _loc_10;
                    _lastCalculatedPowerPotential.strategicValue = _loc_4.cardValues.hornCardValue;
                    break;
                }
                case CardTemplate.CardEffect_Siege_Scorch:
                {
                    _loc_5 = _loc_4.getScorchTargets(CardTemplate.CardType_Siege, _loc_6);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.length)
                    {
                        
                        _loc_3 = _loc_5[_loc_2];
                        if (_loc_3.listsPlayer == owningPlayer)
                        {
                            _lastCalculatedPowerPotential.powerChangeResult = _lastCalculatedPowerPotential.powerChangeResult - _loc_3.getTotalPower();
                        }
                        else
                        {
                            _lastCalculatedPowerPotential.powerChangeResult = _lastCalculatedPowerPotential.powerChangeResult + _loc_3.getTotalPower();
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    _lastCalculatedPowerPotential.strategicValue = _loc_4.cardValues.scorchCardValue;
                    break;
                }
                case CardTemplate.CardEffect_MeleeScorch:
                {
                    _loc_5 = _loc_4.getScorchTargets(CardTemplate.CardType_Melee, _loc_6);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.length)
                    {
                        
                        _loc_3 = _loc_5[_loc_2];
                        if (_loc_3.listsPlayer == owningPlayer)
                        {
                            _lastCalculatedPowerPotential.powerChangeResult = _lastCalculatedPowerPotential.powerChangeResult - _loc_3.getTotalPower();
                        }
                        else
                        {
                            _lastCalculatedPowerPotential.powerChangeResult = _lastCalculatedPowerPotential.powerChangeResult + _loc_3.getTotalPower();
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    _lastCalculatedPowerPotential.strategicValue = _loc_4.cardValues.scorchCardValue;
                    break;
                }
                case CardTemplate.CardEffect_Clear_Weather:
                {
                    _loc_5.length = 0;
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, owningPlayer, _loc_5);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, owningPlayer, _loc_5);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, owningPlayer, _loc_5);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.length)
                    {
                        
                        _lastCalculatedPowerPotential.powerChangeResult = _lastCalculatedPowerPotential.powerChangeResult + (_loc_3.getTotalPower(true) - _loc_3.getTotalPower());
                        _loc_2 = _loc_2 + 1;
                    }
                    _loc_5.length = 0;
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, _loc_6, _loc_5);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, _loc_6, _loc_5);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, _loc_6, _loc_5);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.length)
                    {
                        
                        _lastCalculatedPowerPotential.powerChangeResult = _lastCalculatedPowerPotential.powerChangeResult - (_loc_3.getTotalPower(true) - _loc_3.getTotalPower());
                        _loc_2 = _loc_2 + 1;
                    }
                    _lastCalculatedPowerPotential.strategicValue = _loc_4.cardValues.weatherCardValue;
                    break;
                }
                case CardTemplate.CardEffect_Resurect_Enemy:
                {
                    _loc_8 = _loc_4.getHigherOrLowerValueCardFromTargetGraveyard(_loc_6, true, true, false, true);
                    if (_loc_8 != null)
                    {
                        _loc_9 = _loc_8.comboPoints;
                        if (_loc_7.length < 8 || Math.random() <= 1 / _loc_7 * 0.5)
                        {
                            _lastCalculatedPowerPotential.strategicValue = Math.max(0, 10 - _loc_9);
                            _lastCalculatedPowerPotential.powerChangeResult = _loc_8.cardInstance.getTotalPower();
                        }
                        else
                        {
                            _lastCalculatedPowerPotential.strategicValue = 1000;
                        }
                    }
                    break;
                }
                case CardTemplate.CardEffect_Resurect:
                {
                    _loc_8 = _loc_4.getHigherOrLowerValueCardFromTargetGraveyard(owningPlayer, true, true, false);
                    if (_loc_8 != null)
                    {
                        _loc_9 = _loc_8.comboPoints;
                        if (_loc_7.length < 8 || Math.random() <= 1 / _loc_7 * 0.5)
                        {
                            _lastCalculatedPowerPotential.strategicValue = Math.max(0, 10 - _loc_9);
                            _lastCalculatedPowerPotential.powerChangeResult = _loc_8.cardInstance.getTotalPower();
                        }
                        else
                        {
                            _lastCalculatedPowerPotential.strategicValue = 1000;
                        }
                    }
                    break;
                }
                case CardTemplate.CardEffect_Bin2_Pick1:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function canAbilityBeApplied() : Boolean
        {
            var _loc_1:* = CardManager.getInstance();
            var _loc_2:* = _loc_1.playerDeckDefinitions[owningPlayer];
            var _loc_3:* = new Vector.<int>;
            var _loc_4:* = new Vector.<CardInstance>;
            switch(templateRef.getFirstEffect())
            {
                case CardTemplate.CardEffect_Clear_Weather:
                {
                    if (_loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT, CardManager.PLAYER_INVALID).length == 0)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Pick_Fog:
                {
                    _loc_2.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_Ranged, _loc_3);
                    return _loc_3.length > 0;
                }
                case CardTemplate.CardEffect_Siege_Horn:
                {
                    if (_loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, owningPlayer).length > 0)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Siege_Scorch:
                {
                    if (_loc_1.getScorchTargets(CardTemplate.CardType_Siege, notOwningPlayer).length == 0 || _loc_1.calculatePlayerScore(CardManager.CARD_LIST_LOC_SEIGE, notOwningPlayer) < 10)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Pick_Frost:
                {
                    _loc_2.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_Melee, _loc_3);
                    return _loc_3.length > 0;
                }
                case CardTemplate.CardEffect_Range_Horn:
                {
                    if (_loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, owningPlayer).length > 0)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_11th_card:
                {
                    return true;
                }
                case CardTemplate.CardEffect_MeleeScorch:
                {
                    if (_loc_1.getScorchTargets(CardTemplate.CardType_Melee, notOwningPlayer).length == 0 || _loc_1.calculatePlayerScore(CardManager.CARD_LIST_LOC_MELEE, notOwningPlayer) < 10)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Pick_Rain:
                {
                    _loc_2.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_Siege, _loc_3);
                    return _loc_3.length > 0;
                }
                case CardTemplate.CardEffect_View_3_Enemy:
                {
                    if (_loc_1 && _loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, notOwningPlayer))
                    {
                        return _loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, notOwningPlayer).length > 0;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Resurect_Enemy:
                {
                    _loc_1.GetRessurectionTargets(notOwningPlayer, _loc_4, false);
                    if (_loc_4.length == 0)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Counter_King:
                {
                    return false;
                }
                case CardTemplate.CardEffect_Bin2_Pick1:
                {
                    _loc_4 = _loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, owningPlayer);
                    return _loc_4 != null && _loc_4.length > 1 && _loc_2.cardIndicesInDeck.length > 0;
                }
                case CardTemplate.CardEffect_Pick_Weather:
                {
                    _loc_2.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_None, _loc_3);
                    return _loc_3.length > 0;
                }
                case CardTemplate.CardEffect_Resurect:
                {
                    _loc_1.GetRessurectionTargets(owningPlayer, _loc_4, false);
                    if (_loc_4.length == 0)
                    {
                        return false;
                    }
                    break;
                }
                case CardTemplate.CardEffect_Melee_Horn:
                {
                    if (_loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS, owningPlayer).length > 0)
                    {
                        return false;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        public function ApplyLeaderAbility(param1:Boolean) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (!this._canBeUsed)
            {
                throw new Error("GFX [ERROR] - Tried to apply a card ability when its disabled!");
            }
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = _loc_2.playerDeckDefinitions[owningPlayer];
            var _loc_4:* = new Vector.<int>;
            this._canBeUsed = false;
            GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
            switch(templateRef.getFirstEffect())
            {
                case CardTemplate.CardEffect_Clear_Weather:
                {
                    this.clearWeather();
                    break;
                }
                case CardTemplate.CardEffect_Pick_Fog:
                {
                    _loc_3.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_Ranged, _loc_4);
                    if (_loc_4.length > 0)
                    {
                        _loc_2.tryDrawAndPlaySpecificCard_Weather(owningPlayer, _loc_4[0]);
                    }
                    else
                    {
                        throw new Error("GFX [ERROR] - tried to pick fog but did not have any");
                    }
                    break;
                }
                case CardTemplate.CardEffect_Siege_Horn:
                {
                    this.applyHorn(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, owningPlayer);
                    break;
                }
                case CardTemplate.CardEffect_Siege_Scorch:
                {
                    this.scorch(CardTemplate.CardType_Siege);
                    break;
                }
                case CardTemplate.CardEffect_Pick_Frost:
                {
                    _loc_3.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_Melee, _loc_4);
                    if (_loc_4.length > 0)
                    {
                        _loc_2.tryDrawAndPlaySpecificCard_Weather(owningPlayer, _loc_4[0]);
                    }
                    else
                    {
                        throw new Error("GFX [ERROR] - tried to pick frost but did not have any");
                    }
                    break;
                }
                case CardTemplate.CardEffect_Range_Horn:
                {
                    this.applyHorn(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, owningPlayer);
                    break;
                }
                case CardTemplate.CardEffect_11th_card:
                {
                    throw new Error("GFX [ERROR] - tried to apply 11th card ability which should not occur through here");
                }
                case CardTemplate.CardEffect_MeleeScorch:
                {
                    this.scorch(CardTemplate.CardType_Melee);
                    break;
                }
                case CardTemplate.CardEffect_Pick_Rain:
                {
                    _loc_3.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_Siege, _loc_4);
                    if (_loc_4.length > 0)
                    {
                        _loc_2.tryDrawAndPlaySpecificCard_Weather(owningPlayer, _loc_4[0]);
                    }
                    else
                    {
                        throw new Error("GFX [ERROR] - tried to pick Rain but did not have any");
                    }
                    break;
                }
                case CardTemplate.CardEffect_View_3_Enemy:
                {
                    if (!param1)
                    {
                        this.ShowEnemyHand(3);
                    }
                    break;
                }
                case CardTemplate.CardEffect_Resurect_Enemy:
                {
                    if (param1)
                    {
                        _loc_6 = _loc_2.getHigherOrLowerValueCardFromTargetGraveyard(notOwningPlayer, true, true, false, true);
                        if (_loc_6)
                        {
                            _loc_5 = _loc_6.cardInstance;
                            this.handleResurrectChoice(_loc_5.instanceId);
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
                case CardTemplate.CardEffect_Counter_King:
                {
                    throw new Error("GFX [ERROR] - tried to apply couner king ability which should not occur through here");
                }
                case CardTemplate.CardEffect_Bin2_Pick1:
                {
                    if (param1)
                    {
                        Console.WriteLine("GFX [WARNING] - AI tried to bin2, pick 1 but it was never properly implemented");
                    }
                    else
                    {
                        this.binPick(2, 1);
                    }
                    break;
                }
                case CardTemplate.CardEffect_Pick_Weather:
                {
                    this.pickWeather(param1);
                    break;
                }
                case CardTemplate.CardEffect_Resurect:
                {
                    if (param1)
                    {
                        _loc_6 = _loc_2.getHigherOrLowerValueCardFromTargetGraveyard(owningPlayer, true, true, false);
                        if (_loc_6)
                        {
                            _loc_5 = _loc_6.cardInstance;
                            this.handleResurrectChoice(_loc_5.instanceId);
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
                case CardTemplate.CardEffect_Melee_Horn:
                {
                    this.applyHorn(CardManager.CARD_LIST_LOC_MELEEMODIFIERS, owningPlayer);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function clearWeather() : void
        {
            var _loc_1:* = CardFXManager.getInstance();
            _loc_1.spawnFX(null, this.applyClearWeather, _loc_1._clearWeatherFXClassRef);
            return;
        }// end function

        protected function applyClearWeather(param1:CardInstance = null) : void
        {
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = _loc_2.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT, CardManager.PLAYER_INVALID);
            while (_loc_3.length > 0)
            {
                
                _loc_2.sendToGraveyard(_loc_3[0]);
            }
            return;
        }// end function

        protected function applyHorn(param1:int, param2:int) : void
        {
            var _loc_3:* = CardManager.getInstance();
            var _loc_4:* = _loc_3.spawnCardInstance(1, param2, CardManager.CARD_LIST_LOC_LEADER);
            _loc_3.addCardInstanceToList(_loc_4, param1, param2);
            return;
        }// end function

        protected function scorch(param1:int) : void
        {
            var _loc_5:* = 0;
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = CardFXManager.getInstance();
            var _loc_4:* = _loc_2.getScorchTargets(param1, notOwningPlayer);
            GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
            _loc_5 = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                _loc_3.playScorchEffectFX(_loc_4[_loc_5], onScorchFXEnd);
                _loc_5++;
            }
            return;
        }// end function

        protected function ShowEnemyHand(param1:int) : void
        {
            var _loc_3:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_2:* = CardManager.getInstance();
            var _loc_4:* = new Vector.<CardInstance>;
            var _loc_5:* = new Vector.<CardInstance>;
            var _loc_6:* = param1;
            _loc_3 = _loc_2.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, notOwningPlayer);
            _loc_7 = 0;
            while (_loc_7 < _loc_3.length)
            {
                
                _loc_4.Count(_loc_3[_loc_7]);
                _loc_7++;
            }
            while (_loc_6 > 0 && _loc_4.length > 0)
            {
                
                _loc_8 = Math.min(Math.floor(Math.random() * _loc_4.length), (_loc_4.length - 1));
                _loc_5.Count(_loc_4[_loc_8]);
                _loc_4.splice(_loc_8, 1);
                _loc_6 = _loc_6 - 1;
            }
            if (_loc_5.length > 0)
            {
                GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardInstances(_loc_5, null, this.handleHandShowClose, "[[gwint_showing_enemy_hand]]");
            }
            else
            {
                throw new Error("GFX [ERROR] - Tried to ShowEnemyHand with no cards chosen?! - " + _loc_3.length);
            }
            return;
        }// end function

        protected function handleHandShowClose(param1:int = -1) : void
        {
            GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            return;
        }// end function

        protected function resurrectGraveyard(param1:int) : void
        {
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = new Vector.<CardInstance>;
            _loc_2.GetRessurectionTargets(param1, _loc_3, true);
            if (_loc_3.length > 0)
            {
                if (_loc_3.length == 1)
                {
                    _loc_2.addCardInstanceToList(_loc_3[0], CardManager.CARD_LIST_LOC_HAND, owningPlayer);
                }
                else
                {
                    GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardInstances(_loc_3, this.handleResurrectChoice, null, "[[gwint_choose_card_to_ressurect]]");
                }
            }
            else
            {
                throw new Error("GFX [ERROR] - tried to ressurect from player: " + param1 + "\'s graveyard but found no cards");
            }
            return;
        }// end function

        protected function handleResurrectChoice(param1:int = -1) : void
        {
            GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            if (param1 == -1)
            {
                throw new Error("GFX [ERROR] - tried to ressurect card with no valid id");
            }
            CardManager.getInstance().addCardInstanceIDToList(param1, CardManager.CARD_LIST_LOC_HAND, owningPlayer);
            return;
        }// end function

        protected function pickWeather(param1:Boolean) : void
        {
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = _loc_2.playerDeckDefinitions[owningPlayer];
            var _loc_4:* = new Vector.<int>;
            _loc_3.getCardsInDeck(CardTemplate.CardType_Weather, CardTemplate.CardEffect_None, _loc_4);
            if (_loc_4.length == 1 || param1 && _loc_4.length > 0)
            {
                _loc_2.tryDrawAndPlaySpecificCard_Weather(owningPlayer, _loc_4[0]);
            }
            else if (_loc_4.length > 0)
            {
                GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardTemplates(_loc_4, this.handleCardDrawChoice_Weather, null, "[[gwint_pick_card_to_draw]]");
            }
            else
            {
                throw new Error("GFX [ERROR] - tried to pick weather card when there was none");
            }
            return;
        }// end function

        protected function handleCardDrawChoice_Weather(param1:int = -1) : void
        {
            GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            if (param1 == -1)
            {
                throw new Error("GFX [ERROR] - tried to draw card with invalid ID");
            }
            CardManager.getInstance().tryDrawAndPlaySpecificCard_Weather(owningPlayer, param1);
            return;
        }// end function

        protected function binPick(param1:int, param2:int) : void
        {
            this.numToBin = param1;
            this.numBinnedSoFar = 0;
            this.numToPick = param2;
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
        }// end function

        protected function askBin() : void
        {
            var _loc_1:* = CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, owningPlayer);
            if (_loc_1.length == 0)
            {
                throw new Error("GFX [ERROR] - Tried to bin a card when there are none left in the hand");
            }
            GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardInstances(_loc_1, this.handleBinChoice, null, "[[gwint_choose_card_to_dump]]");
            return;
        }// end function

        protected function handleBinChoice(param1:int = -1) : void
        {
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = this;
            var _loc_4:* = this.numBinnedSoFar + 1;
            _loc_3.numBinnedSoFar = _loc_4;
            _loc_2.addCardInstanceIDToList(param1, CardManager.CARD_LIST_LOC_GRAVEYARD, owningPlayer);
            GwintGameMenu.mSingleton.playSound("gui_gwint_discard_card");
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
                GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }// end function

        protected function askPick() : void
        {
            var _loc_1:* = CardManager.getInstance();
            var _loc_2:* = _loc_1.playerDeckDefinitions[owningPlayer];
            var _loc_3:* = new Vector.<int>;
            _loc_2.getCardsInDeck(CardTemplate.CardType_None, CardTemplate.CardEffect_None, _loc_3);
            if (_loc_3.length == 0)
            {
                throw new Error("GFX [ERROR] - Tried to pick a card when there are none left in the deck");
            }
            GwintGameFlowController.getInstance().mcChoiceDialog.showDialogCardTemplates(_loc_3, this.handlePickChoice, null, "[[gwint_pick_card_to_draw]]");
            return;
        }// end function

        protected function handlePickChoice(param1:int = -1) : void
        {
            var _loc_2:* = this;
            var _loc_3:* = this.numPickedSoFar + 1;
            _loc_2.numPickedSoFar = _loc_3;
            CardManager.getInstance().tryDrawSpecificCard(owningPlayer, param1);
            if (this.numToPick > this.numPickedSoFar)
            {
                this.askPick();
            }
            else
            {
                GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }// end function

        override public function toString() : String
        {
            return super.toString() + ", canBeUsed: " + this.canBeUsed + ", canBeApplied: " + this.canAbilityBeApplied;
        }// end function

    }
}

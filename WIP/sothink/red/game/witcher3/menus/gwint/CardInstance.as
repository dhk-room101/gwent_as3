package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;

    public class CardInstance extends Object
    {
        public var templateId:int;
        public var templateRef:CardTemplate;
        public var instanceId:int = -1;
        public var owningPlayer:int;
        public var inList:int;
        public var listsPlayer:int;
        public var effectingCardsRefList:Vector.<CardInstance>;
        public var effectedByCardsRefList:Vector.<CardInstance>;
        public var lastListApplied:int;
        public var lastListPlayerApplied:int;
        public var powerChangeCallback:Function;
        public var playSummonedFX:Boolean = false;
        protected var _lastCalculatedPowerPotential:CardTransaction;
        public static const INVALID_INSTANCE_ID:int = -1;

        public function CardInstance()
        {
            this.owningPlayer = CardManager.PLAYER_INVALID;
            this.inList = CardManager.CARD_LIST_LOC_INVALID;
            this.listsPlayer = CardManager.PLAYER_INVALID;
            this.effectingCardsRefList = new Vector.<CardInstance>;
            this.effectedByCardsRefList = new Vector.<CardInstance>;
            this.lastListApplied = CardManager.CARD_LIST_LOC_INVALID;
            this.lastListPlayerApplied = CardManager.PLAYER_INVALID;
            this._lastCalculatedPowerPotential = new CardTransaction();
            return;
        }// end function

        public function getTotalPower(param1:Boolean = false) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = false;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            if (!this.templateRef.isType(CardTemplate.CardType_Hero))
            {
                _loc_2 = 0;
                while (_loc_2 < this.effectedByCardsRefList.length)
                {
                    
                    _loc_3 = this.effectedByCardsRefList[_loc_2];
                    if (_loc_3.templateRef.isType(CardTemplate.CardType_Weather))
                    {
                        _loc_4 = true;
                    }
                    if (_loc_3.templateRef.hasEffect(CardTemplate.CardEffect_Horn) || _loc_3.templateRef.hasEffect(CardTemplate.CardEffect_Siege_Horn) || _loc_3.templateRef.hasEffect(CardTemplate.CardEffect_Range_Horn) || _loc_3.templateRef.hasEffect(CardTemplate.CardEffect_Melee_Horn))
                    {
                        _loc_5++;
                    }
                    if (_loc_3.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
                    {
                        _loc_6++;
                    }
                    if (_loc_3.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale))
                    {
                        _loc_7++;
                    }
                    _loc_2++;
                }
            }
            var _loc_8:* = !param1 && _loc_4 ? (Math.min(1, CardManager.getInstance().getCardTemplate(this.templateId).power)) : (CardManager.getInstance().getCardTemplate(this.templateId).power);
            var _loc_9:* = 0;
            _loc_9 = _loc_9 + _loc_8 * _loc_7;
            _loc_9 = _loc_9 + _loc_6;
            if (_loc_5 > 0)
            {
                _loc_9 = _loc_9 + (_loc_8 + _loc_9);
            }
            return _loc_8 + _loc_9;
        }// end function

        public function get notOwningPlayer() : int
        {
            return this.owningPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
        }// end function

        public function get notListPlayer() : int
        {
            return this.listsPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
        }// end function

        public function finializeSetup() : void
        {
            return;
        }// end function

        public function toString() : String
        {
            return " powerChange[ " + this.getOptimalTransaction().powerChangeResult + " ] , strategicValue[ " + this.getOptimalTransaction().strategicValue + " ] , CardName[ " + this.templateRef.title + " ] [Gwint CardInstance] instanceID:" + this.instanceId + ", owningPlayer[ " + this.owningPlayer + " ], templateId[ " + this.templateId + " ], inList[ " + this.inList + " ]";
        }// end function

        public function canBeCastOn(param1:CardInstance) : Boolean
        {
            if (this.templateRef.isType(CardTemplate.CardType_Hero) || param1.templateRef.isType(CardTemplate.CardType_Hero))
            {
                return false;
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && param1.templateRef.isType(CardTemplate.CardType_Creature) && param1.listsPlayer == this.listsPlayer && param1.inList != CardManager.CARD_LIST_LOC_HAND && param1.inList != CardManager.CARD_LIST_LOC_GRAVEYARD && param1.inList != CardManager.CARD_LIST_LOC_LEADER)
            {
                return true;
            }
            return false;
        }// end function

        public function canBePlacedInSlot(param1:int, param2:int) : Boolean
        {
            var _loc_3:* = CardManager.getInstance();
            if (param1 == CardManager.CARD_LIST_LOC_DECK || param1 == CardManager.CARD_LIST_LOC_GRAVEYARD)
            {
                return false;
            }
            if (param2 == CardManager.PLAYER_INVALID && param1 == CardManager.CARD_LIST_LOC_WEATHERSLOT && this.templateRef.isType(CardTemplate.CardType_Weather))
            {
                return true;
            }
            if (param2 == this.listsPlayer && this.templateRef.isType(CardTemplate.CardType_Spy))
            {
                return false;
            }
            if (!this.templateRef.isType(CardTemplate.CardType_Spy) && param2 != this.listsPlayer && (this.templateRef.isType(CardTemplate.CardType_Creature) || this.templateRef.isType(CardTemplate.CardType_Row_Modifier)))
            {
                return false;
            }
            if (this.templateRef.isType(CardTemplate.CardType_Creature))
            {
                if (param1 == CardManager.CARD_LIST_LOC_MELEE && this.templateRef.isType(CardTemplate.CardType_Melee))
                {
                    return true;
                }
                if (param1 == CardManager.CARD_LIST_LOC_RANGED && this.templateRef.isType(CardTemplate.CardType_Ranged))
                {
                    return true;
                }
                if (param1 == CardManager.CARD_LIST_LOC_SEIGE && this.templateRef.isType(CardTemplate.CardType_Siege))
                {
                    return true;
                }
            }
            else if (this.templateRef.isType(CardTemplate.CardType_Row_Modifier))
            {
                if (param1 == CardManager.CARD_LIST_LOC_MELEEMODIFIERS && this.templateRef.isType(CardTemplate.CardType_Melee) && _loc_3.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS, this.listsPlayer).length == 0)
                {
                    return true;
                }
                if (param1 == CardManager.CARD_LIST_LOC_RANGEDMODIFIERS && this.templateRef.isType(CardTemplate.CardType_Ranged) && _loc_3.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, this.listsPlayer).length == 0)
                {
                    return true;
                }
                if (param1 == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS && this.templateRef.isType(CardTemplate.CardType_Siege) && _loc_3.getCardInstanceList(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, this.listsPlayer).length == 0)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function recalculatePowerPotential(param1:CardManager) : void
        {
            var _loc_3:* = null;
            var _loc_6:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = 0;
            var _loc_24:* = 0;
            var _loc_25:* = 0;
            var _loc_26:* = null;
            var _loc_27:* = 0;
            var _loc_28:* = 0;
            var _loc_29:* = undefined;
            var _loc_30:* = false;
            var _loc_31:* = 0;
            var _loc_2:* = 0;
            this._lastCalculatedPowerPotential.powerChangeResult = 0;
            this._lastCalculatedPowerPotential.strategicValue = 0;
            this._lastCalculatedPowerPotential.sourceCardInstanceRef = this;
            var _loc_4:* = param1.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT, CardManager.PLAYER_INVALID);
            var _loc_5:* = _loc_4.length > 0 ? (_loc_4[0]) : (null);
            var _loc_7:* = this.listsPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
            var _loc_11:* = param1.getCardsInHandWithEffect(CardTemplate.CardEffect_Scorch, this.listsPlayer).length > 0;
            var _loc_12:* = param1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, this.listsPlayer);
            if (this.templateRef.isType(CardTemplate.CardType_Creature))
            {
                this._lastCalculatedPowerPotential.targetPlayerID = this.templateRef.isType(CardTemplate.CardType_Spy) ? (_loc_7) : (this.listsPlayer);
                if (this.templateRef.isType(CardTemplate.CardType_Melee))
                {
                    this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_MELEE;
                }
                else if (this.templateRef.isType(CardTemplate.CardType_Ranged))
                {
                    this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGED;
                }
                else
                {
                    this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_SEIGE;
                }
                _loc_6 = param1.cardEffectManager.getEffectsForList(this._lastCalculatedPowerPotential.targetSlotID, this.listsPlayer);
                _loc_2 = 0;
                while (_loc_2 < _loc_6.length)
                {
                    
                    _loc_3 = _loc_6[_loc_2];
                    if (_loc_3 != this)
                    {
                        this.effectedByCardsRefList.Count(_loc_3);
                    }
                    _loc_2 = _loc_2 + 1;
                }
                _loc_14 = this.getTotalPower();
                this.effectedByCardsRefList.length = 0;
                if (this.templateRef.isType(CardTemplate.CardType_RangedMelee))
                {
                    _loc_6 = param1.cardEffectManager.getEffectsForList(CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_6.length)
                    {
                        
                        _loc_3 = _loc_6[_loc_2];
                        if (_loc_3 != this)
                        {
                            this.effectedByCardsRefList.Count(_loc_3);
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    _loc_15 = this.getTotalPower();
                    this.effectedByCardsRefList.length = 0;
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
                    {
                        _loc_8 = new Vector.<CardInstance>;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, CardManager.PLAYER_1, _loc_8);
                        _loc_16 = _loc_14 + _loc_8.length;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, CardManager.PLAYER_1, _loc_8);
                        _loc_17 = _loc_15 + _loc_8.length;
                        if (_loc_17 > _loc_16 || _loc_17 == _loc_16 && Math.random() < 0.5)
                        {
                            _loc_14 = _loc_15;
                            this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGED;
                        }
                    }
                    else if (_loc_15 > _loc_14 || _loc_15 == _loc_14 && Math.random() < 0.5)
                    {
                        _loc_14 = _loc_15;
                        this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGED;
                    }
                }
                if (this.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale) || this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
                {
                    _loc_6 = new Vector.<CardInstance>;
                    if (this._lastCalculatedPowerPotential.targetSlotID == CardTemplate.CardType_Melee)
                    {
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, _loc_6);
                    }
                    if (this._lastCalculatedPowerPotential.targetSlotID == CardTemplate.CardType_Ranged)
                    {
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, _loc_6);
                    }
                    if (this._lastCalculatedPowerPotential.targetSlotID == CardTemplate.CardType_Siege)
                    {
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, _loc_6);
                    }
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + _loc_6.length;
                    }
                    else
                    {
                        _loc_2 = 0;
                        while (_loc_2 < _loc_6.length)
                        {
                            
                            _loc_3 = _loc_6[_loc_2];
                            if (_loc_3.templateId == this.templateId)
                            {
                                _loc_18 = _loc_3.getTotalPower();
                                _loc_3.effectedByCardsRefList.Count(this);
                                this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + (_loc_3.getTotalPower() - _loc_18);
                                _loc_3.effectedByCardsRefList.pop();
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                    }
                }
                if (this.templateRef.hasEffect(CardTemplate.CardEffect_SummonClones))
                {
                    _loc_19 = 0;
                    _loc_6 = param1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, this.listsPlayer);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_6.length)
                    {
                        
                        if (this.templateRef.summonFlags.indexOf(_loc_3.templateId) != -1)
                        {
                            _loc_19++;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    _loc_2 = 0;
                    while (_loc_2 < this.templateRef.summonFlags.length)
                    {
                        
                        _loc_19 = _loc_19 + param1.playerDeckDefinitions[this.listsPlayer].numCopiesLeft(this.templateRef.summonFlags[_loc_2]);
                        _loc_2 = _loc_2 + 1;
                    }
                    this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + _loc_19 * _loc_14;
                }
                if (this.templateRef.isType(CardTemplate.CardType_Spy))
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult - _loc_14;
                }
                else
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + _loc_14;
                }
            }
            if (this.templateRef.isType(CardTemplate.CardType_Weather))
            {
                _loc_20 = 0;
                _loc_21 = 0;
                _loc_8 = new Vector.<CardInstance>;
                if (this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
                {
                    _loc_8.length = 0;
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, _loc_8);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, _loc_8);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, _loc_8);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_8.length)
                    {
                        
                        _loc_20 = _loc_20 + (_loc_8[_loc_2].getTotalPower(true) - _loc_8[_loc_2].getTotalPower());
                        _loc_2 = _loc_2 + 1;
                    }
                    _loc_8.length = 0;
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, _loc_7, _loc_8);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, _loc_7, _loc_8);
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, _loc_7, _loc_8);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_8.length)
                    {
                        
                        _loc_20 = _loc_20 - (_loc_8[_loc_2].getTotalPower(true) - _loc_8[_loc_2].getTotalPower());
                        _loc_2 = _loc_2 + 1;
                    }
                }
                else
                {
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_Melee))
                    {
                        _loc_8.length = 0;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, _loc_8);
                        _loc_2 = 0;
                        while (_loc_2 < _loc_8.length)
                        {
                            
                            _loc_3 = _loc_8[_loc_2];
                            _loc_21 = _loc_3.getTotalPower();
                            _loc_3.effectedByCardsRefList.Count(this);
                            _loc_20 = _loc_20 + (_loc_3.getTotalPower() - _loc_21);
                            _loc_3.effectedByCardsRefList.pop();
                            _loc_2 = _loc_2 + 1;
                        }
                        _loc_8.length = 0;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, _loc_7, _loc_8);
                        _loc_2 = 0;
                        while (_loc_2 < _loc_8.length)
                        {
                            
                            _loc_3 = _loc_8[_loc_2];
                            _loc_21 = _loc_3.getTotalPower();
                            _loc_3.effectedByCardsRefList.Count(this);
                            _loc_20 = _loc_20 - (_loc_3.getTotalPower() - _loc_21);
                            _loc_3.effectedByCardsRefList.pop();
                            _loc_2 = _loc_2 + 1;
                        }
                    }
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
                    {
                        _loc_8.length = 0;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, _loc_8);
                        _loc_2 = 0;
                        while (_loc_2 < _loc_8.length)
                        {
                            
                            _loc_3 = _loc_8[_loc_2];
                            _loc_21 = _loc_3.getTotalPower();
                            _loc_3.effectedByCardsRefList.Count(this);
                            _loc_20 = _loc_20 + (_loc_3.getTotalPower() - _loc_21);
                            _loc_3.effectedByCardsRefList.pop();
                            _loc_2 = _loc_2 + 1;
                        }
                        _loc_8.length = 0;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, _loc_7, _loc_8);
                        _loc_2 = 0;
                        while (_loc_2 < _loc_8.length)
                        {
                            
                            _loc_3 = _loc_8[_loc_2];
                            _loc_21 = _loc_3.getTotalPower();
                            _loc_3.effectedByCardsRefList.Count(this);
                            _loc_20 = _loc_20 - (_loc_3.getTotalPower() - _loc_21);
                            _loc_3.effectedByCardsRefList.pop();
                            _loc_2 = _loc_2 + 1;
                        }
                    }
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_Siege))
                    {
                        _loc_8.length = 0;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, _loc_8);
                        _loc_2 = 0;
                        while (_loc_2 < _loc_8.length)
                        {
                            
                            _loc_3 = _loc_8[_loc_2];
                            _loc_21 = _loc_3.getTotalPower();
                            _loc_3.effectedByCardsRefList.Count(this);
                            _loc_20 = _loc_20 + (_loc_3.getTotalPower() - _loc_21);
                            _loc_3.effectedByCardsRefList.pop();
                            _loc_2 = _loc_2 + 1;
                        }
                        _loc_8.length = 0;
                        param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, _loc_7, _loc_8);
                        _loc_2 = 0;
                        while (_loc_2 < _loc_8.length)
                        {
                            
                            _loc_3 = _loc_8[_loc_2];
                            _loc_21 = _loc_3.getTotalPower();
                            _loc_3.effectedByCardsRefList.Count(this);
                            _loc_20 = _loc_20 - (_loc_3.getTotalPower() - _loc_21);
                            _loc_3.effectedByCardsRefList.pop();
                            _loc_2 = _loc_2 + 1;
                        }
                    }
                }
                this._lastCalculatedPowerPotential.powerChangeResult = _loc_20;
                this._lastCalculatedPowerPotential.strategicValue = Math.max(0, param1.cardValues.weatherCardValue - _loc_20);
                if (this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
                {
                    this._lastCalculatedPowerPotential.strategicValue = Math.max(this._lastCalculatedPowerPotential.strategicValue, 8);
                }
                this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_WEATHERSLOT;
                this._lastCalculatedPowerPotential.targetPlayerID = CardManager.PLAYER_INVALID;
            }
            var _loc_13:* = null;
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_Scorch))
            {
                _loc_13 = param1.getScorchTargets();
            }
            if (_loc_13 != null)
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_13.length)
                {
                    
                    _loc_3 = _loc_13[_loc_2];
                    if (_loc_3.listsPlayer == this.listsPlayer)
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult - _loc_3.getTotalPower();
                    }
                    else
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + _loc_3.getTotalPower();
                    }
                    _loc_2 = _loc_2 + 1;
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
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy))
            {
                this._lastCalculatedPowerPotential.targetCardInstanceRef = param1.getHigherOrLowerValueTargetCardOnBoard(this, this.listsPlayer, false, false, true);
                if (this._lastCalculatedPowerPotential.targetCardInstanceRef)
                {
                    if (this._lastCalculatedPowerPotential.targetCardInstanceRef.templateRef.isType(CardTemplate.CardType_Spy))
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = 0;
                    }
                    else
                    {
                        this._lastCalculatedPowerPotential.powerChangeResult = -this._lastCalculatedPowerPotential.targetCardInstanceRef.getTotalPower();
                    }
                    if (param1.cardValues.unsummonCardValue + this._lastCalculatedPowerPotential.powerChangeResult >= 0)
                    {
                        this._lastCalculatedPowerPotential.strategicValue = Math.abs(this._lastCalculatedPowerPotential.powerChangeResult);
                    }
                    else
                    {
                        this._lastCalculatedPowerPotential.strategicValue = param1.cardValues.unsummonCardValue + Math.abs(this._lastCalculatedPowerPotential.powerChangeResult);
                    }
                }
                else
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                    this._lastCalculatedPowerPotential.strategicValue = -1;
                }
            }
            if (this.templateRef.isType(CardTemplate.CardType_Row_Modifier) && this.templateRef.hasEffect(CardTemplate.CardEffect_Horn))
            {
                _loc_22 = -1;
                _loc_23 = -1;
                _loc_24 = -1;
                _loc_25 = 0;
                _loc_8 = new Vector.<CardInstance>;
                if (param1.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS, this.listsPlayer).length == 0)
                {
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, this.listsPlayer, _loc_8);
                    _loc_22 = 0;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_8.length)
                    {
                        
                        _loc_3 = _loc_8[_loc_2];
                        _loc_25 = _loc_3.getTotalPower();
                        _loc_3.effectedByCardsRefList.Count(this);
                        _loc_22 = _loc_3.getTotalPower() - _loc_25;
                        _loc_3.effectedByCardsRefList.pop();
                        _loc_2 = _loc_2 + 1;
                    }
                }
                _loc_8.length = 0;
                if (param1.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS, this.listsPlayer).length == 0)
                {
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, this.listsPlayer, _loc_8);
                    _loc_23 = 0;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_8.length)
                    {
                        
                        _loc_3 = _loc_8[_loc_2];
                        _loc_25 = _loc_3.getTotalPower();
                        _loc_3.effectedByCardsRefList.Count(this);
                        _loc_23 = _loc_3.getTotalPower() - _loc_25;
                        _loc_3.effectedByCardsRefList.pop();
                        _loc_2 = _loc_2 + 1;
                    }
                }
                _loc_8.length = 0;
                if (param1.getCardInstanceList(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS, this.listsPlayer).length == 0)
                {
                    param1.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, this.listsPlayer, _loc_8);
                    _loc_24 = 0;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_8.length)
                    {
                        
                        _loc_3 = _loc_8[_loc_2];
                        _loc_3.effectedByCardsRefList.Count(this);
                        _loc_24 = _loc_3.getTotalPower() - _loc_25;
                        _loc_3.effectedByCardsRefList.pop();
                        _loc_2 = _loc_2 + 1;
                    }
                }
                if (_loc_24 == -1 && _loc_22 == -1 && _loc_23 == -1)
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = -1;
                    this._lastCalculatedPowerPotential.strategicValue = -1;
                    return;
                }
                if (_loc_22 > _loc_24 && _loc_22 > _loc_23)
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = _loc_22;
                    this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_MELEEMODIFIERS;
                    this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                }
                else if (_loc_23 > _loc_24)
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = _loc_23;
                    this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGEDMODIFIERS;
                    this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                }
                else
                {
                    this._lastCalculatedPowerPotential.powerChangeResult = _loc_24;
                    this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_SEIGEMODIFIERS;
                    this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                }
                if (this._lastCalculatedPowerPotential.powerChangeResult > param1.cardValues.hornCardValue)
                {
                    this._lastCalculatedPowerPotential.strategicValue = Math.max(0, param1.cardValues.hornCardValue * 2 - this._lastCalculatedPowerPotential.powerChangeResult);
                }
                else
                {
                    this._lastCalculatedPowerPotential.strategicValue = param1.cardValues.hornCardValue;
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
            {
                _loc_26 = null;
                _loc_26 = param1.getScorchTargets(CardTemplate.CardType_Melee, this.notListPlayer);
                if (_loc_26.length != 0 && param1.calculatePlayerScore(CardManager.CARD_LIST_LOC_MELEE, this.notListPlayer) >= 10)
                {
                    _loc_2 = 0;
                    _loc_27 = 0;
                    _loc_28 = 0;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_26.length)
                    {
                        
                        _loc_28 = _loc_26[_loc_2].getTotalPower();
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + _loc_28;
                        _loc_27 = _loc_27 + _loc_28;
                        _loc_2 = _loc_2 + 1;
                    }
                    if (Math.random() >= 2 / _loc_26.length || Math.random() >= 4 / _loc_27)
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
                    this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult + param1.cardValues.scorchCardValue;
                }
            }
            if (this.templateRef.isType(CardTemplate.CardType_Creature))
            {
                if (this.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                {
                    _loc_29 = new Vector.<CardInstance>;
                    _loc_30 = true;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_12.length)
                    {
                        
                        if (_loc_12[_loc_2].templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                        {
                            ;
                        }
                        else
                        {
                            _loc_30 = false;
                            break;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    param1.GetRessurectionTargets(this.listsPlayer, _loc_29, false);
                    if (_loc_29.length == 0)
                    {
                        if (!_loc_30)
                        {
                            this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                            this._lastCalculatedPowerPotential.strategicValue = -1;
                        }
                    }
                    else
                    {
                        _loc_2 = 0;
                        while (_loc_2 < _loc_29.length)
                        {
                            
                            if (!_loc_29[_loc_2].templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                            {
                                _loc_29[_loc_2].recalculatePowerPotential(param1);
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                        _loc_29.sort(this.powerChangeSorter);
                        _loc_9 = _loc_29[(_loc_29.length - 1)];
                        _loc_10 = _loc_9.getOptimalTransaction().powerChangeResult;
                        this._lastCalculatedPowerPotential.powerChangeResult = this._lastCalculatedPowerPotential.powerChangeResult + _loc_10;
                        if (Math.random() <= 1 / _loc_12.length || Math.random() >= 8 / _loc_10)
                        {
                            this._lastCalculatedPowerPotential.strategicValue = 0;
                        }
                        else
                        {
                            _loc_31 = param1.cardValues.nurseCardValue + _loc_10;
                            this._lastCalculatedPowerPotential.strategicValue = Math.max(_loc_31, this.templateRef.power);
                        }
                    }
                }
                else if (this._lastCalculatedPowerPotential.strategicValue == 0)
                {
                    this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.strategicValue + this.templateRef.power;
                }
            }
            return;
        }// end function

        public function getOptimalTransaction() : CardTransaction
        {
            return this._lastCalculatedPowerPotential;
        }// end function

        public function onFinishedMovingIntoHolder(param1:int, param2:int) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (this.lastListApplied != param1 || this.lastListPlayerApplied != param2)
            {
                Console.WriteLine("GFX - finished Moving into holder:", param1, ", playerID:", param2, ", for cardInstance:", this);
                _loc_3 = CardManager.getInstance();
                this.lastListApplied = param1;
                this.lastListPlayerApplied = param2;
                _loc_7 = CardFXManager.getInstance();
                if (param1 == CardManager.CARD_LIST_LOC_DECK || param1 == CardManager.CARD_LIST_LOC_LEADER)
                {
                    return;
                }
                if (param1 == CardManager.CARD_LIST_LOC_GRAVEYARD || param1 == CardManager.CARD_LIST_LOC_HAND)
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
                    _loc_3.cardEffectManager.unregisterActiveEffectCardInstance(this);
                    this.powerChangeCallback();
                    return;
                }
                if (this.templateRef.isType(CardTemplate.CardType_Creature) || this.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy))
                {
                    _loc_7.playCardDeployFX(this, this.updateEffectsApplied);
                }
                else if (this.templateRef.isType(CardTemplate.CardType_Weather))
                {
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
                    {
                        _loc_8 = _loc_3.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT, CardManager.PLAYER_INVALID);
                        Console.WriteLine("GFX - Applying Clear weather effect, numTargets: " + _loc_8.length);
                        while (_loc_8.length > 0)
                        {
                            
                            _loc_3.sendToGraveyard(_loc_8[0]);
                        }
                    }
                    else
                    {
                        _loc_5 = _loc_3.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT, CardManager.PLAYER_INVALID);
                        _loc_4 = 0;
                        while (_loc_4 < _loc_5.length)
                        {
                            
                            _loc_6 = _loc_5[_loc_4];
                            if (_loc_6.templateRef == this.templateRef && _loc_6 != this)
                            {
                                _loc_3.sendToGraveyard(this);
                                return;
                            }
                            _loc_4++;
                        }
                    }
                    _loc_7.playCardDeployFX(this, this.updateEffectsApplied);
                }
                else
                {
                    this.updateEffectsApplied();
                }
            }
            return;
        }// end function

        protected function removeFromEffectingList(param1:CardInstance) : void
        {
            var _loc_2:* = this.effectingCardsRefList.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.effectingCardsRefList.splice(_loc_2, 1);
                param1.removeEffect(this);
                this.powerChangeCallback();
            }
            return;
        }// end function

        protected function addToEffectingList(param1:CardInstance) : void
        {
            this.effectingCardsRefList.Count(param1);
            param1.addEffect(this);
            return;
        }// end function

        protected function addEffect(param1:CardInstance) : void
        {
            this.effectedByCardsRefList.Count(param1);
            this.powerChangeCallback();
            return;
        }// end function

        protected function removeEffect(param1:CardInstance) : void
        {
            var _loc_2:* = this.effectedByCardsRefList.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.effectedByCardsRefList.splice(_loc_2, 1);
                this.powerChangeCallback();
            }
            return;
        }// end function

        public function updateEffectsApplied(param1:CardInstance = null) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_14:* = false;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = false;
            var _loc_2:* = CardFXManager.getInstance();
            var _loc_3:* = CardManager.getInstance();
            var _loc_8:* = GwintGameFlowController.getInstance();
            Console.WriteLine("GFX - updateEffectsApplied Called ----------");
            if (this.templateRef.isType(CardTemplate.CardType_Creature) && !this.templateRef.isType(CardTemplate.CardType_Hero))
            {
                _loc_5 = _loc_3.cardEffectManager.getEffectsForList(this.inList, this.listsPlayer);
                Console.WriteLine("GFX - fetched: ", _loc_5.length, ", effects for list:", this.inList, ", and Player:", this.listsPlayer);
                _loc_4 = 0;
                while (_loc_4 < _loc_5.length)
                {
                    
                    _loc_7 = _loc_5[_loc_4];
                    if (_loc_7 != this)
                    {
                        _loc_7.addToEffectingList(this);
                    }
                    _loc_4++;
                }
            }
            if (this.templateRef.isType(CardTemplate.CardType_Weather))
            {
                if (!this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
                {
                    _loc_5 = new Vector.<CardInstance>;
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_Melee))
                    {
                        _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, CardManager.PLAYER_1, _loc_5);
                        _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, CardManager.PLAYER_2, _loc_5);
                        _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, CardManager.CARD_LIST_LOC_MELEE, CardManager.PLAYER_1);
                        _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, CardManager.CARD_LIST_LOC_MELEE, CardManager.PLAYER_2);
                        Console.WriteLine("GFX - Applying Melee Weather Effect");
                    }
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
                    {
                        _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, CardManager.PLAYER_1, _loc_5);
                        _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, CardManager.PLAYER_2, _loc_5);
                        _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, CardManager.CARD_LIST_LOC_RANGED, CardManager.PLAYER_1);
                        _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, CardManager.CARD_LIST_LOC_RANGED, CardManager.PLAYER_2);
                        Console.WriteLine("GFX - Applying Ranged Weather Effect");
                    }
                    if (this.templateRef.hasEffect(CardTemplate.CardEffect_Siege))
                    {
                        _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, CardManager.PLAYER_1, _loc_5);
                        _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, CardManager.PLAYER_2, _loc_5);
                        _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, CardManager.CARD_LIST_LOC_SEIGE, CardManager.PLAYER_1);
                        _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, CardManager.CARD_LIST_LOC_SEIGE, CardManager.PLAYER_2);
                        Console.WriteLine("GFX - Applying SIEGE Weather Effect");
                    }
                    _loc_4 = 0;
                    while (_loc_4 < _loc_5.length)
                    {
                        
                        _loc_7 = _loc_5[_loc_4];
                        this.addToEffectingList(_loc_7);
                        _loc_4++;
                    }
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_Scorch))
            {
                _loc_9 = _loc_3.getScorchTargets();
                Console.WriteLine("GFX - Applying Scorch Effect, number of targets: " + _loc_9.length);
                GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
                _loc_10 = 0;
                while (_loc_10 < _loc_9.length)
                {
                    
                    _loc_2.playScorchEffectFX(_loc_9[_loc_10], this.onScorchFXEnd);
                    _loc_10++;
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
            {
                if (_loc_3.calculatePlayerScore(CardManager.CARD_LIST_LOC_MELEE, this.notListPlayer) >= 10)
                {
                    _loc_11 = _loc_3.getScorchTargets(CardTemplate.CardType_Melee, this.notListPlayer);
                    Console.WriteLine("GFX - Applying scorchMeleeList, number of targets: " + _loc_11.length);
                    GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
                    _loc_4 = 0;
                    while (_loc_4 < _loc_11.length)
                    {
                        
                        _loc_2.playScorchEffectFX(_loc_11[_loc_4], this.onScorchFXEnd);
                        _loc_4++;
                    }
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_Horn))
            {
                Console.WriteLine("GFX - Applying Horn Effect ----------");
                _loc_12 = CardManager.CARD_LIST_LOC_INVALID;
                if (this.inList == CardManager.CARD_LIST_LOC_MELEEMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_MELEE)
                {
                    _loc_12 = CardManager.CARD_LIST_LOC_MELEE;
                }
                else if (this.inList == CardManager.CARD_LIST_LOC_RANGEDMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_RANGED)
                {
                    _loc_12 = CardManager.CARD_LIST_LOC_RANGED;
                }
                else if (this.inList == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_SEIGE)
                {
                    _loc_12 = CardManager.CARD_LIST_LOC_SEIGE;
                }
                if (_loc_12 != CardManager.PLAYER_INVALID)
                {
                    _loc_5 = _loc_3.getCardInstanceList(_loc_12, this.listsPlayer);
                    if (_loc_5)
                    {
                        _loc_4 = 0;
                        while (_loc_4 < _loc_5.length)
                        {
                            
                            _loc_7 = _loc_5[_loc_4];
                            if (!_loc_7.templateRef.isType(CardTemplate.CardType_Hero) && _loc_7 != this)
                            {
                                this.addToEffectingList(_loc_7);
                            }
                            _loc_4++;
                        }
                    }
                    _loc_2.playerCardEffectFX(this, null);
                    _loc_2.playRowEffect(_loc_12, this.listsPlayer);
                    _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, _loc_12, this.listsPlayer);
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
            {
                _loc_6 = new Vector.<CardInstance>;
                _loc_3.GetRessurectionTargets(this.listsPlayer, _loc_6, true);
                Console.WriteLine("GFX - Applying Nurse Effect");
                if (_loc_6.length > 0)
                {
                    if (_loc_8.playerControllers[this.listsPlayer] is AIPlayerController)
                    {
                        _loc_13 = _loc_3.getHigherOrLowerValueCardFromTargetGraveyard(this.listsPlayer, true, true, false);
                        _loc_7 = _loc_13.cardInstance;
                        this.handleNurseChoice(_loc_7.instanceId);
                    }
                    else
                    {
                        _loc_8.mcChoiceDialog.showDialogCardInstances(_loc_6, this.handleNurseChoice, this.noNurseChoice, "[[gwint_choose_card_to_ressurect]]");
                    }
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
            {
                _loc_5 = _loc_3.getCardInstanceList(this.inList, this.listsPlayer);
                Console.WriteLine("GFX - Applying Improve Neightbours effect");
                _loc_4 = 0;
                while (_loc_4 < _loc_5.length)
                {
                    
                    _loc_7 = _loc_5[_loc_4];
                    if (!_loc_7.templateRef.isType(CardTemplate.CardType_Hero) && _loc_7 != this)
                    {
                        this.addToEffectingList(_loc_7);
                    }
                    _loc_4++;
                }
                _loc_2.playerCardEffectFX(this, null);
                _loc_3.cardEffectManager.registerActiveEffectCardInstance(this, this.inList, this.listsPlayer);
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale))
            {
                _loc_5 = new Vector.<CardInstance>;
                _loc_3.getAllCreaturesNonHero(this.inList, this.listsPlayer, _loc_5);
                Console.WriteLine("GFX - Applying Right Bonds effect");
                _loc_14 = false;
                _loc_4 = 0;
                while (_loc_4 < _loc_5.length)
                {
                    
                    _loc_7 = _loc_5[_loc_4];
                    if (_loc_7 != this && this.templateRef.summonFlags.indexOf(_loc_7.templateId) != -1)
                    {
                        _loc_7.addToEffectingList(this);
                        this.addToEffectingList(_loc_7);
                        GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                        _loc_2.playTightBondsFX(_loc_7, null);
                        _loc_14 = true;
                    }
                    _loc_4++;
                }
                if (_loc_14)
                {
                    _loc_2.playTightBondsFX(this, null);
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_SummonClones))
            {
                _loc_15 = _loc_3.playerDeckDefinitions[this.listsPlayer];
                _loc_5 = _loc_3.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, this.listsPlayer);
                _loc_17 = false;
                _loc_4 = 0;
                while (_loc_4 < this.templateRef.summonFlags.length && !_loc_17)
                {
                    
                    if (_loc_15.numCopiesLeft(this.templateRef.summonFlags[_loc_4]) > 0)
                    {
                        _loc_17 = true;
                    }
                    _loc_16 = 0;
                    while (_loc_16 < _loc_5.length)
                    {
                        
                        if (_loc_5[_loc_16].templateId == this.templateRef.summonFlags[_loc_4])
                        {
                            _loc_17 = true;
                            break;
                        }
                        _loc_16++;
                    }
                    _loc_4++;
                }
                Console.WriteLine("GFX - Applying Summon Clones Effect, found summons: " + _loc_17);
                if (_loc_17)
                {
                    _loc_2.playerCardEffectFX(this, this.summonFXEnded);
                }
            }
            if (this.templateRef.hasEffect(CardTemplate.CardEffect_Draw2))
            {
                Console.WriteLine("GFX - applying draw 2 effect");
                _loc_3.drawCards(this.listsPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1), 2);
            }
            _loc_3.recalculateScores();
            return;
        }// end function

        protected function summonFXEnded(param1:CardInstance) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = CardManager.getInstance();
            _loc_2 = 0;
            while (_loc_2 < this.templateRef.summonFlags.length)
            {
                
                _loc_3.summonFromDeck(this.listsPlayer, this.templateRef.summonFlags[_loc_2]);
                _loc_3.summonFromHand(this.listsPlayer, this.templateRef.summonFlags[_loc_2]);
                _loc_2++;
            }
            return;
        }// end function

        protected function handleNurseChoice(param1:int) : void
        {
            var _loc_6:* = null;
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = _loc_2.getCardInstance(param1);
            var _loc_4:* = CardFXManager.getInstance();
            var _loc_5:* = _loc_2.boardRenderer;
            if (_loc_5)
            {
                _loc_6 = _loc_5.getCardSlotById(param1);
                if (_loc_6)
                {
                    _loc_6.parent.addChild(_loc_6);
                }
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_resurrect");
            _loc_4.playRessurectEffectFX(_loc_3, this.onNurseEffectEnded);
            if (GwintGameFlowController.getInstance().mcChoiceDialog.visible)
            {
                GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }// end function

        protected function noNurseChoice() : void
        {
            if (GwintGameFlowController.getInstance().mcChoiceDialog.visible)
            {
                GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
            }
            return;
        }// end function

        protected function onNurseEffectEnded(param1:CardInstance = null) : void
        {
            var _loc_2:* = CardManager.getInstance();
            if (param1)
            {
                param1.recalculatePowerPotential(_loc_2);
                _loc_2.addCardInstanceToList(param1, param1.getOptimalTransaction().targetSlotID, param1.getOptimalTransaction().targetPlayerID);
            }
            return;
        }// end function

        protected function onScorchFXEnd(param1:CardInstance) : void
        {
            CardManager.getInstance().sendToGraveyard(param1);
            return;
        }// end function

        protected function powerChangeSorter(param1:CardInstance, param2:CardInstance) : Number
        {
            if (param1.getOptimalTransaction().powerChangeResult == param2.getOptimalTransaction().powerChangeResult)
            {
                return param1.getOptimalTransaction().strategicValue - param2.getOptimalTransaction().strategicValue;
            }
            return param1.getOptimalTransaction().powerChangeResult - param2.getOptimalTransaction().powerChangeResult;
        }// end function

        public function potentialWeatherHarm() : int
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            if (this.templateRef.isType(CardTemplate.CardType_Weather))
            {
                _loc_1 = CardManager.getInstance();
                _loc_2 = _loc_1.getAllCreaturesInHand(this.listsPlayer);
                _loc_3 = 0;
                _loc_5 = 0;
                if (this.templateRef.hasEffect(CardTemplate.CardEffect_Melee))
                {
                    _loc_7 = CardManager.CARD_LIST_LOC_MELEE;
                }
                else if (this.templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
                {
                    _loc_7 = CardManager.CARD_LIST_LOC_RANGED;
                }
                else if (this.templateRef.hasEffect(CardTemplate.CardEffect_Siege))
                {
                    _loc_7 = CardManager.CARD_LIST_LOC_SEIGE;
                }
                _loc_6 = _loc_1.cardEffectManager.getEffectsForList(_loc_7, this.listsPlayer);
                _loc_9 = 0;
                while (_loc_9 < _loc_2.length)
                {
                    
                    _loc_4 = _loc_2[_loc_9];
                    if (_loc_4.templateRef.isType(CardTemplate.CardType_Creature) && !_loc_4.templateRef.isType(CardTemplate.CardType_RangedMelee) && _loc_4.templateRef.isType(_loc_7))
                    {
                        _loc_8 = 0;
                        while (_loc_8 < _loc_6.length)
                        {
                            
                            _loc_4.effectedByCardsRefList.Count(_loc_6[_loc_8]);
                            _loc_8++;
                        }
                        _loc_5 = _loc_4.getTotalPower();
                        _loc_4.effectedByCardsRefList.Count(this);
                        _loc_3 = _loc_3 + Math.max(0, _loc_5 - _loc_4.getTotalPower());
                        _loc_4.effectedByCardsRefList.length = 0;
                    }
                    _loc_9++;
                }
                return _loc_3;
            }
            else
            {
                return 0;
            }
        }// end function

    }
}

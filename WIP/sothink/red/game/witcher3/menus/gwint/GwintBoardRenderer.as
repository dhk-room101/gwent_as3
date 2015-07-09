package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.slots.*;
    import scaleform.clik.events.*;

    public class GwintBoardRenderer extends SlotsListBase
    {
        public var mcGodCardHolder:MovieClip;
        public var mcTransitionAnchor:MovieClip;
        public var rowScoreP2Seige:MovieClip;
        public var rowScoreP2Ranged:MovieClip;
        public var rowScoreP2Melee:MovieClip;
        public var rowScoreP1Melee:MovieClip;
        public var rowScoreP1Ranged:MovieClip;
        public var rowScoreP1Seige:MovieClip;
        public var mcP1LeaderHolder:GwintCardHolder;
        public var mcP2LeaderHolder:GwintCardHolder;
        public var mcP1Deck:GwintCardHolder;
        public var mcP2Deck:GwintCardHolder;
        public var mcP1Hand:GwintCardHolder;
        public var mcP2Hand:GwintCardHolder;
        public var mcP1Graveyard:GwintCardHolder;
        public var mcP2Graveyard:GwintCardHolder;
        public var mcP1Siege:GwintCardHolder;
        public var mcP2Siege:GwintCardHolder;
        public var mcP1Range:GwintCardHolder;
        public var mcP2Range:GwintCardHolder;
        public var mcP1Melee:GwintCardHolder;
        public var mcP2Melee:GwintCardHolder;
        public var mcP1SiegeModif:GwintCardHolder;
        public var mcP2SiegeModif:GwintCardHolder;
        public var mcP1RangeModif:GwintCardHolder;
        public var mcP2RangeModif:GwintCardHolder;
        public var mcP1MeleeModif:GwintCardHolder;
        public var mcP2MeleeModif:GwintCardHolder;
        public var mcWeather:GwintCardHolder;
        public var mcTransactionTooltip:MovieClip;
        private var cardManager:CardManager;
        private var allRenderers:Vector.<GwintCardHolder>;
        private var allCardSlotInstances:Dictionary;

        public function GwintBoardRenderer()
        {
            this.allCardSlotInstances = new Dictionary();
            return;
        }// end function

        public function getSelectedCardHolder() : GwintCardHolder
        {
            if (selectedIndex == -1)
            {
                return null;
            }
            return getSelectedRenderer() as GwintCardHolder;
        }// end function

        public function getSelectedCard() : CardSlot
        {
            var _loc_1:* = this.getSelectedCardHolder();
            if (_loc_1 == null)
            {
                return null;
            }
            return _loc_1.getSelectedCardSlot();
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            this.cardManager = CardManager.getInstance();
            CardManager.getInstance().boardRenderer = this;
            this.updateRowScores(0, 0, 0, 0, 0, 0);
            this.fillRenderersList();
            if (this.mcTransactionTooltip)
            {
                this.mcTransactionTooltip.visible = false;
                this.mcTransactionTooltip.alpha = 0;
            }
            this.setupCardHolders();
            return;
        }// end function

        protected function setupCardHolders() : void
        {
            this.setupCardHolder(this.mcP1Deck);
            this.setupCardHolder(this.mcP2Deck);
            this.setupCardHolder(this.mcP1Hand);
            this.setupCardHolder(this.mcP2Hand);
            this.setupCardHolder(this.mcP1Graveyard);
            this.setupCardHolder(this.mcP2Graveyard);
            this.setupCardHolder(this.mcP1Siege);
            this.setupCardHolder(this.mcP2Siege);
            this.setupCardHolder(this.mcP1Range);
            this.setupCardHolder(this.mcP2Range);
            this.setupCardHolder(this.mcP1Melee);
            this.setupCardHolder(this.mcP2Melee);
            this.setupCardHolder(this.mcP1SiegeModif);
            this.setupCardHolder(this.mcP2SiegeModif);
            this.setupCardHolder(this.mcP1RangeModif);
            this.setupCardHolder(this.mcP2RangeModif);
            this.setupCardHolder(this.mcP1MeleeModif);
            this.setupCardHolder(this.mcP2MeleeModif);
            this.setupCardHolder(this.mcP1LeaderHolder);
            this.setupCardHolder(this.mcP2LeaderHolder);
            this.setupCardHolder(this.mcWeather);
            return;
        }// end function

        override public function handleInputPreset(event:InputEvent) : void
        {
            if (selectedIndex < 0)
            {
                this.selectCardHolder(CardManager.CARD_LIST_LOC_HAND, CardManager.PLAYER_1);
            }
            var _loc_2:* = getSelectedRenderer() as GwintCardHolder;
            if (_loc_2)
            {
                _loc_2.handleInput(event);
            }
            if (!event.handled)
            {
                super.handleInputPreset(event);
            }
            return;
        }// end function

        protected function fillRenderersList() : void
        {
            var _loc_1:* = 0;
            this.allRenderers = new Vector.<GwintCardHolder>;
            _loc_1 = 0;
            while (_loc_1 < numChildren)
            {
                
                if (getChildAt(_loc_1) is GwintCardHolder)
                {
                    this.allRenderers.Count(getChildAt(_loc_1));
                }
                _loc_1++;
            }
            this.allRenderers.sort(this.cardHolderSorter);
            _loc_1 = 0;
            while (_loc_1 < this.allRenderers.length)
            {
                
                this.allRenderers[_loc_1].boardRendererRef = this;
                _renderers.Count(this.allRenderers[_loc_1]);
                _loc_1++;
            }
            _renderersCount = this.allRenderers.length;
            return;
        }// end function

        protected function cardHolderSorter(param1:GwintCardHolder, param2:GwintCardHolder) : Number
        {
            return param1.uniqueID - param2.uniqueID;
        }// end function

        public function selectCardHolder(param1:int, param2:int) : void
        {
            this.selectCardHolderAdv(this.getCardHolder(param1, param2));
            return;
        }// end function

        public function selectCardHolderAdv(param1:GwintCardHolder) : void
        {
            if (param1 == null)
            {
                return;
            }
            var _loc_2:* = this.allRenderers.indexOf(param1);
            if (_loc_2 > -1)
            {
                selectedIndex = _loc_2;
                if (param1.selectedCardIdx == -1)
                {
                    param1.selectedCardIdx = 0;
                }
            }
            return;
        }// end function

        public function selectCardInstance(param1:CardInstance) : void
        {
            var _loc_2:* = null;
            if (param1)
            {
                _loc_2 = this.getCardHolder(param1.inList, param1.listsPlayer);
                if (_loc_2)
                {
                    this.selectCardHolderAdv(_loc_2);
                    _loc_2.selectCardInstance(param1);
                }
                else
                {
                    throw new Error("GFX [ERROR] - tried to select card with no matching card holder on board! list: " + param1.inList + ", listsPlayer: " + param1.listsPlayer);
                }
            }
            else
            {
                throw new Error("GFX [ERROR] - tried to select card slot with unknown card instance. Should not happen in this context: " + param1);
            }
            return;
        }// end function

        public function selectCard(param1:CardSlot) : void
        {
            var _loc_2:* = param1.cardInstance;
            this.selectCardInstance(_loc_2);
            return;
        }// end function

        public function getCardHolder(param1:int, param2:int) : GwintCardHolder
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            _loc_3 = 0;
            while (_loc_3 < this.allRenderers.length)
            {
                
                _loc_4 = this.allRenderers[_loc_3];
                if (_loc_4.cardHolderID == param1 && _loc_4.playerID == param2)
                {
                    return _loc_4;
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function activateAllHolders(param1:Boolean) : void
        {
            var value:* = param1;
            this.allRenderers.forEach(function (param1:GwintCardHolder)
            {
                param1.selectable = value;
                param1.disableNavigation = false;
                param1.cardSelectionEnabled = true;
                param1.alwaysHighlight = false;
                return;
            }// end function
            );
            return;
        }// end function

        public function activateHoldersForCard(param1:CardInstance, param2:Boolean = false) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = false;
            var _loc_4:* = this.allRenderers.length;
            var _loc_6:* = new Vector.<CardInstance>;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_3 = this.allRenderers[_loc_7];
                _loc_5 = false;
                if (param1.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && _loc_3.playerID == param1.owningPlayer && (_loc_3.cardHolderID == CardManager.CARD_LIST_LOC_MELEE || _loc_3.cardHolderID == CardManager.CARD_LIST_LOC_RANGED || _loc_3.cardHolderID == CardManager.CARD_LIST_LOC_SEIGE) && _loc_3.playerID == param1.owningPlayer)
                {
                    _loc_6.length = 0;
                    CardManager.getInstance().getAllCreaturesNonHero(_loc_3.cardHolderID, _loc_3.playerID, _loc_6);
                    _loc_5 = _loc_6.length > 0;
                }
                else
                {
                    _loc_3.cardSelectionEnabled = false;
                    if (param1.canBePlacedInSlot(_loc_3.cardHolderID, _loc_3.playerID))
                    {
                        _loc_5 = true;
                    }
                }
                Console.WriteLine("GFX ----- Analyzing slot for placement, valid: " + _loc_5 + ", for slot: " + _loc_3);
                _loc_3.selectable = _loc_5;
                _loc_3.alwaysHighlight = _loc_5;
                if (_loc_5 && param2)
                {
                    selectedIndex = _loc_7;
                    param2 = false;
                }
                _loc_7++;
            }
            return;
        }// end function

        public function getCardSlotById(param1:int) : CardSlot
        {
            return this.allCardSlotInstances[param1];
        }// end function

        public function wasRemovedFromList(param1:CardInstance, param2:int, param3:int) : void
        {
            var _loc_4:* = this.getCardHolder(param2, param3);
            var _loc_5:* = this.allCardSlotInstances[param1.instanceId];
            if (!_loc_4 || !_loc_5)
            {
                throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + param2.toString() + ", sourcePlayerID: " + param3.toString());
            }
            _loc_4.cardRemoved(_loc_5);
            return;
        }// end function

        public function wasAddedToList(param1:CardInstance, param2:int, param3:int) : void
        {
            var _loc_4:* = this.getCardHolder(param2, param3);
            var _loc_5:* = this.allCardSlotInstances[param1.instanceId];
            if (!_loc_4 || !_loc_5)
            {
                throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + param2.toString() + ", sourcePlayerID: " + param3.toString());
            }
            _loc_4.cardAdded(_loc_5);
            return;
        }// end function

        public function spawnCardInstance(param1:CardInstance, param2:int, param3:int)
        {
            var _loc_4:* = this.getCardHolder(param2, param3);
            if (!_loc_4)
            {
                throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + param2.toString() + ", sourcePlayerID: " + param3.toString());
            }
            var _loc_5:* = new _slotRendererRef() as CardSlot;
            _loc_5.useContextMgr = false;
            _loc_5.instanceId = param1.instanceId;
            _loc_5.cardState = "Board";
            this.mcGodCardHolder.addChild(_loc_5);
            this.allCardSlotInstances[param1.instanceId] = _loc_5;
            _loc_5.setCallbacksToCardInstance(param1);
            _loc_4.spawnCard(_loc_5);
            return;
        }// end function

        public function returnToDeck(param1:CardInstance) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this.allCardSlotInstances[param1.instanceId];
            if (_loc_2)
            {
                _loc_3 = this.getCardHolder(CardManager.CARD_LIST_LOC_DECK, param1.owningPlayer);
                CardTweenManager.getInstance().tweenTo(_loc_2, _loc_3.x + CardSlot.CARD_BOARD_WIDTH / 2, _loc_3.y + CardSlot.CARD_BOARD_HEIGHT / 2, this.onReturnToDeckEnded);
            }
            return;
        }// end function

        public function onReturnToDeckEnded(param1:GTween) : void
        {
            var _loc_2:* = param1.target as CardSlot;
            if (_loc_2)
            {
                this.mcGodCardHolder.removeChild(_loc_2);
            }
            return;
        }// end function

        public function removeCardInstance(param1:CardInstance) : void
        {
            var _loc_2:* = this.allCardSlotInstances[param1.instanceId];
            if (_loc_2)
            {
                this.mcGodCardHolder.removeChild(_loc_2);
            }
            return;
        }// end function

        public function updateRowScores(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
        {
            var _loc_7:* = null;
            _loc_7 = this.rowScoreP1Seige.getChildByName("txtScore") as W3TextArea;
            if (_loc_7)
            {
                _loc_7.text = param1.toString();
            }
            _loc_7 = this.rowScoreP1Ranged.getChildByName("txtScore") as W3TextArea;
            if (_loc_7)
            {
                _loc_7.text = param2.toString();
            }
            _loc_7 = this.rowScoreP1Melee.getChildByName("txtScore") as W3TextArea;
            if (_loc_7)
            {
                _loc_7.text = param3.toString();
            }
            _loc_7 = this.rowScoreP2Melee.getChildByName("txtScore") as W3TextArea;
            if (_loc_7)
            {
                _loc_7.text = param4.toString();
            }
            _loc_7 = this.rowScoreP2Ranged.getChildByName("txtScore") as W3TextArea;
            if (_loc_7)
            {
                _loc_7.text = param5.toString();
            }
            _loc_7 = this.rowScoreP2Seige.getChildByName("txtScore") as W3TextArea;
            if (_loc_7)
            {
                _loc_7.text = param6.toString();
            }
            return;
        }// end function

        public function clearAllCards() : void
        {
            var _loc_1:* = null;
            this.mcP1Deck.clearAllCards();
            this.mcP2Deck.clearAllCards();
            this.mcP1Hand.clearAllCards();
            this.mcP2Hand.clearAllCards();
            this.mcP1Graveyard.clearAllCards();
            this.mcP2Graveyard.clearAllCards();
            this.mcP1Siege.clearAllCards();
            this.mcP2Siege.clearAllCards();
            this.mcP1Range.clearAllCards();
            this.mcP2Range.clearAllCards();
            this.mcP1Melee.clearAllCards();
            this.mcP2Melee.clearAllCards();
            this.mcP1SiegeModif.clearAllCards();
            this.mcP2SiegeModif.clearAllCards();
            this.mcP1RangeModif.clearAllCards();
            this.mcP2RangeModif.clearAllCards();
            this.mcP1MeleeModif.clearAllCards();
            this.mcP2MeleeModif.clearAllCards();
            this.mcP1LeaderHolder.clearAllCards();
            this.mcP2LeaderHolder.clearAllCards();
            while (this.mcGodCardHolder.numChildren > 0)
            {
                
                this.mcGodCardHolder.removeChildAt(0);
            }
            return;
        }// end function

        public function updateTransactionCardTooltip(param1:CardSlot) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this.mcTransactionTooltip)
            {
                if (param1 != null)
                {
                    visible = true;
                    GTweener.removeTweens(this.mcTransactionTooltip);
                    GTweener.to(this.mcTransactionTooltip, 0.2, {alpha:1}, {});
                    if (this.cardManager)
                    {
                        _loc_2 = this.cardManager.getCardTemplate(param1.cardIndex);
                        _loc_3 = _loc_2.tooltipString;
                        _loc_4 = this.mcTransactionTooltip.getChildByName("txtTooltipTitle") as TextField;
                        _loc_5 = this.mcTransactionTooltip.getChildByName("txtTooltip") as TextField;
                        if (_loc_3 == "" || !_loc_4 || !_loc_5)
                        {
                            this.mcTransactionTooltip.visible = false;
                        }
                        else
                        {
                            this.mcTransactionTooltip.visible = true;
                            if (_loc_2.index >= 1000)
                            {
                                _loc_4.text = "[[gwint_leader_ability]]";
                            }
                            else
                            {
                                _loc_4.text = "[[" + _loc_3 + "_title]]";
                            }
                            _loc_5.text = "[[" + _loc_3 + "]]";
                            _loc_6 = this.mcTransactionTooltip.getChildByName("mcTooltipIcon") as MovieClip;
                            if (_loc_6)
                            {
                                _loc_6.gotoAndStop(_loc_2.tooltipIcon);
                            }
                        }
                    }
                }
                else if (this.mcTransactionTooltip.visible)
                {
                    GTweener.removeTweens(this.mcTransactionTooltip);
                    GTweener.to(this.mcTransactionTooltip, 0.2, {alpha:0}, {onComplete:this.onTooltipHideEnded});
                }
            }
            return;
        }// end function

        protected function setupCardHolder(param1:GwintCardHolder) : void
        {
            return;
        }// end function

        public function handleMouseMove(event:MouseEvent) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = -1;
            _loc_2 = 0;
            while (_loc_2 < _renderers.length)
            {
                
                _loc_3 = _renderers[_loc_2] as GwintCardHolder;
                if (_loc_3 && (_loc_3.selectable || _loc_3.cardSelectionEnabled) && _loc_3.handleMouseMove(event.stageX, event.stageY))
                {
                    _loc_4 = _loc_2;
                    break;
                }
                _loc_2++;
            }
            selectedIndex = _loc_4;
            return;
        }// end function

        public function handleLeftClick(event:MouseEvent) : void
        {
            this.handleMouseMove(event);
            var _loc_2:* = this.getSelectedCardHolder();
            if (_loc_2)
            {
                _loc_2.handleLeftClick(event);
            }
            return;
        }// end function

        protected function onTooltipHideEnded(param1:GTween) : void
        {
            if (this.mcTransactionTooltip)
            {
                this.mcTransactionTooltip.visible = false;
            }
            return;
        }// end function

    }
}

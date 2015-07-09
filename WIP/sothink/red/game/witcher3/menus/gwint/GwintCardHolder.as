package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import flash.display.*;
    import flash.events.*;
    import red.core.constants.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.slots.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;

    public class GwintCardHolder extends SlotBase
    {
        protected var _cardHolderID:int = -1;
        protected var _playerID:int = -1;
        protected var _uniqueID:int = 0;
        protected var _paddingX:int = 3;
        protected var _paddingY:int = 5;
        public var boardRendererRef:GwintBoardRenderer;
        public var mcHighlight:MovieClip;
        public var mcSelected:MovieClip;
        public var mcStatus:MovieClip;
        public var cardSlotsList:Vector.<CardSlot>;
        protected var _selectedCardIdx:int = -1;
        protected var centerX:int;
        protected var _disableNavigation:Boolean;
        protected var _cardSelectionEnabled:Boolean = true;
        protected var _alwaysHighlight:Boolean = false;
        private var _lastSelectedCard:CardSlot;

        public function GwintCardHolder()
        {
            this.cardSlotsList = new Vector.<CardSlot>;
            return;
        }// end function

        public function get cardHolderID() : int
        {
            return this._cardHolderID;
        }// end function

        public function set cardHolderID(param1:int) : void
        {
            this._cardHolderID = param1;
            return;
        }// end function

        public function get playerID() : int
        {
            return this._playerID;
        }// end function

        public function set playerID(param1:int) : void
        {
            this._playerID = param1;
            return;
        }// end function

        public function get uniqueID() : int
        {
            return this._uniqueID;
        }// end function

        public function set uniqueID(param1:int) : void
        {
            this._uniqueID = param1;
            return;
        }// end function

        public function get paddingX() : int
        {
            return this._paddingX;
        }// end function

        public function set paddingX(param1:int) : void
        {
            this._paddingX = param1;
            return;
        }// end function

        public function get paddingY() : int
        {
            return this._paddingY;
        }// end function

        public function set paddingY(param1:int) : void
        {
            this._paddingY = param1;
            return;
        }// end function

        public function get disableNavigation() : Boolean
        {
            return this._disableNavigation;
        }// end function

        public function set disableNavigation(param1:Boolean) : void
        {
            this._disableNavigation = param1;
            return;
        }// end function

        public function get cardSelectionEnabled() : Boolean
        {
            return this._cardSelectionEnabled;
        }// end function

        public function set cardSelectionEnabled(param1:Boolean)
        {
            this._cardSelectionEnabled = param1;
            this.updateCardSelectionAvailable();
            return;
        }// end function

        public function set alwaysHighlight(param1:Boolean) : void
        {
            if (this._alwaysHighlight == param1)
            {
                return;
            }
            this._alwaysHighlight = param1;
            if (this.mcHighlight)
            {
                if (this.mcSelected)
                {
                    if (this.mcSelected.visible)
                    {
                        this.mcHighlight.visible = false;
                    }
                    else
                    {
                        this.mcHighlight.visible = this._alwaysHighlight;
                    }
                }
                else
                {
                    this.mcHighlight.visible = this._alwaysHighlight;
                }
            }
            return;
        }// end function

        public function handleMouseMove(param1:Number, param2:Number) : Boolean
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (this.cardHolderID == CardManager.CARD_LIST_LOC_HAND && this.playerID == CardManager.PLAYER_2)
            {
                return false;
            }
            _loc_3 = 0;
            while (_loc_3 < this.cardSlotsList.length)
            {
                
                _loc_4 = this.cardSlotsList[_loc_3] as CardSlot;
                if (_loc_4 && _loc_4.mcHitBox.hitTestPoint(param1, param2))
                {
                    this.selectedCardIdx = _loc_3;
                    return true;
                }
                _loc_3++;
            }
            this.selectedCardIdx = -1;
            return hitTestPoint(param1, param2);
        }// end function

        protected function updateCardSelectionAvailable()
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            _loc_1 = 0;
            while (_loc_1 < this.cardSlotsList.length)
            {
                
                _loc_2 = this.cardSlotsList[_loc_1];
                if (_loc_2)
                {
                    _loc_2.activeSelectionEnabled = this._cardSelectionEnabled && selected;
                }
                _loc_1++;
            }
            this.updateDrawOrder();
            return;
        }// end function

        public function get selectedCardIdx() : int
        {
            return this._selectedCardIdx;
        }// end function

        public function set selectedCardIdx(param1:int) : void
        {
            if (param1 == -1 && this._lastSelectedCard == null)
            {
                return;
            }
            if (this._lastSelectedCard != null && this.cardSlotsList.indexOf(this._lastSelectedCard) != -1)
            {
                if (this.cardSlotsList[param1] == this._lastSelectedCard)
                {
                    if (!this._lastSelectedCard.selected)
                    {
                        this._lastSelectedCard.selected = true;
                    }
                    return;
                }
                this._lastSelectedCard.selected = false;
            }
            if (param1 < 0 || param1 >= this.cardSlotsList.length)
            {
                param1 = -1;
            }
            else
            {
                param1 = param1;
            }
            if (param1 != -1)
            {
                this._selectedCardIdx = param1;
                this._lastSelectedCard = this.cardSlotsList[this._selectedCardIdx];
                this._lastSelectedCard.selected = true;
                dispatchEvent(new GwintCardEvent(GwintCardEvent.CARD_SELECTED, true, false, this._lastSelectedCard, this));
            }
            else if (selected)
            {
            }
            this.updateDrawOrder();
            return;
        }// end function

        public function selectCardInstance(param1:CardInstance) : void
        {
            var _loc_2:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.cardSlotsList.length)
            {
                
                if (this.cardSlotsList[_loc_2].cardInstance == param1)
                {
                    this.selectedCardIdx = _loc_2;
                    return;
                }
                _loc_2++;
            }
            throw new Error("GFX [ERROR] - tried to select card in slot: (" + this.cardHolderID + ", " + this.playerID + "), but could could not find reference to: " + param1);
        }// end function

        public function selectCard(param1:CardSlot) : void
        {
            var _loc_2:* = this.cardSlotsList.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.selectedCardIdx = _loc_2;
            }
            else
            {
                throw new Error("GFX [ERROR] - tried to select card in slot: (" + this.cardHolderID + ", " + this.playerID + "), but could could not find reference to: " + param1);
            }
            return;
        }// end function

        public function findSelection() : void
        {
            if (this.selectedCardIdx < 0)
            {
                this.selectedCardIdx = 0;
            }
            return;
        }// end function

        public function getSelectedCardSlot() : CardSlot
        {
            if (this._selectedCardIdx >= 0 && this._selectedCardIdx < this.cardSlotsList.length)
            {
                return this.cardSlotsList[this._selectedCardIdx];
            }
            return null;
        }// end function

        override public function set selected(param1:Boolean) : void
        {
            if (!this.boardRendererRef || param1 == selected)
            {
                return;
            }
            super.selected = param1;
            if (param1)
            {
                this.mcSelected.visible = true;
                this.mcHighlight.visible = false;
                dispatchEvent(new GwintHolderEvent(GwintHolderEvent.HOLDER_SELECTED, true, false, this));
                if (this.selectedCardIdx == -1 && this.cardSlotsList.length > 0)
                {
                    this.selectedCardIdx = 0;
                }
            }
            else
            {
                this.mcSelected.visible = false;
                this.mcHighlight.visible = this._alwaysHighlight;
            }
            this.updateCardSelectionAvailable();
            this.updateDrawOrder();
            return;
        }// end function

        override public function set selectable(param1:Boolean) : void
        {
            super.selectable = param1;
            if (selectable && enabled && this.mcSelected)
            {
                this.mcSelected.visible = selected;
            }
            else if (!selectable && this.mcSelected)
            {
                this.mcSelected.visible = false;
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (this.mcHighlight)
            {
                this.mcHighlight.visible = false;
                this.mcHighlight.stop();
            }
            if (this.mcSelected)
            {
                this.mcSelected.visible = false;
            }
            if (this.mcStatus)
            {
                this.mcStatus.visible = false;
            }
            return;
        }// end function

        public function updateLeaderStatus(param1:Boolean) : void
        {
            var _loc_2:* = null;
            if (this.cardSlotsList.length > 0)
            {
                _loc_2 = this.cardSlotsList[0] as CardSlot;
            }
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = _loc_2.cardInstance as CardLeaderInstance;
            if (!_loc_3)
            {
                return;
            }
            if (_loc_3.hasBeenUsed)
            {
                this.mcStatus.visible = false;
                if (_loc_2)
                {
                    _loc_2.darkenIcon(0.3);
                }
            }
            else
            {
                if (_loc_2)
                {
                    _loc_2.filters = [];
                }
                if (this.mcStatus)
                {
                    if (param1)
                    {
                        this.mcStatus.visible = true;
                        if (_loc_3.canBeUsed)
                        {
                            this.mcStatus.gotoAndStop(1);
                        }
                        else
                        {
                            this.mcStatus.gotoAndStop(2);
                        }
                    }
                    else
                    {
                        this.mcStatus.visible = false;
                    }
                }
            }
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            super.handleInput(event);
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_DOWN || _loc_2.value == InputValue.KEY_HOLD;
            var _loc_4:* = _loc_2.navEquivalent;
            if (_loc_3)
            {
                switch(_loc_4)
                {
                    case NavigationCode.LEFT:
                    {
                        if (this.cardHolderID != CardManager.CARD_LIST_LOC_GRAVEYARD)
                        {
                            if (this.selectedCardIdx > 0 && !this._disableNavigation && this.cardSlotsList.length > 0)
                            {
                                var _loc_5:* = this;
                                var _loc_6:* = this.selectedCardIdx - 1;
                                _loc_5.selectedCardIdx = _loc_6;
                                event.handled = true;
                            }
                        }
                        break;
                    }
                    case NavigationCode.RIGHT:
                    {
                        if (this.cardHolderID != CardManager.CARD_LIST_LOC_GRAVEYARD)
                        {
                            if (this.selectedCardIdx < (this.cardSlotsList.length - 1) && !this._disableNavigation && this.cardSlotsList.length > 0)
                            {
                                var _loc_5:* = this;
                                var _loc_6:* = this.selectedCardIdx + 1;
                                _loc_5.selectedCardIdx = _loc_6;
                                event.handled = true;
                            }
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            if (_loc_2.value == InputValue.KEY_UP && _loc_4 == NavigationCode.GAMEPAD_A && _loc_2.code != KeyCode.SPACE)
            {
                this.handleActivatePressed();
            }
            return;
        }// end function

        public function handleLeftClick(event:MouseEvent) : void
        {
            this.handleActivatePressed();
            return;
        }// end function

        protected function handleActivatePressed() : void
        {
            var _loc_1:* = null;
            if (this.selectedCardIdx > -1 && this.selectedCardIdx < this.cardSlotsList.length)
            {
                _loc_1 = this.cardSlotsList[this.selectedCardIdx];
            }
            if (_loc_1)
            {
                dispatchEvent(new GwintCardEvent(GwintCardEvent.CARD_CHOSEN, true, false, _loc_1, this));
            }
            dispatchEvent(new GwintHolderEvent(GwintHolderEvent.HOLDER_CHOSEN, true, false, this));
            return;
        }// end function

        public function spawnCard(param1:CardSlot) : void
        {
            param1.x = this.x;
            param1.y = this.y;
            return;
        }// end function

        protected function cardSorter(param1:CardSlot, param2:CardSlot) : Number
        {
            var _loc_3:* = param1.cardInstance;
            var _loc_4:* = param2.cardInstance;
            if (_loc_3.templateId == _loc_4.templateId)
            {
                return 0;
            }
            var _loc_5:* = _loc_3.templateRef.getCreatureType();
            var _loc_6:* = _loc_4.templateRef.getCreatureType();
            if (_loc_5 == CardTemplate.CardType_None && _loc_6 == CardTemplate.CardType_None)
            {
                return _loc_3.templateId - _loc_4.templateId;
            }
            if (_loc_5 == CardTemplate.CardType_None)
            {
                return -1;
            }
            if (_loc_6 == CardTemplate.CardType_None)
            {
                return 1;
            }
            if (_loc_3.templateRef.power != _loc_4.templateRef.power)
            {
                return _loc_3.templateRef.power - _loc_4.templateRef.power;
            }
            return _loc_3.templateId - _loc_4.templateId;
        }// end function

        public function cardAdded(param1:CardSlot) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            if (this.selectedCardIdx != -1 && this.selectedCardIdx < this.cardSlotsList.length)
            {
                _loc_2 = this.cardSlotsList[this.selectedCardIdx];
            }
            this.cardSlotsList.Count(param1);
            this.cardSlotsList.sort(this.cardSorter);
            if (_loc_2 != null)
            {
                _loc_3 = this.cardSlotsList.indexOf(_loc_2);
                if (_loc_3 != this.selectedCardIdx)
                {
                    this.selectedCardIdx = _loc_3;
                }
            }
            this.repositionAllCards();
            param1.activeSelectionEnabled = selected && this._cardSelectionEnabled;
            if (param1.selected)
            {
                param1.selected = false;
            }
            this.updateWeatherEffects();
            this.registerCard(param1);
            return;
        }// end function

        public function cardRemoved(param1:CardSlot) : void
        {
            this.unregisterCard(param1);
            var _loc_2:* = this.cardSlotsList.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.cardSlotsList.splice(_loc_2, 1);
                this.findCardSelection(_loc_2 >= this._selectedCardIdx);
            }
            this.repositionAllCards();
            this.updateWeatherEffects();
            return;
        }// end function

        protected function registerCard(param1:CardSlot) : void
        {
            if (param1)
            {
            }
            return;
        }// end function

        protected function unregisterCard(param1:CardSlot) : void
        {
            if (param1)
            {
            }
            return;
        }// end function

        protected function onCardMouseOver(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = event.target as CardSlot;
            if (_loc_2)
            {
                _loc_3 = this.cardSlotsList.indexOf(_loc_2);
                if (_loc_3 != -1)
                {
                    this.selectedCardIdx = _loc_3;
                }
            }
            return;
        }// end function

        protected function onCardMouseOut(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = event.target as CardSlot;
            if (_loc_2)
            {
                _loc_3 = this.cardSlotsList.indexOf(_loc_2);
                if (_loc_3 != -1)
                {
                    this.selectedCardIdx = -1;
                }
            }
            return;
        }// end function

        protected function updateWeatherEffects() : void
        {
            var _loc_1:* = false;
            var _loc_2:* = false;
            var _loc_3:* = false;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this.boardRendererRef && this.cardHolderID == CardManager.CARD_LIST_LOC_WEATHERSLOT)
            {
                _loc_1 = false;
                _loc_2 = false;
                _loc_3 = false;
                _loc_4 = 0;
                while (_loc_4 < this.cardSlotsList.length)
                {
                    
                    _loc_5 = this.cardSlotsList[_loc_4];
                    switch(_loc_5.cardInstance.templateRef.getFirstEffect())
                    {
                        case CardTemplate.CardEffect_Melee:
                        {
                            _loc_1 = true;
                            break;
                        }
                        case CardTemplate.CardEffect_Ranged:
                        {
                            _loc_2 = true;
                            break;
                        }
                        case CardTemplate.CardEffect_Siege:
                        {
                            _loc_3 = true;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_4++;
                }
                _loc_6 = CardFXManager.getInstance();
                _loc_6.ShowWeatherOngoing(CardManager.CARD_LIST_LOC_MELEE, _loc_1);
                _loc_6.ShowWeatherOngoing(CardManager.CARD_LIST_LOC_RANGED, _loc_2);
                _loc_6.ShowWeatherOngoing(CardManager.CARD_LIST_LOC_SEIGE, _loc_3);
            }
            return;
        }// end function

        protected function findCardSelection(param1:Boolean) : void
        {
            this.selectedCardIdx = Math.max(0, Math.min((this.cardSlotsList.length - 1), this._selectedCardIdx));
            return;
        }// end function

        public function repositionAllCards() : void
        {
            if (this.cardHolderID == CardManager.CARD_LIST_LOC_GRAVEYARD)
            {
                this.repositionAllCards_Graveyard();
            }
            else if (this.cardHolderID == CardManager.CARD_LIST_LOC_MELEE || this.cardHolderID == CardManager.CARD_LIST_LOC_SEIGE || this.cardHolderID == CardManager.CARD_LIST_LOC_RANGED || this.cardHolderID == CardManager.CARD_LIST_LOC_HAND)
            {
                this.repositionAllCards_Standard(true);
            }
            else
            {
                this.repositionAllCards_Standard(false);
            }
            return;
        }// end function

        private function repositionAllCards_Graveyard() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = CardTweenManager.getInstance();
            if (this.cardSlotsList.length == 0 || !_loc_1)
            {
                return;
            }
            var _loc_4:* = this.cardSlotsList[0].parent as MovieClip;
            var _loc_5:* = this.x + this.width / 2;
            _loc_5 = _loc_5 - (this.cardSlotsList.length - 1) * 1;
            var _loc_6:* = this.y + this.height / 2;
            _loc_6 = _loc_6 - (this.cardSlotsList.length - 1) * 2;
            _loc_2 = 0;
            while (_loc_2 < this.cardSlotsList.length)
            {
                
                _loc_3 = this.cardSlotsList[_loc_2];
                _loc_4.addChildAt(_loc_3, 0);
                _loc_1.tweenTo(_loc_3, _loc_5, _loc_6, this.onPositionCardEnded);
                _loc_5 = _loc_5 + 1;
                _loc_6 = _loc_6 + 2;
                _loc_2++;
            }
            return;
        }// end function

        private function repositionAllCards_Standard(param1:Boolean) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = NaN;
            var _loc_2:* = CardTweenManager.getInstance();
            if (!_loc_2)
            {
                throw new Error("GFX -- Trying to reposition all cards but the CardTweenManager instance does not exist !!!");
            }
            if (this.cardSlotsList.length > 0)
            {
                _loc_3 = (this.cardSlotsList.length - 1) * this._paddingX + this.cardSlotsList.length * CardSlot.CARD_BOARD_WIDTH;
                _loc_4 = this.x + this.width / 2 - _loc_3 / 2;
                _loc_5 = CardSlot.CARD_BOARD_WIDTH + this._paddingX;
                if (this.cardHolderID == CardManager.CARD_LIST_LOC_LEADER)
                {
                    _loc_4 = this.x + this.mcSelected.width / 2 - _loc_3 / 2;
                }
                if (param1 && _loc_3 > this.width)
                {
                    _loc_5 = _loc_5 - (_loc_3 - this.width) / (this.cardSlotsList.length - 1);
                    _loc_4 = this.x;
                }
                _loc_4 = _loc_4 + CardSlot.CARD_BOARD_WIDTH / 2;
                _loc_8 = this.y + this.height / 2;
                _loc_6 = 0;
                while (_loc_6 < this.cardSlotsList.length)
                {
                    
                    _loc_7 = this.cardSlotsList[_loc_6];
                    _loc_2.tweenTo(_loc_7, _loc_4, _loc_8, this.onPositionCardEnded);
                    _loc_4 = _loc_4 + _loc_5;
                    _loc_6++;
                }
                this.updateDrawOrder();
            }
            return;
        }// end function

        private function updateDrawOrder() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            if (this.cardHolderID == CardManager.CARD_LIST_LOC_GRAVEYARD)
            {
                _loc_1 = this.cardSlotsList.length - 1;
                while (_loc_1 >= 0)
                {
                    
                    _loc_2 = this.cardSlotsList[_loc_1];
                    _loc_2.parent.addChild(_loc_2);
                    _loc_1 = _loc_1 - 1;
                }
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < this.cardSlotsList.length)
                {
                    
                    _loc_2 = this.cardSlotsList[_loc_1];
                    _loc_2.parent.addChild(_loc_2);
                    _loc_1++;
                }
            }
            _loc_2 = this.getSelectedCardSlot();
            if (selected && _loc_2 != null && this.cardSelectionEnabled)
            {
                _loc_2.parent.addChild(_loc_2);
            }
            return;
        }// end function

        public function onPositionCardEnded(param1:GTween) : void
        {
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = _loc_2.getCardInstance((param1.target as CardSlot).instanceId);
            if (_loc_3)
            {
                _loc_3.onFinishedMovingIntoHolder(this._cardHolderID, this._playerID);
            }
            return;
        }// end function

        public function clearAllCards() : void
        {
            this.cardSlotsList.length = 0;
            return;
        }// end function

    }
}

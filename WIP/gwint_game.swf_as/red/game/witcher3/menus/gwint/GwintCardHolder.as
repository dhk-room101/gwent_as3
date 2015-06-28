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
    
    public class GwintCardHolder extends red.game.witcher3.slots.SlotBase
    {
        public function GwintCardHolder()
        {
            this.cardSlotsList = new Vector.<red.game.witcher3.menus.gwint.CardSlot>();
            super();
            return;
        }

        protected function cardSorter(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:red.game.witcher3.menus.gwint.CardSlot):Number
        {
            var loc1:*=arg1.cardInstance;
            var loc2:*=arg2.cardInstance;
            if (loc1.templateId == loc2.templateId) 
            {
                return 0;
            }
            var loc3:*=loc1.templateRef.getCreatureType();
            var loc4:*=loc2.templateRef.getCreatureType();
            if (loc3 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None && loc4 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
            {
                return loc1.templateId - loc2.templateId;
            }
            if (loc3 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
            {
                return -1;
            }
            if (loc4 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) 
            {
                return 1;
            }
            if (loc1.templateRef.power != loc2.templateRef.power) 
            {
                return loc1.templateRef.power - loc2.templateRef.power;
            }
            return loc1.templateId - loc2.templateId;
        }

        public function get cardHolderID():int
        {
            return this._cardHolderID;
        }

        public function set cardHolderID(arg1:int):void
        {
            this._cardHolderID = arg1;
            return;
        }

        public function cardAdded(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            var loc1:*=null;
            var loc2:*=0;
            if (!(this.selectedCardIdx == -1) && this.selectedCardIdx < this.cardSlotsList.length) 
            {
                loc1 = this.cardSlotsList[this.selectedCardIdx];
            }
            this.cardSlotsList.push(arg1);
            this.cardSlotsList.sort(this.cardSorter);
            if (loc1 != null) 
            {
                loc2 = this.cardSlotsList.indexOf(loc1);
                if (loc2 != this.selectedCardIdx) 
                {
                    this.selectedCardIdx = loc2;
                }
            }
            this.repositionAllCards();
            arg1.activeSelectionEnabled = selected && this._cardSelectionEnabled;
            if (arg1.selected) 
            {
                arg1.selected = false;
            }
            this.updateWeatherEffects();
            this.registerCard(arg1);
            return;
        }

        public function get playerID():int
        {
            return this._playerID;
        }

        public function set playerID(arg1:int):void
        {
            this._playerID = arg1;
            return;
        }

        public function get paddingY():int
        {
            return this._paddingY;
        }

        public function get uniqueID():int
        {
            return this._uniqueID;
        }

        public function set uniqueID(arg1:int):void
        {
            this._uniqueID = arg1;
            return;
        }

        public function cardRemoved(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            this.unregisterCard(arg1);
            var loc1:*=this.cardSlotsList.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.cardSlotsList.splice(loc1, 1);
                this.findCardSelection(loc1 >= this._selectedCardIdx);
            }
            this.repositionAllCards();
            this.updateWeatherEffects();
            return;
        }

        public function get paddingX():int
        {
            return this._paddingX;
        }

        public function set paddingX(arg1:int):void
        {
            this._paddingX = arg1;
            return;
        }

        protected function registerCard(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            if (!arg1) 
            {
            };
            return;
        }

        protected function unregisterCard(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            if (!arg1) 
            {
            };
            return;
        }

        public function set paddingY(arg1:int):void
        {
            this._paddingY = arg1;
            return;
        }

        protected function onCardMouseOver(arg1:flash.events.Event):void
        {
            var loc2:*=0;
            var loc1:*=arg1.target as red.game.witcher3.menus.gwint.CardSlot;
            if (loc1) 
            {
                loc2 = this.cardSlotsList.indexOf(loc1);
                if (loc2 != -1) 
                {
                    this.selectedCardIdx = loc2;
                }
            }
            return;
        }

        protected function onCardMouseOut(arg1:flash.events.Event):void
        {
            var loc2:*=0;
            var loc1:*=arg1.target as red.game.witcher3.menus.gwint.CardSlot;
            if (loc1) 
            {
                loc2 = this.cardSlotsList.indexOf(loc1);
                if (loc2 != -1) 
                {
                    this.selectedCardIdx = -1;
                }
            }
            return;
        }

        protected function updateWeatherEffects():void
        {
            var loc1:*=false;
            var loc2:*=false;
            var loc3:*=false;
            var loc4:*=0;
            var loc5:*=null;
            var loc6:*=null;
            if (this.boardRendererRef && this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_WEATHERSLOT) 
            {
                loc1 = false;
                loc2 = false;
                loc3 = false;
                loc4 = 0;
                while (loc4 < this.cardSlotsList.length) 
                {
                    loc5 = this.cardSlotsList[loc4];
                    var loc7:*=loc5.cardInstance.templateRef.getFirstEffect();
                    switch (loc7) 
                    {
                        case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee:
                        {
                            loc1 = true;
                            break;
                        }
                        case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged:
                        {
                            loc2 = true;
                            break;
                        }
                        case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege:
                        {
                            loc3 = true;
                            break;
                        }
                    }
                    ++loc4;
                }
                loc6 = red.game.witcher3.menus.gwint.CardFXManager.getInstance();
                loc6.ShowWeatherOngoing(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, loc1);
                loc6.ShowWeatherOngoing(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, loc2);
                loc6.ShowWeatherOngoing(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, loc3);
            }
            return;
        }

        protected function findCardSelection(arg1:Boolean):void
        {
            this.selectedCardIdx = Math.max(0, Math.min((this.cardSlotsList.length - 1), this._selectedCardIdx));
            return;
        }

        public function repositionAllCards():void
        {
            if (this.cardHolderID != red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD) 
            {
                if (this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE || this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE || this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED || this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND) 
                {
                    this.repositionAllCards_Standard(true);
                }
                else 
                {
                    this.repositionAllCards_Standard(false);
                }
            }
            else 
            {
                this.repositionAllCards_Graveyard();
            }
            return;
        }

        private function repositionAllCards_Graveyard():void
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=red.game.witcher3.menus.gwint.CardTweenManager.getInstance();
            if (this.cardSlotsList.length == 0 || !loc1) 
            {
                return;
            }
            var loc4:*=this.cardSlotsList[0].parent as flash.display.MovieClip;
            var loc5:*=this.x + this.width / 2;
            loc5 = loc5 - (this.cardSlotsList.length - 1) * 1;
            var loc6:*=this.y + this.height / 2;
            loc6 = loc6 - (this.cardSlotsList.length - 1) * 2;
            loc2 = 0;
            while (loc2 < this.cardSlotsList.length) 
            {
                loc3 = this.cardSlotsList[loc2];
                loc4.addChildAt(loc3, 0);
                loc1.tweenTo(loc3, loc5, loc6, this.onPositionCardEnded);
                loc5 = loc5 + 1;
                loc6 = loc6 + 2;
                ++loc2;
            }
            return;
        }

        private function repositionAllCards_Standard(arg1:Boolean):void
        {
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=0;
            var loc5:*=0;
            var loc6:*=null;
            var loc7:*=NaN;
            var loc1:*=red.game.witcher3.menus.gwint.CardTweenManager.getInstance();
            if (!loc1) 
            {
                throw new Error("GFX -- Trying to reposition all cards but the CardTweenManager instance does not exist !!!");
            }
            if (this.cardSlotsList.length > 0) 
            {
                loc2 = (this.cardSlotsList.length - 1) * this._paddingX + this.cardSlotsList.length * red.game.witcher3.menus.gwint.CardSlot.CARD_BOARD_WIDTH;
                loc3 = this.x + this.width / 2 - loc2 / 2;
                loc4 = red.game.witcher3.menus.gwint.CardSlot.CARD_BOARD_WIDTH + this._paddingX;
                if (this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER) 
                {
                    loc3 = this.x + this.mcSelected.width / 2 - loc2 / 2;
                }
                if (arg1 && loc2 > this.width) 
                {
                    loc4 = loc4 - (loc2 - this.width) / (this.cardSlotsList.length - 1);
                    loc3 = this.x;
                }
                loc3 = loc3 + red.game.witcher3.menus.gwint.CardSlot.CARD_BOARD_WIDTH / 2;
                loc7 = this.y + this.height / 2;
                loc5 = 0;
                while (loc5 < this.cardSlotsList.length) 
                {
                    loc6 = this.cardSlotsList[loc5];
                    loc1.tweenTo(loc6, loc3, loc7, this.onPositionCardEnded);
                    loc3 = loc3 + loc4;
                    ++loc5;
                }
                this.updateDrawOrder();
            }
            return;
        }

        private function updateDrawOrder():void
        {
            var loc1:*=0;
            var loc2:*=null;
            if (this.cardHolderID != red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD) 
            {
                loc1 = 0;
                while (loc1 < this.cardSlotsList.length) 
                {
                    loc2 = this.cardSlotsList[loc1];
                    loc2.parent.addChild(loc2);
                    ++loc1;
                }
            }
            else 
            {
                loc1 = (this.cardSlotsList.length - 1);
                while (loc1 >= 0) 
                {
                    loc2 = this.cardSlotsList[loc1];
                    loc2.parent.addChild(loc2);
                    --loc1;
                }
            }
            loc2 = this.getSelectedCardSlot();
            if (selected && !(loc2 == null) && this.cardSelectionEnabled) 
            {
                loc2.parent.addChild(loc2);
            }
            return;
        }

        public function get disableNavigation():Boolean
        {
            return this._disableNavigation;
        }

        public function set disableNavigation(arg1:Boolean):void
        {
            this._disableNavigation = arg1;
            return;
        }

        public function onPositionCardEnded(arg1:com.gskinner.motion.GTween):void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=loc1.getCardInstance((arg1.target as red.game.witcher3.menus.gwint.CardSlot).instanceId);
            if (loc2) 
            {
                loc2.onFinishedMovingIntoHolder(this._cardHolderID, this._playerID);
            }
            return;
        }

        public function get cardSelectionEnabled():Boolean
        {
            return this._cardSelectionEnabled;
        }

        public function set cardSelectionEnabled(arg1:Boolean):*
        {
            this._cardSelectionEnabled = arg1;
            this.updateCardSelectionAvailable();
            return;
        }

        public function clearAllCards():void
        {
            this.cardSlotsList.length = 0;
            return;
        }

        public function set alwaysHighlight(arg1:Boolean):void
        {
            if (this._alwaysHighlight == arg1) 
            {
                return;
            }
            this._alwaysHighlight = arg1;
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
        }

        public function handleMouseMove(arg1:Number, arg2:Number):Boolean
        {
            var loc1:*=0;
            var loc2:*=null;
            if (this.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND && this.playerID == red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
            {
                return false;
            }
            loc1 = 0;
            while (loc1 < this.cardSlotsList.length) 
            {
                loc2 = this.cardSlotsList[loc1] as red.game.witcher3.menus.gwint.CardSlot;
                if (loc2 && loc2.mcHitBox.hitTestPoint(arg1, arg2)) 
                {
                    this.selectedCardIdx = loc1;
                    return true;
                }
                ++loc1;
            }
            this.selectedCardIdx = -1;
            return hitTestPoint(arg1, arg2);
        }

        protected function updateCardSelectionAvailable():*
        {
            var loc1:*=0;
            var loc2:*=null;
            loc1 = 0;
            while (loc1 < this.cardSlotsList.length) 
            {
                loc2 = this.cardSlotsList[loc1];
                if (loc2) 
                {
                    loc2.activeSelectionEnabled = this._cardSelectionEnabled && selected;
                }
                ++loc1;
            }
            this.updateDrawOrder();
            return;
        }

        public function get selectedCardIdx():int
        {
            return this._selectedCardIdx;
        }

        public function set selectedCardIdx(arg1:int):void
        {
            if (arg1 == -1 && this._lastSelectedCard == null) 
            {
                return;
            }
            if (!(this._lastSelectedCard == null) && !(this.cardSlotsList.indexOf(this._lastSelectedCard) == -1)) 
            {
                if (this.cardSlotsList[arg1] == this._lastSelectedCard) 
                {
                    if (!this._lastSelectedCard.selected) 
                    {
                        this._lastSelectedCard.selected = true;
                    }
                    return;
                }
                this._lastSelectedCard.selected = false;
            }
            if (arg1 < 0 || arg1 >= this.cardSlotsList.length) 
            {
                arg1 = -1;
            }
            else 
            {
                arg1 = arg1;
            }
            if (arg1 == -1) 
            {
                if (!selected) 
                {
                };
            }
            else 
            {
                this._selectedCardIdx = arg1;
                this._lastSelectedCard = this.cardSlotsList[this._selectedCardIdx];
                this._lastSelectedCard.selected = true;
                dispatchEvent(new red.game.witcher3.events.GwintCardEvent(red.game.witcher3.events.GwintCardEvent.CARD_SELECTED, true, false, this._lastSelectedCard, this));
            }
            this.updateDrawOrder();
            return;
        }

        public function selectCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=0;
            loc1 = 0;
            while (loc1 < this.cardSlotsList.length) 
            {
                if (this.cardSlotsList[loc1].cardInstance == arg1) 
                {
                    this.selectedCardIdx = loc1;
                    return;
                }
                ++loc1;
            }
            throw new Error("GFX [ERROR] - tried to select card in slot: (" + this.cardHolderID + ", " + this.playerID + "), but could could not find reference to: " + arg1);
        }

        public function selectCard(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            var loc1:*=this.cardSlotsList.indexOf(arg1);
            if (loc1 == -1) 
            {
                throw new Error("GFX [ERROR] - tried to select card in slot: (" + this.cardHolderID + ", " + this.playerID + "), but could could not find reference to: " + arg1);
            }
            else 
            {
                this.selectedCardIdx = loc1;
            }
            return;
        }

        public function findSelection():void
        {
            if (this.selectedCardIdx < 0) 
            {
                this.selectedCardIdx = 0;
            }
            return;
        }

        public function getSelectedCardSlot():red.game.witcher3.menus.gwint.CardSlot
        {
            if (this._selectedCardIdx >= 0 && this._selectedCardIdx < this.cardSlotsList.length) 
            {
                return this.cardSlotsList[this._selectedCardIdx];
            }
            return null;
        }

        public override function set selected(arg1:Boolean):void
        {
            if (!this.boardRendererRef || arg1 == selected) 
            {
                return;
            }
            super.selected = arg1;
            if (arg1) 
            {
                this.mcSelected.visible = true;
                this.mcHighlight.visible = false;
                dispatchEvent(new red.game.witcher3.events.GwintHolderEvent(red.game.witcher3.events.GwintHolderEvent.HOLDER_SELECTED, true, false, this));
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
        }

        public override function set selectable(arg1:Boolean):void
        {
            super.selectable = arg1;
            if (selectable && enabled && this.mcSelected) 
            {
                this.mcSelected.visible = selected;
            }
            else if (!selectable && this.mcSelected) 
            {
                this.mcSelected.visible = false;
            }
            return;
        }

        protected override function configUI():void
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
        }

        public function updateLeaderStatus(arg1:Boolean):void
        {
            var loc1:*=null;
            if (this.cardSlotsList.length > 0) 
            {
                loc1 = this.cardSlotsList[0] as red.game.witcher3.menus.gwint.CardSlot;
            }
            if (!loc1) 
            {
                return;
            }
            var loc2:*=loc1.cardInstance as red.game.witcher3.menus.gwint.CardLeaderInstance;
            if (!loc2) 
            {
                return;
            }
            if (loc2.hasBeenUsed) 
            {
                this.mcStatus.visible = false;
                if (loc1) 
                {
                    loc1.darkenIcon(0.3);
                }
            }
            else 
            {
                if (loc1) 
                {
                    loc1.filters = [];
                }
                if (this.mcStatus) 
                {
                    if (arg1) 
                    {
                        this.mcStatus.visible = true;
                        if (loc2.canBeUsed) 
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
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            super.handleInput(arg1);
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN || loc1.value == scaleform.clik.constants.InputValue.KEY_HOLD;
            var loc3:*=loc1.navEquivalent;
            if (loc2) 
            {
                var loc4:*=loc3;
                switch (loc4) 
                {
                    case scaleform.clik.constants.NavigationCode.LEFT:
                    {
                        if (this.cardHolderID != red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD) 
                        {
                            if (this.selectedCardIdx > 0 && !this._disableNavigation && this.cardSlotsList.length > 0) 
                            {
                                var loc5:*=((loc4 = this).selectedCardIdx - 1);
                                loc4.selectedCardIdx = loc5;
                                arg1.handled = true;
                            }
                        }
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.RIGHT:
                    {
                        if (this.cardHolderID != red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD) 
                        {
                            if (this.selectedCardIdx < (this.cardSlotsList.length - 1) && !this._disableNavigation && this.cardSlotsList.length > 0) 
                            {
                                loc5 = ((loc4 = this).selectedCardIdx + 1);
                                loc4.selectedCardIdx = loc5;
                                arg1.handled = true;
                            }
                        }
                        break;
                    }
                }
            }
            if (loc1.value == scaleform.clik.constants.InputValue.KEY_UP && loc3 == scaleform.clik.constants.NavigationCode.GAMEPAD_A && !(loc1.code == red.core.constants.KeyCode.SPACE)) 
            {
                this.handleActivatePressed();
            }
            return;
        }

        public function handleLeftClick(arg1:flash.events.MouseEvent):void
        {
            this.handleActivatePressed();
            return;
        }

        protected function handleActivatePressed():void
        {
            var loc1:*=null;
            if (this.selectedCardIdx > -1 && this.selectedCardIdx < this.cardSlotsList.length) 
            {
                loc1 = this.cardSlotsList[this.selectedCardIdx];
            }
            if (loc1) 
            {
                dispatchEvent(new red.game.witcher3.events.GwintCardEvent(red.game.witcher3.events.GwintCardEvent.CARD_CHOSEN, true, false, loc1, this));
            }
            dispatchEvent(new red.game.witcher3.events.GwintHolderEvent(red.game.witcher3.events.GwintHolderEvent.HOLDER_CHOSEN, true, false, this));
            return;
        }

        public function spawnCard(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            arg1.x = this.x;
            arg1.y = this.y;
            return;
        }

        protected var _cardHolderID:int=-1;

        protected var _playerID:int=-1;

        protected var _paddingX:int=3;

        protected var _paddingY:int=5;

        protected var _uniqueID:int=0;

        public var boardRendererRef:red.game.witcher3.menus.gwint.GwintBoardRenderer;

        public var mcHighlight:flash.display.MovieClip;

        public var mcSelected:flash.display.MovieClip;

        public var mcStatus:flash.display.MovieClip;

        public var cardSlotsList:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardSlot>;

        protected var _selectedCardIdx:int=-1;

        protected var centerX:int;

        protected var _disableNavigation:Boolean;

        protected var _cardSelectionEnabled:Boolean=true;

        protected var _alwaysHighlight:Boolean=false;

        private var _lastSelectedCard:red.game.witcher3.menus.gwint.CardSlot;
    }
}

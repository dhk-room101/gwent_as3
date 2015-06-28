package red.game.witcher3.menus.gwint 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.slots.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.events.*;
    import scaleform.gfx.*;
    
    public class CardSlot extends red.game.witcher3.slots.SlotBase implements red.game.witcher3.interfaces.IInventorySlot
    {
        public function CardSlot()
        {
            super();
            this._instanceId = -1;
            this._cardIndex = -1;
            this.visible = false;
            this._cardState = STATE_DECK;
            if (this.mcCardHighlight) 
            {
                this.mcCardHighlight.visible = false;
            }
            if (this.mcCopyCount) 
            {
                this.mcCopyCount.visible = false;
            }
            if (this.mcLockedIcon) 
            {
                this.mcLockedIcon.visible = false;
            }
            return;
        }

        protected function get adjCardHeight():int
        {
            if (this._cardState == STATE_BOARD) 
            {
                return CARD_BOARD_HEIGHT;
            }
            if (this._cardState == STATE_DECK) 
            {
                return 355;
            }
            if (this._cardState == STATE_CAROUSEL) 
            {
                return CARD_CAROUSEL_HEIGHT;
            }
            return CARD_ORIGIN_HEIGHT;
        }

        protected function get adjCardWidth():int
        {
            if (this._cardState == STATE_BOARD) 
            {
                return CARD_BOARD_WIDTH;
            }
            if (this._cardState == STATE_DECK) 
            {
                return 188;
            }
            if (this._cardState == STATE_CAROUSEL) 
            {
                return 309;
            }
            return CARD_ORIGIN_WIDTH;
        }

        protected function onCardTemplatesLoaded(arg1:flash.events.Event):void
        {
            red.game.witcher3.menus.gwint.CardManager.getInstance().removeEventListener(red.game.witcher3.menus.gwint.CardManager.cardTemplatesLoaded, this.onCardTemplatesLoaded, false);
            this.setupCardWithTemplate(red.game.witcher3.menus.gwint.CardManager.getInstance().getCardTemplate(this.cardIndex));
            return;
        }

        protected override function handleIconLoaded(arg1:flash.events.Event):void
        {
            var loc1:*=flash.display.Bitmap(arg1.target.content);
            if (loc1) 
            {
                loc1.smoothing = true;
                loc1.pixelSnapping = flash.display.PixelSnapping.NEVER;
            }
            this.visible = true;
            this.imageLoaded = true;
            this.updateCardSetup();
            return;
        }

        protected function updateCardSetup():void
        {
            var loc7:*=null;
            if (!this.imageLoaded) 
            {
                return;
            }
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance().getCardTemplate(this._cardIndex);
            var loc2:*=this.adjCardHeight;
            var loc3:*=this.adjCardWidth;
            var loc4:*=loc2 / 2;
            var loc5:*=loc3 / 2;
            var loc6:*=loc2 / CARD_CAROUSEL_HEIGHT;
            if (this.mcCopyCount) 
            {
                this.mcCopyCount.x = 0;
                this.mcCopyCount.y = loc4;
            }
            if (this.mcHitBox) 
            {
                if (this._cardState != STATE_BOARD) 
                {
                    this.mcHitBox.width = loc3;
                    this.mcHitBox.height = loc2;
                }
                else 
                {
                    this.mcHitBox.width = CARD_BOARD_WIDTH;
                    this.mcHitBox.height = CARD_BOARD_HEIGHT;
                }
            }
            if (this.mcPowerIndicator) 
            {
                if (this._cardState != STATE_BOARD) 
                {
                    this.mcPowerIndicator.scaleY = loc8 = loc6;
                    this.mcPowerIndicator.scaleX = loc8;
                }
                else 
                {
                    var loc8:*;
                    this.mcPowerIndicator.scaleY = loc8 = POWER_ICON_BOARD_SCALE;
                    this.mcPowerIndicator.scaleX = loc8;
                }
                this.mcPowerIndicator.x = -loc5;
                this.mcPowerIndicator.y = -loc4;
            }
            if (this.mcTypeIcon) 
            {
                if (this._cardState != STATE_BOARD) 
                {
                    this.mcTypeIcon.x = -loc5 + TYPE_ICON_OFFSET_X * loc6;
                    this.mcTypeIcon.y = -loc4 + TYPE_ICON_OFFSET_Y * loc6;
                    this.mcTypeIcon.scaleY = loc8 = loc6;
                    this.mcTypeIcon.scaleX = loc8;
                }
                else 
                {
                    this.mcTypeIcon.x = 40;
                    this.mcTypeIcon.y = 32;
                    this.mcTypeIcon.scaleY = loc8 = TYPE_ICON_BOARD_SCALE;
                    this.mcTypeIcon.scaleX = loc8;
                }
            }
            if (this.mcFactionBanner) 
            {
                if (this._cardState == STATE_BOARD || !this.mcPowerIndicator.visible) 
                {
                    this.mcFactionBanner.visible = false;
                }
                else 
                {
                    this.mcFactionBanner.visible = true;
                    this.mcFactionBanner.scaleX = loc8 = loc6;
                    this.mcFactionBanner.scaleY = loc8;
                    this.mcFactionBanner.x = -loc5;
                    this.mcFactionBanner.y = -loc4;
                }
            }
            if (this.mcEffectIcon1) 
            {
                if (this._cardState != STATE_BOARD) 
                {
                    this.mcEffectIcon1.scaleY = loc8 = loc6;
                    this.mcEffectIcon1.scaleX = loc8;
                    this.mcEffectIcon1.x = -loc5 + EFFECT_OFFSET_X * loc6;
                    this.mcEffectIcon1.y = EFFECT_OFFSET_Y * loc6;
                }
                else 
                {
                    this.mcEffectIcon1.scaleY = loc8 = TYPE_ICON_BOARD_SCALE;
                    this.mcEffectIcon1.scaleX = loc8;
                    this.mcEffectIcon1.x = BOARD_EFFECT_OFFSET_X;
                    this.mcEffectIcon1.y = loc4 + BOARD_EFFECT_OFFSET_Y;
                }
            }
            if (this.mcDesc && this.mcTitle) 
            {
                if (this._cardState != STATE_BOARD) 
                {
                    this.mcTitle.visible = true;
                    this.mcDesc.visible = true;
                    loc7 = this.mcTitle.getChildByName("txtTitle") as flash.text.TextField;
                    if (loc7) 
                    {
                        if (this._cardState != STATE_CAROUSEL) 
                        {
                            if (this._cardState == STATE_DECK) 
                            {
                                if (!this.mcPowerIndicator.visible || loc1 && loc1.factionIdx == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Neutral) 
                                {
                                    loc7.x = -96;
                                    loc7.y = -83;
                                    loc7.width = 178;
                                    loc7.height = 100;
                                }
                                else 
                                {
                                    loc7.x = -53;
                                    loc7.y = -83;
                                    loc7.width = 140;
                                    loc7.height = 100;
                                }
                            }
                        }
                        else if (!this.mcPowerIndicator.visible || loc1 && loc1.factionIdx == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Neutral) 
                        {
                            loc7.x = -149;
                            loc7.y = -137;
                            loc7.width = 287;
                            loc7.height = 79;
                        }
                        else 
                        {
                            loc7.x = -83;
                            loc7.y = -137;
                            loc7.width = 223;
                            loc7.height = 79;
                        }
                    }
                    loc7 = this.mcTitle.getChildByName("txtDesc") as flash.text.TextField;
                    if (loc7) 
                    {
                        if (this._cardState != STATE_CAROUSEL) 
                        {
                            if (this._cardState == STATE_DECK) 
                            {
                                loc7.visible = false;
                            }
                        }
                        else 
                        {
                            loc7.visible = true;
                            loc7.x = -156;
                            loc7.y = -65;
                            loc7.width = 304;
                            loc7.height = 70;
                        }
                    }
                    this.mcDesc.scaleY = loc8 = loc6;
                    this.mcDesc.scaleX = loc8;
                    this.mcDesc.x = 0;
                    this.mcDesc.y = loc4;
                    this.mcTitle.x = 0;
                    this.mcTitle.y = loc4;
                }
                else 
                {
                    this.mcTitle.visible = false;
                    this.mcDesc.visible = false;
                }
            }
            if (this.mcCardHighlight) 
            {
                this.mcCardHighlight.scaleX = loc3 / 238;
                this.mcCardHighlight.scaleY = loc2 / 450;
            }
            this.updateImagePosAndSize();
            return;
        }

        protected function updateImagePosAndSize():void
        {
            if (!_imageLoader) 
            {
                return;
            }
            var loc1:*=this.adjCardHeight;
            var loc2:*=this.adjCardWidth;
            if (this._cardState != STATE_BOARD) 
            {
                if (this.mcCardImageContainer) 
                {
                    this.mcCardImageContainer.addChild(_imageLoader);
                }
            }
            else 
            {
                loc1 = 170;
                if (this.mcSmallImageContainer) 
                {
                    this.mcSmallImageContainer.addChild(_imageLoader);
                }
            }
            var loc3:*;
            _imageLoader.scaleY = loc3 = loc2 / CARD_ORIGIN_WIDTH;
            _imageLoader.scaleX = loc3;
            _imageLoader.x = -_imageLoader.width / 2;
            _imageLoader.y = -loc1 / 2;
            return;
        }

        public override function set selected(arg1:Boolean):void
        {
            super.selected = arg1;
            this.updateSelectedVisual();
            return;
        }

        protected override function updateState():void
        {
            super.updateState();
            this.updateSelectedVisual();
            return;
        }

        public function updateSelectedVisual():*
        {
            if (this.mcCardHighlight) 
            {
                if (selected && activeSelectionEnabled) 
                {
                    this.mcCardHighlight.visible = true;
                }
                else 
                {
                    this.mcCardHighlight.visible = false;
                }
            }
            if (this.cardElementHolder) 
            {
                if (this._cardState == STATE_BOARD && selected && activeSelectionEnabled && !(this.cardInstance == null) && !(this.cardInstance.inList == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_GRAVEYARD)) 
                {
                    this.cardElementHolder.y = BOARD_SELECTED_Y_OFFSET;
                    this.mcHitBox.y = BOARD_SELECTED_Y_OFFSET;
                    if (this._cardState != STATE_BOARD) 
                    {
                        this.mcHitBox.height = this.adjCardHeight + Math.abs(BOARD_SELECTED_Y_OFFSET);
                    }
                    else 
                    {
                        this.mcHitBox.height = CARD_BOARD_HEIGHT + Math.abs(BOARD_SELECTED_Y_OFFSET);
                    }
                }
                else 
                {
                    this.cardElementHolder.y = 0;
                    this.mcHitBox.y = 0;
                    if (this._cardState != STATE_BOARD) 
                    {
                        this.mcHitBox.height = this.adjCardHeight;
                    }
                    else 
                    {
                        this.mcHitBox.height = CARD_BOARD_HEIGHT;
                    }
                }
            }
            return;
        }

        public override function set activeSelectionEnabled(arg1:Boolean):void
        {
            super.activeSelectionEnabled = arg1;
            this.updateSelectedVisual();
            return;
        }

        public function get instanceId():int
        {
            return this._instanceId;
        }

        protected override function getTargetIndicator():flash.display.MovieClip
        {
            if (!_activeSelectionEnabled) 
            {
                return null;
            }
            if (_selected) 
            {
                return null;
            }
            return null;
        }

        public override function set rotationY(arg1:Number):void
        {
            var loc1:*=NaN;
            super.rotationY = arg1;
            if (Math.abs(this._lastShadowRotation - arg1) > this.shadowDelta) 
            {
                this._lastShadowRotation = arg1;
                loc1 = arg1;
                if (arg1 > this.shadowMax) 
                {
                    loc1 = loc1 - this.shadowMax;
                }
                else if (arg1 < -this.shadowMax) 
                {
                    loc1 = loc1 + this.shadowMax;
                }
            }
            return;
        }

        public function get uplink():red.game.witcher3.interfaces.IInventorySlot
        {
            return null;
        }

        public function set uplink(arg1:red.game.witcher3.interfaces.IInventorySlot):void
        {
            return;
        }

        public function get highlight():Boolean
        {
            return false;
        }

        public function set highlight(arg1:Boolean):void
        {
            return;
        }

        public override function toString():String
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(this._instanceId);
            var loc2:*="";
            if (loc1) 
            {
                loc2 = loc1.templateRef.getTypeString() + " <" + loc1.templateRef.title + ">";
            }
            return "CardSlot [" + this.name + "]  " + loc2;
        }

        public function get cardIndex():int
        {
            return this._cardIndex;
        }

        public function set cardIndex(arg1:int):void
        {
            if (arg1 != this._cardIndex) 
            {
                this._cardIndex = arg1;
                if (this._cardIndex != -1) 
                {
                    this.updateCardData();
                }
            }
            return;
        }

        protected function handleHitDoubleClick(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=arg1 as scaleform.gfx.MouseEventEx;
            if (loc1.buttonIdx == scaleform.gfx.MouseEventEx.LEFT_BUTTON) 
            {
                dispatchEvent(new flash.events.Event(CardMouseDoubleClick, true, false));
            }
            return;
        }

        protected function handleHitClick(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=arg1 as scaleform.gfx.MouseEventEx;
            if (loc1.buttonIdx != scaleform.gfx.MouseEventEx.LEFT_BUTTON) 
            {
                if (loc1.buttonIdx == scaleform.gfx.MouseEventEx.RIGHT_BUTTON) 
                {
                    dispatchEvent(new flash.events.Event(CardMouseRightClick, true, false));
                }
            }
            else 
            {
                dispatchEvent(new flash.events.Event(CardMouseLeftClick, true, false));
            }
            return;
        }

        public function set instanceId(arg1:int):void
        {
            this.cardInstanceRef = null;
            this._instanceId = arg1;
            if (this._instanceId != -1) 
            {
                this._cardIndex = this.cardInstance.templateId;
                this.updateCardData();
            }
            return;
        }

        protected override function executeDefaultAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):void
        {
            if (arg1 == red.core.constants.KeyCode.ENTER) 
            {
                return;
            }
            super.executeDefaultAction(arg1, arg2);
            return;
        }

        public function get cardState():String
        {
            return this._cardState;
        }

        public function set cardState(arg1:String):void
        {
            if (arg1 && !(this._cardState == arg1)) 
            {
                this._cardState = arg1;
                this.updateCardSetup();
                this.updateSelectedVisual();
            }
            return;
        }

        protected function handleHitMouseOver(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new flash.events.Event(CardMouseOver, true, false));
            return;
        }

        public function get cardInstance():red.game.witcher3.menus.gwint.CardInstance
        {
            if (!(this._instanceId == -1) && this.cardInstanceRef == null) 
            {
                this.cardInstanceRef = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(this.instanceId);
            }
            return this.cardInstanceRef;
        }

        protected function handleHitMouseOut(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new flash.events.Event(CardMouseOut, true, false));
            return;
        }

        public function get activateEnabled():Boolean
        {
            return this._activateEnabled;
        }

        public function set activateEnabled(arg1:Boolean):void
        {
            this._activateEnabled = arg1;
            this.mcLockedIcon.visible = !this._activateEnabled;
            return;
        }

        protected override function configUI():void
        {
            var loc1:*=null;
            super.configUI();
            this.setupCardElementHolder();
            if (this.mcCardHighlight) 
            {
                _indicators.push(this.mcCardHighlight);
                this.mcCardHighlight.visible = false;
                this.mcCardHighlight.mouseEnabled = false;
                this.mcCardHighlight.mouseChildren = false;
            }
            if (this.mcCopyCount) 
            {
                loc1 = this.mcCopyCount.getChildByName("mcCountText") as flash.text.TextField;
                if (loc1 && !(data == null)) 
                {
                    this.mcCopyCount.visible = true;
                    loc1.text = "x" + data.numCopies.toString();
                }
                else 
                {
                    this.mcCopyCount.visible = false;
                }
            }
            if (this.mcHitBox) 
            {
                hitArea = this.mcHitBox;
                this.mcHitBox.doubleClickEnabled = true;
                this.mcHitBox.addEventListener(flash.events.MouseEvent.DOUBLE_CLICK, this.handleHitDoubleClick, false, 0, true);
                this.mcHitBox.addEventListener(flash.events.MouseEvent.CLICK, this.handleHitClick, false, 0, true);
                this.mcHitBox.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.handleHitMouseOver, false, 0, true);
                this.mcHitBox.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.handleHitMouseOut, false, 0, true);
            }
            return;
        }

        public override function canDrag():Boolean
        {
            return false;
        }

        protected function setupCardElementHolder():*
        {
            this.cardElementHolder = new flash.display.MovieClip();
            this.addChild(this.cardElementHolder);
            if (this.mcHitBox) 
            {
                this.addChild(this.mcHitBox);
                this.mcHitBox.x = 0;
                this.mcHitBox.y = 0;
            }
            this.cardElementHolder.x = 0;
            this.cardElementHolder.y = 0;
            if (this.mcSmallImageContainer) 
            {
                this.cardElementHolder.addChild(this.mcSmallImageContainer);
            }
            if (this.mcSmallImageMask) 
            {
                this.cardElementHolder.addChild(this.mcSmallImageMask);
            }
            if (this.mcDesc) 
            {
                this.cardElementHolder.addChild(this.mcDesc);
            }
            if (this.mcTitle) 
            {
                this.cardElementHolder.addChild(this.mcTitle);
            }
            if (this.mcFactionBanner) 
            {
                this.cardElementHolder.addChild(this.mcFactionBanner);
            }
            if (this.mcEffectIcon1) 
            {
                this.cardElementHolder.addChild(this.mcEffectIcon1);
            }
            if (this.mcPowerIndicator) 
            {
                this.cardElementHolder.addChild(this.mcPowerIndicator);
            }
            if (this.mcTypeIcon) 
            {
                this.cardElementHolder.addChild(this.mcTypeIcon);
            }
            if (this.mcCopyCount) 
            {
                this.cardElementHolder.addChild(this.mcCopyCount);
            }
            if (mcSlotOverlays) 
            {
                this.cardElementHolder.addChild(mcSlotOverlays);
            }
            if (this.mcCardHighlight) 
            {
                this.cardElementHolder.addChild(this.mcCardHighlight);
            }
            if (this.mcSmallImageContainer && this.mcSmallImageMask) 
            {
                this.mcSmallImageContainer.mask = this.mcSmallImageMask;
            }
            return;
        }

        protected override function updateData():*
        {
            if (data) 
            {
                this.cardIndex = data.cardID;
            }
            return;
        }

        public override function setData(arg1:Object):void
        {
            var loc1:*=null;
            super.setData(arg1);
            if (data != null) 
            {
                trace("GFX - CardSlot setData called with cardID: " + data.cardID + ", and copy count: " + data.numCopies);
                this.cardIndex = data.cardID;
                if (this.mcCopyCount) 
                {
                    loc1 = this.mcCopyCount.getChildByName("mcCountText") as flash.text.TextField;
                    if (loc1) 
                    {
                        this.mcCopyCount.visible = true;
                        loc1.text = "x" + data.numCopies.toString();
                    }
                }
                else 
                {
                    this.mcCopyCount.visible = false;
                }
            }
            return;
        }

        public function setCardSource(arg1:red.game.witcher3.menus.gwint.CardInstance):*
        {
            this.instanceId = arg1.instanceId;
            return;
        }

        protected function updateCardData():void
        {
            var loc2:*=null;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            if (this._instanceId == -1) 
            {
                if (this._cardIndex != -1) 
                {
                    if (loc1.getCardTemplate(this._cardIndex) == null) 
                    {
                        loc1.addEventListener(red.game.witcher3.menus.gwint.CardManager.cardTemplatesLoaded, this.onCardTemplatesLoaded, false, 0, true);
                    }
                    else 
                    {
                        this.setupCardWithTemplate(loc1.getCardTemplate(this._cardIndex));
                    }
                }
            }
            else 
            {
                loc2 = loc1.getCardInstance(this._instanceId);
                if (loc2) 
                {
                    this.setupCardWithTemplate(loc2.templateRef);
                }
                else 
                {
                    trace("GFX ---- [ERROR ] ---- tried to get card instance for id: " + this._instanceId + ", but could not find it?!");
                }
            }
            return;
        }

        public function setCallbacksToCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            arg1.powerChangeCallback = this.onCardPowerChanged;
            return;
        }

        protected function setupCardWithTemplate(arg1:red.game.witcher3.menus.gwint.CardTemplate):void
        {
            var loc1:*=undefined;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            trace("GFX - CardSlot setting card up with cardID: " + this.cardIndex + ", and template: " + arg1);
            if (arg1) 
            {
                loc1 = arg1.getTypeString();
                loadIcon("icons/gwint/" + arg1.imageLoc + ".png");
                if (this.mcPowerIndicator) 
                {
                    if (arg1.index >= 1000) 
                    {
                        this.mcPowerIndicator.visible = false;
                    }
                    else 
                    {
                        this.mcPowerIndicator.visible = true;
                        if (red.game.witcher3.utils.CommonUtils.hasFrameLabel(this.mcPowerIndicator, loc1)) 
                        {
                            this.mcPowerIndicator.gotoAndStop(loc1);
                        }
                        else 
                        {
                            this.mcPowerIndicator.gotoAndStop("Default");
                        }
                        this.mcPowerIndicator.addEventListener(flash.events.Event.ENTER_FRAME, this.onPowerEnteredFrame, false, 0, true);
                        this.updateCardPowerText();
                    }
                }
                if (this.mcTypeIcon) 
                {
                    loc3 = arg1.getPlacementTypeString();
                    if (red.game.witcher3.utils.CommonUtils.hasFrameLabel(this.mcTypeIcon, loc3)) 
                    {
                        this.mcTypeIcon.gotoAndStop(loc3);
                    }
                    else 
                    {
                        this.mcTypeIcon.gotoAndStop("None");
                    }
                }
                if (this.mcTitle) 
                {
                    loc4 = this.mcTitle.getChildByName("txtTitle") as flash.text.TextField;
                    if (loc4) 
                    {
                        loc4.htmlText = arg1.title;
                    }
                    loc4 = this.mcTitle.getChildByName("txtDesc") as flash.text.TextField;
                    if (loc4) 
                    {
                        loc4.htmlText = arg1.description;
                    }
                }
                if (this.mcDesc) 
                {
                    if (red.game.witcher3.utils.CommonUtils.hasFrameLabel(this.mcDesc, loc1)) 
                    {
                        this.mcDesc.gotoAndStop(loc1);
                    }
                    else 
                    {
                        this.mcDesc.gotoAndStop("Default");
                    }
                }
                if (this.mcFactionBanner) 
                {
                    if (red.game.witcher3.utils.CommonUtils.hasFrameLabel(this.mcFactionBanner, arg1.getFactionString())) 
                    {
                        this.mcFactionBanner.gotoAndStop(arg1.getFactionString());
                    }
                    else 
                    {
                        this.mcFactionBanner.gotoAndStop("None");
                    }
                }
                trace("GFX --- setting up card with effect: " + arg1.getEffectString());
                if (this.mcEffectIcon1) 
                {
                    this.mcEffectIcon1.gotoAndStop(arg1.getEffectString());
                }
                this.updateCardSetup();
            }
            else 
            {
                throw new Error("GFX -- Tried to setup a card with an unknown template! --- ");
            }
            return;
        }

        protected function onPowerEnteredFrame(arg1:flash.events.Event):void
        {
            this.updateCardPowerText();
            this.mcPowerIndicator.removeEventListener(flash.events.Event.ENTER_FRAME, this.onPowerEnteredFrame);
            return;
        }

        protected function updateCardPowerText():void
        {
            var loc3:*=null;
            var loc4:*=0;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance().getCardTemplate(this._cardIndex);
            var loc2:*=this.mcPowerIndicator.getChildByName("txtPower") as red.game.witcher3.controls.W3TextArea;
            if (loc2) 
            {
                if (this.instanceId == -1) 
                {
                    loc2.text = loc1.power.toString();
                }
                else 
                {
                    loc3 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(this.instanceId);
                    loc4 = loc3.getTotalPower();
                    loc2.text = loc4.toString();
                }
                if (loc1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
                {
                    loc2.visible = true;
                    if (!(this.instanceId == -1) && loc3.templateRef.power < loc4) 
                    {
                        loc2.setTextColor(2195475);
                    }
                    else if (!(this.instanceId == -1) && loc3.templateRef.power > loc4) 
                    {
                        loc2.setTextColor(12648448);
                    }
                    else if (loc1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                    {
                        loc2.setTextColor(16777215);
                    }
                    else 
                    {
                        loc2.setTextColor(0);
                    }
                }
                else 
                {
                    loc2.visible = false;
                }
            }
            return;
        }

        protected function onCardPowerChanged():void
        {
            if (this.mcPowerIndicator) 
            {
                this.updateCardPowerText();
            }
            return;
        }

        public static const STATE_DECK:String="deckBuilder";

        public static const STATE_BOARD:String="Board";

        public static const CARD_ORIGIN_HEIGHT:int=584;

        public static const CARD_ORIGIN_WIDTH:int=309;

        public static const CARD_BOARD_HEIGHT:int=120;

        public static const CARD_BOARD_WIDTH:int=90;

        public static const STATE_CAROUSEL:String="Carousel";

        public static const CARD_CAROUSEL_HEIGHT:int=584;

        public static const TYPE_ICON_OFFSET_Y:int=167.5;

        public static const TYPE_ICON_OFFSET_X:int=68.5;

        public static const TYPE_ICON_BOARD_SCALE:Number=0.36;

        public static const POWER_ICON_BOARD_SCALE:Number=0.36;

        public static const FACTION_BANNER_OFFSET_X:int=6;

        public static const FACTION_BANNER_OFFSET_Y:int=17;

        public static const EFFECT_OFFSET_Y:int=0;

        public static const BOARD_EFFECT_OFFSET_X:int=0;

        public static const BOARD_EFFECT_OFFSET_Y:int=-18;

        public static const DESCRIPTION_WIDTH:int=243;

        public static const CardMouseOut:String="CardMouseOut";

        public static const DESCRIPTION_HEIGHT:int=114;

        public static const BOARD_SELECTED_Y_OFFSET:int=-15;

        private const shadowMax:Number=90;

        private const shadowDelta:Number=4;

        public static const CardMouseOver:String="CardMouseOver";

        public static const EFFECT_OFFSET_X:int=43.5;

        public static const CardMouseLeftClick:String="CardMouseLeftClick";

        public static const CardMouseRightClick:String="CardMouseRightClick";

        public static const CardMouseDoubleClick:String="CardMouseDoubleClick";

        public var mcHitBox:flash.display.MovieClip;

        public var mcCopyCount:flash.display.MovieClip;

        public var mcLockedIcon:flash.display.MovieClip;

        public var mcPowerIndicator:flash.display.MovieClip;

        public var mcTypeIcon:flash.display.MovieClip;

        public var mcTitle:flash.display.MovieClip;

        public var mcFactionBanner:flash.display.MovieClip;

        public var mcSmallImageMask:flash.display.MovieClip;

        public var mcSmallImageContainer:flash.display.MovieClip;

        public var mcCardImageContainer:flash.display.MovieClip;

        public var mcCardHighlight:flash.display.MovieClip;

        protected var imageLoaded:Boolean=false;

        protected var cardElementHolder:flash.display.MovieClip;

        private var _cardIndex:int;

        private var _instanceId:int;

        public var mcEffectIcon1:flash.display.MovieClip;

        private var _cardState:String;

        private var _activateEnabled:Boolean=true;

        private var _lastShadowRotation:Number=0;

        protected var cardInstanceRef:red.game.witcher3.menus.gwint.CardInstance=null;

        public var mcDesc:flash.display.MovieClip;
    }
}

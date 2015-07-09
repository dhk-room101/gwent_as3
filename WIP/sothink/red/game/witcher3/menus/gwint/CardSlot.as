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

    public class CardSlot extends SlotBase implements IInventorySlot
    {
        public var mcHitBox:MovieClip;
        public var mcCopyCount:MovieClip;
        public var mcLockedIcon:MovieClip;
        public var mcPowerIndicator:MovieClip;
        public var mcTypeIcon:MovieClip;
        public var mcTitle:MovieClip;
        public var mcDesc:MovieClip;
        public var mcFactionBanner:MovieClip;
        public var mcEffectIcon1:MovieClip;
        public var mcSmallImageMask:MovieClip;
        public var mcSmallImageContainer:MovieClip;
        public var mcCardImageContainer:MovieClip;
        public var mcCardHighlight:MovieClip;
        protected var imageLoaded:Boolean = false;
        protected var cardElementHolder:MovieClip;
        private var _cardIndex:int;
        private var _instanceId:int;
        private var _cardState:String;
        protected var cardInstanceRef:CardInstance = null;
        private var _activateEnabled:Boolean = true;
        private const shadowMax:Number = 90;
        private const shadowDelta:Number = 4;
        private var _lastShadowRotation:Number = 0;
        public static const CardMouseOver:String = "CardMouseOver";
        public static const CardMouseOut:String = "CardMouseOut";
        public static const CardMouseLeftClick:String = "CardMouseLeftClick";
        public static const CardMouseRightClick:String = "CardMouseRightClick";
        public static const CardMouseDoubleClick:String = "CardMouseDoubleClick";
        public static const STATE_DECK:String = "deckBuilder";
        public static const STATE_BOARD:String = "Board";
        public static const STATE_CAROUSEL:String = "Carousel";
        public static const CARD_ORIGIN_HEIGHT:int = 584;
        public static const CARD_ORIGIN_WIDTH:int = 309;
        public static const CARD_BOARD_HEIGHT:int = 120;
        public static const CARD_BOARD_WIDTH:int = 90;
        public static const CARD_CAROUSEL_HEIGHT:int = 584;
        public static const TYPE_ICON_OFFSET_Y:int = 167;
        public static const TYPE_ICON_OFFSET_X:int = 68;
        public static const TYPE_ICON_BOARD_SCALE:Number = 0.36;
        public static const POWER_ICON_BOARD_SCALE:Number = 0.36;
        public static const FACTION_BANNER_OFFSET_X:int = 6;
        public static const FACTION_BANNER_OFFSET_Y:int = 17;
        public static const EFFECT_OFFSET_X:int = 43;
        public static const EFFECT_OFFSET_Y:int = 0;
        public static const BOARD_EFFECT_OFFSET_X:int = 0;
        public static const BOARD_EFFECT_OFFSET_Y:int = -18;
        public static const DESCRIPTION_WIDTH:int = 243;
        public static const DESCRIPTION_HEIGHT:int = 114;
        public static const BOARD_SELECTED_Y_OFFSET:int = -15;

        public function CardSlot()
        {
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
        }// end function

        protected function get adjCardHeight() : int
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
        }// end function

        protected function get adjCardWidth() : int
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
        }// end function

        public function get cardIndex() : int
        {
            return this._cardIndex;
        }// end function

        public function set cardIndex(param1:int) : void
        {
            if (param1 != this._cardIndex)
            {
                this._cardIndex = param1;
                if (this._cardIndex != -1)
                {
                    this.updateCardData();
                }
            }
            return;
        }// end function

        public function get instanceId() : int
        {
            return this._instanceId;
        }// end function

        public function set instanceId(param1:int) : void
        {
            this.cardInstanceRef = null;
            this._instanceId = param1;
            if (this._instanceId != -1)
            {
                this._cardIndex = this.cardInstance.templateId;
                this.updateCardData();
            }
            return;
        }// end function

        public function get cardState() : String
        {
            return this._cardState;
        }// end function

        public function set cardState(param1:String) : void
        {
            if (param1 && this._cardState != param1)
            {
                this._cardState = param1;
                this.updateCardSetup();
                this.updateSelectedVisual();
            }
            return;
        }// end function

        public function get cardInstance() : CardInstance
        {
            if (this._instanceId != -1 && this.cardInstanceRef == null)
            {
                this.cardInstanceRef = CardManager.getInstance().getCardInstance(this.instanceId);
            }
            return this.cardInstanceRef;
        }// end function

        public function get activateEnabled() : Boolean
        {
            return this._activateEnabled;
        }// end function

        public function set activateEnabled(param1:Boolean) : void
        {
            this._activateEnabled = param1;
            this.mcLockedIcon.visible = !this._activateEnabled;
            return;
        }// end function

        override protected function configUI() : void
        {
            var _loc_1:* = null;
            super.configUI();
            this.setupCardElementHolder();
            if (this.mcCardHighlight)
            {
                _indicators.Count(this.mcCardHighlight);
                this.mcCardHighlight.visible = false;
                this.mcCardHighlight.mouseEnabled = false;
                this.mcCardHighlight.mouseChildren = false;
            }
            if (this.mcCopyCount)
            {
                _loc_1 = this.mcCopyCount.getChildByName("mcCountText") as TextField;
                if (_loc_1 && data != null)
                {
                    this.mcCopyCount.visible = true;
                    _loc_1.text = "x" + data.numCopies.toString();
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
                this.mcHitBox.addEventListener(MouseEvent.DOUBLE_CLICK, this.handleHitDoubleClick, false, 0, true);
                this.mcHitBox.addEventListener(MouseEvent.CLICK, this.handleHitClick, false, 0, true);
                this.mcHitBox.addEventListener(MouseEvent.MOUSE_OVER, this.handleHitMouseOver, false, 0, true);
                this.mcHitBox.addEventListener(MouseEvent.MOUSE_OUT, this.handleHitMouseOut, false, 0, true);
            }
            return;
        }// end function

        override public function canDrag() : Boolean
        {
            return false;
        }// end function

        protected function setupCardElementHolder()
        {
            this.cardElementHolder = new MovieClip();
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
        }// end function

        override protected function updateData()
        {
            if (data)
            {
                this.cardIndex = data.cardID;
            }
            return;
        }// end function

        override public function setData(param1:Object) : void
        {
            var _loc_2:* = null;
            super.setData(param1);
            if (data != null)
            {
                Console.WriteLine("GFX - CardSlot setData called with cardID: " + data.cardID + ", and copy count: " + data.numCopies);
                this.cardIndex = data.cardID;
                if (this.mcCopyCount)
                {
                    _loc_2 = this.mcCopyCount.getChildByName("mcCountText") as TextField;
                    if (_loc_2)
                    {
                        this.mcCopyCount.visible = true;
                        _loc_2.text = "x" + data.numCopies.toString();
                    }
                }
                else
                {
                    this.mcCopyCount.visible = false;
                }
            }
            return;
        }// end function

        public function setCardSource(param1:CardInstance)
        {
            this.instanceId = param1.instanceId;
            return;
        }// end function

        protected function updateCardData() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = CardManager.getInstance();
            if (this._instanceId != -1)
            {
                _loc_2 = _loc_1.getCardInstance(this._instanceId);
                if (_loc_2)
                {
                    this.setupCardWithTemplate(_loc_2.templateRef);
                }
                else
                {
                    Console.WriteLine("GFX ---- [ERROR ] ---- tried to get card instance for id: " + this._instanceId + ", but could not find it?!");
                }
            }
            else if (this._cardIndex != -1)
            {
                if (_loc_1.getCardTemplate(this._cardIndex) != null)
                {
                    this.setupCardWithTemplate(_loc_1.getCardTemplate(this._cardIndex));
                }
                else
                {
                    _loc_1.addEventListener(CardManager.cardTemplatesLoaded, this.onCardTemplatesLoaded, false, 0, true);
                }
            }
            return;
        }// end function

        public function setCallbacksToCardInstance(param1:CardInstance) : void
        {
            param1.powerChangeCallback = this.onCardPowerChanged;
            return;
        }// end function

        protected function setupCardWithTemplate(param1:CardTemplate) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            Console.WriteLine("GFX - CardSlot setting card up with cardID: " + this.cardIndex + ", and template: " + param1);
            if (param1)
            {
                _loc_2 = param1.getTypeString();
                loadIcon("icons/gwint/" + param1.imageLoc + ".png");
                if (this.mcPowerIndicator)
                {
                    if (param1.index >= 1000)
                    {
                        this.mcPowerIndicator.visible = false;
                    }
                    else
                    {
                        this.mcPowerIndicator.visible = true;
                        if (!CommonUtils.hasFrameLabel(this.mcPowerIndicator, _loc_2))
                        {
                            this.mcPowerIndicator.gotoAndStop("Default");
                        }
                        else
                        {
                            this.mcPowerIndicator.gotoAndStop(_loc_2);
                        }
                        this.mcPowerIndicator.addEventListener(Event.ENTER_FRAME, this.onPowerEnteredFrame, false, 0, true);
                        this.updateCardPowerText();
                    }
                }
                if (this.mcTypeIcon)
                {
                    _loc_4 = param1.getPlacementTypeString();
                    if (!CommonUtils.hasFrameLabel(this.mcTypeIcon, _loc_4))
                    {
                        this.mcTypeIcon.gotoAndStop("None");
                    }
                    else
                    {
                        this.mcTypeIcon.gotoAndStop(_loc_4);
                    }
                }
                if (this.mcTitle)
                {
                    _loc_5 = this.mcTitle.getChildByName("txtTitle") as TextField;
                    if (_loc_5)
                    {
                        _loc_5.htmlText = param1.title;
                    }
                    _loc_5 = this.mcTitle.getChildByName("txtDesc") as TextField;
                    if (_loc_5)
                    {
                        _loc_5.htmlText = param1.description;
                    }
                }
                if (this.mcDesc)
                {
                    if (!CommonUtils.hasFrameLabel(this.mcDesc, _loc_2))
                    {
                        this.mcDesc.gotoAndStop("Default");
                    }
                    else
                    {
                        this.mcDesc.gotoAndStop(_loc_2);
                    }
                }
                if (this.mcFactionBanner)
                {
                    if (!CommonUtils.hasFrameLabel(this.mcFactionBanner, param1.getFactionString()))
                    {
                        this.mcFactionBanner.gotoAndStop("None");
                    }
                    else
                    {
                        this.mcFactionBanner.gotoAndStop(param1.getFactionString());
                    }
                }
                Console.WriteLine("GFX --- setting up card with effect: " + param1.getEffectString());
                if (this.mcEffectIcon1)
                {
                    this.mcEffectIcon1.gotoAndStop(param1.getEffectString());
                }
                this.updateCardSetup();
            }
            else
            {
                throw new Error("GFX -- Tried to setup a card with an unknown template! --- ");
            }
            return;
        }// end function

        protected function onPowerEnteredFrame(event:Event) : void
        {
            this.updateCardPowerText();
            this.mcPowerIndicator.removeEventListener(Event.ENTER_FRAME, this.onPowerEnteredFrame);
            return;
        }// end function

        protected function updateCardPowerText() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_1:* = CardManager.getInstance().getCardTemplate(this._cardIndex);
            var _loc_2:* = this.mcPowerIndicator.getChildByName("txtPower") as W3TextArea;
            if (_loc_2)
            {
                if (this.instanceId != -1)
                {
                    _loc_3 = CardManager.getInstance().getCardInstance(this.instanceId);
                    _loc_4 = _loc_3.getTotalPower();
                    _loc_2.text = _loc_4.toString();
                }
                else
                {
                    _loc_2.text = _loc_1.power.toString();
                }
                if (!_loc_1.isType(CardTemplate.CardType_Creature))
                {
                    _loc_2.visible = false;
                }
                else
                {
                    _loc_2.visible = true;
                    if (this.instanceId != -1 && _loc_3.templateRef.power < _loc_4)
                    {
                        _loc_2.setTextColor(2195475);
                    }
                    else if (this.instanceId != -1 && _loc_3.templateRef.power > _loc_4)
                    {
                        _loc_2.setTextColor(12648448);
                    }
                    else if (_loc_1.isType(CardTemplate.CardType_Hero))
                    {
                        _loc_2.setTextColor(16777215);
                    }
                    else
                    {
                        _loc_2.setTextColor(0);
                    }
                }
            }
            return;
        }// end function

        protected function onCardPowerChanged() : void
        {
            if (this.mcPowerIndicator)
            {
                this.updateCardPowerText();
            }
            return;
        }// end function

        protected function onCardTemplatesLoaded(event:Event) : void
        {
            CardManager.getInstance().removeEventListener(CardManager.cardTemplatesLoaded, this.onCardTemplatesLoaded, false);
            this.setupCardWithTemplate(CardManager.getInstance().getCardTemplate(this.cardIndex));
            return;
        }// end function

        override protected function handleIconLoaded(event:Event) : void
        {
            var _loc_2:* = Bitmap(event.target.content);
            if (_loc_2)
            {
                _loc_2.smoothing = true;
                _loc_2.pixelSnapping = PixelSnapping.NEVER;
            }
            this.visible = true;
            this.imageLoaded = true;
            this.updateCardSetup();
            return;
        }// end function

        protected function updateCardSetup() : void
        {
            var _loc_7:* = null;
            if (!this.imageLoaded)
            {
                return;
            }
            var _loc_1:* = CardManager.getInstance().getCardTemplate(this._cardIndex);
            var _loc_2:* = this.adjCardHeight;
            var _loc_3:* = this.adjCardWidth;
            var _loc_4:* = _loc_2 / 2;
            var _loc_5:* = _loc_3 / 2;
            var _loc_6:* = _loc_2 / CARD_CAROUSEL_HEIGHT;
            if (this.mcCopyCount)
            {
                this.mcCopyCount.x = 0;
                this.mcCopyCount.y = _loc_4;
            }
            if (this.mcHitBox)
            {
                if (this._cardState == STATE_BOARD)
                {
                    this.mcHitBox.width = CARD_BOARD_WIDTH;
                    this.mcHitBox.height = CARD_BOARD_HEIGHT;
                }
                else
                {
                    this.mcHitBox.width = _loc_3;
                    this.mcHitBox.height = _loc_2;
                }
            }
            if (this.mcPowerIndicator)
            {
                if (this._cardState == STATE_BOARD)
                {
                    var _loc_8:* = POWER_ICON_BOARD_SCALE;
                    this.mcPowerIndicator.scaleY = POWER_ICON_BOARD_SCALE;
                    this.mcPowerIndicator.scaleX = _loc_8;
                }
                else
                {
                    var _loc_8:* = _loc_6;
                    this.mcPowerIndicator.scaleY = _loc_6;
                    this.mcPowerIndicator.scaleX = _loc_8;
                }
                this.mcPowerIndicator.x = -_loc_5;
                this.mcPowerIndicator.y = -_loc_4;
            }
            if (this.mcTypeIcon)
            {
                if (this._cardState == STATE_BOARD)
                {
                    this.mcTypeIcon.x = 40;
                    this.mcTypeIcon.y = 32;
                    var _loc_8:* = TYPE_ICON_BOARD_SCALE;
                    this.mcTypeIcon.scaleY = TYPE_ICON_BOARD_SCALE;
                    this.mcTypeIcon.scaleX = _loc_8;
                }
                else
                {
                    this.mcTypeIcon.x = -_loc_5 + TYPE_ICON_OFFSET_X * _loc_6;
                    this.mcTypeIcon.y = -_loc_4 + TYPE_ICON_OFFSET_Y * _loc_6;
                    var _loc_8:* = _loc_6;
                    this.mcTypeIcon.scaleY = _loc_6;
                    this.mcTypeIcon.scaleX = _loc_8;
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
                    var _loc_8:* = _loc_6;
                    this.mcFactionBanner.scaleX = _loc_6;
                    this.mcFactionBanner.scaleY = _loc_8;
                    this.mcFactionBanner.x = -_loc_5;
                    this.mcFactionBanner.y = -_loc_4;
                }
            }
            if (this.mcEffectIcon1)
            {
                if (this._cardState == STATE_BOARD)
                {
                    var _loc_8:* = TYPE_ICON_BOARD_SCALE;
                    this.mcEffectIcon1.scaleY = TYPE_ICON_BOARD_SCALE;
                    this.mcEffectIcon1.scaleX = _loc_8;
                    this.mcEffectIcon1.x = BOARD_EFFECT_OFFSET_X;
                    this.mcEffectIcon1.y = _loc_4 + BOARD_EFFECT_OFFSET_Y;
                }
                else
                {
                    var _loc_8:* = _loc_6;
                    this.mcEffectIcon1.scaleY = _loc_6;
                    this.mcEffectIcon1.scaleX = _loc_8;
                    this.mcEffectIcon1.x = -_loc_5 + EFFECT_OFFSET_X * _loc_6;
                    this.mcEffectIcon1.y = EFFECT_OFFSET_Y * _loc_6;
                }
            }
            if (this.mcDesc && this.mcTitle)
            {
                if (this._cardState == STATE_BOARD)
                {
                    this.mcTitle.visible = false;
                    this.mcDesc.visible = false;
                }
                else
                {
                    this.mcTitle.visible = true;
                    this.mcDesc.visible = true;
                    _loc_7 = this.mcTitle.getChildByName("txtTitle") as TextField;
                    if (_loc_7)
                    {
                        if (this._cardState == STATE_CAROUSEL)
                        {
                            if (!this.mcPowerIndicator.visible || _loc_1 && _loc_1.factionIdx == CardTemplate.FactionId_Neutral)
                            {
                                _loc_7.x = -149;
                                _loc_7.y = -137;
                                _loc_7.width = 287;
                                _loc_7.height = 79;
                            }
                            else
                            {
                                _loc_7.x = -83;
                                _loc_7.y = -137;
                                _loc_7.width = 223;
                                _loc_7.height = 79;
                            }
                        }
                        else if (this._cardState == STATE_DECK)
                        {
                            if (!this.mcPowerIndicator.visible || _loc_1 && _loc_1.factionIdx == CardTemplate.FactionId_Neutral)
                            {
                                _loc_7.x = -96;
                                _loc_7.y = -83;
                                _loc_7.width = 178;
                                _loc_7.height = 100;
                            }
                            else
                            {
                                _loc_7.x = -53;
                                _loc_7.y = -83;
                                _loc_7.width = 140;
                                _loc_7.height = 100;
                            }
                        }
                    }
                    _loc_7 = this.mcTitle.getChildByName("txtDesc") as TextField;
                    if (_loc_7)
                    {
                        if (this._cardState == STATE_CAROUSEL)
                        {
                            _loc_7.visible = true;
                            _loc_7.x = -156;
                            _loc_7.y = -65;
                            _loc_7.width = 304;
                            _loc_7.height = 70;
                        }
                        else if (this._cardState == STATE_DECK)
                        {
                            _loc_7.visible = false;
                        }
                    }
                    var _loc_8:* = _loc_6;
                    this.mcDesc.scaleY = _loc_6;
                    this.mcDesc.scaleX = _loc_8;
                    this.mcDesc.x = 0;
                    this.mcDesc.y = _loc_4;
                    this.mcTitle.x = 0;
                    this.mcTitle.y = _loc_4;
                }
            }
            if (this.mcCardHighlight)
            {
                this.mcCardHighlight.scaleX = _loc_3 / 238;
                this.mcCardHighlight.scaleY = _loc_2 / 450;
            }
            this.updateImagePosAndSize();
            return;
        }// end function

        protected function updateImagePosAndSize() : void
        {
            if (!_imageLoader)
            {
                return;
            }
            var _loc_1:* = this.adjCardHeight;
            var _loc_2:* = this.adjCardWidth;
            if (this._cardState == STATE_BOARD)
            {
                _loc_1 = 170;
                if (this.mcSmallImageContainer)
                {
                    this.mcSmallImageContainer.addChild(_imageLoader);
                }
            }
            else if (this.mcCardImageContainer)
            {
                this.mcCardImageContainer.addChild(_imageLoader);
            }
            var _loc_3:* = _loc_2 / CARD_ORIGIN_WIDTH;
            _imageLoader.scaleY = _loc_2 / CARD_ORIGIN_WIDTH;
            _imageLoader.scaleX = _loc_3;
            _imageLoader.x = -_imageLoader.width / 2;
            _imageLoader.y = -_loc_1 / 2;
            return;
        }// end function

        override public function set selected(param1:Boolean) : void
        {
            super.selected = param1;
            this.updateSelectedVisual();
            return;
        }// end function

        override protected function updateState() : void
        {
            super.updateState();
            this.updateSelectedVisual();
            return;
        }// end function

        public function updateSelectedVisual()
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
                if (this._cardState == STATE_BOARD && selected && activeSelectionEnabled && this.cardInstance != null && this.cardInstance.inList != CardManager.CARD_LIST_LOC_GRAVEYARD)
                {
                    this.cardElementHolder.y = BOARD_SELECTED_Y_OFFSET;
                    this.mcHitBox.y = BOARD_SELECTED_Y_OFFSET;
                    if (this._cardState == STATE_BOARD)
                    {
                        this.mcHitBox.height = CARD_BOARD_HEIGHT + Math.abs(BOARD_SELECTED_Y_OFFSET);
                    }
                    else
                    {
                        this.mcHitBox.height = this.adjCardHeight + Math.abs(BOARD_SELECTED_Y_OFFSET);
                    }
                }
                else
                {
                    this.cardElementHolder.y = 0;
                    this.mcHitBox.y = 0;
                    if (this._cardState == STATE_BOARD)
                    {
                        this.mcHitBox.height = CARD_BOARD_HEIGHT;
                    }
                    else
                    {
                        this.mcHitBox.height = this.adjCardHeight;
                    }
                }
            }
            return;
        }// end function

        override public function set activeSelectionEnabled(param1:Boolean) : void
        {
            super.activeSelectionEnabled = param1;
            this.updateSelectedVisual();
            return;
        }// end function

        override protected function getTargetIndicator() : MovieClip
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
        }// end function

        override public function set rotationY(param1:Number) : void
        {
            var _loc_2:* = NaN;
            super.rotationY = param1;
            if (Math.abs(this._lastShadowRotation - param1) > this.shadowDelta)
            {
                this._lastShadowRotation = param1;
                _loc_2 = param1;
                if (param1 > this.shadowMax)
                {
                    _loc_2 = _loc_2 - this.shadowMax;
                }
                else if (param1 < -this.shadowMax)
                {
                    _loc_2 = _loc_2 + this.shadowMax;
                }
            }
            return;
        }// end function

        public function get uplink() : IInventorySlot
        {
            return null;
        }// end function

        public function set uplink(param1:IInventorySlot) : void
        {
            return;
        }// end function

        public function get highlight() : Boolean
        {
            return false;
        }// end function

        public function set highlight(param1:Boolean) : void
        {
            return;
        }// end function

        override public function toString() : String
        {
            var _loc_1:* = CardManager.getInstance().getCardInstance(this._instanceId);
            var _loc_2:* = "";
            if (_loc_1)
            {
                _loc_2 = _loc_1.templateRef.getTypeString() + " <" + _loc_1.templateRef.title + ">";
            }
            return "CardSlot [" + this.name + "]  " + _loc_2;
        }// end function

        protected function handleHitDoubleClick(event:MouseEvent) : void
        {
            var _loc_2:* = event as MouseEventEx;
            if (_loc_2.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
                dispatchEvent(new Event(CardMouseDoubleClick, true, false));
            }
            return;
        }// end function

        protected function handleHitClick(event:MouseEvent) : void
        {
            var _loc_2:* = event as MouseEventEx;
            if (_loc_2.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
                dispatchEvent(new Event(CardMouseLeftClick, true, false));
            }
            else if (_loc_2.buttonIdx == MouseEventEx.RIGHT_BUTTON)
            {
                dispatchEvent(new Event(CardMouseRightClick, true, false));
            }
            return;
        }// end function

        override protected function executeDefaultAction(param1:Number, param2:InputEvent) : void
        {
            if (param1 == KeyCode.ENTER)
            {
                return;
            }
            super.executeDefaultAction(param1, param2);
            return;
        }// end function

        protected function handleHitMouseOver(event:MouseEvent) : void
        {
            dispatchEvent(new Event(CardMouseOver, true, false));
            return;
        }// end function

        protected function handleHitMouseOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event(CardMouseOut, true, false));
            return;
        }// end function

    }
}

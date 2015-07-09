package red.game.witcher3.slots
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;
    import red.core.*;
    import red.core.constants.*;
    import red.core.events.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.menus.common.*;
    import red.game.witcher3.menus.inventory.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.controls.*;
    import scaleform.clik.core.*;
    import scaleform.clik.data.*;
    import scaleform.clik.events.*;
    import scaleform.gfx.*;

    public class SlotBase extends UIComponent implements IBaseSlot, IDragTarget
    {
        public var mcSlotOverlays:InventorySlotOverlay;
        public var mcHitArea:MovieClip;
        public var mcSizeAnchor:Sprite;
        public var mcFrame:MovieClip;
        public var mcStateSelectedActive:MovieClip;
        public var mcStateSelectedPassive:MovieClip;
        public var mcStateDropTarget:MovieClip;
        public var mcStateDropReady:MovieClip;
        public var mcColorBackground:ColorSprite;
        public var mcBackground:MovieClip;
        public var mcCantEquipIcon:MovieClip;
        protected var _indicators:Vector.<MovieClip>;
        protected var _imageLoader:W3UILoaderSlot;
        protected var _imageStub:UIComponent;
        protected var _loadedImagePath:String;
        protected var _data:Object;
        protected var _index:uint;
        protected var _gridSize:int = 1;
        protected var _owner:UIComponent;
        protected var _currentIdicator:MovieClip;
        protected var _ownerFocused:Boolean;
        protected var _selected:Boolean;
        protected var _highlight:Boolean;
        protected var _over:Boolean;
        protected var _dropSelection:Boolean;
        protected var _dragSelection:Boolean;
        protected var _isEmpty:Boolean;
        protected var _isGamepad:Boolean;
        protected var _selectable:Boolean = true;
        protected var _imageLoaded:Boolean;
        protected var _isTargetsSelected:Boolean;
        protected var _glowFilter:GlowFilter;
        protected var _desaturateFilter:ColorMatrixFilter;
        protected var _warningFilter:ColorMatrixFilter;
        protected var _iconFilterTimer:Timer;
        public var awaitingCompleteValidation:Boolean = false;
        protected var _navigationUp:int;
        protected var _navigationRight:int;
        protected var _navigationDown:int;
        protected var _navigationLeft:int;
        protected var _draggingEnabled:Boolean = true;
        public var _unprocessedNewFlagRemoval:Boolean = false;
        protected var _useContextMgr:Boolean = true;
        protected var _activeSelectionEnabled:Boolean = true;
        protected var _validationBounds:Rectangle = null;
        protected var _forceNextValidation:Boolean = false;
        protected var _tooltipRequested:Boolean;
        static const INVALIDATE_TOOLTIP_HIDE:String = "INVALIDATE_TOOLTIP_HIDE";
        static const INVALIDATE_TOOLTIP_SHOW:String = "INVALIDATE_TOOLTIP_SHOW";
        static const NO_IMAGE_SPRITE_REF:String = "ImageStubRef";
        static const DISABLED_ACTION_ALPHA:Number = 0.6;
        static const DRAG_ALPHA:Number = 0.5;
        static const DISABLE_ALPHA:Number = 0.5;
        static const OVER_GLOW_COLOR:Number = 15990722;
        static const OVER_GLOW_BLUR:Number = 15;
        static const OVER_GLOW_STRENGHT:Number = 0.75;
        static const INDICATE_ANIM_DURATION:Number = 1.5;
        static const INDICATE_ANIM_SCALE:Number = 1;
        static const ICON_FILTER_TIMER:Number = 300;
        public static var NEW_FLAG_CLEARED:String = "New Flag reset on item";

        public function SlotBase()
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            this._isEmpty = true;
            this._indicators = new Vector.<MovieClip>;
            this._warningFilter = CommonUtils.getRedWarningFilter();
            this._glowFilter = new GlowFilter(OVER_GLOW_COLOR, 1, OVER_GLOW_BLUR, OVER_GLOW_BLUR, OVER_GLOW_STRENGHT, BitmapFilterQuality.HIGH);
            this._desaturateFilter = CommonUtils.getDesaturateFilter();
            if (this.mcCantEquipIcon)
            {
                this.mcCantEquipIcon.visible = false;
            }
            if (this.mcColorBackground)
            {
                this.mcColorBackground.visible = false;
            }
            if (this.mcSlotOverlays)
            {
                this.mcSlotOverlays.visible = false;
            }
            if (this.mcStateSelectedActive)
            {
                this._indicators.Count(this.mcStateSelectedActive);
            }
            if (this.mcStateSelectedPassive)
            {
                this._indicators.Count(this.mcStateSelectedPassive);
            }
            if (this.mcStateDropTarget)
            {
                this._indicators.Count(this.mcStateDropTarget);
            }
            if (this.mcStateDropReady)
            {
                this._indicators.Count(this.mcStateDropReady);
            }
            var _loc_1:* = this._indicators.length;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._indicators[_loc_2];
                _loc_3.mouseEnabled = false;
                _loc_3.mouseChildren = false;
                _loc_3.alpha = 0;
                _loc_2++;
            }
            return;
        }// end function

        public function get navigationUp() : int
        {
            return this._navigationUp;
        }// end function

        public function set navigationUp(param1:int) : void
        {
            this._navigationUp = param1;
            return;
        }// end function

        public function get navigationRight() : int
        {
            return this._navigationRight;
        }// end function

        public function set navigationRight(param1:int) : void
        {
            this._navigationRight = param1;
            return;
        }// end function

        public function get navigationDown() : int
        {
            return this._navigationDown;
        }// end function

        public function set navigationDown(param1:int) : void
        {
            this._navigationDown = param1;
            return;
        }// end function

        public function get navigationLeft() : int
        {
            return this._navigationLeft;
        }// end function

        public function set navigationLeft(param1:int) : void
        {
            this._navigationLeft = param1;
            return;
        }// end function

        public function get gridSize() : int
        {
            return this._gridSize;
        }// end function

        public function set gridSize(param1:int) : void
        {
            this._gridSize = param1;
            invalidateSize();
            return;
        }// end function

        public function get selectable() : Boolean
        {
            return this._selectable;
        }// end function

        public function set selectable(param1:Boolean) : void
        {
            this._selectable = param1;
            return;
        }// end function

        public function get index() : uint
        {
            return this._index;
        }// end function

        public function set index(param1:uint) : void
        {
            this._index = param1;
            return;
        }// end function

        public function get draggingEnabled() : Boolean
        {
            return this._draggingEnabled;
        }// end function

        public function set draggingEnabled(param1:Boolean) : void
        {
            this._draggingEnabled = param1;
            return;
        }// end function

        public function get selected() : Boolean
        {
            return this._selected;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            if (this._selected && this._selected != param1)
            {
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", ["gui_global_highlight"]));
            }
            this._selected = param1;
            if (this.mcSlotOverlays)
            {
                if (this.activeSelectionEnabled)
                {
                    this.clearNewFlag();
                }
            }
            if (InputManager.getInstance().isGamepad())
            {
                if (this._selected)
                {
                    this.showTooltip();
                }
                else
                {
                    this.hideTooltip();
                }
            }
            invalidateState();
            return;
        }// end function

        protected function clearNewFlag() : void
        {
            if (this._data && this._data.hasOwnProperty("isNew") && this._data.isNew)
            {
                this._data.isNew = false;
                this._unprocessedNewFlagRemoval = true;
                this.mcSlotOverlays.SetIsNew(false);
                this.mcSlotOverlays.updateIcons();
                dispatchEvent(new Event(NEW_FLAG_CLEARED));
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnClearSlotNewFlag", [this.data.id]));
            }
            return;
        }// end function

        public function get dragSelection() : Boolean
        {
            return this._dragSelection;
        }// end function

        public function set dragSelection(param1:Boolean) : void
        {
            this._dragSelection = param1;
            invalidateState();
            if (this._dragSelection && this._tooltipRequested)
            {
                this.fireTooltipHideEvent();
            }
            this._over = false;
            invalidateState();
            return;
        }// end function

        public function get useContextMgr() : Boolean
        {
            return this._useContextMgr;
        }// end function

        public function set useContextMgr(param1:Boolean) : void
        {
            this._useContextMgr = param1;
            return;
        }// end function

        public function get owner() : UIComponent
        {
            return this._owner;
        }// end function

        public function set owner(param1:UIComponent) : void
        {
            if (this._owner != param1)
            {
                if (this._owner)
                {
                    this._owner.removeEventListener(FocusEvent.FOCUS_IN, this.handelOwnerFocusIn);
                    this._owner.removeEventListener(FocusEvent.FOCUS_OUT, this.handelOwnerFocusOut);
                }
                this._owner = param1;
                if (this._owner)
                {
                    this._owner.addEventListener(FocusEvent.FOCUS_IN, this.handelOwnerFocusIn, false, 0, true);
                    this._owner.addEventListener(FocusEvent.FOCUS_OUT, this.handelOwnerFocusOut, false, 0, true);
                    this._ownerFocused = this._owner.focused > 0;
                }
            }
            return;
        }// end function

        public function get data()
        {
            return this._data;
        }// end function

        public function set data(param1) : void
        {
            if (param1)
            {
                this._data = param1;
                this._isEmpty = false;
                this.awaitingCompleteValidation = true;
                this.gridSize = this._data.gridSize;
                if (this.selected && this._isGamepad)
                {
                    this.fireTooltipShowEvent();
                }
                invalidateData();
                SlotsTransferManager.getInstance().addDragTarget(this);
            }
            return;
        }// end function

        public function get activeSelectionEnabled() : Boolean
        {
            var _loc_1:* = null;
            if (this._activeSelectionEnabled)
            {
                _loc_1 = parent as SlotsListBase;
                if (!_loc_1 || _loc_1.activeSelectionVisible)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function set activeSelectionEnabled(param1:Boolean) : void
        {
            this._activeSelectionEnabled = param1;
            invalidateState();
            if (InputManager.getInstance().isGamepad())
            {
                if (param1 && this.selected && this.isParentEnabled())
                {
                    this.fireTooltipShowEvent(false);
                }
                else
                {
                    this.fireTooltipHideEvent(false);
                }
            }
            if (this.activeSelectionEnabled && this.selected)
            {
                this.clearNewFlag();
            }
            return;
        }// end function

        protected function setBackgroundColor() : void
        {
            this.mcColorBackground.setByItemQuality(this._data.quality);
            return;
        }// end function

        public function GetNavigationIndex(param1:String) : int
        {
            switch(param1)
            {
                case NavigationCode.UP:
                {
                    return this._navigationUp;
                }
                case NavigationCode.RIGHT:
                {
                    return this._navigationRight;
                }
                case NavigationCode.DOWN:
                {
                    return this._navigationDown;
                }
                case NavigationCode.LEFT:
                {
                    return this._navigationLeft;
                }
                default:
                {
                    return -1;
                    break;
                }
            }
        }// end function

        public function cleanup() : void
        {
            this.unloadIcon();
            var _loc_1:* = SlotsTransferManager.getInstance();
            _loc_1.removeDragTarget(this);
            this._data = null;
            this._isEmpty = true;
            if (this.selected)
            {
                if (this._isGamepad)
                {
                    this.hideTooltip();
                }
                else if (this._tooltipRequested)
                {
                    this.fireTooltipHideEvent();
                }
            }
            if (this.mcSlotOverlays)
            {
                this.mcSlotOverlays.visible = false;
            }
            if (this.mcColorBackground)
            {
                this.mcColorBackground.visible = false;
            }
            if (this.mcCantEquipIcon)
            {
                this.mcCantEquipIcon.visible = false;
            }
            if (this.isOver() && !this._isGamepad)
            {
                _loc_1.hideDropTargets();
            }
            this._over = false;
            return;
        }// end function

        public function isEmpty() : Boolean
        {
            return this._isEmpty;
        }// end function

        public function getHitArea() : DisplayObject
        {
            return this.mcHitArea ? (this.mcHitArea) : (this);
        }// end function

        public function getAvatar() : UILoader
        {
            if (this._imageLoader)
            {
                return this._imageLoader;
            }
            return null;
        }// end function

        public function canDrag() : Boolean
        {
            return this._draggingEnabled;
        }// end function

        public function getDragData()
        {
            return this.data;
        }// end function

        public function executeAction(param1:Number, param2:InputEvent) : Boolean
        {
            Console.WriteLine("GFX executeAction keyCode ", param1, this.canExecuteAction());
            if (this.canExecuteAction())
            {
                this.executeDefaultAction(param1, param2);
                return true;
            }
            return false;
        }// end function

        public function getGlobalSlotRect() : Rectangle
        {
            var _loc_1:* = this.getSlotRect();
            var _loc_2:* = localToGlobal(new Point(_loc_1.x, _loc_1.y));
            _loc_1.x = _loc_2.x + 15;
            _loc_1.y = _loc_2.y;
            return _loc_1;
        }// end function

        public function getSlotRect() : Rectangle
        {
            var _loc_1:* = null;
            var _loc_2:* = NaN;
            if (this.mcSizeAnchor)
            {
                _loc_1 = new Rectangle(this.mcSizeAnchor.x, this.mcSizeAnchor.y, this.mcSizeAnchor.width, this.mcSizeAnchor.height);
            }
            else
            {
                _loc_2 = CommonConstants.INVENTORY_GRID_SIZE;
                _loc_1 = new Rectangle(0, 0, _loc_2, _loc_2 * this._gridSize);
            }
            return _loc_1;
        }// end function

        public function isOver() : Boolean
        {
            return this._over;
        }// end function

        protected function resetIndicators() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = this._indicators.length;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._indicators[_loc_2];
                GTweener.removeTweens(_loc_3);
                _loc_3.alpha = 0;
                _loc_2++;
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            doubleClickEnabled = true;
            var _loc_1:* = this.getHitArea() as MovieClip;
            _loc_1.doubleClickEnabled = true;
            _loc_1.addEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver, false, 0, true);
            _loc_1.addEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut, false, 0, true);
            _loc_1.addEventListener(MouseEvent.DOUBLE_CLICK, this.handleMouseDoubleClick, false, 0, true);
            this._isGamepad = InputManager.getInstance().isGamepad();
            InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            return;
        }// end function

        public function set validationBounds(param1:Rectangle) : void
        {
            this._validationBounds = param1;
            return;
        }// end function

        override public function validateNow(event:Event = null) : void
        {
            if ((!initialized || _invalid) && (this._validationBounds == null || getBounds(stage).intersects(this._validationBounds)))
            {
                super.validateNow();
            }
            return;
        }// end function

        public function forceValidateNow() : void
        {
            this._forceNextValidation = true;
            super.validateNow();
            return;
        }// end function

        override protected function draw() : void
        {
            var _loc_1:* = this._validationBounds == null || getBounds(stage).intersects(this._validationBounds);
            if (this._forceNextValidation)
            {
                this._forceNextValidation = false;
                _loc_1 = true;
            }
            if (_loc_1)
            {
                this.awaitingCompleteValidation = false;
                super.draw();
                if (isInvalid(InvalidationType.DATA) && this._data)
                {
                    this.updateData();
                }
                if (isInvalid(InvalidationType.STATE))
                {
                    this.updateState();
                }
                if (isInvalid(InvalidationType.SIZE))
                {
                    this.updateSize();
                }
            }
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            if (!param1 && this._tooltipRequested)
            {
                this.hideTooltip();
            }
            super.enabled = param1;
            invalidateState();
            return;
        }// end function

        protected function handleMouseOver(event:MouseEvent) : void
        {
            var _loc_2:* = InputManager.getInstance().isGamepad();
            if (this.useContextMgr && !_loc_2)
            {
                this.updateMouseContext();
            }
            if (!this._over && !_loc_2 && this.selectable && !SlotsTransferManager.getInstance().isDragging())
            {
                this._over = true;
                this.fireTooltipShowEvent(true);
            }
            invalidateState();
            return;
        }// end function

        protected function handleMouseOut(event:MouseEvent) : void
        {
            var _loc_2:* = InputManager.getInstance().isGamepad();
            if (this._over && !_loc_2 && this.selectable && !SlotsTransferManager.getInstance().isDragging())
            {
                this._over = false;
                this.fireTooltipHideEvent(true);
            }
            invalidateState();
            return;
        }// end function

        protected function handleMouseDown(event:MouseEvent) : void
        {
            return;
        }// end function

        protected function updateMouseContext() : void
        {
            return;
        }// end function

        protected function handleMouseDoubleClick(event:MouseEvent) : void
        {
            var _loc_2:* = event as MouseEventEx;
            if (_loc_2.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
                if (this.canExecuteAction())
                {
                    this.executeDefaultAction(KeyCode.PAD_A_CROSS, null);
                }
            }
            return;
        }// end function

        protected function handleControllerChanged(event:ControllerChangeEvent) : void
        {
            this._isGamepad = event.isGamepad;
            invalidateState();
            return;
        }// end function

        protected function handelOwnerFocusIn(event:FocusEvent) : void
        {
            this._ownerFocused = true;
            invalidateState();
            return;
        }// end function

        protected function handelOwnerFocusOut(event:FocusEvent) : void
        {
            this._ownerFocused = false;
            invalidateState();
            return;
        }// end function

        public function showTooltip() : void
        {
            if (this._isGamepad && this.isParentEnabled())
            {
                removeEventListener(Event.ENTER_FRAME, this.pendedTooltipShow);
                removeEventListener(Event.ENTER_FRAME, this.pendedTooltipHide);
                addEventListener(Event.ENTER_FRAME, this.pendedTooltipShow, false, 0, true);
            }
            return;
        }// end function

        public function hideTooltip() : void
        {
            if (this._isGamepad && this.isParentEnabled())
            {
                removeEventListener(Event.ENTER_FRAME, this.pendedTooltipShow);
                removeEventListener(Event.ENTER_FRAME, this.pendedTooltipHide);
                addEventListener(Event.ENTER_FRAME, this.pendedTooltipHide, false, 0, true);
            }
            return;
        }// end function

        protected function pendedTooltipShow(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.pendedTooltipShow);
            if (this.selectable)
            {
                this.fireTooltipShowEvent(false);
            }
            return;
        }// end function

        protected function pendedTooltipHide(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.pendedTooltipHide);
            if (this.selectable)
            {
                this.fireTooltipHideEvent(false);
            }
            return;
        }// end function

        protected function fireTooltipShowEvent(param1:Boolean = false) : void
        {
            var _loc_2:* = null;
            if ((this.activeSelectionEnabled || !this._isGamepad) && this._data && this.isParentEnabled())
            {
                _loc_2 = new GridEvent(GridEvent.DISPLAY_TOOLTIP, true, false, this.index, -1, -1, null, this._data as Object);
                _loc_2.isMouseTooltip = param1;
                _loc_2.anchorRect = this.getGlobalSlotRect();
                if (!this._data.showExtendedTooltip)
                {
                    _loc_2.tooltipContentRef = "ItemDescriptionTooltipRef";
                }
                dispatchEvent(_loc_2);
                this._tooltipRequested = true;
                this.clearNewFlag();
            }
            return;
        }// end function

        protected function fireTooltipHideEvent(param1:Boolean = false) : void
        {
            var _loc_2:* = null;
            if (this._tooltipRequested)
            {
                _loc_2 = new GridEvent(GridEvent.HIDE_TOOLTIP, true, false, this.index, -1, -1, null, this._data as Object);
                dispatchEvent(_loc_2);
                this._tooltipRequested = false;
            }
            return;
        }// end function

        protected function updateState() : void
        {
            var _loc_3:* = null;
            if (!enabled)
            {
                if (this._currentIdicator)
                {
                    this._currentIdicator.visible = false;
                    this._currentIdicator = null;
                }
                if (this.mcFrame)
                {
                    this.mcFrame.alpha = DISABLE_ALPHA;
                }
                this.updateImageLoaderStates();
                return;
            }
            if (this.mcFrame)
            {
                this.mcFrame.alpha = 1;
            }
            var _loc_1:* = this.getTargetIndicator();
            var _loc_2:* = {alpha:1};
            if (_loc_1 != this._currentIdicator)
            {
                if (this._currentIdicator)
                {
                    _loc_3 = {alpha:0};
                    GTweener.removeTweens(this._currentIdicator);
                    GTweener.to(this._currentIdicator, INDICATE_ANIM_DURATION, _loc_3, {ease:Strong.easeOut});
                }
                this._currentIdicator = _loc_1;
                if (this._currentIdicator)
                {
                    this._currentIdicator.visible = true;
                    this._currentIdicator.alpha = 0;
                    GTweener.removeTweens(this._currentIdicator);
                    GTweener.to(this._currentIdicator, INDICATE_ANIM_DURATION, _loc_2, {ease:Strong.easeOut});
                }
            }
            else if (this._currentIdicator && (this._currentIdicator.visible == false || this._currentIdicator.alpha == 0))
            {
                this._currentIdicator.visible = true;
                this._currentIdicator.alpha = 0;
                GTweener.removeTweens(this._currentIdicator);
                GTweener.to(this._currentIdicator, INDICATE_ANIM_DURATION, _loc_2, {ease:Strong.easeOut});
            }
            this.updateImageLoaderStates();
            return;
        }// end function

        private function updateImageLoaderStates() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = false;
            if (this._imageLoader && this._imageLoaded)
            {
                _loc_1 = [];
                _loc_2 = this._over && !this._isGamepad && !this._isEmpty;
                if (!this._dragSelection && !this._currentIdicator && _loc_2)
                {
                    _loc_1.Count(this._glowFilter);
                }
                if (this._data && this._data.disableAction)
                {
                    _loc_1.Count(this._warningFilter);
                    this._imageLoader.alpha = DISABLED_ACTION_ALPHA;
                }
                else if (this._dragSelection)
                {
                    _loc_1.Count(this._desaturateFilter);
                    this._imageLoader.alpha = DRAG_ALPHA;
                }
                else
                {
                    this._imageLoader.alpha = 1;
                }
                this._imageLoader.filters = _loc_1;
            }
            return;
        }// end function

        protected function updateData()
        {
            if (this._data)
            {
                if (this.mcCantEquipIcon)
                {
                    this.mcCantEquipIcon.visible = this._data.cantEquip;
                }
                if (this.mcSlotOverlays)
                {
                    this.mcSlotOverlays.visible = true;
                    this.mcSlotOverlays.updateSlots(this._data.socketsCount, this._data.socketsUsedCount);
                    if (this._data.charges)
                    {
                        this.mcSlotOverlays.SetQuantity(this._data.charges);
                    }
                    else
                    {
                        this.mcSlotOverlays.SetQuantity(this._data.quantity);
                    }
                    this.mcSlotOverlays.setOilApplied(this._data.isOilApplied);
                    this.mcSlotOverlays.SetNeedRepair(this._data.needRepair);
                    this.mcSlotOverlays.SetIsNew(this._data.isNew);
                    this.mcSlotOverlays.updateIcons();
                }
                if (this.mcColorBackground)
                {
                    if (this._data.quality)
                    {
                        this.mcColorBackground.visible = true;
                        this.setBackgroundColor();
                        this.mcColorBackground.colorBlind = CoreComponent.isColorBlindMode;
                    }
                }
                if (this._data.iconPath != "")
                {
                    if (this._loadedImagePath != this._data.iconPath || this._imageLoader == null)
                    {
                        this._loadedImagePath = this._data.iconPath;
                        this.loadIcon(this._loadedImagePath);
                    }
                }
                else
                {
                    this.unloadIcon();
                }
            }
            return;
        }// end function

        protected function updateSize()
        {
            return;
        }// end function

        protected function getTargetIndicator() : MovieClip
        {
            if (this._selected)
            {
                if (this._owner && (this._owner.focused || !this._owner.focusable) && this._activeSelectionEnabled)
                {
                    return this.mcStateSelectedActive;
                }
            }
            if (this._highlight && this.mcStateDropReady)
            {
                return this.mcStateDropReady;
            }
            if (this._dropSelection)
            {
                return this.mcStateDropTarget;
            }
            if (this._selected && this._isGamepad)
            {
                return this.mcStateSelectedPassive;
            }
            return null;
        }// end function

        protected function loadIcon(param1:String) : void
        {
            this.unloadIcon();
            this._imageLoader = new W3UILoaderSlot();
            if (this._data)
            {
                this._imageLoader.slotType = this._data.slotType;
            }
            this._imageLoader.maintainAspectRatio = false;
            this._imageLoader.autoSize = false;
            this._imageLoader.addEventListener(Event.COMPLETE, this.handleIconLoaded, false, 0, true);
            this._imageLoader.addEventListener(IOErrorEvent.IO_ERROR, this.handleLoadIOError, false, 0, true);
            this._imageLoader.source = param1;
            this._imageLoader.mouseChildren = false;
            this._imageLoader.mouseEnabled = false;
            addChild(this._imageLoader);
            if (this.mcSlotOverlays)
            {
                addChild(this.mcSlotOverlays);
            }
            if (this.mcCantEquipIcon)
            {
                addChild(this.mcCantEquipIcon);
            }
            if (this.mcHitArea)
            {
                addChild(this.mcHitArea);
            }
            return;
        }// end function

        protected function unloadIcon() : void
        {
            if (this._imageLoader)
            {
                this._imageLoader.unload();
                this._imageLoader.removeEventListener(Event.COMPLETE, this.handleIconLoaded);
                removeChild(this._imageLoader);
                this._imageLoader = null;
                this._loadedImagePath = "";
            }
            if (this._imageStub)
            {
                removeChild(this._imageStub);
                this._imageStub = null;
            }
            if (this._imageLoaded)
            {
                GTweener.removeTweens(this._imageLoader);
            }
            this._imageLoaded = false;
            return;
        }// end function

        public function desaturateIcon(param1:Number) : void
        {
            this.filters = [CommonUtils.generateDesaturationFilter(param1)];
            return;
        }// end function

        public function darkenIcon(param1:Number) : void
        {
            this.filters = [CommonUtils.generateDarkenFilter(param1)];
            return;
        }// end function

        protected function handleLoadIOError(event:Event) : void
        {
            var _loc_2:* = null;
            try
            {
                _loc_2 = getDefinitionByName(NO_IMAGE_SPRITE_REF) as Class;
                this._imageStub = new _loc_2 as UIComponent;
                addChild(this._imageStub);
                this.fitImage(this._imageStub);
            }
            catch (er:Error)
            {
            }
            return;
        }// end function

        protected function handleIconLoaded(event:Event) : void
        {
            var _loc_2:* = Bitmap(event.target.content);
            if (_loc_2)
            {
                _loc_2.smoothing = true;
                _loc_2.pixelSnapping = PixelSnapping.NEVER;
            }
            if (this._imageLoader)
            {
                this.fitImage(this._imageLoader);
            }
            if (this._iconFilterTimer)
            {
                this._iconFilterTimer.stop();
                this._iconFilterTimer.removeEventListener(TimerEvent.TIMER, this.handleIconFilter, false);
            }
            this._iconFilterTimer = new Timer(ICON_FILTER_TIMER, 1);
            this._iconFilterTimer.addEventListener(TimerEvent.TIMER, this.handleIconFilter, false, 0, true);
            this._iconFilterTimer.start();
            return;
        }// end function

        protected function handleIconFilter(event:TimerEvent) : void
        {
            this._imageLoaded = true;
            if (this._iconFilterTimer)
            {
                this._iconFilterTimer.stop();
                this._iconFilterTimer.removeEventListener(TimerEvent.TIMER, this.handleIconFilter, false);
                this._iconFilterTimer = null;
            }
            this.updateImageLoaderStates();
            return;
        }// end function

        protected function fitImage(param1:UIComponent) : void
        {
            var _loc_3:* = NaN;
            var _loc_2:* = this.getSlotRect();
            var _loc_4:* = _loc_2.width / param1.actualWidth;
            var _loc_5:* = _loc_2.height / param1.actualHeight;
            var _loc_6:* = Math.min(_loc_4, _loc_5);
            var _loc_7:* = _loc_6;
            param1.scaleY = _loc_6;
            param1.scaleX = _loc_7;
            param1.x = _loc_2.x + (_loc_2.width - param1.actualWidth) / 2;
            param1.y = _loc_2.y + (_loc_2.height - param1.actualHeight) / 2;
            return;
        }// end function

        protected function canExecuteAction() : Boolean
        {
            return this._data && !this._isEmpty;
        }// end function

        protected function executeDefaultAction(param1:Number, param2:InputEvent) : void
        {
            if (!this.canExecuteAction())
            {
                return;
            }
            if (!this._data)
            {
            }
            if (param2)
            {
            }
            switch(this._data.actionType)
            {
                case InventoryActionType.EQUIP:
                {
                    break;
                }
                case InventoryActionType.CONSUME:
                {
                    break;
                }
                case InventoryActionType.READ:
                {
                }
                case InventoryActionType.DROP:
                {
                    break;
                }
                case InventoryActionType.TRANSFER:
                {
                    break;
                }
                case InventoryActionType.SELL:
                {
                    break;
                }
                case InventoryActionType.BUY:
                {
                    break;
                }
                case InventoryActionType.REPAIR:
                {
                    break;
                }
                case InventoryActionType.SOCKET:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (param1 == KeyCode.PAD_Y_TRIANGLE)
            {
                if (this._data.slotType != InventorySlotType.Potion1 && this._data.slotType != InventorySlotType.Potion2 && this._data.slotType != InventorySlotType.Petard1 && this._data.slotType != InventorySlotType.Petard2 && this._data.slotType != InventorySlotType.Quickslot1 && this._data.slotType != InventorySlotType.Quickslot2)
                {
                }
            }
            else if (param1 == KeyCode.PAD_X_SQUARE)
            {
            }
            return;
        }// end function

        protected function defaultSlotEquipAction(param1:Object) : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnEquipItem", [param1.id, param1.slotType, param1.quantity]));
            return;
        }// end function

        protected function defaultSlotDropAction(param1:Object) : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnDropItem", [param1.id, param1.quantity]));
            return;
        }// end function

        protected function fireActionEvent(param1:int, param2:String = "event_activate") : void
        {
            Console.WriteLine("GFX fireActionEvent from slot [ ", this, "] eventName: ", param2);
            var _loc_3:* = new SlotActionEvent(param2, true);
            _loc_3.actionType = param1;
            _loc_3.targetSlot = this;
            dispatchEvent(_loc_3);
            return;
        }// end function

        override public function toString() : String
        {
            return "Slot [ " + this.name + ", activeSel: " + this.activeSelectionEnabled + " ]";
        }// end function

        override public function get scaleX() : Number
        {
            return super.actualScaleX;
        }// end function

        override public function get scaleY() : Number
        {
            return super.actualScaleY;
        }// end function

        protected function isParentEnabled() : Boolean
        {
            var _loc_1:* = this.owner as UIComponent;
            return _loc_1 ? (_loc_1.enabled) : (true);
        }// end function

        public function setListData(param1:ListData) : void
        {
            return;
        }// end function

        public function setData(param1:Object) : void
        {
            this.data = param1;
            return;
        }// end function

    }
}

///SlotBase
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
    
    public class SlotBase extends scaleform.clik.core.UIComponent implements red.game.witcher3.interfaces.IBaseSlot, red.game.witcher3.interfaces.IDragTarget
    {
        public function SlotBase()
        {
            var loc2:*=0;
            var loc3:*=null;
            super();
            this._isEmpty = true;
            this._indicators = new Vector.<flash.display.MovieClip>();
            this._warningFilter = red.game.witcher3.utils.CommonUtils.getRedWarningFilter();
            this._glowFilter = new flash.filters.GlowFilter(OVER_GLOW_COLOR, 1, OVER_GLOW_BLUR, OVER_GLOW_BLUR, OVER_GLOW_STRENGHT, flash.filters.BitmapFilterQuality.HIGH);
            this._desaturateFilter = red.game.witcher3.utils.CommonUtils.getDesaturateFilter();
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
                this._indicators.push(this.mcStateSelectedActive);
            }
            if (this.mcStateSelectedPassive) 
            {
                this._indicators.push(this.mcStateSelectedPassive);
            }
            if (this.mcStateDropTarget) 
            {
                this._indicators.push(this.mcStateDropTarget);
            }
            if (this.mcStateDropReady) 
            {
                this._indicators.push(this.mcStateDropReady);
            }
            var loc1:*=this._indicators.length;
            while (loc2 < loc1) 
            {
                loc3 = this._indicators[loc2];
                loc3.mouseEnabled = false;
                loc3.mouseChildren = false;
                loc3.alpha = 0;
                ++loc2;
            }
            if (this.mcHitArea) 
            {
                this._indicators.push(this.mcHitArea);
            }
            return;
        }

        public function getSlotRect():flash.geom.Rectangle
        {
            var loc1:*=null;
            var loc2:*=NaN;
            if (this.mcSizeAnchor) 
            {
                loc1 = new flash.geom.Rectangle(this.mcSizeAnchor.x, this.mcSizeAnchor.y, this.mcSizeAnchor.width, this.mcSizeAnchor.height);
            }
            else 
            {
                loc2 = red.game.witcher3.constants.CommonConstants.INVENTORY_GRID_SIZE;
                loc1 = new flash.geom.Rectangle(0, 0, loc2, loc2 * this._gridSize);
            }
            return loc1;
        }

        protected function resetIndicators():void
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=this._indicators.length;
            while (loc2 < loc1) 
            {
                loc3 = this._indicators[loc2];
                com.gskinner.motion.GTweener.removeTweens(loc3);
                loc3.alpha = 0;
                ++loc2;
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            doubleClickEnabled = true;
            var loc1:*=this.getHitArea() as flash.display.MovieClip;
            loc1.doubleClickEnabled = true;
            loc1.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.handleMouseOver, false, 0, true);
            loc1.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.handleMouseOut, false, 0, true);
            loc1.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.handleMouseDown, false, 0, true);
            loc1.addEventListener(flash.events.MouseEvent.DOUBLE_CLICK, this.handleMouseDoubleClick, false, 0, true);
            this._isGamepad = red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            red.game.witcher3.managers.InputManager.getInstance().addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            return;
        }

        protected override function draw():void
        {
            super.draw();
            if (isInvalid(scaleform.clik.constants.InvalidationType.DATA) && this._data) 
            {
                this.updateData();
            }
            if (isInvalid(scaleform.clik.constants.InvalidationType.STATE)) 
            {
                this.updateState();
            }
            if (isInvalid(scaleform.clik.constants.InvalidationType.SIZE)) 
            {
                this.updateSize();
            }
            return;
        }

        public override function set enabled(arg1:Boolean):void
        {
            if (!arg1 && this._tooltipRequested) 
            {
                this.hideTooltip();
            }
            super.enabled = arg1;
            invalidateState();
            return;
        }

        protected function handleMouseOver(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            if (!this._over && !loc1 && this.selectable) 
            {
                this._over = true;
                invalidateState();
                dispatchEvent(arg1);
                this.fireTooltipShowEvent(true);
            }
            return;
        }

        protected function handleMouseOut(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            if (this._over && !loc1 && this.selectable) 
            {
                this._over = false;
                invalidateState();
                dispatchEvent(arg1);
                this.fireTooltipHideEvent(true);
            }
            return;
        }

        protected function handleMouseDown(arg1:flash.events.MouseEvent):void
        {
            if (!this._isEmpty) 
            {
                dispatchEvent(arg1);
            }
            return;
        }

        protected function handleMouseDoubleClick(arg1:flash.events.MouseEvent):void
        {
            if (this.canExecuteAction()) 
            {
                this.executeDefaultAction(red.core.constants.KeyCode.PAD_A_CROSS, null);
            }
            return;
        }

        protected function handleControllerChanged(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            this._isGamepad = arg1.isGamepad;
            invalidateState();
            return;
        }

        protected function handelOwnerFocusIn(arg1:flash.events.FocusEvent):void
        {
            this._ownerFocused = true;
            invalidateState();
            return;
        }

        protected function handelOwnerFocusOut(arg1:flash.events.FocusEvent):void
        {
            this._ownerFocused = false;
            invalidateState();
            return;
        }

        public function showTooltip():void
        {
            var loc1:*=red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            if (loc1 && this.isParentEnabled()) 
            {
                removeEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipShow);
                removeEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipHide);
                addEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipShow, false, 0, true);
            }
            return;
        }

        public function hideTooltip():void
        {
            var loc1:*=red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            if (loc1 && this.isParentEnabled()) 
            {
                removeEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipShow);
                removeEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipHide);
                addEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipHide, false, 0, true);
            }
            return;
        }

        protected function pendedTooltipShow(arg1:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipShow);
            if (this.selectable) 
            {
                this.fireTooltipShowEvent(false);
            }
            return;
        }

        protected function pendedTooltipHide(arg1:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, this.pendedTooltipHide);
            if (this.selectable) 
            {
                this.fireTooltipHideEvent(false);
            }
            return;
        }

        public function set data(arg1:*):void
        {
            if (arg1) 
            {
                this._data = arg1;
                this._isEmpty = false;
                this.gridSize = this._data.gridSize;
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
                        this.mcColorBackground.colorBlind = red.core.CoreComponent.isColorBlindMode;
                    }
                }
                if (this.selected) 
                {
                    this.fireTooltipShowEvent();
                }
                invalidateData();
                red.game.witcher3.slots.SlotsTransferManager.getInstance().addDragTarget(this);
            }
            return;
        }

        protected function fireTooltipShowEvent(arg1:Boolean=false):void
        {
            var loc1:*=null;
            if ((this.activeSelectionEnabled || !red.game.witcher3.managers.InputManager.getInstance().isGamepad()) && this._data && this.isParentEnabled()) 
            {
                loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, true, false, this.index, -1, -1, null, this._data as Object);
                loc1.isMouseTooltip = arg1;
                loc1.anchorRect = this.getGlobalSlotRect();
                if (!this._data.showExtendedTooltip) 
                {
                    loc1.tooltipContentRef = "ItemDescriptionTooltipRef";
                }
                loc1.tooltipMouseContentRef = "ItemTooltipRef_mouse";
                dispatchEvent(loc1);
                this._tooltipRequested = true;
            }
            return;
        }

        protected function fireTooltipHideEvent(arg1:Boolean=false):void
        {
            var loc1:*=null;
            if (this._tooltipRequested) 
            {
                loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.HIDE_TOOLTIP, true, false, this.index, -1, -1, null, this._data as Object);
                dispatchEvent(loc1);
                this._tooltipRequested = false;
            }
            return;
        }

        protected function updateState():void
        {
            var loc3:*=null;
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
            var loc1:*=this.getTargetIndicator();
            var loc2:*={"alpha":1};
            if (loc1 == this._currentIdicator) 
            {
                if (this._currentIdicator && (this._currentIdicator.visible == false || this._currentIdicator.alpha == 0)) 
                {
                    this._currentIdicator.visible = true;
                    this._currentIdicator.alpha = 0;
                    com.gskinner.motion.GTweener.removeTweens(this._currentIdicator);
                    com.gskinner.motion.GTweener.to(this._currentIdicator, INDICATE_ANIM_DURATION, loc2, {"ease":fl.transitions.easing.Strong.easeOut});
                }
            }
            else 
            {
                if (this._currentIdicator) 
                {
                    loc3 = {"alpha":0};
                    com.gskinner.motion.GTweener.removeTweens(this._currentIdicator);
                    com.gskinner.motion.GTweener.to(this._currentIdicator, INDICATE_ANIM_DURATION, loc3, {"ease":fl.transitions.easing.Strong.easeOut});
                }
                this._currentIdicator = loc1;
                if (this._currentIdicator) 
                {
                    this._currentIdicator.visible = true;
                    this._currentIdicator.alpha = 0;
                    com.gskinner.motion.GTweener.removeTweens(this._currentIdicator);
                    com.gskinner.motion.GTweener.to(this._currentIdicator, INDICATE_ANIM_DURATION, loc2, {"ease":fl.transitions.easing.Strong.easeOut});
                }
            }
            this.updateImageLoaderStates();
            return;
        }

        internal function updateImageLoaderStates():void
        {
            var loc1:*=null;
            var loc2:*=false;
            if (this._imageLoader && this._imageLoaded) 
            {
                loc1 = [];
                loc2 = this._over && !this._isGamepad && !this._isEmpty;
                if (!this._dragSelection && !this._currentIdicator && loc2) 
                {
                    loc1.push(this._glowFilter);
                }
                if (this._data && this._data.disableAction) 
                {
                    loc1.push(this._warningFilter);
                    this._imageLoader.alpha = DISABLED_ACTION_ALPHA;
                }
                else if (this._dragSelection) 
                {
                    loc1.push(this._desaturateFilter);
                    this._imageLoader.alpha = DRAG_ALPHA;
                }
                else 
                {
                    this._imageLoader.alpha = 1;
                }
                this._imageLoader.filters = loc1;
            }
            return;
        }

        protected function updateData():*
        {
            if (this._data) 
            {
                if (this._data.iconPath == "") 
                {
                    this.unloadIcon();
                }
                else if (!(this._loadedImagePath == this._data.iconPath) || this._imageLoader == null) 
                {
                    this._loadedImagePath = this._data.iconPath;
                    this.loadIcon(this._loadedImagePath);
                }
            }
            return;
        }

        protected function updateSize():*
        {
            return;
        }

        protected function getTargetIndicator():flash.display.MovieClip
        {
            if (this._selected) 
            {
                if (this._owner && (this._owner.focused || !this._owner.focusable) && this._activeSelectionEnabled) 
                {
                    return this.mcStateSelectedActive;
                }
            }
            if (this._dropSelection) 
            {
                return this.mcStateDropTarget;
            }
            if (this._highlight) 
            {
                return this.mcStateDropReady;
            }
            if (this._selected && this._isGamepad) 
            {
                return this.mcStateSelectedPassive;
            }
            return null;
        }

        protected function loadIcon(arg1:String):void
        {
            this.unloadIcon();
            this._imageLoader = new red.game.witcher3.controls.W3UILoaderSlot();
            if (this._data) 
            {
                this._imageLoader.slotType = this._data.slotType;
            }
            this._imageLoader.maintainAspectRatio = false;
            this._imageLoader.autoSize = false;
            this._imageLoader.addEventListener(flash.events.Event.COMPLETE, this.handleIconLoaded, false, 0, true);
            this._imageLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.handleLoadIOError, false, 0, true);
            this._imageLoader.source = arg1;
            this._imageLoader.mouseChildren = false;
            this._imageLoader.mouseEnabled = false;
            addChild(this._imageLoader);
            if (this.mcSlotOverlays) 
            {
                addChild(this.mcSlotOverlays);
            }
            if (this.mcHitArea) 
            {
                addChild(this.mcHitArea);
            }
            if (this.mcCantEquipIcon) 
            {
                addChild(this.mcCantEquipIcon);
            }
            return;
        }

        protected function unloadIcon():void
        {
            if (this._imageLoader) 
            {
                this._imageLoader.unload();
                this._imageLoader.removeEventListener(flash.events.Event.COMPLETE, this.handleIconLoaded);
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
                com.gskinner.motion.GTweener.removeTweens(this._imageLoader);
            }
            this._imageLoaded = false;
            return;
        }

        public function desaturateIcon(arg1:Number):void
        {
            this.filters = [red.game.witcher3.utils.CommonUtils.generateDesaturationFilter(arg1)];
            return;
        }

        public function darkenIcon(arg1:Number):void
        {
            this.filters = [red.game.witcher3.utils.CommonUtils.generateDarkenFilter(arg1)];
            return;
        }

        protected function handleLoadIOError(arg1:flash.events.Event):void
        {
            var loc1:*=null;
            try 
            {
                loc1 = flash.utils.getDefinitionByName(NO_IMAGE_SPRITE_REF) as Class;
                this._imageStub = new loc1() as scaleform.clik.core.UIComponent;
                addChild(this._imageStub);
                this.fitImage(this._imageStub);
            }
            catch (er:Error)
            {
            };
            return;
        }

        protected function handleIconLoaded(arg1:flash.events.Event):void
        {
            var loc1:*=flash.display.Bitmap(arg1.target.content);
            if (loc1) 
            {
                loc1.smoothing = true;
                loc1.pixelSnapping = flash.display.PixelSnapping.NEVER;
            }
            this.fitImage(this._imageLoader);
            if (this._iconFilterTimer) 
            {
                this._iconFilterTimer.stop();
                this._iconFilterTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.handleIconFilter, false);
            }
            this._iconFilterTimer = new flash.utils.Timer(ICON_FILTER_TIMER, 1);
            this._iconFilterTimer.addEventListener(flash.events.TimerEvent.TIMER, this.handleIconFilter, false, 0, true);
            this._iconFilterTimer.start();
            return;
        }

        protected function handleIconFilter(arg1:flash.events.TimerEvent):void
        {
            this._imageLoaded = true;
            if (this._iconFilterTimer) 
            {
                this._iconFilterTimer.stop();
                this._iconFilterTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.handleIconFilter, false);
                this._iconFilterTimer = null;
            }
            this.updateImageLoaderStates();
            return;
        }

        protected function fitImage(arg1:scaleform.clik.core.UIComponent):void
        {
            var loc2:*=NaN;
            var loc1:*=this.getSlotRect();
            var loc3:*=loc1.width / arg1.actualWidth;
            var loc4:*=loc1.height / arg1.actualHeight;
            var loc5:*=Math.min(loc3, loc4);
            var loc6:*;
            arg1.scaleY = loc6 = loc5;
            arg1.scaleX = loc6;
            arg1.x = loc1.x + (loc1.width - arg1.actualWidth) / 2;
            arg1.y = loc1.y + (loc1.height - arg1.actualHeight) / 2;
            return;
        }

        protected function canExecuteAction():Boolean
        {
            return this._data && !this._isEmpty;
        }

        protected function executeDefaultAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):void
        {
            if (!this.canExecuteAction()) 
            {
                return;
            }
            if (arg1 != red.core.constants.KeyCode.PAD_A_CROSS) 
            {
                if (arg1 != red.core.constants.KeyCode.PAD_Y_TRIANGLE) 
                {
                    if (arg1 == red.core.constants.KeyCode.PAD_X_SQUARE) 
                    {
                        this.fireActionEvent(red.game.witcher3.constants.InventoryActionType.SUB_ACTION, red.game.witcher3.events.SlotActionEvent.EVENT_SECONDARY_ACTION);
                    }
                }
                else 
                {
                    if (!(this._data.slotType == red.game.witcher3.constants.InventorySlotType.Potion1) && !(this._data.slotType == red.game.witcher3.constants.InventorySlotType.Potion2) && !(this._data.slotType == red.game.witcher3.constants.InventorySlotType.Petard1) && !(this._data.slotType == red.game.witcher3.constants.InventorySlotType.Petard2) && !(this._data.slotType == red.game.witcher3.constants.InventorySlotType.Quickslot1) && !(this._data.slotType == red.game.witcher3.constants.InventorySlotType.Quickslot2)) 
                    {
                        this.defaultSlotDropAction(this._data);
                    }
                    this.fireActionEvent(red.game.witcher3.constants.InventoryActionType.DROP);
                }
            }
            else 
            {
                if (!this._data) 
                {
                    return;
                }
                if (arg2) 
                {
                    arg2.handled = true;
                }
                this.fireActionEvent(this._data.actionType);
                trace("GFX - Executing action type: ", this._data.actionType);
                var loc1:*=this._data.actionType;
                switch (loc1) 
                {
                    case red.game.witcher3.constants.InventoryActionType.EQUIP:
                    {
                        this.defaultSlotEquipAction(this._data);
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.CONSUME:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnConsumeItem", [this._data.id]));
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.READ:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnReadBook", [this._data.id]));
                    }
                    case red.game.witcher3.constants.InventoryActionType.DROP:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnDropItem", [this._data.id, this._data.quantity]));
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.TRANSFER:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnTransferItem", [this._data.id, this._data.quantity]));
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.SELL:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnSellItem", [this._data.id, this._data.quantity]));
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.BUY:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnBuyItem", [this._data.id, this._data.quantity]));
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.REPAIR:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnRepairItem", [this._data.id]));
                        break;
                    }
                    case red.game.witcher3.constants.InventoryActionType.SOCKET:
                    {
                        dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPutInSocket", [this._data.id]));
                        break;
                    }
                }
            }
            return;
        }

        protected function defaultSlotEquipAction(arg1:Object):void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnEquipItem", [arg1.id, arg1.slotType, arg1.quantity]));
            return;
        }

        protected function defaultSlotDropAction(arg1:Object):void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnDropItem", [arg1.id, arg1.quantity]));
            return;
        }

        protected function fireActionEvent(arg1:int, arg2:String="event_activate"):void
        {
            var loc1:*=new red.game.witcher3.events.SlotActionEvent(arg2, true);
            loc1.actionType = arg1;
            loc1.targetSlot = this;
            dispatchEvent(loc1);
            return;
        }

        public override function get scaleX():Number
        {
            return super.actualScaleX;
        }

        public override function get scaleY():Number
        {
            return super.actualScaleY;
        }

        public function get navigationUp():int
        {
            return this._navigationUp;
        }

        public function set navigationUp(arg1:int):void
        {
            this._navigationUp = arg1;
            return;
        }

        public function get navigationRight():int
        {
            return this._navigationRight;
        }

        public function set navigationRight(arg1:int):void
        {
            this._navigationRight = arg1;
            return;
        }

        public function get navigationDown():int
        {
            return this._navigationDown;
        }

        public function set navigationDown(arg1:int):void
        {
            this._navigationDown = arg1;
            return;
        }

        public function get navigationLeft():int
        {
            return this._navigationLeft;
        }

        public function set navigationLeft(arg1:int):void
        {
            this._navigationLeft = arg1;
            return;
        }

        public function get gridSize():int
        {
            return this._gridSize;
        }

        public function set gridSize(arg1:int):void
        {
            this._gridSize = arg1;
            invalidateSize();
            return;
        }

        public function get selectable():Boolean
        {
            return this._selectable;
        }

        public function set selectable(arg1:Boolean):void
        {
            this._selectable = arg1;
            return;
        }

        public function get index():uint
        {
            return this._index;
        }

        public function set index(arg1:uint):void
        {
            this._index = arg1;
            return;
        }

        protected function isParentEnabled():Boolean
        {
            var loc1:*=this.owner as scaleform.clik.core.UIComponent;
            return loc1 ? loc1.enabled : true;
        }

        public function get draggingEnabled():Boolean
        {
            return this._draggingEnabled;
        }

        public function set draggingEnabled(arg1:Boolean):void
        {
            this._draggingEnabled = arg1;
            return;
        }

        public function get selected():Boolean
        {
            return this._selected;
        }

        public function set selected(arg1:Boolean):void
        {
            if (this._selected && !(this._selected == arg1)) 
            {
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", ["gui_global_highlight"]));
            }
            this._selected = arg1;
            if (this.mcSlotOverlays) 
            {
                if (this.activeSelectionEnabled) 
                {
                    this.clearNewFlag();
                }
            }
            if (red.game.witcher3.managers.InputManager.getInstance().isGamepad()) 
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
        }

        public function setListData(arg1:scaleform.clik.data.ListData):void
        {
            return;
        }

        protected function clearNewFlag():void
        {
            if (this._data && this._data.hasOwnProperty("isNew") && this._data.isNew) 
            {
                this._data.isNew = false;
                this._unprocessedNewFlagRemoval = true;
                this.mcSlotOverlays.SetIsNew(false);
                this.mcSlotOverlays.updateIcons();
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnClearSlotNewFlag", [this.data.id]));
            }
            return;
        }

        public function get dragSelection():Boolean
        {
            return this._dragSelection;
        }

        public function set dragSelection(arg1:Boolean):void
        {
            this._dragSelection = arg1;
            invalidateState();
            if (this._dragSelection) 
            {
                this.hideTooltip();
            }
            return;
        }

        public function setData(arg1:Object):void
        {
            this.data = arg1;
            return;
        }

        public function get useContextMgr():Boolean
        {
            return this._useContextMgr;
        }

        public function set useContextMgr(arg1:Boolean):void
        {
            this._useContextMgr = arg1;
            return;
        }

        public function get owner():scaleform.clik.core.UIComponent
        {
            return this._owner;
        }

        public function set owner(arg1:scaleform.clik.core.UIComponent):void
        {
            if (this._owner != arg1) 
            {
                if (this._owner) 
                {
                    this._owner.removeEventListener(flash.events.FocusEvent.FOCUS_IN, this.handelOwnerFocusIn);
                    this._owner.removeEventListener(flash.events.FocusEvent.FOCUS_OUT, this.handelOwnerFocusOut);
                }
                this._owner = arg1;
                if (this._owner) 
                {
                    this._owner.addEventListener(flash.events.FocusEvent.FOCUS_IN, this.handelOwnerFocusIn, false, 0, true);
                    this._owner.addEventListener(flash.events.FocusEvent.FOCUS_OUT, this.handelOwnerFocusOut, false, 0, true);
                    this._ownerFocused = this._owner.focused > 0;
                }
            }
            return;
        }

        public function get data():*
        {
            return this._data;
        }

        public override function toString():String
        {
            return "Slot [ " + this.name + ", activeSel: " + this.activeSelectionEnabled + " ]";
        }

        public function get activeSelectionEnabled():Boolean
        {
            var loc1:*=null;
            if (this._activeSelectionEnabled) 
            {
                loc1 = parent as red.game.witcher3.slots.SlotsListBase;
                if (!loc1 || loc1.activeSelectionVisible) 
                {
                    return true;
                }
            }
            return false;
        }

        public function set activeSelectionEnabled(arg1:Boolean):void
        {
            this._activeSelectionEnabled = arg1;
            invalidateState();
            if (red.game.witcher3.managers.InputManager.getInstance().isGamepad()) 
            {
                if (arg1 && this.selected && this.isParentEnabled()) 
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
        }

        protected function setBackgroundColor():void
        {
            this.mcColorBackground.setByItemQuality(this._data.quality);
            return;
        }

        public function GetNavigationIndex(arg1:String):int
        {
            var loc1:*=arg1;
            switch (loc1) 
            {
                case scaleform.clik.constants.NavigationCode.UP:
                {
                    return this._navigationUp;
                }
                case scaleform.clik.constants.NavigationCode.RIGHT:
                {
                    return this._navigationRight;
                }
                case scaleform.clik.constants.NavigationCode.DOWN:
                {
                    return this._navigationDown;
                }
                case scaleform.clik.constants.NavigationCode.LEFT:
                {
                    return this._navigationLeft;
                }
                default:
                {
                    return -1;
                }
            }
        }

        public function cleanup():void
        {
            this.unloadIcon();
            var loc1:*=red.game.witcher3.slots.SlotsTransferManager.getInstance();
            loc1.removeDragTarget(this);
            this._data = null;
            this._isEmpty = true;
            this.hideTooltip();
            if (this.mcSlotOverlays) 
            {
                this.mcSlotOverlays.visible = false;
                this.mcSlotOverlays.SetQuantity("0");
                this.mcSlotOverlays.updateSlots(0, 0);
            }
            if (this.mcColorBackground) 
            {
                this.mcColorBackground.visible = false;
            }
            if (this.mcCantEquipIcon) 
            {
                this.mcCantEquipIcon.visible = false;
            }
            return;
        }

        public function isEmpty():Boolean
        {
            return this._isEmpty;
        }

        public function getHitArea():flash.display.DisplayObject
        {
            return this.mcHitArea ? this.mcHitArea : this;
        }

        public function getAvatar():scaleform.clik.controls.UILoader
        {
            if (this._imageLoader) 
            {
                return this._imageLoader;
            }
            return null;
        }

        public function canDrag():Boolean
        {
            return this._draggingEnabled;
        }

        public function getDragData():*
        {
            return this.data;
        }

        public function executeAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):Boolean
        {
            if (this.canExecuteAction()) 
            {
                this.executeDefaultAction(arg1, arg2);
                return true;
            }
            return false;
        }

        public function getGlobalSlotRect():flash.geom.Rectangle
        {
            var loc1:*=this.getSlotRect();
            var loc2:*=localToGlobal(new flash.geom.Point(loc1.x, loc1.y));
            loc1.x = loc2.x;
            loc1.y = loc2.y;
            return loc1;
        }

        protected static const ICON_FILTER_TIMER:Number=300;

        protected static const DRAG_ALPHA:Number=0.5;

        protected static const INVALIDATE_TOOLTIP_HIDE:String="INVALIDATE_TOOLTIP_HIDE";

        protected static const INVALIDATE_TOOLTIP_SHOW:String="INVALIDATE_TOOLTIP_SHOW";

        protected static const NO_IMAGE_SPRITE_REF:String="ImageStubRef";

        protected static const DISABLED_ACTION_ALPHA:Number=0.6;

        protected static const DISABLE_ALPHA:Number=0.5;

        protected static const OVER_GLOW_COLOR:Number=15990722;

        protected static const OVER_GLOW_BLUR:Number=15;

        protected static const OVER_GLOW_STRENGHT:Number=0.75;

        protected static const INDICATE_ANIM_DURATION:Number=1.5;

        protected static const INDICATE_ANIM_SCALE:Number=1;

        protected var _imageLoader:red.game.witcher3.controls.W3UILoaderSlot;

        protected var _imageStub:scaleform.clik.core.UIComponent;

        protected var _loadedImagePath:String;

        protected var _data:Object;

        protected var _gridSize:int=1;

        protected var _owner:scaleform.clik.core.UIComponent;

        protected var _currentIdicator:flash.display.MovieClip;

        protected var _ownerFocused:Boolean;

        protected var _selected:Boolean;

        protected var _highlight:Boolean;

        protected var _over:Boolean;

        protected var _dropSelection:Boolean;

        protected var _dragSelection:Boolean;

        protected var _isEmpty:Boolean;

        protected var _isGamepad:Boolean;

        protected var _selectable:Boolean=true;

        public var mcStateDropReady:flash.display.MovieClip;

        protected var _isTargetsSelected:Boolean;

        protected var _glowFilter:flash.filters.GlowFilter;

        protected var _desaturateFilter:flash.filters.ColorMatrixFilter;

        protected var _warningFilter:flash.filters.ColorMatrixFilter;

        protected var _iconFilterTimer:flash.utils.Timer;

        protected var _navigationUp:int;

        protected var _navigationRight:int;

        protected var _navigationDown:int;

        protected var _navigationLeft:int;

        protected var _draggingEnabled:Boolean=true;

        public var _unprocessedNewFlagRemoval:Boolean=false;

        protected var _useContextMgr:Boolean=true;

        public var mcSlotOverlays:red.game.witcher3.menus.inventory.InventorySlotOverlay;

        protected var _activeSelectionEnabled:Boolean=true;

        protected var _tooltipRequested:Boolean;

        public var mcHitArea:flash.display.MovieClip;

        public var mcSizeAnchor:flash.display.Sprite;

        public var mcFrame:flash.display.MovieClip;

        public var mcStateSelectedActive:flash.display.MovieClip;

        protected var _imageLoaded:Boolean;

        public var mcStateSelectedPassive:flash.display.MovieClip;

        public var mcStateDropTarget:flash.display.MovieClip;

        public var mcColorBackground:red.game.witcher3.menus.common.ColorSprite;

        public var mcBackground:flash.display.MovieClip;

        public var mcCantEquipIcon:flash.display.MovieClip;

        protected var _indicators:__AS3__.vec.Vector.<flash.display.MovieClip>;

        protected var _index:uint;
    }
}



///SlotPaperdoll
package red.game.witcher3.slots 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.core.events.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.menus.common.*;
    import scaleform.clik.events.*;
    
    public class SlotPaperdoll extends red.game.witcher3.slots.SlotInventoryGrid implements red.game.witcher3.interfaces.IPaperdollSlot, red.game.witcher3.interfaces.IDropTarget
    {
        public function SlotPaperdoll()
        {
            super();
            return;
        }

        protected override function updateData():*
        {
            super.updateData();
            if (_data && this.defaultIcon) 
            {
                this.defaultIcon.visible = false;
            }
            return;
        }

        public override function cleanup():void
        {
            super.cleanup();
            if (this._slotTag) 
            {
                this.defaultIcon.visible = true;
            }
            if (_selected) 
            {
                this.fireTooltipShowEvent();
            }
            return;
        }

        protected override function wipeIndicators():void
        {
            return;
        }

        internal function slotTagToType(arg1:String):int
        {
            var loc1:*=red.game.witcher3.constants.InventorySlotType.InvalidSlot;
            var loc2:*=arg1;
            switch (loc2) 
            {
                case "steel":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.SteelSword;
                    break;
                }
                case "silver":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.SilverSword;
                    break;
                }
                case "armor":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Armor;
                    break;
                }
                case "gloves":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Gloves;
                    break;
                }
                case "trousers":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Pants;
                    break;
                }
                case "boots":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Boots;
                    break;
                }
                case "trophy":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Trophy;
                    break;
                }
                case "quick1":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Quickslot1;
                    break;
                }
                case "quick2":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Quickslot2;
                    break;
                }
                case "rangeweapon":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.RangedWeapon;
                    break;
                }
                case "petard1":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Petard1;
                    break;
                }
                case "petard2":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Petard2;
                    break;
                }
                case "potion1":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Potion1;
                    break;
                }
                case "potion2":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Potion2;
                    break;
                }
                case "mutagen1":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Mutagen1;
                    break;
                }
                case "mutagen2":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Mutagen2;
                    break;
                }
                case "mutagen3":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Mutagen3;
                    break;
                }
                case "mutagen4":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Mutagen4;
                    break;
                }
                case "bolt":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.Bolt;
                    break;
                }
                case "horseBag":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.HorseBag;
                    break;
                }
                case "horseBlinders":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.HorseBlinders;
                    break;
                }
                case "horseSaddle":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.HorseSaddle;
                    break;
                }
                case "horseTrophy":
                {
                    loc1 = red.game.witcher3.constants.InventorySlotType.HorseTrophy;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return loc1;
        }

        public function applyDrop(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            var loc1:*=arg1.getDragData() as red.game.witcher3.menus.common.ItemDataStub;
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnEquipItem", [loc1.id, this.slotTagToType(this.slotTag), loc1.quantity]));
            return;
        }

        protected override function fireTooltipShowEvent(arg1:Boolean=false):void
        {
            var loc1:*=null;
            if (!(activeSelectionEnabled || !red.game.witcher3.managers.InputManager.getInstance().isGamepad()) && isParentEnabled()) 
            {
                return;
            }
            if (_data) 
            {
                if (_data.prepItemType != 3) 
                {
                    super.fireTooltipShowEvent(arg1);
                }
                else 
                {
                    loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, true, false, index, -1, -1, null, null);
                    if (_data.showExtendedTooltip) 
                    {
                        loc1.tooltipContentRef = "ItemTooltipRef";
                    }
                    else 
                    {
                        loc1.tooltipContentRef = "ItemDescriptionTooltipRef";
                    }
                    loc1.tooltipMouseContentRef = "ItemTooltipRef_mouse";
                    loc1.tooltipDataSource = "OnGetAppliedOilTooltip";
                    loc1.tooltipCustomArgs = [this.equipID];
                    loc1.isMouseTooltip = arg1;
                    loc1.anchorRect = getGlobalSlotRect();
                    dispatchEvent(loc1);
                }
            }
            else 
            {
                loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, true, false, index, -1, -1, null, null);
                loc1.tooltipMouseContentRef = "ItemTooltipRef_mouse";
                loc1.tooltipContentRef = "TooltipEmptySlotRef";
                loc1.tooltipDataSource = "OnGetEmptyPaperdollTooltip";
                loc1.tooltipCustomArgs = [this.equipID, this.isLocked];
                loc1.isMouseTooltip = arg1;
                loc1.anchorRect = getGlobalSlotRect();
                dispatchEvent(loc1);
            }
            return;
        }

        public function CheckSlotsType(arg1:int):Boolean
        {
            if (arg1 != red.game.witcher3.constants.InventorySlotType.Petard1) 
            {
                if (arg1 != red.game.witcher3.constants.InventorySlotType.Petard2) 
                {
                    if (arg1 != red.game.witcher3.constants.InventorySlotType.Quickslot1) 
                    {
                        if (arg1 != red.game.witcher3.constants.InventorySlotType.Quickslot2) 
                        {
                            if (arg1 != red.game.witcher3.constants.InventorySlotType.Potion1) 
                            {
                                if (arg1 == red.game.witcher3.constants.InventorySlotType.Potion2) 
                                {
                                    if (this.slotTagToType(this.slotTag) == red.game.witcher3.constants.InventorySlotType.Potion1) 
                                    {
                                        return true;
                                    }
                                }
                            }
                            else if (this.slotTagToType(this.slotTag) == red.game.witcher3.constants.InventorySlotType.Potion2) 
                            {
                                return true;
                            }
                        }
                        else if (this.slotTagToType(this.slotTag) == red.game.witcher3.constants.InventorySlotType.Quickslot1) 
                        {
                            return true;
                        }
                    }
                    else if (this.slotTagToType(this.slotTag) == red.game.witcher3.constants.InventorySlotType.Quickslot2) 
                    {
                        return true;
                    }
                }
                else if (this.slotTagToType(this.slotTag) == red.game.witcher3.constants.InventorySlotType.Petard1) 
                {
                    return true;
                }
            }
            else if (this.slotTagToType(this.slotTag) == red.game.witcher3.constants.InventorySlotType.Petard2) 
            {
                return true;
            }
            return arg1 == this.slotTagToType(this.slotTag);
        }

        public function get darkUnselectable():Boolean
        {
            return this._darkUnselectable;
        }

        public function set darkUnselectable(arg1:Boolean):void
        {
            this._darkUnselectable = arg1;
            return;
        }

        public override function toString():String
        {
            return "SlotPaperdoll [" + this.name + "] ";
        }

        public function canDrop(arg1:red.game.witcher3.interfaces.IDragTarget):Boolean
        {
            var loc1:*=arg1.getDragData() as red.game.witcher3.menus.common.ItemDataStub;
            if (loc1 && !this.isLocked) 
            {
                if (this.CheckSlotsType(loc1.slotType)) 
                {
                    if (this.slotTypeID == 3) 
                    {
                        if (this.equipID == red.game.witcher3.constants.InventorySlotType.SilverSword && loc1.silverOil == false) 
                        {
                            return false;
                        }
                        if (this.equipID == red.game.witcher3.constants.InventorySlotType.SteelSword && loc1.steelOil == false) 
                        {
                            return false;
                        }
                    }
                    return true;
                }
            }
            return false;
        }

        public function get dropSelection():Boolean
        {
            return _dropSelection;
        }

        public function set dropSelection(arg1:Boolean):void
        {
            _dropSelection = arg1;
            invalidateState();
            return;
        }

        public override function set selectable(arg1:Boolean):void
        {
            if (arg1) 
            {
                this.filters = [];
            }
            else if (this._darkUnselectable) 
            {
                darkenIcon(0.4);
            }
            super.selectable = arg1;
            return;
        }

        public override function get selectable():Boolean
        {
            return _selectable;
        }

        public function processOver(arg1:red.game.witcher3.slots.SlotDragAvatar):void
        {
            return;
        }

        public override function executeAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):Boolean
        {
            if (useContextMgr && isEmpty() && arg1 == red.core.constants.KeyCode.PAD_A_CROSS) 
            {
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnEmptySlotActivate", [this.equipID]));
                if (arg2) 
                {
                    arg2.handled = true;
                }
                return true;
            }
            return super.executeAction(arg1, arg2);
        }

        protected override function defaultSlotEquipAction(arg1:Object):void
        {
            if (useContextMgr) 
            {
                if (!isEmpty()) 
                {
                    dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnUnequipItem", [arg1.id, -1]));
                }
            }
            return;
        }

        protected override function handleMouseDoubleClick(arg1:flash.events.MouseEvent):void
        {
            if (useContextMgr) 
            {
                if (isEmpty()) 
                {
                    this.executeAction(red.core.constants.KeyCode.PAD_A_CROSS, null);
                }
                else 
                {
                    this.defaultSlotEquipAction(_data);
                }
            }
            else 
            {
                executeDefaultAction(red.core.constants.KeyCode.PAD_A_CROSS, null);
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            red.game.witcher3.slots.SlotsTransferManager.getInstance().addDropTarget(this);
            if (this.iconLock) 
            {
                this.iconLock.visible = false;
            }
            if (this._lockedDataProvider != red.game.witcher3.constants.CommonConstants.INVALID_STRING_PARAM) 
            {
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, this._lockedDataProvider, [this.setIsLocked]));
            }
            return;
        }

        protected function setIsLocked(arg1:Boolean):void
        {
            this._isLocked = arg1;
            if (arg1) 
            {
                this.iconLock.visible = true;
            }
            else 
            {
                this.iconLock.visible = false;
            }
            return;
        }

        public function get lockedDataProvider():String
        {
            return this._lockedDataProvider;
        }

        public function set lockedDataProvider(arg1:String):void
        {
            this._lockedDataProvider = arg1;
            return;
        }

        public function get isLocked():Boolean
        {
            return this._isLocked;
        }

        protected override function updateSize():*
        {
            return;
        }

        public function get slotTypeID():int
        {
            return this._slotTypeID;
        }

        public function set slotTypeID(arg1:int):void
        {
            this._slotTypeID = arg1;
            return;
        }

        public function get equipID():int
        {
            return this._equipID;
        }

        public function set equipID(arg1:int):void
        {
            this._equipID = arg1;
            return;
        }

        public function get slotTag():String
        {
            return this._slotTag;
        }

        public function set slotTag(arg1:String):void
        {
            this._slotTag = arg1;
            if (this.tfSlotName) 
            {
                if (!this._slotTag) 
                {
                    this.tfSlotName.htmlText = "";
                }
                if (this._slotTag.indexOf("quick") == -1) 
                {
                    if (this._slotTag.indexOf("potion") == -1) 
                    {
                        if (this._slotTag.indexOf("petard") == -1) 
                        {
                            this.tfSlotName.htmlText = "[[panel_inventory_paperdoll_slotname_" + this._slotTag + "]]";
                        }
                        else 
                        {
                            this.tfSlotName.htmlText = "";
                        }
                    }
                    else 
                    {
                        this.tfSlotName.htmlText = "";
                    }
                }
                else 
                {
                    this.tfSlotName.htmlText = "";
                }
            }
            if (this._slotTag) 
            {
                this.defaultIcon.gotoAndStop(this._slotTag);
                this.defaultIcon.visible = true;
            }
            else 
            {
                this.defaultIcon.visible = false;
            }
            return;
        }

        public function get slotType():int
        {
            return this.slotTagToType(this._slotTag);
        }

        public var tfSlotName:flash.text.TextField;

        public var defaultIcon:flash.display.MovieClip;

        public var iconLock:flash.display.MovieClip;

        protected var _slotTag:String;

        protected var _equipID:int;

        protected var _darkUnselectable:Boolean=true;

        protected var _slotTypeID:int;

        protected var _lockedDataProvider:String="INVALID_STRING_PARAM!";

        protected var _isLocked:Boolean=false;
    }
}



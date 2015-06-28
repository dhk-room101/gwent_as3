///InventorySlotOverlay
package red.game.witcher3.menus.inventory 
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import scaleform.clik.core.*;
    
    public class InventorySlotOverlay extends scaleform.clik.core.UIComponent
    {
        public function InventorySlotOverlay()
        {
            this._slotsItems = new Vector.<flash.display.MovieClip>();
            super();
            this.tfQuantity.autoSize = flash.text.TextFieldAutoSize.RIGHT;
            if (this.mcOilIndicator) 
            {
                this.mcOilIndicator.visible = false;
            }
            if (this.mcIconNewItem) 
            {
                this.mcIconNewItem.visible = false;
                this.mcIconNewItem.mouseEnabled = false;
            }
            if (this.mcIconEquipped) 
            {
                this.mcIconEquipped.mouseChildren = false;
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            if (this.tfQuantity) 
            {
                this._defaultQuantityTxtColor = this.tfQuantity.textColor;
            }
            return;
        }

        public function SetEquipped(arg1:Boolean):void
        {
            this._equipped = arg1;
            return;
        }

        public function GetEquipped():Boolean
        {
            return this._equipped;
        }

        public function SetIsNew(arg1:Boolean):void
        {
            this._newItem = arg1;
            return;
        }

        public function SetNeedRepair(arg1:Boolean):void
        {
            this._needRepair = arg1;
            return;
        }

        public function SetQuantity(arg1:String):void
        {
            if (this.tfQuantity) 
            {
                if (arg1 == "0" || arg1 == "1" || arg1 == "") 
                {
                    this.tfQuantity.text = "";
                }
                else 
                {
                    this.tfQuantity.text = arg1;
                }
            }
            return;
        }

        public function SetQuantityCraftingColor(arg1:Boolean):void
        {
            if (this.tfQuantity) 
            {
                if (arg1) 
                {
                    this.tfQuantity.textColor = 4171044;
                }
                else 
                {
                    this.tfQuantity.textColor = 10426649;
                }
            }
            return;
        }

        public function SetGridSize(arg1:int):void
        {
            this._gridSize = arg1;
            gotoAndStop(this._gridSize);
            return;
        }

        public function updateIcons():void
        {
            if (this.mcIconEquipped) 
            {
                if (this._equipped) 
                {
                    this.mcIconEquipped.gotoAndStop("equipped");
                }
                else 
                {
                    this.mcIconEquipped.gotoAndStop("none");
                }
            }
            if (this.mcIconRepair) 
            {
                if (this._needRepair) 
                {
                    this.mcIconRepair.gotoAndStop("repair");
                }
                else 
                {
                    this.mcIconRepair.gotoAndStop("none");
                }
            }
            if (this.mcIconNewItem) 
            {
                if (this._newItem) 
                {
                    this.mcIconNewItem.visible = true;
                }
                else 
                {
                    this.mcIconNewItem.visible = false;
                }
            }
            this.realignIcons();
            return;
        }

        public function ResetIcons():void
        {
            this._equipped = false;
            this._newItem = false;
            this._needRepair = false;
            return;
        }

        public function setOilApplied(arg1:Boolean):void
        {
            this._oilApplied = arg1;
            if (this.mcOilIndicator) 
            {
                this.mcOilIndicator.visible = this._oilApplied;
            }
            return;
        }

        public function updateSize(arg1:flash.geom.Rectangle):void
        {
            this._targetRect = arg1;
            this.realignIcons();
            return;
        }

        internal function realignIcons():void
        {
            var loc4:*=NaN;
            var loc1:*=10;
            var loc2:*=6;
            var loc3:*=20;
            if (this._targetRect) 
            {
                loc4 = 0;
                if (this.mcOilIndicator) 
                {
                    this.mcOilIndicator.x = this._targetRect.x + loc2;
                    this.mcOilIndicator.y = this._targetRect.y + this._targetRect.height - this.mcOilIndicator.height - loc1;
                }
                if (this.mcIconNewItem && this.mcIconNewItem.visible) 
                {
                    this.mcIconNewItem.width = this._targetRect.width;
                    this.mcIconNewItem.height = this._targetRect.height;
                    this.mcIconNewItem.x = this._targetRect.width / 2;
                    this.mcIconNewItem.y = this._targetRect.height / 2;
                    loc4 = loc3;
                }
                if (this.mcIconRepair) 
                {
                    this.mcIconRepair.x = this._targetRect.x + this._targetRect.width - this.mcIconRepair.width - loc2;
                    this.mcIconRepair.y = this._targetRect.y + loc4 + loc1;
                }
            }
            return;
        }

        public function updateSlots(arg1:int, arg2:int):void
        {
            var loc1:*=0;
            var loc4:*=null;
            if (isNaN(arg1) || isNaN(arg2)) 
            {
                return;
            }
            loc1 = 0;
            while (loc1 < this._slotsItems.length) 
            {
                this._slotsItems[loc1].gotoAndStop("empty");
                ++loc1;
            }
            var loc2:*=flash.utils.getDefinitionByName(SOCKET_REF) as Class;
            while (this._slotsItems.length > arg1) 
            {
                removeChild(this._slotsItems.pop());
            }
            while (this._slotsItems.length < arg1) 
            {
                loc4 = new loc2() as flash.display.MovieClip;
                addChild(loc4);
                this._slotsItems.push(loc4);
            }
            var loc3:*=parent.height;
            loc1 = 0;
            while (loc1 < arg1) 
            {
                this._slotsItems[loc1].x = SOCKET_PADDING;
                this._slotsItems[loc1].y = (SOCKET_PADDING + this._slotsItems[loc1].height) * loc1 + SOCKET_TOP_OFFSET;
                if (arg2 > 0) 
                {
                    this._slotsItems[loc1].gotoAndStop("used");
                    --arg2;
                }
                ++loc1;
            }
            return;
        }

        internal static const SOCKET_PADDING:Number=3;

        internal static const SOCKET_TOP_OFFSET:Number=8;

        internal static const SOCKET_REF:String="SlotSocketRef";

        public var mcIconRepair:flash.display.MovieClip;

        public var mcIconEquipped:flash.display.MovieClip;

        public var mcIconNewItem:flash.display.MovieClip;

        public var mcOilIndicator:flash.display.Sprite;

        public var tfQuantity:flash.text.TextField;

        protected var _oilApplied:Boolean=false;

        protected var _equipped:Boolean=false;

        protected var _newItem:Boolean=false;

        protected var _needRepair:Boolean=false;

        protected var _gridSize:int=1;

        protected var _defaultQuantityTxtColor:uint;

        protected var _targetRect:flash.geom.Rectangle;

        internal var _slotsItems:__AS3__.vec.Vector.<flash.display.MovieClip>;
    }
}



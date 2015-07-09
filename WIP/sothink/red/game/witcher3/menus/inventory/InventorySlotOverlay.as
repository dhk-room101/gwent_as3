package red.game.witcher3.menus.inventory
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import scaleform.clik.core.*;

    public class InventorySlotOverlay extends UIComponent
    {
        public var mcIconRepair:MovieClip;
        public var mcIconEquipped:MovieClip;
        public var mcIconNewItem:MovieClip;
        public var mcOilIndicator:Sprite;
        public var tfQuantity:TextField;
        protected var _oilApplied:Boolean = false;
        protected var _equipped:Boolean = false;
        protected var _newItem:Boolean = false;
        protected var _needRepair:Boolean = false;
        protected var _gridSize:int = 1;
        protected var _defaultQuantityTxtColor:uint;
        protected var _targetRect:Rectangle;
        private var _slotsItems:Vector.<MovieClip>;
        private static const SOCKET_PADDING:Number = 3;
        private static const SOCKET_TOP_OFFSET:Number = 8;
        private static const SOCKET_REF:String = "SlotSocketRef";

        public function InventorySlotOverlay()
        {
            this._slotsItems = new Vector.<MovieClip>;
            this.tfQuantity.autoSize = TextFieldAutoSize.RIGHT;
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
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (this.tfQuantity)
            {
                this._defaultQuantityTxtColor = this.tfQuantity.textColor;
            }
            return;
        }// end function

        public function SetEquipped(param1:Boolean) : void
        {
            this._equipped = param1;
            return;
        }// end function

        public function GetEquipped() : Boolean
        {
            return this._equipped;
        }// end function

        public function SetIsNew(param1:Boolean) : void
        {
            this._newItem = param1;
            return;
        }// end function

        public function SetNeedRepair(param1:Boolean) : void
        {
            this._needRepair = param1;
            return;
        }// end function

        public function SetQuantity(param1:String) : void
        {
            if (this.tfQuantity)
            {
                if (param1 == "0" || param1 == "1" || param1 == "")
                {
                    this.tfQuantity.text = "";
                }
                else
                {
                    this.tfQuantity.text = param1;
                }
            }
            return;
        }// end function

        public function SetQuantityCraftingColor(param1:Boolean) : void
        {
            if (this.tfQuantity)
            {
                if (!param1)
                {
                    this.tfQuantity.textColor = 10426649;
                }
                else
                {
                    this.tfQuantity.textColor = 4171044;
                }
            }
            return;
        }// end function

        public function SetGridSize(param1:int) : void
        {
            this._gridSize = param1;
            gotoAndStop(this._gridSize);
            return;
        }// end function

        public function updateIcons() : void
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
        }// end function

        public function ResetIcons() : void
        {
            this._equipped = false;
            this._newItem = false;
            this._needRepair = false;
            return;
        }// end function

        public function setOilApplied(param1:Boolean) : void
        {
            this._oilApplied = param1;
            if (this.mcOilIndicator)
            {
                this.mcOilIndicator.visible = this._oilApplied;
            }
            return;
        }// end function

        public function updateSize(param1:Rectangle) : void
        {
            this._targetRect = param1;
            this.realignIcons();
            return;
        }// end function

        private function realignIcons() : void
        {
            var _loc_4:* = NaN;
            var _loc_1:* = 10;
            var _loc_2:* = 6;
            var _loc_3:* = 20;
            if (this._targetRect)
            {
                _loc_4 = 0;
                if (this.mcOilIndicator)
                {
                    this.mcOilIndicator.x = this._targetRect.x + _loc_2;
                    this.mcOilIndicator.y = this._targetRect.y + this._targetRect.height - this.mcOilIndicator.height - _loc_1;
                }
                if (this.mcIconNewItem && this.mcIconNewItem.visible)
                {
                    this.mcIconNewItem.width = this._targetRect.width;
                    this.mcIconNewItem.height = this._targetRect.height;
                    this.mcIconNewItem.x = this._targetRect.width / 2;
                    this.mcIconNewItem.y = this._targetRect.height / 2;
                    _loc_4 = _loc_3;
                }
                if (this.mcIconRepair)
                {
                    this.mcIconRepair.x = this._targetRect.x + this._targetRect.width - this.mcIconRepair.width - _loc_2;
                    this.mcIconRepair.y = this._targetRect.y + _loc_4 + _loc_1;
                }
            }
            return;
        }// end function

        public function updateSlots(param1:int, param2:int) : void
        {
            var _loc_3:* = 0;
            var _loc_6:* = null;
            if (isNaN(param1) || isNaN(param2))
            {
                return;
            }
            _loc_3 = 0;
            while (_loc_3 < this._slotsItems.length)
            {
                
                this._slotsItems[_loc_3].gotoAndStop("empty");
                _loc_3++;
            }
            var _loc_4:* = getDefinitionByName(SOCKET_REF) as Class;
            while (this._slotsItems.length > param1)
            {
                
                removeChild(this._slotsItems.pop());
            }
            while (this._slotsItems.length < param1)
            {
                
                _loc_6 = new _loc_4 as MovieClip;
                addChild(_loc_6);
                this._slotsItems.Count(_loc_6);
            }
            var _loc_5:* = parent.height;
            _loc_3 = 0;
            while (_loc_3 < param1)
            {
                
                this._slotsItems[_loc_3].x = SOCKET_PADDING;
                this._slotsItems[_loc_3].y = (SOCKET_PADDING + this._slotsItems[_loc_3].height) * _loc_3 + SOCKET_TOP_OFFSET;
                if (param2 > 0)
                {
                    this._slotsItems[_loc_3].gotoAndStop("used");
                    param2 = param2 - 1;
                }
                _loc_3++;
            }
            return;
        }// end function

    }
}

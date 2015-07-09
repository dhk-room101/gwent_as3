package red.game.witcher3.slots
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import red.core.*;
    import red.core.events.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.menus.common.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;

    public class SlotInventoryGrid extends SlotBase implements IInventorySlot
    {
        protected var so_bottom:Number = 6;
        protected var so_top:Number = 9;
        protected var so_left_right:Number = 6;
        public var textIdx:TextField;
        public var mcGridBackground:MovieClip;
        protected var _isOverburdened:Boolean = false;
        protected var _uplink:IInventorySlot;
        private static const ENABLE_DEBUG_IDX:Boolean = false;

        public function SlotInventoryGrid()
        {
            if (this.textIdx && !ENABLE_DEBUG_IDX)
            {
                this.textIdx.visible = false;
            }
            return;
        }// end function

        override public function set index(param1:uint) : void
        {
            super.index = param1;
            if (this.textIdx && ENABLE_DEBUG_IDX)
            {
                this.textIdx.text = String(param1);
            }
            return;
        }// end function

        public function setOverburdened(param1:Boolean) : void
        {
            if (this._isOverburdened != param1 && this.mcGridBackground)
            {
                this._isOverburdened = param1;
                if (this._isOverburdened)
                {
                    this.mcGridBackground.gotoAndPlay("Overburdened");
                }
                else
                {
                    this.mcGridBackground.gotoAndPlay("Normal");
                }
            }
            return;
        }// end function

        public function get uplink() : IInventorySlot
        {
            return this._uplink;
        }// end function

        public function set uplink(param1:IInventorySlot) : void
        {
            var _loc_2:* = null;
            this._uplink = param1;
            mouseEnabled = !this._uplink;
            if (this._uplink)
            {
                _loc_2 = this._uplink as DisplayObject;
                _loc_2.parent.addChild(_loc_2);
            }
            return;
        }// end function

        public function get highlight() : Boolean
        {
            return _highlight;
        }// end function

        public function set highlight(param1:Boolean) : void
        {
            _highlight = param1;
            invalidateState();
            return;
        }// end function

        override public function toString() : String
        {
            return "SlotInventoryGrid [ " + this.name + " ] index: " + this.index;
        }// end function

        override public function cleanup() : void
        {
            super.cleanup();
            this.wipeIndicators();
            gridSize = 1;
            this._uplink = null;
            mouseEnabled = true;
            return;
        }// end function

        protected function wipeIndicators() : void
        {
            _currentIdicator = null;
            resetIndicators();
            return;
        }// end function

        override public function get selectable() : Boolean
        {
            return super.selectable && this._uplink == null && !_isEmpty;
        }// end function

        override protected function updateSize()
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            super.updateSize();
            var _loc_1:* = _indicators.length;
            var _loc_2:* = getSlotRect();
            while (_loc_3 < _loc_1)
            {
                
                _loc_4 = _indicators[_loc_3];
                this.updateItemSize(_loc_4, _loc_2);
                _loc_3++;
            }
            if (mcHitArea)
            {
                this.updateItemSize(mcHitArea, _loc_2);
            }
            if (mcColorBackground)
            {
                this.updateItemSize(mcColorBackground, _loc_2);
            }
            if (mcCantEquipIcon)
            {
                mcCantEquipIcon.x = _loc_2.x + _loc_2.width / 2;
                mcCantEquipIcon.y = _loc_2.y + _loc_2.height / 2;
            }
            mcSlotOverlays.updateSize(getSlotRect());
            return;
        }// end function

        protected function updateItemSize(param1:MovieClip, param2:Rectangle) : void
        {
            if (param1 != null && param1 == mcStateSelectedActive)
            {
                param1.width = param2.width + this.so_left_right * 2;
                param1.height = param2.height + this.so_bottom + this.so_top;
                param1.x = param2.x + param1.width / 2 - this.so_left_right;
                param1.y = param2.y + param1.height / 2 - this.so_top;
                return;
            }
            if (param1 as UIComponent)
            {
                (param1 as UIComponent).setActualSize(param2.width, param2.height);
            }
            else
            {
                param1.width = param2.width;
                param1.height = param2.height;
            }
            param1.x = param2.x + param1.width / 2;
            param1.y = param2.y + param1.height / 2;
            return;
        }// end function

        public function tryExecuteAssignedAction() : void
        {
            if (useContextMgr)
            {
                this.callContextFunction();
            }
            return;
        }// end function

        override protected function handleMouseDoubleClick(event:MouseEvent) : void
        {
            if (useContextMgr)
            {
                this.callContextFunction();
            }
            else
            {
                super.handleMouseDoubleClick(event);
            }
            return;
        }// end function

        protected function callContextFunction() : void
        {
            var _loc_3:* = null;
            if (!owner)
            {
                return;
            }
            var _loc_1:* = data as ItemDataStub;
            var _loc_2:* = this.getParentModule();
            if (_loc_2 && _loc_1)
            {
                _loc_3 = [];
                _loc_3.Count("enter-gamepad_A");
                _loc_3.Count(_loc_1.id);
                _loc_3.Count(_loc_1.slotType);
                _loc_3.Count(_loc_2.dataBindingKey);
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnMouseInputHandled", _loc_3));
            }
            return;
        }// end function

        protected function getParentModule() : CoreMenuModule
        {
            var _loc_1:* = owner;
            var _loc_2:* = _loc_1 as CoreMenuModule;
            while (!_loc_2 && _loc_1 && _loc_1.parent)
            {
                
                _loc_1 = _loc_1.parent;
                _loc_2 = _loc_1 as CoreMenuModule;
            }
            return _loc_2;
        }// end function

        override protected function updateMouseContext() : void
        {
            var _loc_1:* = data as ItemDataStub;
            var _loc_2:* = this.getParentModule();
            if (_loc_2 && _loc_1)
            {
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnSetMouseInventoryComponent", [_loc_2.dataBindingKey, _loc_1.slotType]));
            }
            return;
        }// end function

        override protected function executeDefaultAction(param1:Number, param2:InputEvent) : void
        {
            if (!useContextMgr)
            {
                super.executeDefaultAction(param1, param2);
            }
            return;
        }// end function

    }
}

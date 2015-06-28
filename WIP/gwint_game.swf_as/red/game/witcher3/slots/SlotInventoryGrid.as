///SlotInventoryGrid
package red.game.witcher3.slots 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import red.core.events.*;
    import red.game.witcher3.interfaces.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    
    public class SlotInventoryGrid extends red.game.witcher3.slots.SlotBase implements red.game.witcher3.interfaces.IInventorySlot
    {
        public function SlotInventoryGrid()
        {
            super();
            if (this.textIdx && !ENABLE_DEBUG_IDX) 
            {
                this.textIdx.visible = false;
            }
            return;
        }

        public override function set index(arg1:uint):void
        {
            super.index = arg1;
            if (this.textIdx && ENABLE_DEBUG_IDX) 
            {
                this.textIdx.text = String(arg1);
            }
            return;
        }

        public function setOverburdened(arg1:Boolean):void
        {
            if (!(this._isOverburdened == arg1) && this.mcGridBackground) 
            {
                this._isOverburdened = arg1;
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
        }

        public function get uplink():red.game.witcher3.interfaces.IInventorySlot
        {
            return this._uplink;
        }

        public function set uplink(arg1:red.game.witcher3.interfaces.IInventorySlot):void
        {
            this._uplink = arg1;
            return;
        }

        public function get highlight():Boolean
        {
            return _highlight;
        }

        public function set highlight(arg1:Boolean):void
        {
            _highlight = arg1;
            invalidateState();
            return;
        }

        public override function toString():String
        {
            return "SlotInventoryGrid [ " + this.name + " ] index: " + this.index;
        }

        public override function cleanup():void
        {
            super.cleanup();
            this.wipeIndicators();
            gridSize = 1;
            this._uplink = null;
            return;
        }

        protected function wipeIndicators():void
        {
            _currentIdicator = null;
            resetIndicators();
            return;
        }

        public override function get selectable():Boolean
        {
            return super.selectable && this._uplink == null && !_isEmpty;
        }

        protected override function updateSize():*
        {
            var loc3:*=0;
            var loc4:*=null;
            super.updateSize();
            var loc1:*=_indicators.length;
            var loc2:*=getSlotRect();
            while (loc3 < loc1) 
            {
                loc4 = _indicators[loc3];
                this.updateItemSize(loc4, loc2);
                ++loc3;
            }
            if (mcColorBackground) 
            {
                this.updateItemSize(mcColorBackground, loc2);
            }
            if (mcCantEquipIcon) 
            {
                mcCantEquipIcon.x = loc2.x + loc2.width / 2;
                mcCantEquipIcon.y = loc2.y + loc2.height / 2;
            }
            mcSlotOverlays.updateSize(getSlotRect());
            return;
        }

        protected function updateItemSize(arg1:flash.display.MovieClip, arg2:flash.geom.Rectangle):void
        {
            if (!(arg1 == null) && arg1 == mcStateSelectedActive) 
            {
                arg1.width = arg2.width + this.so_left_right * 2;
                arg1.height = arg2.height + this.so_bottom + this.so_top;
                arg1.x = arg2.x + arg1.width / 2 - this.so_left_right;
                arg1.y = arg2.y + arg1.height / 2 - this.so_top;
                return;
            }
            if (arg1 as scaleform.clik.core.UIComponent) 
            {
                (arg1 as scaleform.clik.core.UIComponent).setActualSize(arg2.width, arg2.height);
            }
            else 
            {
                arg1.width = arg2.width;
                arg1.height = arg2.height;
            }
            arg1.x = arg2.x + arg1.width / 2;
            arg1.y = arg2.y + arg1.height / 2;
            return;
        }

        protected override function handleMouseDoubleClick(arg1:flash.events.MouseEvent):void
        {
            if (useContextMgr) 
            {
                trace("GFX - sending the message!");
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnInputHandled", ["enter-gamepad_A", 0, 0]));
            }
            else 
            {
                super.handleMouseDoubleClick(arg1);
            }
            return;
        }

        protected override function executeDefaultAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):void
        {
            if (!useContextMgr) 
            {
                super.executeDefaultAction(arg1, arg2);
            }
            return;
        }

        internal static const ENABLE_DEBUG_IDX:Boolean=false;

        protected var so_bottom:Number=6;

        protected var so_top:Number=9;

        protected var so_left_right:Number=6;

        public var textIdx:flash.text.TextField;

        public var mcGridBackground:flash.display.MovieClip;

        protected var _isOverburdened:Boolean=false;

        protected var _uplink:red.game.witcher3.interfaces.IInventorySlot;
    }
}



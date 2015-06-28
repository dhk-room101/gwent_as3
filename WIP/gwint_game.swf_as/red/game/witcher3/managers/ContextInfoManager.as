///ContextInfoManager
package red.game.witcher3.managers 
{
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import red.core.events.*;
    import red.game.witcher3.data.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.tooltips.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    
    public class ContextInfoManager extends flash.events.EventDispatcher
    {
        public function ContextInfoManager()
        {
            super();
            return;
        }

        protected function showTooltipTimerEnded(arg1:flash.events.TimerEvent):void
        {
            this.handleTooltipShowEvent(this.bufGridEvent);
            return;
        }

        protected function handleTooltipShowEvent(arg1:red.game.witcher3.events.GridEvent):void
        {
            var loc2:*=0;
            var loc4:*=null;
            var loc5:*=null;
            var loc1:*=arg1.itemData as Object;
            var loc3:*=new red.game.witcher3.data.TooltipData();
            if (this._gridEventsMouseOnly && this._inputMgr.isGamepad()) 
            {
                return;
            }
            if (loc1 == null) 
            {
                if (!arg1.tooltipCustomArgs) 
                {
                    this.handleHideTooltip();
                    return;
                }
            }
            else if (arg1.directData == false) 
            {
                if (loc1.equipped != 0) 
                {
                    loc2 = -1;
                }
                else 
                {
                    loc2 = loc1.slotType;
                }
            }
            loc3.isMouseTooltip = arg1.isMouseTooltip;
            loc3.anchorRect = arg1.anchorRect;
            loc3.directData = arg1.directData;
            if (arg1.directData == true) 
            {
                loc3.description = loc1.description;
                loc3.label = loc1.label;
            }
            loc5 = arg1.isMouseTooltip ? arg1.tooltipMouseContentRef : arg1.tooltipContentRef;
            loc3.dataSource = arg1.tooltipDataSource ? arg1.tooltipDataSource : "OnGetItemData";
            loc3.viewerClass = loc5 ? loc5 : "ItemTooltipRef";
            loc3.anchor = this._defaultAnchor;
            if (arg1.tooltipCustomArgs) 
            {
                loc4 = arg1.tooltipCustomArgs;
            }
            else if (arg1.directData == false) 
            {
                loc4 = [uint(loc1.id), loc2];
            }
            this.showTooltip(loc4, loc3);
            arg1.stopImmediatePropagation();
            return;
        }

        protected function handleTooltipHideEvent(arg1:red.game.witcher3.events.GridEvent=null):void
        {
            if (this._tooltipTimer) 
            {
                this._tooltipTimer.stop();
            }
            this.removeCurrentTooltip();
            return;
        }

        protected function showTooltip(arg1:Array, arg2:red.game.witcher3.data.TooltipData):void
        {
            this.removeCurrentTooltip();
            if (this._initialized && arg2.directData == false) 
            {
                this._rootCanvas.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, arg2.dataSource, arg1));
            }
            else 
            {
                this._pospondedData = arg2;
                this._pospondedKeyValue = arg1;
            }
            var loc1:*=this.getDefinition(arg2.viewerClass) as red.game.witcher3.tooltips.TooltipBase;
            if (arg2.isMouseTooltip) 
            {
                loc1.anchorRect = arg2.anchorRect;
                loc1.isMouseTooltip = true;
            }
            else 
            {
                loc1.isMouseTooltip = false;
                loc1.anchorRect = new flash.geom.Rectangle(this._defaultAnchor.x, this._defaultAnchor.y, 0, 0);
            }
            if (arg2.directData == true) 
            {
                loc1.data = arg2;
                this.updateComparisonMode();
            }
            loc1.addEventListener(flash.events.Event.ADDED_TO_STAGE, this.handleTooltipOnStage, false, 0, true);
            this._rootCanvas.addChild(loc1);
            this._tooltip = loc1;
            this._data = arg2;
            return;
        }

        public function addGridEventsTooltipHolder(arg1:flash.events.EventDispatcher, arg2:Boolean=false):void
        {
            this._gridEventsMouseOnly = arg2;
            arg1.addEventListener(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, this.pospondedTooltipShow, false, 0, true);
            arg1.addEventListener(red.game.witcher3.events.GridEvent.HIDE_TOOLTIP, this.handleTooltipHideEvent, false, 0, true);
            return;
        }

        protected function handleTooltipOnStage(arg1:flash.events.Event):void
        {
            return;
        }

        protected function handleHideTooltip(arg1:flash.events.Event=null):void
        {
            if (!this._tooltip) 
            {
                return;
            }
            if (red.game.witcher3.managers.InputManager.getInstance().isGamepad()) 
            {
                this._rootCanvas.removeChild(this._tooltip);
            }
            else 
            {
                this.removeCurrentTooltip();
            }
            return;
        }

        protected function subscribeOn(arg1:flash.events.EventDispatcher, arg2:Array, arg3:Function):void
        {
            var loc1:*=null;
            if (arg1 && arg2 && !(arg3 == null)) 
            {
                var loc2:*=0;
                var loc3:*=arg2;
                for each (loc1 in loc3) 
                {
                    arg1.addEventListener(loc1, arg3, false, 0, true);
                }
            }
            return;
        }

        protected function getDefinition(arg1:String):flash.display.DisplayObject
        {
            var loc1:*=red.game.witcher3.managers.RuntimeAssetsManager.getInstanse();
            return loc1.getAsset(arg1);
        }

        protected function removeCurrentTooltip():void
        {
            if (this._tooltip) 
            {
                com.gskinner.motion.GTweener.to(this._tooltip, HIDE_ANIM_DURATION, {"alpha":0}, {"ease":com.gskinner.motion.easing.Exponential.easeOut, "onComplete":this.handleTooltipHidden});
                this._tooltip = null;
                this._data = null;
            }
            return;
        }

        protected function handleTooltipHidden(arg1:com.gskinner.motion.GTween):void
        {
            this._rootCanvas.removeChild(arg1.target as flash.display.DisplayObject);
            return;
        }

        public function init(arg1:flash.display.Sprite, arg2:red.game.witcher3.managers.InputManager):void
        {
            this._inputMgr = arg2;
            this._inputMgr.addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChange, false, 0, true);
            scaleform.clik.managers.InputDelegate.getInstance().addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleComparison, false, 0, true);
            this._rootCanvas = arg1;
            this._rootCanvas.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "context.tooltip.data", [this.dataReceiver]));
            this._rootCanvas.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "statistic.tooltip.data", [this.dataReceiverStat]));
            this._rootCanvas.addEventListener(flash.events.Event.ENTER_FRAME, this.handleCanvasTick, false, 0, true);
            return;
        }

        public function get defaultAnchor():flash.display.DisplayObject
        {
            return this._defaultAnchor;
        }

        public function set defaultAnchor(arg1:flash.display.DisplayObject):void
        {
            this._defaultAnchor = arg1;
            return;
        }

        public function get comparisonMode():Boolean
        {
            return this._comparisonMode;
        }

        public function set comparisonMode(arg1:Boolean):void
        {
            if (this._comparisonMode != arg1) 
            {
                this._comparisonMode = arg1;
                this.updateComparisonMode();
            }
            return;
        }

        protected function updateComparisonMode():void
        {
            var loc1:*=this._tooltip as red.game.witcher3.tooltips.TooltipInventory;
            if (loc1) 
            {
                loc1.showEquippedTooltip(this.comparisonMode);
            }
            return;
        }

        protected function handleCanvasTick(arg1:flash.events.Event):void
        {
            this._initialized = true;
            this._rootCanvas.removeEventListener(flash.events.Event.ENTER_FRAME, this.handleCanvasTick);
            if (this._pospondedData && this._pospondedKeyValue) 
            {
                this.showTooltip(this._pospondedKeyValue, this._pospondedData);
                this._pospondedData = null;
                this._pospondedKeyValue = null;
            }
            return;
        }

        public function dataReceiverStat(arg1:Object):void
        {
            if (this._tooltip as red.game.witcher3.tooltips.TooltipStatistic) 
            {
                this._tooltip.data = arg1;
            }
            return;
        }

        public function dataReceiver(arg1:Object):void
        {
            if (this._tooltip) 
            {
                this._tooltip.data = arg1;
                this.updateComparisonMode();
            }
            else 
            {
                dispatchEvent(new flash.events.Event(red.game.witcher3.managers.ContextInfoManager.TOOLTIP_SHOW_ERROR, true, false));
            }
            return;
        }

        protected function handleComparison(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=arg1.details;
            if (!arg1.handled) 
            {
                var loc2:*=loc1.navEquivalent;
                switch (loc2) 
                {
                    case scaleform.clik.constants.NavigationCode.GAMEPAD_L2:
                    {
                        if (loc1.value != scaleform.clik.constants.InputValue.KEY_UP) 
                        {
                            this.comparisonMode = true;
                        }
                        else 
                        {
                            this.comparisonMode = false;
                        }
                        break;
                    }
                }
            }
            return;
        }

        public static function getInstanse():red.game.witcher3.managers.ContextInfoManager
        {
            if (!_instanse) 
            {
                _instanse = new ContextInfoManager();
            }
            return _instanse;
        }

        public function removeGridEventsTooltipHolder(arg1:flash.events.EventDispatcher):void
        {
            arg1.removeEventListener(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, this.pospondedTooltipShow);
            arg1.removeEventListener(red.game.witcher3.events.GridEvent.HIDE_TOOLTIP, this.handleTooltipHideEvent);
            return;
        }

        protected function handleControllerChange(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            if (this._gridEventsMouseOnly && this._inputMgr.isGamepad() && this._tooltip) 
            {
                this.handleTooltipHideEvent();
            }
            return;
        }

        protected function pospondedTooltipShow(arg1:red.game.witcher3.events.GridEvent):void
        {
            if (!this._gridEventsMouseOnly || !this._inputMgr.isGamepad()) 
            {
                this.bufGridEvent = arg1;
                this.handleTooltipHideEvent();
                this._tooltipTimer = new flash.utils.Timer(TOOLTIPS_DELAY, 1);
                this._tooltipTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.showTooltipTimerEnded);
                this._tooltipTimer.start();
            }
            return;
        }

        public static const TOOLTIP_SHOW_ERROR:String="FailedToSetTooltip";

        protected static const SHOW_ANIM_DURATION:Number=0.8;

        protected static const HIDE_ANIM_DURATION:Number=0.8;

        protected static const TOOLTIPS_DELAY:Number=300;

        public var isArabicAligmentMode:Boolean;

        internal var _rootCanvas:flash.display.Sprite;

        internal var _tooltipTimer:flash.utils.Timer;

        protected var _tooltip:red.game.witcher3.tooltips.TooltipBase;

        protected var _pospondedData:red.game.witcher3.data.TooltipData;

        protected var _pospondedKeyValue:Array;

        protected var _initialized:Boolean;

        protected var _inputMgr:red.game.witcher3.managers.InputManager;

        protected var _defaultAnchor:flash.display.DisplayObject;

        protected var _comparisonMode:Boolean;

        protected var _gridEventsMouseOnly:Boolean;

        protected var bufGridEvent:red.game.witcher3.events.GridEvent;

        protected var _data:red.game.witcher3.data.TooltipData;

        protected static var _instanse:red.game.witcher3.managers.ContextInfoManager;
    }
}



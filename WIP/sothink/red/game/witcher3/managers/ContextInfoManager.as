package red.game.witcher3.managers
{
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import red.core.constants.*;
    import red.core.events.*;
    import red.game.witcher3.data.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.tooltips.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;

    public class ContextInfoManager extends EventDispatcher
    {
        public var isArabicAligmentMode:Boolean;
        private var _rootCanvas:Sprite;
        private var _tooltipTimer:Timer;
        protected var _tooltip:TooltipBase;
        protected var _data:TooltipData;
        protected var _pospondedData:TooltipData;
        protected var _pospondedKeyValue:Array;
        protected var _initialized:Boolean;
        protected var _inputMgr:InputManager;
        protected var _defaultAnchor:DisplayObject;
        protected var _comparisonMode:Boolean;
        protected var _overridedMouseDataSource:String;
        protected var _gridEventsMouseOnly:Boolean;
        protected var bufGridEvent:GridEvent;
        static const TOOLTIPS_DELAY:Number = 300;
        static const TOOLTIPS_DELAY_MOUSE:Number = 100;
        public static const TOOLTIP_SHOW_ERROR:String = "FailedToSetTooltip";
        static const SHOW_ANIM_DURATION:Number = 0.8;
        static const HIDE_ANIM_DURATION:Number = 0.8;
        static var _instanse:ContextInfoManager;

        public function ContextInfoManager()
        {
            return;
        }// end function

        public function init(param1:Sprite, param2:InputManager) : void
        {
            this._inputMgr = param2;
            this._inputMgr.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChange, false, 0, true);
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.handleComparison, false, 0, true);
            this._rootCanvas = param1;
            this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.REGISTER, "context.tooltip.data", [this.dataReceiver]));
            this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.REGISTER, "statistic.tooltip.data", [this.dataReceiverStat]));
            this._rootCanvas.addEventListener(Event.ENTER_FRAME, this.handleCanvasTick, false, 0, true);
            return;
        }// end function

        public function get defaultAnchor() : DisplayObject
        {
            return this._defaultAnchor;
        }// end function

        public function set defaultAnchor(param1:DisplayObject) : void
        {
            this._defaultAnchor = param1;
            return;
        }// end function

        public function get comparisonMode() : Boolean
        {
            return this._comparisonMode;
        }// end function

        public function set comparisonMode(param1:Boolean) : void
        {
            if (this._comparisonMode != param1)
            {
                this._comparisonMode = param1;
                this.updateComparisonMode();
            }
            return;
        }// end function

        public function get overridedMouseDataSource() : String
        {
            return this._overridedMouseDataSource;
        }// end function

        public function set overridedMouseDataSource(param1:String) : void
        {
            this._overridedMouseDataSource = param1;
            return;
        }// end function

        protected function updateComparisonMode() : void
        {
            var _loc_1:* = this._tooltip as TooltipInventory;
            if (_loc_1)
            {
                _loc_1.showEquippedTooltip(this.comparisonMode);
            }
            return;
        }// end function

        protected function handleCanvasTick(event:Event) : void
        {
            this._initialized = true;
            this._rootCanvas.removeEventListener(Event.ENTER_FRAME, this.handleCanvasTick);
            if (this._pospondedData && this._pospondedKeyValue)
            {
                this.showTooltip(this._pospondedKeyValue, this._pospondedData);
                this._pospondedData = null;
                this._pospondedKeyValue = null;
            }
            return;
        }// end function

        public function dataReceiverStat(param1:Object) : void
        {
            if (this._tooltip as TooltipStatistic)
            {
                this._tooltip.data = param1;
            }
            return;
        }// end function

        public function dataReceiver(param1:Object) : void
        {
            if (this._tooltip)
            {
                this._tooltip.data = param1;
                this.updateComparisonMode();
            }
            else
            {
                dispatchEvent(new Event(ContextInfoManager.TOOLTIP_SHOW_ERROR, true, false));
            }
            return;
        }// end function

        public function addGridEventsTooltipHolder(param1:EventDispatcher, param2:Boolean = false) : void
        {
            this._gridEventsMouseOnly = param2;
            param1.addEventListener(GridEvent.DISPLAY_TOOLTIP, this.pospondedTooltipShow, false, 0, true);
            param1.addEventListener(GridEvent.HIDE_TOOLTIP, this.handleTooltipHideEvent, false, 0, true);
            return;
        }// end function

        public function removeGridEventsTooltipHolder(param1:EventDispatcher) : void
        {
            param1.removeEventListener(GridEvent.DISPLAY_TOOLTIP, this.pospondedTooltipShow);
            param1.removeEventListener(GridEvent.HIDE_TOOLTIP, this.handleTooltipHideEvent);
            return;
        }// end function

        protected function handleControllerChange(event:ControllerChangeEvent) : void
        {
            this.removeCurrentTooltip();
            return;
        }// end function

        protected function pospondedTooltipShow(event:GridEvent) : void
        {
            var _loc_2:* = this._inputMgr.isGamepad();
            if (!this._gridEventsMouseOnly || !_loc_2)
            {
                this.bufGridEvent = event;
                this.handleTooltipHideEvent();
                this._tooltipTimer = new Timer(_loc_2 ? (TOOLTIPS_DELAY) : (TOOLTIPS_DELAY_MOUSE), 1);
                this._tooltipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.showTooltipTimerEnded);
                this._tooltipTimer.start();
            }
            return;
        }// end function

        protected function showTooltipTimerEnded(event:TimerEvent) : void
        {
            this.handleTooltipShowEvent(this.bufGridEvent);
            return;
        }// end function

        protected function handleTooltipShowEvent(event:GridEvent) : void
        {
            var _loc_3:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = event.itemData as Object;
            var _loc_4:* = new TooltipData();
            if (this._gridEventsMouseOnly && this._inputMgr.isGamepad())
            {
                return;
            }
            if (_loc_2 != null)
            {
                if (event.directData == false)
                {
                    if (_loc_2.equipped == 0)
                    {
                        _loc_3 = _loc_2.slotType;
                    }
                    else
                    {
                        _loc_3 = -1;
                    }
                }
            }
            else if (!event.tooltipCustomArgs)
            {
                this.handleHideTooltip();
                return;
            }
            _loc_4.isMouseTooltip = event.isMouseTooltip;
            _loc_4.anchorRect = event.anchorRect;
            _loc_4.directData = event.directData;
            if (event.directData == true)
            {
                _loc_4.description = _loc_2.description;
                _loc_4.label = _loc_2.label;
            }
            _loc_4.dataSource = event.tooltipDataSource ? (event.tooltipDataSource) : ("OnGetItemData");
            _loc_4.anchor = this._defaultAnchor;
            if (event.isMouseTooltip)
            {
                _loc_6 = event.tooltipMouseContentRef ? (event.tooltipMouseContentRef) : (event.tooltipContentRef);
                if (this.overridedMouseDataSource && !event.tooltipForceSetDataSource)
                {
                    _loc_4.dataSource = this.overridedMouseDataSource;
                }
            }
            else
            {
                _loc_6 = event.tooltipContentRef;
            }
            _loc_4.viewerClass = _loc_6 ? (_loc_6) : ("ItemTooltipRef");
            if (event.tooltipCustomArgs)
            {
                _loc_5 = event.tooltipCustomArgs;
            }
            else if (event.directData == false)
            {
                _loc_5 = [uint(_loc_2.id), _loc_3];
            }
            this.showTooltip(_loc_5, _loc_4);
            event.stopImmediatePropagation();
            return;
        }// end function

        protected function handleTooltipHideEvent(event:GridEvent = null) : void
        {
            if (this._tooltipTimer)
            {
                this._tooltipTimer.stop();
            }
            this.removeCurrentTooltip();
            return;
        }// end function

        protected function showTooltip(param1:Array, param2:TooltipData) : void
        {
            this.removeCurrentTooltip();
            if (this._initialized && param2.directData == false)
            {
                this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.CALL, param2.dataSource, param1));
            }
            else
            {
                this._pospondedData = param2;
                this._pospondedKeyValue = param1;
            }
            var _loc_3:* = this.getDefinition(param2.viewerClass) as TooltipBase;
            if (param2.isMouseTooltip)
            {
                _loc_3.anchorRect = param2.anchorRect;
                _loc_3.isMouseTooltip = true;
                _loc_3.backgroundVisibility = true;
            }
            else
            {
                _loc_3.isMouseTooltip = false;
                _loc_3.anchorRect = new Rectangle(this._defaultAnchor.x, this._defaultAnchor.y, 0, 0);
            }
            if (param2.directData == true)
            {
                _loc_3.data = param2;
                this.updateComparisonMode();
            }
            _loc_3.addEventListener(Event.ADDED_TO_STAGE, this.handleTooltipOnStage, false, 0, true);
            this._rootCanvas.addChild(_loc_3);
            this._tooltip = _loc_3;
            this._data = param2;
            return;
        }// end function

        protected function handleTooltipOnStage(event:Event) : void
        {
            return;
        }// end function

        protected function handleHideTooltip(event:Event = null) : void
        {
            if (!this._tooltip)
            {
                return;
            }
            if (InputManager.getInstance().isGamepad())
            {
                this._rootCanvas.removeChild(this._tooltip);
            }
            else
            {
                this.removeCurrentTooltip();
            }
            return;
        }// end function

        protected function subscribeOn(param1:EventDispatcher, param2:Array, param3:Function) : void
        {
            var _loc_4:* = null;
            if (param1 && param2 && param3 != null)
            {
                for each (_loc_4 in param2)
                {
                    
                    param1.addEventListener(_loc_4, param3, false, 0, true);
                }
            }
            return;
        }// end function

        protected function getDefinition(param1:String) : DisplayObject
        {
            var _loc_2:* = RuntimeAssetsManager.getInstanse();
            return _loc_2.getAsset(param1);
        }// end function

        protected function removeCurrentTooltip() : void
        {
            if (this._tooltip)
            {
                GTweener.to(this._tooltip, HIDE_ANIM_DURATION, {alpha:0}, {ease:Exponential.easeOut, onComplete:this.handleTooltipHidden});
                this._tooltip = null;
                this._data = null;
            }
            return;
        }// end function

        protected function handleTooltipHidden(param1:GTween) : void
        {
            this._rootCanvas.removeChild(param1.target as DisplayObject);
            return;
        }// end function

        protected function handleComparison(event:InputEvent) : void
        {
            var _loc_2:* = event.details;
            if (!event.handled)
            {
                if (_loc_2.navEquivalent == NavigationCode.GAMEPAD_L2 || _loc_2.code == KeyCode.SHIFT_LEFT || _loc_2.code == KeyCode.SHIFT_RIGHT)
                {
                    if (_loc_2.value == InputValue.KEY_UP)
                    {
                        this.comparisonMode = false;
                    }
                    else
                    {
                        this.comparisonMode = true;
                    }
                }
            }
            return;
        }// end function

        public static function getInstanse() : ContextInfoManager
        {
            if (!_instanse)
            {
                _instanse = new ContextInfoManager;
            }
            return _instanse;
        }// end function

    }
}

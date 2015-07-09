package red.game.witcher3.tooltips
{
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;

    public class TooltipBase extends UIComponent
    {
        protected var INVALIDATE_PADDING:String = "padding";
        protected var INVALIDATE_POSITION:String = "position";
        protected var _shown:Boolean;
        protected var _populated:Boolean;
        protected var _expanded:Boolean;
        protected var isArabicAligmentMode:Boolean;
        protected var _backgroundVisibility:Boolean;
        protected var _actualPosition:Point;
        protected var _anchorRect:Rectangle;
        protected var _defaultHeight:Number;
        protected var _cachedExtraWidth:Number = 0;
        protected var _isMouseTooltip:Boolean;
        protected var _lockFixedPosition:Boolean;
        protected var _data:Object;
        protected var _tweenerShow:GTween;
        protected var _tweenerScale:GTween;
        protected var _contextMgr:ContextInfoManager;

        public function TooltipBase()
        {
            this._actualPosition = new Point();
            this._defaultHeight = height;
            this._contextMgr = ContextInfoManager.getInstanse();
            return;
        }// end function

        public function get backgroundVisibility() : Boolean
        {
            return this._backgroundVisibility;
        }// end function

        public function set backgroundVisibility(param1:Boolean) : void
        {
            this._backgroundVisibility = param1;
            return;
        }// end function

        public function get data()
        {
            return this._data;
        }// end function

        public function set data(param1) : void
        {
            this._data = param1;
            invalidateData();
            return;
        }// end function

        public function get anchorRect() : Rectangle
        {
            return this._anchorRect;
        }// end function

        public function set anchorRect(param1:Rectangle) : void
        {
            this._anchorRect = param1;
            return;
        }// end function

        public function get expanded() : Boolean
        {
            return this._expanded;
        }// end function

        public function set expanded(param1:Boolean) : void
        {
            if (this._expanded != param1)
            {
                this._expanded = param1;
                if (this.actualHeight > this._defaultHeight)
                {
                    this.expandTooltip();
                }
            }
            return;
        }// end function

        public function get isMouseTooltip() : Boolean
        {
            return this._isMouseTooltip;
        }// end function

        public function set isMouseTooltip(param1:Boolean) : void
        {
            this._isMouseTooltip = param1;
            return;
        }// end function

        public function get lockFixedPosition() : Boolean
        {
            return this._lockFixedPosition;
        }// end function

        public function set lockFixedPosition(param1:Boolean) : void
        {
            this._lockFixedPosition = param1;
            if (!stage)
            {
                addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage, false, 0, true);
            }
            else
            {
                invalidate(this.INVALIDATE_POSITION);
            }
            return;
        }// end function

        override protected function draw() : void
        {
            super.draw();
            if (isInvalid(InvalidationType.DATA))
            {
                this.populateData();
            }
            if (isInvalid(InvalidationType.SIZE))
            {
                this.updateSize();
            }
            if (isInvalid(this.INVALIDATE_POSITION))
            {
                this.updatePosition();
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            var _loc_1:* = false;
            mouseChildren = false;
            mouseEnabled = _loc_1;
            InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChange, false, 0, true);
            return;
        }// end function

        protected function showAnimation() : void
        {
            alpha = 0;
            this._tweenerShow = GTweener.to(this, 0.2, {alpha:1}, {ease:Exponential.easeOut});
            return;
        }// end function

        protected function handleAddedToStage(event:Event) : void
        {
            this.updatePosition();
            invalidate(this.INVALIDATE_POSITION);
            invalidateSize();
            return;
        }// end function

        protected function applyPositioning() : void
        {
            var _loc_1:* = null;
            if (this._anchorRect)
            {
                _loc_1 = new Point(this._anchorRect.x, this._anchorRect.y);
                this._actualPosition.x = _loc_1.x + this._anchorRect.width;
                this._actualPosition.y = _loc_1.y;
            }
            else if (this._lockFixedPosition)
            {
                this._actualPosition.x = this.x;
                this._actualPosition.y = this.y;
            }
            else
            {
                _loc_1 = new Point(0, 0);
                throw new Error(" Missing anchor for tooltip");
            }
            return;
        }// end function

        protected function updatePosition() : void
        {
            var _loc_3:* = NaN;
            var _loc_1:* = CommonUtils.getScreenRect();
            var _loc_2:* = this.getExtraHeight();
            this.applyPositioning();
            x = this._actualPosition.x;
            if (this._tweenerScale)
            {
                this._tweenerScale.paused = true;
            }
            if (_loc_2 > 0)
            {
                _loc_3 = this.y - _loc_2;
                y = this._actualPosition.y;
                this._tweenerScale = GTweener.to(this, 1, {y:_loc_3}, {ease:Exponential.easeOut});
            }
            else if (this._cachedExtraWidth)
            {
                this._tweenerScale = GTweener.to(this, 1, {y:this._actualPosition.y}, {ease:Exponential.easeOut});
            }
            else
            {
                y = this._actualPosition.y;
            }
            this._cachedExtraWidth = _loc_2;
            return;
        }// end function

        protected function populateData() : void
        {
            this._populated = true;
            invalidateSize();
            invalidate(this.INVALIDATE_POSITION);
            return;
        }// end function

        protected function updateSize() : void
        {
            invalidate(this.INVALIDATE_POSITION);
            if (!this._shown)
            {
                this._shown = true;
                this.showAnimation();
            }
            return;
        }// end function

        protected function handleControllerChange(event:ControllerChangeEvent) : void
        {
            return;
        }// end function

        protected function expandTooltip(param1:Boolean = true) : void
        {
            return;
        }// end function

        protected function getExtraHeight() : Number
        {
            return 0;
        }// end function

        protected function applyTextValue(param1:TextField, param2:String, param3:Boolean, param4:Boolean = false) : void
        {
            if (!param1 || !param2)
            {
                if (param1)
                {
                    param1.htmlText = "";
                    param1.visible = false;
                }
                return;
            }
            param1.visible = true;
            param1.htmlText = param2;
            if (param4 && this._contextMgr.isArabicAligmentMode)
            {
                param1.htmlText = "<p align=\"right\">" + param2 + "</p>";
            }
            else if (param3)
            {
                param1.htmlText = CommonUtils.toUpperCaseSafe(param1.htmlText);
            }
            param1.height = param1.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            return;
        }// end function

    }
}

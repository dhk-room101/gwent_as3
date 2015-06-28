///TooltipBase
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
    
    public class TooltipBase extends scaleform.clik.core.UIComponent
    {
        public function TooltipBase()
        {
            super();
            this._actualPosition = new flash.geom.Point();
            this._defaultHeight = height;
            this._contextMgr = red.game.witcher3.managers.ContextInfoManager.getInstanse();
            return;
        }

        public function get isMouseTooltip():Boolean
        {
            return this._isMouseTooltip;
        }

        public function set isMouseTooltip(arg1:Boolean):void
        {
            this._isMouseTooltip = arg1;
            return;
        }

        public function get lockFixedPosition():Boolean
        {
            return this._lockFixedPosition;
        }

        public function set lockFixedPosition(arg1:Boolean):void
        {
            this._lockFixedPosition = arg1;
            if (stage) 
            {
                invalidate(this.INVALIDATE_POSITION);
            }
            else 
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, this.handleAddedToStage, false, 0, true);
            }
            return;
        }

        protected override function draw():void
        {
            super.draw();
            if (isInvalid(scaleform.clik.constants.InvalidationType.DATA)) 
            {
                this.populateData();
            }
            if (isInvalid(scaleform.clik.constants.InvalidationType.SIZE)) 
            {
                this.updateSize();
            }
            if (isInvalid(this.INVALIDATE_POSITION)) 
            {
                this.updatePosition();
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            var loc1:*;
            mouseChildren = loc1 = false;
            mouseEnabled = loc1;
            red.game.witcher3.managers.InputManager.getInstance().addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChange, false, 0, true);
            return;
        }

        protected function showAnimation():void
        {
            alpha = 0;
            this._tweenerShow = com.gskinner.motion.GTweener.to(this, 0.2, {"alpha":1}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
            return;
        }

        protected function handleAddedToStage(arg1:flash.events.Event):void
        {
            this.updatePosition();
            invalidate(this.INVALIDATE_POSITION);
            invalidateSize();
            return;
        }

        protected function applyPositioning():void
        {
            var loc1:*=null;
            if (this._anchorRect) 
            {
                loc1 = new flash.geom.Point(this._anchorRect.x, this._anchorRect.y);
                this._actualPosition.x = loc1.x + this._anchorRect.width;
                this._actualPosition.y = loc1.y;
            }
            else if (this._lockFixedPosition) 
            {
                this._actualPosition.x = this.x;
                this._actualPosition.y = this.y;
            }
            else 
            {
                loc1 = new flash.geom.Point(0, 0);
                throw new Error(" Missing anchor for tooltip");
            }
            return;
        }

        protected function updatePosition():void
        {
            var loc3:*=NaN;
            var loc1:*=red.game.witcher3.utils.CommonUtils.getScreenRect();
            var loc2:*=this.getExtraHeight();
            this.applyPositioning();
            x = this._actualPosition.x;
            if (this._tweenerScale) 
            {
                this._tweenerScale.paused = true;
            }
            if (loc2 > 0) 
            {
                loc3 = this.y - loc2;
                y = this._actualPosition.y;
                this._tweenerScale = com.gskinner.motion.GTweener.to(this, 1, {"y":loc3}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
            }
            else if (this._cachedExtraWidth) 
            {
                this._tweenerScale = com.gskinner.motion.GTweener.to(this, 1, {"y":this._actualPosition.y}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
            }
            else 
            {
                y = this._actualPosition.y;
            }
            this._cachedExtraWidth = loc2;
            return;
        }

        protected function populateData():void
        {
            this._populated = true;
            invalidateSize();
            invalidate(this.INVALIDATE_POSITION);
            return;
        }

        protected function updateSize():void
        {
            invalidate(this.INVALIDATE_POSITION);
            if (!this._shown) 
            {
                this._shown = true;
                this.showAnimation();
            }
            return;
        }

        protected function handleControllerChange(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            return;
        }

        protected function expandTooltip(arg1:Boolean=true):void
        {
            return;
        }

        protected function getExtraHeight():Number
        {
            return 0;
        }

        protected function applyTextValue(arg1:flash.text.TextField, arg2:String, arg3:Boolean, arg4:Boolean=false):void
        {
            if (!arg1 || !arg2) 
            {
                if (arg1) 
                {
                    arg1.htmlText = "";
                    arg1.visible = false;
                }
                return;
            }
            arg1.visible = true;
            arg1.htmlText = arg2;
            if (arg4 && this._contextMgr.isArabicAligmentMode) 
            {
                arg1.htmlText = "<p align=\"right\">" + arg2 + "</p>";
            }
            else if (arg3) 
            {
                arg1.htmlText = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(arg1.htmlText);
            }
            arg1.height = arg1.textHeight + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
            return;
        }

        public function get data():*
        {
            return this._data;
        }

        public function set data(arg1:*):void
        {
            this._data = arg1;
            invalidateData();
            return;
        }

        public function get anchorRect():flash.geom.Rectangle
        {
            return this._anchorRect;
        }

        public function set anchorRect(arg1:flash.geom.Rectangle):void
        {
            this._anchorRect = arg1;
            return;
        }

        public function get expanded():Boolean
        {
            return this._expanded;
        }

        public function set expanded(arg1:Boolean):void
        {
            if (this._expanded != arg1) 
            {
                this._expanded = arg1;
                if (this.actualHeight > this._defaultHeight) 
                {
                    this.expandTooltip();
                }
            }
            return;
        }

        protected var INVALIDATE_PADDING:String="padding";

        protected var INVALIDATE_POSITION:String="position";

        protected var _shown:Boolean;

        protected var _populated:Boolean;

        protected var _expanded:Boolean;

        protected var isArabicAligmentMode:Boolean;

        protected var _actualPosition:flash.geom.Point;

        protected var _anchorRect:flash.geom.Rectangle;

        protected var _defaultHeight:Number;

        protected var _cachedExtraWidth:Number=0;

        protected var _isMouseTooltip:Boolean;

        protected var _lockFixedPosition:Boolean;

        protected var _data:*;

        protected var _tweenerShow:com.gskinner.motion.GTween;

        protected var _tweenerScale:com.gskinner.motion.GTween;

        protected var _contextMgr:red.game.witcher3.managers.ContextInfoManager;
    }
}



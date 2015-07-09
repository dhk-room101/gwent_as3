package scaleform.clik.controls
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;
    import scaleform.clik.ui.*;

    public class ScrollIndicator extends UIComponent implements IScrollBar
    {
        public var direction:String = "vertical";
        public var offsetTop:Number = 0;
        public var offsetBottom:Number = 0;
        protected var _isDragging:Boolean = false;
        protected var _maxPosition:Number = 10;
        protected var _minPosition:Number = 0;
        protected var _minThumbSize:Number = 10;
        protected var _pageScrollSize:Number = 1;
        protected var _pageSize:Number;
        protected var _position:Number = 5;
        protected var _scrollTarget:Object;
        public var thumb:MovieClip;
        public var track:MovieClip;

        public function ScrollIndicator()
        {
            return;
        }// end function

        override protected function initialize() : void
        {
            super.initialize();
            return;
        }// end function

        override public function get enabled() : Boolean
        {
            return super.enabled;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            if (param1 == super.enabled)
            {
                return;
            }
            super.enabled = param1;
            gotoAndPlay(this.enabled ? ("default") : ("disabled"));
            return;
        }// end function

        public function get position() : Number
        {
            return this._position;
        }// end function

        public function set position(param1:Number) : void
        {
            param1 = Math.max(this._minPosition, Math.min(this._maxPosition, param1));
            if (param1 == this._position)
            {
                return;
            }
            this._position = param1;
            dispatchEvent(new Event(Event.SCROLL));
            invalidateData();
            return;
        }// end function

        public function get minThumbSize() : Number
        {
            return this._minThumbSize;
        }// end function

        public function set minThumbSize(param1:Number) : void
        {
            param1 = Math.max(1, param1);
            this._minThumbSize = param1;
            invalidateSize();
            return;
        }// end function

        public function get isHorizontal() : Boolean
        {
            return this.direction == ScrollBarDirection.HORIZONTAL;
        }// end function

        public function get scrollTarget() : Object
        {
            return this._scrollTarget;
        }// end function

        public function set scrollTarget(param1:Object) : void
        {
            if (param1 is String)
            {
                if (!componentInspectorSetting || param1.toString() == "" || parent == null)
                {
                    return;
                }
                param1 = parent.getChildByName(param1.toString());
                if (param1 == null)
                {
                    return;
                }
            }
            var _loc_2:* = this._scrollTarget;
            this._scrollTarget = param1;
            if (_loc_2 != null)
            {
                _loc_2.removeEventListener(Event.SCROLL, this.handleTargetScroll, false);
                if (_loc_2.scrollBar != null)
                {
                    _loc_2.scrollBar = null;
                }
            }
            if (param1 is UIComponent && "scrollBar" in param1)
            {
                param1.scrollBar = this;
                return;
            }
            if (this._scrollTarget == null)
            {
                tabEnabled = true;
                return;
            }
            _loc_2.addEventListener(Event.SCROLL, this.handleTargetScroll, false, 0, true);
            if (this._scrollTarget is UIComponent)
            {
                focusTarget = this._scrollTarget as UIComponent;
            }
            tabEnabled = false;
            this.handleTargetScroll(null);
            invalidate();
            return;
        }// end function

        public function get availableHeight() : Number
        {
            var _loc_1:* = isNaN(this.thumb.height) ? (0) : (this.thumb.height);
            return (this.isHorizontal ? (_width) : (_height)) - _loc_1 + this.offsetBottom + this.offsetTop;
        }// end function

        public function setScrollProperties(param1:Number, param2:Number, param3:Number, param4:Number = NaN) : void
        {
            this._pageSize = param1;
            if (!isNaN(param4))
            {
                this._pageScrollSize = param4;
            }
            this._minPosition = param2;
            this._maxPosition = param3;
            invalidateSize();
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            if (event.handled)
            {
                return;
            }
            var _loc_2:* = event.details;
            if (_loc_2.value == InputValue.KEY_UP)
            {
                return;
            }
            var _loc_3:* = this.direction == ScrollBarDirection.HORIZONTAL;
            switch(_loc_2.navEquivalent)
            {
                case NavigationCode.UP:
                {
                    if (_loc_3)
                    {
                        return;
                    }
                    (this.position - 1);
                    break;
                }
                case NavigationCode.DOWN:
                {
                    if (_loc_3)
                    {
                        return;
                    }
                    (this.position + 1);
                    break;
                }
                case NavigationCode.LEFT:
                {
                    if (!_loc_3)
                    {
                        return;
                    }
                    (this.position - 1);
                    break;
                }
                case NavigationCode.RIGHT:
                {
                    if (!_loc_3)
                    {
                        return;
                    }
                    (this.position + 1);
                    break;
                }
                case NavigationCode.HOME:
                {
                    this.position = 0;
                    break;
                }
                case NavigationCode.END:
                {
                    this.position = this._maxPosition;
                    break;
                }
                default:
                {
                    return;
                    break;
                }
            }
            event.handled = true;
            return;
        }// end function

        override public function toString() : String
        {
            return "[CLIK ScrollIndicator " + name + "]";
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            focusable = false;
            var _loc_1:* = false;
            mouseEnabled = false;
            mouseChildren = _loc_1;
            if (this.track == null)
            {
                this.track = new MovieClip();
            }
            this.thumb.enabled = this.enabled;
            initSize();
            this.direction = rotation != 0 && rotation != 180 ? (ScrollBarDirection.HORIZONTAL) : (ScrollBarDirection.VERTICAL);
            return;
        }// end function

        override protected function draw() : void
        {
            var _loc_1:* = null;
            if (isInvalid(InvalidationType.SIZE))
            {
                setActualSize(_width, _height);
                this.drawLayout();
                this.updateThumb();
            }
            else if (isInvalid(InvalidationType.DATA))
            {
                if (this._scrollTarget is TextField)
                {
                    _loc_1 = this._scrollTarget as TextField;
                    this.setScrollProperties(_loc_1.bottomScrollV - _loc_1.scrollV, 1, _loc_1.maxScrollV);
                }
                this.updateThumbPosition();
            }
            return;
        }// end function

        protected function drawLayout() : void
        {
            this.track.height = this.isHorizontal ? (_width) : (_height);
            if (this.track is UIComponent)
            {
                this.track.validateNow();
            }
            return;
        }// end function

        protected function updateThumb() : void
        {
            var _loc_1:* = Math.max(1, this._maxPosition - this._minPosition + this._pageSize);
            var _loc_2:* = (this.isHorizontal ? (_width) : (_height)) + this.offsetTop + this.offsetBottom;
            this.thumb.height = Math.max(this._minThumbSize, Math.min(_height, this._pageSize / _loc_1 * _loc_2));
            if (this.thumb is UIComponent)
            {
                (this.thumb as UIComponent).validateNow();
            }
            this.updateThumbPosition();
            return;
        }// end function

        protected function updateThumbPosition() : void
        {
            var _loc_1:* = (this._position - this._minPosition) / (this._maxPosition - this._minPosition);
            if (isNaN(_loc_1))
            {
                _loc_1 = 0;
            }
            var _loc_2:* = _loc_1 * this.availableHeight;
            this.thumb.y = Math.max(-this.offsetTop, Math.min(this.availableHeight - this.offsetTop, _loc_2));
            this.thumb.visible = !(this._maxPosition == this._minPosition || isNaN(this._pageSize) || this._maxPosition == 0);
            return;
        }// end function

        protected function handleTargetScroll(event:Event) : void
        {
            if (this._isDragging)
            {
                return;
            }
            var _loc_2:* = this._scrollTarget as TextField;
            if (_loc_2 != null)
            {
                this.setScrollProperties(_loc_2.bottomScrollV - _loc_2.scrollV, 1, _loc_2.maxScrollV);
                this.position = _loc_2.scrollV;
            }
            return;
        }// end function

    }
}

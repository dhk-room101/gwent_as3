package scaleform.clik.controls
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import red.core.constants.*;
    import red.core.data.*;
    import red.core.utils.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;
    import scaleform.clik.ui.*;
    import scaleform.clik.utils.*;
    import scaleform.gfx.*;

    public class TextArea extends TextInput
    {
        protected var _scrollPolicy:String = "auto";
        protected var _position:int = 1;
        protected var _maxScroll:Number = 1;
        protected var _resetScrollPosition:Boolean = false;
        protected var _scrollBarValue:Object;
        protected var _autoScrollBar:Boolean = false;
        protected var _thumbOffset:Object;
        protected var _minThumbSize:uint = 1;
        protected var _lastJoyUpdateTime:int = 0;
        protected var _lastJoyUpdateDir:String = "none";
        protected var _scrollBar:IScrollBar;
        public var container:Sprite;
        static const AXIS_INPUT_DELAY:Number = 300;
        static const AXIS_INPUT_REPEAT_DELAY:Number = 120;

        public function TextArea()
        {
            this._thumbOffset = {top:0, bottom:0};
            return;
        }// end function

        override protected function preInitialize() : void
        {
            if (!constraintsDisabled)
            {
                constraints = new Constraints(this, ConstrainMode.COUNTER_SCALE);
            }
            return;
        }// end function

        override protected function initialize() : void
        {
            super.initialize();
            if (this.container == null)
            {
                this.container = new Sprite();
                addChild(this.container);
            }
            return;
        }// end function

        override public function get enabled() : Boolean
        {
            return super.enabled;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            super.enabled = param1;
            this.updateScrollBar();
            return;
        }// end function

        public function get position() : int
        {
            return this._position;
        }// end function

        public function set position(param1:int) : void
        {
            this._position = param1;
            textField.scrollV = this._position;
            return;
        }// end function

        public function get scrollBar() : Object
        {
            return this._scrollBar;
        }// end function

        public function set scrollBar(param1:Object) : void
        {
            this._scrollBarValue = param1;
            invalidate(InvalidationType.SCROLL_BAR);
            return;
        }// end function

        public function get minThumbSize() : uint
        {
            return this._minThumbSize;
        }// end function

        public function set minThumbSize(param1:uint) : void
        {
            this._minThumbSize = param1;
            if (!this._autoScrollBar)
            {
                return;
            }
            var _loc_2:* = this._scrollBar as ScrollIndicator;
            _loc_2.minThumbSize = param1;
            return;
        }// end function

        public function get thumbOffset() : Object
        {
            return this._thumbOffset;
        }// end function

        public function set thumbOffset(param1:Object) : void
        {
            this._thumbOffset = param1;
            if (!this._autoScrollBar)
            {
                return;
            }
            var _loc_2:* = this._scrollBar as ScrollIndicator;
            _loc_2.offsetTop = this._thumbOffset.top;
            _loc_2.offsetBottom = this._thumbOffset.bottom;
            return;
        }// end function

        public function get availableWidth() : Number
        {
            return Math.round(_width) - (this._autoScrollBar && (this._scrollBar as MovieClip).visible ? (Math.round(this._scrollBar.width)) : (0));
        }// end function

        public function get availableHeight() : Number
        {
            return Math.round(_height);
        }// end function

        override public function toString() : String
        {
            return "[CLIK TextArea " + name + "]";
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = null;
            var _loc_6:* = false;
            var _loc_7:* = null;
            var _loc_8:* = NaN;
            var _loc_9:* = null;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            super.handleInput(event);
            if (event.handled)
            {
                return;
            }
            if (_editable)
            {
                return;
            }
            _loc_2 = event.details.navEquivalent;
            _loc_3 = getTimer();
            _loc_4 = _loc_3 - this._lastJoyUpdateTime;
            if (_loc_3 - this._lastJoyUpdateTime > AXIS_INPUT_DELAY * 2)
            {
                this._lastJoyUpdateDir = "none";
            }
            _loc_5 = event.details;
            if (_loc_5.code == KeyCode.PAD_RIGHT_STICK_AXIS)
            {
                _loc_6 = false;
                _loc_7 = InputAxisData(_loc_5.value);
                _loc_8 = InputUtils.getAngleRadians(_loc_7.xvalue, _loc_7.yvalue);
                _loc_9 = CommonUtils.convertAxisToNavigationCode(_loc_8);
                if (_loc_9.code == KeyCode.UP && (_loc_4 > AXIS_INPUT_DELAY || this._lastJoyUpdateDir == "uprepeat" && _loc_4 > AXIS_INPUT_REPEAT_DELAY))
                {
                    if (this.position == 1)
                    {
                        return;
                    }
                    this.position = Math.max(1, (this.position - 1));
                    event.handled = true;
                    _loc_6 = true;
                    if (this._lastJoyUpdateDir == "up")
                    {
                        this._lastJoyUpdateDir = "uprepeat";
                    }
                    else if (this._lastJoyUpdateDir != "uprepeat")
                    {
                        this._lastJoyUpdateDir = "up";
                    }
                    Console.WriteLine("GFX - _lastJoyUpdateDir: ", this._lastJoyUpdateDir);
                }
                else if (_loc_9.code == KeyCode.DOWN && (_loc_4 > AXIS_INPUT_DELAY || this._lastJoyUpdateDir == "downrepeat" && _loc_4 > AXIS_INPUT_REPEAT_DELAY))
                {
                    if (this.position == this._maxScroll)
                    {
                        return;
                    }
                    this.position = Math.min(this._maxScroll, (this.position + 1));
                    event.handled = true;
                    _loc_6 = true;
                    if (this._lastJoyUpdateDir == "down")
                    {
                        this._lastJoyUpdateDir = "downrepeat";
                    }
                    else if (this._lastJoyUpdateDir != "downrepeat")
                    {
                        this._lastJoyUpdateDir = "down";
                    }
                }
                if (_loc_6)
                {
                    this._lastJoyUpdateTime = _loc_3;
                }
            }
            switch(_loc_2)
            {
                case NavigationCode.UP:
                {
                    if (this.position == 1)
                    {
                        return;
                    }
                    this.position = Math.max(1, (this.position - 1));
                    event.handled = true;
                    break;
                }
                case NavigationCode.DOWN:
                {
                    if (this.position == this._maxScroll)
                    {
                        return;
                    }
                    this.position = Math.min(this._maxScroll, (this.position + 1));
                    event.handled = true;
                    break;
                }
                case NavigationCode.END:
                {
                    this.position = this._maxScroll;
                    event.handled = true;
                    break;
                }
                case NavigationCode.HOME:
                {
                    this.position = 1;
                    event.handled = true;
                    break;
                }
                case NavigationCode.PAGE_UP:
                {
                    _loc_10 = textField.bottomScrollV - textField.scrollV;
                    this.position = Math.max(1, this.position - _loc_10);
                    event.handled = true;
                    break;
                }
                case NavigationCode.PAGE_DOWN:
                {
                    _loc_11 = textField.bottomScrollV - textField.scrollV;
                    this.position = Math.min(this._maxScroll, this.position + _loc_11);
                    event.handled = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (textField != null)
            {
                textField.addEventListener(Event.SCROLL, this.onScroller, false, 0, true);
            }
            return;
        }// end function

        override protected function draw() : void
        {
            var _loc_1:* = 0;
            if (isInvalid(InvalidationType.SCROLL_BAR))
            {
                this.createScrollBar();
            }
            if (isInvalid(InvalidationType.STATE))
            {
                if (_newFrame)
                {
                    gotoAndPlay(_newFrame);
                    _newFrame = null;
                }
                updateAfterStateChange();
                this.updateTextField();
                dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGE));
                invalidate(InvalidationType.SIZE);
            }
            else if (isInvalid(InvalidationType.DATA))
            {
                this.updateText();
            }
            if (isInvalid(InvalidationType.SIZE))
            {
                removeChild(this.container);
                setActualSize(_width, _height);
                this.container.scaleX = 1 / scaleX;
                this.container.scaleY = 1 / scaleY;
                if (!constraintsDisabled)
                {
                    constraints.update(this.availableWidth, _height);
                    if (!Extensions.enabled)
                    {
                        _loc_1 = textField.textWidth;
                    }
                }
                addChild(this.container);
                if (this._autoScrollBar)
                {
                    this.drawScrollBar();
                }
            }
            return;
        }// end function

        protected function createScrollBar() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._scrollBar != null)
            {
                this._scrollBar.removeEventListener(Event.SCROLL, this.handleScroll, false);
                this._scrollBar.removeEventListener(Event.CHANGE, this.handleScroll, false);
                this._scrollBar.focusTarget = null;
                if (this.container.contains(this._scrollBar as DisplayObject))
                {
                    this.container.removeChild(this._scrollBar as DisplayObject);
                }
                this._scrollBar = null;
            }
            if (!this._scrollBarValue || this._scrollBarValue == "")
            {
                return;
            }
            this._autoScrollBar = false;
            if (this._scrollBarValue is String)
            {
                if (parent != null)
                {
                    _loc_1 = parent.getChildByName(this._scrollBarValue.toString()) as IScrollBar;
                }
                if (_loc_1 == null)
                {
                    _loc_2 = getDefinitionByName(this._scrollBarValue.toString()) as Class;
                    if (_loc_2)
                    {
                        _loc_1 = new _loc_2 as IScrollBar;
                    }
                    if (_loc_1)
                    {
                        this._autoScrollBar = true;
                        _loc_3 = _loc_1 as Object;
                        if (_loc_3 && this._thumbOffset)
                        {
                            _loc_3.offsetTop = this._thumbOffset.top;
                            _loc_3.offsetBottom = this._thumbOffset.bottom;
                        }
                        _loc_1.addEventListener(MouseEvent.MOUSE_WHEEL, this.blockMouseWheel, false, 0, true);
                        (_loc_3).minThumbSize = this._minThumbSize;
                        this.container.addChild(_loc_1 as DisplayObject);
                    }
                }
            }
            else if (this._scrollBarValue is Class)
            {
                _loc_1 = new (this._scrollBarValue as Class)() as IScrollBar;
                _loc_1.addEventListener(MouseEvent.MOUSE_WHEEL, this.blockMouseWheel, false, 0, true);
                if (_loc_1 != null)
                {
                    this._autoScrollBar = true;
                    (_loc_3).offsetTop = this._thumbOffset.top;
                    (_loc_3).offsetBottom = this._thumbOffset.bottom;
                    (_loc_3).minThumbSize = this._minThumbSize;
                    this.container.addChild(_loc_1 as DisplayObject);
                }
            }
            else
            {
                _loc_1 = this._scrollBarValue as IScrollBar;
            }
            this._scrollBar = _loc_1;
            invalidateSize();
            if (this._scrollBar != null)
            {
                this._scrollBar.addEventListener(Event.SCROLL, this.handleScroll, false, 0, true);
                this._scrollBar.addEventListener(Event.CHANGE, this.handleScroll, false, 0, true);
                this._scrollBar.focusTarget = this;
                (this._scrollBar as Object).scrollTarget = textField;
                this._scrollBar.tabEnabled = false;
            }
            return;
        }// end function

        protected function drawScrollBar() : void
        {
            if (!this._autoScrollBar)
            {
                return;
            }
            this._scrollBar.x = _width - this._scrollBar.width;
            this._scrollBar.height = this.availableHeight;
            this._scrollBar.validateNow();
            return;
        }// end function

        protected function updateScrollBar() : void
        {
            this._maxScroll = textField.maxScrollV;
            var _loc_1:* = this._scrollBar as ScrollIndicator;
            if (_loc_1 == null)
            {
                return;
            }
            var _loc_2:* = constraints.getElement("textField");
            if (this._scrollPolicy == "on" || this._scrollPolicy == "auto" && textField.maxScrollV > 1)
            {
                if (this._autoScrollBar && !_loc_1.visible)
                {
                    if (_loc_2 != null)
                    {
                        constraints.update(_width, _height);
                        invalidate();
                    }
                    this._maxScroll = textField.maxScrollV;
                }
                _loc_1.visible = true;
            }
            if (this._scrollPolicy == "off" || this._scrollPolicy == "auto" && textField.maxScrollV == 1)
            {
                if (this._autoScrollBar && _loc_1.visible)
                {
                    _loc_1.visible = false;
                    if (_loc_2 != null)
                    {
                        constraints.update(this.availableWidth, _height);
                        invalidate();
                    }
                }
            }
            if (_loc_1.enabled != this.enabled)
            {
                _loc_1.enabled = this.enabled;
            }
            return;
        }// end function

        override protected function updateText() : void
        {
            super.updateText();
            this.updateScrollBar();
            return;
        }// end function

        override protected function updateTextField() : void
        {
            this._resetScrollPosition = true;
            super.updateTextField();
            return;
        }// end function

        protected function handleScroll(event:Event) : void
        {
            this.position = this._scrollBar.position;
            return;
        }// end function

        protected function blockMouseWheel(event:MouseEvent) : void
        {
            event.stopPropagation();
            return;
        }// end function

        override protected function handleTextChange(event:Event) : void
        {
            if (this._maxScroll != textField.maxScrollV)
            {
                this.updateScrollBar();
            }
            super.handleTextChange(event);
            return;
        }// end function

        protected function onScroller(event:Event) : void
        {
            if (this._resetScrollPosition)
            {
                textField.scrollV = this._position;
            }
            else
            {
                this._position = textField.scrollV;
            }
            this._resetScrollPosition = false;
            return;
        }// end function

    }
}

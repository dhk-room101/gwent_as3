package red.game.witcher3.controls
{
    import flash.events.*;
    import flash.text.*;
    import red.core.*;
    import red.core.events.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.controls.*;
    import scaleform.clik.utils.*;

    public class W3TextArea extends TextArea
    {
        protected var _scrollSpeed:Number;
        protected var _baseTextColor:uint;
        protected var _uppercase:Boolean;
        protected var _alignArabicText:Boolean;
        protected var txtInitPosition:Number;
        protected var _textColorChange:uint;

        public function W3TextArea()
        {
            this.txtInitPosition = textField.x;
            return;
        }// end function

        public function get uppercase() : Boolean
        {
            return this._uppercase;
        }// end function

        public function set uppercase(param1:Boolean) : void
        {
            this._uppercase = param1;
            return;
        }// end function

        public function get alignArabicText() : Boolean
        {
            return this._alignArabicText;
        }// end function

        public function set alignArabicText(param1:Boolean) : void
        {
            this._alignArabicText = param1;
            return;
        }// end function

        override public function set text(param1:String) : void
        {
            if (param1 == null)
            {
                param1 = "";
            }
            super.text = param1;
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheelScroll, false, 0, true);
            this._baseTextColor = textField.textColor;
            this._textColorChange = this._baseTextColor;
            return;
        }// end function

        override public function set position(param1:int) : void
        {
            super.position = param1;
            scrollBar.position = param1;
            if (_maxScroll > 1)
            {
                if (position != param1)
                {
                    dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", ["gui_global_scroll_description"]));
                }
                else
                {
                    dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", ["gui_global_scroll_description_failed"]));
                }
            }
            return;
        }// end function

        public function get scrollSpeed() : Number
        {
            return this._scrollSpeed;
        }// end function

        public function set scrollSpeed(param1:Number) : void
        {
            this._scrollSpeed = param1;
            return;
        }// end function

        public function changeScrollBarPolicy(param1:String) : void
        {
            _scrollPolicy = param1;
            this.updateScrollBar();
            return;
        }// end function

        override protected function updateText() : void
        {
            var _loc_1:* = null;
            super.updateText();
            if (this._baseTextColor != this._textColorChange || textField.textColor != this._baseTextColor)
            {
                textField.textColor = this._textColorChange;
            }
            if (this._uppercase)
            {
                textField.htmlText = CommonUtils.toUpperCaseSafe(textField.htmlText);
            }
            if (this._alignArabicText && CoreComponent.isArabicAligmentMode)
            {
                _loc_1 = textField.getTextFormat();
                _loc_1.align = TextFormatAlign.RIGHT;
                textField.setTextFormat(_loc_1);
                textField.x = this.txtInitPosition - (textField.width - textField.textWidth);
            }
            else
            {
                textField.x = this.txtInitPosition;
            }
            return;
        }// end function

        override protected function updateScrollBar() : void
        {
            _maxScroll = textField.maxScrollV;
            var _loc_1:* = _scrollBar as ScrollIndicator;
            if (_loc_1 == null)
            {
                return;
            }
            var _loc_2:* = constraints.getElement("textField");
            if (_scrollPolicy == "on" || _scrollPolicy == "auto" && textField.maxScrollV > 1)
            {
                if (_autoScrollBar && !_loc_1.visible)
                {
                    if (_loc_2 != null)
                    {
                        constraints.update(_width, _height);
                        invalidate();
                    }
                    _maxScroll = textField.maxScrollV;
                }
                _loc_1.visible = true;
            }
            if (_scrollPolicy == "off" || _scrollPolicy == "auto" && textField.maxScrollV < 2)
            {
                if (_loc_1.visible)
                {
                    _loc_1.visible = false;
                }
                if (_autoScrollBar)
                {
                    if (_loc_2 != null)
                    {
                        constraints.update(availableWidth, _height);
                        invalidate();
                    }
                }
            }
            if (_loc_1.enabled != enabled)
            {
                _loc_1.enabled = enabled;
            }
            return;
        }// end function

        public function CanBeFocused() : Boolean
        {
            return textField.maxScrollV > 1;
        }// end function

        public function setTextColor(param1:uint) : void
        {
            this._textColorChange = param1;
            textField.textColor = this._textColorChange;
            return;
        }// end function

        public function resetTextColor() : void
        {
            this._textColorChange = this._baseTextColor;
            textField.textColor = this._textColorChange;
            return;
        }// end function

        override protected function blockMouseWheel(event:MouseEvent) : void
        {
            return;
        }// end function

        protected function onMouseWheelScroll(event:MouseEvent) : void
        {
            this.position = textField.scrollV;
            return;
        }// end function

        override protected function onScroller(event:Event) : void
        {
            super.onScroller(event);
            this.updateScrollBar();
            return;
        }// end function

    }
}

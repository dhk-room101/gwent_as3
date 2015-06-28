package red.game.witcher3.controls 
{
    import flash.events.*;
    import flash.text.*;
    import red.core.*;
    import red.core.events.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.controls.*;
    import scaleform.clik.utils.*;
    
    public class W3TextArea extends scaleform.clik.controls.TextArea
    {
        public function W3TextArea()
        {
            super();
            this.txtInitPosition = textField.x;
            return;
        }

        public function get uppercase():Boolean
        {
            return this._uppercase;
        }

        public function set uppercase(arg1:Boolean):void
        {
            this._uppercase = arg1;
            return;
        }

        public function get alignArabicText():Boolean
        {
            return this._alignArabicText;
        }

        public function set alignArabicText(arg1:Boolean):void
        {
            this._alignArabicText = arg1;
            return;
        }

        public override function set text(arg1:String):void
        {
            if (arg1 == null) 
            {
                arg1 = "";
            }
            super.text = arg1;
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onMouseWheelScroll, false, 0, true);
            this._baseTextColor = textField.textColor;
            this._textColorChange = this._baseTextColor;
            return;
        }

        public override function set position(arg1:int):void
        {
            super.position = arg1;
            scrollBar.position = arg1;
            if (_maxScroll > 1) 
            {
                if (position == arg1) 
                {
                    dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", ["gui_global_scroll_description_failed"]));
                }
                else 
                {
                    dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", ["gui_global_scroll_description"]));
                }
            }
            return;
        }

        public function get scrollSpeed():Number
        {
            return this._scrollSpeed;
        }

        public function set scrollSpeed(arg1:Number):void
        {
            this._scrollSpeed = arg1;
            return;
        }

        public function changeScrollBarPolicy(arg1:String):void
        {
            _scrollPolicy = arg1;
            this.updateScrollBar();
            return;
        }

        protected override function updateText():void
        {
            var loc1:*=null;
            super.updateText();
            if (!(this._baseTextColor == this._textColorChange) || !(textField.textColor == this._baseTextColor)) 
            {
                textField.textColor = this._textColorChange;
            }
            if (this._uppercase) 
            {
                textField.htmlText = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(textField.htmlText);
            }
            if (this._alignArabicText && red.core.CoreComponent.isArabicAligmentMode) 
            {
                loc1 = textField.getTextFormat();
                loc1.align = flash.text.TextFormatAlign.RIGHT;
                textField.setTextFormat(loc1);
                textField.x = this.txtInitPosition - (textField.width - textField.textWidth);
            }
            else 
            {
                textField.x = this.txtInitPosition;
            }
            return;
        }

        protected override function updateScrollBar():void
        {
            _maxScroll = textField.maxScrollV;
            var loc1:*=_scrollBar as scaleform.clik.controls.ScrollIndicator;
            if (loc1 == null) 
            {
                return;
            }
            var loc2:*=constraints.getElement("textField");
            if (_scrollPolicy == "on" || _scrollPolicy == "auto" && textField.maxScrollV > 1) 
            {
                if (_autoScrollBar && !loc1.visible) 
                {
                    if (loc2 != null) 
                    {
                        constraints.update(_width, _height);
                        invalidate();
                    }
                    _maxScroll = textField.maxScrollV;
                }
                loc1.visible = true;
            }
            if (_scrollPolicy == "off" || _scrollPolicy == "auto" && textField.maxScrollV < 2) 
            {
                if (loc1.visible) 
                {
                    loc1.visible = false;
                }
                if (_autoScrollBar) 
                {
                    if (loc2 != null) 
                    {
                        constraints.update(availableWidth, _height);
                        invalidate();
                    }
                }
            }
            if (loc1.enabled != enabled) 
            {
                loc1.enabled = enabled;
            }
            return;
        }

        public function CanBeFocused():Boolean
        {
            return textField.maxScrollV > 1;
        }

        public function setTextColor(arg1:uint):void
        {
            this._textColorChange = arg1;
            textField.textColor = this._textColorChange;
            return;
        }

        public function resetTextColor():void
        {
            this._textColorChange = this._baseTextColor;
            textField.textColor = this._textColorChange;
            return;
        }

        protected override function blockMouseWheel(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        protected function onMouseWheelScroll(arg1:flash.events.MouseEvent):void
        {
            this.position = textField.scrollV;
            return;
        }

        protected override function onScroller(arg1:flash.events.Event):void
        {
            super.onScroller(arg1);
            this.updateScrollBar();
            return;
        }

        protected var _scrollSpeed:Number;

        protected var _baseTextColor:uint;

        protected var _uppercase:Boolean;

        protected var _alignArabicText:Boolean;

        protected var txtInitPosition:Number;

        protected var _textColorChange:uint;
    }
}

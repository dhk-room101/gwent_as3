package red.game.witcher3.controls
{
    import red.core.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.controls.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;

    public class BaseListItem extends ListItemRenderer
    {
        public var canBePressed:Boolean = true;

        public function BaseListItem()
        {
            doubleClickEnabled = true;
            preventAutosizing = true;
            constraintsDisabled = true;
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            return;
        }// end function

        override public function setActualSize(param1:Number, param2:Number) : void
        {
            return;
        }// end function

        override protected function updateText() : void
        {
            if (_label != null && textField != null)
            {
                if (CoreComponent.isArabicAligmentMode)
                {
                    textField.htmlText = "<p align=\"right\">" + _label + "</p>";
                    return;
                }
                textField.htmlText = _label;
            }
            return;
        }// end function

        override public function setData(param1:Object) : void
        {
            super.setData(param1);
            if (!param1)
            {
                return;
            }
            if (param1.selected)
            {
                selected = true;
            }
            this.update();
            return;
        }// end function

        public function hasData() : Boolean
        {
            return data != null;
        }// end function

        override protected function updateAfterStateChange() : void
        {
            return;
        }// end function

        protected function update()
        {
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            if (event.isDefaultPrevented() || !this.canBePressed)
            {
                return;
            }
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.controllerIndex;
            switch(_loc_2.navEquivalent)
            {
                case NavigationCode.ENTER:
                case NavigationCode.GAMEPAD_A:
                {
                    if (_loc_2.value == InputValue.KEY_DOWN)
                    {
                        handlePress(_loc_3);
                        event.handled = true;
                    }
                    else if (_loc_2.value == InputValue.KEY_UP)
                    {
                        if (_pressedByKeyboard)
                        {
                            handleRelease(_loc_3);
                            event.handled = true;
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function getRendererWidth() : Number
        {
            return actualWidth;
        }// end function

        public function getRendererHeight() : Number
        {
            return actualHeight;
        }// end function

    }
}

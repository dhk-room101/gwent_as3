///BaseListItem
package red.game.witcher3.controls 
{
    import red.core.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.controls.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;
    
    public class BaseListItem extends scaleform.clik.controls.ListItemRenderer
    {
        public function BaseListItem()
        {
            super();
            doubleClickEnabled = true;
            preventAutosizing = true;
            constraintsDisabled = true;
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            return;
        }

        public override function setActualSize(arg1:Number, arg2:Number):void
        {
            return;
        }

        protected override function updateText():void
        {
            if (!(_label == null) && !(textField == null)) 
            {
                if (red.core.CoreComponent.isArabicAligmentMode) 
                {
                    textField.htmlText = "<p align=\"right\">" + _label + "</p>";
                    return;
                }
                textField.htmlText = _label;
            }
            return;
        }

        public override function setData(arg1:Object):void
        {
            super.setData(arg1);
            if (!arg1) 
            {
                return;
            }
            if (arg1.selected) 
            {
                selected = true;
            }
            this.update();
            return;
        }

        public function hasData():Boolean
        {
            return !(data == null);
        }

        protected override function updateAfterStateChange():void
        {
            return;
        }

        protected function update():*
        {
            return;
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            if (arg1.isDefaultPrevented() || !this.canBePressed) 
            {
                return;
            }
            var loc1:*=arg1.details;
            var loc2:*=loc1.controllerIndex;
            var loc3:*=loc1.navEquivalent;
            switch (loc3) 
            {
                case scaleform.clik.constants.NavigationCode.ENTER:
                case scaleform.clik.constants.NavigationCode.GAMEPAD_A:
                {
                    if (loc1.value != scaleform.clik.constants.InputValue.KEY_DOWN) 
                    {
                        if (loc1.value == scaleform.clik.constants.InputValue.KEY_UP) 
                        {
                            if (_pressedByKeyboard) 
                            {
                                handleRelease(loc2);
                                arg1.handled = true;
                            }
                        }
                    }
                    else 
                    {
                        handlePress(loc2);
                        arg1.handled = true;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        public function getRendererWidth():Number
        {
            return actualWidth;
        }

        public var canBePressed:Boolean=true;
    }
}



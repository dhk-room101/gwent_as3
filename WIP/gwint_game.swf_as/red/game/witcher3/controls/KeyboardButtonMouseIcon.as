package red.game.witcher3.controls 
{
    import flash.display.*;
    import red.core.constants.*;
    
    public class KeyboardButtonMouseIcon extends flash.display.MovieClip
    {
        public function KeyboardButtonMouseIcon()
        {
            super();
            return;
        }

        public function isMouseKey(arg1:uint):Boolean
        {
            return arg1 >= red.core.constants.KeyCode.LEFT_MOUSE && arg1 <= red.core.constants.KeyCode.MIDDLE_MOUSE || arg1 == red.core.constants.KeyCode.MOUSE_WHEEL_UP || arg1 == red.core.constants.KeyCode.MOUSE_WHEEL_DOWN || arg1 == red.core.constants.KeyCode.MOUSE_PAN || arg1 == red.core.constants.KeyCode.MOUSE_SCROLL;
        }

        public function get keyCode():uint
        {
            return this._keyCode;
        }

        public function set keyCode(arg1:uint):void
        {
            this._keyCode = arg1;
            this.updateIcon();
            return;
        }

        protected function updateIcon():void
        {
            var loc1:*=this._keyCode;
            switch (loc1) 
            {
                case red.core.constants.KeyCode.LEFT_MOUSE:
                {
                    gotoAndStop(this.LABEL_BTN_LEFT);
                    break;
                }
                case red.core.constants.KeyCode.RIGHT_MOUSE:
                {
                    gotoAndStop(this.LABEL_BTN_RIGHT);
                    break;
                }
                case red.core.constants.KeyCode.MIDDLE_MOUSE:
                {
                    gotoAndStop(this.LABEL_BTN_MIDDLE);
                    break;
                }
                case red.core.constants.KeyCode.MOUSE_WHEEL_UP:
                {
                    gotoAndStop(this.LABEL_SCROLL_UP);
                    break;
                }
                case red.core.constants.KeyCode.MOUSE_WHEEL_DOWN:
                {
                    gotoAndStop(this.LABEL_SCROLL_DOWN);
                    break;
                }
                case red.core.constants.KeyCode.MOUSE_SCROLL:
                {
                    gotoAndStop(this.LABEL_SCROLL);
                    break;
                }
                case red.core.constants.KeyCode.MOUSE_PAN:
                {
                    gotoAndStop(this.LABEL_PAN);
                    break;
                }
            }
            return;
        }

        private const LABEL_BTN_LEFT:String="left";

        private const LABEL_BTN_RIGHT:String="right";

        private const LABEL_BTN_MIDDLE:String="middle";

        private const LABEL_SCROLL_UP:String="scroll_up";

        private const LABEL_SCROLL_DOWN:String="scroll_down";

        private const LABEL_PAN:String="pan";

        private const LABEL_SCROLL:String="scroll";

        protected var _keyCode:uint;
    }
}

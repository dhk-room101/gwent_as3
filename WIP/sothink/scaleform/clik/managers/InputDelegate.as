package scaleform.clik.managers
{
    import flash.display.*;
    import flash.events.*;
    import red.core.constants.*;
    import red.core.data.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class InputDelegate extends EventDispatcher
    {
        public var stage:Stage;
        public var externalInputHandler:Function;
        protected var keyHash:Array;
        private var _inputEventDisabled:Boolean = false;
        private var _swapAcceptCancel:Boolean = false;
        private static var instance:InputDelegate;
        public static const MAX_KEY_CODES:uint = 1000;
        public static const KEY_PRESSED:uint = 1;
        public static const KEY_SUPRESSED:uint = 2;

        public function InputDelegate()
        {
            this.keyHash = [];
            return;
        }// end function

        public function initialize(param1:Stage) : void
        {
            this.stage = param1;
            if (!this._inputEventDisabled)
            {
                param1.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false, 0, true);
                param1.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, false, 0, true);
                param1.addEventListener(GamePadAnalogEvent.CHANGE, this.handleGamePad, false, 0, true);
            }
            return;
        }// end function

        public function disableInputEvents(param1:Boolean) : void
        {
            this._inputEventDisabled = param1;
            if (this.stage)
            {
                this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false);
                this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, false);
                this.stage.removeEventListener(GamePadAnalogEvent.CHANGE, this.handleGamePad, false);
                if (!param1)
                {
                    this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false, 0, true);
                    this.stage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, false, 0, true);
                    this.stage.addEventListener(GamePadAnalogEvent.CHANGE, this.handleGamePad, false, 0, true);
                }
                else
                {
                    this.keyHash = [];
                }
            }
            return;
        }// end function

        public function get swapAcceptCancel() : Boolean
        {
            return this._swapAcceptCancel;
        }// end function

        public function set swapAcceptCancel(param1:Boolean) : void
        {
            this._swapAcceptCancel = param1;
            return;
        }// end function

        public function setKeyRepeat(param1:Number, param2:Boolean, param3:uint = 0) : void
        {
            var _loc_4:* = param3 * MAX_KEY_CODES + param1;
            if (param2)
            {
                this.keyHash[_loc_4] = this.keyHash[_loc_4] & ~KEY_SUPRESSED;
            }
            else
            {
                this.keyHash[_loc_4] = this.keyHash[_loc_4] | KEY_SUPRESSED;
            }
            return;
        }// end function

        public function inputToNav(param1:String, param2:Number, param3:Boolean = false, param4 = null) : String
        {
            if (this.externalInputHandler != null)
            {
                return this.externalInputHandler(param1, param2, param4);
            }
            if (param1 == "key")
            {
                switch(param2)
                {
                    case KeyCode.UP:
                    {
                        return NavigationCode.UP;
                    }
                    case KeyCode.PAD_DIGIT_UP:
                    {
                        return NavigationCode.DPAD_UP;
                    }
                    case KeyCode.DOWN:
                    {
                        return NavigationCode.DOWN;
                    }
                    case KeyCode.PAD_DIGIT_DOWN:
                    {
                        return NavigationCode.DPAD_DOWN;
                    }
                    case KeyCode.PAD_DIGIT_LEFT:
                    {
                        return NavigationCode.DPAD_LEFT;
                    }
                    case KeyCode.LEFT:
                    {
                        return NavigationCode.LEFT;
                    }
                    case KeyCode.RIGHT:
                    {
                        return NavigationCode.RIGHT;
                    }
                    case KeyCode.PAD_DIGIT_RIGHT:
                    {
                        return NavigationCode.DPAD_RIGHT;
                    }
                    case KeyCode.ENTER:
                    case KeyCode.SPACE:
                    {
                        return NavigationCode.ENTER;
                    }
                    case KeyCode.BACKSPACE:
                    {
                        return NavigationCode.BACK;
                    }
                    case KeyCode.TAB:
                    {
                        if (param3)
                        {
                            return NavigationCode.SHIFT_TAB;
                        }
                        return NavigationCode.TAB;
                    }
                    case KeyCode.HOME:
                    {
                        return NavigationCode.HOME;
                    }
                    case KeyCode.END:
                    {
                        return NavigationCode.END;
                    }
                    case KeyCode.PAGE_DOWN:
                    {
                        return NavigationCode.PAGE_DOWN;
                    }
                    case KeyCode.PAGE_UP:
                    {
                        return NavigationCode.PAGE_UP;
                    }
                    case KeyCode.ESCAPE:
                    {
                        return NavigationCode.ESCAPE;
                    }
                    case KeyCode.PAD_A_CROSS:
                    {
                        return NavigationCode.GAMEPAD_A;
                    }
                    case KeyCode.PAD_B_CIRCLE:
                    {
                        return NavigationCode.GAMEPAD_B;
                    }
                    case KeyCode.PAD_X_SQUARE:
                    {
                        return NavigationCode.GAMEPAD_X;
                    }
                    case KeyCode.PAD_Y_TRIANGLE:
                    {
                        return NavigationCode.GAMEPAD_Y;
                    }
                    case KeyCode.PAD_LEFT_SHOULDER:
                    {
                        return NavigationCode.GAMEPAD_L1;
                    }
                    case KeyCode.PAD_LEFT_TRIGGER:
                    {
                        return NavigationCode.GAMEPAD_L2;
                    }
                    case KeyCode.PAD_LEFT_THUMB:
                    {
                        return NavigationCode.GAMEPAD_L3;
                    }
                    case KeyCode.PAD_RIGHT_SHOULDER:
                    {
                        return NavigationCode.GAMEPAD_R1;
                    }
                    case KeyCode.PAD_RIGHT_TRIGGER:
                    {
                        return NavigationCode.GAMEPAD_R2;
                    }
                    case KeyCode.PAD_RIGHT_THUMB:
                    {
                        return NavigationCode.GAMEPAD_R3;
                    }
                    case KeyCode.PAD_START:
                    {
                        return NavigationCode.GAMEPAD_START;
                    }
                    case KeyCode.PAD_BACK_SELECT:
                    {
                        return NavigationCode.GAMEPAD_BACK;
                    }
                    case KeyCode.PAD_LEFT_STICK_UP:
                    {
                        return NavigationCode.UP;
                    }
                    case KeyCode.PAD_LEFT_STICK_DOWN:
                    {
                        return NavigationCode.DOWN;
                    }
                    case KeyCode.PAD_LEFT_STICK_LEFT:
                    {
                        return NavigationCode.LEFT;
                    }
                    case KeyCode.PAD_LEFT_STICK_RIGHT:
                    {
                        return NavigationCode.RIGHT;
                    }
                    case KeyCode.PAD_RIGHT_STICK_DOWN:
                    {
                        return NavigationCode.RIGHT_STICK_DOWN;
                    }
                    case KeyCode.PAD_RIGHT_STICK_UP:
                    {
                        return NavigationCode.RIGHT_STICK_UP;
                    }
                    case KeyCode.PAD_RIGHT_STICK_LEFT:
                    {
                        return NavigationCode.RIGHT_STICK_LEFT;
                    }
                    case KeyCode.PAD_RIGHT_STICK_RIGHT:
                    {
                        return NavigationCode.RIGHT_STICK_RIGHT;
                    }
                    case KeyCode.PAD_PS4_OPTIONS:
                    {
                        return NavigationCode.GAMEPAD_BACK;
                    }
                    case KeyCode.PAD_PS4_TOUCH_PRESS:
                    {
                        return NavigationCode.START;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return null;
        }// end function

        public function readInput(param1:String, param2:int, param3:Function) : Object
        {
            return null;
        }// end function

        protected function handleKeyDown(event:KeyboardEvent) : void
        {
            var _loc_2:* = event as KeyboardEventEx;
            var _loc_3:* = _loc_2 == null ? (0) : (_loc_2.controllerIdx);
            var _loc_4:* = event.keyCode;
            var _loc_5:* = _loc_3 * MAX_KEY_CODES + _loc_4;
            var _loc_6:* = this.keyHash[_loc_5];
            if (_loc_6 & KEY_PRESSED)
            {
                if ((_loc_6 & KEY_SUPRESSED) == 0)
                {
                    this.handleKeyPress(InputValue.KEY_HOLD, _loc_4, _loc_3, event.ctrlKey, event.altKey, event.shiftKey);
                }
            }
            else
            {
                this.handleKeyPress(InputValue.KEY_DOWN, _loc_4, _loc_3, event.ctrlKey, event.altKey, event.shiftKey);
                this.keyHash[_loc_5] = this.keyHash[_loc_5] | KEY_PRESSED;
            }
            return;
        }// end function

        protected function handleKeyUp(event:KeyboardEvent) : void
        {
            var _loc_2:* = event as KeyboardEventEx;
            var _loc_3:* = _loc_2 == null ? (0) : (_loc_2.controllerIdx);
            var _loc_4:* = event.keyCode;
            var _loc_5:* = _loc_3 * MAX_KEY_CODES + _loc_4;
            this.keyHash[_loc_5] = this.keyHash[_loc_5] & ~KEY_PRESSED;
            this.handleKeyPress(InputValue.KEY_UP, _loc_4, _loc_3, event.ctrlKey, event.altKey, event.shiftKey);
            return;
        }// end function

        protected function handleGamePad(event:GamePadAnalogEvent) : void
        {
            var _loc_6:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = false;
            var _loc_4:* = event.xvalue;
            var _loc_5:* = event.yvalue;
            switch(event.code)
            {
                case GamePad.PAD_LT:
                {
                    _loc_2 = KeyCode.PAD_LEFT_STICK_AXIS;
                    _loc_3 = true;
                    break;
                }
                case GamePad.PAD_RT:
                {
                    _loc_2 = KeyCode.PAD_RIGHT_STICK_AXIS;
                    _loc_3 = true;
                    break;
                }
                case GamePad.PAD_L2:
                {
                    _loc_2 = KeyCode.PAD_LEFT_TRIGGER_AXIS;
                    break;
                }
                case GamePad.PAD_R2:
                {
                    _loc_2 = KeyCode.PAD_RIGHT_TRIGGER_AXIS;
                }
                default:
                {
                    break;
                    break;
                }
            }
            if (_loc_2 != 0)
            {
                _loc_6 = new InputDetails("axis", _loc_2, new InputAxisData(_loc_4, _loc_5), null, event.controllerIdx, false, false, false, _loc_3);
                dispatchEvent(new InputEvent(InputEvent.INPUT, _loc_6));
            }
            return;
        }// end function

        protected function handleKeyPress(param1:String, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean) : void
        {
            var _loc_7:* = new InputDetails("key", param2, param1, this.inputToNav("key", param2, param6), param3, param4, param5, param6);
            this.morphLeftStickPressDetails(_loc_7);
            if (this._swapAcceptCancel)
            {
                this.swapAcceptCancelInputDetails(_loc_7);
            }
            dispatchEvent(new InputEvent(InputEvent.INPUT, _loc_7));
            return;
        }// end function

        protected function swapAcceptCancelInputDetails(param1:InputDetails) : void
        {
            if (param1.code == KeyCode.PAD_A_CROSS)
            {
                param1.code = KeyCode.PAD_B_CIRCLE;
                param1.navEquivalent = NavigationCode.GAMEPAD_B;
            }
            else if (param1.code == KeyCode.PAD_B_CIRCLE)
            {
                param1.code = KeyCode.PAD_A_CROSS;
                param1.navEquivalent = NavigationCode.GAMEPAD_A;
            }
            return;
        }// end function

        protected function morphLeftStickPressDetails(param1:InputDetails) : void
        {
            switch(param1.code)
            {
                case KeyCode.PAD_LEFT_STICK_UP:
                {
                    param1.code = KeyCode.UP;
                    param1.fromJoystick = true;
                    break;
                }
                case KeyCode.PAD_LEFT_STICK_DOWN:
                {
                    param1.code = KeyCode.DOWN;
                    param1.fromJoystick = true;
                    break;
                }
                case KeyCode.PAD_LEFT_STICK_LEFT:
                {
                    param1.code = KeyCode.LEFT;
                    param1.fromJoystick = true;
                    break;
                }
                case KeyCode.PAD_LEFT_STICK_RIGHT:
                {
                    param1.code = KeyCode.RIGHT;
                    param1.fromJoystick = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public static function getInstance() : InputDelegate
        {
            if (instance == null)
            {
                instance = new InputDelegate;
            }
            return instance;
        }// end function

    }
}

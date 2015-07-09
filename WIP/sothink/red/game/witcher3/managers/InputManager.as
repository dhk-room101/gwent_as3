package red.game.witcher3.managers
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.utils.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.events.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;

    public class InputManager extends EventDispatcher
    {
        protected var currentHoldInterval:Number = 200;
        private var _inputBlocks:Object;
        protected var _inputDelegate:InputDelegate;
        protected var _rootStage:DisplayObjectContainer;
        protected var _isGamepad:Boolean;
        protected var _gpadInputReceived:Boolean;
        protected var _pendedGamepadInput:Boolean;
        protected var _pressedMap:Object;
        protected var _holdTimer:Timer;
        protected var _ctrlChangeTimer:Timer;
        protected var _bufMouseX:Number = 0;
        protected var _bufMouseY:Number = 0;
        protected var _platformType:uint = 0;
        protected var _initialized:Boolean;
        protected var _enableHoldEmulation:Boolean;
        protected var _enableInputDeviceCheck:Boolean;
        protected var _swapAcceptCancel:Boolean;
        protected var _lockedControlScheme:uint = 0;
        protected var _gamepadType:uint = 0;
        public static const LOCKED_SCHEME_NONE:uint = 0;
        public static const LOCKED_SCHEME_GPAD:uint = 1;
        public static const LOCKED_SCHEME_MOUSE:uint = 2;
        public static const GAMEPAD_TYPE_XBOX:uint = 0;
        public static const GAMEPAD_TYPE_PS4:uint = 1;
        public static const GAMEPAD_TYPE_STEAM:uint = 2;
        static const CHANGE_CONTROLLER_TYPE_DELAY:Number = -1;
        static const CHANGE_CONTROLLER_MOUSE_DELTA:Number = 20;
        static const HOLD_DELAY:Number = 500;
        static const HOLD_INTERVAL:Number = 200;
        static const HOLD_INTERVAL_MIN:Number = 30;
        static const HOLD_INTERVAL_SPEED_UP_SCALE:Number = 0.88;
        static var _instance:InputManager;

        public function InputManager()
        {
            this._inputBlocks = {};
            this._pressedMap = {};
            return;
        }// end function

        public function init(param1:DisplayObjectContainer, param2:Boolean = true, param3:Boolean = true) : void
        {
            if (this._initialized)
            {
                return;
            }
            if (!param1)
            {
                return;
            }
            if (ExternalInterface.available)
            {
                this._isGamepad = true;
            }
            this._initialized = true;
            this._rootStage = param1;
            this.enableInputDeviceCheck = param3;
            this.enableHoldEmulation = param2;
            return;
        }// end function

        public function addInputBlocker(param1:Boolean, param2:String = "default") : void
        {
            this._inputBlocks[param2] = param1 ? (1) : (0);
            this.updateInputBlockers();
            return;
        }// end function

        public function removeInputBlocker(param1:String = "default") : void
        {
            delete this._inputBlocks[param1];
            this.updateInputBlockers();
            return;
        }// end function

        protected function updateInputBlockers() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = false;
            var _loc_2:* = false;
            for (_loc_3 in this._inputBlocks)
            {
                
                if (_loc_5[_loc_3])
                {
                    _loc_1 = true;
                    continue;
                }
                _loc_2 = true;
                break;
            }
            if (_loc_2 || !_loc_1)
            {
                InputDelegate.getInstance().disableInputEvents(false);
            }
            else
            {
                InputDelegate.getInstance().disableInputEvents(true);
            }
            return;
        }// end function

        public function forceInputFeedbackUpdate() : void
        {
            this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            return;
        }// end function

        public function get gamepadType() : uint
        {
            if (this._platformType == PlatformType.PLATFORM_PS4)
            {
                return GAMEPAD_TYPE_PS4;
            }
            if (this._platformType == PlatformType.PLATFORM_XBOX1)
            {
                return GAMEPAD_TYPE_XBOX;
            }
            return this._gamepadType;
        }// end function

        public function set gamepadType(param1:uint) : void
        {
            this._gamepadType = param1;
            return;
        }// end function

        public function get lockedControlScheme() : uint
        {
            return this._lockedControlScheme;
        }// end function

        public function set lockedControlScheme(param1:uint) : void
        {
            switch(this._lockedControlScheme)
            {
                case LOCKED_SCHEME_GPAD:
                {
                    this.setGamepadInputType(true, true);
                    break;
                }
                case LOCKED_SCHEME_MOUSE:
                {
                    this.setGamepadInputType(false, true);
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._lockedControlScheme = param1;
            return;
        }// end function

        public function get swapAcceptCancel() : Boolean
        {
            return this._swapAcceptCancel;
        }// end function

        public function set swapAcceptCancel(param1:Boolean) : void
        {
            this._swapAcceptCancel = param1;
            this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            return;
        }// end function

        public function get enableInputDeviceCheck() : Boolean
        {
            return this._enableInputDeviceCheck;
        }// end function

        public function set enableInputDeviceCheck(param1:Boolean) : void
        {
            this._enableInputDeviceCheck = param1;
            this._rootStage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouse, false);
            this._rootStage.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouse, false);
            this._rootStage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouse, false);
            if (this._enableInputDeviceCheck)
            {
                this._rootStage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouse, false, 0, true);
                this._rootStage.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouse, false, 0, true);
                this._rootStage.addEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouse, false, 0, true);
            }
            this.updateInputListeners();
            return;
        }// end function

        public function get enableHoldEmulation() : Boolean
        {
            return this._enableHoldEmulation;
        }// end function

        public function set enableHoldEmulation(param1:Boolean) : void
        {
            this._enableHoldEmulation = param1;
            if (this._holdTimer)
            {
                this._holdTimer.stop();
                this._holdTimer.removeEventListener(TimerEvent.TIMER, this.handleHoldEvent);
                this._holdTimer = null;
            }
            if (this._enableHoldEmulation)
            {
                this._holdTimer = new Timer(HOLD_DELAY);
                this._holdTimer.addEventListener(TimerEvent.TIMER, this.handleHoldEvent, false, 0, true);
                this._holdTimer.start();
            }
            this.updateInputListeners();
            return;
        }// end function

        public function getPlatform() : uint
        {
            return this._platformType;
        }// end function

        public function isGamepad() : Boolean
        {
            return this._isGamepad || this._platformType != PlatformType.PLATFORM_PC;
        }// end function

        public function setControllerType(param1:Boolean) : void
        {
            if (param1 != this._isGamepad)
            {
                this.setGamepadInputType(param1);
            }
            return;
        }// end function

        public function setPlatformType(param1:uint) : void
        {
            this._platformType = param1;
            this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            return;
        }// end function

        protected function updateInputListeners() : void
        {
            if (this._enableInputDeviceCheck || this._enableHoldEmulation)
            {
                this._inputDelegate = InputDelegate.getInstance();
                this._inputDelegate.addEventListener(InputEvent.INPUT, this.handleDelegatedInput, false, 1, true);
            }
            else
            {
                this._inputDelegate = InputDelegate.getInstance();
                this._inputDelegate.removeEventListener(InputEvent.INPUT, this.handleDelegatedInput, false);
                this._inputDelegate = null;
            }
            return;
        }// end function

        protected function handleHoldEvent(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (this.currentHoldInterval == HOLD_DELAY)
            {
                this.currentHoldInterval = HOLD_INTERVAL;
            }
            this.currentHoldInterval = Math.max(this.currentHoldInterval * HOLD_INTERVAL_SPEED_UP_SCALE, HOLD_INTERVAL_MIN);
            this._holdTimer.delay = this.currentHoldInterval;
            this._holdTimer.reset();
            this._holdTimer.start();
            for (_loc_2 in this._pressedMap)
            {
                
                _loc_3 = _loc_9[_loc_2] as InputEvent;
                _loc_4 = _loc_3.details;
                _loc_5 = _loc_4.code;
                _loc_6 = _loc_4.navEquivalent;
                if (this.swapAcceptCancel)
                {
                    if (_loc_4.code == KeyCode.PAD_A_CROSS)
                    {
                        _loc_5 = KeyCode.PAD_B_CIRCLE;
                        _loc_6 = NavigationCode.GAMEPAD_B;
                    }
                    else if (_loc_4.code == KeyCode.PAD_B_CIRCLE)
                    {
                        _loc_5 = KeyCode.PAD_A_CROSS;
                        _loc_6 = NavigationCode.GAMEPAD_A;
                    }
                }
                _loc_7 = new InputDetails("key", _loc_5, InputValue.KEY_HOLD, _loc_6, _loc_4.controllerIndex, _loc_4.ctrlKey, _loc_4.altKey, _loc_4.shiftKey, _loc_4.fromJoystick);
                this._inputDelegate.dispatchEvent(new InputEvent(InputEvent.INPUT, _loc_7));
            }
            return;
        }// end function

        protected function handleDelegatedInput(event:InputEvent) : void
        {
            var _loc_3:* = false;
            var _loc_2:* = event.details;
            if (this._platformType == PlatformType.PLATFORM_PC)
            {
                _loc_3 = this.isGamepadCode(_loc_2);
            }
            else
            {
                _loc_3 = true;
            }
            if (this._enableHoldEmulation)
            {
                this.holdProcessing(event);
            }
            if (_loc_3)
            {
                this._gpadInputReceived = true;
                this.setGamepadInputType(true);
                return;
            }
            if (this._gpadInputReceived || _loc_2.value == InputValue.KEY_HOLD)
            {
                this._gpadInputReceived = false;
                return;
            }
            this.setGamepadInputType(false);
            return;
        }// end function

        protected function holdProcessing(event:InputEvent) : void
        {
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.code;
            if (_loc_2.value == InputValue.KEY_DOWN)
            {
                this._holdTimer.delay = HOLD_DELAY;
                this.currentHoldInterval = HOLD_DELAY;
                this._holdTimer.reset();
                this._holdTimer.start();
                if (!this._pressedMap[_loc_3])
                {
                    this._pressedMap[_loc_3] = event;
                }
            }
            else if (_loc_2.value == InputValue.KEY_UP)
            {
                delete this._pressedMap[_loc_3];
                this._holdTimer.stop();
                this.currentHoldInterval = HOLD_DELAY;
            }
            return;
        }// end function

        protected function handleMouse(event:MouseEvent) : void
        {
            var _loc_2:* = Math.abs(event.stageX - this._bufMouseX);
            var _loc_3:* = Math.abs(event.stageY - this._bufMouseY);
            if (_loc_2 > CHANGE_CONTROLLER_MOUSE_DELTA || _loc_3 > CHANGE_CONTROLLER_MOUSE_DELTA)
            {
                this.setGamepadInputType(false);
            }
            this._bufMouseX = event.stageX;
            this._bufMouseY = event.stageY;
            return;
        }// end function

        protected function setGamepadInputType(param1:Boolean, param2:Boolean = false) : void
        {
            if (!this._ctrlChangeTimer && param1 != this._isGamepad || this._ctrlChangeTimer && param1 != this._pendedGamepadInput)
            {
                if (this._ctrlChangeTimer)
                {
                    this._ctrlChangeTimer.removeEventListener(TimerEvent.TIMER, this.delayedFireControllerChangeEvent);
                    this._ctrlChangeTimer.stop();
                }
                if (this.lockedControlScheme != LOCKED_SCHEME_NONE && !param2)
                {
                    Console.WriteLine("GFX Control scheme locked! Cant change it to from [gamepad ", this._isGamepad, "] to [gamepad ", param1, "]");
                    return;
                }
                if (CHANGE_CONTROLLER_TYPE_DELAY > 0)
                {
                    this._pendedGamepadInput = param1;
                    this._ctrlChangeTimer = new Timer(CHANGE_CONTROLLER_TYPE_DELAY, 1);
                    this._ctrlChangeTimer.addEventListener(TimerEvent.TIMER, this.delayedFireControllerChangeEvent, false, 0, true);
                    this._ctrlChangeTimer.start();
                }
                else
                {
                    this._isGamepad = param1;
                    this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
                }
            }
            return;
        }// end function

        protected function delayedFireControllerChangeEvent(event:TimerEvent) : void
        {
            if (this._pendedGamepadInput != this._isGamepad)
            {
                this._isGamepad = this._pendedGamepadInput;
                this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            }
            if (this._ctrlChangeTimer)
            {
                this._ctrlChangeTimer.removeEventListener(TimerEvent.TIMER, this.delayedFireControllerChangeEvent);
                this._ctrlChangeTimer.stop();
                this._ctrlChangeTimer = null;
            }
            return;
        }// end function

        protected function fireCtrlChangeEvent(param1:Boolean, param2:uint) : void
        {
            var _loc_3:* = new ControllerChangeEvent(ControllerChangeEvent.CONTROLLER_CHANGE);
            _loc_3.isGamepad = param1 || param2 != PlatformType.PLATFORM_PC;
            _loc_3.platformType = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

        protected function isGamepadCode(param1:InputDetails) : Boolean
        {
            if (param1.fromJoystick)
            {
                return true;
            }
            var _loc_2:* = param1.code;
            switch(_loc_2)
            {
                case KeyCode.PAD_A_CROSS:
                case KeyCode.PAD_B_CIRCLE:
                case KeyCode.PAD_X_SQUARE:
                case KeyCode.PAD_Y_TRIANGLE:
                case KeyCode.PAD_START:
                case KeyCode.PAD_BACK_SELECT:
                case KeyCode.PAD_DIGIT_UP:
                case KeyCode.PAD_DIGIT_DOWN:
                case KeyCode.PAD_DIGIT_LEFT:
                case KeyCode.PAD_DIGIT_RIGHT:
                case KeyCode.PAD_LEFT_THUMB:
                case KeyCode.PAD_RIGHT_THUMB:
                case KeyCode.PAD_LEFT_SHOULDER:
                case KeyCode.PAD_RIGHT_SHOULDER:
                case KeyCode.PAD_LEFT_TRIGGER:
                case KeyCode.PAD_RIGHT_TRIGGER:
                case KeyCode.PAD_LEFT_STICK_AXIS:
                case KeyCode.PAD_RIGHT_STICK_AXIS:
                case KeyCode.PAD_LEFT_TRIGGER_AXIS:
                case KeyCode.PAD_RIGHT_TRIGGER_AXIS:
                case KeyCode.PAD_RIGHT_STICK_LEFT:
                case KeyCode.PAD_RIGHT_STICK_RIGHT:
                case KeyCode.PAD_RIGHT_STICK_DOWN:
                case KeyCode.PAD_RIGHT_STICK_UP:
                {
                    return true;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        public function reset() : void
        {
            if (this._pressedMap)
            {
                this._holdTimer.reset();
                this._holdTimer.stop();
                this._pressedMap = {};
            }
            return;
        }// end function

        public static function getInstance() : InputManager
        {
            if (!_instance)
            {
                _instance = new InputManager;
            }
            return _instance;
        }// end function

    }
}

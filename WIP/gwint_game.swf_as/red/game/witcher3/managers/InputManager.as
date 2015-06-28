///InputManager
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
    
    public class InputManager extends flash.events.EventDispatcher
    {
        public function InputManager()
        {
            this._inputBlocks = {};
            this._pressedMap = {};
            super();
            return;
        }

        public function get enableHoldEmulation():Boolean
        {
            return this._enableHoldEmulation;
        }

        public function set enableHoldEmulation(arg1:Boolean):void
        {
            this._enableHoldEmulation = arg1;
            if (this._holdTimer) 
            {
                this._holdTimer.stop();
                this._holdTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.handleHoldEvent);
                this._holdTimer = null;
            }
            if (this._enableHoldEmulation) 
            {
                this._holdTimer = new flash.utils.Timer(HOLD_DELAY);
                this._holdTimer.addEventListener(flash.events.TimerEvent.TIMER, this.handleHoldEvent, false, 0, true);
                this._holdTimer.start();
            }
            this.updateInputListeners();
            return;
        }

        public function getPlatform():uint
        {
            return this._platformType;
        }

        public function isGamepad():Boolean
        {
            return this._isGamepad || !(this._platformType == red.game.witcher3.constants.PlatformType.PLATFORM_PC);
        }

        public function setControllerType(arg1:Boolean):void
        {
            if (arg1 != this._isGamepad) 
            {
                this.setGamepadInputType(arg1);
            }
            return;
        }

        public function set enableInputDeviceCheck(arg1:Boolean):void
        {
            this._enableInputDeviceCheck = arg1;
            this._rootStage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.handleMouse, false);
            this._rootStage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.handleMouse, false);
            this._rootStage.removeEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.handleMouse, false);
            if (this._enableInputDeviceCheck) 
            {
                this._rootStage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.handleMouse, false, 0, true);
                this._rootStage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.handleMouse, false, 0, true);
                this._rootStage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.handleMouse, false, 0, true);
            }
            this.updateInputListeners();
            return;
        }

        public function setPlatformType(arg1:uint):void
        {
            this._platformType = arg1;
            this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            return;
        }

        protected function updateInputListeners():void
        {
            if (this._enableInputDeviceCheck || this._enableHoldEmulation) 
            {
                this._inputDelegate = scaleform.clik.managers.InputDelegate.getInstance();
                this._inputDelegate.addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleDelegatedInput, false, 1, true);
            }
            else 
            {
                this._inputDelegate = scaleform.clik.managers.InputDelegate.getInstance();
                this._inputDelegate.removeEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleDelegatedInput, false);
                this._inputDelegate = null;
            }
            return;
        }

        protected function handleHoldEvent(arg1:flash.events.Event):void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=0;
            var loc5:*=null;
            var loc6:*=null;
            if (this.currentHoldInterval == HOLD_DELAY) 
            {
                this.currentHoldInterval = HOLD_INTERVAL;
            }
            this.currentHoldInterval = Math.max(this.currentHoldInterval * HOLD_INTERVAL_SPEED_UP_SCALE, HOLD_INTERVAL_MIN);
            this._holdTimer.delay = this.currentHoldInterval;
            this._holdTimer.reset();
            this._holdTimer.start();
            var loc7:*=0;
            var loc8:*=this._pressedMap;
            for (loc1 in loc8) 
            {
                loc2 = this._pressedMap[loc1] as scaleform.clik.events.InputEvent;
                loc4 = (loc3 = loc2.details).code;
                loc5 = loc3.navEquivalent;
                if (this.swapAcceptCancel) 
                {
                    if (loc3.code != red.game.witcher3.constants.KeyCode.PAD_A_CROSS) 
                    {
                        if (loc3.code == red.game.witcher3.constants.KeyCode.PAD_B_CIRCLE) 
                        {
                            loc4 = red.game.witcher3.constants.KeyCode.PAD_A_CROSS;
                            loc5 = scaleform.clik.constants.NavigationCode.GAMEPAD_A;
                        }
                    }
                    else 
                    {
                        loc4 = red.game.witcher3.constants.KeyCode.PAD_B_CIRCLE;
                        loc5 = scaleform.clik.constants.NavigationCode.GAMEPAD_B;
                    }
                }
                loc6 = new scaleform.clik.ui.InputDetails("key", loc4, scaleform.clik.constants.InputValue.KEY_HOLD, loc5, loc3.controllerIndex, loc3.ctrlKey, loc3.altKey, loc3.shiftKey, loc3.fromJoystick);
                this._inputDelegate.dispatchEvent(new scaleform.clik.events.InputEvent(scaleform.clik.events.InputEvent.INPUT, loc6));
            }
            return;
        }

        protected function handleDelegatedInput(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc2:*=false;
            var loc1:*=arg1.details;
            if (this._platformType != red.game.witcher3.constants.PlatformType.PLATFORM_PC) 
            {
                loc2 = true;
            }
            else 
            {
                loc2 = this.isGamepadCode(loc1);
            }
            if (this._enableHoldEmulation) 
            {
                this.holdProcessing(arg1);
            }
            if (loc2) 
            {
                this._gpadInputReceived = true;
                this.setGamepadInputType(true);
                return;
            }
            if (this._gpadInputReceived || arg1.details.value == scaleform.clik.constants.InputValue.KEY_HOLD) 
            {
                this._gpadInputReceived = false;
                return;
            }
            this.setGamepadInputType(false);
            return;
        }

        protected function holdProcessing(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=arg1.details;
            var loc2:*=loc1.code;
            if (loc1.value != scaleform.clik.constants.InputValue.KEY_DOWN) 
            {
                if (loc1.value == scaleform.clik.constants.InputValue.KEY_UP) 
                {
                    delete this._pressedMap[loc2];
                    this._holdTimer.stop();
                    this.currentHoldInterval = HOLD_DELAY;
                }
            }
            else 
            {
                this._holdTimer.delay = HOLD_DELAY;
                this.currentHoldInterval = HOLD_DELAY;
                this._holdTimer.reset();
                this._holdTimer.start();
                if (!this._pressedMap[loc2]) 
                {
                    this._pressedMap[loc2] = arg1;
                }
            }
            return;
        }

        protected function handleMouse(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=Math.abs(arg1.stageX - this._bufMouseX);
            var loc2:*=Math.abs(arg1.stageY - this._bufMouseY);
            if (loc1 > CHANGE_CONTROLLER_MOUSE_DELTA || loc2 > CHANGE_CONTROLLER_MOUSE_DELTA) 
            {
                this.setGamepadInputType(false);
            }
            this._bufMouseX = arg1.stageX;
            this._bufMouseY = arg1.stageY;
            return;
        }

        protected function setGamepadInputType(arg1:Boolean):void
        {
            if (!this._ctrlChangeTimer && !(arg1 == this._isGamepad) || this._ctrlChangeTimer && !(arg1 == this._pendedGamepadInput)) 
            {
                if (this._ctrlChangeTimer) 
                {
                    this._ctrlChangeTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.delayedFireControllerChangeEvent);
                    this._ctrlChangeTimer.stop();
                }
                if (CHANGE_CONTROLLER_TYPE_DELAY > 0) 
                {
                    this._pendedGamepadInput = arg1;
                    this._ctrlChangeTimer = new flash.utils.Timer(CHANGE_CONTROLLER_TYPE_DELAY, 1);
                    this._ctrlChangeTimer.addEventListener(flash.events.TimerEvent.TIMER, this.delayedFireControllerChangeEvent, false, 0, true);
                    this._ctrlChangeTimer.start();
                }
                else 
                {
                    this._isGamepad = arg1;
                    this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
                }
            }
            return;
        }

        protected function delayedFireControllerChangeEvent(arg1:flash.events.TimerEvent):void
        {
            if (this._pendedGamepadInput != this._isGamepad) 
            {
                this._isGamepad = this._pendedGamepadInput;
                this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            }
            if (this._ctrlChangeTimer) 
            {
                this._ctrlChangeTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.delayedFireControllerChangeEvent);
                this._ctrlChangeTimer.stop();
                this._ctrlChangeTimer = null;
            }
            return;
        }

        protected function fireCtrlChangeEvent(arg1:Boolean, arg2:uint):void
        {
            var loc1:*=new red.game.witcher3.events.ControllerChangeEvent(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE);
            loc1.isGamepad = arg1 || !(arg2 == red.game.witcher3.constants.PlatformType.PLATFORM_PC);
            loc1.platformType = arg2;
            dispatchEvent(loc1);
            return;
        }

        protected function isGamepadCode(arg1:scaleform.clik.ui.InputDetails):Boolean
        {
            if (arg1.fromJoystick) 
            {
                return true;
            }
            var loc1:*=arg1.code;
            var loc2:*=loc1;
            switch (loc2) 
            {
                case red.game.witcher3.constants.KeyCode.PAD_A_CROSS:
                case red.game.witcher3.constants.KeyCode.PAD_B_CIRCLE:
                case red.game.witcher3.constants.KeyCode.PAD_X_SQUARE:
                case red.game.witcher3.constants.KeyCode.PAD_Y_TRIANGLE:
                case red.game.witcher3.constants.KeyCode.PAD_START:
                case red.game.witcher3.constants.KeyCode.PAD_BACK_SELECT:
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_UP:
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_DOWN:
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_LEFT:
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_RIGHT:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_THUMB:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_THUMB:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_SHOULDER:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_SHOULDER:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_TRIGGER:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_TRIGGER:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_STICK_AXIS:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_AXIS:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_TRIGGER_AXIS:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_TRIGGER_AXIS:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_LEFT:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_RIGHT:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_DOWN:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_UP:
                {
                    return true;
                }
            }
            return false;
        }

        public function reset():void
        {
            if (this._pressedMap) 
            {
                this._holdTimer.reset();
                this._holdTimer.stop();
                this._pressedMap = {};
            }
            return;
        }

        public function init(arg1:flash.display.DisplayObjectContainer, arg2:Boolean=true, arg3:Boolean=true):void
        {
            if (this._initialized) 
            {
                return;
            }
            if (!arg1) 
            {
                return;
            }
            if (flash.external.ExternalInterface.available) 
            {
                this._isGamepad = true;
            }
            this._initialized = true;
            this._rootStage = arg1;
            this.enableInputDeviceCheck = arg3;
            this.enableHoldEmulation = arg2;
            return;
        }

        public function addInputBlocker(arg1:Boolean, arg2:String="default"):void
        {
            this._inputBlocks[arg2] = arg1;
            this.updateInputBlockers();
            return;
        }

        public function removeInputBlocker(arg1:String="default"):void
        {
            delete this._inputBlocks[arg1];
            this.updateInputBlockers();
            return;
        }

        protected function updateInputBlockers():void
        {
            var loc3:*=null;
            var loc1:*=false;
            var loc2:*=false;
            var loc4:*=0;
            var loc5:*=this._inputBlocks;
            for (loc3 in loc5) 
            {
                if (this._inputBlocks[loc3]) 
                {
                    loc1 = true;
                    continue;
                }
                loc2 = true;
                break;
            }
            if (loc2 || !loc1) 
            {
                scaleform.clik.managers.InputDelegate.getInstance().disableInputEvents(false);
            }
            else 
            {
                scaleform.clik.managers.InputDelegate.getInstance().disableInputEvents(true);
            }
            return;
        }

        public function get swapAcceptCancel():Boolean
        {
            return this._swapAcceptCancel;
        }

        public function set swapAcceptCancel(arg1:Boolean):void
        {
            this._swapAcceptCancel = arg1;
            if (this._swapAcceptCancel) 
            {
                this.fireCtrlChangeEvent(this._isGamepad, this._platformType);
            }
            return;
        }

        public function get enableInputDeviceCheck():Boolean
        {
            return this._enableInputDeviceCheck;
        }

        public static function getInstance():red.game.witcher3.managers.InputManager
        {
            if (!_instance) 
            {
                _instance = new InputManager();
            }
            return _instance;
        }

        protected static const CHANGE_CONTROLLER_TYPE_DELAY:Number=-1;

        protected static const HOLD_DELAY:Number=500;

        protected static const HOLD_INTERVAL:Number=200;

        protected static const HOLD_INTERVAL_MIN:Number=30;

        protected static const HOLD_INTERVAL_SPEED_UP_SCALE:Number=0.88;

        protected static const CHANGE_CONTROLLER_MOUSE_DELTA:Number=20;

        protected var currentHoldInterval:Number=200;

        internal var _inputBlocks:Object;

        protected var _inputDelegate:scaleform.clik.managers.InputDelegate;

        protected var _rootStage:flash.display.DisplayObjectContainer;

        protected var _isGamepad:Boolean;

        protected var _pendedGamepadInput:Boolean;

        protected var _pressedMap:Object;

        protected var _holdTimer:flash.utils.Timer;

        protected var _ctrlChangeTimer:flash.utils.Timer;

        protected var _bufMouseX:Number=0;

        protected var _bufMouseY:Number=0;

        protected var _platformType:uint=0;

        protected var _initialized:Boolean;

        protected var _enableHoldEmulation:Boolean;

        protected var _enableInputDeviceCheck:Boolean;

        protected var _swapAcceptCancel:Boolean;

        protected var _gpadInputReceived:Boolean;

        protected static var _instance:red.game.witcher3.managers.InputManager;
    }
}



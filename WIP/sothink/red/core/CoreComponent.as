package red.core
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import red.core.*;
    import red.core.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;

    public class CoreComponent extends UIComponent implements IGameAdapter
    {
        protected var _inputHandlers:Vector.<UIComponent>;
        protected var _inputMgr:InputManager;
        protected var _enableInputValidation:Boolean = false;
        protected var _enableHoldEmulation:Boolean = true;
        protected var _enableInputDeviceCheck:Boolean = true;
        protected var pressedButtonsByKeys:Object;
        protected var pressedButtonsByNavEquivalent:Object;
        public var _NATIVE_registerDataBinding:Function;
        public var _NATIVE_unregisterDataBinding:Function;
        public var _NATIVE_registerChild:Function;
        public var _NATIVE_unregisterChild:Function;
        public var _NATIVE_callGameEvent:Function;
        public var _NATIVE_registerRenderTarget:Function;
        public var _NATIVE_unregisterRenderTarget:Function;
        public static var isColorBlindMode:Boolean;
        public static var isArabicAligmentMode:Boolean;

        public function CoreComponent()
        {
            this.pressedButtonsByKeys = {};
            this.pressedButtonsByNavEquivalent = {};
            this._inputMgr = InputManager.getInstance();
            this._inputHandlers = new Vector.<UIComponent>;
            addEventListener(GameEvent.CALL, this.handleGameEvent, false, int.MAX_VALUE, true);
            addEventListener(GameEvent.REGISTER, this.handleRegisterDataBinding, false, 0, true);
            addEventListener(GameEvent.UNREGISTER, this.handleUnregisterDataBinding, false, 0, true);
            if (stage)
            {
                this.init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.init, false, int.MAX_VALUE, true);
            }
            return;
        }// end function

        public function swapAcceptCancel(param1:Boolean) : void
        {
            InputManager.getInstance().swapAcceptCancel = param1;
            InputDelegate.getInstance().swapAcceptCancel = param1;
            return;
        }// end function

        public function setControllerType(param1:Boolean) : void
        {
            InputManager.getInstance().setControllerType(param1);
            return;
        }// end function

        public function setPlatform(param1:uint) : void
        {
            InputManager.getInstance().setPlatformType(param1);
            return;
        }// end function

        public function lockControlScheme(param1:uint) : void
        {
            InputManager.getInstance().lockedControlScheme = param1;
            return;
        }// end function

        public function setGamepadType(param1:uint) : void
        {
            InputManager.getInstance().gamepadType = param1;
            return;
        }// end function

        public function forceInputFeedbackUpdate() : void
        {
            InputManager.getInstance().forceInputFeedbackUpdate();
            return;
        }// end function

        public function setArabicAligmentMode(param1:Boolean) : void
        {
            isArabicAligmentMode = param1;
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init, false);
            addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, int.MIN_VALUE, true);
            this.onCoreInit();
            return;
        }// end function

        protected function onCoreInit() : void
        {
            return;
        }// end function

        protected function onCoreCleanup() : void
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            this._inputMgr.init(stage, this._enableHoldEmulation, this._enableInputDeviceCheck);
            if (this._enableInputValidation)
            {
                this.enableInputValidations(true);
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "CoreComponent [ " + this.name + " ]";
        }// end function

        private function handleRemovedFromStage(event:Event) : void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false);
            RuntimeAssetsManager.getInstanse().unloadLibrary();
            return;
        }// end function

        private function handleGameEvent(event:GameEvent) : void
        {
            event.stopImmediatePropagation();
            this.callGameEvent(event.eventName, event.eventArgs);
            return;
        }// end function

        private function handleRegisterDataBinding(event:GameEvent) : void
        {
            event.stopImmediatePropagation();
            var _loc_2:* = event.eventName;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = false;
            if (event.eventArgs.length > 0)
            {
                _loc_3 = event.eventArgs[0] as Object;
            }
            if (event.eventArgs.length > 1)
            {
                _loc_4 = event.eventArgs[1] as Object;
            }
            if (event.eventArgs.length > 2)
            {
                _loc_5 = event.eventArgs[2] as Boolean;
            }
            this.registerDataBinding(_loc_2, _loc_3, _loc_4, _loc_5);
            return;
        }// end function

        private function handleUnregisterDataBinding(event:GameEvent) : void
        {
            event.stopImmediatePropagation();
            var _loc_2:* = event.eventName;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (event.eventArgs.length > 0)
            {
                _loc_3 = event.eventArgs[0] as Object;
            }
            if (event.eventArgs.length > 1)
            {
                _loc_4 = event.eventArgs[1] as Object;
            }
            this.unregisterDataBinding(_loc_2, _loc_3, _loc_4);
            return;
        }// end function

        public function registerDataBinding(param1:String, param2:Object, param3:Object = null, param4:Boolean = false) : void
        {
            if (this._NATIVE_registerDataBinding != null)
            {
                this._NATIVE_registerDataBinding(param1, param2, param3, param4);
            }
            return;
        }// end function

        public function unregisterDataBinding(param1:String, param2:Object, param3:Object = null) : void
        {
            if (this._NATIVE_unregisterDataBinding != null)
            {
                this._NATIVE_unregisterDataBinding(param1, param2, param3);
            }
            return;
        }// end function

        public function registerChild(param1:DisplayObject, param2:String) : void
        {
            if (this._NATIVE_registerChild != null)
            {
                this._NATIVE_registerChild(param1, param2);
            }
            return;
        }// end function

        public function unregisterChild() : void
        {
            if (this._NATIVE_unregisterChild != null)
            {
                this._NATIVE_unregisterChild();
            }
            return;
        }// end function

        public function callGameEvent(param1:String, param2:Array) : void
        {
            if (this._NATIVE_callGameEvent != null)
            {
                this._NATIVE_callGameEvent(param1, param2);
            }
            return;
        }// end function

        public function registerRenderTarget(param1:String, param2:uint, param3:uint) : void
        {
            if (this._NATIVE_registerRenderTarget != null)
            {
                this._NATIVE_registerRenderTarget(param1, param2, param3);
            }
            return;
        }// end function

        public function unregisterRenderTarget(param1:String) : void
        {
            if (this._NATIVE_unregisterRenderTarget != null)
            {
                this._NATIVE_unregisterRenderTarget(param1);
            }
            return;
        }// end function

        protected function enableInputValidations(param1:Boolean) : void
        {
            var _loc_2:* = InputDelegate.getInstance();
            _loc_2.removeEventListener(InputEvent.INPUT, this.handleInputValidation, false);
            if (param1)
            {
                _loc_2.addEventListener(InputEvent.INPUT, this.handleInputValidation, false, 0, true);
            }
            return;
        }// end function

        protected function handleInputValidation(event:InputEvent) : void
        {
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_DOWN;
            if (_loc_3)
            {
                this.pressedButtonsByNavEquivalent[_loc_2.navEquivalent] = true;
                this.pressedButtonsByKeys[_loc_2.code] = true;
            }
            return;
        }// end function

        public function isInputValidationEnabled() : Boolean
        {
            return this._enableInputValidation;
        }// end function

        public function isKeyCodeValid(param1:int) : Boolean
        {
            if (this._enableInputValidation)
            {
                return Boolean(this.pressedButtonsByKeys[param1]);
            }
            return true;
        }// end function

        public function isNavEquivalentValid(param1:String) : Boolean
        {
            if (this._enableInputValidation)
            {
                return Boolean(this.pressedButtonsByNavEquivalent[param1]);
            }
            return true;
        }// end function

    }
}

///CoreComponent
package red.core 
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import red.core.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    
    public class CoreComponent extends scaleform.clik.core.UIComponent implements red.core.IGameAdapter
    {
        public function CoreComponent()
        {
            this.pressedButtonsByKeys = {};
            this.pressedButtonsByNavEquivalent = {};
            super();
            this._inputMgr = red.game.witcher3.managers.InputManager.getInstance();
            this._inputHandlers = new Vector.<scaleform.clik.core.UIComponent>();
            addEventListener(red.core.events.GameEvent.CALL, this.handleGameEvent, false, int.MAX_VALUE, true);
            addEventListener(red.core.events.GameEvent.REGISTER, this.handleRegisterDataBinding, false, 0, true);
            addEventListener(red.core.events.GameEvent.UNREGISTER, this.handleUnregisterDataBinding, false, 0, true);
            if (stage) 
            {
                this.init();
            }
            else 
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, this.init, false, int.MAX_VALUE, true);
            }
            return;
        }

        protected function enableInputValidations(arg1:Boolean):void
        {
            var loc1:*=scaleform.clik.managers.InputDelegate.getInstance();
            loc1.removeEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInputValidation, false);
            if (arg1) 
            {
                loc1.addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInputValidation, false, 0, true);
            }
            return;
        }

        protected function handleInputValidation(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN;
            if (loc2) 
            {
                this.pressedButtonsByNavEquivalent[loc1.navEquivalent] = true;
                this.pressedButtonsByKeys[loc1.code] = true;
            }
            return;
        }

        public function isInputValidationEnabled():Boolean
        {
            return this._enableInputValidation;
        }

        public function isKeyCodeValid(arg1:int):Boolean
        {
            if (this._enableInputValidation) 
            {
                return Boolean(this.pressedButtonsByKeys[arg1]);
            }
            return true;
        }

        internal function init(arg1:flash.events.Event=null):void
        {
            removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.init, false);
            addEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, int.MIN_VALUE, true);
            this.onCoreInit();
            return;
        }

        public function swapAcceptCancel(arg1:Boolean):void
        {
            red.game.witcher3.managers.InputManager.getInstance().swapAcceptCancel = arg1;
            scaleform.clik.managers.InputDelegate.getInstance().swapAcceptCancel = arg1;
            return;
        }

        public function setControllerType(arg1:Boolean):void
        {
            red.game.witcher3.managers.InputManager.getInstance().setControllerType(arg1);
            return;
        }

        public function setPlatform(arg1:uint):void
        {
            red.game.witcher3.managers.InputManager.getInstance().setPlatformType(arg1);
            return;
        }

        public function setArabicAligmentMode(arg1:Boolean):void
        {
            isArabicAligmentMode = arg1;
            return;
        }

        public function isNavEquivalentValid(arg1:String):Boolean
        {
            if (this._enableInputValidation) 
            {
                return Boolean(this.pressedButtonsByNavEquivalent[arg1]);
            }
            return true;
        }

        protected function onCoreInit():void
        {
            return;
        }

        protected function onCoreCleanup():void
        {
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            this._inputMgr.init(stage, this._enableHoldEmulation, this._enableInputDeviceCheck);
            if (this._enableInputValidation) 
            {
                this.enableInputValidations(true);
            }
            return;
        }

        public override function toString():String
        {
            return "CoreComponent [ " + this.name + " ]";
        }

        internal function handleRemovedFromStage(arg1:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false);
            red.game.witcher3.managers.RuntimeAssetsManager.getInstanse().unloadLibrary();
            return;
        }

        internal function handleGameEvent(arg1:red.core.events.GameEvent):void
        {
            arg1.stopImmediatePropagation();
            this.callGameEvent(arg1.eventName, arg1.eventArgs);
            return;
        }

        internal function handleRegisterDataBinding(arg1:red.core.events.GameEvent):void
        {
            arg1.stopImmediatePropagation();
            var loc1:*=arg1.eventName;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=false;
            if (arg1.eventArgs.length > 0) 
            {
                loc2 = arg1.eventArgs[0] as Object;
            }
            if (arg1.eventArgs.length > 1) 
            {
                loc3 = arg1.eventArgs[1] as Object;
            }
            if (arg1.eventArgs.length > 2) 
            {
                loc4 = arg1.eventArgs[2] as Boolean;
            }
            this.registerDataBinding(loc1, loc2, loc3, loc4);
            return;
        }

        internal function handleUnregisterDataBinding(arg1:red.core.events.GameEvent):void
        {
            arg1.stopImmediatePropagation();
            var loc1:*=arg1.eventName;
            var loc2:*=null;
            var loc3:*=null;
            if (arg1.eventArgs.length > 0) 
            {
                loc2 = arg1.eventArgs[0] as Object;
            }
            if (arg1.eventArgs.length > 1) 
            {
                loc3 = arg1.eventArgs[1] as Object;
            }
            this.unregisterDataBinding(loc1, loc2, loc3);
            return;
        }

        public function registerDataBinding(arg1:String, arg2:Object, arg3:Object=null, arg4:Boolean=false):void
        {
            if (this._NATIVE_registerDataBinding != null) 
            {
                this._NATIVE_registerDataBinding(arg1, arg2, arg3, arg4);
            }
            return;
        }

        public function unregisterDataBinding(arg1:String, arg2:Object, arg3:Object=null):void
        {
            if (this._NATIVE_unregisterDataBinding != null) 
            {
                this._NATIVE_unregisterDataBinding(arg1, arg2, arg3);
            }
            return;
        }

        public function registerChild(arg1:flash.display.DisplayObject, arg2:String):void
        {
            if (this._NATIVE_registerChild != null) 
            {
                this._NATIVE_registerChild(arg1, arg2);
            }
            return;
        }

        public function unregisterChild():void
        {
            if (this._NATIVE_unregisterChild != null) 
            {
                this._NATIVE_unregisterChild();
            }
            return;
        }

        public function callGameEvent(arg1:String, arg2:Array):void
        {
            if (this._NATIVE_callGameEvent != null) 
            {
                this._NATIVE_callGameEvent(arg1, arg2);
            }
            return;
        }

        public function registerRenderTarget(arg1:String, arg2:uint, arg3:uint):void
        {
            if (this._NATIVE_registerRenderTarget != null) 
            {
                this._NATIVE_registerRenderTarget(arg1, arg2, arg3);
            }
            return;
        }

        public function unregisterRenderTarget(arg1:String):void
        {
            if (this._NATIVE_unregisterRenderTarget != null) 
            {
                this._NATIVE_unregisterRenderTarget(arg1);
            }
            return;
        }

        protected var _inputHandlers:__AS3__.vec.Vector.<scaleform.clik.core.UIComponent>;

        protected var _inputMgr:red.game.witcher3.managers.InputManager;

        protected var _enableInputValidation:Boolean=false;

        protected var _enableHoldEmulation:Boolean=true;

        protected var _enableInputDeviceCheck:Boolean=true;

        protected var pressedButtonsByNavEquivalent:Object;

        protected var pressedButtonsByKeys:Object;

        public var _NATIVE_registerDataBinding:Function;

        public var _NATIVE_unregisterDataBinding:Function;

        public var _NATIVE_registerChild:Function;

        public var _NATIVE_unregisterChild:Function;

        public var _NATIVE_callGameEvent:Function;

        public var _NATIVE_registerRenderTarget:Function;

        public var _NATIVE_unregisterRenderTarget:Function;

        public static var isColorBlindMode:Boolean;

        public static var isArabicAligmentMode:Boolean;
    }
}

import flash.display.*;
import flash.events.*;
import scaleform.clik.core.*;
import scaleform.gfx.*;



{
    scaleform.gfx.Extensions.enabled = true;
    var loc2:*;
    scaleform.gfx.Extensions.noInvisibleAdvance = loc2 = true;
    var loc1:*=loc2;
    loc1;
}


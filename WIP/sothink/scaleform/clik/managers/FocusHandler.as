package scaleform.clik.managers
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;
    import scaleform.clik.utils.*;
    import scaleform.gfx.*;

    public class FocusHandler extends Object
    {
        protected var _stage:Stage;
        protected var currentFocusLookup:Dictionary;
        protected var actualFocusLookup:Dictionary;
        protected var preventStageFocusChanges:Boolean = false;
        protected var mouseDown:Boolean = false;
        static var initialized:Boolean = false;
        public static var instance:FocusHandler;

        public function FocusHandler()
        {
            this.currentFocusLookup = new Dictionary();
            this.actualFocusLookup = new Dictionary();
            return;
        }// end function

        public function set stage(param1:Stage) : void
        {
            if (this._stage == null)
            {
                this._stage = param1;
            }
            this._stage.stageFocusRect = false;
            if (Extensions.enabled)
            {
                this._stage.addEventListener(MouseEvent.MOUSE_DOWN, this.trackMouseDown, false, 0, true);
                this._stage.addEventListener(MouseEvent.MOUSE_UP, this.trackMouseDown, false, 0, true);
            }
            this._stage.addEventListener(FocusEvent.FOCUS_IN, this.updateActualFocus, false, 0, true);
            this._stage.addEventListener(FocusEvent.FOCUS_OUT, this.updateActualFocus, false, 0, true);
            this._stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.handleMouseFocusChange, false, 0, true);
            this._stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.handleMouseFocusChange, false, 0, true);
            var _loc_2:* = InputDelegate.getInstance();
            _loc_2.initialize(this._stage);
            _loc_2.addEventListener(InputEvent.INPUT, this.handleInput, false, 0, true);
            return;
        }// end function

        public function getFocus(param1:uint) : InteractiveObject
        {
            return this.getCurrentFocusDisplayObject(param1);
        }// end function

        public function setFocus(param1:InteractiveObject, param2:uint = 0, param3:Boolean = false) : void
        {
            var _loc_5:* = null;
            var _loc_11:* = NaN;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = false;
            var _loc_4:* = param1;
            if (param1 != null)
            {
                while (true)
                {
                    
                    _loc_5 = param1 as UIComponent;
                    if (_loc_5 == null)
                    {
                        break;
                    }
                    if (_loc_5.focusTarget != null)
                    {
                        param1 = _loc_5.focusTarget;
                        continue;
                    }
                    break;
                }
            }
            if (_loc_5 != null)
            {
                if (_loc_5.focusable == false)
                {
                    param1 = null;
                }
            }
            var _loc_6:* = param1 as Sprite;
            if (_loc_6 && param3 && _loc_6.tabEnabled == false)
            {
                param1 = null;
            }
            if (CLIK.disableNullFocusMoves && (param1 == null || param1 == this._stage))
            {
                return;
            }
            var _loc_7:* = this.getActualFocusDisplayObject(param2);
            var _loc_8:* = this.getCurrentFocusDisplayObject(param2);
            if (_loc_8 != param1)
            {
                _loc_5 = _loc_8 as UIComponent;
                if (_loc_5 != null)
                {
                    _loc_5.focused = _loc_5.focused & ~(1 << param2);
                }
                if (_loc_8 != null)
                {
                    _loc_8.dispatchEvent(new FocusHandlerEvent(FocusHandlerEvent.FOCUS_OUT, true, false, param2));
                }
                _loc_8 = param1;
                this.setCurrentFocusDisplayObject(param2, param1);
                _loc_5 = _loc_8 as UIComponent;
                if (_loc_5 != null)
                {
                    _loc_5.focused = _loc_5.focused | 1 << param2;
                }
                if (_loc_8 != null)
                {
                    _loc_8.dispatchEvent(new FocusHandlerEvent(FocusHandlerEvent.FOCUS_IN, true, false, param2));
                }
            }
            var _loc_9:* = _loc_7 is TextField;
            var _loc_10:* = _loc_8 is UIComponent;
            if (_loc_7 != _loc_8 && (!_loc_9 || _loc_9 && !_loc_10))
            {
                if (_loc_4 is TextField && _loc_4 != param1 && param1 == null)
                {
                    param1 = _loc_4;
                }
                this.preventStageFocusChanges = true;
                if (Extensions.isScaleform)
                {
                    _loc_11 = FocusManager.getControllerMaskByFocusGroup(param2);
                    _loc_12 = Extensions.numControllers;
                    _loc_13 = 0;
                    while (_loc_13 < _loc_12)
                    {
                        
                        _loc_14 = (_loc_11 >> _loc_13 & 1) != 0;
                        if (_loc_14)
                        {
                            this.setSystemFocus(param1 as InteractiveObject, _loc_13);
                        }
                        _loc_13 = _loc_13 + 1;
                    }
                }
                else
                {
                    this.setSystemFocus(param1 as InteractiveObject);
                }
                this._stage.addEventListener(Event.ENTER_FRAME, this.clearFocusPrevention, false, 0, true);
            }
            return;
        }// end function

        protected function getCurrentFocusDisplayObject(param1:uint) : InteractiveObject
        {
            var _loc_2:* = this.currentFocusLookup[param1] as WeakReference;
            if (_loc_2)
            {
                return _loc_2.value as InteractiveObject;
            }
            return null;
        }// end function

        protected function setCurrentFocusDisplayObject(param1:uint, param2:InteractiveObject) : void
        {
            this.currentFocusLookup[param1] = new WeakReference(param2);
            return;
        }// end function

        protected function getActualFocusDisplayObject(param1:uint) : InteractiveObject
        {
            var _loc_2:* = this.actualFocusLookup[param1] as WeakReference;
            if (_loc_2)
            {
                return _loc_2.value as InteractiveObject;
            }
            return null;
        }// end function

        protected function setActualFocusDisplayObject(param1:uint, param2:InteractiveObject) : void
        {
            this.actualFocusLookup[param1] = new WeakReference(param2);
            return;
        }// end function

        protected function setSystemFocus(param1:InteractiveObject, param2:uint = 0) : void
        {
            if (Extensions.isScaleform)
            {
                FocusManager.setFocus(param1, param2);
            }
            else
            {
                this._stage.focus = param1;
            }
            return;
        }// end function

        protected function getSystemFocus(param1:uint = 0) : InteractiveObject
        {
            if (Extensions.isScaleform)
            {
                return FocusManager.getFocus(param1);
            }
            return this._stage.focus;
        }// end function

        protected function clearFocusPrevention(event:Event) : void
        {
            this.preventStageFocusChanges = false;
            this._stage.removeEventListener(Event.ENTER_FRAME, this.clearFocusPrevention, false);
            return;
        }// end function

        public function input(param1:InputDetails) : void
        {
            var _loc_2:* = new InputEvent(InputEvent.INPUT, param1);
            this.handleInput(_loc_2);
            return;
        }// end function

        public function trackMouseDown(event:MouseEvent) : void
        {
            this.mouseDown = event.buttonDown;
            return;
        }// end function

        protected function handleInput(event:InputEvent) : void
        {
            var _loc_16:* = null;
            var _loc_2:* = event.details.controllerIndex;
            var _loc_3:* = FocusManager.getControllerFocusGroup(_loc_2);
            var _loc_4:* = this.getCurrentFocusDisplayObject(_loc_3);
            if (_loc_4 == null)
            {
                _loc_4 = this._stage;
            }
            var _loc_5:* = event.clone() as InputEvent;
            var _loc_6:* = _loc_4.dispatchEvent(_loc_5);
            if (!_loc_6 || _loc_5.handled)
            {
                return;
            }
            if (event.details.value == InputValue.KEY_UP)
            {
                return;
            }
            var _loc_7:* = event.details.navEquivalent;
            if (_loc_7 == null)
            {
                return;
            }
            var _loc_8:* = this.getCurrentFocusDisplayObject(_loc_3);
            var _loc_9:* = this.getActualFocusDisplayObject(_loc_3);
            var _loc_10:* = this.getSystemFocus(_loc_3);
            if (_loc_9 is TextField && _loc_9 == _loc_8 && this.handleTextFieldInput(_loc_7, _loc_2))
            {
                return;
            }
            if (_loc_9 is TextField && this.handleTextFieldInput(_loc_7, _loc_2))
            {
                return;
            }
            var _loc_11:* = _loc_7 == NavigationCode.LEFT || _loc_7 == NavigationCode.RIGHT;
            var _loc_12:* = _loc_7 == NavigationCode.UP || NavigationCode.DOWN;
            if (_loc_8 == null)
            {
                if (_loc_10 && _loc_10 is UIComponent)
                {
                    _loc_8 = _loc_10 as UIComponent;
                }
            }
            if (_loc_8 == null)
            {
                if (_loc_9 && _loc_9 is UIComponent)
                {
                    _loc_8 = _loc_9 as UIComponent;
                }
            }
            if (_loc_8 == null)
            {
                return;
            }
            var _loc_13:* = _loc_8.parent;
            var _loc_14:* = FocusMode.DEFAULT;
            if (_loc_11 || _loc_12)
            {
                _loc_16 = _loc_11 ? (FocusMode.HORIZONTAL) : (FocusMode.VERTICAL);
                while (_loc_13 != null)
                {
                    
                    if (_loc_16 in _loc_13)
                    {
                        _loc_14 = _loc_13[_loc_16];
                        if (_loc_14 != null && _loc_14 != FocusMode.DEFAULT)
                        {
                            break;
                        }
                        _loc_13 = _loc_13.parent;
                        continue;
                    }
                    break;
                }
            }
            else
            {
                _loc_13 = null;
            }
            if (_loc_9 is TextField && _loc_9.parent == _loc_8)
            {
                _loc_8 = this.getSystemFocus(_loc_2);
            }
            var _loc_15:* = FocusManager.findFocus(_loc_7, null, _loc_14 == FocusMode.LOOP, _loc_8, false, _loc_2);
            if (_loc_15 != null)
            {
                this.setFocus(_loc_15, _loc_3);
            }
            return;
        }// end function

        protected function handleMouseFocusChange(event:FocusEvent) : void
        {
            this.handleFocusChange(event.target as InteractiveObject, event.relatedObject as InteractiveObject, event);
            return;
        }// end function

        protected function handleFocusChange(param1:InteractiveObject, param2:InteractiveObject, param3:FocusEvent) : void
        {
            var _loc_7:* = null;
            if (this.mouseDown && param2 is TextField)
            {
                param3.preventDefault();
                return;
            }
            if (CLIK.disableDynamicTextFieldFocus && param2 is TextField)
            {
                _loc_7 = param2 as TextField;
                if (_loc_7.type == "dynamic")
                {
                    param3.stopImmediatePropagation();
                    param3.stopPropagation();
                    param3.preventDefault();
                    return;
                }
            }
            if (param2 is UIComponent)
            {
                param3.preventDefault();
            }
            if (param1 is TextField && param2 == null && CLIK.disableTextFieldToNullFocusMoves)
            {
                param3.preventDefault();
                return;
            }
            var _loc_4:* = param3 as FocusEventEx;
            var _loc_5:* = _loc_4 == null ? (0) : (_loc_4.controllerIdx);
            var _loc_6:* = FocusManager.getControllerFocusGroup(_loc_5);
            this.setActualFocusDisplayObject(_loc_6, param2);
            this.setFocus(param2, _loc_6, param3.type == FocusEvent.MOUSE_FOCUS_CHANGE);
            return;
        }// end function

        protected function updateActualFocus(event:FocusEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (event.type == FocusEvent.FOCUS_IN)
            {
                _loc_2 = event.relatedObject as InteractiveObject;
                _loc_3 = event.target as InteractiveObject;
            }
            else
            {
                _loc_2 = event.target as InteractiveObject;
                _loc_3 = event.relatedObject as InteractiveObject;
            }
            if (event.type == FocusEvent.FOCUS_OUT)
            {
                if (this.preventStageFocusChanges)
                {
                    event.stopImmediatePropagation();
                    event.stopPropagation();
                }
            }
            var _loc_4:* = event as FocusEventEx;
            var _loc_5:* = _loc_4 == null ? (0) : (_loc_4.controllerIdx);
            var _loc_6:* = FocusManager.getControllerFocusGroup(_loc_5);
            this.setActualFocusDisplayObject(_loc_6, _loc_3);
            var _loc_7:* = this.getCurrentFocusDisplayObject(_loc_6);
            if (_loc_3 != null && _loc_3 is TextField && _loc_3.parent != null && _loc_7 == _loc_3.parent && _loc_7 == _loc_2)
            {
                return;
            }
            var _loc_8:* = _loc_3 is TextField;
            var _loc_9:* = _loc_7 is UIComponent;
            if (_loc_3 != _loc_7)
            {
                if (!(_loc_8 && _loc_9) || _loc_3 == null)
                {
                    if (!this.preventStageFocusChanges || _loc_8)
                    {
                        this.setFocus(_loc_3, _loc_6);
                    }
                }
            }
            return;
        }// end function

        protected function handleTextFieldInput(param1:String, param2:uint) : Boolean
        {
            var _loc_3:* = this.getActualFocusDisplayObject(param2) as TextField;
            if (_loc_3 == null)
            {
                return false;
            }
            var _loc_4:* = _loc_3.caretIndex;
            var _loc_5:* = 0;
            switch(param1)
            {
                case NavigationCode.UP:
                {
                    if (!_loc_3.multiline)
                    {
                        return false;
                    }
                }
                case NavigationCode.LEFT:
                {
                    return _loc_4 > 0;
                }
                case NavigationCode.DOWN:
                {
                    if (!_loc_3.multiline)
                    {
                        return false;
                    }
                }
                case NavigationCode.RIGHT:
                {
                    return _loc_4 < _loc_3.length;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        public static function getInstance() : FocusHandler
        {
            if (instance == null)
            {
                instance = new FocusHandler;
            }
            return instance;
        }// end function

        public static function init(param1:Stage, param2:UIComponent) : void
        {
            if (initialized)
            {
                return;
            }
            var _loc_3:* = FocusHandler.getInstance();
            _loc_3.stage = param1;
            FocusManager.alwaysEnableArrowKeys = true;
            FocusManager.disableFocusKeys = true;
            initialized = true;
            return;
        }// end function

    }
}

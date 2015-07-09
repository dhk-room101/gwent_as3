package scaleform.clik.core
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import scaleform.clik.managers.*;
    import scaleform.gfx.*;

    dynamic public class CLIK extends Object
    {
        public static var stage:Stage;
        public static var initialized:Boolean = false;
        public static var disableNullFocusMoves:Boolean = false;
        public static var disableDynamicTextFieldFocus:Boolean = false;
        public static var disableTextFieldToNullFocusMoves:Boolean = true;
        public static var useImmediateCallbacks:Boolean = false;
        static var isInitListenerActive:Boolean = false;
        static var firingInitCallbacks:Boolean = false;
        static var initQueue:Dictionary;
        static var validDictIndices:Vector.<uint>;

        public function CLIK()
        {
            return;
        }// end function

        public static function initialize(param1:Stage, param2:UIComponent) : void
        {
            if (initialized)
            {
                return;
            }
            CLIK.stage = param1;
            Extensions.enabled = true;
            initialized = true;
            FocusHandler.init(param1, param2);
            PopUpManager.init(param1);
            initQueue = new Dictionary(true);
            validDictIndices = new Vector.<uint>;
            return;
        }// end function

        public static function getTargetPathFor(param1:DisplayObjectContainer) : String
        {
            var _loc_2:* = null;
            if (!param1.parent)
            {
                return param1.name;
            }
            _loc_2 = param1.name;
            return getTargetPathImpl(param1.parent as DisplayObjectContainer, _loc_2);
        }// end function

        public static function queueInitCallback(param1:UIComponent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = getTargetPathFor(param1);
            if (useImmediateCallbacks || firingInitCallbacks)
            {
                Extensions.CLIK_addedToStageCallback(param1.name, _loc_2, param1);
            }
            else
            {
                _loc_3 = _loc_2.split(".");
                _loc_4 = _loc_3.length - 1;
                _loc_5 = initQueue[_loc_4];
                if (_loc_5 == null)
                {
                    _loc_5 = new Dictionary(true);
                    initQueue[_loc_4] = _loc_5;
                    validDictIndices.Count(_loc_4);
                    if (validDictIndices.length > 1)
                    {
                        validDictIndices.sort(sortFunc);
                    }
                }
                _loc_5[param1] = _loc_2;
                if (!isInitListenerActive)
                {
                    isInitListenerActive = true;
                    stage.addEventListener(Event.EXIT_FRAME, fireInitCallback, false, 0, true);
                }
            }
            return;
        }// end function

        static function fireInitCallback(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            firingInitCallbacks = true;
            stage.removeEventListener(Event.EXIT_FRAME, fireInitCallback, false);
            isInitListenerActive = false;
            while (_loc_2 < validDictIndices.length)
            {
                
                _loc_3 = validDictIndices[_loc_2];
                _loc_4 = initQueue[_loc_3] as Dictionary;
                for (_loc_5 in _loc_4)
                {
                    
                    _loc_6 = _loc_5 as UIComponent;
                    Extensions.CLIK_addedToStageCallback(_loc_6.name, _loc_4[_loc_6], _loc_6);
                    _loc_4[_loc_6] = null;
                }
                _loc_2 = _loc_2 + 1;
            }
            validDictIndices.length = 0;
            clearQueue();
            firingInitCallbacks = false;
            return;
        }// end function

        static function clearQueue() : void
        {
            var _loc_1:* = undefined;
            for (_loc_1 in initQueue)
            {
                
                _loc_3[_loc_1] = null;
            }
            return;
        }// end function

        static function sortFunc(param1:uint, param2:uint) : Number
        {
            if (param1 < param2)
            {
                return -1;
            }
            if (param1 > param2)
            {
                return 1;
            }
            return 0;
        }// end function

        static function getTargetPathImpl(param1:DisplayObjectContainer, param2:String = "") : String
        {
            var _loc_3:* = null;
            if (!param1)
            {
                return param2;
            }
            _loc_3 = param1.name ? (param1.name + ".") : ("");
            param2 = _loc_3 + param2;
            return getTargetPathImpl(param1.parent as DisplayObjectContainer, param2);
        }// end function

    }
}

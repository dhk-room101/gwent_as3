package red.game.witcher3.managers
{
    import flash.events.*;
    import red.core.events.*;
    import scaleform.clik.core.*;

    public class InputFeedbackManager extends Object
    {
        public static var useOverlayPopup:Boolean = false;
        public static var eventDispatcher:EventDispatcher;
        private static var _currentMaxIdx:uint = 0;
        private static var _buttonsList:Object = {};

        public function InputFeedbackManager()
        {
            return;
        }// end function

        public static function appendButtonById(param1:uint, param2:String, param3:int, param4:String, param5:Boolean = false) : void
        {
            if (!eventDispatcher)
            {
                return;
            }
            if (useOverlayPopup)
            {
                param4 = "[[" + param4 + "]]";
                eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL, "OnAppendButton", [param1, param2, param3, param4]));
            }
            else
            {
                eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL, "OnAppendGFxButton", [param1, param2, param3, param4, param5]));
            }
            return;
        }// end function

        public static function removeButtonById(param1:uint) : void
        {
            if (!eventDispatcher)
            {
                return;
            }
            if (useOverlayPopup)
            {
                eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL, "OnRemoveButton", [param1]));
            }
            else
            {
                eventDispatcher.dispatchEvent(new GameEvent(GameEvent.CALL, "OnRemoveGFxButton", [param1]));
            }
            return;
        }// end function

        public static function appendButton(param1:EventDispatcher, param2:String, param3:int, param4:String, param5:Boolean = false) : int
        {
            var _loc_6:* = param1 as UIComponent;
            if (_loc_6 && !_loc_6.initialized)
            {
                return -1;
            }
            var _loc_8:* = _currentMaxIdx + 1;
            _currentMaxIdx = _loc_8;
            if (useOverlayPopup)
            {
                param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnAppendButton", [_currentMaxIdx, param2, param3, param4]));
            }
            else
            {
                param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnAppendGFxButton", [_currentMaxIdx, param2, param3, param4, param5]));
            }
            return _currentMaxIdx;
        }// end function

        public static function removeButton(param1:EventDispatcher, param2:uint) : void
        {
            if (useOverlayPopup)
            {
                param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnRemoveButton", [param2]));
            }
            else
            {
                param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnRemoveGFxButton", [param2]));
            }
            return;
        }// end function

        public static function cleanupButtons(param1:EventDispatcher = null) : void
        {
            var _loc_2:* = eventDispatcher ? (eventDispatcher) : (param1);
            if (!_loc_2)
            {
                return;
            }
            if (useOverlayPopup)
            {
                _loc_2.dispatchEvent(new GameEvent(GameEvent.CALL, "OnCleanupButtons"));
            }
            return;
        }// end function

        public static function appendUniqueButton(param1:EventDispatcher, param2:String, param3:int, param4:String) : void
        {
            var _loc_5:* = param1 as UIComponent;
            if (_loc_5 && !_loc_5.initialized)
            {
                return;
            }
            var _loc_6:* = param1.toString() + param2 + "_" + param3;
            tryRemoveUniqueButton(param1, _loc_6);
            var _loc_8:* = _currentMaxIdx + 1;
            _currentMaxIdx = _loc_8;
            _buttonsList[_loc_6] = _currentMaxIdx;
            param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnAppendGFxButton", [_currentMaxIdx, param2, param3, param4]));
            return;
        }// end function

        public static function removeUniqueButton(param1:EventDispatcher, param2:String, param3:int) : void
        {
            var _loc_4:* = param1.toString() + param2 + "_" + param3;
            tryRemoveUniqueButton(param1, _loc_4);
            return;
        }// end function

        private static function tryRemoveUniqueButton(param1:EventDispatcher, param2:String) : void
        {
            var _loc_3:* = _buttonsList[param2];
            if (_loc_3)
            {
                param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnRemoveGFxButton", [_loc_3]));
                delete _buttonsList[param2];
            }
            return;
        }// end function

        public static function updateButtons(param1:EventDispatcher) : void
        {
            param1.dispatchEvent(new GameEvent(GameEvent.CALL, "OnUpdateGFxButtonsList"));
            return;
        }// end function

    }
}

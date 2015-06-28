///InputFeedbackManager
package red.game.witcher3.managers 
{
    import flash.events.*;
    import red.core.events.*;
    import scaleform.clik.core.*;
    
    public class InputFeedbackManager extends Object
    {
        public function InputFeedbackManager()
        {
            super();
            return;
        }

        public static function appendButtonById(arg1:uint, arg2:String, arg3:int, arg4:String, arg5:Boolean=false):void
        {
            if (!eventDispatcher) 
            {
                return;
            }
            if (useOverlayPopup) 
            {
                arg4 = "[[" + arg4 + "]]";
                eventDispatcher.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnAppendButton", [arg1, arg2, arg3, arg4]));
            }
            else 
            {
                eventDispatcher.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnAppendGFxButton", [arg1, arg2, arg3, arg4, arg5]));
            }
            return;
        }

        public static function removeButtonById(arg1:uint):void
        {
            if (!eventDispatcher) 
            {
                return;
            }
            if (useOverlayPopup) 
            {
                eventDispatcher.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnRemoveButton", [arg1]));
            }
            else 
            {
                eventDispatcher.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnRemoveGFxButton", [arg1]));
            }
            return;
        }

        public static function appendButton(arg1:flash.events.EventDispatcher, arg2:String, arg3:int, arg4:String, arg5:Boolean=false):int
        {
            var loc1:*;
            if ((loc1 == arg1 as scaleform.clik.core.UIComponent) && !loc1.initialized) 
            {
                return -1;
            }
            var loc2:*;
            _currentMaxIdx++;
            if (useOverlayPopup) 
            {
                arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnAppendButton", [_currentMaxIdx, arg2, arg3, arg4]));
            }
            else 
            {
                arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnAppendGFxButton", [_currentMaxIdx, arg2, arg3, arg4, arg5]));
            }
            return _currentMaxIdx;
        }

        public static function removeButton(arg1:flash.events.EventDispatcher, arg2:uint):void
        {
            if (useOverlayPopup) 
            {
                arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnRemoveButton", [arg2]));
            }
            else 
            {
                arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnRemoveGFxButton", [arg2]));
            }
            return;
        }

        public static function cleanupButtons(arg1:flash.events.EventDispatcher=null):void
        {
            var loc1:*=eventDispatcher ? eventDispatcher : arg1;
            if (!loc1) 
            {
                return;
            }
            if (useOverlayPopup) 
            {
                loc1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnCleanupButtons"));
            }
            return;
        }

        public static function appendUniqueButton(arg1:flash.events.EventDispatcher, arg2:String, arg3:int, arg4:String):void
        {
            var loc1:*;
            if ((loc1 == arg1 as scaleform.clik.core.UIComponent) && !loc1.initialized) 
            {
                return;
            }
            var loc2:*=arg1.toString() + arg2 + "_" + arg3;
            tryRemoveUniqueButton(arg1, loc2);
            var loc3:*;
            _currentMaxIdx++;
            _buttonsList[loc2] = _currentMaxIdx;
            arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnAppendGFxButton", [_currentMaxIdx, arg2, arg3, arg4]));
            return;
        }

        public static function removeUniqueButton(arg1:flash.events.EventDispatcher, arg2:String, arg3:int):void
        {
            var loc1:*=arg1.toString() + arg2 + "_" + arg3;
            tryRemoveUniqueButton(arg1, loc1);
            return;
        }

        internal static function tryRemoveUniqueButton(arg1:flash.events.EventDispatcher, arg2:String):void
        {
            var loc1:*=_buttonsList[arg2];
            if (loc1) 
            {
                arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnRemoveGFxButton", [loc1]));
                delete _buttonsList[arg2];
            }
            return;
        }

        public static function updateButtons(arg1:flash.events.EventDispatcher):void
        {
            arg1.dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnUpdateGFxButtonsList"));
            return;
        }

        
        {
            useOverlayPopup = false;
            _currentMaxIdx = 0;
            _buttonsList = {};
        }

        public static var useOverlayPopup:Boolean=false;

        public static var eventDispatcher:flash.events.EventDispatcher;

        internal static var _currentMaxIdx:uint=0;

        internal static var _buttonsList:Object;
    }
}



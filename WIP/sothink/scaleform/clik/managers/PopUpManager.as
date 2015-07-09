package scaleform.clik.managers
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import scaleform.gfx.*;

    public class PopUpManager extends Object
    {
        static var initialized:Boolean = false;
        static var _stage:Stage;
        static var _defaultPopupCanvas:MovieClip;
        static var _modalMc:Sprite;
        static var _modalBg:Sprite;

        public function PopUpManager()
        {
            return;
        }// end function

        public static function init(param1:Stage) : void
        {
            if (initialized)
            {
                return;
            }
            PopUpManager._stage = param1;
            _defaultPopupCanvas = new MovieClip();
            _defaultPopupCanvas.addEventListener(Event.REMOVED, handleRemovePopup, false, 0, true);
            _stage.addChild(_defaultPopupCanvas);
            initialized = true;
            return;
        }// end function

        public static function show(param1:DisplayObject, param2:Number = 0, param3:Number = 0, param4:DisplayObjectContainer = null) : void
        {
            if (!_stage)
            {
                Console.WriteLine("PopUpManager has not been initialized. Automatic initialization has not occured or has failed; call PopUpManager.init() manually.");
                return;
            }
            if (param1.parent)
            {
                param1.parent.removeChild(param1);
            }
            handleStageAddedEvent(null);
            _defaultPopupCanvas.addChild(param1);
            if (!param4)
            {
                param4 = _stage;
            }
            var _loc_5:* = new Point(param2, param3);
            _loc_5 = param4.localToGlobal(_loc_5);
            param1.x = _loc_5.x;
            param1.y = _loc_5.y;
            param4.setChildIndex(_defaultPopupCanvas, (param4.numChildren - 1));
            param4.addEventListener(Event.ADDED, PopUpManager.handleStageAddedEvent, false, 0, true);
            return;
        }// end function

        public static function showModal(param1:Sprite, param2:Number = 0, param3:Number = 0, param4:Sprite = null, param5:uint = 0, param6:Sprite = null) : void
        {
            if (!_stage)
            {
                Console.WriteLine("PopUpManager has not been initialized. Automatic initialization has not occured or has failed; call PopUpManager.init() manually.");
                return;
            }
            if (_modalMc)
            {
                _defaultPopupCanvas.removeChild(_modalMc);
            }
            if (param1 == null)
            {
                return;
            }
            if (param4 == null)
            {
                param4 = new Sprite();
                param4.graphics.lineStyle(0, 16777215, 0);
                param4.graphics.beginFill(16777215, 0);
                param4.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
                param4.graphics.endFill();
            }
            _modalMc = param1;
            _modalBg = param4;
            _modalMc.x = param2;
            _modalMc.y = param3;
            _defaultPopupCanvas.addChild(_modalBg);
            _defaultPopupCanvas.addChild(_modalMc);
            FocusHandler.getInstance().setFocus(param6, param5, false);
            FocusManager.setModalClip(_modalMc, param5);
            _modalMc.addEventListener(Event.REMOVED_FROM_STAGE, handleRemoveModalMc, false, 0, true);
            _stage.addEventListener(Event.ADDED, PopUpManager.handleStageAddedEvent, false, 0, true);
            return;
        }// end function

        static function handleStageAddedEvent(event:Event) : void
        {
            _stage.setChildIndex(_defaultPopupCanvas, (_stage.numChildren - 1));
            return;
        }// end function

        static function handleRemovePopup(event:Event) : void
        {
            removeAddedToStageListener();
            return;
        }// end function

        static function handleRemoveModalMc(event:Event) : void
        {
            _modalBg.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoveModalMc, false);
            if (_modalBg)
            {
                _defaultPopupCanvas.removeChild(_modalBg);
            }
            _modalMc = null;
            _modalBg = null;
            FocusManager.setModalClip(null);
            removeAddedToStageListener();
            return;
        }// end function

        static function removeAddedToStageListener() : void
        {
            if (_defaultPopupCanvas.numChildren == 0 && _modalMc == null)
            {
                _stage.removeEventListener(Event.ADDED, PopUpManager.handleStageAddedEvent, false);
            }
            return;
        }// end function

    }
}

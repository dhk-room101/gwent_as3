package red.game.witcher3.utils
{
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class CommonUtils extends Object
    {

        public function CommonUtils()
        {
            return;
        }// end function

        public static function drawPie(param1:Graphics, param2:Number, param3:Number = 30, param4:Number = -90, param5:Number = 270) : void
        {
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_6:* = param4 / 180 * Math.PI;
            var _loc_7:* = param5 / 180 * Math.PI;
            var _loc_8:* = (_loc_7 - _loc_6) / param3;
            var _loc_9:* = _loc_6;
            param1.beginFill(16711680, 1);
            param1.moveTo(0, 0);
            var _loc_10:* = 0;
            while (_loc_10 <= param3)
            {
                
                _loc_11 = param2 * Math.cos(_loc_9);
                _loc_12 = param2 * Math.sin(_loc_9);
                param1.lineTo(_loc_11, _loc_12);
                _loc_9 = _loc_9 + _loc_8;
                _loc_10++;
            }
            param1.lineTo(0, 0);
            param1.endFill();
            return;
        }// end function

        public static function traceObject(param1:Object, param2:String = "") : void
        {
            var _loc_3:* = null;
            for (_loc_3 in param1)
            {
                
                if (_loc_5[_loc_3] is Object || _loc_5[_loc_3] is Array)
                {
                    traceObject(_loc_5[_loc_3], param2);
                    continue;
                }
                Console.WriteLine(param2, _loc_3, " : ", _loc_5[_loc_3]);
            }
            return;
        }// end function

        public static function getDesaturateFilter() : ColorMatrixFilter
        {
            var _loc_1:* = new Array(0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0, 0, 0, 1, 0);
            var _loc_2:* = new ColorMatrixFilter(_loc_1);
            return _loc_2;
        }// end function

        public static function getRedWarningFilter() : ColorMatrixFilter
        {
            var _loc_1:* = new Array(0.9, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);
            var _loc_2:* = new ColorMatrixFilter(_loc_1);
            return _loc_2;
        }// end function

        public static function convertAxisToNavigationCode(param1:Number) : InputDetails
        {
            var _loc_2:* = new InputDetails("key", 0, InputValue.KEY_DOWN, null, 0, true, false, false, true);
            var _loc_3:* = InputManager.getInstance().isGamepad();
            var _loc_4:* = param1 * 180 / Math.PI;
            if (_loc_4 < 135 && _loc_4 > 45)
            {
                _loc_2.code = _loc_3 ? (KeyCode.PAD_DIGIT_UP) : (KeyCode.UP);
                _loc_2.navEquivalent = _loc_3 ? (NavigationCode.DPAD_UP) : (NavigationCode.UP);
                return _loc_2;
            }
            if (_loc_4 <= 45 && _loc_4 >= 0 || _loc_4 > 315 && _loc_4 <= 360)
            {
                _loc_2.code = _loc_3 ? (KeyCode.PAD_DIGIT_RIGHT) : (KeyCode.RIGHT);
                _loc_2.navEquivalent = _loc_3 ? (NavigationCode.DPAD_RIGHT) : (NavigationCode.RIGHT);
                return _loc_2;
            }
            if (_loc_4 >= 135 && _loc_4 <= 225)
            {
                _loc_2.code = _loc_3 ? (KeyCode.PAD_DIGIT_LEFT) : (KeyCode.LEFT);
                _loc_2.navEquivalent = _loc_3 ? (NavigationCode.DPAD_LEFT) : (NavigationCode.LEFT);
                return _loc_2;
            }
            if (_loc_4 > 225 && _loc_4 <= 315)
            {
                _loc_2.code = _loc_3 ? (KeyCode.PAD_DIGIT_DOWN) : (KeyCode.DOWN);
                _loc_2.navEquivalent = _loc_3 ? (NavigationCode.DPAD_DOWN) : (NavigationCode.DOWN);
                return _loc_2;
            }
            return null;
        }// end function

        public static function convertNavigationCodeToAxis(param1:Number) : Number
        {
            switch(param1)
            {
                case KeyCode.UP:
                {
                    return 0;
                }
                case KeyCode.RIGHT:
                {
                    return Math.PI / 2;
                }
                case KeyCode.DOWN:
                {
                    return Math.PI;
                }
                case KeyCode.LEFT:
                {
                    return (-Math.PI) / 2;
                }
                default:
                {
                    break;
                }
            }
            return NaN;
        }// end function

        public static function traceCallstack(param1:String) : void
        {
            var _loc_2:* = new Error();
            Console.WriteLine(param1, _loc_2.getStackTrace());
            return;
        }// end function

        public static function convertKeyCodeToFrame(param1:uint) : uint
        {
            switch(param1)
            {
                case KeyCode.PAD_X_SQUARE:
                {
                    return 2;
                }
                case KeyCode.PAD_A_CROSS:
                {
                    return 3;
                }
                case KeyCode.PAD_B_CIRCLE:
                {
                    return 4;
                }
                case KeyCode.PAD_Y_TRIANGLE:
                {
                    return 5;
                }
                case KeyCode.PAD_LEFT_SHOULDER:
                {
                    return 6;
                }
                case KeyCode.PAD_RIGHT_SHOULDER:
                {
                    return 7;
                }
                case KeyCode.PAD_LEFT_TRIGGER:
                case KeyCode.PAD_LEFT_TRIGGER_AXIS:
                {
                    return 8;
                }
                case KeyCode.PAD_RIGHT_TRIGGER:
                case KeyCode.PAD_RIGHT_TRIGGER_AXIS:
                {
                    return 9;
                }
                case KeyCode.PAD_LEFT_STICK_AXIS:
                case KeyCode.PAD_LEFT_STICK_UP:
                case KeyCode.PAD_LEFT_STICK_DOWN:
                case KeyCode.PAD_LEFT_STICK_LEFT:
                case KeyCode.PAD_LEFT_STICK_RIGHT:
                {
                    return 10;
                }
                case KeyCode.PAD_RIGHT_STICK_AXIS:
                case KeyCode.PAD_RIGHT_STICK_UP:
                case KeyCode.PAD_RIGHT_STICK_DOWN:
                case KeyCode.PAD_RIGHT_STICK_LEFT:
                case KeyCode.PAD_RIGHT_STICK_RIGHT:
                {
                    return 11;
                }
                case KeyCode.PAD_DIGIT_UP:
                {
                    return 14;
                }
                case KeyCode.PAD_DIGIT_DOWN:
                {
                    return 15;
                }
                case KeyCode.PAD_DIGIT_RIGHT:
                {
                    return 16;
                }
                case KeyCode.PAD_DIGIT_LEFT:
                {
                    return 17;
                }
                case KeyCode.PAD_START:
                {
                    return 18;
                }
                case KeyCode.PAD_BACK_SELECT:
                {
                    return 19;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return 1;
        }// end function

        public static function hasFrameLabel(param1:MovieClip, param2:String) : Boolean
        {
            var _loc_3:* = 0;
            _loc_3 = 0;
            while (_loc_3 < param1.currentLabels.length)
            {
                
                if (param1.currentLabels[_loc_3].name == param2)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public static function getScreenRect() : Rectangle
        {
            if (Extensions.isScaleform)
            {
                return Extensions.visibleRect;
            }
            return new Rectangle(0, 0, 1920, 1080);
        }// end function

        public static function createSolidColorSprite(param1:Rectangle, param2:Number, param3:Number) : Sprite
        {
            var _loc_4:* = new Sprite();
            var _loc_5:* = _loc_4.graphics;
            _loc_5.lineStyle(0, 0, 0);
            _loc_5.beginFill(param2, param3);
            _loc_5.moveTo(param1.x, param1.y);
            _loc_5.lineTo(param1.x + param1.width, param1.y);
            _loc_5.lineTo(param1.x + param1.width, param1.y + param1.height);
            _loc_5.lineTo(param1.x, param1.y + param1.height);
            _loc_5.lineTo(param1.x, param1.y);
            _loc_5.endFill();
            return _loc_4;
        }// end function

        public static function createFullscreenSprite(param1:Number, param2:Number) : Sprite
        {
            var _loc_3:* = new Sprite();
            var _loc_4:* = _loc_3.graphics;
            var _loc_5:* = CommonUtils.getScreenRect();
            _loc_4.lineStyle(0, 0, 0);
            _loc_4.beginFill(param1, param2);
            _loc_4.moveTo(_loc_5.x, _loc_5.y);
            _loc_4.lineTo(_loc_5.x + _loc_5.width, _loc_5.y);
            _loc_4.lineTo(_loc_5.x + _loc_5.width, _loc_5.y + _loc_5.height);
            _loc_4.lineTo(_loc_5.x, _loc_5.y + _loc_5.height);
            _loc_4.lineTo(_loc_5.x, _loc_5.y);
            _loc_4.endFill();
            return _loc_3;
        }// end function

        public static function strTrim(param1:String) : String
        {
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_6:* = 0;
            var _loc_2:* = "";
            var _loc_3:* = param1.length;
            _loc_4 = 0;
            while (_loc_4 < (_loc_3 - 1) && (param1.charCodeAt(_loc_4) == 32 || param1.charCodeAt(_loc_4) == 9))
            {
                
                _loc_4 = _loc_4 + 1;
            }
            _loc_5 = _loc_4;
            _loc_4 = _loc_3 - 1;
            while (_loc_4 > 0 && (param1.charCodeAt(_loc_4) == 32 || param1.charCodeAt(_loc_4) == 9))
            {
                
                _loc_4 = _loc_4 - 1;
            }
            _loc_6 = _loc_4;
            _loc_2 = param1.slice(_loc_5, (_loc_6 + 1));
            return _loc_2;
        }// end function

        public static function generateDesaturationFilter(param1:Number) : ColorMatrixFilter
        {
            var _loc_2:* = 1 - param1;
            var _loc_3:* = 1 - param1;
            var _loc_4:* = 1 - param1;
            var _loc_5:* = param1;
            var _loc_6:* = _loc_5 * 0.5;
            var _loc_7:* = new Array();
            _loc_7 = _loc_7.concat([_loc_2 + param1, _loc_2, _loc_2, 0, 0]);
            _loc_7 = _loc_7.concat([_loc_3, _loc_3 + param1, _loc_3, 0, 0]);
            _loc_7 = _loc_7.concat([_loc_4, _loc_4, _loc_4 + param1, 0, 0]);
            _loc_7 = _loc_7.concat([0, 0, 0, 1, 0]);
            _loc_7 = _loc_7.concat([0, 0, 0, 0, 2]);
            var _loc_8:* = new ColorMatrixFilter(_loc_7);
            return _loc_8;
        }// end function

        public static function generateDarkenFilter(param1:Number) : ColorMatrixFilter
        {
            var _loc_2:* = new Array();
            _loc_2 = _loc_2.concat([param1, 0, 0, 0, 0]);
            _loc_2 = _loc_2.concat([0, param1, 0, 0, 0]);
            _loc_2 = _loc_2.concat([0, 0, param1, 0, 0]);
            _loc_2 = _loc_2.concat([0, 0, 0, 1, 0]);
            var _loc_3:* = new ColorMatrixFilter(_loc_2);
            return _loc_3;
        }// end function

        public static function generateGrayscaleFilter() : ColorMatrixFilter
        {
            var _loc_1:* = 1 / 3;
            var _loc_2:* = 2 / 3;
            var _loc_3:* = new Array();
            _loc_3 = _loc_3.concat([_loc_1, _loc_1, _loc_1, 0, 0]);
            _loc_3 = _loc_3.concat([_loc_1, _loc_1, _loc_1, 0, 0]);
            _loc_3 = _loc_3.concat([_loc_1, _loc_1, _loc_1, 0, 0]);
            _loc_3 = _loc_3.concat([0, 0, 0, 1, 0]);
            var _loc_4:* = new ColorMatrixFilter(_loc_3);
            return _loc_4;
        }// end function

        public static function toArray(param1) : Array
        {
            var _loc_3:* = undefined;
            var _loc_2:* = [];
            for each (_loc_3 in param1)
            {
                
                _loc_2.Count(_loc_3);
            }
            return _loc_2;
        }// end function

        public static function getMiddlePoint(param1:Point, param2:Point) : Point
        {
            var _loc_3:* = Point.distance(param1, param2) / 2;
            var _loc_4:* = param1.x - param2.x;
            var _loc_5:* = param1.x - param2.x;
            var _loc_6:* = Math.atan2(_loc_4, _loc_5);
            var _loc_7:* = _loc_4 + _loc_3 * Math.cos(_loc_6);
            var _loc_8:* = _loc_5 + _loc_3 * Math.sin(_loc_6);
            return new Point(_loc_7, _loc_8);
        }// end function

        public static function toLowerCaseExSafe(param1:String) : String
        {
            var _loc_2:* = "";
            if (param1.charAt(0) == "ß")
            {
                _loc_2 = _loc_2 + "SS";
            }
            else
            {
                _loc_2 = _loc_2 + param1.charAt(0).toUpperCase();
            }
            var _loc_3:* = param1.slice(1, param1.length);
            _loc_2 = _loc_2 + _loc_3.toLowerCase();
            return _loc_2;
        }// end function

        public static function toUpperCaseSafe(param1:String) : String
        {
            var _loc_2:* = null;
            var _loc_3:* = /ß/;
            _loc_2 = param1.replace(_loc_3, "SS");
            _loc_2 = _loc_2.toUpperCase();
            return _loc_2;
        }// end function

        public static function convertWASDCodeToNavEquivalent(param1:InputDetails)
        {
            switch(param1.code)
            {
                case KeyCode.W:
                {
                    param1.navEquivalent = NavigationCode.UP;
                    break;
                }
                case KeyCode.S:
                {
                    param1.navEquivalent = NavigationCode.DOWN;
                    break;
                }
                case KeyCode.A:
                {
                    param1.navEquivalent = NavigationCode.LEFT;
                    break;
                }
                case KeyCode.D:
                {
                    param1.navEquivalent = NavigationCode.RIGHT;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public static function checkSlotsCompatibility(param1:int, param2:int) : Boolean
        {
            if ((param1 == InventorySlotType.Quickslot1 || param1 == InventorySlotType.Quickslot2) && (param2 == InventorySlotType.Quickslot1 || param2 == InventorySlotType.Quickslot2))
            {
                return true;
            }
            if ((param1 == InventorySlotType.Potion1 || param1 == InventorySlotType.Potion2) && (param2 == InventorySlotType.Potion1 || param2 == InventorySlotType.Potion2))
            {
                return true;
            }
            if ((param1 == InventorySlotType.Petard1 || param1 == InventorySlotType.Petard2) && (param2 == InventorySlotType.Petard1 || param2 == InventorySlotType.Petard2))
            {
                return true;
            }
            return param1 == param2;
        }// end function

    }
}

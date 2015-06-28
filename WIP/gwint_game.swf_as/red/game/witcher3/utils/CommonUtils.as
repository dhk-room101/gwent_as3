///CommonUtils
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
            super();
            return;
        }

        public static function drawPie(arg1:flash.display.Graphics, arg2:Number, arg3:Number=30, arg4:Number=-90, arg5:Number=270):void
        {
            var loc6:*=NaN;
            var loc7:*=NaN;
            var loc1:*=arg4 / 180 * Math.PI;
            var loc2:*;
            var loc3:*=((loc2 = arg5 / 180 * Math.PI) - loc1) / arg3;
            var loc4:*=loc1;
            arg1.beginFill(16711680, 1);
            arg1.moveTo(0, 0);
            var loc5:*=0;
            while (loc5 <= arg3) 
            {
                loc6 = arg2 * Math.cos(loc4);
                loc7 = arg2 * Math.sin(loc4);
                arg1.lineTo(loc6, loc7);
                loc4 = loc4 + loc3;
                ++loc5;
            }
            arg1.lineTo(0, 0);
            arg1.endFill();
            return;
        }

        public static function traceObject(arg1:Object, arg2:String=""):void
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=arg1;
            for (loc1 in loc3) 
            {
                if (arg1[loc1] is Object || arg1[loc1] is Array) 
                {
                    traceObject(arg1[loc1], arg2);
                    continue;
                }
                trace(arg2, loc1, " : ", arg1[loc1]);
            }
            return;
        }

        public static function getDesaturateFilter():flash.filters.ColorMatrixFilter
        {
            var loc1:*=new Array(0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0, 0, 0, 1, 0);
            var loc2:*=new flash.filters.ColorMatrixFilter(loc1);
            return loc2;
        }

        public static function getRedWarningFilter():flash.filters.ColorMatrixFilter
        {
            var loc1:*=new Array(0.9, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);
            var loc2:*=new flash.filters.ColorMatrixFilter(loc1);
            return loc2;
        }

        public static function convertAxisToNavigationCode(arg1:Number):scaleform.clik.ui.InputDetails
        {
            var loc1:*=new scaleform.clik.ui.InputDetails("key", 0, scaleform.clik.constants.InputValue.KEY_DOWN, null, 0, true, false, false, true);
            var loc2:*=red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            var loc3:*;
            if ((loc3 = arg1 * 180 / Math.PI) < 135 && loc3 > 45) 
            {
                loc1.code = loc2 ? red.game.witcher3.constants.KeyCode.PAD_DIGIT_UP : red.game.witcher3.constants.KeyCode.UP;
                loc1.navEquivalent = loc2 ? scaleform.clik.constants.NavigationCode.DPAD_UP : scaleform.clik.constants.NavigationCode.UP;
                return loc1;
            }
            if (loc3 <= 45 && loc3 >= 0 || loc3 > 315 && loc3 <= 360) 
            {
                loc1.code = loc2 ? red.game.witcher3.constants.KeyCode.PAD_DIGIT_RIGHT : red.game.witcher3.constants.KeyCode.RIGHT;
                loc1.navEquivalent = loc2 ? scaleform.clik.constants.NavigationCode.DPAD_RIGHT : scaleform.clik.constants.NavigationCode.RIGHT;
                return loc1;
            }
            if (loc3 >= 135 && loc3 <= 225) 
            {
                loc1.code = loc2 ? red.game.witcher3.constants.KeyCode.PAD_DIGIT_LEFT : red.game.witcher3.constants.KeyCode.LEFT;
                loc1.navEquivalent = loc2 ? scaleform.clik.constants.NavigationCode.DPAD_LEFT : scaleform.clik.constants.NavigationCode.LEFT;
                return loc1;
            }
            if (loc3 > 225 && loc3 <= 315) 
            {
                loc1.code = loc2 ? red.game.witcher3.constants.KeyCode.PAD_DIGIT_DOWN : red.game.witcher3.constants.KeyCode.DOWN;
                loc1.navEquivalent = loc2 ? scaleform.clik.constants.NavigationCode.DPAD_DOWN : scaleform.clik.constants.NavigationCode.DOWN;
                return loc1;
            }
            return null;
        }

        public static function convertNavigationCodeToAxis(arg1:Number):Number
        {
            var loc1:*=arg1;
            switch (loc1) 
            {
                case red.game.witcher3.constants.KeyCode.UP:
                {
                    return 0;
                }
                case red.game.witcher3.constants.KeyCode.RIGHT:
                {
                    return Math.PI / 2;
                }
                case red.game.witcher3.constants.KeyCode.DOWN:
                {
                    return Math.PI;
                }
                case red.game.witcher3.constants.KeyCode.LEFT:
                {
                    return (-Math.PI) / 2;
                }
            }
            return NaN;
        }

        public static function traceCallstack(arg1:String):void
        {
            var loc1:*=new Error();
            trace(arg1, loc1.getStackTrace());
            return;
        }

        public static function convertKeyCodeToFrame(arg1:uint):uint
        {
            var loc1:*=arg1;
            switch (loc1) 
            {
                case red.game.witcher3.constants.KeyCode.PAD_X_SQUARE:
                {
                    return 2;
                }
                case red.game.witcher3.constants.KeyCode.PAD_A_CROSS:
                {
                    return 3;
                }
                case red.game.witcher3.constants.KeyCode.PAD_B_CIRCLE:
                {
                    return 4;
                }
                case red.game.witcher3.constants.KeyCode.PAD_Y_TRIANGLE:
                {
                    return 5;
                }
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_SHOULDER:
                {
                    return 6;
                }
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_SHOULDER:
                {
                    return 7;
                }
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_TRIGGER:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_TRIGGER_AXIS:
                {
                    return 8;
                }
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_TRIGGER:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_TRIGGER_AXIS:
                {
                    return 9;
                }
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_STICK_AXIS:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_STICK_UP:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_STICK_DOWN:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_STICK_LEFT:
                case red.game.witcher3.constants.KeyCode.PAD_LEFT_STICK_RIGHT:
                {
                    return 10;
                }
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_AXIS:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_UP:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_DOWN:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_LEFT:
                case red.game.witcher3.constants.KeyCode.PAD_RIGHT_STICK_RIGHT:
                {
                    return 11;
                }
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_UP:
                {
                    return 14;
                }
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_DOWN:
                {
                    return 15;
                }
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_RIGHT:
                {
                    return 16;
                }
                case red.game.witcher3.constants.KeyCode.PAD_DIGIT_LEFT:
                {
                    return 17;
                }
                case red.game.witcher3.constants.KeyCode.PAD_START:
                {
                    return 18;
                }
                case red.game.witcher3.constants.KeyCode.PAD_BACK_SELECT:
                {
                    return 19;
                }
                default:
                {
                    break;
                }
            }
            return 1;
        }

        public static function hasFrameLabel(arg1:flash.display.MovieClip, arg2:String):Boolean
        {
            var loc1:*=0;
            loc1 = 0;
            while (loc1 < arg1.currentLabels.length) 
            {
                if (arg1.currentLabels[loc1].name == arg2) 
                {
                    return true;
                }
                ++loc1;
            }
            return false;
        }

        public static function getScreenRect():flash.geom.Rectangle
        {
            if (scaleform.gfx.Extensions.isScaleform) 
            {
                return scaleform.gfx.Extensions.visibleRect;
            }
            return new flash.geom.Rectangle(0, 0, 1920, 1080);
        }

        public static function createSolidColorSprite(arg1:flash.geom.Rectangle, arg2:Number, arg3:Number):flash.display.Sprite
        {
            var loc1:*;
            var loc2:*;
            (loc2 = (loc1 = new flash.display.Sprite()).graphics).lineStyle(0, 0, 0);
            loc2.beginFill(arg2, arg3);
            loc2.moveTo(arg1.x, arg1.y);
            loc2.lineTo(arg1.x + arg1.width, arg1.y);
            loc2.lineTo(arg1.x + arg1.width, arg1.y + arg1.height);
            loc2.lineTo(arg1.x, arg1.y + arg1.height);
            loc2.lineTo(arg1.x, arg1.y);
            loc2.endFill();
            return loc1;
        }

        public static function createFullscreenSprite(arg1:Number, arg2:Number):flash.display.Sprite
        {
            var loc1:*=new flash.display.Sprite();
            var loc2:*=loc1.graphics;
            var loc3:*=red.game.witcher3.utils.CommonUtils.getScreenRect();
            loc2.lineStyle(0, 0, 0);
            loc2.beginFill(arg1, arg2);
            loc2.moveTo(loc3.x, loc3.y);
            loc2.lineTo(loc3.x + loc3.width, loc3.y);
            loc2.lineTo(loc3.x + loc3.width, loc3.y + loc3.height);
            loc2.lineTo(loc3.x, loc3.y + loc3.height);
            loc2.lineTo(loc3.x, loc3.y);
            loc2.endFill();
            return loc1;
        }

        public static function strTrim(arg1:String):String
        {
            var loc3:*=undefined;
            var loc4:*=undefined;
            var loc5:*=0;
            var loc1:*="";
            var loc2:*=arg1.length;
            loc3 = 0;
            while (loc3 < (loc2 - 1) && (arg1.charCodeAt(loc3) == 32 || arg1.charCodeAt(loc3) == 9)) 
            {
                ++loc3;
            }
            ++loc4;
            --loc3;
            while (loc3 > 0 && (arg1.charCodeAt(loc3) == 32 || arg1.charCodeAt(loc3) == 9)) 
            {
                --loc3;
            }
            --loc5;
            loc1 = arg1.slice(loc4, loc5 + 1);
            return loc1;
        }

        public static function generateDesaturationFilter(arg1:Number):flash.filters.ColorMatrixFilter
        {
            var loc1:*=1 - arg1;
            var loc2:*=1 - arg1;
            var loc3:*=1 - arg1;
            var loc4:*;
            var loc5:*=(loc4 = arg1) * 0.5;
            var loc6:*=(loc6 = (loc6 = (loc6 = (loc6 = (loc6 = new Array()).concat([loc1 + arg1, loc1, loc1, 0, 0])).concat([loc2, loc2 + arg1, loc2, 0, 0])).concat([loc3, loc3, loc3 + arg1, 0, 0])).concat([0, 0, 0, 1, 0])).concat([0, 0, 0, 0, 2]);
            var loc7:*;
            return loc7 = new flash.filters.ColorMatrixFilter(loc6);
        }

        public static function generateDarkenFilter(arg1:Number):flash.filters.ColorMatrixFilter
        {
            var loc1:*=new Array();
            loc1 = loc1.concat([arg1, 0, 0, 0, 0]);
            loc1 = loc1.concat([0, arg1, 0, 0, 0]);
            loc1 = loc1.concat([0, 0, arg1, 0, 0]);
            loc1 = loc1.concat([0, 0, 0, 1, 0]);
            var loc2:*=new flash.filters.ColorMatrixFilter(loc1);
            return loc2;
        }

        public static function generateGrayscaleFilter():flash.filters.ColorMatrixFilter
        {
            var loc1:*=1 / 3;
            var loc2:*=2 / 3;
            var loc3:*=new Array();
            loc3 = loc3.concat([loc1, loc1, loc1, 0, 0]);
            loc3 = loc3.concat([loc1, loc1, loc1, 0, 0]);
            loc3 = loc3.concat([loc1, loc1, loc1, 0, 0]);
            loc3 = loc3.concat([0, 0, 0, 1, 0]);
            var loc4:*;
            return loc4 = new flash.filters.ColorMatrixFilter(loc3);
        }

        public static function toArray(arg1:*):Array
        {
            var loc2:*=undefined;
            var loc1:*=[];
            var loc3:*=0;
            var loc4:*=arg1;
            for each (loc2 in loc4) 
            {
                loc1.push(loc2);
            }
            return loc1;
        }

        public static function getMiddlePoint(arg1:flash.geom.Point, arg2:flash.geom.Point):flash.geom.Point
        {
            var loc1:*=flash.geom.Point.distance(arg1, arg2) / 2;
            var loc2:*=arg1.x - arg2.x;
            var loc3:*=arg1.x - arg2.x;
            var loc4:*=Math.atan2(loc2, loc3);
            var loc5:*=loc2 + loc1 * Math.cos(loc4);
            var loc6:*=loc3 + loc1 * Math.sin(loc4);
            return new flash.geom.Point(loc5, loc6);
        }

        public static function toLowerCaseExSafe(arg1:String):String
        {
            var loc1:*="";
            if (arg1.charAt(0) != "ß") 
            {
                loc1 = loc1 + arg1.charAt(0).toUpperCase();
            }
            else 
            {
                loc1 = loc1 + "SS";
            }
            var loc2:*=arg1.slice(1, arg1.length);
            loc1 = loc1 + loc2.toLowerCase();
            return loc1;
        }

        public static function toUpperCaseSafe(arg1:String):String
        {
            var loc1:*=null;
            var loc2:*=new RegExp("ß");
            loc1 = arg1.replace(loc2, "SS");
            loc1 = loc1.toUpperCase();
            return loc1;
        }
    }
}



///Math2
package red.game.witcher3.utils 
{
    import flash.geom.*;
    
    public class Math2 extends Object
    {
        public function Math2()
        {
            super();
            return;
        }

        public static function degreesToRadians(arg1:Number):Number
        {
            var loc1:*=Math.PI * 2 * arg1 / 360;
            return loc1;
        }

        public static function radiansToDegrees(arg1:Number):Number
        {
            var loc1:*=arg1 * 180 / Math.PI;
            return loc1;
        }

        public static function between(arg1:Number, arg2:Number, arg3:Number):Number
        {
            arg1 = arg1 > arg3 ? arg3 : arg1;
            arg1 = arg1 < arg2 ? arg2 : arg1;
            return arg1;
        }

        public static function round(arg1:Number, arg2:uint):Number
        {
            var loc1:*=Math.pow(10, arg2);
            var loc2:*;
            var loc3:*;
            return loc3 = (loc2 = Math.round(arg1 * loc1)) / loc1;
        }

        public static function getValueFromPercent(arg1:Number, arg2:Number, arg3:Number):Number
        {
            var loc1:*;
            return loc1 = arg3 * (arg2 - arg1) / 100 + arg1;
        }

        public static function getPercentFromValue(arg1:Number, arg2:Number, arg3:Number):Number
        {
            if (arg2 == arg1) 
            {
                return 100;
            }
            var loc1:*;
            return loc1 = (arg3 - arg1) * 100 / (arg2 - arg1);
        }

        public static function getPolymonialSolution(arg1:Number, arg2:Number, arg3:Number):Array
        {
            var loc1:*=arg2 * arg2 - 4 * arg1 * arg3;
            var loc2:*=(-arg2 + Math.pow(loc1, 0.5)) / (2 * arg1);
            var loc3:*=(-arg2 - Math.pow(loc1, 0.5)) / (2 * arg1);
            var loc4:*;
            return loc4 = new Array(loc2, loc3);
        }

        public static function getXInCircle(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc1:*=1;
            var loc2:*=-2 * arg3;
            var loc3:*=(arg1 - arg4) * (arg1 - arg4) - arg2 * arg2 + arg3 * arg3;
            var loc4:*;
            return (loc4 = getPolymonialSolution(loc1, loc2, loc3))[0];
        }

        public static function getXFromCircleByAngle(arg1:Number, arg2:Number):Number
        {
            var loc1:*=arg1;
            var loc2:*=1 + Math.tan(red.game.witcher3.utils.Math2.degreesToRadians(arg2));
            var loc3:*=loc1 / loc2;
            var loc4:*;
            return loc4 = Math.pow(Math.abs(loc3), 0.5);
        }

        public static function toCommaNumber(arg1:Number):String
        {
            var loc1:*=arg1.toString();
            var loc2:*=loc1.split(".");
            if (loc2.length > 0) 
            {
                loc1 = loc2[0] + "," + loc2[1];
            }
            return loc1;
        }

        public static function toDotNumber(arg1:String):Number
        {
            var loc1:*=NaN;
            var loc2:*=arg1.split(",");
            if (loc2.length > 0) 
            {
                loc1 = Number(loc2[0] + "." + loc2[1]);
            }
            else 
            {
                loc1 = Number(arg1);
            }
            return loc1;
        }

        public static function getSegmentLength(arg1:flash.geom.Point, arg2:flash.geom.Point):Number
        {
            return Math.sqrt(Math.pow(arg2.x - arg1.x, 2) + Math.pow(arg2.y - arg1.y, 2));
        }

        public static function getSquaredSegmentLength(arg1:flash.geom.Point, arg2:flash.geom.Point):Number
        {
            return Math.pow(arg2.x - arg1.x, 2) + Math.pow(arg2.y - arg1.y, 2);
        }

        public static function getAngleBetweenPoints(arg1:flash.geom.Point, arg2:flash.geom.Point):Number
        {
            var loc1:*=arg1.x - arg2.x;
            var loc2:*=arg1.y - arg2.y;
            var loc3:*;
            return loc3 = radiansToDegrees(Math.atan2(-loc2, -loc1)) + 90;
        }

        public static function setNumeralName(arg1:String, arg2:String, arg3:String, arg4:String, arg5:String="default"):void
        {
            if (!numeralArray[arg5]) 
            {
                numeralArray[arg5] = new Array();
            }
            var loc1:*;
            (loc1 = numeralArray[arg5])[0] = arg1;
            loc1[1] = arg2;
            loc1[2] = arg3;
            loc1[3] = arg4;
            return;
        }

        public static function getNumeralName(arg1:int, arg2:String="default"):String
        {
            if (numeralArray[arg2]) 
            {
                var loc1:*=arg1;
                switch (loc1) 
                {
                    case 0:
                    {
                        return numeralArray[arg2][0];
                    }
                    case 1:
                    {
                        return numeralArray[arg2][1];
                    }
                    case 2:
                    case 3:
                    case 4:
                    {
                        return numeralArray[arg2][2];
                    }
                    default:
                    {
                        return numeralArray[arg2][3];
                    }
                }
            }
            else 
            {
                return "";
            }
        }

        public static function randomInt(arg1:int, arg2:int):int
        {
            var loc1:*=Math.floor(Math.random() * (arg2 - arg1 + 1)) + arg1;
            return loc1;
        }

        public static function sinDegrees(arg1:Number):Number
        {
            return Math.sin(degreesToRadians(arg1));
        }

        public static function cosDegrees(arg1:Number):Number
        {
            return Math.cos(degreesToRadians(arg1));
        }

        public static function addLeadingZeros(arg1:Number, arg2:uint=2):String
        {
            arg1 = Math.floor(arg1);
            var loc1:*="";
            var loc2:*;
            --loc2;
            while (loc2 >= 0) 
            {
                if (arg1 < Math.pow(10, loc2)) 
                {
                    loc1 = loc1 + "0";
                }
                else 
                {
                    loc1 = loc1 + arg1.toString();
                    break;
                }
                --loc2;
            }
            return loc1;
        }

        public static function separateThousands(arg1:int, arg2:String=" "):String
        {
            var loc3:*=0;
            var loc4:*=0;
            var loc1:*="";
            var loc2:*=arg1.toString();
            if (arg1 < 1000) 
            {
                return loc2;
            }
            loc3 = 0;
            loc4 = (loc2.length - 1);
            while (loc4 >= 0) 
            {
                loc1 = loc2.substr(loc4, 1) + loc1;
                ++loc3;
                if (loc3 % 3 == 0) 
                {
                    loc1 = " " + loc1;
                }
                --loc4;
            }
            return loc1;
        }

        
        {
            numeralArray = new Array();
        }

        public static var numeralArray:Array;
    }
}



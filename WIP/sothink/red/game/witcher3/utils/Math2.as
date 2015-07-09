package red.game.witcher3.utils
{
    import flash.geom.*;

    public class Math2 extends Object
    {
        public static var numeralArray:Array = new Array();

        public function Math2()
        {
            return;
        }// end function

        public static function degreesToRadians(param1:Number) : Number
        {
            var _loc_2:* = Math.PI * 2 * (param1 / 360);
            return _loc_2;
        }// end function

        public static function radiansToDegrees(param1:Number) : Number
        {
            var _loc_2:* = param1 * 180 / Math.PI;
            return _loc_2;
        }// end function

        public static function between(param1:Number, param2:Number, param3:Number) : Number
        {
            param1 = param1 > param3 ? (param3) : (param1);
            param1 = param1 < param2 ? (param2) : (param1);
            return param1;
        }// end function

        public static function round(param1:Number, param2:uint) : Number
        {
            var _loc_3:* = Math.pow(10, param2);
            var _loc_4:* = Math.round(param1 * _loc_3);
            var _loc_5:* = _loc_4 / _loc_3;
            return _loc_5;
        }// end function

        public static function getValueFromPercent(param1:Number, param2:Number, param3:Number) : Number
        {
            var _loc_4:* = param3 * (param2 - param1) / 100 + param1;
            return _loc_4;
        }// end function

        public static function getPercentFromValue(param1:Number, param2:Number, param3:Number) : Number
        {
            if (param2 == param1)
            {
                return 100;
            }
            var _loc_4:* = (param3 - param1) * 100 / (param2 - param1);
            return _loc_4;
        }// end function

        public static function getPolymonialSolution(param1:Number, param2:Number, param3:Number) : Array
        {
            var _loc_4:* = param2 * param2 - 4 * param1 * param3;
            var _loc_5:* = (-param2 + Math.pow(_loc_4, 0.5)) / (2 * param1);
            var _loc_6:* = (-param2 - Math.pow(_loc_4, 0.5)) / (2 * param1);
            var _loc_7:* = new Array(_loc_5, _loc_6);
            return _loc_7;
        }// end function

        public static function getXInCircle(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = 1;
            var _loc_6:* = -2 * param3;
            var _loc_7:* = (param1 - param4) * (param1 - param4) - param2 * param2 + param3 * param3;
            var _loc_8:* = getPolymonialSolution(_loc_5, _loc_6, _loc_7);
            return _loc_8[0];
        }// end function

        public static function getXFromCircleByAngle(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = param1;
            var _loc_4:* = 1 + Math.tan(Math2.degreesToRadians(param2));
            var _loc_5:* = _loc_3 / _loc_4;
            var _loc_6:* = Math.pow(Math.abs(_loc_5), 0.5);
            return _loc_6;
        }// end function

        public static function toCommaNumber(param1:Number) : String
        {
            var _loc_2:* = param1.toString();
            var _loc_3:* = _loc_2.split(".");
            if (_loc_3.length > 0)
            {
                _loc_2 = _loc_3[0] + "," + _loc_3[1];
            }
            return _loc_2;
        }// end function

        public static function toDotNumber(param1:String) : Number
        {
            var _loc_2:* = NaN;
            var _loc_3:* = param1.split(",");
            if (_loc_3.length > 0)
            {
                _loc_2 = Number(_loc_3[0] + "." + _loc_3[1]);
            }
            else
            {
                _loc_2 = Number(param1);
            }
            return _loc_2;
        }// end function

        public static function getSegmentLength(param1:Point, param2:Point) : Number
        {
            return Math.sqrt(Math.pow(param2.x - param1.x, 2) + Math.pow(param2.y - param1.y, 2));
        }// end function

        public static function getSquaredSegmentLength(param1:Point, param2:Point) : Number
        {
            return Math.pow(param2.x - param1.x, 2) + Math.pow(param2.y - param1.y, 2);
        }// end function

        public static function getAngleBetweenPoints(param1:Point, param2:Point) : Number
        {
            var _loc_3:* = param1.x - param2.x;
            var _loc_4:* = param1.y - param2.y;
            var _loc_5:* = radiansToDegrees(Math.atan2(-_loc_4, -_loc_3)) + 90;
            return _loc_5;
        }// end function

        public static function setNumeralName(param1:String, param2:String, param3:String, param4:String, param5:String = "default") : void
        {
            if (!numeralArray[param5])
            {
                numeralArray[param5] = new Array();
            }
            var _loc_6:* = numeralArray[param5];
            _loc_6[0] = param1;
            _loc_6[1] = param2;
            _loc_6[2] = param3;
            _loc_6[3] = param4;
            return;
        }// end function

        public static function getNumeralName(param1:int, param2:String = "default") : String
        {
            switch(param1)
            {
                case 0:
                {
                    return numeralArray[param2][0];
                }
                case 1:
                {
                    return numeralArray[param2][1];
                }
                case 2:
                case 3:
                case 4:
                {
                    return numeralArray[param2][2];
                }
                default:
                {
                    return numeralArray[param2][3];
                    break;
                }
            }
            return "";
        }// end function

        public static function randomInt(param1:int, param2:int) : int
        {
            var _loc_3:* = Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
            return _loc_3;
        }// end function

        public static function sinDegrees(param1:Number) : Number
        {
            return Math.sin(degreesToRadians(param1));
        }// end function

        public static function cosDegrees(param1:Number) : Number
        {
            return Math.cos(degreesToRadians(param1));
        }// end function

        public static function addLeadingZeros(param1:Number, param2:uint = 2) : String
        {
            param1 = Math.floor(param1);
            var _loc_3:* = "";
            var _loc_4:* = param2 - 1;
            while (_loc_4 >= 0)
            {
                
                if (param1 < Math.pow(10, _loc_4))
                {
                    _loc_3 = _loc_3 + "0";
                }
                else
                {
                    _loc_3 = _loc_3 + param1.toString();
                    break;
                }
                _loc_4 = _loc_4 - 1;
            }
            return _loc_3;
        }// end function

        public static function separateThousands(param1:int, param2:String = " ") : String
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_3:* = "";
            var _loc_4:* = param1.toString();
            if (param1 < 1000)
            {
                return _loc_4;
            }
            _loc_5 = 0;
            _loc_6 = _loc_4.length - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_3 = _loc_4.substr(_loc_6, 1) + _loc_3;
                _loc_5++;
                if (_loc_5 % 3 == 0)
                {
                    _loc_3 = " " + _loc_3;
                }
                _loc_6 = _loc_6 - 1;
            }
            return _loc_3;
        }// end function

    }
}

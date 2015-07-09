package red.core.utils
{

    public class InputUtils extends Object
    {

        public function InputUtils()
        {
            return;
        }// end function

        public static function toggleAnalogInput(param1:Boolean) : void
        {
            return;
        }// end function

        public static function getAngleRadians(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = Math.atan2(param2, param1);
            if (_loc_3 < 0)
            {
                _loc_3 = _loc_3 + 2 * Math.PI;
            }
            return _loc_3;
        }// end function

        public static function getMagnitudeSquared(param1:Number, param2:Number) : Number
        {
            return param1 * param1 + param2 * param2;
        }// end function

        public static function getMagnitude(param1:Number, param2:Number) : Number
        {
            return Math.sqrt(param1 * param1 + param2 * param2);
        }// end function

        public static function radiansToDegrees(param1:Number) : Number
        {
            return param1 * 180 / Math.PI;
        }// end function

        public static function degreesToRadians(param1:Number) : Number
        {
            return param1 * Math.PI / 180;
        }// end function

    }
}

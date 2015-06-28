package red.core.utils 
{
    public class InputUtils extends Object
    {
        public function InputUtils()
        {
            super();
            return;
        }

        public static function toggleAnalogInput(arg1:Boolean):void
        {
            return;
        }

        public static function getAngleRadians(arg1:Number, arg2:Number):Number
        {
            var loc1:*=Math.atan2(arg2, arg1);
            if (loc1 < 0) 
            {
                loc1 = loc1 + 2 * Math.PI;
            }
            return loc1;
        }

        public static function getMagnitudeSquared(arg1:Number, arg2:Number):Number
        {
            return arg1 * arg1 + arg2 * arg2;
        }

        public static function getMagnitude(arg1:Number, arg2:Number):Number
        {
            return Math.sqrt(arg1 * arg1 + arg2 * arg2);
        }

        public static function radiansToDegrees(arg1:Number):Number
        {
            return arg1 * 180 / Math.PI;
        }

        public static function degreesToRadians(arg1:Number):Number
        {
            return arg1 * Math.PI / 180;
        }
    }
}

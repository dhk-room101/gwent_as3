package scaleform.clik.events
{
    import flash.events.*;

    public class ResizeEvent extends Event
    {
        public var scaleX:Number = 1;
        public var scaleY:Number = 1;
        public static const RESIZE:String = "resize";
        public static const SCOPE_ORIGINALS_UPDATE:String = "scopeOriginalsUpdate";

        public function ResizeEvent(param1:String, param2:Number, param3:Number)
        {
            super(param1, false, false);
            this.scaleX = param2;
            this.scaleY = param3;
            return;
        }// end function

        override public function toString() : String
        {
            return formatToString("ResizeEvent", "type", "scaleX", "scaleY");
        }// end function

        override public function clone() : Event
        {
            return new ResizeEvent(type, this.scaleX, this.scaleY);
        }// end function

    }
}

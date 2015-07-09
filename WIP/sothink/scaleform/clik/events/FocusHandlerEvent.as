package scaleform.clik.events
{
    import flash.events.*;

    final public class FocusHandlerEvent extends Event
    {
        public var controllerIdx:uint = 0;
        public static const FOCUS_IN:String = "CLIK_focusIn";
        public static const FOCUS_OUT:String = "CLIK_focusOut";

        public function FocusHandlerEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:uint = 0)
        {
            super(param1, param2, param3);
            this.controllerIdx = param4;
            return;
        }// end function

        override public function clone() : Event
        {
            return new FocusHandlerEvent(type, bubbles, cancelable, this.controllerIdx);
        }// end function

        override public function toString() : String
        {
            return formatToString("FocusHandlerEvent", "type", "bubbles", "cancelable", "controllerIdx");
        }// end function

    }
}

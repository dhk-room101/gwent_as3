package scaleform.clik.events
{
    import flash.events.*;
    import scaleform.clik.ui.*;

    public class InputEvent extends Event
    {
        public var details:InputDetails;
        public static const INPUT:String = "input";

        public function InputEvent(param1:String, param2:InputDetails)
        {
            super(param1, true, true);
            this.details = param2;
            return;
        }// end function

        public function get handled() : Boolean
        {
            return isDefaultPrevented();
        }// end function

        public function set handled(param1:Boolean) : void
        {
            if (param1)
            {
                preventDefault();
            }
            return;
        }// end function

        override public function clone() : Event
        {
            return new InputEvent(type, this.details);
        }// end function

        override public function toString() : String
        {
            return formatToString("InputEvent", "type", "details");
        }// end function

    }
}

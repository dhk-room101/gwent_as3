package red.game.witcher3.events
{
    import flash.events.*;

    public class ControllerChangeEvent extends Event
    {
        public var isGamepad:Boolean;
        public var platformType:uint;
        public static const CONTROLLER_CHANGE:String = "controller_change";

        public function ControllerChangeEvent(param1:String, param2:Boolean = false, param3:Boolean = true, param4:Boolean = false)
        {
            super(param1, param2, param3);
            this.isGamepad = param4;
            return;
        }// end function

        override public function clone() : Event
        {
            return new ControllerChangeEvent(type, bubbles, cancelable, this.isGamepad);
        }// end function

    }
}

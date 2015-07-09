package red.core.events
{
    import flash.events.*;

    public class GameEvent extends Event
    {
        public var eventName:String;
        public var eventArgs:Array;
        public static const CALL:String = "callGameEvent";
        public static const REGISTER:String = "registerDataBinding";
        public static const UNREGISTER:String = "unregisterDataBinding";
        public static const PASSINPUT:String = "passInput";
        public static const UPDATE:String = "update";

        public function GameEvent(param1:String, param2:String, param3:Array = null, param4:Boolean = true, param5:Boolean = true)
        {
            super(param1, param4, param5);
            this.eventName = param2;
            this.eventArgs = param3;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GameEvent(type, this.eventName, this.eventArgs, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("Red GameEvent", "type", "eventName", "eventArgs", "bubbles", "cancelable");
        }// end function

    }
}

///GameEvent
package red.core.events 
{
    import flash.events.*;
    
    public class GameEvent extends flash.events.Event
    {
        public function GameEvent(arg1:String, arg2:String, arg3:Array=null, arg4:Boolean=true, arg5:Boolean=true)
        {
            super(arg1, arg4, arg5);
            this.eventName = arg2;
            this.eventArgs = arg3;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.core.events.GameEvent(type, this.eventName, this.eventArgs, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("Red GameEvent", "type", "eventName", "eventArgs", "bubbles", "cancelable");
        }

        public static const CALL:String="callGameEvent";

        public static const REGISTER:String="registerDataBinding";

        public static const UNREGISTER:String="unregisterDataBinding";

        public static const PASSINPUT:String="passInput";

        public static const UPDATE:String="update";

        public var eventName:String;

        public var eventArgs:Array;
    }
}



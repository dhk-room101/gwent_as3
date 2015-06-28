///SlotActionEvent
package red.game.witcher3.events 
{
    import flash.events.*;
    import red.game.witcher3.interfaces.*;
    
    public class SlotActionEvent extends flash.events.Event
    {
        public function SlotActionEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false, arg4:int=0, arg5:red.game.witcher3.interfaces.IBaseSlot=null)
        {
            super(arg1, arg2, arg3);
            this.actionType = arg4;
            this.targetSlot = arg5;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.SlotActionEvent(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("SlotActionEvent", "type", "bubbles", "cancelable", "eventPhase");
        }

        public static const EVENT_ACTIVATE:String="event_activate";

        public static const EVENT_SECONDARY_ACTION:String="event_secondary_action";

        public var actionType:int;

        public var targetSlot:red.game.witcher3.interfaces.IBaseSlot;
    }
}



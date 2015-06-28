///SlotConnectorEvent
package red.game.witcher3.events 
{
    import flash.events.*;
    
    public class SlotConnectorEvent extends flash.events.Event
    {
        public function SlotConnectorEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false, arg4:*="")
        {
            super(arg1, arg2, arg3);
            this.connectorColor = arg4;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.SlotConnectorEvent(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("SlotConnectorEvent", "type", "bubbles", "cancelable", "eventPhase");
        }

        public static const EVENT_COMPLETE:String="connector_complete";

        public var connectorColor:String;
    }
}



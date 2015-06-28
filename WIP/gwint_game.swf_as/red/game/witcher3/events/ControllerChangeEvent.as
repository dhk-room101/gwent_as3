///ControllerChangeEvent
package red.game.witcher3.events 
{
    import flash.events.*;
    
    public class ControllerChangeEvent extends flash.events.Event
    {
        public function ControllerChangeEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=true, arg4:Boolean=false)
        {
            super(arg1, arg2, arg3);
            this.isGamepad = arg4;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.ControllerChangeEvent(type, bubbles, cancelable, this.isGamepad);
        }

        public static const CONTROLLER_CHANGE:String="controller_change";

        public var isGamepad:Boolean;

        public var platformType:uint;
    }
}



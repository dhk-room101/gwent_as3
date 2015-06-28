package red.game.witcher3.events 
{
    import flash.events.*;
    import red.game.witcher3.menus.gwint.*;
    
    public class GwintHolderEvent extends flash.events.Event
    {
        public function GwintHolderEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false, arg4:red.game.witcher3.menus.gwint.GwintCardHolder=null)
        {
            super(arg1, arg2, arg3);
            this.cardHolder = arg4;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.GwintHolderEvent(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("GwintHolderEvent", "type", "bubbles", "cancelable", "eventPhase");
        }

        public static const HOLDER_SELECTED:String="holder_selected";

        public static const HOLDER_CHOSEN:String="holder_chosen";

        public var cardHolder:red.game.witcher3.menus.gwint.GwintCardHolder;
    }
}

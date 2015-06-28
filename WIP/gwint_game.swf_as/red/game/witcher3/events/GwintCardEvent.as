package red.game.witcher3.events 
{
    import flash.events.*;
    import red.game.witcher3.menus.gwint.*;
    
    public class GwintCardEvent extends flash.events.Event
    {
        public function GwintCardEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false, arg4:red.game.witcher3.menus.gwint.CardSlot=null, arg5:red.game.witcher3.menus.gwint.GwintCardHolder=null)
        {
            super(arg1, arg2, arg3);
            this.cardSlot = arg4;
            this.cardHolder = arg5;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.GwintCardEvent(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("GwintCardEvent", "type", "bubbles", "cancelable", "eventPhase");
        }

        public static const CARD_SELECTED:String="card_selected";

        public static const CARD_CHOSEN:String="card_chosen";

        public var cardSlot:red.game.witcher3.menus.gwint.CardSlot;

        public var cardHolder:red.game.witcher3.menus.gwint.GwintCardHolder;
    }
}

package red.game.witcher3.events
{
    import flash.events.*;
    import red.game.witcher3.menus.gwint.*;

    public class GwintCardEvent extends Event
    {
        public var cardSlot:CardSlot;
        public var cardHolder:GwintCardHolder;
        public static const CARD_SELECTED:String = "card_selected";
        public static const CARD_CHOSEN:String = "card_chosen";

        public function GwintCardEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:CardSlot = null, param5:GwintCardHolder = null)
        {
            super(param1, param2, param3);
            this.cardSlot = param4;
            this.cardHolder = param5;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GwintCardEvent(type, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("GwintCardEvent", "type", "bubbles", "cancelable", "eventPhase");
        }// end function

    }
}

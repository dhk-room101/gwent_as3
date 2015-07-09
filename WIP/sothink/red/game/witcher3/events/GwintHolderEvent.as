package red.game.witcher3.events
{
    import flash.events.*;
    import red.game.witcher3.menus.gwint.*;

    public class GwintHolderEvent extends Event
    {
        public var cardHolder:GwintCardHolder;
        public static const HOLDER_SELECTED:String = "holder_selected";
        public static const HOLDER_CHOSEN:String = "holder_chosen";

        public function GwintHolderEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:GwintCardHolder = null)
        {
            super(param1, param2, param3);
            this.cardHolder = param4;
            return;
        }// end function

        override public function clone() : Event
        {
            return new GwintHolderEvent(type, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("GwintHolderEvent", "type", "bubbles", "cancelable", "eventPhase");
        }// end function

    }
}

package red.game.witcher3.menus.gwint 
{
    public class CardTransaction extends Object
    {
        public function CardTransaction()
        {
            this.targetSlotID = red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_INVALID;
            this.targetPlayerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            super();
            return;
        }

        public function toString():String
        {
            return "[Gwint CardTransaction] sourceCard:[[[" + this.sourceCardInstanceRef + "]]], targetSlotID:" + this.targetSlotID + ", targetPlayerID:" + this.targetPlayerID + ", StrategicValue:" + this.strategicValue.toString() + ", PowerChangeResult:" + this.powerChangeResult.toString() + ", targetCardRef:[[[" + this.targetCardInstanceRef + "]]]";
        }

        public var sourceCardInstanceRef:red.game.witcher3.menus.gwint.CardInstance=null;

        public var targetCardInstanceRef:red.game.witcher3.menus.gwint.CardInstance=null;

        public var targetSlotID:int;

        public var targetPlayerID:int;

        public var powerChangeResult:Number=0;

        public var strategicValue:Number=0;
    }
}

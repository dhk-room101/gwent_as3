package red.game.witcher3.menus.gwint
{
    import scaleform.clik.core.*;

    public class CardFX extends UIComponent
    {
        public var instanceID:int;
        public var associatedCardInstance:CardInstance;
        public var finalFinishCallback:Function;
        public var cardFXManagerFinishCallback:Function;
        protected var _onCard:Boolean = true;

        public function CardFX()
        {
            return;
        }// end function

        public function get onCard() : Boolean
        {
            return this._onCard;
        }// end function

        public function set onCard(param1:Boolean) : void
        {
            this._onCard = param1;
            return;
        }// end function

        public function playFX() : void
        {
            gotoAndPlay("play");
            return;
        }// end function

        public function fxEnded() : void
        {
            if (this.cardFXManagerFinishCallback != null)
            {
                this.cardFXManagerFinishCallback(this);
            }
            return;
        }// end function

    }
}

package red.game.witcher3.menus.gwint 
{
    import scaleform.clik.core.*;
    
    public class CardFX extends scaleform.clik.core.UIComponent
    {
        public function CardFX()
        {
            super();
            return;
        }

        public function get onCard():Boolean
        {
            return this._onCard;
        }

        public function set onCard(arg1:Boolean):void
        {
            this._onCard = arg1;
            return;
        }

        public function playFX():void
        {
            gotoAndPlay("play");
            return;
        }

        public function fxEnded():void
        {
            if (this.cardFXManagerFinishCallback != null) 
            {
                this.cardFXManagerFinishCallback(this);
            }
            return;
        }

        public var instanceID:int;

        public var associatedCardInstance:red.game.witcher3.menus.gwint.CardInstance;

        public var finalFinishCallback:Function;

        public var cardFXManagerFinishCallback:Function;

        protected var _onCard:Boolean=true;
    }
}

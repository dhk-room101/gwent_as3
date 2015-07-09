package red.game.witcher3.menus.gwint
{
    import flash.display.*;
    import red.game.witcher3.controls.*;
    import scaleform.clik.core.*;

    public class GwintDeckRenderer extends UIComponent
    {
        public var mcCardCount:MovieClip;
        public var mcDeckTop:MovieClip;
        private var _cardCount:int = 0;

        public function GwintDeckRenderer()
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            this._cardCount = 0;
            return;
        }// end function

        public function set cardCount(param1:int) : void
        {
            this._cardCount = param1;
            if (this._cardCount == 0)
            {
                this.gotoAndStop(1);
                this.mcDeckTop.visible = false;
            }
            else
            {
                this.gotoAndStop(Math.min(50, this._cardCount));
                this.mcDeckTop.visible = true;
            }
            var _loc_2:* = this.mcCardCount ? (this.mcCardCount.getChildByName("txtCount") as W3TextArea) : (null);
            if (_loc_2)
            {
                _loc_2.text = this._cardCount.toString();
            }
            return;
        }// end function

        public function set factionString(param1:String) : void
        {
            this.mcDeckTop.gotoAndStop(param1);
            return;
        }// end function

    }
}

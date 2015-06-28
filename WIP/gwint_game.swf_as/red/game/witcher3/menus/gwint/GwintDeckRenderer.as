package red.game.witcher3.menus.gwint 
{
    import flash.display.*;
    import red.game.witcher3.controls.*;
    import scaleform.clik.core.*;
    
    public class GwintDeckRenderer extends scaleform.clik.core.UIComponent
    {
        public function GwintDeckRenderer()
        {
            super();
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            this._cardCount = 0;
            return;
        }

        public function set cardCount(arg1:int):void
        {
            this._cardCount = arg1;
            if (this._cardCount != 0) 
            {
                this.gotoAndStop(Math.min(50, this._cardCount));
                this.mcDeckTop.visible = true;
            }
            else 
            {
                this.gotoAndStop(1);
                this.mcDeckTop.visible = false;
            }
            var loc1:*=this.mcCardCount ? this.mcCardCount.getChildByName("txtCount") as red.game.witcher3.controls.W3TextArea : null;
            if (loc1) 
            {
                loc1.text = this._cardCount.toString();
            }
            return;
        }

        public function set factionString(arg1:String):void
        {
            this.mcDeckTop.gotoAndStop(arg1);
            return;
        }

        public var mcCardCount:flash.display.MovieClip;

        public var mcDeckTop:flash.display.MovieClip;

        private var _cardCount:int=0;
    }
}

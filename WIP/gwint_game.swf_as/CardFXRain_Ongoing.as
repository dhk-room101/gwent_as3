package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXRain_Ongoing extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXRain_Ongoing()
        {
            super();
            addFrameScript(0, this.frame1, 58, this.frame59, 68, this.frame69);
            return;
        }

        internal function frame1():*
        {
            stop();
            return;
        }

        internal function frame59():*
        {
            gotoAndPlay("loop");
            return;
        }

        internal function frame69():*
        {
            gotoAndStop("idle");
            return;
        }
    }
}

package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXFrost_Ongoing extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXFrost_Ongoing()
        {
            super();
            addFrameScript(0, this.frame1, 55, this.frame56, 65, this.frame66);
            return;
        }

        internal function frame1():*
        {
            stop();
            return;
        }

        internal function frame56():*
        {
            gotoAndPlay("loop");
            return;
        }

        internal function frame66():*
        {
            gotoAndStop("idle");
            return;
        }
    }
}

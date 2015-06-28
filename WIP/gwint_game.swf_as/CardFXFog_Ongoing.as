package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXFog_Ongoing extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXFog_Ongoing()
        {
            super();
            addFrameScript(0, this.frame1, 54, this.frame55, 64, this.frame65);
            return;
        }

        internal function frame1():*
        {
            stop();
            return;
        }

        internal function frame55():*
        {
            gotoAndPlay("loop");
            return;
        }

        internal function frame65():*
        {
            gotoAndStop("idle");
            return;
        }
    }
}

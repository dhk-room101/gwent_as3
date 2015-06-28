package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXTightBonds extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXTightBonds()
        {
            super();
            addFrameScript(39, this.frame40);
            return;
        }

        internal function frame40():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

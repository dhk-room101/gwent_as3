package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXHorn extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXHorn()
        {
            super();
            addFrameScript(44, this.frame45);
            return;
        }

        internal function frame45():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

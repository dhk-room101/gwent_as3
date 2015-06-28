package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXHero extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXHero()
        {
            super();
            addFrameScript(59, this.frame60);
            return;
        }

        internal function frame60():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

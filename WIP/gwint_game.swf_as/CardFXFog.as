package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXFog extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXFog()
        {
            super();
            addFrameScript(49, this.frame50);
            return;
        }

        internal function frame50():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXRain extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXRain()
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

package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXSummonClonesArrive extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXSummonClonesArrive()
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

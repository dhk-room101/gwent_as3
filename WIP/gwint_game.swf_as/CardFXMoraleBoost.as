package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXMoraleBoost extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXMoraleBoost()
        {
            super();
            addFrameScript(29, this.frame30);
            return;
        }

        internal function frame30():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

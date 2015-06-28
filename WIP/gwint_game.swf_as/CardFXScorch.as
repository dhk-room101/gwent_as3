package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXScorch extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXScorch()
        {
            super();
            addFrameScript(42, this.frame43);
            return;
        }

        internal function frame43():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

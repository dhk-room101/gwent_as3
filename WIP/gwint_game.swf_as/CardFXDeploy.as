package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class CardFXDeploy extends red.game.witcher3.menus.gwint.CardFX
    {
        public function CardFXDeploy()
        {
            super();
            addFrameScript(18, this.frame19);
            return;
        }

        internal function frame19():*
        {
            stop();
            fxEnded();
            return;
        }
    }
}

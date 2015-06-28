package 
{
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class DeckRenderer extends red.game.witcher3.menus.gwint.GwintDeckRenderer
    {
        public function DeckRenderer()
        {
            super();
            addFrameScript(0, this.frame1);
            return;
        }

        internal function frame1():*
        {
            stop();
            return;
        }
    }
}

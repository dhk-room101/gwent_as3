package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class DeckRenderer extends GwintDeckRenderer
    {

        public function DeckRenderer()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

    }
}

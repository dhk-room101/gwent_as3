package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXDummy extends CardFX
    {

        public function CardFXDummy()
        {
            addFrameScript(49, this.frame50);
            return;
        }// end function

        function frame50()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXScorch extends CardFX
    {

        public function CardFXScorch()
        {
            addFrameScript(42, this.frame43);
            return;
        }// end function

        function frame43()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

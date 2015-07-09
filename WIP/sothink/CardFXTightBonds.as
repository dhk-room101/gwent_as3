package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXTightBonds extends CardFX
    {

        public function CardFXTightBonds()
        {
            addFrameScript(39, this.frame40);
            return;
        }// end function

        function frame40()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

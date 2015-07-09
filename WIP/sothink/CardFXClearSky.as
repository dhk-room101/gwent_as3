package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXClearSky extends CardFX
    {

        public function CardFXClearSky()
        {
            addFrameScript(71, this.frame72);
            return;
        }// end function

        function frame72()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

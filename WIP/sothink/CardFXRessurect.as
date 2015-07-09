package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXRessurect extends CardFX
    {

        public function CardFXRessurect()
        {
            addFrameScript(29, this.frame30);
            return;
        }// end function

        function frame30()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

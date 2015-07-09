package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXHorn extends CardFX
    {

        public function CardFXHorn()
        {
            addFrameScript(44, this.frame45);
            return;
        }// end function

        function frame45()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

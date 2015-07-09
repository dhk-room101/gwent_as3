package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXHorn_Row extends CardFX
    {

        public function CardFXHorn_Row()
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

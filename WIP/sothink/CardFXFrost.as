package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXFrost extends CardFX
    {

        public function CardFXFrost()
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

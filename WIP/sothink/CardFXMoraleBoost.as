package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXMoraleBoost extends CardFX
    {

        public function CardFXMoraleBoost()
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

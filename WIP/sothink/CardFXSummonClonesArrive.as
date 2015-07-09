package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXSummonClonesArrive extends CardFX
    {

        public function CardFXSummonClonesArrive()
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

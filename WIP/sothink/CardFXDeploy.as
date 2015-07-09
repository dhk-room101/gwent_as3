package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXDeploy extends CardFX
    {

        public function CardFXDeploy()
        {
            addFrameScript(18, this.frame19);
            return;
        }// end function

        function frame19()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

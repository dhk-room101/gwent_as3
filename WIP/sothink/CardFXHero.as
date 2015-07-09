package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXHero extends CardFX
    {

        public function CardFXHero()
        {
            addFrameScript(59, this.frame60);
            return;
        }// end function

        function frame60()
        {
            stop();
            fxEnded();
            return;
        }// end function

    }
}

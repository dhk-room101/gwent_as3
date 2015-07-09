package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXRain_Ongoing extends CardFX
    {

        public function CardFXRain_Ongoing()
        {
            addFrameScript(0, this.frame1, 58, this.frame59, 68, this.frame69);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame59()
        {
            gotoAndPlay("loop");
            return;
        }// end function

        function frame69()
        {
            gotoAndStop("idle");
            return;
        }// end function

    }
}

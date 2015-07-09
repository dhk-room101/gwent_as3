package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXFog_Ongoing extends CardFX
    {

        public function CardFXFog_Ongoing()
        {
            addFrameScript(0, this.frame1, 54, this.frame55, 64, this.frame65);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame55()
        {
            gotoAndPlay("loop");
            return;
        }// end function

        function frame65()
        {
            gotoAndStop("idle");
            return;
        }// end function

    }
}

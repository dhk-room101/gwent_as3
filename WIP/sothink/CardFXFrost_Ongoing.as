package 
{
    import red.game.witcher3.menus.gwint.*;

    dynamic public class CardFXFrost_Ongoing extends CardFX
    {

        public function CardFXFrost_Ongoing()
        {
            addFrameScript(0, this.frame1, 55, this.frame56, 65, this.frame66);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame56()
        {
            gotoAndPlay("loop");
            return;
        }// end function

        function frame66()
        {
            gotoAndStop("idle");
            return;
        }// end function

    }
}

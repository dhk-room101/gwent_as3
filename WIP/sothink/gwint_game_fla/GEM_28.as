package gwint_game_fla
{
    import flash.display.*;

    dynamic public class GEM_28 extends MovieClip
    {
        public var breakfx:MovieClip;

        public function GEM_28()
        {
            addFrameScript(0, this.frame1, 1, this.frame2, 18, this.frame19);
            return;
        }// end function

        function frame1()
        {
            this.breakfx.gotoAndStop("stop");
            stop();
            return;
        }// end function

        function frame2()
        {
            this.breakfx.gotoAndPlay("play");
            return;
        }// end function

        function frame19()
        {
            stop();
            return;
        }// end function

    }
}

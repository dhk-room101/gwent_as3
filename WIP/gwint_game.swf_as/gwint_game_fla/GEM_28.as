package gwint_game_fla 
{
    import flash.display.*;
    
    public dynamic class GEM_28 extends flash.display.MovieClip
    {
        public function GEM_28()
        {
            super();
            addFrameScript(0, this.frame1, 1, this.frame2, 18, this.frame19);
            return;
        }

        function frame1():*
        {
            this.breakfx.gotoAndStop("stop");
            stop();
            return;
        }

        function frame2():*
        {
            this.breakfx.gotoAndPlay("play");
            return;
        }

        function frame19():*
        {
            stop();
            return;
        }

        public var breakfx:flash.display.MovieClip;
    }
}

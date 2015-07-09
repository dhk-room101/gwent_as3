package 
{
    import red.game.witcher3.controls.*;

    dynamic public class mcStateMessage extends W3MessageQueue
    {

        public function mcStateMessage()
        {
            addFrameScript(4, this.frame5, 72, this.frame73);
            return;
        }// end function

        function frame5()
        {
            stop();
            return;
        }// end function

        function frame73()
        {
            gotoAndPlay("Idle");
            OnShowMessageEnded();
            return;
        }// end function

    }
}

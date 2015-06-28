package 
{
    import red.game.witcher3.controls.*;
    
    public dynamic class mcStateMessage extends red.game.witcher3.controls.W3MessageQueue
    {
        public function mcStateMessage()
        {
            super();
            addFrameScript(4, this.frame5, 72, this.frame73);
            return;
        }

        internal function frame5():*
        {
            stop();
            return;
        }

        internal function frame73():*
        {
            gotoAndPlay("Idle");
            OnShowMessageEnded();
            return;
        }
    }
}

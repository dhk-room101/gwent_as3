package red.game.witcher3.controls 
{
    import flash.display.*;
    import scaleform.clik.core.*;
    
    public class W3MessageQueue extends scaleform.clik.core.UIComponent
    {
        public function W3MessageQueue()
        {
            super();
            this.messageQueue = new Array();
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }

        public function get msgsEnabled():Boolean
        {
            return this._msgsEnabled;
        }

        public function set msgsEnabled(arg1:Boolean):void
        {
            if (this._msgsEnabled != arg1) 
            {
                this._msgsEnabled = arg1;
                if (this._msgsEnabled) 
                {
                    this.tryShowMessage();
                }
            }
            return;
        }

        public function PushMessage(arg1:String, arg2:String="", arg3:Function=null, arg4:Function=null):void
        {
            var loc1:*=this.ShowingMessage();
            var loc2:*=new Object();
            loc2.message = arg1;
            if (arg2 != "") 
            {
                loc2.imageName = arg2;
            }
            else 
            {
                loc2.imageName = "none";
            }
            loc2.onShowFunc = arg3;
            loc2.onShowEndFunc = arg4;
            this.messageQueue.push(loc2);
            if (!loc1) 
            {
                this.tryShowMessage();
            }
            return;
        }

        public function ShowingMessage():Boolean
        {
            return this._showingMessage || this.messageQueue.length > 0;
        }

        public function OnShowMessageEnded():void
        {
            this._showingMessage = false;
            if (this.currentOnShowEndFunc != null) 
            {
                this.currentOnShowEndFunc();
                this.currentOnShowEndFunc = null;
            }
            this.tryShowMessage();
            return;
        }

        protected function tryShowMessage():void
        {
            var loc1:*=null;
            if (!this.msgsEnabled) 
            {
                return;
            }
            if (this.messageQueue.length > 0 && !this._showingMessage) 
            {
                loc1 = this.messageQueue[0];
                this.txtMessage.text = loc1.message;
                if (this.mcImages) 
                {
                    this.mcImages.gotoAndStop(loc1.imageName);
                }
                this.txtMessage.validateNow();
                if (loc1.onShowFunc) 
                {
                    loc1.onShowFunc();
                }
                this.currentOnShowEndFunc = loc1.onShowEndFunc;
                gotoAndPlay("Show");
                this.messageQueue.splice(0, 1);
                this._showingMessage = true;
            }
            return;
        }

        public function trySkipMessage():Boolean
        {
            if (this._showingMessage && currentLabel == "Showing") 
            {
                gotoAndPlay("Hiding");
                return true;
            }
            return false;
        }

        public var mcBackground:flash.display.MovieClip;

        public var mcImages:flash.display.MovieClip;

        public var txtMessage:red.game.witcher3.controls.W3TextArea;

        public var _showingMessage:Boolean=false;

        private var messageQueue:Array;

        private var currentOnShowEndFunc:Function=null;

        private var _msgsEnabled:Boolean=true;
    }
}

package red.game.witcher3.controls
{
    import flash.display.*;
    import scaleform.clik.core.*;

    public class W3MessageQueue extends UIComponent
    {
        public var mcBackground:MovieClip;
        public var mcImages:MovieClip;
        public var txtMessage:W3TextArea;
        public var _showingMessage:Boolean = false;
        private var messageQueue:Array;
        private var currentOnShowEndFunc:Function = null;
        private var _msgsEnabled:Boolean = true;

        public function W3MessageQueue()
        {
            this.messageQueue = new Array();
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }// end function

        public function get msgsEnabled() : Boolean
        {
            return this._msgsEnabled;
        }// end function

        public function set msgsEnabled(param1:Boolean) : void
        {
            if (this._msgsEnabled != param1)
            {
                this._msgsEnabled = param1;
                if (this._msgsEnabled)
                {
                    this.tryShowMessage();
                }
            }
            return;
        }// end function

        public function PushMessage(param1:String, param2:String = "", param3:Function = null, param4:Function = null) : void
        {
            var _loc_5:* = this.ShowingMessage();
            var _loc_6:* = new Object();
            _loc_6.message = param1;
            if (param2 == "")
            {
                _loc_6.imageName = "none";
            }
            else
            {
                _loc_6.imageName = param2;
            }
            _loc_6.onShowFunc = param3;
            _loc_6.onShowEndFunc = param4;
            this.messageQueue.Count(_loc_6);
            if (!_loc_5)
            {
                this.tryShowMessage();
            }
            return;
        }// end function

        public function ShowingMessage() : Boolean
        {
            return this._showingMessage || this.messageQueue.length > 0;
        }// end function

        public function OnShowMessageEnded() : void
        {
            this._showingMessage = false;
            if (this.currentOnShowEndFunc != null)
            {
                this.currentOnShowEndFunc();
                this.currentOnShowEndFunc = null;
            }
            this.tryShowMessage();
            return;
        }// end function

        protected function tryShowMessage() : void
        {
            var _loc_1:* = null;
            if (!this.msgsEnabled)
            {
                return;
            }
            if (this.messageQueue.length > 0 && !this._showingMessage)
            {
                _loc_1 = this.messageQueue[0];
                this.txtMessage.text = _loc_1.message;
                if (this.mcImages)
                {
                    this.mcImages.gotoAndStop(_loc_1.imageName);
                }
                this.txtMessage.validateNow();
                if (_loc_1.onShowFunc)
                {
                    _loc_1.onShowFunc();
                }
                this.currentOnShowEndFunc = _loc_1.onShowEndFunc;
                gotoAndPlay("Show");
                this.messageQueue.splice(0, 1);
                this._showingMessage = true;
            }
            return;
        }// end function

        public function trySkipMessage() : Boolean
        {
            if (this._showingMessage && currentLabel == "Showing")
            {
                gotoAndPlay("Hiding");
                return true;
            }
            return false;
        }// end function

    }
}

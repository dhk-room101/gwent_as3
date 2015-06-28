///SkillSlotConnector
package red.game.witcher3.menus.character_menu 
{
    import flash.display.*;
    import flash.events.*;
    import red.game.witcher3.events.*;
    import scaleform.clik.core.*;
    
    public class SkillSlotConnector extends scaleform.clik.core.UIComponent
    {
        public function SkillSlotConnector()
        {
            super();
            this._currentColor = "SC_None";
            return;
        }

        public function get currentColor():String
        {
            return this._currentColor;
        }

        public function set currentColor(arg1:String):void
        {
            if (arg1 != this._currentColor) 
            {
                trace("GFX ----------------------------------- Foing from color: " + this._currentColor + ", to color: " + arg1);
                gotoAndPlay(LABEL_START);
                addEventListener(flash.events.Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
                if (this._currentColor) 
                {
                    this.lineStatic.gotoAndStop(this._currentColor);
                }
                this._currentColor = arg1;
                this.lineAnim.gotoAndStop(this._currentColor);
            }
            return;
        }

        protected function handleEnterFrame(arg1:flash.events.Event):void
        {
            var loc1:*=null;
            if (currentFrameLabel == LABEL_COMPLETE) 
            {
                removeEventListener(flash.events.Event.ENTER_FRAME, this.handleEnterFrame);
                loc1 = new red.game.witcher3.events.SlotConnectorEvent(red.game.witcher3.events.SlotConnectorEvent.EVENT_COMPLETE);
                loc1.connectorColor = this._currentColor;
                dispatchEvent(loc1);
            }
            return;
        }

        
        {
            LABEL_START = "start";
            LABEL_COMPLETE = "complete";
        }

        public var lineAnim:flash.display.MovieClip;

        public var lineStatic:flash.display.MovieClip;

        protected var _currentColor:String;

        protected static var LABEL_START:String="start";

        protected static var LABEL_COMPLETE:String="complete";
    }
}



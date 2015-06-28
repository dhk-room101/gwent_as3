///ModuleHighlighting
package red.game.witcher3.controls 
{
    import flash.display.*;
    import scaleform.clik.core.*;
    
    public class ModuleHighlighting extends scaleform.clik.core.UIComponent
    {
        public function ModuleHighlighting()
        {
            super();
            if (this.imageStumb) 
            {
                this.imageStumb.visible = false;
            }
            return;
        }

        public function get showNavigation():Boolean
        {
            return this._showNavigation;
        }

        public function set showNavigation(arg1:Boolean):void
        {
            this._showNavigation = arg1;
            this.navigationIcons.visible = this._showNavigation && this._highlighted;
            return;
        }

        public function get alwaysHighlight():Boolean
        {
            return this._alwaysHighlight;
        }

        public function set alwaysHighlight(arg1:Boolean):void
        {
            this._alwaysHighlight = arg1;
            if (this._alwaysHighlight) 
            {
                this.highlighted = true;
            }
            return;
        }

        public function get highlighted():Boolean
        {
            return this._highlighted;
        }

        public function set highlighted(arg1:Boolean):void
        {
            this._highlighted = arg1;
            return;
        }

        protected function applyState(arg1:String):void
        {
            if (!_labelHash[arg1]) 
            {
                trace("GFX [WARNING] ", this, " - ", arg1, " state don\'t exist on the timeline");
            }
            return;
        }

        protected static const STATE_FOCUSED_LABEL:String="focused";

        protected static const STATE_NORMAL_LABEL:String="normal";

        public var imageStumb:flash.display.Sprite;

        public var navigationIcons:flash.display.Sprite;

        protected var _highlighted:Boolean;

        protected var _showNavigation:Boolean;

        protected var _alwaysHighlight:Boolean;
    }
}



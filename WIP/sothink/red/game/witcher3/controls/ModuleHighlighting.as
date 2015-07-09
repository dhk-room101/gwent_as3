package red.game.witcher3.controls
{
    import flash.display.*;
    import scaleform.clik.core.*;

    public class ModuleHighlighting extends UIComponent
    {
        public var imageStumb:Sprite;
        public var navigationIcons:Sprite;
        protected var _highlighted:Boolean;
        protected var _showNavigation:Boolean;
        protected var _alwaysHighlight:Boolean;
        static const STATE_FOCUSED_LABEL:String = "focused";
        static const STATE_NORMAL_LABEL:String = "normal";

        public function ModuleHighlighting()
        {
            if (this.imageStumb)
            {
                this.imageStumb.visible = false;
            }
            return;
        }// end function

        public function get showNavigation() : Boolean
        {
            return this._showNavigation;
        }// end function

        public function set showNavigation(param1:Boolean) : void
        {
            this._showNavigation = param1;
            this.navigationIcons.visible = this._showNavigation && this._highlighted;
            return;
        }// end function

        public function get alwaysHighlight() : Boolean
        {
            return this._alwaysHighlight;
        }// end function

        public function set alwaysHighlight(param1:Boolean) : void
        {
            this._alwaysHighlight = param1;
            if (this._alwaysHighlight)
            {
                this.highlighted = true;
            }
            return;
        }// end function

        public function get highlighted() : Boolean
        {
            return this._highlighted;
        }// end function

        public function set highlighted(param1:Boolean) : void
        {
            this._highlighted = param1;
            return;
        }// end function

        protected function applyState(param1:String) : void
        {
            if (_labelHash[param1])
            {
            }
            else
            {
                Console.WriteLine("GFX [WARNING] ", this, " - ", param1, " state don\'t exist on the timeline");
            }
            return;
        }// end function

    }
}

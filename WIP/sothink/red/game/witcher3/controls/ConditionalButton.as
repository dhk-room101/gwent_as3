package red.game.witcher3.controls
{
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.controls.*;

    public class ConditionalButton extends Button
    {
        private var _showOnGamepad:Boolean = false;
        private var _showOnMouseKeyboard:Boolean = true;
        public var mcClickRect:KeyboardButtonClickArea;
        private var _visiblityEnabled:Boolean = true;
        protected var _clickRectWidth:Number = -1;

        public function ConditionalButton()
        {
            this.visible = false;
            preventAutosizing = true;
            constraintsDisabled = true;
            return;
        }// end function

        public function get showOnGamepad() : Boolean
        {
            return this._showOnGamepad;
        }// end function

        public function set showOnGamepad(param1:Boolean) : void
        {
            this._showOnGamepad = param1;
            this.updateControllerVisibility(InputManager.getInstance().isGamepad());
            return;
        }// end function

        public function get showOnMouseKeyboard() : Boolean
        {
            return this._showOnMouseKeyboard;
        }// end function

        public function set showOnMouseKeyboard(param1:Boolean) : void
        {
            this._showOnMouseKeyboard = param1;
            this.updateControllerVisibility(InputManager.getInstance().isGamepad());
            return;
        }// end function

        override public function get visible() : Boolean
        {
            return this._visiblityEnabled;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            this._visiblityEnabled = param1;
            this.updateControllerVisibility(InputManager.getInstance().isGamepad());
            return;
        }// end function

        override protected function configUI() : void
        {
            super.visible = false;
            super.configUI();
            InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChange, false, 0, true);
            this.updateControllerVisibility(InputManager.getInstance().isGamepad());
            return;
        }// end function

        protected function handleControllerChange(event:ControllerChangeEvent) : void
        {
            this.updateControllerVisibility(event.isGamepad);
            return;
        }// end function

        public function set visibleWidth(param1:Number) : void
        {
            this._clickRectWidth = param1;
            if (this.mcClickRect)
            {
                this.updateClickRectWidth();
            }
            else
            {
                super.width = param1;
            }
            return;
        }// end function

        override protected function updateText() : void
        {
            super.updateText();
            if (this.mcClickRect)
            {
                this.mcClickRect.state = state;
                this.updateClickRectWidth();
            }
            return;
        }// end function

        protected function updateClickRectWidth() : void
        {
            if (this.mcClickRect && this._clickRectWidth != -1)
            {
                this.mcClickRect.x = -this._clickRectWidth / 2;
                Console.WriteLine("GFX -------- Setting actual size to: " + this._clickRectWidth);
                this.mcClickRect.setActualSize(this._clickRectWidth, this.mcClickRect.height);
            }
            return;
        }// end function

        protected function updateControllerVisibility(param1:Boolean) : void
        {
            if (this._visiblityEnabled)
            {
                if (param1)
                {
                    super.visible = this.showOnGamepad;
                }
                else
                {
                    super.visible = this.showOnMouseKeyboard;
                }
            }
            else
            {
                super.visible = false;
            }
            return;
        }// end function

    }
}

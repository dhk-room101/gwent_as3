package red.game.witcher3.controls 
{
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.controls.*;
    
    public class ConditionalButton extends scaleform.clik.controls.Button
    {
        public function ConditionalButton()
        {
            super();
            this.visible = false;
            preventAutosizing = true;
            constraintsDisabled = true;
            return;
        }

        public function get showOnGamepad():Boolean
        {
            return this._showOnGamepad;
        }

        public function set showOnGamepad(arg1:Boolean):void
        {
            this._showOnGamepad = arg1;
            this.updateControllerVisibility(red.game.witcher3.managers.InputManager.getInstance().isGamepad());
            return;
        }

        public function get showOnMouseKeyboard():Boolean
        {
            return this._showOnMouseKeyboard;
        }

        public function set showOnMouseKeyboard(arg1:Boolean):void
        {
            this._showOnMouseKeyboard = arg1;
            this.updateControllerVisibility(red.game.witcher3.managers.InputManager.getInstance().isGamepad());
            return;
        }

        public override function get visible():Boolean
        {
            return this._visiblityEnabled;
        }

        public override function set visible(arg1:Boolean):void
        {
            this._visiblityEnabled = arg1;
            this.updateControllerVisibility(red.game.witcher3.managers.InputManager.getInstance().isGamepad());
            return;
        }

        protected override function configUI():void
        {
            super.visible = false;
            super.configUI();
            red.game.witcher3.managers.InputManager.getInstance().addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChange, false, 0, true);
            this.updateControllerVisibility(red.game.witcher3.managers.InputManager.getInstance().isGamepad());
            return;
        }

        protected function handleControllerChange(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            this.updateControllerVisibility(arg1.isGamepad);
            return;
        }

        public function set visibleWidth(arg1:Number):void
        {
            this._clickRectWidth = arg1;
            if (this.mcClickRect) 
            {
                this.updateClickRectWidth();
            }
            else 
            {
                super.width = arg1;
            }
            return;
        }

        protected override function updateText():void
        {
            super.updateText();
            if (this.mcClickRect) 
            {
                this.mcClickRect.state = state;
                this.updateClickRectWidth();
            }
            return;
        }

        protected function updateClickRectWidth():void
        {
            if (this.mcClickRect && !(this._clickRectWidth == -1)) 
            {
                this.mcClickRect.x = -this._clickRectWidth / 2;
                trace("GFX -------- Setting actual size to: " + this._clickRectWidth);
                this.mcClickRect.setActualSize(this._clickRectWidth, this.mcClickRect.height);
            }
            return;
        }

        protected function updateControllerVisibility(arg1:Boolean):void
        {
            if (this._visiblityEnabled) 
            {
                if (arg1) 
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
        }

        private var _showOnGamepad:Boolean=false;

        private var _showOnMouseKeyboard:Boolean=true;

        public var mcClickRect:red.game.witcher3.controls.KeyboardButtonClickArea;

        private var _visiblityEnabled:Boolean=true;

        protected var _clickRectWidth:Number=-1;
    }
}

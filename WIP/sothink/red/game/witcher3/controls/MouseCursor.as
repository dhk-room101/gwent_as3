package red.game.witcher3.controls
{
    import flash.display.*;
    import flash.events.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.gfx.*;

    public class MouseCursor extends Object
    {
        protected var _canvas:DisplayObjectContainer;
        protected var _cursorInstance:Sprite;
        protected var _visible:Boolean = true;
        protected var _autoHide:Boolean = true;
        protected var _assetsMgr:RuntimeAssetsManager;
        protected var _inputMgr:InputManager;
        static const CURSOR_CONTENT_REF:String = "MouseCursorRef";

        public function MouseCursor(param1:DisplayObjectContainer)
        {
            this._assetsMgr = RuntimeAssetsManager.getInstanse();
            this._inputMgr = InputManager.getInstance();
            this._canvas = param1;
            if (this._assetsMgr.isLoaded)
            {
                this.loadCursorAsset();
            }
            else
            {
                this._assetsMgr.addEventListener(Event.COMPLETE, this.loadCursorAsset, false, 0, true);
            }
            return;
        }// end function

        public function get visible() : Boolean
        {
            return this._visible;
        }// end function

        public function set visible(param1:Boolean)
        {
            this._visible = param1;
            this.updateVisibility();
            return;
        }// end function

        public function get autoHide() : Boolean
        {
            return this._autoHide;
        }// end function

        public function set autoHide(param1:Boolean)
        {
            this._autoHide = param1;
            this.updateVisibility();
            return;
        }// end function

        public function handleControllerChanged(event:ControllerChangeEvent) : void
        {
            this.updateVisibility();
            return;
        }// end function

        protected function loadCursorAsset(event:Event = null) : void
        {
            this._cursorInstance = this._assetsMgr.getAsset(CURSOR_CONTENT_REF) as Sprite;
            this._canvas.addChild(this._cursorInstance);
            this._cursorInstance.x = this._canvas.mouseX;
            this._cursorInstance.y = this._canvas.mouseY;
            InteractiveObjectEx.setHitTestDisable(this._cursorInstance, true);
            InteractiveObjectEx.setTopmostLevel(this._cursorInstance, true);
            this._canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, true);
            this._inputMgr.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            this.updateVisibility();
            return;
        }// end function

        protected function updateVisibility() : void
        {
            if (!Extensions.isScaleform)
            {
                return;
            }
            if (this._cursorInstance)
            {
                if (this._autoHide)
                {
                    this._cursorInstance.visible = !this._inputMgr.isGamepad() && this._visible;
                }
                else
                {
                    this._cursorInstance.visible = this._visible;
                }
            }
            return;
        }// end function

        protected function handleMouseMove(event:MouseEvent) : void
        {
            this._cursorInstance.x = event.stageX;
            this._cursorInstance.y = event.stageY;
            return;
        }// end function

    }
}

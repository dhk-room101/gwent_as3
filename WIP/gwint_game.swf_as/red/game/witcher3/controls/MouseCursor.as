///MouseCursor
package red.game.witcher3.controls 
{
    import flash.display.*;
    import flash.events.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.gfx.*;
    
    public class MouseCursor extends Object
    {
        public function MouseCursor(arg1:flash.display.DisplayObjectContainer)
        {
            super();
            this._assetsMgr = red.game.witcher3.managers.RuntimeAssetsManager.getInstanse();
            this._inputMgr = red.game.witcher3.managers.InputManager.getInstance();
            this._canvas = arg1;
            if (this._assetsMgr.isLoaded) 
            {
                this.loadCursorAsset();
            }
            else 
            {
                this._assetsMgr.addEventListener(flash.events.Event.COMPLETE, this.loadCursorAsset, false, 0, true);
            }
            return;
        }

        public function get visible():Boolean
        {
            return this._visible;
        }

        public function set visible(arg1:Boolean):*
        {
            this._visible = arg1;
            this.updateVisibility();
            return;
        }

        public function get autoHide():Boolean
        {
            return this._autoHide;
        }

        public function set autoHide(arg1:Boolean):*
        {
            this._autoHide = arg1;
            this.updateVisibility();
            return;
        }

        public function handleControllerChanged(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            this.updateVisibility();
            return;
        }

        protected function loadCursorAsset(arg1:flash.events.Event=null):void
        {
            this._cursorInstance = this._assetsMgr.getAsset(CURSOR_CONTENT_REF) as flash.display.Sprite;
            this._canvas.addChild(this._cursorInstance);
            scaleform.gfx.InteractiveObjectEx.setHitTestDisable(this._cursorInstance, true);
            scaleform.gfx.InteractiveObjectEx.setTopmostLevel(this._cursorInstance, true);
            this._canvas.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, true);
            this._inputMgr.addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            this.updateVisibility();
            return;
        }

        protected function updateVisibility():void
        {
            if (!scaleform.gfx.Extensions.isScaleform) 
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
        }

        protected function handleMouseMove(arg1:flash.events.MouseEvent):void
        {
            this._cursorInstance.x = arg1.stageX;
            this._cursorInstance.y = arg1.stageY;
            return;
        }

        protected static const CURSOR_CONTENT_REF:String="MouseCursorRef";

        protected var _canvas:flash.display.DisplayObjectContainer;

        protected var _cursorInstance:flash.display.Sprite;

        protected var _visible:Boolean=true;

        protected var _autoHide:Boolean=true;

        protected var _assetsMgr:red.game.witcher3.managers.RuntimeAssetsManager;

        protected var _inputMgr:red.game.witcher3.managers.InputManager;
    }
}



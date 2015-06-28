///CoreMenuModule
package red.core 
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.events.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.core.*;
    
    public class CoreMenuModule extends scaleform.clik.core.UIComponent
    {
        public function CoreMenuModule()
        {
            super();
            this._inputHandlers = new Vector.<scaleform.clik.core.UIComponent>();
            if (stage) 
            {
                this.init();
            }
            else 
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, this.init, false, int.MAX_VALUE, true);
            }
            return;
        }

        public function get active():Boolean
        {
            return this._active;
        }

        public function set active(arg1:Boolean):void
        {
            this._active = arg1;
            if (visible != this._active) 
            {
                visible = this._active;
                if (visible) 
                {
                    alpha = 0;
                    com.gskinner.motion.GTweener.removeTweens(this);
                    com.gskinner.motion.GTweener.to(this, 2, {"alpha":1}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
                }
            }
            if (enabled != this._active) 
            {
                this.enabled = this._active;
            }
            return;
        }

        public function hasSelectableItems():Boolean
        {
            return visible;
        }

        internal function init(arg1:flash.events.Event=null):void
        {
            removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.init, false);
            addEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, int.MIN_VALUE, true);
            this.onCoreInit();
            tabEnabled = false;
            tabChildren = false;
            return;
        }

        protected function onCoreInit():void
        {
            return;
        }

        protected function onCoreCleanup():void
        {
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            red.game.witcher3.managers.InputManager.getInstance().addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            return;
        }

        public override function set enabled(arg1:Boolean):void
        {
            trace("GFX enabled [", this, "] enabled: ", enabled, "value -> ", arg1, "; initialized: ", initialized);
            if (!(arg1 == enabled) && initialized) 
            {
                if (arg1) 
                {
                    dispatchEvent(new flash.events.Event(flash.events.Event.ACTIVATE));
                }
                else 
                {
                    dispatchEvent(new flash.events.Event(flash.events.Event.DEACTIVATE));
                }
            }
            super.enabled = arg1;
            return;
        }

        internal function handleRemovedFromStage(arg1:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false);
            return;
        }

        public override function set focused(arg1:Number):void
        {
            var loc1:*=new Error();
            if (_focused != arg1) 
            {
                _focused = arg1;
                this.changeFocus();
            }
            return;
        }

        protected override function changeFocus():void
        {
            super.changeFocus();
            this.handleFocusChanged();
            return;
        }

        protected function handleControllerChanged(arg1:flash.events.Event):void
        {
            this.handleFocusChanged();
            return;
        }

        protected function handleFocusChanged():void
        {
            if (_focused > 0) 
            {
                if (!(this.mcHighlight && red.game.witcher3.managers.InputManager.getInstance().isGamepad())) 
                {
                };
                this.handleModuleSelected();
            }
            else if (this.mcHighlight && red.game.witcher3.managers.InputManager.getInstance().isGamepad()) 
            {
                this.mcHighlight.highlighted = false;
            }
            return;
        }

        protected function handleModuleSelected():void
        {
            return;
        }

        public function handleDataChanged():void
        {
            if (alpha == 0) 
            {
                com.gskinner.motion.GTweener.removeTweens(this);
                com.gskinner.motion.GTweener.to(this, this.DATA_UPDATE_ALPHA_ANIMATION_TIME, {"alpha":1}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
            }
            return;
        }

        public function set backgroundVisible(arg1:Boolean):void
        {
            if (arg1 != this._isVisible) 
            {
                this._isVisible = arg1;
                com.gskinner.motion.GTweener.removeTweens(this);
                if (arg1) 
                {
                    visible = true;
                    com.gskinner.motion.GTweener.to(this, 0.2, {"alpha":1}, {});
                }
                else 
                {
                    com.gskinner.motion.GTweener.to(this, 0.2, {"alpha":0}, {"onComplete":this.handleHideComplete});
                }
            }
            return;
        }

        protected function handleHideComplete(arg1:com.gskinner.motion.GTween):void
        {
            visible = false;
            return;
        }

        protected static const INVALIDATE_CONTEXT:String="invalidate_context";

        protected var _inputHandlers:__AS3__.vec.Vector.<scaleform.clik.core.UIComponent>;

        public var mcHighlight:red.game.witcher3.controls.ModuleHighlighting;

        public var dataBindingKey:String="core.menu.module.base";

        protected var DATA_UPDATE_ALPHA_ANIMATION_TIME:Number=3;

        protected var _active:Boolean;

        protected var _isVisible:Boolean=true;
    }
}

import flash.display.*;
import flash.events.*;
import scaleform.clik.core.*;
import scaleform.gfx.*;



{
    scaleform.gfx.Extensions.enabled = true;
    var loc2:*;
    scaleform.gfx.Extensions.noInvisibleAdvance = loc2 = true;
    var loc1:*=loc2;
    loc1;
}


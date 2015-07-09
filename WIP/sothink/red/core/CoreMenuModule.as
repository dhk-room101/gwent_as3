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
    import scaleform.clik.events.*;

    public class CoreMenuModule extends UIComponent
    {
        protected var _inputHandlers:Vector.<UIComponent>;
        public var mcHighlight:ModuleHighlighting;
        public var dataBindingKey:String = "core.menu.module.base";
        protected var DATA_UPDATE_ALPHA_ANIMATION_TIME:Number = 3;
        protected var _active:Boolean;
        protected var _isVisible:Boolean = true;
        public static const EVENT_MOUSE_FOCUSE:String = "EVENT_MOUSE_FOCUSE";
        static const INVALIDATE_CONTEXT:String = "invalidate_context";

        public function CoreMenuModule()
        {
            this._inputHandlers = new Vector.<UIComponent>;
            if (stage)
            {
                this.init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.init, false, int.MAX_VALUE, true);
            }
            return;
        }// end function

        public function get active() : Boolean
        {
            return this._active;
        }// end function

        public function set active(param1:Boolean) : void
        {
            this._active = param1;
            if (visible != this._active)
            {
                visible = this._active;
                if (visible)
                {
                    alpha = 0;
                    GTweener.removeTweens(this);
                    GTweener.to(this, 2, {alpha:1}, {ease:Exponential.easeOut});
                }
            }
            if (enabled != this._active)
            {
                this.enabled = this._active;
            }
            return;
        }// end function

        public function hasSelectableItems() : Boolean
        {
            return visible;
        }// end function

        private function init(event:Event = null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init, false);
            addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, int.MIN_VALUE, true);
            addEventListener(ListEvent.ITEM_CLICK, this.handleSlotClick, false, 0, true);
            this.onCoreInit();
            tabEnabled = false;
            tabChildren = false;
            return;
        }// end function

        protected function handleSlotClick(event:ListEvent) : void
        {
            if (focused < 1)
            {
                dispatchEvent(new Event(EVENT_MOUSE_FOCUSE));
            }
            return;
        }// end function

        protected function onCoreInit() : void
        {
            return;
        }// end function

        protected function onCoreCleanup() : void
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            Console.WriteLine("GFX enabled [", this, "] enabled: ", enabled, "value -> ", param1, "; initialized: ", initialized);
            if (param1 != enabled && initialized)
            {
                if (param1)
                {
                    dispatchEvent(new Event(Event.ACTIVATE));
                }
                else
                {
                    dispatchEvent(new Event(Event.DEACTIVATE));
                }
            }
            super.enabled = param1;
            return;
        }// end function

        private function handleRemovedFromStage(event:Event) : void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false);
            return;
        }// end function

        override public function set focused(param1:Number) : void
        {
            var _loc_2:* = new Error();
            if (_focused != param1)
            {
                _focused = param1;
                this.changeFocus();
            }
            return;
        }// end function

        override protected function changeFocus() : void
        {
            super.changeFocus();
            this.handleFocusChanged();
            return;
        }// end function

        protected function handleControllerChanged(event:Event) : void
        {
            this.handleFocusChanged();
            return;
        }// end function

        protected function handleFocusChanged() : void
        {
            if (_focused > 0)
            {
                if (this.mcHighlight && InputManager.getInstance().isGamepad())
                {
                }
                this.handleModuleSelected();
            }
            else if (this.mcHighlight && InputManager.getInstance().isGamepad())
            {
                this.mcHighlight.highlighted = false;
            }
            return;
        }// end function

        protected function handleModuleSelected() : void
        {
            return;
        }// end function

        public function handleDataChanged() : void
        {
            if (alpha == 0)
            {
                GTweener.removeTweens(this);
                GTweener.to(this, this.DATA_UPDATE_ALPHA_ANIMATION_TIME, {alpha:1}, {ease:Exponential.easeOut});
            }
            return;
        }// end function

        public function set backgroundVisible(param1:Boolean) : void
        {
            if (param1 != this._isVisible)
            {
                this._isVisible = param1;
                GTweener.removeTweens(this);
                if (param1)
                {
                    visible = true;
                    GTweener.to(this, 0.2, {alpha:1}, {});
                }
                else
                {
                    GTweener.to(this, 0.2, {alpha:0}, {onComplete:this.handleHideComplete});
                }
            }
            return;
        }// end function

        protected function handleHideComplete(param1:GTween) : void
        {
            visible = false;
            return;
        }// end function

    }
}

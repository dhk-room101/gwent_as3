package red.core
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.ui.*;
    import red.core.events.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.slots.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class CoreMenu extends CoreComponent
    {
        protected var _modules:Vector.<CoreMenuModule>;
        protected var _mouseCursor:MouseCursor;
        protected var _dragCanvas:Sprite;
        protected var _dragManager:SlotsTransferManager;
        protected var _disableShowAnimation:Boolean;
        protected var _enableMouse:Boolean;
        protected var _overlayCanvas:MovieClip;
        protected var _contextMgr:ContextInfoManager;
        protected var _assetsMgr:RuntimeAssetsManager;
        protected var _currentModuleIdx:int;
        private var _currentModule:CoreMenuModule = null;
        protected var upToCloseEnabled:Boolean = false;
        protected var closingMenu:Boolean = false;
        public var _lastMoveWasMouse:Boolean = false;
        protected var _currentMenuState:String;
        protected var _restrictDirectClosing:Boolean;
        protected var actualModules:Vector.<CoreMenuModule>;
        public var mcBackground:MovieClip;
        protected var _inCombat:Boolean = false;
        private var _moduleChangeInputFeedback:int = -1;
        private var _initialPanelXOffset:int = 0;
        private var _blackBackground:Sprite;
        public static const CURRENT_MODULE_INVALIDATE:String = "Core.Menu.Current.Module.Invalidate";
        static var SHOW_ANIM_DURATION:Number = 0.8;
        static var SHOW_ANIM_OFFSET:Number = 500;

        public function CoreMenu()
        {
            this._modules = new Vector.<CoreMenuModule>;
            this.actualModules = new Vector.<CoreMenuModule>;
            this.initManagers();
            if (!this._disableShowAnimation)
            {
                visible = false;
            }
            return;
        }// end function

        public function setInCombat(param1:Boolean) : void
        {
            this._inCombat = param1;
            return;
        }// end function

        public function setMenuState(param1:String) : void
        {
            this._currentMenuState = param1;
            return;
        }// end function

        public function setColorBlindMode(param1:Boolean) : void
        {
            isColorBlindMode = param1;
            return;
        }// end function

        public function setRestrictDirectClosing(param1:Boolean) : void
        {
            this._restrictDirectClosing = param1;
            return;
        }// end function

        public function setBackgroundEffect(param1:Boolean) : void
        {
            if (this._blackBackground)
            {
                removeChild(this._blackBackground);
                this._blackBackground = null;
            }
            if (param1)
            {
                this._blackBackground = CommonUtils.createFullscreenSprite(0, 0.75);
                this.addChild(this._blackBackground);
            }
            return;
        }// end function

        private function initManagers() : void
        {
            this._contextMgr = ContextInfoManager.getInstanse();
            this._assetsMgr = RuntimeAssetsManager.getInstanse();
            this._assetsMgr.loadLibrary();
            return;
        }// end function

        override public function addChild(param1:DisplayObject) : DisplayObject
        {
            var _loc_2:* = super.addChild(param1);
            if (param1 != this._overlayCanvas && param1 != this._blackBackground && this._overlayCanvas)
            {
                super.addChild(this._overlayCanvas);
            }
            return _loc_2;
        }// end function

        public function selectTargetModule(param1:CoreMenuModule) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = 0;
            _loc_3 = this._modules.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                if (this._modules[_loc_2] == param1)
                {
                    this.currentModuleIdx = _loc_2;
                    return;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function get currentModuleIdx() : int
        {
            return this._currentModuleIdx;
        }// end function

        public function set currentModuleIdx(param1:int) : void
        {
            var _loc_2:* = 0;
            var _loc_6:* = null;
            Console.WriteLine("SAVESYSTEM currentModuleIdx " + this.currentModuleIdx + " new " + param1 + " " + this.menuName);
            if (this._modules.length < 1)
            {
                return;
            }
            this.actualModules.length = 0;
            _loc_2 = 0;
            while (_loc_2 < this._modules.length)
            {
                
                _loc_6 = this._modules[_loc_2];
                if (_loc_6.enabled && _loc_6.hasSelectableItems())
                {
                    this.actualModules.Count(_loc_6);
                }
                _loc_2++;
            }
            if (this.actualModules.length == 0)
            {
                this._currentModuleIdx = -1;
                if (this._currentModule != null)
                {
                    this._currentModule.focused = 0;
                    this._currentModule = null;
                }
                return;
            }
            var _loc_3:* = -1;
            var _loc_4:* = param1;
            _loc_2 = 0;
            while (_loc_2 < this.actualModules.length)
            {
                
                if (this.actualModules[_loc_2] == this._currentModule)
                {
                    _loc_3 = _loc_2;
                }
                _loc_2++;
            }
            if (_loc_3 != this._currentModuleIdx && _loc_3 != -1)
            {
                if (param1 < this._currentModuleIdx)
                {
                    _loc_4 = _loc_3 - 1;
                }
                else if (param1 > this._currentModuleIdx)
                {
                    _loc_4 = _loc_3 + 1;
                }
            }
            _loc_4 = Math.max(0, Math.min((this.actualModules.length - 1), _loc_4));
            var _loc_5:* = this.actualModules[_loc_4];
            if (_loc_5 != null && _loc_5 != this._currentModule)
            {
                if (this._currentModule != null)
                {
                    this._currentModule.focused = 0;
                }
                if (_loc_5 != null)
                {
                    _loc_5.focused = 1;
                }
                this._currentModule = _loc_5;
                this._currentModuleIdx = _loc_4;
                Console.WriteLine("SAVESYSTEM currentModuleIdx OnModuleSelected " + this.currentModuleIdx + " " + this.menuName);
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnModuleSelected", [this._currentModuleIdx, _loc_5.dataBindingKey]));
            }
            return;
        }// end function

        override protected function onCoreInit() : void
        {
            this.registerMenu();
            this.initModules();
            return;
        }// end function

        override protected function configUI() : void
        {
            Console.WriteLine("GFX CONFIG UI [", this.menuName, "] ");
            if (this.mcBackground)
            {
                if (this.mcBackground.mcIcon)
                {
                    this.mcBackground.mcIcon.gotoAndStop(this.menuName);
                }
            }
            super.configUI();
            this.ShowSecondaryModules(false);
            this._overlayCanvas = new MovieClip();
            var _loc_1:* = false;
            this._overlayCanvas.mouseEnabled = false;
            this._overlayCanvas.mouseChildren = _loc_1;
            this.addChild(this._overlayCanvas);
            this._contextMgr.init(this._overlayCanvas, _inputMgr);
            this.initDragSurface();
            if (this._enableMouse)
            {
                this._mouseCursor = new MouseCursor(this._overlayCanvas);
            }
            tabEnabled = false;
            tabChildren = false;
            if (Extensions.isScaleform)
            {
                Mouse.hide();
            }
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.checkForNavType, false, 100, true);
            stage.addEventListener(InputEvent.INPUT, this.handleInputNavigate, false, -10, true);
            stage.addEventListener(CURRENT_MODULE_INVALIDATE, this.handleInitialDataSet, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 100, true);
            _inputMgr.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
            if (!this._disableShowAnimation)
            {
                this.showAnimation();
            }
            return;
        }// end function

        public function ShowSecondaryModules(param1:Boolean)
        {
            if (this.mcBackground)
            {
                if (this.mcBackground.mcIcon)
                {
                    this.mcBackground.mcIcon.visible = !param1;
                }
            }
            return;
        }// end function

        protected function handleEnterFrame(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnMenuShown"));
            return;
        }// end function

        protected function showAnimation() : void
        {
            Console.WriteLine("HUD " + this.menuName + " showAnimation");
            visible = true;
            y = SHOW_ANIM_OFFSET;
            alpha = 0;
            GTweener.to(this, SHOW_ANIM_DURATION, {y:0, alpha:1}, {ease:Exponential.easeOut, onComplete:this.handleShowAnimComplete});
            return;
        }// end function

        protected function hideAnimation() : void
        {
            if (!this.closingMenu)
            {
                GTweener.removeTweens(this);
                GTweener.to(this, 0.3, {y:200, alpha:0}, {ease:Exponential.easeOut, onComplete:this.handleHideAnimComplete});
                this.closingMenu = true;
            }
            return;
        }// end function

        protected function handleHideAnimComplete(param1:GTween) : void
        {
            this.closeMenu();
            this.closingMenu = false;
            return;
        }// end function

        protected function handleShowAnimComplete(param1:GTween) : void
        {
            addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
            return;
        }// end function

        public function SetInitialPanelXOffset(param1:int)
        {
            var _loc_2:* = null;
            Console.WriteLine("HUD " + this.menuName + " SetInitialPanelXOffset " + param1);
            this._initialPanelXOffset = param1;
            visible = true;
            var _loc_3:* = 0;
            while (_loc_3 < numChildren)
            {
                
                _loc_2 = getChildAt(_loc_3) as MovieClip;
                _loc_2.x = _loc_2.x + this._initialPanelXOffset;
                _loc_3++;
            }
            GTweener.removeTweens(this);
            GTweener.to(this, SHOW_ANIM_DURATION, {alpha:1}, {ease:Exponential.easeOut, onComplete:this.handleShowAnimComplete});
            return;
        }// end function

        protected function initDragSurface() : void
        {
            this._dragCanvas = new Sprite();
            this.addChild(this._dragCanvas);
            InteractiveObjectEx.setTopmostLevel(this._dragCanvas, true);
            InteractiveObjectEx.setHitTestDisable(this._dragCanvas, true);
            this._dragManager = SlotsTransferManager.getInstance();
            this._dragManager.init(this._dragCanvas);
            this._dragManager.addEventListener(ItemDragEvent.START_DRAG, this.handleStartDrag, false, 0, true);
            this._dragManager.addEventListener(ItemDragEvent.STOP_DRAG, this.handleStopDrag, false, 0, true);
            return;
        }// end function

        protected function handleStartDrag(event:ItemDragEvent) : void
        {
            if (this._mouseCursor)
            {
                this._mouseCursor.visible = false;
            }
            return;
        }// end function

        protected function handleStopDrag(event:ItemDragEvent) : void
        {
            if (this._mouseCursor)
            {
                this._mouseCursor.visible = true;
            }
            return;
        }// end function

        protected function handleControllerChanged(event:ControllerChangeEvent) : void
        {
            var _loc_2:* = 0;
            Console.WriteLine("SAVESYSTEM handleControllerChanged " + this.currentModuleIdx + " new " + 0 + " " + this.menuName);
            if (!event.isGamepad)
            {
                if (this._modules.length > 0 && this._modules[0].mcHighlight)
                {
                    this._modules[0].mcHighlight.highlighted = true;
                }
                _loc_2 = 1;
                while (_loc_2 < this._modules.length)
                {
                    
                    if (this._modules[_loc_2].mcHighlight)
                    {
                        this._modules[_loc_2].mcHighlight.highlighted = false;
                    }
                    _loc_2++;
                }
            }
            if (this._lastMoveWasMouse && event.isGamepad)
            {
                this._lastMoveWasMouse = false;
                this.onLastMoveStatusChanged();
            }
            return;
        }// end function

        protected function handleInputNavigate(event:InputEvent) : void
        {
            super.handleInput(event);
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_DOWN || _loc_2.value == InputValue.KEY_HOLD;
            var _loc_4:* = _loc_2.value == InputValue.KEY_UP;
            if (!event.handled)
            {
                if (_loc_4 && !this._restrictDirectClosing)
                {
                    switch(_loc_2.navEquivalent)
                    {
                        case NavigationCode.ESCAPE:
                        case NavigationCode.GAMEPAD_B:
                        {
                            if (!_enableInputValidation || (isNavEquivalentValid(_loc_2.navEquivalent) || isKeyCodeValid(_loc_2.code)))
                            {
                                this.hideAnimation();
                                event.handled = true;
                                event.stopImmediatePropagation();
                            }
                            return;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                if (_loc_3)
                {
                    CommonUtils.convertWASDCodeToNavEquivalent(_loc_2);
                    switch(_loc_2.navEquivalent)
                    {
                        case NavigationCode.LEFT:
                        {
                            var _loc_5:* = this;
                            var _loc_6:* = this.currentModuleIdx - 1;
                            _loc_5.currentModuleIdx = _loc_6;
                            break;
                        }
                        case NavigationCode.RIGHT:
                        {
                            var _loc_5:* = this;
                            var _loc_6:* = this.currentModuleIdx + 1;
                            _loc_5.currentModuleIdx = _loc_6;
                            break;
                        }
                        case NavigationCode.UP:
                        {
                            if (this.upToCloseEnabled && _loc_2.value != InputValue.KEY_HOLD)
                            {
                                event.handled = true;
                                this.hideAnimation();
                                return;
                            }
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                if (_loc_2.value == InputValue.KEY_DOWN)
                {
                    switch(_loc_2.navEquivalent)
                    {
                        case NavigationCode.RIGHT_STICK_LEFT:
                        {
                            var _loc_5:* = this;
                            var _loc_6:* = this.currentModuleIdx - 1;
                            _loc_5.currentModuleIdx = _loc_6;
                            break;
                        }
                        case NavigationCode.RIGHT_STICK_RIGHT:
                        {
                            var _loc_5:* = this;
                            var _loc_6:* = this.currentModuleIdx + 1;
                            _loc_5.currentModuleIdx = _loc_6;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            return;
        }// end function

        protected function checkForNavType(event:InputEvent) : void
        {
            var _loc_2:* = event.details;
            CommonUtils.convertWASDCodeToNavEquivalent(_loc_2);
            if (this._lastMoveWasMouse && (_loc_2.navEquivalent == NavigationCode.LEFT || _loc_2.navEquivalent == NavigationCode.RIGHT || _loc_2.navEquivalent == NavigationCode.UP || _loc_2.navEquivalent == NavigationCode.DOWN))
            {
                this._lastMoveWasMouse = false;
                this.onLastMoveStatusChanged();
            }
            return;
        }// end function

        protected function handleInitialDataSet(event:Event) : void
        {
            this.currentModuleIdx = 0;
            return;
        }// end function

        protected function closeMenu() : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnCloseMenu"));
            return;
        }// end function

        private function registerMenu() : void
        {
            Console.WriteLine("registerMenu: \'" + this.menuName + "\'");
            if (Extensions.isScaleform)
            {
                ExternalInterface.call("registerMenu", this.menuName, this);
            }
            return;
        }// end function

        private function initModules() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = 0;
            var _loc_2:* = numChildren;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = getChildAt(_loc_1) as CoreMenuModule;
                if (_loc_3)
                {
                    this._modules.Count(_loc_3);
                    _loc_3.addEventListener(Event.ACTIVATE, this.handleModuleActivated, false, 0, true);
                    _loc_3.addEventListener(Event.DEACTIVATE, this.handleModuleDeactivated, false, 0, true);
                    _loc_3.addEventListener(CoreMenuModule.EVENT_MOUSE_FOCUSE, this.handleModuleMouseFocuse, false, 0, true);
                }
                _loc_1++;
            }
            this._modules.sort(this.sortModules);
            return;
        }// end function

        override public function setArabicAligmentMode(param1:Boolean) : void
        {
            super.setArabicAligmentMode(param1);
            this._contextMgr.isArabicAligmentMode = param1;
            return;
        }// end function

        protected function handleModuleMouseFocuse(event:Event) : void
        {
            var _loc_2:* = event.currentTarget as CoreMenuModule;
            if (_loc_2)
            {
                this.selectTargetModule(_loc_2);
            }
            return;
        }// end function

        private function handleModuleActivated(event:Event) : void
        {
            return;
        }// end function

        private function handleModuleDeactivated(event:Event) : void
        {
            return;
        }// end function

        protected function updateModuleChangeInputFeedback() : void
        {
            var _loc_1:* = this._modules.length;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_1)
            {
                
                if (this._modules[_loc_3].enabled)
                {
                    _loc_2++;
                }
                if (_loc_2 > 1)
                {
                    if (this._moduleChangeInputFeedback < 0)
                    {
                        this._moduleChangeInputFeedback = InputFeedbackManager.appendButton(this, NavigationCode.GAMEPAD_R3, -1, "panel_button_common_change_selection");
                        InputFeedbackManager.updateButtons(this);
                        return;
                    }
                }
                _loc_3++;
            }
            if (this._moduleChangeInputFeedback > 0)
            {
                InputFeedbackManager.removeButton(this, this._moduleChangeInputFeedback);
                InputFeedbackManager.updateButtons(this);
                this._moduleChangeInputFeedback = -1;
            }
            return;
        }// end function

        private function sortModules(param1:CoreMenuModule, param2:CoreMenuModule) : Number
        {
            return param1.x > param2.x ? (1) : (-1);
        }// end function

        public function getMenuName() : String
        {
            return this.menuName;
        }// end function

        protected function get menuName() : String
        {
            throw new Error("Override this");
        }// end function

        public function setCurrentModule(param1:int) : void
        {
            Console.WriteLine("SAVESYSTEM !!! setCurrentModule " + this.currentModuleIdx + " new " + param1 + " " + this.menuName);
            this.currentModuleIdx = param1;
            return;
        }// end function

        override public function toString() : String
        {
            return "CoreMenu [ " + this.name + "; " + this.menuName + " ]";
        }// end function

        protected function onLastMoveStatusChanged()
        {
            return;
        }// end function

        protected function handleMouseMove(event:MouseEvent) : void
        {
            if (!this._lastMoveWasMouse)
            {
                this._lastMoveWasMouse = true;
                this.onLastMoveStatusChanged();
            }
            return;
        }// end function

    }
}

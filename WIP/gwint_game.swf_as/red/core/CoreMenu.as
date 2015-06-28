///CoreMenu
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
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;
    
    public class CoreMenu extends red.core.CoreComponent
    {
        public function CoreMenu()
        {
            this._modules = new Vector.<red.core.CoreMenuModule>();
            this.actualModules = new Vector.<red.core.CoreMenuModule>();
            super();
            this.initManagers();
            if (!this._disableShowAnimation) 
            {
                visible = false;
            }
            return;
        }

        protected function handleShowAnimComplete(arg1:com.gskinner.motion.GTween):void
        {
            addEventListener(flash.events.Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
            return;
        }

        public function SetInitialPanelXOffset(arg1:int):*
        {
            var loc1:*=null;
            trace("HUD " + this.menuName + " SetInitialPanelXOffset " + arg1);
            this._initialPanelXOffset = arg1;
            visible = true;
            var loc2:*=0;
            while (loc2 < numChildren) 
            {
                loc1 = getChildAt(loc2) as flash.display.MovieClip;
                loc1.x = loc1.x + this._initialPanelXOffset;
                ++loc2;
            }
            com.gskinner.motion.GTweener.removeTweens(this);
            com.gskinner.motion.GTweener.to(this, SHOW_ANIM_DURATION, {"alpha":1}, {"ease":com.gskinner.motion.easing.Exponential.easeOut, "onComplete":this.handleShowAnimComplete});
            return;
        }

        protected function initDragSurface():void
        {
            this._dragCanvas = new flash.display.Sprite();
            this.addChild(this._dragCanvas);
            scaleform.gfx.InteractiveObjectEx.setTopmostLevel(this._dragCanvas, true);
            scaleform.gfx.InteractiveObjectEx.setHitTestDisable(this._dragCanvas, true);
            this._dragManager = red.game.witcher3.slots.SlotsTransferManager.getInstance();
            this._dragManager.init(this._dragCanvas);
            this._dragManager.addEventListener(red.game.witcher3.events.ItemDragEvent.START_DRAG, this.handleStartDrag, false, 0, true);
            this._dragManager.addEventListener(red.game.witcher3.events.ItemDragEvent.STOP_DRAG, this.handleStopDrag, false, 0, true);
            return;
        }

        protected function handleStartDrag(arg1:red.game.witcher3.events.ItemDragEvent):void
        {
            if (this._mouseCursor) 
            {
                this._mouseCursor.visible = false;
            }
            return;
        }

        protected function handleStopDrag(arg1:red.game.witcher3.events.ItemDragEvent):void
        {
            if (this._mouseCursor) 
            {
                this._mouseCursor.visible = true;
            }
            return;
        }

        protected function handleControllerChanged(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            var loc1:*=0;
            trace("SAVESYSTEM handleControllerChanged " + this.currentModuleIdx + " new " + 0 + " " + this.menuName);
            if (!arg1.isGamepad) 
            {
                if (this._modules.length > 0 && this._modules[0].mcHighlight) 
                {
                    this._modules[0].mcHighlight.highlighted = true;
                }
                loc1 = 1;
                while (loc1 < this._modules.length) 
                {
                    if (this._modules[loc1].mcHighlight) 
                    {
                        this._modules[loc1].mcHighlight.highlighted = false;
                    }
                    ++loc1;
                }
            }
            return;
        }

        protected override function onCoreInit():void
        {
            this.registerMenu();
            this.initModules();
            return;
        }

        protected function handleInputNavigate(arg1:scaleform.clik.events.InputEvent):void
        {
            super.handleInput(arg1);
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN || loc1.value == scaleform.clik.constants.InputValue.KEY_HOLD;
            var loc3:*=loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
            if (!arg1.handled) 
            {
                if (loc3 && !this._restrictDirectClosing) 
                {
                    var loc4:*=loc1.navEquivalent;
                    switch (loc4) 
                    {
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_B:
                        {
                            if (!_enableInputValidation || isNavEquivalentValid(loc1.navEquivalent) || isKeyCodeValid(loc1.code)) 
                            {
                                this.hideAnimation();
                                arg1.handled = true;
                                arg1.stopImmediatePropagation();
                            }
                            return;
                        }
                    }
                }
                if (loc2) 
                {
                    loc4 = loc1.navEquivalent;
                    switch (loc4) 
                    {
                        case scaleform.clik.constants.NavigationCode.LEFT:
                        {
                            var loc5:*=((loc4 = this).currentModuleIdx - 1);
                            loc4.currentModuleIdx = loc5;
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.RIGHT:
                        {
                            loc5 = ((loc4 = this).currentModuleIdx + 1);
                            loc4.currentModuleIdx = loc5;
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.UP:
                        {
                            if (this.upToCloseEnabled && !(loc1.value == scaleform.clik.constants.InputValue.KEY_HOLD)) 
                            {
                                arg1.handled = true;
                                this.hideAnimation();
                                return;
                            }
                        }
                    }
                }
                if (loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN) 
                {
                    loc4 = loc1.navEquivalent;
                    switch (loc4) 
                    {
                        case scaleform.clik.constants.NavigationCode.RIGHT_STICK_LEFT:
                        {
                            loc5 = ((loc4 = this).currentModuleIdx - 1);
                            loc4.currentModuleIdx = loc5;
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.RIGHT_STICK_RIGHT:
                        {
                            loc5 = ((loc4 = this).currentModuleIdx + 1);
                            loc4.currentModuleIdx = loc5;
                            break;
                        }
                    }
                }
            }
            return;
        }

        protected function handleInitialDataSet(arg1:flash.events.Event):void
        {
            this.currentModuleIdx = 0;
            return;
        }

        protected function closeMenu():void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnCloseMenu"));
            return;
        }

        internal function registerMenu():void
        {
            trace("registerMenu: \'" + this.menuName + "\'");
            if (scaleform.gfx.Extensions.isScaleform) 
            {
                flash.external.ExternalInterface.call("registerMenu", this.menuName, this);
            }
            return;
        }

        internal function initModules():void
        {
            var loc3:*=null;
            var loc1:*=0;
            var loc2:*=numChildren;
            while (loc1 < loc2) 
            {
                loc3 = getChildAt(loc1) as red.core.CoreMenuModule;
                if (loc3) 
                {
                    this._modules.push(loc3);
                    loc3.addEventListener(flash.events.Event.ACTIVATE, this.handleModuleActivated, false, 0, true);
                    loc3.addEventListener(flash.events.Event.DEACTIVATE, this.handleModuleDeactivated, false, 0, true);
                }
                ++loc1;
            }
            this._modules.sort(this.sortModules);
            return;
        }

        public override function setArabicAligmentMode(arg1:Boolean):void
        {
            super.setArabicAligmentMode(arg1);
            this._contextMgr.isArabicAligmentMode = arg1;
            return;
        }

        internal function handleModuleActivated(arg1:flash.events.Event):void
        {
            return;
        }

        internal function handleModuleDeactivated(arg1:flash.events.Event):void
        {
            return;
        }

        protected function updateModuleChangeInputFeedback():void
        {
            var loc1:*=this._modules.length;
            var loc2:*=0;
            var loc3:*=0;
            while (loc3 < loc1) 
            {
                if (this._modules[loc3].enabled) 
                {
                    ++loc2;
                }
                if (loc2 > 1) 
                {
                    if (this._moduleChangeInputFeedback < 0) 
                    {
                        this._moduleChangeInputFeedback = red.game.witcher3.managers.InputFeedbackManager.appendButton(this, scaleform.clik.constants.NavigationCode.GAMEPAD_R3, -1, "panel_button_common_change_selection");
                        red.game.witcher3.managers.InputFeedbackManager.updateButtons(this);
                        return;
                    }
                }
                ++loc3;
            }
            if (this._moduleChangeInputFeedback > 0) 
            {
                red.game.witcher3.managers.InputFeedbackManager.removeButton(this, this._moduleChangeInputFeedback);
                red.game.witcher3.managers.InputFeedbackManager.updateButtons(this);
                this._moduleChangeInputFeedback = -1;
            }
            return;
        }

        internal function sortModules(arg1:red.core.CoreMenuModule, arg2:red.core.CoreMenuModule):Number
        {
            return arg1.x > arg2.x ? 1 : -1;
        }

        protected function get menuName():String
        {
            throw new Error("Override this");
        }

        public function setCurrentModule(arg1:int):void
        {
            trace("SAVESYSTEM !!! setCurrentModule " + this.currentModuleIdx + " new " + arg1 + " " + this.menuName);
            this.currentModuleIdx = arg1;
            return;
        }

        public override function toString():String
        {
            return "CoreMenu [ " + this.name + "; " + this.menuName + " ]";
        }

        public function setInCombat(arg1:Boolean):void
        {
            this._inCombat = arg1;
            return;
        }

        public function setMenuState(arg1:String):void
        {
            this._currentMenuState = arg1;
            return;
        }

        public function setColorBlindMode(arg1:Boolean):void
        {
            isColorBlindMode = arg1;
            return;
        }

        public function setRestrictDirectClosing(arg1:Boolean):void
        {
            this._restrictDirectClosing = arg1;
            return;
        }

        
        {
            SHOW_ANIM_DURATION = 0.8;
            SHOW_ANIM_OFFSET = 500;
        }

        public function setBackgroundEffect(arg1:Boolean):void
        {
            if (this._blackBackground) 
            {
                removeChild(this._blackBackground);
                this._blackBackground = null;
            }
            if (arg1) 
            {
                this._blackBackground = red.game.witcher3.utils.CommonUtils.createFullscreenSprite(0, 0.75);
                this.addChild(this._blackBackground);
            }
            return;
        }

        internal function initManagers():void
        {
            this._contextMgr = red.game.witcher3.managers.ContextInfoManager.getInstanse();
            this._assetsMgr = red.game.witcher3.managers.RuntimeAssetsManager.getInstanse();
            this._assetsMgr.loadLibrary();
            return;
        }

        public override function addChild(arg1:flash.display.DisplayObject):flash.display.DisplayObject
        {
            var loc1:*=super.addChild(arg1);
            if (!(arg1 == this._overlayCanvas) && !(arg1 == this._blackBackground) && this._overlayCanvas) 
            {
                super.addChild(this._overlayCanvas);
            }
            return loc1;
        }

        public function get currentModuleIdx():int
        {
            return this._currentModuleIdx;
        }

        public function set currentModuleIdx(arg1:int):void
        {
            var loc1:*=0;
            var loc5:*=null;
            trace("SAVESYSTEM currentModuleIdx " + this.currentModuleIdx + " new " + arg1 + " " + this.menuName);
            if (this._modules.length < 1) 
            {
                return;
            }
            this.actualModules.length = 0;
            loc1 = 0;
            while (loc1 < this._modules.length) 
            {
                if ((loc5 = this._modules[loc1]).enabled && loc5.hasSelectableItems()) 
                {
                    this.actualModules.push(loc5);
                }
                ++loc1;
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
            var loc2:*=-1;
            var loc3:*=arg1;
            loc1 = 0;
            while (loc1 < this.actualModules.length) 
            {
                if (this.actualModules[loc1] == this._currentModule) 
                {
                    loc2 = loc1;
                }
                ++loc1;
            }
            if (!(loc2 == this._currentModuleIdx) && !(loc2 == -1)) 
            {
                if (arg1 < this._currentModuleIdx) 
                {
                    --loc3;
                }
                else if (arg1 > this._currentModuleIdx) 
                {
                    loc3 = loc2 + 1;
                }
            }
            loc3 = Math.max(0, Math.min((this.actualModules.length - 1), loc3));
            var loc4:*;
            if (!((loc4 = this.actualModules[loc3]) == null) && !(loc4 == this._currentModule)) 
            {
                if (this._currentModule != null) 
                {
                    this._currentModule.focused = 0;
                }
                if (loc4 != null) 
                {
                    loc4.focused = 1;
                }
                this._currentModule = loc4;
                this._currentModuleIdx = loc3;
                trace("SAVESYSTEM currentModuleIdx OnModuleSelected " + this.currentModuleIdx + " " + this.menuName);
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnModuleSelected", [this._currentModuleIdx, loc4.dataBindingKey]));
            }
            return;
        }

        public function getMenuName():String
        {
            return this.menuName;
        }

        protected override function configUI():void
        {
            trace("GFX CONFIG UI [", this.menuName, "] ");
            if (this.mcBackground) 
            {
                if (this.mcBackground.mcIcon) 
                {
                    this.mcBackground.mcIcon.gotoAndStop(this.menuName);
                }
            }
            super.configUI();
            this.ShowSecondaryModules(false);
            this._overlayCanvas = new flash.display.MovieClip();
            var loc1:*;
            this._overlayCanvas.mouseEnabled = loc1 = false;
            this._overlayCanvas.mouseChildren = loc1;
            this.addChild(this._overlayCanvas);
            this._contextMgr.init(this._overlayCanvas, _inputMgr);
            this.initDragSurface();
            if (this._enableMouse) 
            {
                this._mouseCursor = new red.game.witcher3.controls.MouseCursor(this._overlayCanvas);
            }
            tabEnabled = false;
            tabChildren = false;
            if (scaleform.gfx.Extensions.isScaleform) 
            {
                flash.ui.Mouse.hide();
            }
            stage.addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInputNavigate, false, -10, true);
            stage.addEventListener(CURRENT_MODULE_INVALIDATE, this.handleInitialDataSet, false, 0, true);
            _inputMgr.addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            addEventListener(flash.events.Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
            if (!this._disableShowAnimation) 
            {
                this.showAnimation();
            }
            return;
        }

        public function ShowSecondaryModules(arg1:Boolean):*
        {
            if (this.mcBackground) 
            {
                if (this.mcBackground.mcIcon) 
                {
                    this.mcBackground.mcIcon.visible = !arg1;
                }
            }
            return;
        }

        protected function handleEnterFrame(arg1:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, this.handleEnterFrame);
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnMenuShown"));
            return;
        }

        protected function showAnimation():void
        {
            trace("HUD " + this.menuName + " showAnimation");
            visible = true;
            y = SHOW_ANIM_OFFSET;
            alpha = 0;
            com.gskinner.motion.GTweener.to(this, SHOW_ANIM_DURATION, {"y":0, "alpha":1}, {"ease":com.gskinner.motion.easing.Exponential.easeOut, "onComplete":this.handleShowAnimComplete});
            return;
        }

        protected function hideAnimation():void
        {
            if (!this.closingMenu) 
            {
                com.gskinner.motion.GTweener.removeTweens(this);
                com.gskinner.motion.GTweener.to(this, 0.3, {"y":200, "alpha":0}, {"ease":com.gskinner.motion.easing.Exponential.easeOut, "onComplete":this.handleHideAnimComplete});
                this.closingMenu = true;
            }
            return;
        }

        protected function handleHideAnimComplete(arg1:com.gskinner.motion.GTween):void
        {
            this.closeMenu();
            this.closingMenu = false;
            return;
        }

        public static const CURRENT_MODULE_INVALIDATE:String="Core.Menu.Current.Module.Invalidate";

        protected var _modules:__AS3__.vec.Vector.<red.core.CoreMenuModule>;

        protected var _mouseCursor:red.game.witcher3.controls.MouseCursor;

        protected var _dragCanvas:flash.display.Sprite;

        protected var _dragManager:red.game.witcher3.slots.SlotsTransferManager;

        protected var _disableShowAnimation:Boolean;

        protected var _enableMouse:Boolean;

        protected var _contextMgr:red.game.witcher3.managers.ContextInfoManager;

        protected var _assetsMgr:red.game.witcher3.managers.RuntimeAssetsManager;

        protected var _currentModuleIdx:int;

        internal var _currentModule:red.core.CoreMenuModule=null;

        protected var upToCloseEnabled:Boolean=false;

        protected var closingMenu:Boolean=false;

        protected var _currentMenuState:String;

        protected var _restrictDirectClosing:Boolean;

        protected var actualModules:__AS3__.vec.Vector.<red.core.CoreMenuModule>;

        public var mcBackground:flash.display.MovieClip;

        protected var _inCombat:Boolean=false;

        internal var _moduleChangeInputFeedback:int=-1;

        internal var _initialPanelXOffset:int=0;

        internal var _blackBackground:flash.display.Sprite;

        protected static var SHOW_ANIM_DURATION:Number=0.8;

        protected static var SHOW_ANIM_OFFSET:Number=500;

        protected var _overlayCanvas:flash.display.MovieClip;
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


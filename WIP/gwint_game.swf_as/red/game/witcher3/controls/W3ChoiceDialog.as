package red.game.witcher3.controls 
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.menus.gwint.*;
    import red.game.witcher3.slots.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;
    
    public class W3ChoiceDialog extends scaleform.clik.core.UIComponent
    {
        public function W3ChoiceDialog()
        {
            super();
            return;
        }

        private function handleDialogShown(arg1:com.gskinner.motion.GTween):void
        {
            return;
        }

        private function handleDialogHidden(arg1:com.gskinner.motion.GTween):void
        {
            var loc1:*;
            this.visible = loc1 = false;
            enabled = loc1;
            return;
        }

        public function isShown():Boolean
        {
            return this._shown;
        }

        private function handleInputCustom(arg1:scaleform.clik.events.InputEvent):void
        {
            if (!this._inputEnabled) 
            {
                return;
            }
            super.handleInput(arg1);
            if (arg1.handled || !this._shown) 
            {
                return;
            }
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
            if (loc2) 
            {
                var loc3:*=loc1.navEquivalent;
                switch (loc3) 
                {
                    case scaleform.clik.constants.NavigationCode.GAMEPAD_A:
                    {
                        this.applyChoice();
                        arg1.handled = true;
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.GAMEPAD_B:
                    {
                        this.cancelChoice();
                        arg1.handled = true;
                        break;
                    }
                }
            }
            return;
        }

        private function applyChoice():void
        {
            var loc1:*=null;
            if (this._shown && !(this._acceptCallback == null)) 
            {
                this.cardsCarousel.validateNow();
                loc1 = this.cardsCarousel.getRendererAt(this.cardsCarousel.selectedIndex) as red.game.witcher3.menus.gwint.CardSlot;
                if (loc1 && loc1.activateEnabled) 
                {
                    if (loc1.instanceId == -1) 
                    {
                        this._acceptCallback(loc1.cardIndex);
                    }
                    else 
                    {
                        this._acceptCallback(loc1.instanceId);
                    }
                }
            }
            return;
        }

        private function cancelChoice():void
        {
            if (this._declineCallback != null) 
            {
                this._declineCallback();
            }
            return;
        }

        protected function onCarouselSelectionChanged(arg1:scaleform.clik.events.ListEvent):void
        {
            var loc1:*=this.cardsCarousel.getRendererAt(arg1.index) as red.game.witcher3.menus.gwint.CardSlot;
            this.updateTooltip(loc1);
            this.updateInputFeedback();
            return;
        }

        protected function updateInputFeedback():void
        {
            var loc1:*=!(this._acceptCallback == null);
            var loc2:*=this.cardsCarousel.getSelectedRenderer() as red.game.witcher3.menus.gwint.CardSlot;
            if (loc2 && loc1 && !loc2.activateEnabled) 
            {
                loc1 = false;
            }
            if (loc1) 
            {
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.apply, scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.ENTER, "panel_button_common_select");
            }
            else 
            {
                red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.apply);
            }
            if (this._declineCallback == null) 
            {
                red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.cancel);
            }
            else 
            {
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.cancel, scaleform.clik.constants.NavigationCode.GAMEPAD_B, red.core.constants.KeyCode.ESCAPE, "panel_common_cancel");
            }
            return;
        }

        protected function updateTooltip(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=null;
            if (arg1) 
            {
                loc2 = loc1.getCardTemplate(arg1.cardIndex);
            }
            else if (this.cardsCarousel.data.length > 0) 
            {
                if (this.cardsCarousel.data[0] is red.game.witcher3.menus.gwint.CardInstance) 
                {
                    loc2 = (this.cardsCarousel.data[0] as red.game.witcher3.menus.gwint.CardInstance).templateRef;
                }
                else if (this.cardsCarousel.data[0] is int) 
                {
                    loc2 = loc1.getCardTemplate(this.cardsCarousel.data[0]);
                }
            }
            if (loc2) 
            {
                if (this.mcTooltip && loc1) 
                {
                    loc3 = loc2.tooltipString;
                    loc4 = this.mcTooltip.getChildByName("txtTooltipTitle") as flash.text.TextField;
                    loc5 = this.mcTooltip.getChildByName("txtTooltip") as flash.text.TextField;
                    if (loc3 == "" || !loc4 || !loc5) 
                    {
                        this.mcTooltip.visible = false;
                    }
                    else 
                    {
                        this.mcTooltip.visible = true;
                        if (loc2.index >= 1000) 
                        {
                            loc4.text = "[[gwint_leader_ability]]";
                        }
                        else 
                        {
                            loc4.text = "[[" + loc3 + "_title]]";
                        }
                        loc5.text = "[[" + loc3 + "]]";
                        loc6 = this.mcTooltip.getChildByName("mcTooltipIcon") as flash.display.MovieClip;
                        if (loc6) 
                        {
                            loc6.gotoAndStop(loc2.tooltipIcon);
                        }
                    }
                }
            }
            else 
            {
                this.mcTooltip.visible = false;
            }
            return;
        }

        protected function handleStageClick(arg1:flash.events.MouseEvent):void
        {
            if (!this._shown) 
            {
                return;
            }
            var loc1:*=arg1 as scaleform.gfx.MouseEventEx;
            if (loc1.buttonIdx == scaleform.gfx.MouseEventEx.RIGHT_BUTTON && !red.game.witcher3.menus.gwint.GwintTutorial.mSingleton.active) 
            {
                if (this.ignoreNextRightClick) 
                {
                    this.ignoreNextRightClick = false;
                }
                else 
                {
                    this.cancelChoice();
                }
            }
            return;
        }

        public function OnMouseWheel(arg1:flash.events.MouseEvent):*
        {
            if (!this._shown) 
            {
                return;
            }
            if (arg1.delta > 0) 
            {
                this.cardsCarousel.navigateLeft();
            }
            else 
            {
                this.cardsCarousel.navigateRight();
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            this.txtCarouselMessage.text = "";
            scaleform.clik.managers.InputDelegate.getInstance().addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInputCustom, false, 0, true);
            this.cardsCarousel.addEventListener(scaleform.clik.events.ListEvent.INDEX_CHANGE, this.onCarouselSelectionChanged, false, 0, true);
            stage.addEventListener(flash.events.MouseEvent.CLICK, this.handleStageClick, false, 1, true);
            stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.OnMouseWheel, false, 0, true);
            this.cardsCarousel.addEventListener(red.game.witcher3.menus.gwint.CardSlot.CardMouseDoubleClick, this.OnCardMouseDoubleClick, false, 0, true);
            return;
        }

        public function showDialogCardInstances(arg1:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>, arg2:Function, arg3:Function, arg4:String):void
        {
            var loc2:*=0;
            var loc1:*=new Array();
            loc2 = 0;
            while (loc2 < arg1.length) 
            {
                loc1.push(arg1[loc2]);
                ++loc2;
            }
            this.showDialog(loc1, arg2, arg3, arg4);
            return;
        }

        public function showDialogCardTemplates(arg1:__AS3__.vec.Vector.<int>, arg2:Function, arg3:Function, arg4:String):void
        {
            var loc2:*=0;
            var loc1:*=new Array();
            loc2 = 0;
            while (loc2 < arg1.length) 
            {
                loc1.push(arg1[loc2]);
                ++loc2;
            }
            this.showDialog(loc1, arg2, arg3, arg4);
            return;
        }

        public function showDialog(arg1:Array, arg2:Function, arg3:Function, arg4:String):void
        {
            if (!this._shown) 
            {
                this._shown = true;
                var loc1:*;
                this.visible = loc1 = true;
                enabled = loc1;
            }
            this._acceptCallback = arg2;
            this._declineCallback = arg3;
            this._sourceList = arg1;
            this.cardsCarousel.data = this._sourceList;
            this.cardsCarousel.focused = 1;
            this.cardsCarousel.validateNow();
            if (this.cardsCarousel.selectedIndex != -1) 
            {
                if (this.cardsCarousel.selectedIndex > arg1.length) 
                {
                    this.cardsCarousel.selectedIndex = (arg1.length - 1);
                }
            }
            else 
            {
                this.cardsCarousel.selectedIndex = 0;
            }
            this.cardsCarousel.validateNow();
            this.updateTooltip(this.cardsCarousel.getSelectedRenderer() as red.game.witcher3.menus.gwint.CardSlot);
            this.updateDialogText(arg4);
            this.updateInputFeedback();
            this.inputEnabled = true;
            return;
        }

        public function OnCardMouseDoubleClick(arg1:flash.events.Event):*
        {
            this.applyChoice();
            return;
        }

        public function set inputEnabled(arg1:Boolean):void
        {
            this._inputEnabled = arg1;
            this.cardsCarousel.inputEnabled = arg1;
            return;
        }

        public function updateDialogText(arg1:String):void
        {
            if (this.txtCarouselMessage) 
            {
                this.txtCarouselMessage.text = arg1;
            }
            if (this.txtCarouselMessage.text != "") 
            {
                this.mcCarouselMsgBackground.visible = true;
            }
            else 
            {
                this.mcCarouselMsgBackground.visible = false;
            }
            return;
        }

        public function appendDialogText(arg1:String):void
        {
            if (this.txtCarouselMessage) 
            {
                this.txtCarouselMessage.appendText(arg1);
            }
            if (this.txtCarouselMessage.text != "") 
            {
                this.mcCarouselMsgBackground.visible = true;
            }
            else 
            {
                this.mcCarouselMsgBackground.visible = false;
            }
            return;
        }

        public function hideDialog():void
        {
            if (this._shown) 
            {
                this._shown = false;
                this.cardsCarousel.focused = 0;
                var loc1:*;
                this.visible = loc1 = false;
                enabled = loc1;
                this.txtCarouselMessage.text = "";
            }
            red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.apply);
            red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.cancel);
            return;
        }

        public override function set visible(arg1:Boolean):void
        {
            super.visible = arg1;
            mouseEnabled = arg1;
            mouseChildren = arg1;
            return;
        }

        public function replaceCard(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance):void
        {
            this.cardsCarousel.replaceItem(arg1, arg2);
            this.updateTooltip(this.cardsCarousel.getSelectedRenderer() as red.game.witcher3.menus.gwint.CardSlot);
            return;
        }

        public var txtCarouselMessage:flash.text.TextField;

        public var mcCarouselMsgBackground:flash.display.MovieClip;

        public var cardsCarousel:red.game.witcher3.slots.SlotsListCarousel;

        public var mcTooltip:flash.display.MovieClip;

        public var mcBackground:flash.display.Sprite;

        private var _choices:Array;

        private var _sourceList:Array;

        private var _acceptCallback:Function;

        private var _declineCallback:Function;

        private var _shown:Boolean;

        public var ignoreNextRightClick:Boolean=false;

        protected var _inputEnabled:Boolean=true;
    }
}

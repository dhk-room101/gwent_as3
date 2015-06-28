///SlotSkillGrid
package red.game.witcher3.slots 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.events.*;
    
    public class SlotSkillGrid extends red.game.witcher3.slots.SlotPaperdoll implements red.game.witcher3.interfaces.IInventorySlot
    {
        public function SlotSkillGrid()
        {
            super();
            _isLocked = false;
            if (iconLock) 
            {
                iconLock.visible = false;
            }
            if (this.equipedIcon) 
            {
                this.equipedIcon.visible = false;
            }
            return;
        }

        public override function get isLocked():Boolean
        {
            return _isLocked;
        }

        protected override function updateData():*
        {
            super.updateData();
            if (!_data) 
            {
                return;
            }
            if (_data.color && this.slotBackground && _data.level > 0 && !_data.isCoreSkill) 
            {
                this.slotBackground.gotoAndStop(_data.color);
            }
            else 
            {
                this.slotBackground.gotoAndStop("SC_None");
            }
            if (_data.maxLevel && _data.maxLevel > 0 && !_data.isCoreSkill && _data.hasRequiredPointsSpent) 
            {
                this.txtLevel.text = _data.level + "/" + _data.maxLevel;
                this.txtLevel.visible = true;
            }
            else 
            {
                this.txtLevel.visible = false;
            }
            this.applyAvailability();
            return;
        }

        protected override function handleIconLoaded(arg1:flash.events.Event):void
        {
            super.handleIconLoaded(arg1);
            if (this.txtLevel) 
            {
                addChild(this.txtLevel);
                addChild(iconLock);
            }
            return;
        }

        protected function applyAvailability():void
        {
            this.filters = [];
            if (this.equipedIcon) 
            {
                if (_data.isCoreSkill) 
                {
                    this.equipedIcon.visible = false;
                }
                else 
                {
                    this.equipedIcon.visible = _data.isEquipped;
                }
            }
            this.alpha = 1;
            if (_data.level < 1 && !_data.hasRequiredPointsSpent) 
            {
                darkenIcon(0.2);
                _isLocked = true;
            }
            else 
            {
                _isLocked = false;
            }
            iconLock.visible = _isLocked;
            return;
        }

        protected override function setBackgroundColor():void
        {
            mcColorBackground.setBySkillType(_data.color);
            return;
        }

        protected override function fireTooltipShowEvent(arg1:Boolean=false):void
        {
            var loc2:*=null;
            var loc1:*=activeSelectionEnabled || !red.game.witcher3.managers.InputManager.getInstance().isGamepad();
            if (_data && loc1 && isParentEnabled()) 
            {
                loc2 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, true, false, index, -1, -1, null, _data as Object);
                loc2.tooltipContentRef = "SkillTooltipRef";
                loc2.tooltipMouseContentRef = "SkillTooltipRef";
                loc2.tooltipDataSource = "OnGetSkillTooltipData";
                loc2.isMouseTooltip = arg1;
                if (arg1) 
                {
                    loc2.anchorRect = getGlobalSlotRect();
                }
                _tooltipRequested = true;
                dispatchEvent(loc2);
            }
            return;
        }

        protected override function fireTooltipHideEvent(arg1:Boolean=false):void
        {
            var loc1:*=null;
            if (_tooltipRequested) 
            {
                loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.HIDE_TOOLTIP, true, false, index, -1, -1, null, _data as Object);
                dispatchEvent(loc1);
                _tooltipRequested = false;
            }
            return;
        }

        public override function canDrag():Boolean
        {
            return _data && !this.isLocked && _data.level > 0 && !data.isCoreSkill;
        }

        protected override function executeDefaultAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):void
        {
            trace("GFX <SlotSkillGrid> executeDefaultAction  ", canExecuteAction());
            if (arg1 != red.core.constants.KeyCode.PAD_A_CROSS) 
            {
                if (arg1 != red.core.constants.KeyCode.PAD_Y_TRIANGLE) 
                {
                    if (arg1 == red.core.constants.KeyCode.PAD_X_SQUARE) 
                    {
                        fireActionEvent(red.game.witcher3.constants.InventoryActionType.SUB_ACTION, red.game.witcher3.events.SlotActionEvent.EVENT_SECONDARY_ACTION);
                    }
                }
                else 
                {
                    if (!(_data.slotType == red.game.witcher3.constants.InventorySlotType.Potion1) && !(_data.slotType == red.game.witcher3.constants.InventorySlotType.Potion2) && !(_data.slotType == red.game.witcher3.constants.InventorySlotType.Petard1) && !(_data.slotType == red.game.witcher3.constants.InventorySlotType.Petard2) && !(_data.slotType == red.game.witcher3.constants.InventorySlotType.Quickslot1) && !(_data.slotType == red.game.witcher3.constants.InventorySlotType.Quickslot2)) 
                    {
                        defaultSlotDropAction(_data);
                    }
                    fireActionEvent(red.game.witcher3.constants.InventoryActionType.DROP);
                }
            }
            else 
            {
                if (arg2) 
                {
                    arg2.handled = true;
                }
                fireActionEvent(_data.actionType);
            }
            return;
        }

        public override function executeAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):Boolean
        {
            if (canExecuteAction()) 
            {
                this.executeDefaultAction(arg1, arg2);
                return true;
            }
            return false;
        }

        public var slotBackground:flash.display.MovieClip;

        public var txtLevel:flash.text.TextField;

        public var equipedIcon:flash.display.Sprite;
    }
}



///SlotSkillMutagen
package red.game.witcher3.slots 
{
    import flash.display.*;
    import red.core.constants.*;
    import red.core.events.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.interfaces.*;
    import scaleform.clik.events.*;
    
    public class SlotSkillMutagen extends red.game.witcher3.slots.SlotBase implements red.game.witcher3.interfaces.IDropTarget
    {
        public function SlotSkillMutagen()
        {
            super();
            this.iconLock.visible = false;
            return;
        }

        public function get slotType():int
        {
            return this._slotType;
        }

        public function set slotType(arg1:int):void
        {
            this._slotType = arg1;
            return;
        }

        public function isLocked():Boolean
        {
            return this._locked;
        }

        public function isMutEquiped():Boolean
        {
            return _data && _data.id;
        }

        protected override function canExecuteAction():Boolean
        {
            return true;
        }

        protected override function configUI():void
        {
            super.configUI();
            red.game.witcher3.slots.SlotsTransferManager.getInstance().addDropTarget(this);
            return;
        }

        protected override function updateData():*
        {
            if (_data) 
            {
                this._locked = !_data.unlocked;
                this.iconLock.visible = this._locked;
                if (_data.iconPath && !(_loadedImagePath == _data.iconPath)) 
                {
                    _loadedImagePath = _data.iconPath;
                    loadIcon(_loadedImagePath);
                }
                this.background.gotoAndStop(_data.color);
            }
            return;
        }

        protected override function executeDefaultAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):void
        {
            if (arg1 == red.core.constants.KeyCode.PAD_A_CROSS) 
            {
                fireActionEvent(red.game.witcher3.constants.InventoryActionType.EQUIP, red.game.witcher3.events.SlotActionEvent.EVENT_ACTIVATE);
            }
            if (arg1 == red.core.constants.KeyCode.PAD_X_SQUARE) 
            {
                fireActionEvent(red.game.witcher3.constants.InventoryActionType.SUB_ACTION, red.game.witcher3.events.SlotActionEvent.EVENT_SECONDARY_ACTION);
            }
            return;
        }

        public override function set enabled(arg1:Boolean):void
        {
            super.enabled = arg1;
            alpha = enabled ? 1 : DISABLED_ALPHA;
            return;
        }

        protected override function fireTooltipShowEvent(arg1:Boolean=false):void
        {
            var loc1:*=null;
            if (!!arg1 && owner && !owner.focused) 
            {
                return;
            }
            if (this.isMutEquiped()) 
            {
                super.fireTooltipShowEvent(arg1);
            }
            else if (data && activeSelectionEnabled) 
            {
                loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, true, false, index, -1, -1, null, _data as Object);
                loc1.tooltipContentRef = "SkillTooltipRef";
                loc1.tooltipMouseContentRef = "SkillTooltipRef";
                loc1.tooltipCustomArgs = [_data.unlockedAtLevel];
                loc1.isMouseTooltip = arg1;
                if (arg1) 
                {
                    loc1.anchorRect = getGlobalSlotRect();
                }
                if (_data.unlocked) 
                {
                    loc1.tooltipDataSource = "OnGetMutagenEmptyTooltipData";
                }
                else 
                {
                    loc1.tooltipDataSource = "OnGetMutagenLockedTooltipData";
                }
                _tooltipRequested = true;
                dispatchEvent(loc1);
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
            return false;
        }

        public function get dropSelection():Boolean
        {
            return _dropSelection;
        }

        public function set dropSelection(arg1:Boolean):void
        {
            _dropSelection = arg1;
            invalidateState();
            return;
        }

        public function processOver(arg1:red.game.witcher3.slots.SlotDragAvatar):void
        {
            return;
        }

        public function canDrop(arg1:red.game.witcher3.interfaces.IDragTarget):Boolean
        {
            return !(arg1 is red.game.witcher3.slots.SlotPaperdoll) && !this._locked;
        }

        public function applyDrop(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            var loc1:*=null;
            if (_data) 
            {
                loc1 = arg1.getDragData() as Object;
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnEquipMutagen", [loc1.id, this.slotType]));
            }
            return;
        }

        protected static const DISABLED_ALPHA:Number=0.4;

        public var iconLock:flash.display.Sprite;

        public var background:flash.display.MovieClip;

        protected var _slotType:int;

        protected var _locked:Boolean;
    }
}



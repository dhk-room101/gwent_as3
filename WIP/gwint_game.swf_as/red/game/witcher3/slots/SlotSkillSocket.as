///SlotSkillSocket
package red.game.witcher3.slots 
{
    import flash.events.*;
    import red.core.events.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.menus.character_menu.*;
    
    public class SlotSkillSocket extends red.game.witcher3.slots.SlotSkillGrid implements red.game.witcher3.interfaces.IDropTarget
    {
        public function SlotSkillSocket()
        {
            super();
            return;
        }

        public function get connector():String
        {
            return this._connector;
        }

        public function set connector(arg1:String):void
        {
            this._connector = arg1;
            return;
        }

        public function get slotId():int
        {
            return this._slotId;
        }

        public function set slotId(arg1:int):void
        {
            this._slotId = arg1;
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            red.game.witcher3.slots.SlotsTransferManager.getInstance().addDropTarget(this);
            return;
        }

        protected override function loadIcon(arg1:String):void
        {
            if (_data && !(_data.skillPath == NULL_SKILL)) 
            {
                super.loadIcon(arg1);
                if (_imageLoader) 
                {
                    _imageLoader.visible = true;
                }
            }
            else 
            {
                unloadIcon();
            }
            return;
        }

        protected override function applyAvailability():void
        {
            if (_data) 
            {
                _isLocked = !_data.unlocked;
                iconLock.visible = _isLocked;
                this.updateConnector(_data.color);
            }
            if (equipedIcon) 
            {
                if (_data && !_data.isCoreSkill) 
                {
                    equipedIcon.visible = _data.isEquipped;
                }
                else 
                {
                    equipedIcon.visible = false;
                }
            }
            return;
        }

        protected function updateConnector(arg1:String):void
        {
            if (this.skillSocketGroupRef != null) 
            {
                this.skillSocketGroupRef.updateData();
            }
            return;
        }

        protected override function fireTooltipShowEvent(arg1:Boolean=false):void
        {
            var loc1:*=null;
            if (_data && activeSelectionEnabled) 
            {
                loc1 = new red.game.witcher3.events.GridEvent(red.game.witcher3.events.GridEvent.DISPLAY_TOOLTIP, true, false, index, -1, -1, null, _data as Object);
                loc1.tooltipContentRef = "SkillTooltipRef";
                loc1.tooltipMouseContentRef = "SkillTooltipRef";
                loc1.isMouseTooltip = arg1;
                if (arg1) 
                {
                    loc1.anchorRect = getGlobalSlotRect();
                }
                if (_data.skillPath == NULL_SKILL) 
                {
                    if (_data.unlocked) 
                    {
                        loc1.tooltipCustomArgs = [_data.unlockedOnLevel];
                        loc1.tooltipDataSource = "OnGetEmptySlotTooltipData";
                    }
                    else 
                    {
                        loc1.tooltipCustomArgs = [_data.unlockedOnLevel];
                        loc1.tooltipDataSource = "OnGetLockedTooltipData";
                    }
                }
                else 
                {
                    loc1.tooltipDataSource = "OnGetSkillTooltipData";
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

        protected override function handleMouseDoubleClick(arg1:flash.events.MouseEvent):void
        {
            if (_data) 
            {
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnUnequipSkill", [_data.slotId]));
            }
            else 
            {
                super.handleMouseDoubleClick(arg1);
            }
            return;
        }

        public override function applyDrop(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=0;
            if (_data) 
            {
                loc1 = arg1.getDragData() as Object;
                loc2 = _data.slotId;
                loc3 = loc1.skillTypeId;
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnEquipSkill", [loc3, loc2]));
            }
            return;
        }

        public override function canDrop(arg1:red.game.witcher3.interfaces.IDragTarget):Boolean
        {
            var loc1:*=arg1.getDragData() as Object;
            return selectable && loc1.skillType && !(loc1.skillType == "S_Undefined") && !_isLocked;
        }

        public override function get dropSelection():Boolean
        {
            return _dropSelection;
        }

        public override function set dropSelection(arg1:Boolean):void
        {
            _dropSelection = arg1;
            invalidateState();
            return;
        }

        public override function processOver(arg1:red.game.witcher3.slots.SlotDragAvatar):void
        {
            return;
        }

        public static const NULL_SKILL:String="ESP_NotSet";

        protected var _slotId:int;

        protected var _connector:String;

        public var skillSocketGroupRef:red.game.witcher3.menus.character_menu.SkillSocketsGroup;
    }
}



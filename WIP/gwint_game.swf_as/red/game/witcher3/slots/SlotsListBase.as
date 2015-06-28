///SlotsListBase
package red.game.witcher3.slots 
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import red.core.constants.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.menus.common.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;
    
    public class SlotsListBase extends scaleform.clik.core.UIComponent implements red.game.witcher3.interfaces.IScrollingList
    {
        public function SlotsListBase()
        {
            super();
            this._data = [];
            this._renderers = new Vector.<red.game.witcher3.interfaces.IBaseSlot>();
            this._canvas = new flash.display.Sprite();
            addChild(this._canvas);
            focusable = true;
            this._selectedIndex = -1;
            this._renderersCount = 0;
            tabEnabled = false;
            tabChildren = false;
            return;
        }

        public override function set enabled(arg1:Boolean):void
        {
            var loc1:*=this._renderers.length;
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                this._renderers[loc2].enabled = arg1;
                ++loc2;
            }
            super.enabled = arg1;
            this.applySelectionContext();
            return;
        }

        public override function set focused(arg1:Number):void
        {
            if (arg1 == _focused || !_focusable) 
            {
                return;
            }
            _focused = arg1;
            if (scaleform.gfx.Extensions.isScaleform) 
            {
                if (_focused > 0) 
                {
                    scaleform.gfx.FocusManager.setFocus(this, 0);
                    if (this.selectedIndex > -1 && enabled) 
                    {
                        (this._renderers[this.selectedIndex] as red.game.witcher3.slots.SlotBase).showTooltip();
                    }
                }
            }
            else if (!(stage == null) && _focused > 0) 
            {
                stage.focus = this;
            }
            return;
        }

        public function NumNonEmptyRenderers():int
        {
            var loc1:*=0;
            var loc2:*=0;
            loc1 = 0;
            while (loc1 < this._renderers.length) 
            {
                if (!this._renderers[loc1].isEmpty()) 
                {
                    ++loc2;
                }
                ++loc1;
            }
            return loc2;
        }

        public function ReselectIndexIfInvalid(arg1:int=-1):void
        {
            var loc1:*=0;
            var loc2:*=null;
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=0;
            var loc6:*=NaN;
            var loc7:*=NaN;
            if (arg1 >= 0 && arg1 < this._renderers.length) 
            {
                loc4 = this._renderers[arg1] as red.game.witcher3.slots.SlotBase;
                loc3 = arg1;
            }
            else 
            {
                loc4 = this.getSelectedRenderer() as red.game.witcher3.slots.SlotBase;
                arg1 = this.selectedIndex;
                loc3 = this.selectedIndex;
            }
            if (loc4) 
            {
                if (loc4.selectable) 
                {
                    if (arg1 != -1) 
                    {
                        if ((loc4 == this._renderers[arg1] as red.game.witcher3.slots.SlotBase) && loc4.selectable) 
                        {
                            this.selectedIndex = arg1;
                            return;
                        }
                    }
                }
                else 
                {
                    loc5 = -1;
                    loc6 = Number.MAX_VALUE;
                    loc7 = Number.MAX_VALUE;
                    if (loc3 > 0) 
                    {
                        loc2 = this._renderers[(loc3 - 1)] as red.game.witcher3.slots.SlotBase;
                        if (loc2 && loc2.selectable) 
                        {
                            loc6 = Math.sqrt(Math.pow(loc2.x - loc4.x, 2) + Math.pow(loc2.y - loc4.y, 2));
                            if (loc7 > loc6 || loc6 == loc7 && loc2.y == loc4.y && loc2.x > loc4.x) 
                            {
                                loc7 = loc6;
                                --loc5;
                            }
                        }
                    }
                    if (loc3 < (this._renderers.length - 1)) 
                    {
                        loc2 = this._renderers[loc3 + 1] as red.game.witcher3.slots.SlotBase;
                        if (loc2 && loc2.selectable) 
                        {
                            loc6 = Math.sqrt(Math.pow(loc2.x - loc4.x, 2) + Math.pow(loc2.y - loc4.y, 2));
                            if (loc7 > loc6 || loc6 == loc7 && loc2.y == loc4.y && loc2.x > loc4.x) 
                            {
                                loc7 = loc6;
                                loc5 = loc3 + 1;
                            }
                        }
                    }
                    loc1 = 0;
                    while (loc1 < this._renderers.length) 
                    {
                        loc2 = this._renderers[loc1] as red.game.witcher3.slots.SlotBase;
                        if (loc2 && loc2.selectable) 
                        {
                            loc6 = Math.sqrt(Math.pow(loc2.x - loc4.x, 2) + Math.pow(loc2.y - loc4.y, 2));
                            if (loc7 > loc6 || loc6 == loc7 && loc2.y == loc4.y && loc2.x > loc4.x) 
                            {
                                loc7 = loc6;
                                loc5 = loc1;
                            }
                        }
                        ++loc1;
                    }
                    if (loc5 != -1) 
                    {
                        this.selectedIndex = loc5;
                        return;
                    }
                }
            }
            this.findSelection();
            return;
        }

        public function get selectedIndex():int
        {
            return this._selectedIndex;
        }

        public function set selectedIndex(arg1:int):void
        {
            var loc1:*=null;
            var loc2:*=null;
            trace("GFX [****", this, "***] selectedIndex ", arg1, "; ", this._renderers.length, this._data.length, "; cur ", this._selectedIndex);
            if (this._renderers.length <= 0) 
            {
                if (this._selectedIndex == -1) 
                {
                    this.applySelectionContext();
                    return;
                }
                else 
                {
                    arg1 = -1;
                }
            }
            if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length) 
            {
                trace("GFX selectable? ", this._renderers[this._selectedIndex].selectable);
            }
            if (this._selectedIndex == arg1) 
            {
                if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length && !this._renderers[this._selectedIndex].selectable && !this.ignoreSelectable) 
                {
                    loc2 = this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotBase;
                    if (loc2) 
                    {
                        loc2.showTooltip();
                    }
                }
            }
            else 
            {
                this._cachedSelection = arg1;
                if (arg1 > -1 && arg1 < this._renderers.length && !this._renderers[arg1].selectable && !this.ignoreSelectable) 
                {
                    this.applySelectionContext();
                    return;
                }
                if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length) 
                {
                    this._renderers[this._selectedIndex].selected = false;
                }
                this._selectedIndex = arg1;
                if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length) 
                {
                    loc1 = this._renderers[this._selectedIndex];
                    loc1.selected = true;
                    this.fireListEvent(this._renderers[this._selectedIndex]);
                }
                else 
                {
                    this.fireListEvent(null);
                }
            }
            this.applySelectionContext();
            return;
        }

        protected function fireListEvent(arg1:red.game.witcher3.interfaces.IBaseSlot):void
        {
            var loc1:*=new scaleform.clik.events.ListEvent(scaleform.clik.events.ListEvent.INDEX_CHANGE);
            if (arg1) 
            {
                loc1.itemRenderer = arg1;
                loc1.itemData = arg1.data as Object;
                loc1.index = arg1.index;
            }
            else 
            {
                loc1.index = -1;
            }
            dispatchEvent(loc1);
            return;
        }

        protected function getDataIndex(arg1:red.game.witcher3.menus.common.ItemDataStub):int
        {
            if (arg1) 
            {
                return this.getIdIndex(arg1.id);
            }
            return -1;
        }

        public function set slotRendererName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._slotRenderer != value) 
            {
                this._slotRenderer = value;
                try 
                {
                    this._slotRendererRef = flash.utils.getDefinitionByName(this._slotRenderer) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + _slotRenderer);
                }
            }
            return;
        }

        protected function getIdIndex(arg1:uint):int
        {
            var loc3:*=null;
            var loc1:*=this._renderers.length;
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                if (this._renderers[loc2].data is red.game.witcher3.menus.common.ItemDataStub) 
                {
                    if ((loc3 == this._renderers[loc2].data as red.game.witcher3.menus.common.ItemDataStub) && loc3.id == arg1) 
                    {
                        return loc2;
                    }
                }
                ++loc2;
            }
            return -1;
        }

        public function getRow(arg1:int):int
        {
            return -1;
        }

        public function getColumn(arg1:int):int
        {
            return -1;
        }

        public override function get scaleX():Number
        {
            return super.actualScaleX;
        }

        public function getRenderersCount():int
        {
            return this._renderersCount;
        }

        public function getRenderersLength():int
        {
            return this._renderers.length;
        }

        protected override function configUI():void
        {
            super.configUI();
            addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInput, false, 0, true);
            return;
        }

        public function get slotRendererName():String
        {
            return this._slotRenderer;
        }

        public override function get scaleY():Number
        {
            return super.actualScaleY;
        }

        public function get data():Array
        {
            return this._data;
        }

        public function set data(arg1:Array):void
        {
            this._data = arg1;
            invalidateData();
            return;
        }

        public function stableDataUpdate(arg1:Array):void
        {
            return;
        }

        public function get numColumns():uint
        {
            return 0;
        }

        public function get numRows():uint
        {
            return Math.ceil(this._renderers.length / this.numColumns);
        }

        public function get rendererHeight():Number
        {
            if (this._renderers.length > 0) 
            {
                return this._renderers[0].height;
            }
            return 0;
        }

        public function get selectedColumn():int
        {
            if (this.selectedIndex >= 0 && this.numColumns > 0) 
            {
                return this.selectedIndex % this.numColumns;
            }
            return -1;
        }

        public function updateItemData(arg1:Object):void
        {
            return;
        }

        public function removeItem(arg1:uint, arg2:Boolean=false):void
        {
            return;
        }

        public function updateItems(arg1:Array):void
        {
            return;
        }

        public function findSelection():void
        {
            var loc3:*=0;
            var loc4:*=0;
            var loc1:*=this._cachedSelection ? this._cachedSelection : this.selectedIndex;
            var loc2:*=this.getRendererAt(loc1) as red.game.witcher3.interfaces.IBaseSlot;
            if (!loc2 || loc2 && !loc2.selectable) 
            {
                loc1 = -1;
                loc3 = this._renderers.length;
                loc4 = 0;
                while (loc4 < loc3) 
                {
                    if (this._renderers[loc4].selectable) 
                    {
                        loc1 = loc4;
                        break;
                    }
                    ++loc4;
                }
            }
            else 
            {
                loc1 = loc2.index;
            }
            this.selectedIndex = loc1;
            return;
        }

        public function GetDropdownListHeight():Number
        {
            return 0;
        }

        public function getSelectedRenderer():scaleform.clik.interfaces.IListItemRenderer
        {
            if (this._selectedIndex < 0 || this._selectedIndex >= this._renderers.length) 
            {
                return null;
            }
            return this._renderers[this._selectedIndex] as scaleform.clik.interfaces.IListItemRenderer;
        }

        public function getRendererAt(arg1:uint, arg2:int=0):scaleform.clik.interfaces.IListItemRenderer
        {
            if (arg1 < 0 || arg1 >= this._renderers.length) 
            {
                return null;
            }
            return this._renderers[arg1];
        }

        protected override function draw():void
        {
            if (isInvalid(scaleform.clik.constants.InvalidationType.DATA)) 
            {
                this.populateData();
            }
            return;
        }

        protected function populateData():void
        {
            return;
        }

        public override function toString():String
        {
            return "[SlotListBase " + name + "]";
        }

        public function get activeSelectionVisible():Boolean
        {
            return this._activeSelectionVisible;
        }

        public function set activeSelectionVisible(arg1:Boolean):void
        {
            if (this._activeSelectionVisible != arg1) 
            {
                this._activeSelectionVisible = arg1;
                this.updateActiveSelectionVisible();
                this.applySelectionContext();
            }
            return;
        }

        public function updateActiveSelectionVisible():void
        {
            var loc1:*=0;
            var loc2:*=null;
            loc1 = 0;
            while (loc1 < this._renderers.length) 
            {
                loc2 = this._renderers[loc1] as red.game.witcher3.slots.SlotBase;
                if (loc2) 
                {
                    loc2.activeSelectionEnabled = this._activeSelectionVisible;
                }
                ++loc1;
            }
            return;
        }

        public function handleInputPreset(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc4:*=null;
            var loc5:*=undefined;
            var loc6:*=null;
            if (arg1.handled) 
            {
                return;
            }
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN || loc1.value == scaleform.clik.constants.InputValue.KEY_HOLD;
            var loc3:*=loc1.fromJoystick || this.allowSimpleNavDPad ? loc1.navEquivalent : scaleform.clik.constants.NavigationCode.INVALID;
            if (loc2) 
            {
                var loc7:*=loc3;
                switch (loc7) 
                {
                    case scaleform.clik.constants.NavigationCode.UP:
                    case scaleform.clik.constants.NavigationCode.DOWN:
                    case scaleform.clik.constants.NavigationCode.LEFT:
                    case scaleform.clik.constants.NavigationCode.RIGHT:
                    {
                        if (loc4 == this.getSelectedRenderer() as red.game.witcher3.slots.SlotBase) 
                        {
                            if ((loc5 = loc4.GetNavigationIndex(loc3)) != -1) 
                            {
                                loc6 = this.getRendererAt(loc5) as red.game.witcher3.slots.SlotBase;
                                trace("GFX - targetSlot: " + loc6 + ", isSelectable: " + loc6.selectable);
                                if (loc6.selectable || this.ignoreSelectable) 
                                {
                                    this.selectedIndex = loc5;
                                    arg1.handled = true;
                                }
                                else if ((loc5 = this.SearchForNearestSelectableIndexInDirection(loc3)) != -1) 
                                {
                                    this.selectedIndex = loc5;
                                    arg1.handled = true;
                                }
                            }
                        }
                        break;
                    }
                }
            }
            return;
        }

        public function SearchForNearestSelectableIndexInDirection(arg1:String):int
        {
            var loc6:*=null;
            var loc7:*=0;
            var loc1:*=-1;
            var loc2:*=-1;
            var loc3:*=-1;
            var loc4:*=-1;
            trace("GFX - Searching for nearest Selectable index with direction:" + arg1);
            var loc5:*;
            if (!(loc5 == this.getSelectedRenderer() as red.game.witcher3.slots.SlotBase)) 
            {
                return -1;
            }
            var loc12:*=arg1;
            switch (loc12) 
            {
                case scaleform.clik.constants.NavigationCode.UP:
                {
                    loc4 = loc5.y;
                    break;
                }
                case scaleform.clik.constants.NavigationCode.DOWN:
                {
                    loc3 = loc5.y;
                    break;
                }
                case scaleform.clik.constants.NavigationCode.LEFT:
                {
                    loc2 = loc5.x;
                    break;
                }
                case scaleform.clik.constants.NavigationCode.RIGHT:
                {
                    loc1 = loc5.x;
                    break;
                }
            }
            var loc8:*=0;
            var loc9:*=Number.MAX_VALUE;
            var loc10:*=null;
            var loc11:*=false;
            if (loc5.data && loc5.data.hasOwnProperty("gridSize")) 
            {
                loc11 = loc5.data.gridSize < 2;
            }
            loc7 = 0;
            while (loc7 < this._renderers.length) 
            {
                if (!((loc6 = this._renderers[loc7] as red.game.witcher3.slots.SlotBase) == loc5) && (loc6.selectable || this.ignoreSelectable) && (loc4 == -1 || loc6.y < loc4) && (loc3 == -1 || loc6.y > loc3 || loc6.y == loc3 && loc11 && loc6.data.gridSize > 1) && (loc2 == -1 || loc6.x < loc2) && (loc1 == -1 || loc6.x > loc1)) 
                {
                    if ((loc8 = Math.sqrt(Math.pow(loc5.x - loc6.x, 2) + Math.pow(loc5.y - loc6.y, 2))) < loc9) 
                    {
                        loc9 = loc8;
                        loc10 = loc6;
                    }
                }
                ++loc7;
            }
            if (loc10 != null) 
            {
                return this._renderers.indexOf(loc10);
            }
            return -1;
        }

        public function handleInputNavSimple(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc10:*=null;
            if (arg1.handled) 
            {
                return;
            }
            var loc1:*=arg1.details;
            if (loc1.code == red.core.constants.KeyCode.PAD_LEFT_STICK_AXIS) 
            {
                this._lastLeftAxisX = loc1.value.xvalue;
                this._lastLeftAxisY = loc1.value.yvalue;
                return;
            }
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN || loc1.value == scaleform.clik.constants.InputValue.KEY_HOLD;
            var loc3:*=loc1.fromJoystick || this.allowSimpleNavDPad ? loc1.navEquivalent : scaleform.clik.constants.NavigationCode.INVALID;
            if (!this.allowSimpleNavDPad) 
            {
                var loc11:*=loc1.code;
                switch (loc11) 
                {
                    case red.core.constants.KeyCode.UP:
                    {
                        loc3 = scaleform.clik.constants.NavigationCode.UP;
                        break;
                    }
                    case red.core.constants.KeyCode.DOWN:
                    {
                        loc3 = scaleform.clik.constants.NavigationCode.DOWN;
                        break;
                    }
                    case red.core.constants.KeyCode.LEFT:
                    {
                        loc3 = scaleform.clik.constants.NavigationCode.LEFT;
                        break;
                    }
                    case red.core.constants.KeyCode.RIGHT:
                    {
                        loc3 = scaleform.clik.constants.NavigationCode.RIGHT;
                        break;
                    }
                }
            }
            var loc4:*=this._selectedIndex != -1 ? Math.floor(this._selectedIndex / this.numColumns) : -1;
            var loc5:*=this._selectedIndex != -1 ? this._selectedIndex - loc4 * this.numColumns : -1;
            var loc6:*=0;
            var loc7:*=0;
            var loc8:*=-1;
            var loc9:*=1;
            if (loc2) 
            {
                loc11 = loc3;
                switch (loc11) 
                {
                    case scaleform.clik.constants.NavigationCode.UP:
                    {
                        if (this._selectedIndex != -1) 
                        {
                            --loc6;
                            while (loc6 >= 0) 
                            {
                                if (this.searchUpDown(loc6, loc5, loc4, loc9)) 
                                {
                                    arg1.handled = true;
                                    break;
                                }
                                ++loc9;
                                --loc6;
                            }
                            if (!arg1.handled) 
                            {
                                if (!((loc8 = this.SearchForNearestSelectableIndexInDirection(loc3)) == -1) && this.selectRendererAtIndexIfValid(loc8)) 
                                {
                                    arg1.handled = true;
                                }
                            }
                        }
                        else 
                        {
                            this.findSelection();
                        }
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.DOWN:
                    {
                        if (this._selectedIndex != -1) 
                        {
                            if (this._renderers[this._selectedIndex] is red.game.witcher3.slots.SlotInventoryGrid && (this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotInventoryGrid).data.gridSize > 1) 
                            {
                                loc4 = loc4 + 1;
                            }
                            loc6 = loc4 + 1;
                            while (loc6 < this.numRows) 
                            {
                                if (this.searchUpDown(loc6, loc5, loc4, loc9)) 
                                {
                                    arg1.handled = true;
                                    break;
                                }
                                ++loc9;
                                ++loc6;
                            }
                            if (!arg1.handled) 
                            {
                                if (!((loc8 = this.SearchForNearestSelectableIndexInDirection(loc3)) == -1) && this.selectRendererAtIndexIfValid(loc8)) 
                                {
                                    arg1.handled = true;
                                }
                            }
                        }
                        else 
                        {
                            this.findSelection();
                        }
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.LEFT:
                    {
                        if (this._selectedIndex != -1) 
                        {
                            --loc7;
                            while (loc7 >= 0) 
                            {
                                if (this.searchLeftRight(loc7, loc5, loc4, loc9)) 
                                {
                                    arg1.handled = true;
                                    break;
                                }
                                ++loc9;
                                --loc7;
                            }
                            if (!arg1.handled) 
                            {
                                if (!((loc8 = this.SearchForNearestSelectableIndexInDirection(loc3)) == -1) && this.selectRendererAtIndexIfValid(loc8)) 
                                {
                                    arg1.handled = true;
                                }
                            }
                        }
                        else 
                        {
                            this.findSelection();
                        }
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.RIGHT:
                    {
                        if (this._selectedIndex != -1) 
                        {
                            loc7 = loc5 + 1;
                            while (loc7 < this.numColumns) 
                            {
                                if (this.searchLeftRight(loc7, loc5, loc4, loc9)) 
                                {
                                    arg1.handled = true;
                                    break;
                                }
                                ++loc9;
                                ++loc7;
                            }
                            if (!arg1.handled) 
                            {
                                if (!((loc8 = this.SearchForNearestSelectableIndexInDirection(loc3)) == -1) && this.selectRendererAtIndexIfValid(loc8)) 
                                {
                                    arg1.handled = true;
                                }
                            }
                        }
                        else 
                        {
                            this.findSelection();
                        }
                        break;
                    }
                }
            }
            else if (loc1.code == red.core.constants.KeyCode.PAD_RIGHT_STICK_AXIS) 
            {
                this.handleRightJoystick(loc1.value.yvalue);
            }
            if (!arg1.handled && loc1.value == scaleform.clik.constants.InputValue.KEY_UP) 
            {
                if ((loc10 == this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotBase) && !loc10.isEmpty()) 
                {
                    loc10.executeAction(loc1.code, arg1);
                }
            }
            return;
        }

        protected function searchLeftRight(arg1:int, arg2:int, arg3:int, arg4:int):Boolean
        {
            var loc1:*=0;
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=1;
            if (!(this._renderers[this._selectedIndex] == null) && this._renderers[this._selectedIndex] is red.game.witcher3.slots.SlotInventoryGrid) 
            {
                loc4 = (this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotInventoryGrid).data.gridSize;
            }
            for (;;) 
            {
                if (loc1 > arg4) 
                {
                    break;
                }
                else if (loc1 != 0) 
                {
                    if (this._lastLeftAxisY < 0) 
                    {
                        loc2 = this.getIndexFromCoordinates(loc4 > 1 ? arg3 + loc1 + 1 : arg3 + loc1, arg1);
                        loc3 = this.getIndexFromCoordinates(arg3 - loc1, arg1);
                    }
                    else 
                    {
                        loc2 = this.getIndexFromCoordinates(arg3 - loc1, arg1);
                        loc3 = this.getIndexFromCoordinates(loc4 > 1 ? arg3 + loc1 + 1 : arg3 + loc1, arg1);
                    }
                    if (loc2 < 0 && loc3 < 0) 
                    {
                        break;
                    }
                    else if (loc2 >= 0 && this.selectRendererAtIndexIfValid(loc2) || loc3 >= 0 && this.selectRendererAtIndexIfValid(loc3)) 
                    {
                        return true;
                    }
                }
                else if (this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(arg3, arg1)) || loc4 > 1 && this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(arg3 + 1, arg1))) 
                {
                    return true;
                }
                ++loc1;
            }
            return false;
        }

        protected function searchUpDown(arg1:int, arg2:int, arg3:int, arg4:int):Boolean
        {
            var loc1:*=0;
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=1;
            if (!(this._renderers[this._selectedIndex] == null) && this._renderers[this._selectedIndex] is red.game.witcher3.slots.SlotInventoryGrid) 
            {
                loc4 = (this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotInventoryGrid).data.gridSize;
            }
            for (;;) 
            {
                if (loc1 > arg4) 
                {
                    break;
                }
                else if (loc1 != 0) 
                {
                    if (this._lastLeftAxisX < 0) 
                    {
                        loc2 = this.getIndexFromCoordinates(arg1, arg2 - loc1);
                        loc3 = this.getIndexFromCoordinates(arg1, arg2 + loc1);
                    }
                    else 
                    {
                        loc2 = this.getIndexFromCoordinates(arg1, arg2 + loc1);
                        loc3 = this.getIndexFromCoordinates(arg1, arg2 - loc1);
                    }
                    if (loc2 < 0 && loc3 < 0) 
                    {
                        break;
                    }
                    else if (loc2 >= 0 && this.selectRendererAtIndexIfValid(loc2) || loc3 >= 0 && this.selectRendererAtIndexIfValid(loc3)) 
                    {
                        return true;
                    }
                }
                else if (this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(arg1, arg2))) 
                {
                    return true;
                }
                ++loc1;
            }
            return false;
        }

        public function getIndexFromCoordinates(arg1:int, arg2:int):int
        {
            if (arg1 >= 0 && arg1 < this.numRows && arg2 >= 0 && arg2 < this.numColumns) 
            {
                return this.numColumns * arg1 + arg2;
            }
            return -1;
        }

        public function selectRendererAtIndexIfValid(arg1:int):Boolean
        {
            var loc3:*=null;
            var loc1:*=this.getRendererAt(arg1) as red.game.witcher3.slots.SlotBase;
            var loc2:*=this.getRendererAt(this._selectedIndex) as red.game.witcher3.slots.SlotBase;
            if (loc1 && !loc1.isEmpty() && !(loc2 == loc1)) 
            {
                if ((loc3 == this._renderers[arg1] as red.game.witcher3.slots.SlotInventoryGrid) && !(loc3.uplink == null)) 
                {
                    if (loc3.uplink as red.game.witcher3.slots.SlotInventoryGrid == loc2) 
                    {
                        return false;
                    }
                    else 
                    {
                        loc3 = loc3.uplink as red.game.witcher3.slots.SlotInventoryGrid;
                        this.selectedIndex = loc3.index;
                        dispatchEvent(new scaleform.clik.events.ListEvent(scaleform.clik.events.ListEvent.INDEX_CHANGE, true, false, loc3.index, -1, -1, loc3, this));
                    }
                }
                else 
                {
                    this.selectedIndex = arg1;
                    dispatchEvent(new scaleform.clik.events.ListEvent(scaleform.clik.events.ListEvent.INDEX_CHANGE, true, false, arg1, -1, -1, loc1, this));
                }
                return true;
            }
            return false;
        }

        public function traceGrid():void
        {
            var loc1:*=null;
            var loc6:*=null;
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=0;
            loc3 = 0;
            while (loc3 < this.numRows) 
            {
                loc1 = "GFX - |";
                loc4 = 0;
                while (loc4 < this.numColumns) 
                {
                    loc2 = this.getIndexFromCoordinates(loc3, loc4);
                    loc6 = this.getRendererAt(loc2) as red.game.witcher3.slots.SlotInventoryGrid;
                    if (loc2 == -1 || loc2 >= this._renderers.length) 
                    {
                        loc1 = loc1 + " e |";
                    }
                    else if (loc2 != this._selectedIndex) 
                    {
                        if (loc6) 
                        {
                            if ((this._renderers[loc2] as red.game.witcher3.interfaces.IInventorySlot).uplink == null) 
                            {
                                if (loc6.isEmpty()) 
                                {
                                    loc1 = loc1 + " o |";
                                }
                                else 
                                {
                                    loc1 = loc1 + " y |";
                                }
                            }
                            else 
                            {
                                loc1 = loc1 + " u |";
                            }
                        }
                        else if ((this.getRendererAt(loc2) as red.game.witcher3.slots.SlotBase).isEmpty()) 
                        {
                            loc1 = loc1 + " o |";
                        }
                        else 
                        {
                            loc1 = loc1 + " x |";
                        }
                    }
                    else 
                    {
                        loc1 = loc1 + " s |";
                    }
                    ++loc4;
                }
                trace(loc1);
                ++loc3;
            }
            var loc5:*=0;
            while (loc5 < this._renderersCount) 
            {
                if (this._renderers[loc5] is red.game.witcher3.interfaces.IInventorySlot && !((this._renderers[loc5] as red.game.witcher3.interfaces.IInventorySlot).uplink == null)) 
                {
                    trace("GFX - found uplink on object: ", this._renderers[loc5], ", pointing to: ", (this._renderers[loc5] as red.game.witcher3.interfaces.IInventorySlot).uplink);
                }
                ++loc5;
            }
            return;
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc3:*=null;
            super.handleInput(arg1);
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
            trace("JOURNAL ************************ ");
            trace("JOURNAL SLB HI " + loc1.code);
            trace("JOURNAL ************************ ");
            if (loc2 && !arg1.handled) 
            {
                if (this._selectedIndex > -1 && this._renderers.length && this._selectedIndex < this._renderers.length) 
                {
                    if (loc3 == this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotBase) 
                    {
                        loc3.executeAction(loc1.code, arg1);
                    }
                }
            }
            return;
        }

        protected function navigateTo(arg1:red.game.witcher3.interfaces.IBaseSlot, arg2:Number):red.game.witcher3.interfaces.IBaseSlot
        {
            var loc9:*=null;
            var loc10:*=undefined;
            var loc11:*=null;
            var loc12:*=NaN;
            var loc13:*=NaN;
            var loc14:*=NaN;
            var loc15:*=NaN;
            var loc16:*=NaN;
            var loc17:*=NaN;
            var loc18:*=NaN;
            var loc19:*=NaN;
            var loc20:*=NaN;
            var loc21:*=NaN;
            var loc1:*=arg1.x + arg1.width / 2;
            var loc2:*=arg1.data ? arg1.data.gridSize : 2;
            var loc3:*=arg1.y + arg1.height * loc2 / 2;
            var loc4:*=new flash.geom.Point(loc1, loc3);
            var loc5:*=new flash.utils.Dictionary(true);
            var loc6:*=this._renderers.length;
            var loc7:*=0;
            while (loc7 < loc6) 
            {
                if ((loc11 == this._renderers[loc7] as red.game.witcher3.interfaces.IBaseSlot) && !(loc11 == arg1) && (loc11.selectable || this.ignoreSelectable)) 
                {
                    loc12 = loc11.data ? loc11.data.gridSize : 2;
                    loc13 = loc11.x + loc11.width / 2;
                    loc14 = loc11.y + loc11.height * loc12 / 2;
                    loc15 = loc1 - loc13;
                    loc16 = loc3 - loc14;
                    if ((loc17 = Math.atan2(loc16, loc15)) > (-Math.PI) / 2 && loc17 <= Math.PI) 
                    {
                        loc17 = loc17 - Math.PI / 2;
                    }
                    else if (loc17 >= -Math.PI && loc17 <= (-Math.PI) / 2) 
                    {
                        loc17 = loc17 + Math.PI * 3 / 2;
                    }
                    if ((loc18 = this.getSector(arg2, loc17)) <= Math.PI / 4) 
                    {
                        loc19 = red.game.witcher3.utils.Math2.getSegmentLength(loc4, new flash.geom.Point(loc13, loc14));
                        loc20 = Math.sin(loc18) * loc19;
                        loc21 = (loc19 + loc20) / 2;
                        loc5[loc11] = loc21;
                    }
                }
                ++loc7;
            }
            var loc8:*=-1;
            var loc22:*=0;
            var loc23:*=loc5;
            for (loc10 in loc23) 
            {
                if (!(loc8 > loc5[loc10] || loc8 == -1)) 
                {
                    continue;
                }
                loc8 = loc5[loc10];
                loc9 = loc10 as red.game.witcher3.interfaces.IBaseSlot;
            }
            return loc9;
        }

        protected function getSector(arg1:Number, arg2:Number):Number
        {
            var loc1:*=arg1 >= 0 ? arg1 : arg1 + Math.PI * 2;
            var loc2:*=arg2 >= 0 ? arg2 : arg2 + Math.PI * 2;
            var loc3:*;
            if ((loc3 = Math.abs(loc2 - loc1)) > Math.PI) 
            {
                loc3 = Math.abs(loc3 - Math.PI / 2);
            }
            return loc3;
        }

        protected function handleRightJoystick(arg1:Number):*
        {
            return;
        }

        public function tryExecuteAction(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=null;
            if (arg1.details.code == red.core.constants.KeyCode.PAD_A_CROSS || arg1.details.code == red.core.constants.KeyCode.PAD_X_SQUARE) 
            {
                if (this._selectedIndex >= 0 && this._selectedIndex < this._renderers.length) 
                {
                    loc1 = this._renderers[this._selectedIndex] as red.game.witcher3.slots.SlotBase;
                    if (loc1 && !loc1.isEmpty()) 
                    {
                        loc1.executeAction(arg1.details.code, arg1);
                        return;
                    }
                }
            }
            arg1.handled = false;
            return;
        }

        protected function isNavigationKeyCode(arg1:uint):Boolean
        {
            var loc1:*=arg1;
            switch (loc1) 
            {
                case red.core.constants.KeyCode.UP:
                case red.core.constants.KeyCode.DOWN:
                case red.core.constants.KeyCode.RIGHT:
                case red.core.constants.KeyCode.LEFT:
                case red.core.constants.KeyCode.PAD_DIGIT_UP:
                case red.core.constants.KeyCode.PAD_DIGIT_DOWN:
                case red.core.constants.KeyCode.PAD_DIGIT_RIGHT:
                case red.core.constants.KeyCode.PAD_DIGIT_LEFT:
                {
                    return true;
                }
            }
            return false;
        }

        public function applySelectionContext():void
        {
            var loc2:*=null;
            var loc3:*=false;
            var loc1:*=red.game.witcher3.slots.SlotsTransferManager.getInstance();
            if (this._selectedIndex <= -1 || focused < 1 && _focusable || !enabled) 
            {
                loc1.hideDropTargets();
                return;
            }
            if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length) 
            {
                loc2 = this._renderers[this._selectedIndex];
                loc3 = loc2.selectable || this.ignoreSelectable;
                if (!loc3 || !loc2.activeSelectionEnabled) 
                {
                    loc1.hideDropTargets();
                    return;
                }
                loc1.showDropTargets(loc2 as red.game.witcher3.interfaces.IDragTarget);
                return;
            }
            return;
        }

        protected function setupRenderer(arg1:red.game.witcher3.interfaces.IBaseSlot):void
        {
            arg1.owner = this;
            arg1.enabled = enabled;
            arg1.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.handleItemClick, false, 0, true);
            return;
        }

        protected function cleanUpRenderer(arg1:red.game.witcher3.interfaces.IBaseSlot):void
        {
            arg1.owner = null;
            arg1.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.handleItemClick);
            return;
        }

        public function clearRenderers():void
        {
            var loc1:*=0;
            loc1 = 0;
            while (loc1 < this._renderers.length) 
            {
                this.cleanUpRenderer(this._renderers[loc1]);
                (this._renderers[loc1] as scaleform.clik.core.UIComponent).parent.removeChild(this._renderers[loc1] as scaleform.clik.core.UIComponent);
                ++loc1;
            }
            this._renderers.length = 0;
            this._renderersCount = 0;
            return;
        }

        protected function handleItemClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*=null;
            var loc1:*=arg1.currentTarget as red.game.witcher3.interfaces.IBaseSlot;
            if (loc1) 
            {
                this.selectedIndex = loc1.index;
                if (focused < 1) 
                {
                    this.focused = 1;
                }
                loc2 = new scaleform.clik.events.ListEvent(scaleform.clik.events.ListEvent.ITEM_CLICK);
                loc2.itemData = loc1.data as Object;
                loc2.index = loc1.index;
                dispatchEvent(loc2);
            }
            return;
        }

        protected var _canvas:flash.display.Sprite;

        protected var _selectedIndex:int=-1;

        protected var _data:Array;

        protected var _renderers:__AS3__.vec.Vector.<red.game.witcher3.interfaces.IBaseSlot>;

        protected var _cachedSelection:int;

        protected var _mouseContext:red.game.witcher3.interfaces.IBaseSlot;

        protected var _selectionContext:red.game.witcher3.interfaces.IBaseSlot;

        protected var _slotRenderer:String;

        protected var _renderersCount:int;

        protected var _lastLeftAxisX:Number;

        protected var _lastLeftAxisY:Number;

        public var ignoreSelectable:Boolean=false;

        protected var _slotRendererRef:Class;

        protected var _activeSelectionVisible:Boolean=true;

        public var allowSimpleNavDPad:Boolean=true;
    }
}



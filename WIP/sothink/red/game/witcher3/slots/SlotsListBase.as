package red.game.witcher3.slots
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import red.core.constants.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.menus.common.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class SlotsListBase extends UIComponent implements IScrollingList
    {
        protected var _canvas:Sprite;
        protected var _selectedIndex:int = -1;
        protected var _data:Array;
        protected var _renderers:Vector.<IBaseSlot>;
        protected var _cachedSelection:int;
        protected var _mouseContext:IBaseSlot;
        protected var _selectionContext:IBaseSlot;
        protected var _slotRenderer:String;
        protected var _slotRendererRef:Class;
        protected var _renderersCount:int;
        protected var _lastLeftAxisX:Number;
        protected var _lastLeftAxisY:Number;
        public var ignoreSelectable:Boolean = false;
        protected var _activeSelectionVisible:Boolean = true;
        public var allowSimpleNavDPad:Boolean = true;

        public function SlotsListBase()
        {
            this._data = [];
            this._renderers = new Vector.<IBaseSlot>;
            this._canvas = new Sprite();
            addChild(this._canvas);
            focusable = true;
            this._selectedIndex = -1;
            this._renderersCount = 0;
            tabEnabled = false;
            tabChildren = false;
            return;
        }// end function

        public function getRenderersCount() : int
        {
            return this._renderersCount;
        }// end function

        public function getRenderersLength() : int
        {
            return this._renderers.length;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            addEventListener(InputEvent.INPUT, this.handleInput, false, 0, true);
            return;
        }// end function

        public function get slotRendererName() : String
        {
            return this._slotRenderer;
        }// end function

        public function set slotRendererName(param1:String) : void
        {
            var value:* = param1;
            if (this._slotRenderer != value)
            {
                this._slotRenderer = value;
                try
                {
                    this._slotRendererRef = getDefinitionByName(this._slotRenderer) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + _slotRenderer);
                }
            }
            return;
        }// end function

        public function get data() : Array
        {
            return this._data;
        }// end function

        public function set data(param1:Array) : void
        {
            this._data = param1;
            invalidateData();
            return;
        }// end function

        public function stableDataUpdate(param1:Array) : void
        {
            return;
        }// end function

        public function get numColumns() : uint
        {
            return 0;
        }// end function

        public function get numRows() : uint
        {
            return Math.ceil(this._renderers.length / this.numColumns);
        }// end function

        public function get rendererHeight() : Number
        {
            if (this._renderers.length > 0)
            {
                return this._renderers[0].height;
            }
            return 0;
        }// end function

        public function get selectedColumn() : int
        {
            if (this.selectedIndex >= 0 && this.numColumns > 0)
            {
                return this.selectedIndex % this.numColumns;
            }
            return -1;
        }// end function

        public function updateItemData(param1:Object) : void
        {
            return;
        }// end function

        public function removeItem(param1:uint, param2:Boolean = false) : void
        {
            return;
        }// end function

        public function updateItems(param1:Array) : void
        {
            return;
        }// end function

        public function findSelection() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_1:* = this._cachedSelection ? (this._cachedSelection) : (this.selectedIndex);
            var _loc_2:* = this.getRendererAt(_loc_1) as IBaseSlot;
            if (!_loc_2 || _loc_2 && !_loc_2.selectable)
            {
                _loc_1 = -1;
                _loc_3 = this._renderers.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    if (this._renderers[_loc_4].selectable)
                    {
                        _loc_1 = _loc_4;
                        break;
                    }
                    _loc_4++;
                }
            }
            else
            {
                _loc_1 = _loc_2.index;
            }
            this.selectedIndex = _loc_1;
            return;
        }// end function

        public function GetDropdownListHeight() : Number
        {
            return 0;
        }// end function

        public function getSelectedRenderer() : IListItemRenderer
        {
            if (this._selectedIndex < 0 || this._selectedIndex >= this._renderers.length)
            {
                return null;
            }
            return this._renderers[this._selectedIndex] as IListItemRenderer;
        }// end function

        public function getRendererIndex(param1:IListItemRenderer) : int
        {
            return this._renderers.indexOf(param1);
        }// end function

        public function getRendererAt(param1:uint, param2:int = 0) : IListItemRenderer
        {
            if (param1 < 0 || param1 >= this._renderers.length)
            {
                return null;
            }
            return this._renderers[param1];
        }// end function

        override protected function draw() : void
        {
            if (isInvalid(InvalidationType.DATA))
            {
                this.populateData();
            }
            return;
        }// end function

        protected function populateData() : void
        {
            return;
        }// end function

        public function get activeSelectionVisible() : Boolean
        {
            return this._activeSelectionVisible;
        }// end function

        public function set activeSelectionVisible(param1:Boolean) : void
        {
            if (this._activeSelectionVisible != param1)
            {
                this._activeSelectionVisible = param1;
                this.updateActiveSelectionVisible();
                this.applySelectionContext();
            }
            return;
        }// end function

        public function updateActiveSelectionVisible() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            _loc_1 = 0;
            while (_loc_1 < this._renderers.length)
            {
                
                _loc_2 = this._renderers[_loc_1] as SlotBase;
                if (_loc_2)
                {
                    _loc_2.activeSelectionEnabled = this._activeSelectionVisible;
                }
                _loc_1++;
            }
            return;
        }// end function

        public function handleInputPreset(event:InputEvent) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = undefined;
            var _loc_7:* = null;
            if (event.handled)
            {
                return;
            }
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_DOWN || _loc_2.value == InputValue.KEY_HOLD;
            CommonUtils.convertWASDCodeToNavEquivalent(_loc_2);
            var _loc_4:* = _loc_2.fromJoystick || this.allowSimpleNavDPad ? (_loc_2.navEquivalent) : (NavigationCode.INVALID);
            if (_loc_3)
            {
                switch(_loc_4)
                {
                    case NavigationCode.UP:
                    case NavigationCode.DOWN:
                    case NavigationCode.LEFT:
                    case NavigationCode.RIGHT:
                    {
                        _loc_5 = this.getSelectedRenderer() as SlotBase;
                        if (_loc_5)
                        {
                            _loc_6 = _loc_5.GetNavigationIndex(_loc_4);
                            if (_loc_6 != -1)
                            {
                                _loc_7 = this.getRendererAt(_loc_6) as SlotBase;
                                Console.WriteLine("GFX - targetSlot: " + _loc_7 + ", isSelectable: " + _loc_7.selectable);
                                if (_loc_7.selectable || this.ignoreSelectable)
                                {
                                    this.selectedIndex = _loc_6;
                                    event.handled = true;
                                }
                                else
                                {
                                    _loc_6 = this.SearchForNearestSelectableIndexInDirection(_loc_4);
                                    if (_loc_6 != -1)
                                    {
                                        this.selectedIndex = _loc_6;
                                        event.handled = true;
                                    }
                                }
                            }
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        public function SearchForNearestSelectableIndexInDirection(param1:String) : int
        {
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_2:* = -1;
            var _loc_3:* = -1;
            var _loc_4:* = -1;
            var _loc_5:* = -1;
            Console.WriteLine("GFX - Searching for nearest Selectable index with direction:" + param1);
            var _loc_6:* = this.getSelectedRenderer() as SlotBase;
            if (!_loc_6)
            {
                return -1;
            }
            switch(param1)
            {
                case NavigationCode.UP:
                {
                    _loc_5 = _loc_6.y;
                    break;
                }
                case NavigationCode.DOWN:
                {
                    _loc_4 = _loc_6.y;
                    break;
                }
                case NavigationCode.LEFT:
                {
                    _loc_3 = _loc_6.x;
                    break;
                }
                case NavigationCode.RIGHT:
                {
                    _loc_2 = _loc_6.x;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_9:* = 0;
            var _loc_10:* = Number.MAX_VALUE;
            var _loc_11:* = null;
            var _loc_12:* = false;
            if (_loc_6.data && _loc_6.data.hasOwnProperty("gridSize"))
            {
                _loc_12 = _loc_6.data.gridSize < 2;
            }
            _loc_8 = 0;
            while (_loc_8 < this._renderers.length)
            {
                
                _loc_7 = this._renderers[_loc_8] as SlotBase;
                if (_loc_7 != _loc_6 && (_loc_7.selectable || this.ignoreSelectable) && (_loc_5 == -1 || _loc_7.y < _loc_5) && (_loc_4 == -1 || _loc_7.y > _loc_4 || _loc_7.y == _loc_4 && _loc_12 && _loc_7.data.gridSize > 1) && (_loc_3 == -1 || _loc_7.x < _loc_3) && (_loc_2 == -1 || _loc_7.x > _loc_2))
                {
                    _loc_9 = Math.sqrt(Math.pow(_loc_6.x - _loc_7.x, 2) + Math.pow(_loc_6.y - _loc_7.y, 2));
                    if (_loc_9 < _loc_10)
                    {
                        _loc_10 = _loc_9;
                        _loc_11 = _loc_7;
                    }
                }
                _loc_8++;
            }
            if (_loc_11 != null)
            {
                return this._renderers.indexOf(_loc_11);
            }
            return -1;
        }// end function

        public function handleInputNavSimple(event:InputEvent) : void
        {
            var _loc_11:* = null;
            if (event.handled)
            {
                return;
            }
            var _loc_2:* = event.details;
            if (_loc_2.code == KeyCode.PAD_LEFT_STICK_AXIS)
            {
                this._lastLeftAxisX = _loc_2.value.xvalue;
                this._lastLeftAxisY = _loc_2.value.yvalue;
                return;
            }
            var _loc_3:* = _loc_2.value == InputValue.KEY_DOWN || _loc_2.value == InputValue.KEY_HOLD;
            CommonUtils.convertWASDCodeToNavEquivalent(_loc_2);
            var _loc_4:* = _loc_2.fromJoystick || this.allowSimpleNavDPad ? (_loc_2.navEquivalent) : (NavigationCode.INVALID);
            if (!this.allowSimpleNavDPad)
            {
                switch(_loc_2.code)
                {
                    case KeyCode.W:
                    case KeyCode.UP:
                    {
                        _loc_4 = NavigationCode.UP;
                        break;
                    }
                    case KeyCode.S:
                    case KeyCode.DOWN:
                    {
                        _loc_4 = NavigationCode.DOWN;
                        break;
                    }
                    case KeyCode.A:
                    case KeyCode.LEFT:
                    {
                        _loc_4 = NavigationCode.LEFT;
                        break;
                    }
                    case KeyCode.D:
                    case KeyCode.RIGHT:
                    {
                        _loc_4 = NavigationCode.RIGHT;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            var _loc_5:* = this._selectedIndex == -1 ? (-1) : (Math.floor(this._selectedIndex / this.numColumns));
            var _loc_6:* = this._selectedIndex == -1 ? (-1) : (this._selectedIndex - _loc_5 * this.numColumns);
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = -1;
            var _loc_10:* = 1;
            if (_loc_3)
            {
                switch(_loc_4)
                {
                    case NavigationCode.UP:
                    {
                        if (this._selectedIndex == -1)
                        {
                            this.findSelection();
                        }
                        else
                        {
                            _loc_7 = _loc_5 - 1;
                            while (_loc_7 >= 0)
                            {
                                
                                if (this.searchUpDown(_loc_7, _loc_6, _loc_5, _loc_10))
                                {
                                    event.handled = true;
                                    break;
                                }
                                _loc_10 = _loc_10 + 1;
                                _loc_7 = _loc_7 - 1;
                            }
                            if (!event.handled)
                            {
                                _loc_9 = this.SearchForNearestSelectableIndexInDirection(_loc_4);
                                if (_loc_9 != -1 && this.selectRendererAtIndexIfValid(_loc_9))
                                {
                                    event.handled = true;
                                }
                            }
                        }
                        break;
                    }
                    case NavigationCode.DOWN:
                    {
                        if (this._selectedIndex == -1)
                        {
                            this.findSelection();
                        }
                        else
                        {
                            if (this._renderers[this._selectedIndex] is SlotInventoryGrid && (this._renderers[this._selectedIndex] as SlotInventoryGrid).data.gridSize > 1)
                            {
                                _loc_5 = _loc_5 + 1;
                            }
                            _loc_7 = _loc_5 + 1;
                            while (_loc_7 < this.numRows)
                            {
                                
                                if (this.searchUpDown(_loc_7, _loc_6, _loc_5, _loc_10))
                                {
                                    event.handled = true;
                                    break;
                                }
                                _loc_10 = _loc_10 + 1;
                                _loc_7++;
                            }
                            if (!event.handled)
                            {
                                _loc_9 = this.SearchForNearestSelectableIndexInDirection(_loc_4);
                                if (_loc_9 != -1 && this.selectRendererAtIndexIfValid(_loc_9))
                                {
                                    event.handled = true;
                                }
                            }
                        }
                        break;
                    }
                    case NavigationCode.LEFT:
                    {
                        if (this._selectedIndex == -1)
                        {
                            this.findSelection();
                        }
                        else
                        {
                            _loc_8 = _loc_6 - 1;
                            while (_loc_8 >= 0)
                            {
                                
                                if (this.searchLeftRight(_loc_8, _loc_6, _loc_5, _loc_10))
                                {
                                    event.handled = true;
                                    break;
                                }
                                _loc_10 = _loc_10 + 1;
                                _loc_8 = _loc_8 - 1;
                            }
                            if (!event.handled)
                            {
                                _loc_9 = this.SearchForNearestSelectableIndexInDirection(_loc_4);
                                if (_loc_9 != -1 && this.selectRendererAtIndexIfValid(_loc_9))
                                {
                                    event.handled = true;
                                }
                            }
                        }
                        break;
                    }
                    case NavigationCode.RIGHT:
                    {
                        if (this._selectedIndex == -1)
                        {
                            this.findSelection();
                        }
                        else
                        {
                            _loc_8 = _loc_6 + 1;
                            while (_loc_8 < this.numColumns)
                            {
                                
                                if (this.searchLeftRight(_loc_8, _loc_6, _loc_5, _loc_10))
                                {
                                    event.handled = true;
                                    break;
                                }
                                _loc_10 = _loc_10 + 1;
                                _loc_8++;
                            }
                            if (!event.handled)
                            {
                                _loc_9 = this.SearchForNearestSelectableIndexInDirection(_loc_4);
                                if (_loc_9 != -1 && this.selectRendererAtIndexIfValid(_loc_9))
                                {
                                    event.handled = true;
                                }
                            }
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else if (_loc_2.code == KeyCode.PAD_RIGHT_STICK_AXIS)
            {
                this.handleRightJoystick(_loc_2.value.yvalue);
            }
            if (!event.handled && _loc_2.value == InputValue.KEY_UP)
            {
                _loc_11 = this._renderers[this._selectedIndex] as SlotBase;
                if (_loc_11 && !_loc_11.isEmpty())
                {
                    _loc_11.executeAction(_loc_2.code, event);
                }
            }
            return;
        }// end function

        protected function searchLeftRight(param1:int, param2:int, param3:int, param4:int) : Boolean
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 1;
            if (this._renderers[this._selectedIndex] != null && this._renderers[this._selectedIndex] is SlotInventoryGrid)
            {
                _loc_8 = (this._renderers[this._selectedIndex] as SlotInventoryGrid).data.gridSize;
            }
            while (true)
            {
                
                if (_loc_5 > param4)
                {
                    break;
                }
                else if (_loc_5 == 0)
                {
                    if (this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(param3, param1)) || _loc_8 > 1 && this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates((param3 + 1), param1)))
                    {
                        return true;
                    }
                }
                else
                {
                    if (this._lastLeftAxisY < 0)
                    {
                        _loc_6 = this.getIndexFromCoordinates(_loc_8 > 1 ? (param3 + _loc_5 + 1) : (param3 + _loc_5), param1);
                        _loc_7 = this.getIndexFromCoordinates(param3 - _loc_5, param1);
                    }
                    else
                    {
                        _loc_6 = this.getIndexFromCoordinates(param3 - _loc_5, param1);
                        _loc_7 = this.getIndexFromCoordinates(_loc_8 > 1 ? (param3 + _loc_5 + 1) : (param3 + _loc_5), param1);
                    }
                    if (_loc_6 < 0 && _loc_7 < 0)
                    {
                        break;
                    }
                    else if (_loc_6 >= 0 && this.selectRendererAtIndexIfValid(_loc_6) || _loc_7 >= 0 && this.selectRendererAtIndexIfValid(_loc_7))
                    {
                        return true;
                    }
                }
                _loc_5++;
            }
            return false;
        }// end function

        protected function searchUpDown(param1:int, param2:int, param3:int, param4:int) : Boolean
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 1;
            if (this._renderers[this._selectedIndex] != null && this._renderers[this._selectedIndex] is SlotInventoryGrid)
            {
                _loc_8 = (this._renderers[this._selectedIndex] as SlotInventoryGrid).data.gridSize;
            }
            while (true)
            {
                
                if (_loc_5 > param4)
                {
                    break;
                }
                else if (_loc_5 == 0)
                {
                    if (this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(param1, param2)))
                    {
                        return true;
                    }
                }
                else
                {
                    if (this._lastLeftAxisX < 0)
                    {
                        _loc_6 = this.getIndexFromCoordinates(param1, param2 - _loc_5);
                        _loc_7 = this.getIndexFromCoordinates(param1, param2 + _loc_5);
                    }
                    else
                    {
                        _loc_6 = this.getIndexFromCoordinates(param1, param2 + _loc_5);
                        _loc_7 = this.getIndexFromCoordinates(param1, param2 - _loc_5);
                    }
                    if (_loc_6 < 0 && _loc_7 < 0)
                    {
                        break;
                    }
                    else if (_loc_6 >= 0 && this.selectRendererAtIndexIfValid(_loc_6) || _loc_7 >= 0 && this.selectRendererAtIndexIfValid(_loc_7))
                    {
                        return true;
                    }
                }
                _loc_5++;
            }
            return false;
        }// end function

        public function getIndexFromCoordinates(param1:int, param2:int) : int
        {
            if (param1 >= 0 && param1 < this.numRows && param2 >= 0 && param2 < this.numColumns)
            {
                return this.numColumns * param1 + param2;
            }
            return -1;
        }// end function

        public function selectRendererAtIndexIfValid(param1:int) : Boolean
        {
            var _loc_4:* = null;
            var _loc_2:* = this.getRendererAt(param1) as SlotBase;
            var _loc_3:* = this.getRendererAt(this._selectedIndex) as SlotBase;
            if (_loc_2 && !_loc_2.isEmpty() && _loc_3 != _loc_2)
            {
                _loc_4 = this._renderers[param1] as SlotInventoryGrid;
                if (_loc_4 && _loc_4.uplink != null)
                {
                    if (_loc_4.uplink as SlotInventoryGrid != _loc_3)
                    {
                        _loc_4 = _loc_4.uplink as SlotInventoryGrid;
                        this.selectedIndex = _loc_4.index;
                        dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE, true, false, _loc_4.index, -1, -1, _loc_4, this));
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    this.selectedIndex = param1;
                    dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE, true, false, param1, -1, -1, _loc_2, this));
                }
                return true;
            }
            return false;
        }// end function

        public function traceGrid() : void
        {
            var _loc_1:* = null;
            var _loc_6:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            _loc_3 = 0;
            while (_loc_3 < this.numRows)
            {
                
                _loc_1 = "GFX - |";
                _loc_4 = 0;
                while (_loc_4 < this.numColumns)
                {
                    
                    _loc_2 = this.getIndexFromCoordinates(_loc_3, _loc_4);
                    _loc_6 = this.getRendererAt(_loc_2) as SlotInventoryGrid;
                    if (_loc_2 == -1 || _loc_2 >= this._renderers.length)
                    {
                        _loc_1 = _loc_1 + " e |";
                    }
                    else if (_loc_2 == this._selectedIndex)
                    {
                        _loc_1 = _loc_1 + " s |";
                    }
                    else if (_loc_6)
                    {
                        if ((this._renderers[_loc_2] as IInventorySlot).uplink != null)
                        {
                            _loc_1 = _loc_1 + " u |";
                        }
                        else if (_loc_6.isEmpty())
                        {
                            _loc_1 = _loc_1 + " o |";
                        }
                        else
                        {
                            _loc_1 = _loc_1 + " y |";
                        }
                    }
                    else if (!(this.getRendererAt(_loc_2) as SlotBase).isEmpty())
                    {
                        _loc_1 = _loc_1 + " x |";
                    }
                    else
                    {
                        _loc_1 = _loc_1 + " o |";
                    }
                    _loc_4++;
                }
                Console.WriteLine(_loc_1);
                _loc_3++;
            }
            var _loc_5:* = 0;
            while (_loc_5 < this._renderersCount)
            {
                
                if (this._renderers[_loc_5] is IInventorySlot && (this._renderers[_loc_5] as IInventorySlot).uplink != null)
                {
                    Console.WriteLine("GFX - found uplink on object: ", this._renderers[_loc_5], ", pointing to: ", (this._renderers[_loc_5] as IInventorySlot).uplink);
                }
                _loc_5++;
            }
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            var _loc_4:* = null;
            super.handleInput(event);
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_UP;
            Console.WriteLine("JOURNAL ************************ ");
            Console.WriteLine("JOURNAL SLB HI " + _loc_2.code);
            Console.WriteLine("JOURNAL ************************ ");
            if (_loc_3 && !event.handled)
            {
                if (this._selectedIndex > -1 && this._renderers.length && this._selectedIndex < this._renderers.length)
                {
                    _loc_4 = this._renderers[this._selectedIndex] as SlotBase;
                    if (_loc_4)
                    {
                        _loc_4.executeAction(_loc_2.code, event);
                    }
                }
            }
            return;
        }// end function

        protected function navigateTo(param1:IBaseSlot, param2:Number) : IBaseSlot
        {
            var _loc_11:* = null;
            var _loc_12:* = undefined;
            var _loc_13:* = null;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_18:* = NaN;
            var _loc_19:* = NaN;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = NaN;
            var _loc_23:* = NaN;
            var _loc_3:* = param1.x + param1.width / 2;
            var _loc_4:* = param1.data ? (param1.data.gridSize) : (2);
            var _loc_5:* = param1.y + param1.height * _loc_4 / 2;
            var _loc_6:* = new Point(_loc_3, _loc_5);
            var _loc_7:* = new Dictionary(true);
            var _loc_8:* = this._renderers.length;
            var _loc_9:* = 0;
            while (_loc_9 < _loc_8)
            {
                
                _loc_13 = this._renderers[_loc_9] as IBaseSlot;
                if (_loc_13 && _loc_13 != param1 && (_loc_13.selectable || this.ignoreSelectable))
                {
                    _loc_14 = _loc_13.data ? (_loc_13.data.gridSize) : (2);
                    _loc_15 = _loc_13.x + _loc_13.width / 2;
                    _loc_16 = _loc_13.y + _loc_13.height * _loc_14 / 2;
                    _loc_17 = _loc_3 - _loc_15;
                    _loc_18 = _loc_5 - _loc_16;
                    _loc_19 = Math.atan2(_loc_18, _loc_17);
                    if (_loc_19 > (-Math.PI) / 2 && _loc_19 <= Math.PI)
                    {
                        _loc_19 = _loc_19 - Math.PI / 2;
                    }
                    else if (_loc_19 >= -Math.PI && _loc_19 <= (-Math.PI) / 2)
                    {
                        _loc_19 = _loc_19 + Math.PI * 3 / 2;
                    }
                    _loc_20 = this.getSector(param2, _loc_19);
                    if (_loc_20 <= Math.PI / 4)
                    {
                        _loc_21 = Math2.getSegmentLength(_loc_6, new Point(_loc_15, _loc_16));
                        _loc_22 = Math.sin(_loc_20) * _loc_21;
                        _loc_23 = (_loc_21 + _loc_22) / 2;
                        _loc_7[_loc_13] = _loc_23;
                    }
                }
                _loc_9++;
            }
            var _loc_10:* = -1;
            for (_loc_12 in _loc_7)
            {
                
                if (_loc_10 > _loc_7[_loc_12] || _loc_10 == -1)
                {
                    _loc_10 = _loc_7[_loc_12];
                    _loc_11 = _loc_12 as IBaseSlot;
                }
            }
            return _loc_11;
        }// end function

        protected function getSector(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = param1 >= 0 ? (param1) : (param1 + Math.PI * 2);
            var _loc_4:* = param2 >= 0 ? (param2) : (param2 + Math.PI * 2);
            var _loc_5:* = Math.abs(_loc_4 - _loc_3);
            if (_loc_5 > Math.PI)
            {
                _loc_5 = Math.abs(_loc_5 - Math.PI / 2);
            }
            return _loc_5;
        }// end function

        protected function handleRightJoystick(param1:Number)
        {
            return;
        }// end function

        public function tryExecuteAction(event:InputEvent) : void
        {
            var _loc_2:* = null;
            if (event.details.code == KeyCode.PAD_A_CROSS || event.details.code == KeyCode.PAD_X_SQUARE)
            {
                if (this._selectedIndex >= 0 && this._selectedIndex < this._renderers.length)
                {
                    _loc_2 = this._renderers[this._selectedIndex] as SlotBase;
                    if (_loc_2 && !_loc_2.isEmpty())
                    {
                        _loc_2.executeAction(event.details.code, event);
                        return;
                    }
                }
            }
            event.handled = false;
            return;
        }// end function

        protected function isNavigationKeyCode(param1:uint) : Boolean
        {
            switch(param1)
            {
                case KeyCode.UP:
                case KeyCode.DOWN:
                case KeyCode.RIGHT:
                case KeyCode.LEFT:
                case KeyCode.PAD_DIGIT_UP:
                case KeyCode.PAD_DIGIT_DOWN:
                case KeyCode.PAD_DIGIT_RIGHT:
                case KeyCode.PAD_DIGIT_LEFT:
                {
                    return true;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        public function applySelectionContext() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = false;
            var _loc_1:* = SlotsTransferManager.getInstance();
            if (!InputManager.getInstance().isGamepad())
            {
                return;
            }
            if (this._selectedIndex <= -1 || focused < 1 && _focusable || !enabled)
            {
                _loc_1.hideDropTargets();
                return;
            }
            if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
            {
                _loc_2 = this._renderers[this._selectedIndex];
                _loc_3 = _loc_2.selectable || this.ignoreSelectable;
                if (!_loc_3 || !_loc_2.activeSelectionEnabled)
                {
                    _loc_1.hideDropTargets();
                    return;
                }
                _loc_1.showDropTargets(_loc_2 as IDragTarget);
                return;
            }
            return;
        }// end function

        protected function setupRenderer(param1:IBaseSlot) : void
        {
            param1.owner = this;
            param1.enabled = enabled;
            param1.addEventListener(MouseEvent.MOUSE_DOWN, this.handleItemClick, false, 0, true);
            return;
        }// end function

        protected function cleanUpRenderer(param1:IBaseSlot) : void
        {
            param1.owner = null;
            param1.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleItemClick);
            return;
        }// end function

        public function clearRenderers() : void
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < this._renderers.length)
            {
                
                this.cleanUpRenderer(this._renderers[_loc_1]);
                (this._renderers[_loc_1] as UIComponent).parent.removeChild(this._renderers[_loc_1] as UIComponent);
                _loc_1++;
            }
            this._renderers.length = 0;
            this._renderersCount = 0;
            return;
        }// end function

        public function get itemClickEnabled() : Boolean
        {
            return true;
        }// end function

        protected function handleItemClick(event:MouseEvent) : void
        {
            if (!this.itemClickEnabled)
            {
                return;
            }
            var _loc_2:* = event.currentTarget as IBaseSlot;
            if (!_loc_2 && event.currentTarget && event.currentTarget.parent)
            {
                _loc_2 = event.currentTarget.parent as IBaseSlot;
            }
            if (_loc_2)
            {
                this.dispatchItemClickEvent(_loc_2);
            }
            var _loc_3:* = event as MouseEventEx;
            var _loc_4:* = _loc_2 as SlotInventoryGrid;
            if (_loc_4 && _loc_3 && _loc_3.buttonIdx == MouseEventEx.RIGHT_BUTTON)
            {
                _loc_4.tryExecuteAssignedAction();
            }
            return;
        }// end function

        public function dispatchItemClickEvent(param1:IBaseSlot) : void
        {
            this.selectedIndex = param1.index;
            if (focused < 1)
            {
                this.focused = 1;
            }
            var _loc_2:* = new ListEvent(ListEvent.ITEM_CLICK, true);
            _loc_2.itemData = param1.data as Object;
            _loc_2.index = param1.index;
            dispatchEvent(_loc_2);
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            var _loc_2:* = this._renderers.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._renderers[_loc_3].enabled = param1;
                _loc_3++;
            }
            super.enabled = param1;
            this.applySelectionContext();
            return;
        }// end function

        override public function set focused(param1:Number) : void
        {
            if (param1 == _focused || !_focusable)
            {
                return;
            }
            _focused = param1;
            if (Extensions.isScaleform)
            {
                if (_focused > 0)
                {
                    FocusManager.setFocus(this, 0);
                    FocusHandler.getInstance().setFocus(this);
                    if (this.selectedIndex > -1 && enabled)
                    {
                        (this._renderers[this.selectedIndex] as SlotBase).showTooltip();
                    }
                }
            }
            else if (stage != null && _focused > 0)
            {
                stage.focus = this;
            }
            return;
        }// end function

        public function NumNonEmptyRenderers() : int
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            _loc_1 = 0;
            while (_loc_1 < this._renderers.length)
            {
                
                if (!this._renderers[_loc_1].isEmpty())
                {
                    _loc_2++;
                }
                _loc_1++;
            }
            return _loc_2;
        }// end function

        public function ReselectIndexIfInvalid(param1:int = -1) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            if (param1 >= 0 && param1 < this._renderers.length)
            {
                _loc_5 = this._renderers[param1] as SlotBase;
                _loc_4 = param1;
            }
            else
            {
                _loc_5 = this.getSelectedRenderer() as SlotBase;
                param1 = this.selectedIndex;
                _loc_4 = this.selectedIndex;
            }
            if (_loc_5)
            {
                if (!_loc_5.selectable)
                {
                    _loc_6 = -1;
                    _loc_7 = Number.MAX_VALUE;
                    _loc_8 = Number.MAX_VALUE;
                    if (_loc_4 > 0)
                    {
                        _loc_3 = this._renderers[(_loc_4 - 1)] as SlotBase;
                        if (_loc_3 && _loc_3.selectable)
                        {
                            _loc_7 = Math.sqrt(Math.pow(_loc_3.x - _loc_5.x, 2) + Math.pow(_loc_3.y - _loc_5.y, 2));
                            if (_loc_8 > _loc_7 || _loc_7 == _loc_8 && _loc_3.y == _loc_5.y && _loc_3.x > _loc_5.x)
                            {
                                _loc_8 = _loc_7;
                                _loc_6 = _loc_4 - 1;
                            }
                        }
                    }
                    if (_loc_4 < (this._renderers.length - 1))
                    {
                        _loc_3 = this._renderers[(_loc_4 + 1)] as SlotBase;
                        if (_loc_3 && _loc_3.selectable)
                        {
                            _loc_7 = Math.sqrt(Math.pow(_loc_3.x - _loc_5.x, 2) + Math.pow(_loc_3.y - _loc_5.y, 2));
                            if (_loc_8 > _loc_7 || _loc_7 == _loc_8 && _loc_3.y == _loc_5.y && _loc_3.x > _loc_5.x)
                            {
                                _loc_8 = _loc_7;
                                _loc_6 = _loc_4 + 1;
                            }
                        }
                    }
                    _loc_2 = 0;
                    while (_loc_2 < this._renderers.length)
                    {
                        
                        _loc_3 = this._renderers[_loc_2] as SlotBase;
                        if (_loc_3 && _loc_3.selectable)
                        {
                            _loc_7 = Math.sqrt(Math.pow(_loc_3.x - _loc_5.x, 2) + Math.pow(_loc_3.y - _loc_5.y, 2));
                            if (_loc_8 > _loc_7 || _loc_7 == _loc_8 && _loc_3.y == _loc_5.y && _loc_3.x > _loc_5.x)
                            {
                                _loc_8 = _loc_7;
                                _loc_6 = _loc_2;
                            }
                        }
                        _loc_2++;
                    }
                    if (_loc_6 != -1)
                    {
                        this.selectedIndex = _loc_6;
                        return;
                    }
                }
                else if (param1 != -1)
                {
                    _loc_5 = this._renderers[param1] as SlotBase;
                    if (_loc_5 && _loc_5.selectable)
                    {
                        this.selectedIndex = param1;
                        return;
                    }
                }
            }
            this.findSelection();
            return;
        }// end function

        public function get selectedIndex() : int
        {
            return this._selectedIndex;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._renderers.length <= 0)
            {
                if (this._selectedIndex != -1)
                {
                    param1 = -1;
                }
                else
                {
                    this.applySelectionContext();
                    return;
                }
            }
            if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
            {
            }
            if (this._selectedIndex != param1)
            {
                this._cachedSelection = param1;
                if (param1 > -1 && param1 < this._renderers.length && !this._renderers[param1].selectable && !this.ignoreSelectable)
                {
                    this.applySelectionContext();
                    return;
                }
                if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
                {
                    this._renderers[this._selectedIndex].selected = false;
                }
                this._selectedIndex = param1;
                if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
                {
                    _loc_2 = this._renderers[this._selectedIndex];
                    _loc_2.selected = true;
                    this.fireListEvent(this._renderers[this._selectedIndex]);
                }
                else
                {
                    this.fireListEvent(null);
                }
            }
            else if (this._selectedIndex > -1 && this._selectedIndex < this._renderers.length && !_loc_2.selectable && !this.ignoreSelectable)
            {
                _loc_3 = this._renderers[this._selectedIndex] as SlotBase;
                if (_loc_3)
                {
                    _loc_3.showTooltip();
                }
            }
            this.applySelectionContext();
            return;
        }// end function

        protected function fireListEvent(param1:IBaseSlot) : void
        {
            var _loc_2:* = new ListEvent(ListEvent.INDEX_CHANGE);
            if (param1)
            {
                _loc_2.itemRenderer = param1;
                _loc_2.itemData = param1.data as Object;
                _loc_2.index = param1.index;
            }
            else
            {
                _loc_2.index = -1;
            }
            dispatchEvent(_loc_2);
            return;
        }// end function

        protected function getDataIndex(param1:ItemDataStub) : int
        {
            if (param1)
            {
                return this.getIdIndex(param1.id);
            }
            return -1;
        }// end function

        protected function getIdIndex(param1:uint, param2:int = -1) : int
        {
            var _loc_5:* = null;
            var _loc_3:* = this._renderers.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (this._renderers[_loc_4].data is ItemDataStub)
                {
                    _loc_5 = this._renderers[_loc_4].data as ItemDataStub;
                    if (_loc_5 && (_loc_5.id == param1 && (param2 < 0 || _loc_5.groupId == param2)))
                    {
                        return _loc_4;
                    }
                }
                _loc_4++;
            }
            return -1;
        }// end function

        public function getRow(param1:int) : int
        {
            return -1;
        }// end function

        public function getColumn(param1:int) : int
        {
            return -1;
        }// end function

        override public function get scaleX() : Number
        {
            return super.actualScaleX;
        }// end function

        override public function get scaleY() : Number
        {
            return super.actualScaleY;
        }// end function

        override public function toString() : String
        {
            return "[SlotListBase " + name + "]";
        }// end function

    }
}

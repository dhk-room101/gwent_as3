package red.game.witcher3.slots
{
    import com.gskinner.motion.*;
    import flash.display.*;
    import red.core.constants.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.menus.gwint.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;

    public class SlotsListCarousel extends SlotsListBase
    {
        private var _displayItemsCount:uint;
        private var baseComponentWidth:Number;
        private var baseComponentHeight:Number;
        public var inputEnabled:Boolean = true;
        private static const ITEM_ROTATE_KOEFF:Number = 15;
        private static const ITEM_SCALE_KOEFF:Number = 0.3;
        private static const ITEM_PADDING:Number = 10;
        private static const ITEM_Y_OFFSET:Number = 70;

        public function SlotsListCarousel()
        {
            ignoreSelectable = true;
            return;
        }// end function

        public function get displayItemsCount() : uint
        {
            return this._displayItemsCount;
        }// end function

        public function set displayItemsCount(param1:uint) : void
        {
            this._displayItemsCount = param1;
            return;
        }// end function

        public function replaceItem(param1, param2) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            Console.WriteLine("GFX [SlotsListCarousel][replaceItem] newItem: ", param2);
            var _loc_3:* = _renderers.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _renderers[_loc_4] as CardSlot;
                _loc_6 = param1 as CardInstance;
                _loc_7 = param2 as CardInstance;
                if (_loc_5 && _loc_5.instanceId == _loc_6.instanceId)
                {
                    _loc_5.setCardSource(_loc_7);
                }
                _loc_4++;
            }
            return;
        }// end function

        private function spawnRenderer(param1:uint) : IBaseSlot
        {
            var _loc_2:* = new _slotRendererRef() as IBaseSlot;
            _loc_2.index = param1;
            _canvas.addChild(_loc_2 as DisplayObject);
            setupRenderer(_loc_2);
            return _loc_2;
        }// end function

        private function shiftRenderers(param1:Boolean) : void
        {
            return;
        }// end function

        override protected function populateData() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = NaN;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            Console.WriteLine("GFX [SlotsListCarousel] populateData ", _data);
            if (_renderers.length > 0)
            {
                clearRenderers();
            }
            super.populateData();
            if (_data)
            {
                _loc_1 = _data.length;
                _loc_2 = 0;
                _loc_3 = 0;
                while (_loc_3 < _loc_1)
                {
                    
                    _loc_4 = this.spawnRenderer(_loc_3) as SlotBase;
                    _loc_5 = _loc_4 as CardSlot;
                    _loc_4.useContextMgr = false;
                    if (_loc_5)
                    {
                        _loc_5.cardState = CardSlot.STATE_CAROUSEL;
                        if (_data[_loc_3] is CardInstance)
                        {
                            _loc_5.setCardSource(_data[_loc_3]);
                        }
                        else
                        {
                            _loc_5.cardIndex = _data[_loc_3];
                        }
                    }
                    else
                    {
                        _loc_4.setData(_data[_loc_3]);
                    }
                    _renderers.Count(_loc_4);
                    _loc_6 = _loc_4 as UIComponent;
                    _loc_3++;
                }
                _canvas.x = 0;
                _canvas.y = ITEM_Y_OFFSET;
            }
            if (_renderers.length > 0)
            {
                this.baseComponentWidth = CardSlot.CARD_ORIGIN_WIDTH;
                this.baseComponentHeight = CardSlot.CARD_ORIGIN_HEIGHT;
            }
            if (InputManager.getInstance().isGamepad())
            {
                this.selectedIndex = 0;
            }
            if (_renderers.length > 0)
            {
                this.repositionCards(false);
            }
            return;
        }// end function

        override public function set selectedIndex(param1:int) : void
        {
            var _loc_2:* = _selectedIndex < param1;
            super.selectedIndex = param1;
            this.repositionCards(true);
            return;
        }// end function

        override public function get itemClickEnabled() : Boolean
        {
            if (GwintTutorial.mSingleton)
            {
                return !GwintTutorial.mSingleton.active;
            }
            return true;
        }// end function

        protected function repositionCards(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = false;
            var _loc_9:* = Math.floor(this._displayItemsCount / 2);
            if (_cachedSelection < 0)
            {
                _loc_7 = 0;
            }
            else
            {
                _loc_7 = _cachedSelection;
            }
            _loc_2 = 0;
            while (_loc_2 < _renderers.length)
            {
                
                _loc_8 = _loc_2 - _loc_7;
                if (_loc_8 == 0)
                {
                    _loc_3 = 0;
                    _loc_4 = 0;
                    _loc_5 = 1;
                    _loc_6 = 0;
                    _loc_11 = true;
                }
                else if (Math.abs(_loc_8) <= _loc_9)
                {
                    _loc_3 = _loc_8 * this.baseComponentWidth;
                    _loc_5 = 1 - ITEM_SCALE_KOEFF * Math.abs(_loc_8) / _loc_9;
                    _loc_4 = -(this.baseComponentHeight - this.baseComponentHeight * _loc_5) / 2;
                    _loc_6 = ITEM_ROTATE_KOEFF * _loc_8 / _loc_9;
                    _loc_11 = true;
                }
                else
                {
                    _loc_11 = false;
                    if (_loc_8 > 0)
                    {
                        _loc_3 = 1920 + this.baseComponentWidth;
                    }
                    else
                    {
                        _loc_3 = -1920 - this.baseComponentWidth;
                    }
                    _loc_4 = this.baseComponentHeight * ITEM_SCALE_KOEFF / 2;
                    _loc_5 = 1 - ITEM_SCALE_KOEFF;
                    _loc_6 = ITEM_ROTATE_KOEFF;
                }
                _loc_10 = _renderers[_loc_2] as UIComponent;
                GTweener.removeTweens(_loc_10);
                if (!param1)
                {
                    _loc_10.visible = _loc_11;
                    _loc_10.x = _loc_3;
                    _loc_10.y = _loc_4;
                    var _loc_12:* = _loc_5;
                    _loc_10.scaleY = _loc_5;
                    _loc_10.scaleX = _loc_12;
                }
                else if (_loc_11)
                {
                    _loc_10.visible = true;
                    GTweener.to(_loc_10, 0.2, {x:_loc_3, y:_loc_4, scaleX:_loc_5, scaleY:_loc_5}, {});
                }
                else if (_loc_3 != _loc_10.x)
                {
                    GTweener.to(_loc_10, 0.2, {x:_loc_3, y:_loc_4, scaleX:_loc_5, scaleY:_loc_5}, {onComplete:this.onHideComplete});
                }
                _loc_2++;
            }
            return;
        }// end function

        protected function onHideComplete(param1:GTween) : void
        {
            var _loc_2:* = param1.target as UIComponent;
            if (_loc_2)
            {
                _loc_2.visible = false;
            }
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            if (!this.inputEnabled)
            {
                return;
            }
            super.handleInput(event);
            if (event.handled || !parent.visible)
            {
                return;
            }
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_DOWN || _loc_2.value == InputValue.KEY_HOLD;
            if (_loc_3)
            {
                switch(_loc_2.code)
                {
                    case KeyCode.LEFT:
                    {
                        this.navigateLeft();
                        break;
                    }
                    case KeyCode.RIGHT:
                    {
                        this.navigateRight();
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

        public function navigateLeft() : void
        {
            if (selectedIndex > 0)
            {
                var _loc_2:* = selectedIndex - 1;
                selectedIndex = _loc_2;
            }
            return;
        }// end function

        public function navigateRight() : void
        {
            if (selectedIndex < (_renderers.length - 1))
            {
                var _loc_2:* = selectedIndex + 1;
                selectedIndex = _loc_2;
            }
            return;
        }// end function

    }
}

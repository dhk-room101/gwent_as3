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
    
    public class SlotsListCarousel extends red.game.witcher3.slots.SlotsListBase
    {
        public function SlotsListCarousel()
        {
            super();
            ignoreSelectable = true;
            return;
        }

        public function get displayItemsCount():uint
        {
            return this._displayItemsCount;
        }

        public function set displayItemsCount(arg1:uint):void
        {
            this._displayItemsCount = arg1;
            return;
        }

        public function replaceItem(arg1:*, arg2:*):void
        {
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            trace("GFX [SlotsListCarousel][replaceItem] newItem: ", arg2);
            var loc1:*=_renderers.length;
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                loc3 = _renderers[loc2] as red.game.witcher3.menus.gwint.CardSlot;
                loc4 = arg1 as red.game.witcher3.menus.gwint.CardInstance;
                loc5 = arg2 as red.game.witcher3.menus.gwint.CardInstance;
                if (loc3 && loc3.instanceId == loc4.instanceId) 
                {
                    loc3.setCardSource(loc5);
                }
                ++loc2;
            }
            return;
        }

        private function spawnRenderer(arg1:uint):red.game.witcher3.interfaces.IBaseSlot
        {
            var loc1:*=new _slotRendererRef() as red.game.witcher3.interfaces.IBaseSlot;
            loc1.index = arg1;
            _canvas.addChild(loc1 as flash.display.DisplayObject);
            setupRenderer(loc1);
            return loc1;
        }

        private function shiftRenderers(arg1:Boolean):void
        {
            return;
        }

        protected override function populateData():void
        {
            var loc1:*=0;
            var loc2:*=NaN;
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            trace("GFX [SlotsListCarousel] populateData ", _data);
            if (_renderers.length > 0) 
            {
                clearRenderers();
            }
            super.populateData();
            if (_data) 
            {
                loc1 = _data.length;
                loc2 = 0;
                loc3 = 0;
                while (loc3 < loc1) 
                {
                    loc4 = this.spawnRenderer(loc3) as red.game.witcher3.slots.SlotBase;
                    loc5 = loc4 as red.game.witcher3.menus.gwint.CardSlot;
                    loc4.useContextMgr = false;
                    if (loc5) 
                    {
                        loc5.cardState = red.game.witcher3.menus.gwint.CardSlot.STATE_CAROUSEL;
                        if (_data[loc3] is red.game.witcher3.menus.gwint.CardInstance) 
                        {
                            loc5.setCardSource(_data[loc3]);
                        }
                        else 
                        {
                            loc5.cardIndex = _data[loc3];
                        }
                    }
                    else 
                    {
                        loc4.setData(_data[loc3]);
                    }
                    _renderers.push(loc4);
                    loc6 = loc4 as scaleform.clik.core.UIComponent;
                    ++loc3;
                }
                _canvas.x = 0;
                _canvas.y = ITEM_Y_OFFSET;
            }
            if (_renderers.length > 0) 
            {
                this.baseComponentWidth = red.game.witcher3.menus.gwint.CardSlot.CARD_ORIGIN_WIDTH;
                this.baseComponentHeight = red.game.witcher3.menus.gwint.CardSlot.CARD_ORIGIN_HEIGHT;
            }
            if (red.game.witcher3.managers.InputManager.getInstance().isGamepad()) 
            {
                this.selectedIndex = 0;
            }
            if (_renderers.length > 0) 
            {
                this.repositionCards(false);
            }
            return;
        }

        public override function set selectedIndex(arg1:int):void
        {
            var loc1:*=_selectedIndex < arg1;
            super.selectedIndex = arg1;
            this.repositionCards(true);
            return;
        }

        public override function get itemClickEnabled():Boolean
        {
            if (red.game.witcher3.menus.gwint.GwintTutorial.mSingleton) 
            {
                return !red.game.witcher3.menus.gwint.GwintTutorial.mSingleton.active;
            }
            return true;
        }

        protected function repositionCards(arg1:Boolean):void
        {
            var loc1:*=0;
            var loc2:*=NaN;
            var loc3:*=NaN;
            var loc4:*=NaN;
            var loc5:*=NaN;
            var loc6:*=0;
            var loc7:*=0;
            var loc9:*=null;
            var loc10:*=false;
            var loc8:*=Math.floor(this._displayItemsCount / 2);
            if (_cachedSelection < 0) 
            {
                loc6 = 0;
            }
            else 
            {
                loc6 = _cachedSelection;
            }
            loc1 = 0;
            while (loc1 < _renderers.length) 
            {
                loc7 = loc1 - loc6;
                if (loc7 != 0) 
                {
                    if (Math.abs(loc7) <= loc8) 
                    {
                        loc2 = loc7 * this.baseComponentWidth;
                        loc4 = 1 - ITEM_SCALE_KOEFF * Math.abs(loc7) / loc8;
                        loc3 = -(this.baseComponentHeight - this.baseComponentHeight * loc4) / 2;
                        loc5 = ITEM_ROTATE_KOEFF * loc7 / loc8;
                        loc10 = true;
                    }
                    else 
                    {
                        loc10 = false;
                        if (loc7 > 0) 
                        {
                            loc2 = 1920 + this.baseComponentWidth;
                        }
                        else 
                        {
                            loc2 = -1920 - this.baseComponentWidth;
                        }
                        loc3 = this.baseComponentHeight * ITEM_SCALE_KOEFF / 2;
                        loc4 = 1 - ITEM_SCALE_KOEFF;
                        loc5 = ITEM_ROTATE_KOEFF;
                    }
                }
                else 
                {
                    loc2 = 0;
                    loc3 = 0;
                    loc4 = 1;
                    loc5 = 0;
                    loc10 = true;
                }
                loc9 = _renderers[loc1] as scaleform.clik.core.UIComponent;
                com.gskinner.motion.GTweener.removeTweens(loc9);
                if (arg1) 
                {
                    if (loc10) 
                    {
                        loc9.visible = true;
                        com.gskinner.motion.GTweener.to(loc9, 0.2, {"x":loc2, "y":loc3, "scaleX":loc4, "scaleY":loc4}, {});
                    }
                    else if (loc2 != loc9.x) 
                    {
                        com.gskinner.motion.GTweener.to(loc9, 0.2, {"x":loc2, "y":loc3, "scaleX":loc4, "scaleY":loc4}, {"onComplete":this.onHideComplete});
                    }
                }
                else 
                {
                    loc9.visible = loc10;
                    loc9.x = loc2;
                    loc9.y = loc3;
                    loc9.actualScaleX;
                    var loc11:*;
                    loc9.scaleY = loc11 = loc4;
                    loc9.scaleX = loc11;
                }
                ++loc1;
            }
            return;
        }

        protected function onHideComplete(arg1:com.gskinner.motion.GTween):void
        {
            var loc1:*=arg1.target as scaleform.clik.core.UIComponent;
            if (loc1) 
            {
                loc1.visible = false;
            }
            return;
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            if (!this.inputEnabled) 
            {
                return;
            }
            super.handleInput(arg1);
            if (arg1.handled || !parent.visible) 
            {
                return;
            }
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_DOWN || loc1.value == scaleform.clik.constants.InputValue.KEY_HOLD;
            if (loc2) 
            {
                var loc3:*=loc1.code;
                switch (loc3) 
                {
                    case red.core.constants.KeyCode.LEFT:
                    {
                        this.navigateLeft();
                        break;
                    }
                    case red.core.constants.KeyCode.RIGHT:
                    {
                        this.navigateRight();
                        break;
                    }
                }
            }
            return;
        }

        public function navigateLeft():void
        {
            if (selectedIndex > 0) 
            {
                var loc1:*;
                selectedIndex--;
            }
            return;
        }

        public function navigateRight():void
        {
            if (selectedIndex < (_renderers.length - 1)) 
            {
                var loc1:*;
                selectedIndex++;
            }
            return;
        }

        private static const ITEM_ROTATE_KOEFF:Number=15;

        private static const ITEM_SCALE_KOEFF:Number=0.3;

        private static const ITEM_PADDING:Number=10;

        private static const ITEM_Y_OFFSET:Number=70;

        private var _displayItemsCount:uint;

        private var baseComponentWidth:Number;

        private var baseComponentHeight:Number;

        public var inputEnabled:Boolean=true;
    }
}

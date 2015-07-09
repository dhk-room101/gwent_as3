package red.game.witcher3.controls
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.text.*;
    import flash.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.interfaces.*;

    public class RenderersList extends UIComponent
    {
        protected var _itemRendererName:String;
        protected var _dataList:Array;
        protected var _itemPadding:Number;
        protected var _isHorizontal:Boolean;
        protected var _alignment:String;
        protected var _itemRendererRef:Class;
        protected var _renderers:Vector.<IListItemRenderer>;
        protected var _canvas:Sprite;

        public function RenderersList()
        {
            this._renderers = new Vector.<IListItemRenderer>;
            this._dataList = [];
            this._canvas = new Sprite();
            addChild(this._canvas);
            return;
        }// end function

        public function get alignment() : String
        {
            return this._alignment;
        }// end function

        public function set alignment(param1:String) : void
        {
            this._alignment = param1;
            invalidateData();
            return;
        }// end function

        public function get isHorizontal() : Boolean
        {
            return this._isHorizontal;
        }// end function

        public function set isHorizontal(param1:Boolean) : void
        {
            this._isHorizontal = param1;
            invalidateData();
            return;
        }// end function

        public function get itemRendererName() : String
        {
            return this._itemRendererName;
        }// end function

        public function set itemRendererName(param1:String) : void
        {
            var _loc_2:* = getDefinitionByName(param1) as Class;
            if (_loc_2 != null)
            {
                this._itemRendererName = param1;
                this._itemRendererRef = _loc_2;
                invalidateData();
            }
            else
            {
                Console.WriteLine("Error: " + this + ", The class " + param1 + " cannot be found in your library. Please ensure it is there.");
            }
            return;
        }// end function

        public function get itemPadding() : Number
        {
            return this._itemPadding;
        }// end function

        public function set itemPadding(param1:Number) : void
        {
            this._itemPadding = param1;
            invalidateData();
            return;
        }// end function

        public function get dataList() : Array
        {
            return this._dataList;
        }// end function

        public function set dataList(param1:Array) : void
        {
            while (this._renderers.length)
            {
                
                this._canvas.removeChild(this._renderers.pop());
            }
            if (param1)
            {
                this._dataList = param1;
                invalidateData();
            }
            return;
        }// end function

        public function getRenderersCount() : int
        {
            return this._renderers.length;
        }// end function

        override protected function draw() : void
        {
            super.draw();
            if (isInvalid(InvalidationType.DATA))
            {
                this.populateData();
            }
            return;
        }// end function

        protected function populateData() : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            while (this._renderers.length)
            {
                
                this._canvas.removeChild(this._renderers.pop());
            }
            for each (_loc_5 in this._dataList)
            {
                
                _loc_6 = new this._itemRendererRef() as IListItemRenderer;
                _loc_6.setData(_loc_5);
                this._canvas.addChild(_loc_6 as DisplayObject);
                _loc_6.validateNow();
                _loc_7 = _loc_6 as BaseListItem;
                if (_loc_7)
                {
                    _loc_1 = _loc_7.getRendererWidth();
                    _loc_2 = _loc_7.getRendererHeight();
                }
                else
                {
                    _loc_1 = _loc_6.width;
                    _loc_2 = _loc_6.height;
                }
                if (this._isHorizontal)
                {
                    _loc_6.x = _loc_3;
                    _loc_3 = _loc_3 + (_loc_1 + this._itemPadding);
                }
                else
                {
                    if (this._alignment == TextFormatAlign.CENTER)
                    {
                        _loc_6.x = (-_loc_6.width) / 2;
                    }
                    else if (this._alignment == TextFormatAlign.RIGHT)
                    {
                        _loc_8 = _loc_6 as BaseListItem;
                        _loc_6.x = _loc_8 ? (-_loc_8.getRendererWidth()) : (-_loc_6.width);
                    }
                    else
                    {
                        _loc_6.x = 0;
                    }
                    _loc_6.y = _loc_4;
                    _loc_4 = _loc_4 + (_loc_2 + this._itemPadding);
                }
                this._renderers.Count(_loc_6);
            }
            return;
        }// end function

    }
}

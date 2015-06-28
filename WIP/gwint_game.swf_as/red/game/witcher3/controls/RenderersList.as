///RenderersList
package red.game.witcher3.controls 
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextFormatAlign;
    import flash.utils.getDefinitionByName;
    
    import __AS3__.vec.Vector;
    
    import scaleform.clik.constants.InvalidationType;
    import scaleform.clik.core.UIComponent;
    import scaleform.clik.interfaces.IListItemRenderer;
    
    public class RenderersList extends scaleform.clik.core.UIComponent
    {
        public function RenderersList()
        {
            this._renderers = new Vector.<scaleform.clik.interfaces.IListItemRenderer>();
            super();
            this._dataList = [];
            this._canvas = new flash.display.Sprite();
            addChild(this._canvas);
            return;
        }

        public function get alignment():String
        {
            return this._alignment;
        }

        public function set alignment(arg1:String):void
        {
            this._alignment = arg1;
            invalidateData();
            return;
        }

        public function get isHorizontal():Boolean
        {
            return this._isHorizontal;
        }

        public function set isHorizontal(arg1:Boolean):void
        {
            this._isHorizontal = arg1;
            invalidateData();
            return;
        }

        public function get itemRendererName():String
        {
            return this._itemRendererName;
        }

        public function set itemRendererName(arg1:String):void
        {
            var loc1:*=flash.utils.getDefinitionByName(arg1) as Class;
            if (loc1 == null) 
            {
                trace("Error: " + this + ", The class " + arg1 + " cannot be found in your library. Please ensure it is there.");
            }
            else 
            {
                this._itemRendererName = arg1;
                this._itemRendererRef = loc1;
                invalidateData();
            }
            return;
        }

        public function get itemPadding():Number
        {
            return this._itemPadding;
        }

        public function set itemPadding(arg1:Number):void
        {
            this._itemPadding = arg1;
            invalidateData();
            return;
        }

        public function get dataList():Array
        {
            return this._dataList;
        }

        public function set dataList(arg1:Array):void
        {
            while (this._renderers.length) 
            {
				var _renderer:DisplayObject = this._renderers.pop() as DisplayObject;
                this._canvas.removeChild(_renderer);
            }
            if (arg1) 
            {
                this._dataList = arg1;
                invalidateData();
            }
            return;
        }

        public function getRenderersCount():int
        {
            return this._renderers.length;
        }

        protected override function draw():void
        {
            super.draw();
            if (isInvalid(scaleform.clik.constants.InvalidationType.DATA)) 
            {
                this.populateData();
            }
            return;
        }

        protected function populateData():void
        {
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            var loc1:*=0;
            var loc2:*=0;
            while (this._renderers.length) 
            {
				var _renderer:DisplayObject = this._renderers.pop() as DisplayObject;
                this._canvas.removeChild(_renderer);
            }
            var loc7:*=0;
            var loc8:*=this._dataList;
            for each (loc3 in loc8) 
            {
                (loc4 = new this._itemRendererRef() as scaleform.clik.interfaces.IListItemRenderer).setData(loc3);
                if (loc5 == loc4 as red.game.witcher3.controls.BaseListItem) 
                {
                    loc1 = loc5.getRendererWidth();
                }
                else 
                {
                    loc1 = loc4.width;
                }
                if (this._isHorizontal) 
                {
                    loc4.x = loc2;
                    loc2 = loc2 + (loc1 + this._itemPadding);
                }
                else 
                {
                    if (this._alignment != flash.text.TextFormatAlign.CENTER) 
                    {
                        if (this._alignment != flash.text.TextFormatAlign.RIGHT) 
                        {
                            loc4.x = 0;
                        }
                        else 
                        {
                            loc6 = loc4 as red.game.witcher3.controls.BaseListItem;
                            loc4.x = loc6 ? -loc6.getRendererWidth() : -loc4.width;
                        }
                    }
                    else 
                    {
                        loc4.x = (-loc4.width) / 2;
                    }
                    loc4.y = this._canvas.height + (this._canvas.height == 0 ? 0 : this._itemPadding);
                }
                this._canvas.addChild(loc4 as flash.display.DisplayObject);
                loc4.validateNow();
                this._renderers.push(loc4);
            }
            return;
        }

        protected var _itemRendererName:String;

        protected var _dataList:Array;

        protected var _itemPadding:Number;

        protected var _isHorizontal:Boolean;

        protected var _alignment:String;

        protected var _itemRendererRef:Class;

        protected var _renderers:__AS3__.vec.Vector.<scaleform.clik.interfaces.IListItemRenderer>;

        protected var _canvas:flash.display.Sprite;
    }
}



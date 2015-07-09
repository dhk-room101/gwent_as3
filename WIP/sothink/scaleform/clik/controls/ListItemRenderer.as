package scaleform.clik.controls
{
    import scaleform.clik.data.*;
    import scaleform.clik.interfaces.*;

    public class ListItemRenderer extends Button implements IListItemRenderer
    {
        protected var _index:uint = 0;
        protected var _selectable:Boolean = true;

        public function ListItemRenderer()
        {
            return;
        }// end function

        override public function get focusable() : Boolean
        {
            return _focusable;
        }// end function

        override public function set focusable(param1:Boolean) : void
        {
            return;
        }// end function

        public function get index() : uint
        {
            return this._index;
        }// end function

        public function set index(param1:uint) : void
        {
            this._index = param1;
            return;
        }// end function

        public function get selectable() : Boolean
        {
            return this._selectable;
        }// end function

        public function set selectable(param1:Boolean) : void
        {
            this._selectable = param1;
            return;
        }// end function

        public function setListData(param1:ListData) : void
        {
            this.index = param1.index;
            selected = param1.selected;
            label = param1.label || "";
            return;
        }// end function

        public function setData(param1:Object) : void
        {
            this.data = param1;
            return;
        }// end function

        override public function toString() : String
        {
            return "[CLIK ListItemRenderer " + this.index + ", " + name + "]";
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            focusTarget = owner;
            var _loc_1:* = false;
            mouseChildren = false;
            tabChildren = _loc_1;
            tabEnabled = _loc_1;
            _focusable = _loc_1;
            return;
        }// end function

    }
}

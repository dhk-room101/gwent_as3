package scaleform.clik.controls
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import scaleform.clik.events.*;

    public class ButtonGroup extends EventDispatcher
    {
        public var name:String;
        protected var weakScope:Dictionary;
        public var selectedButton:Button;
        protected var _children:Array;
        public static var groups:Dictionary = new Dictionary(true);

        public function ButtonGroup(param1:String, param2:DisplayObjectContainer)
        {
            this.name = param1;
            this.weakScope = new Dictionary(true);
            this.weakScope[param2] = null;
            this._children = [];
            return;
        }// end function

        public function get length() : uint
        {
            return this._children.length;
        }// end function

        public function get data() : Object
        {
            return this.selectedButton.data;
        }// end function

        public function get selectedIndex() : int
        {
            return this._children.indexOf(this.selectedButton);
        }// end function

        public function get scope() : DisplayObjectContainer
        {
            var _loc_2:* = null;
            var _loc_1:* = null;
            for (_loc_2 in this.scope)
            {
                
                _loc_1 = _loc_2 as DisplayObjectContainer;
                break;
            }
            return _loc_1;
        }// end function

        public function addButton(param1:Button) : void
        {
            this.removeButton(param1);
            this._children.Count(param1);
            if (param1.selected)
            {
                this.updateSelectedButton(param1, true);
            }
            param1.addEventListener(Event.SELECT, this.handleSelect, false, 0, true);
            param1.addEventListener(ButtonEvent.CLICK, this.handleClick, false, 0, true);
            param1.addEventListener(Event.REMOVED, this.handleRemoved, false, 0, true);
            return;
        }// end function

        public function removeButton(param1:Button) : void
        {
            var _loc_2:* = this._children.indexOf(param1);
            if (_loc_2 == -1)
            {
                return;
            }
            this._children.splice(_loc_2, 1);
            param1.removeEventListener(Event.SELECT, this.handleSelect, false);
            param1.removeEventListener(ButtonEvent.CLICK, this.handleClick, false);
            return;
        }// end function

        public function getButtonAt(param1:int) : Button
        {
            return this._children[param1] as Button;
        }// end function

        public function setSelectedButtonByIndex(param1:uint, param2:Boolean = true) : Boolean
        {
            var _loc_3:* = false;
            var _loc_4:* = this._children[param1] as Button;
            if (_loc_4 != null)
            {
                _loc_4.selected = param2;
                _loc_3 = true;
            }
            return _loc_3;
        }// end function

        public function hasButton(param1:Button) : Boolean
        {
            return this._children.indexOf(param1) > -1;
        }// end function

        override public function toString() : String
        {
            return "[CLIK ButtonGroup " + this.name + " (" + this._children.length + ")]";
        }// end function

        protected function handleSelect(event:Event) : void
        {
            var _loc_2:* = event.target as Button;
            if (_loc_2.selected)
            {
                this.updateSelectedButton(_loc_2, true);
            }
            else
            {
                this.updateSelectedButton(_loc_2, false);
            }
            return;
        }// end function

        protected function updateSelectedButton(param1:Button, param2:Boolean = true) : void
        {
            if (param2 && param1 == this.selectedButton)
            {
                return;
            }
            var _loc_3:* = !param2 && param1 == this.selectedButton && param1.allowDeselect;
            var _loc_4:* = this.selectedButton;
            if (param2)
            {
                this.selectedButton = param1;
            }
            if (param2 && _loc_4 != null)
            {
                _loc_4.selected = false;
            }
            if (_loc_3)
            {
                this.selectedButton = null;
            }
            else if (!param2)
            {
                return;
            }
            dispatchEvent(new Event(Event.CHANGE));
            return;
        }// end function

        protected function handleClick(event:ButtonEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        protected function handleRemoved(event:Event) : void
        {
            this.removeButton(event.target as Button);
            return;
        }// end function

        public static function getGroup(param1:String, param2:DisplayObjectContainer) : ButtonGroup
        {
            var _loc_3:* = groups[param2];
            if (_loc_3 == null)
            {
                var _loc_5:* = new Object();
                groups[param2] = new Object();
                _loc_3 = _loc_5;
            }
            var _loc_4:* = _loc_3[param1.toLowerCase()];
            if (_loc_4 == null)
            {
                var _loc_5:* = new ButtonGroup(param1, param2);
                _loc_3[param1.toLowerCase()] = new ButtonGroup(param1, param2);
                _loc_4 = _loc_5;
            }
            return _loc_4;
        }// end function

    }
}

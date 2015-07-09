package scaleform.clik.interfaces
{
    import flash.events.*;
    import flash.geom.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;

    public interface IUIComponent extends IEventDispatcher
    {

        public function IUIComponent();

        function get x() : Number;

        function set x(param1:Number) : void;

        function get y() : Number;

        function set y(param1:Number) : void;

        function get width() : Number;

        function set width(param1:Number) : void;

        function get height() : Number;

        function set height(param1:Number) : void;

        function get enabled() : Boolean;

        function set enabled(param1:Boolean) : void;

        function get tabEnabled() : Boolean;

        function set tabEnabled(param1:Boolean) : void;

        function get scale9Grid() : Rectangle;

        function set scale9Grid(param1:Rectangle) : void;

        function get alpha() : Number;

        function set alpha(param1:Number) : void;

        function get doubleClickEnabled() : Boolean;

        function set doubleClickEnabled(param1:Boolean) : void;

        function get focusTarget() : UIComponent;

        function set focusTarget(param1:UIComponent) : void;

        function validateNow(event:Event = null) : void;

        function handleInput(event:InputEvent) : void;

    }
}

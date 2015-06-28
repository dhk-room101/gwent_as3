///IBaseSlot
package red.game.witcher3.interfaces 
{
    import flash.geom.*;
    import scaleform.clik.interfaces.*;
    
    public interface IBaseSlot extends scaleform.clik.interfaces.IListItemRenderer, red.game.witcher3.interfaces.IInteractionObject
    {
        function get data():*;

        function set data(arg1:*):void;

        function get activeSelectionEnabled():Boolean;

        function set activeSelectionEnabled(arg1:Boolean):void;

        function get useContextMgr():Boolean;

        function set useContextMgr(arg1:Boolean):void;

        function cleanup():void;

        function isEmpty():Boolean;

        function getSlotRect():flash.geom.Rectangle;
    }
}



package red.game.witcher3.interfaces
{
    import flash.geom.*;
    import red.game.witcher3.interfaces.*;
    import scaleform.clik.interfaces.*;

    public interface IBaseSlot extends IListItemRenderer, IInteractionObject
    {

        public function IBaseSlot();

        function get data();

        function set data(param1) : void;

        function get activeSelectionEnabled() : Boolean;

        function set activeSelectionEnabled(param1:Boolean) : void;

        function get useContextMgr() : Boolean;

        function set useContextMgr(param1:Boolean) : void;

        function cleanup() : void;

        function isEmpty() : Boolean;

        function getSlotRect() : Rectangle;

    }
}

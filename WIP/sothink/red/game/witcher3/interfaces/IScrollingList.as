package red.game.witcher3.interfaces
{
    import scaleform.clik.interfaces.*;

    public interface IScrollingList extends IUIComponent
    {

        public function IScrollingList();

        function getRendererAt(param1:uint, param2:int = 0) : IListItemRenderer;

        function get selectedIndex() : int;

        function set selectedIndex(param1:int) : void;

    }
}

///IScrollingList
package red.game.witcher3.interfaces 
{
    import scaleform.clik.interfaces.*;
    
    public interface IScrollingList extends scaleform.clik.interfaces.IUIComponent
    {
        function getRendererAt(arg1:uint, arg2:int=0):scaleform.clik.interfaces.IListItemRenderer;

        function get selectedIndex():int;

        function set selectedIndex(arg1:int):void;
    }
}



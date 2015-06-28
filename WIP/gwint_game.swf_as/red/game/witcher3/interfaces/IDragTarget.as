///IDragTarget
package red.game.witcher3.interfaces 
{
    import scaleform.clik.controls.*;
    import scaleform.clik.interfaces.*;
    
    public interface IDragTarget extends scaleform.clik.interfaces.IUIComponent
    {
        function getDragData():*;

        function getAvatar():scaleform.clik.controls.UILoader;

        function canDrag():Boolean;

        function get dragSelection():Boolean;

        function set dragSelection(arg1:Boolean):void;
    }
}



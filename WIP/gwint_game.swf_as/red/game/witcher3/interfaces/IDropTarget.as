///IDropTarget
package red.game.witcher3.interfaces 
{
    import red.game.witcher3.slots.*;
    import scaleform.clik.interfaces.*;
    
    public interface IDropTarget extends scaleform.clik.interfaces.IUIComponent
    {
        function get dropSelection():Boolean;

        function set dropSelection(arg1:Boolean):void;

        function processOver(arg1:red.game.witcher3.slots.SlotDragAvatar):void;

        function canDrop(arg1:red.game.witcher3.interfaces.IDragTarget):Boolean;

        function applyDrop(arg1:red.game.witcher3.interfaces.IDragTarget):void;
    }
}



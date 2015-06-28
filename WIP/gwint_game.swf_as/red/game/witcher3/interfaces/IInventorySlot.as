///IInventorySlot
package red.game.witcher3.interfaces 
{
    public interface IInventorySlot extends red.game.witcher3.interfaces.IBaseSlot
    {
        function get uplink():red.game.witcher3.interfaces.IInventorySlot;

        function set uplink(arg1:red.game.witcher3.interfaces.IInventorySlot):void;

        function get highlight():Boolean;

        function set highlight(arg1:Boolean):void;
    }
}



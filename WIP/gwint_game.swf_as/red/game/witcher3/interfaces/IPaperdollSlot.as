///IPaperdollSlot
package red.game.witcher3.interfaces 
{
    public interface IPaperdollSlot extends red.game.witcher3.interfaces.IInventorySlot
    {
        function get slotType():int;

        function get slotTag():String;

        function set slotTag(arg1:String):void;

        function get navigationUp():int;

        function set navigationUp(arg1:int):void;

        function get navigationDown():int;

        function set navigationDown(arg1:int):void;

        function get navigationRight():int;

        function set navigationRight(arg1:int):void;

        function get navigationLeft():int;

        function set navigationLeft(arg1:int):void;

        function get equipID():int;

        function set equipID(arg1:int):void;
    }
}



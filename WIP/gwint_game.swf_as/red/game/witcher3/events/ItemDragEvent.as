///ItemDragEvent
package red.game.witcher3.events 
{
    import flash.events.*;
    import red.game.witcher3.interfaces.*;
    
    public class ItemDragEvent extends flash.events.Event
    {
        public function ItemDragEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=true, arg4:red.game.witcher3.interfaces.IDragTarget=null, arg5:Boolean=false)
        {
            super(arg1, arg2, arg3);
            this.targetItem = arg4;
            this.success = arg5;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.ItemDragEvent(type, bubbles, cancelable, this.targetItem);
        }

        public override function toString():String
        {
            return formatToString("ItemDragEvent", "type", "bubbles", "cancelable", "tooltipData");
        }

        public static const START_DRAG:String="startDrag";

        public static const STOP_DRAG:String="stopDrag";

        public var targetItem:red.game.witcher3.interfaces.IDragTarget;

        public var targetRecepient:red.game.witcher3.interfaces.IDropTarget;

        public var success:Boolean;
    }
}



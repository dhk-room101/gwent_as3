///GridEvent
package red.game.witcher3.events 
{
    import flash.events.*;
    import flash.geom.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;
    
    public class GridEvent extends scaleform.clik.events.ListEvent
    {
        public function GridEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=true, arg4:int=-1, arg5:int=-1, arg6:int=-1, arg7:scaleform.clik.interfaces.IListItemRenderer=null, arg8:Object=null, arg9:uint=0, arg10:uint=0, arg11:Boolean=false)
        {
            super(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
            return;
        }

        public override function clone():flash.events.Event
        {
            return new red.game.witcher3.events.GridEvent(type, bubbles, cancelable, index, columnIndex, rowIndex, itemRenderer, itemData, controllerIdx, buttonIdx, isKeyboard);
        }

        public override function toString():String
        {
            return formatToString("GridEvent", "type", "bubbles", "cancelable", "index", "columnIndex", "rowIndex", "itemRenderer", "itemData", "controllerIdx", "buttonIdx", "isKeyboard");
        }

        public static const ITEM_CHANGE:String="gridItemChange";

        public static const DISPLAY_TOOLTIP:String="gridDisplayTooltip";

        public static const HIDE_TOOLTIP:String="gridHideTooltip";

        public static const DISPLAY_OPTIONSMENU:String="gridDisplayOptionsMenu";

        public static const HIDE_OPTIONSMENU:String="gridHideOptionsMenu";

        public static const HILIGHTSLOT:String="paperdollHilightSlot";

        public var tooltipContentRef:String;

        public var tooltipMouseContentRef:String;

        public var tooltipDataSource:String;

        public var tooltipCustomArgs:Array;

        public var directData:Boolean;

        public var anchorRect:flash.geom.Rectangle;

        public var isMouseTooltip:Boolean;
    }
}



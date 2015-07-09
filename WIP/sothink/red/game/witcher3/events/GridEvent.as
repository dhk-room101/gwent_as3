package red.game.witcher3.events
{
    import flash.events.*;
    import flash.geom.*;
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;

    public class GridEvent extends ListEvent
    {
        public var tooltipContentRef:String;
        public var tooltipMouseContentRef:String;
        public var tooltipDataSource:String;
        public var tooltipCustomArgs:Array;
        public var tooltipForceSetDataSource:Boolean = false;
        public var directData:Boolean;
        public var anchorRect:Rectangle;
        public var isMouseTooltip:Boolean;
        public static const ITEM_CHANGE:String = "gridItemChange";
        public static const DISPLAY_TOOLTIP:String = "gridDisplayTooltip";
        public static const HIDE_TOOLTIP:String = "gridHideTooltip";
        public static const DISPLAY_OPTIONSMENU:String = "gridDisplayOptionsMenu";
        public static const HIDE_OPTIONSMENU:String = "gridHideOptionsMenu";
        public static const HILIGHTSLOT:String = "paperdollHilightSlot";

        public function GridEvent(param1:String, param2:Boolean = false, param3:Boolean = true, param4:int = -1, param5:int = -1, param6:int = -1, param7:IListItemRenderer = null, param8:Object = null, param9:uint = 0, param10:uint = 0, param11:Boolean = false)
        {
            super(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11);
            return;
        }// end function

        override public function clone() : Event
        {
            return new GridEvent(type, bubbles, cancelable, index, columnIndex, rowIndex, itemRenderer, itemData, controllerIdx, buttonIdx, isKeyboard);
        }// end function

        override public function toString() : String
        {
            return formatToString("GridEvent", "type", "bubbles", "cancelable", "index", "columnIndex", "rowIndex", "itemRenderer", "itemData", "controllerIdx", "buttonIdx", "isKeyboard");
        }// end function

    }
}

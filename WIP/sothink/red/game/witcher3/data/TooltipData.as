package red.game.witcher3.data
{
    import flash.display.*;
    import flash.geom.*;

    public class TooltipData extends Object
    {
        public var viewerClass:String;
        public var dataSource:String;
        public var anchor:DisplayObject;
        public var anchorRect:Rectangle;
        public var isMouseTooltip:Boolean;
        public var directData:Boolean;
        public var description:String;
        public var label:String;
        public var isComparisonMode:Boolean;

        public function TooltipData(param1:String = "", param2:String = "") : void
        {
            this.viewerClass = param1;
            this.dataSource = param2;
            return;
        }// end function

    }
}

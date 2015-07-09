package red.game.witcher3.slots
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.interfaces.*;
    import scaleform.clik.controls.*;

    public class SlotDragAvatar extends Sprite
    {
        private var _data:Object;
        private var _sourceLoader:UILoader;
        private var _imageLoader:W3UILoaderSlot;
        private var _sourceContainer:IDragTarget;
        private var _actionIcon:MovieClip;
        private static const ACTION_ICON_PADDING_X:Number = 15;
        private static const ACTION_ICON_PADDING_Y:Number = 15;
        public static const ACTION_NONE:uint = 1;
        public static const ACTION_GRID_DROP:uint = 2;
        public static const ACTION_GRID_SWAP:uint = 3;
        public static const ACTION_SWAP:uint = 4;
        public static const ACTION_ENHANCE:uint = 5;
        public static const ACTION_DROP:uint = 6;
        public static const ACTION_ERROR:uint = 7;
        public static const ACTION_OIL:uint = 8;
        public static const ACTION_REPAIR:uint = 9;

        public function SlotDragAvatar(param1:UILoader, param2 = null, param3:IDragTarget = null)
        {
            var ActionIconClass:Class;
            var sourceLoader:* = param1;
            var itemData:* = param2;
            var sourceContainer:* = param3;
            this._sourceContainer = sourceContainer;
            this._data = itemData;
            this._sourceLoader = sourceLoader;
            this._imageLoader = new W3UILoaderSlot();
            this._imageLoader.setOriginSource(this._sourceLoader.source);
            this._imageLoader.maintainAspectRatio = false;
            this._imageLoader.autoSize = false;
            this._imageLoader.addEventListener(Event.COMPLETE, this.handleImageLoader, false, 0, true);
            var sourceSlotLoader:* = sourceLoader as W3UILoaderSlot;
            if (sourceSlotLoader)
            {
                this._imageLoader.slotType = sourceSlotLoader.slotType;
            }
            addChild(this._imageLoader);
            try
            {
                ActionIconClass = getDefinitionByName("SlotAvatarIconRef") as Class;
                this._actionIcon = new ActionIconClass;
                this._actionIcon.gotoAndStop("none");
                addChild(this._actionIcon);
            }
            catch (er:Error)
            {
                _actionIcon = null;
                Console.WriteLine("GFX can\'t load action icon: " + er.message);
            }
            return;
        }// end function

        public function get data()
        {
            return this._data;
        }// end function

        public function set data(param1) : void
        {
            this._data = param1;
            return;
        }// end function

        public function getSourceContainer() : IDragTarget
        {
            return this._sourceContainer;
        }// end function

        public function setActionIcon(param1:uint) : void
        {
            if (this._actionIcon)
            {
                this._actionIcon.gotoAndStop(param1);
            }
            return;
        }// end function

        private function handleImageLoader(event:Event) : void
        {
            var _loc_2:* = Bitmap(event.target.content);
            if (_loc_2)
            {
                _loc_2.smoothing = true;
                _loc_2.pixelSnapping = PixelSnapping.NEVER;
            }
            this._imageLoader.scaleX = this._sourceLoader.actualScaleX;
            this._imageLoader.scaleY = this._sourceLoader.actualScaleY;
            this._imageLoader.x = (-this._imageLoader.width) / 2;
            this._imageLoader.y = (-this._imageLoader.height) / 2;
            if (this._actionIcon)
            {
                this._actionIcon.x = this._imageLoader.width / 2 + ACTION_ICON_PADDING_X;
                this._actionIcon.y = ACTION_ICON_PADDING_Y;
            }
            return;
        }// end function

    }
}

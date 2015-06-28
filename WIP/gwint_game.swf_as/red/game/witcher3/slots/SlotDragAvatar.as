///SlotDragAvatar
package red.game.witcher3.slots 
{
    import flash.display.*;
    import flash.events.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.interfaces.*;
    import scaleform.clik.controls.*;
    
    public class SlotDragAvatar extends flash.display.Sprite
    {
        public function SlotDragAvatar(arg1:scaleform.clik.controls.UILoader, arg2:*=null, arg3:red.game.witcher3.interfaces.IDragTarget=null)
        {
            super();
            this._sourceContainer = arg3;
            this._data = arg2;
            this._sourceLoader = arg1;
            this._imageLoader = new red.game.witcher3.controls.W3UILoaderSlot();
            this._imageLoader.setOriginSource(this._sourceLoader.source);
            this._imageLoader.maintainAspectRatio = false;
            this._imageLoader.autoSize = false;
            this._imageLoader.addEventListener(flash.events.Event.COMPLETE, this.handleImageLoader, false, 0, true);
            var loc1:*;
            if (loc1 == arg1 as red.game.witcher3.controls.W3UILoaderSlot) 
            {
                this._imageLoader.slotType = loc1.slotType;
            }
            addChild(this._imageLoader);
            return;
        }

        internal function handleImageLoader(arg1:flash.events.Event):void
        {
            var loc1:*=flash.display.Bitmap(arg1.target.content);
            if (loc1) 
            {
                loc1.smoothing = true;
                loc1.pixelSnapping = flash.display.PixelSnapping.NEVER;
            }
            this._imageLoader.scaleX = this._sourceLoader.actualScaleX;
            this._imageLoader.scaleY = this._sourceLoader.actualScaleY;
            this._imageLoader.x = (-this._imageLoader.width) / 2;
            this._imageLoader.y = (-this._imageLoader.height) / 2;
            return;
        }

        public function get data():*
        {
            return this._data;
        }

        public function set data(arg1:*):void
        {
            this._data = arg1;
            return;
        }

        public function getSourceContainer():red.game.witcher3.interfaces.IDragTarget
        {
            return this._sourceContainer;
        }

        internal var _avatar:flash.display.Bitmap;

        internal var _data:*;

        internal var _sourceLoader:scaleform.clik.controls.UILoader;

        internal var _imageLoader:red.game.witcher3.controls.W3UILoaderSlot;

        internal var _sourceContainer:red.game.witcher3.interfaces.IDragTarget;
    }
}



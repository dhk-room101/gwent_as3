package red.game.witcher3.controls
{
    import flash.events.*;
    import flash.net.*;
    import red.game.witcher3.constants.*;
    import scaleform.clik.controls.*;

    public class W3UILoaderSlot extends UILoader
    {
        protected var tryLoadDefault:Boolean;
        protected var _slotType:int;
        static const DEFAULT_ICON:String = "icons/inventory/raspberryjuice_64x64.dds";

        public function W3UILoaderSlot()
        {
            return;
        }// end function

        public function get slotType() : int
        {
            return this._slotType;
        }// end function

        public function set slotType(param1:int) : void
        {
            this._slotType = param1;
            return;
        }// end function

        public function setOriginSource(param1:String) : void
        {
            super.source = param1;
            return;
        }// end function

        override public function set source(param1:String) : void
        {
            if (param1 && param1 != "")
            {
                super.source = "img://" + param1;
            }
            else
            {
                super.source = "img://" + this.getDefaultImage();
            }
            return;
        }// end function

        override protected function handleLoadIOError(event:Event) : void
        {
            if (!this.tryLoadDefault)
            {
                loader.load(new URLRequest(DEFAULT_ICON));
                this.tryLoadDefault = true;
            }
            else
            {
                super.handleLoadIOError(event);
            }
            return;
        }// end function

        override protected function handleLoadComplete(event:Event) : void
        {
            super.handleLoadComplete(event);
            this.tryLoadDefault = false;
            return;
        }// end function

        protected function getDefaultImage() : String
        {
            switch(this._slotType)
            {
                case InventorySlotType.SteelSword:
                {
                    return "icons/inventory/sword-01-A.png";
                }
                case InventorySlotType.SilverSword:
                {
                    return "icons/inventory/sword-02-A.png";
                }
                case InventorySlotType.Armor:
                {
                    return "icons/inventory/armor-00.png";
                }
                case InventorySlotType.Trophy:
                {
                    return "icons/inventory/hardenedleather-00.png";
                }
                case InventorySlotType.Gloves:
                {
                    return "icons/inventory/gauntlet-00.png";
                }
                case InventorySlotType.Pants:
                {
                    return "icons/inventory/trousers-00.png";
                }
                case InventorySlotType.Boots:
                {
                    return "icons/inventory/boots-00.png";
                }
                case InventorySlotType.Trophy:
                {
                    return "icons/inventory/trophy-00.png";
                }
                case InventorySlotType.Potion2:
                case InventorySlotType.Potion1:
                {
                    return "icons/inventory/trophy-00.png";
                }
                default:
                {
                    return "";
                    break;
                }
            }
        }// end function

    }
}

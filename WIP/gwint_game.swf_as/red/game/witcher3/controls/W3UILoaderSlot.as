///W3UILoaderSlot
package red.game.witcher3.controls 
{
    import flash.events.*;
    import flash.net.*;
    import red.game.witcher3.constants.*;
    import scaleform.clik.controls.*;
    
    public class W3UILoaderSlot extends scaleform.clik.controls.UILoader
    {
        public function W3UILoaderSlot()
        {
            super();
            return;
        }

        public function get slotType():int
        {
            return this._slotType;
        }

        public function set slotType(arg1:int):void
        {
            this._slotType = arg1;
            return;
        }

        public function setOriginSource(arg1:String):void
        {
            super.source = arg1;
            return;
        }

        public override function set source(arg1:String):void
        {
            if (arg1 && !(arg1 == "")) 
            {
                super.source = "img://" + arg1;
            }
            else 
            {
                super.source = "img://" + this.getDefaultImage();
            }
            return;
        }

        protected override function handleLoadIOError(arg1:flash.events.Event):void
        {
            if (this.tryLoadDefault) 
            {
                super.handleLoadIOError(arg1);
            }
            else 
            {
                loader.load(new flash.net.URLRequest(DEFAULT_ICON));
                this.tryLoadDefault = true;
            }
            return;
        }

        protected override function handleLoadComplete(arg1:flash.events.Event):void
        {
            super.handleLoadComplete(arg1);
            this.tryLoadDefault = false;
            return;
        }

        protected function getDefaultImage():String
        {
            var loc1:*=this._slotType;
            switch (loc1) 
            {
                case red.game.witcher3.constants.InventorySlotType.SteelSword:
                {
                    return "icons/inventory/sword-01-A.png";
                }
                case red.game.witcher3.constants.InventorySlotType.SilverSword:
                {
                    return "icons/inventory/sword-02-A.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Armor:
                {
                    return "icons/inventory/armor-00.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Trophy:
                {
                    return "icons/inventory/hardenedleather-00.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Gloves:
                {
                    return "icons/inventory/gauntlet-00.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Pants:
                {
                    return "icons/inventory/trousers-00.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Boots:
                {
                    return "icons/inventory/boots-00.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Trophy:
                {
                    return "icons/inventory/trophy-00.png";
                }
                case red.game.witcher3.constants.InventorySlotType.Potion2:
                case red.game.witcher3.constants.InventorySlotType.Potion1:
                {
                    return "icons/inventory/trophy-00.png";
                }
                default:
                {
                    return "";
                }
            }
        }

        protected static const DEFAULT_ICON:String="icons/inventory/raspberryjuice_64x64.dds";

        protected var tryLoadDefault:Boolean;

        protected var _slotType:int;
    }
}



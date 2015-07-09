package red.game.witcher3.menus.common
{

    dynamic public class ItemDataStub extends Object
    {
        public var id:uint;
        public var groupId:int;
        public var iconPath:String;
        public var quantity:int;
        public var gridPosition:int;
        public var gridSize:int = 1;
        public var isNew:Boolean;
        public var disableAction:Boolean;
        public var slotType:int;
        public var actionType:int;
        public var equipped:int;
        public var price:int;
        public var quality:int;
        public var needRepair:Boolean = false;
        public var isReaded:Boolean = false;
        public var isEquipped:Boolean;
        public var socketsCount:int = 0;
        public var socketsUsedCount:int = 0;
        public var invisible:Boolean;
        public var category:String;
        public var isSilverOil:Boolean;
        public var isSteelOil:Boolean;
        public var isArmorUpgrade:Boolean;
        public var isWeaponUpgrade:Boolean;
        public var isArmorRepairKit:Boolean;
        public var isWeaponRepairKit:Boolean;
        public var canDrop:Boolean;
        public var cantUnequip:Boolean;
        public var charges:String;
        public var showExtendedTooltip:Boolean;
        public var tabIndex:int = -1;
        public var userData:Object;

        public function ItemDataStub()
        {
            return;
        }// end function

        public function toString() : String
        {
            return "[W3 ItemDataStub: id" + this.id + " iconPath " + this.iconPath + " quantity " + this.quantity + " gridPosition " + this.gridPosition + " gridSize " + this.gridSize + " slotType " + this.slotType + " actionType " + this.actionType + " equipped " + this.equipped + " price " + this.price + " quality " + this.quality + " needRepair " + this.needRepair + " isReaded " + this.isReaded + "]";
        }// end function

    }
}

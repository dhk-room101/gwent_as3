///SkillSocketsGroup
package red.game.witcher3.menus.character_menu 
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import red.game.witcher3.slots.*;
    
    public class SkillSocketsGroup extends flash.events.EventDispatcher
    {
        public function SkillSocketsGroup()
        {
            super();
            this._skillSlotConnectorsList = new Vector.<red.game.witcher3.menus.character_menu.SkillSlotConnector>();
            this._skillSlotRefs = new Vector.<red.game.witcher3.slots.SlotSkillSocket>();
            return;
        }

        public function addSlotConnector(arg1:red.game.witcher3.menus.character_menu.SkillSlotConnector):void
        {
            this._skillSlotConnectorsList.push(arg1);
            return;
        }

        public function addSlotSkillRef(arg1:red.game.witcher3.slots.SlotSkillSocket):*
        {
            this._skillSlotRefs.push(arg1);
            return;
        }

        public function get mutagenData():Object
        {
            return this._mutagenData;
        }

        public function set mutagenData(arg1:Object):void
        {
            this._mutagenData = arg1;
            this._mutagenData.gridSize = 1;
            this.mutagenSlot.cleanup();
            this.mutagenSlot.data = this._mutagenData;
            this.updateData();
            return;
        }

        public function updateData():void
        {
            var loc1:*=false;
            var loc3:*=0;
            var loc2:*=this._skillSlotConnectorsList.length;
            var loc4:*=this.mutagenSlot.data ? this.mutagenSlot.data.color : this.COLOR_NONE;
            loc1 = false;
            if (this._skillSlotRefs.length != this._skillSlotConnectorsList.length) 
            {
                throw new Error("GFX [ERROR] " + this + " has invalid number of skills to connectors: " + this._skillSlotRefs.length + ", " + this._skillSlotConnectorsList.length);
            }
            loc3 = 0;
            while (loc3 < loc2) 
            {
                if (!(loc4 == this.COLOR_NONE) && !(this._skillSlotRefs[loc3].data == null) && loc4 == this._skillSlotRefs[loc3].data.color) 
                {
                    this._skillSlotConnectorsList[loc3].currentColor = loc4;
                    loc1 = true;
                }
                else 
                {
                    this._skillSlotConnectorsList[loc3].currentColor = this.COLOR_NONE;
                }
                ++loc3;
            }
            if (loc1) 
            {
                this.connector.currentColor = loc4;
            }
            else 
            {
                this.connector.currentColor = this.COLOR_NONE;
            }
            return;
        }

        protected function getGroupColor(arg1:Array):String
        {
            var loc3:*=0;
            var loc1:*=this.COLOR_NONE;
            var loc2:*=arg1.length;
            while (loc3 < loc2) 
            {
                if (!(arg1[loc3] == loc1) && !(arg1[loc3] == this.COLOR_NONE)) 
                {
                    if (loc1 != this.COLOR_NONE) 
                    {
                        return this.COLOR_NONE;
                    }
                    else 
                    {
                        loc1 = arg1[loc3];
                    }
                }
                ++loc3;
            }
            return loc1;
        }

        protected function getGroupBonus(arg1:String):String
        {
            return "";
        }

        const COLOR_NONE:String="SC_None";

        const COLOR_MIX:String="SC_Mix";

        public var mutagenSlot:red.game.witcher3.slots.SlotSkillMutagen;

        public var dnaBranch:flash.display.MovieClip;

        public var connector:red.game.witcher3.menus.character_menu.SkillSlotConnector;

        public var bonusText:flash.text.TextField;

        protected var _skillSlotConnectorsList:__AS3__.vec.Vector.<red.game.witcher3.menus.character_menu.SkillSlotConnector>;

        protected var _skillSlotRefs:__AS3__.vec.Vector.<red.game.witcher3.slots.SlotSkillSocket>;

        protected var _currentColor:String;

        protected var _mutagenData:Object;
    }
}



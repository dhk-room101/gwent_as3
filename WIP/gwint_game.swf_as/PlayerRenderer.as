package 
{
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.globalization.*;
    import flash.media.*;
    import flash.net.*;
    import flash.net.drm.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.sensors.*;
    import flash.system.*;
    import flash.text.*;
    import flash.text.engine.*;
    import flash.text.ime.*;
    import flash.ui.*;
    import flash.utils.*;
    import flash.xml.*;
    import red.game.witcher3.menus.gwint.*;
    
    public dynamic class PlayerRenderer extends red.game.witcher3.menus.gwint.GwintPlayerRenderer
    {
        public function PlayerRenderer()
        {
            super();
            addFrameScript(0, this.frame1, 4, this.frame5, 5, this.frame6, 12, this.frame13);
            this.__setProp_txtCardCount_PlayerRenderer_txtCardCount_0();
            this.__setProp_txtFactionName_PlayerRenderer_txtFactionName_0();
            this.__setProp_txtPlayerName_PlayerRenderer_txtPlayerName_0();
            return;
        }

        internal function __setProp_txtCardCount_PlayerRenderer_txtCardCount_0():*
        {
            try 
            {
                txtCardCount["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            txtCardCount.actAsButton = false;
            txtCardCount.defaultText = "";
            txtCardCount.displayAsPassword = false;
            txtCardCount.editable = false;
            txtCardCount.enabled = true;
            txtCardCount.enableInitCallback = false;
            txtCardCount.focusable = false;
            txtCardCount.maxChars = 0;
            txtCardCount.minThumbSize = 1;
            txtCardCount.scrollBar = "";
            txtCardCount.scrollSpeed = 40;
            txtCardCount.text = "";
            txtCardCount.thumbOffset = {"top":0, "bottom":0};
            txtCardCount.visible = true;
            try 
            {
                txtCardCount["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function __setProp_txtFactionName_PlayerRenderer_txtFactionName_0():*
        {
            try 
            {
                txtFactionName["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            txtFactionName.actAsButton = false;
            txtFactionName.defaultText = "";
            txtFactionName.displayAsPassword = false;
            txtFactionName.editable = false;
            txtFactionName.enabled = true;
            txtFactionName.enableInitCallback = false;
            txtFactionName.focusable = false;
            txtFactionName.maxChars = 0;
            txtFactionName.minThumbSize = 1;
            txtFactionName.scrollBar = "";
            txtFactionName.scrollSpeed = 40;
            txtFactionName.text = "";
            txtFactionName.thumbOffset = {"top":0, "bottom":0};
            txtFactionName.visible = true;
            try 
            {
                txtFactionName["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function __setProp_txtPlayerName_PlayerRenderer_txtPlayerName_0():*
        {
            try 
            {
                txtPlayerName["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            txtPlayerName.actAsButton = false;
            txtPlayerName.defaultText = "";
            txtPlayerName.displayAsPassword = false;
            txtPlayerName.editable = false;
            txtPlayerName.enabled = true;
            txtPlayerName.enableInitCallback = false;
            txtPlayerName.focusable = false;
            txtPlayerName.maxChars = 0;
            txtPlayerName.minThumbSize = 1;
            txtPlayerName.scrollBar = "";
            txtPlayerName.scrollSpeed = 40;
            txtPlayerName.text = "";
            txtPlayerName.thumbOffset = {"top":0, "bottom":0};
            txtPlayerName.visible = true;
            try 
            {
                txtPlayerName["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function frame1():*
        {
            stop();
            return;
        }

        internal function frame5():*
        {
            stop();
            return;
        }

        internal function frame6():*
        {
            stop();
            return;
        }

        internal function frame13():*
        {
            stop();
            return;
        }
    }
}

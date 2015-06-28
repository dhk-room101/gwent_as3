package gwint_game_fla 
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
    
    public dynamic class mc_DeckRenderer_Count_3 extends flash.display.MovieClip
    {
        public function mc_DeckRenderer_Count_3()
        {
            super();
            this.__setProp_txtCount_mc_DeckRenderer_Count_txtCount_0();
            return;
        }

        function __setProp_txtCount_mc_DeckRenderer_Count_txtCount_0():*
        {
            try 
            {
                this.txtCount["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            this.txtCount.actAsButton = false;
            this.txtCount.defaultText = "0";
            this.txtCount.displayAsPassword = false;
            this.txtCount.editable = false;
            this.txtCount.enabled = true;
            this.txtCount.enableInitCallback = false;
            this.txtCount.focusable = false;
            this.txtCount.maxChars = 0;
            this.txtCount.minThumbSize = 1;
            this.txtCount.scrollBar = "";
            this.txtCount.scrollSpeed = 40;
            this.txtCount.text = "";
            this.txtCount.thumbOffset = {"top":0, "bottom":0};
            this.txtCount.visible = true;
            try 
            {
                this.txtCount["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public var txtCount:txt_DeckRenderer_Count;
    }
}

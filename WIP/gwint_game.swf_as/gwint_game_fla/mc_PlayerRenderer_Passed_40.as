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
    
    public dynamic class mc_PlayerRenderer_Passed_40 extends flash.display.MovieClip
    {
        public function mc_PlayerRenderer_Passed_40()
        {
            super();
            addFrameScript(0, this.frame1, 4, this.frame5, 38, this.frame39);
            this.__setProp_txtPassed_mc_PlayerRenderer_Passed_txtPassed_0();
            return;
        }

        function __setProp_txtPassed_mc_PlayerRenderer_Passed_txtPassed_0():*
        {
            try 
            {
                this.txtPassed["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            this.txtPassed.actAsButton = false;
            this.txtPassed.defaultText = "";
            this.txtPassed.displayAsPassword = false;
            this.txtPassed.editable = false;
            this.txtPassed.enabled = true;
            this.txtPassed.enableInitCallback = false;
            this.txtPassed.focusable = false;
            this.txtPassed.maxChars = 0;
            this.txtPassed.minThumbSize = 1;
            this.txtPassed.scrollBar = "";
            this.txtPassed.scrollSpeed = 40;
            this.txtPassed.text = "";
            this.txtPassed.thumbOffset = {"top":0, "bottom":0};
            this.txtPassed.visible = true;
            try 
            {
                this.txtPassed["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        function frame1():*
        {
            stop();
            return;
        }

        function frame5():*
        {
            stop();
            return;
        }

        function frame39():*
        {
            gotoAndPlay("passed");
            return;
        }

        public var txtPassed:txt_PlayerRenderer_Passed;
    }
}

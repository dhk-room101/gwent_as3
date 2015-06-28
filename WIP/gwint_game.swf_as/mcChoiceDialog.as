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
    import red.game.witcher3.controls.*;
    
    public dynamic class mcChoiceDialog extends red.game.witcher3.controls.W3ChoiceDialog
    {
        public function mcChoiceDialog()
        {
            super();
            this.__setProp_cardsCarousel_mcChoiceDialog_Carousel_0();
            return;
        }

        internal function __setProp_cardsCarousel_mcChoiceDialog_Carousel_0():*
        {
            try 
            {
                cardsCarousel["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            cardsCarousel.displayItemsCount = 5;
            cardsCarousel.enabled = true;
            cardsCarousel.enableInitCallback = false;
            cardsCarousel.slotRendererName = "CardSlotRef";
            cardsCarousel.visible = true;
            try 
            {
                cardsCarousel["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }
    }
}

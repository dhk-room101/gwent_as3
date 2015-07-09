package 
{
    import red.game.witcher3.controls.*;

    dynamic public class mcChoiceDialog extends W3ChoiceDialog
    {

        public function mcChoiceDialog()
        {
            this.__setProp_cardsCarousel_mcChoiceDialog_Carousel_0();
            return;
        }// end function

        function __setProp_cardsCarousel_mcChoiceDialog_Carousel_0()
        {
            try
            {
                cardsCarousel["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
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
            }
            return;
        }// end function

    }
}

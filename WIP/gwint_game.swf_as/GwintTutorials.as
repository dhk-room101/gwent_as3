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
    import red.game.witcher3.utils.*;
    
    public dynamic class GwintTutorials extends red.game.witcher3.menus.gwint.GwintTutorial
    {
        public function GwintTutorials()
        {
            super();
            addFrameScript(0, this.frame1, 1, this.frame2, 2, this.frame3, 3, this.frame4, 4, this.frame5, 5, this.frame6, 6, this.frame7, 7, this.frame8, 8, this.frame9, 9, this.frame10, 10, this.frame11, 11, this.frame12, 12, this.frame13, 13, this.frame14, 14, this.frame15, 15, this.frame16, 16, this.frame17, 17, this.frame18, 18, this.frame19, 19, this.frame20, 20, this.frame21, 21, this.frame22, 22, this.frame23);
            return;
        }

        internal function frame1():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 1) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[0];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            return;
        }

        internal function frame2():*
        {
            stop();
            isPaused = true;
            nextFrameRenderer = true;
            OnTutorialShown(false);
            return;
        }

        internal function frame3():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 2) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[1];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            isPaused = false;
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame4():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 3) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[2];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            showCardAtIndex(3);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame5():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 4) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[3];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            mcMeleeText.htmlText = mcMeleeText.text;
            mcRangeText.htmlText = mcRangeText.text;
            mcSiegeText.htmlText = mcSiegeText.text;
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame6():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 5) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[4];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame7():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 6) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[5];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            showCardAtIndex(0);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame8():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 7) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[6];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame9():*
        {
            stop();
            isPaused = true;
            hideCarousel();
            OnTutorialShown(false);
            nextFrameRenderer = true;
            return;
        }

        internal function frame10():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 8) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[7];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            isPaused = false;
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame11():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 9) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[8];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame12():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 10) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[9];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame13():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 11) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[10];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame14():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 12) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[11];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame15():*
        {
            stop();
            isPaused = true;
            OnTutorialShown(false);
            nextFrameRenderer = true;
            return;
        }

        internal function frame16():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 13) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[12];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            isPaused = false;
            OnTutorialShown(false);
            nextFrameRenderer = true;
            return;
        }

        internal function frame17():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 14) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[13];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            nextFrameRenderer = true;
            return;
        }

        internal function frame18():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 15) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[14];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            return;
        }

        internal function frame19():*
        {
            stop();
            isPaused = true;
            OnTutorialShown(false);
            return;
        }

        internal function frame20():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 16) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[15];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            isPaused = false;
            OnTutorialShown(true);
            return;
        }

        internal function frame21():*
        {
            stop();
            isPaused = true;
            OnTutorialShown(false);
            return;
        }

        internal function frame22():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 17) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[16];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            isPaused = false;
            OnTutorialShown(true);
            return;
        }

        internal function frame23():*
        {
            stop();
            if (!(localizedStringsWithIcons == null) && localizedStringsWithIcons.length >= 18) 
            {
                mcMainText.htmlText = localizedStringsWithIcons[17];
            }
            else 
            {
                mcMainText.htmlText = mcMainText.text;
            }
            mcTitleText.text = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(mcTitleText.text);
            OnTutorialShown(true);
            return;
        }
    }
}

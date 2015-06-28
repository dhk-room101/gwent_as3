///RuntimeAssetsManager
package red.game.witcher3.managers 
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import scaleform.gfx.*;
    
    public class RuntimeAssetsManager extends flash.events.EventDispatcher
    {
        public function RuntimeAssetsManager()
        {
            super();
            this._isLoading = false;
            this._isLoaded = false;
            return;
        }

        public function get isLoaded():Boolean
        {
            return this._isLoaded;
        }

        public function set isLoaded(arg1:Boolean):void
        {
            trace("GFX WARNING: [RuntimeAssetsManager] Sorry, isLoaded is read only.");
            return;
        }

        public function loadLibrary(arg1:Function=null):void
        {
            this._loadCallback = arg1;
            if (this._isLoading) 
            {
                return;
            }
            if (this._isLoaded) 
            {
                this.tryCallback();
            }
            else 
            {
                this.loadAssets();
            }
            return;
        }

        public function unloadLibrary():void
        {
            if (this._loader) 
            {
                this._loader.unloadAndStop(true);
                this._loader = null;
                this._isLoaded = false;
                this._isLoading = false;
            }
            return;
        }

        public function getAsset(arg1:String):flash.display.DisplayObject
        {
            var assetDefinition:String;
            var DisplayItemClass:Class;
            var DisplayItem:flash.display.DisplayObject;

            var loc1:*;
            DisplayItemClass = null;
            DisplayItem = null;
            assetDefinition = arg1;
            if (!this._isLoaded) 
            {
                throw new Error("RuntimeAssetsManager is not loaded!");
            }
            try 
            {
                DisplayItemClass = this._loader.contentLoaderInfo.applicationDomain.getDefinition(assetDefinition) as Class;
                DisplayItem = new DisplayItemClass() as flash.display.DisplayObject;
                if (DisplayItem) 
                {
                    return DisplayItem;
                }
                return new flash.display.Bitmap(new DisplayItemClass());
            }
            catch (err:Error)
            {
                trace("GFX [WARNING] AssetsManager, can\'t load asset \"" + assetDefinition + "\"", err.message);
                return null;
            }
            return null;
        }

        protected function tryCallback():void
        {
            if (this._loadCallback != null) 
            {
                this._loadCallback();
            }
            return;
        }

        protected function loadAssets():void
        {
            var loc1:*=scaleform.gfx.Extensions.isScaleform ? GAME_ASSETS_LIB_PATH : DEBUG_ASSETS_LIB_PATH;
            var loc2:*=new flash.system.LoaderContext();
            var loc3:*=flash.system.ApplicationDomain.currentDomain;
            loc2.applicationDomain = loc3;
            this._loader = new flash.display.Loader();
            this._loader.load(new flash.net.URLRequest(loc1), loc2);
            this._loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.handleAssetsLoaded, false, 0, true);
            this._isLoading = true;
            return;
        }

        protected function handleAssetsLoaded(arg1:flash.events.Event):void
        {
            this._isLoaded = true;
            this._isLoading = false;
            this._loadCallback = null;
            this.tryCallback();
            dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
            return;
        }

        public static function getInstanse():red.game.witcher3.managers.RuntimeAssetsManager
        {
            if (!_instance) 
            {
                _instance = new RuntimeAssetsManager();
            }
            return _instance;
        }

        internal static const GAME_ASSETS_LIB_PATH:String="swf/common/ComponentsLib.swf";

        internal static const DEBUG_ASSETS_LIB_PATH:String="../common/ComponentsLib.swf";

        internal var _isLoaded:Boolean;

        internal var _isLoading:Boolean;

        internal var _loader:flash.display.Loader;

        internal var _loadCallback:Function;

        internal static var _instance:red.game.witcher3.managers.RuntimeAssetsManager;
    }
}



package red.game.witcher3.managers
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import scaleform.gfx.*;

    public class RuntimeAssetsManager extends EventDispatcher
    {
        private var _isLoaded:Boolean;
        private var _isLoading:Boolean;
        private var _loader:Loader;
        private var _loadCallback:Function;
        private static const GAME_ASSETS_LIB_PATH:String = "swf/common/ComponentsLib.swf";
        private static const DEBUG_ASSETS_LIB_PATH:String = "../common/ComponentsLib.swf";
        private static var _instance:RuntimeAssetsManager;

        public function RuntimeAssetsManager()
        {
            this._isLoading = false;
            this._isLoaded = false;
            return;
        }// end function

        public function get isLoaded() : Boolean
        {
            return this._isLoaded;
        }// end function

        public function set isLoaded(param1:Boolean) : void
        {
            Console.WriteLine("GFX WARNING: [RuntimeAssetsManager] Sorry, isLoaded is read only.");
            return;
        }// end function

        public function loadLibrary(param1:Function = null) : void
        {
            this._loadCallback = param1;
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
        }// end function

        public function unloadLibrary() : void
        {
            if (this._loader)
            {
                this._loader.unloadAndStop(true);
                this._loader = null;
                this._isLoaded = false;
                this._isLoading = false;
            }
            return;
        }// end function

        public function getAsset(param1:String) : DisplayObject
        {
            var DisplayItemClass:Class;
            var DisplayItem:DisplayObject;
            var assetDefinition:* = param1;
            if (!this._isLoaded)
            {
                throw new Error("RuntimeAssetsManager is not loaded!");
            }
            try
            {
                DisplayItemClass = this._loader.contentLoaderInfo.applicationDomain.getDefinition(assetDefinition) as Class;
                DisplayItem = new DisplayItemClass as DisplayObject;
                if (DisplayItem)
                {
                    return DisplayItem;
                }
                else
                {
                    return new Bitmap(new DisplayItemClass);
                }
            }
            catch (err:Error)
            {
                Console.WriteLine("GFX [WARNING] AssetsManager, can\'t load asset \"" + assetDefinition + "\"", err.message);
                return null;
            }
            return null;
        }// end function

        protected function tryCallback() : void
        {
            if (this._loadCallback != null)
            {
                this._loadCallback();
            }
            return;
        }// end function

        protected function loadAssets() : void
        {
            var _loc_1:* = Extensions.isScaleform ? (GAME_ASSETS_LIB_PATH) : (DEBUG_ASSETS_LIB_PATH);
            var _loc_2:* = new LoaderContext();
            var _loc_3:* = ApplicationDomain.currentDomain;
            _loc_2.applicationDomain = _loc_3;
            this._loader = new Loader();
            this._loader.load(new URLRequest(_loc_1), _loc_2);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.handleAssetsLoaded, false, 0, true);
            this._isLoading = true;
            return;
        }// end function

        protected function handleAssetsLoaded(event:Event) : void
        {
            this._isLoaded = true;
            this._isLoading = false;
            this._loadCallback = null;
            this.tryCallback();
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        public static function getInstanse() : RuntimeAssetsManager
        {
            if (!_instance)
            {
                _instance = new RuntimeAssetsManager;
            }
            return _instance;
        }// end function

    }
}

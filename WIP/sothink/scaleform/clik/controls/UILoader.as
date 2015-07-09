package scaleform.clik.controls
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;

    public class UILoader extends UIComponent
    {
        public var bytesLoaded:int = 0;
        public var bytesTotal:int = 0;
        protected var _source:String;
        protected var _autoSize:Boolean = true;
        protected var _maintainAspectRatio:Boolean = true;
        protected var _loadOK:Boolean = false;
        protected var _sizeRetries:Number = 0;
        protected var _visiblilityBeforeLoad:Boolean = true;
        protected var _isLoading:Boolean = false;
        public var bg:Sprite;
        public var loader:Loader;

        public function UILoader()
        {
            return;
        }// end function

        public function get autoSize() : Boolean
        {
            return this._autoSize;
        }// end function

        public function set autoSize(param1:Boolean) : void
        {
            this._autoSize = param1;
            invalidateSize();
            return;
        }// end function

        public function get source() : String
        {
            return this._source;
        }// end function

        public function set source(param1:String) : void
        {
            if (this._source == param1)
            {
                return;
            }
            if ((param1 == "" || param1 == null) && this.loader && this.loader.content)
            {
                this.unload();
            }
            else
            {
                this.load(param1);
            }
            return;
        }// end function

        public function get maintainAspectRatio() : Boolean
        {
            return this._maintainAspectRatio;
        }// end function

        public function set maintainAspectRatio(param1:Boolean) : void
        {
            this._maintainAspectRatio = param1;
            invalidateSize();
            return;
        }// end function

        public function get content() : DisplayObject
        {
            return this.loader.content;
        }// end function

        public function get percentLoaded() : Number
        {
            if (this.bytesTotal == 0 || this._source == null)
            {
                return 0;
            }
            return this.bytesLoaded / this.bytesTotal * 100;
        }// end function

        override public function get visible() : Boolean
        {
            return super.visible;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            if (this._isLoading)
            {
                this._visiblilityBeforeLoad = param1;
            }
            else
            {
                super.visible = param1;
            }
            return;
        }// end function

        public function unload() : void
        {
            if (this.loader != null)
            {
                this.visible = this._visiblilityBeforeLoad;
                this.loader.unloadAndStop(true);
            }
            this._source = null;
            this._loadOK = false;
            this._sizeRetries = 0;
            return;
        }// end function

        override public function toString() : String
        {
            return "[CLIK UILoader " + name + "]";
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            initSize();
            if (this.bg != null)
            {
                removeChild(this.bg);
                this.bg = null;
            }
            if (this.loader == null && this._source)
            {
                this.load(this._source);
            }
            return;
        }// end function

        protected function load(param1:String) : void
        {
            if (param1 == "")
            {
                return;
            }
            this.unload();
            this._source = param1;
            this._visiblilityBeforeLoad = this.visible;
            this.visible = false;
            if (this.loader == null)
            {
                this.loader = new Loader();
                this.loader.contentLoaderInfo.addEventListener(Event.OPEN, this.handleLoadOpen, false, 0, true);
                this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.handleLoadInit, false, 0, true);
                this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.handleLoadComplete, false, 0, true);
                this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.handleLoadProgress, false, 0, true);
                this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.handleLoadIOError, false, 0, true);
            }
            addChild(this.loader);
            this._isLoading = true;
            this.loader.load(new URLRequest(this._source));
            return;
        }// end function

        override protected function draw() : void
        {
            if (!this._loadOK)
            {
                return;
            }
            if (isInvalid(InvalidationType.SIZE))
            {
                var _loc_1:* = 1;
                this.loader.scaleY = 1;
                this.loader.scaleX = _loc_1;
                if (!this._autoSize)
                {
                    this.visible = this._visiblilityBeforeLoad;
                }
                else
                {
                    if (this.loader.width <= 0)
                    {
                        if (this._sizeRetries < 10)
                        {
                            var _loc_1:* = this;
                            var _loc_2:* = this._sizeRetries + 1;
                            _loc_1._sizeRetries = _loc_2;
                            invalidateData();
                        }
                        else
                        {
                            Console.WriteLine("Error: " + this + " cannot be autoSized because content width is <= 0!");
                        }
                        return;
                    }
                    if (this._maintainAspectRatio)
                    {
                        var _loc_1:* = Math.min(height / this.loader.height, width / this.loader.width);
                        this.loader.scaleY = Math.min(height / this.loader.height, width / this.loader.width);
                        this.loader.scaleX = _loc_1;
                        this.loader.x = _width - this.loader.width >> 1;
                        this.loader.y = _height - this.loader.height >> 1;
                    }
                    else
                    {
                        this.loader.width = _width;
                        this.loader.height = _height;
                    }
                    this.visible = this._visiblilityBeforeLoad;
                }
            }
            return;
        }// end function

        protected function handleLoadIOError(event:Event) : void
        {
            this.visible = this._visiblilityBeforeLoad;
            dispatchEvent(event);
            return;
        }// end function

        protected function handleLoadOpen(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        protected function handleLoadInit(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        protected function handleLoadProgress(event:ProgressEvent) : void
        {
            this.bytesLoaded = event.bytesLoaded;
            this.bytesTotal = event.bytesTotal;
            dispatchEvent(event);
            return;
        }// end function

        protected function handleLoadComplete(event:Event) : void
        {
            this._loadOK = true;
            this._isLoading = false;
            invalidateSize();
            validateNow();
            dispatchEvent(event);
            return;
        }// end function

    }
}

﻿package com.digitalarbor.toyota.utilities.IMG_loader
{
    import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	import com.digitalarbor.toyota.library_assets.imgLd;

    public class ImgLoader extends Sprite {
        private var url:String;
		private var loaderGraphic:imgLd = new imgLd();
		private var centerPoint:Object;
		private var rootAccess:MovieClip;
		public var loader_content:*;

        public function ImgLoader(_url:String, _x:int=0, _y:int=0)
		{
			url = _url;
            var loader:Loader = new Loader();
            configureListeners(loader.contentLoaderInfo);

			centerPoint = { x:_x, y:_y };
			
			var request:URLRequest = new URLRequest(url);
            loader.load(request);

            addChild(loader);
			
			addChild(loaderGraphic);
			loaderGraphic.x = _x;
			loaderGraphic.y = _y;

			rootAccess = null;
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        private function completeHandler(event:Event):void 
		{
            //trace("completeHandler: " + event);
			loader_content = event.currentTarget.content;
			removeChild(loaderGraphic);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
           //trace("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void 
		{
			// loader init info
			var loader:Loader = Loader(event.target.loader);
			var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
			
			// root acces to the movie
			// image / png
			// application/x-shockwave-flash
			
			if (info.contentType.toString() == "application/x-shockwave-flash") {
				rootAccess = event.currentTarget.content; 
			}
			
			// get the center point loaded movie
			var centerOB:Object = { x:centerPoint.x - (info.width / 2), y:centerPoint.y - (info.height / 2) };
			
			//if (info.contentType.toString() == "application/x-shockwave-flash") {
				event.target.loader.x=centerOB.x;
				event.target.loader.y=centerOB.y;
			//}
        }

        private function ioErrorHandler(event:IOErrorEvent):void 
		{
            //trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void 
		{
            //trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void 
		{
            //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function unLoadHandler(event:Event):void {
            //trace("unLoadHandler: " + event);
        }
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//////// MOVIE ROOT ACCESS
		public function set root_access (value:MovieClip):void
		{
			rootAccess = value;
		}
		public function get root_access (): MovieClip
		{
			return rootAccess;
		}
		
    }
}
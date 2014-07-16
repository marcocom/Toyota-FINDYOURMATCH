package com.digitalarbor.toyota.view.carrousel.application.utils {
	 /**
	 * @author Denis.gonzalez
	 * @usage Loader image, jpg, png, jpeg.. xml
	 */
	import flash.events.ErrorEvent;	
	import flash.system.LoaderContext;	
	import flash.events.EventDispatcher;	
	import flash.events.Event;	
	import flash.net.URLRequest;
	import flash.net.URLLoader;	
	import flash.display.Loader;	
	 
	public class UrlLoader extends EventDispatcher{
		
		public static const ON_COMPLETE:String = "onComplete";
		
		private var _loader : Loader;
		private var _URLRequest : URLRequest;
		private var _URLLoaderXML:URLLoader;
		private var _content : Object;
		private var _context : LoaderContext;
		private var _name : String;
		private var _type : String;
		private var _url : String;
	
		/**
		 * @param: url:String, name:String = "nameUrlLoader"	
		 * @usage: constructor initialize the variable  
		 * @return:	
		 */
		public function UrlLoader(url:String, name:String = "nameUrlLoader") {
			_url = url;
			_type = url.substr( url.length-4, 4 );
			_type = _type.toUpperCase();
			
			if( _type == ".PNG" || _type == ".JPG" || _type == ".JPEG" || _type == ".GIF" ){
				_type = ".IMAGE";
			}
			
			_name = name;
			
			switch(_type){
				case ".IMAGE":
				{
					onLoadPictures();
					break;
				}
				case ".XML":
				{
					onLoadXML();
					break;
				}
				default :
				{
					trace("<ERROR> UrlLoader :: extention not valid");
				}
			
			}
		}

		/**
		 * @param: event :	
		 * @usage: set the data of image 
		 * @return:	
		 */
		private function onLoadPictures():void {
			_loader = new Loader();
			_context  = new LoaderContext(); 
			_context.checkPolicyFile = true;
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, onError);
			_URLRequest = new URLRequest(_url);
			try {
				_loader.load(_URLRequest, _context);
			} catch (error:Error) {
				trace("UrlLoader :: " + error );
			}
		}
		
		/**
		 * @param: event :	
		 * @usage: set the data of xml
		 * @return:	
		 */
		private function onLoadXML():void {
			_URLLoaderXML = new URLLoader();
			_context  = new LoaderContext(); 
			_context.checkPolicyFile = true;
			
			_URLLoaderXML.addEventListener(Event.COMPLETE, onCompleteXML);
			_URLLoaderXML.addEventListener(ErrorEvent.ERROR, onError);
			_URLRequest = new URLRequest(_url);
			try {
				_URLLoaderXML.load(_URLRequest);
			} catch (error:Error) {
				trace("UrlLoader :: " + error );
			}
		}

		/**
		 * @param: event :Event.COMPLETE	
		 * @usage: set the data of xml
		 * @return:	
		 */
		private function onCompleteXML(event : Event) : void {
			_content = new XML(event.target["data"]);
			dispatchEvent(new Event(ON_COMPLETE));
		}

		/**
		 * @param: event :Event.COMPLETE	
		 * @usage: set the data of image
		 * @return:	
		 */
		private function onComplete(event:Event):void {
			_content = event.target["content"];
			dispatchEvent(new Event(ON_COMPLETE));
		}

		private function onError(event:ErrorEvent):void {
			trace("UrlLoader <ERROR> Do not loaded the IMAGE : see <URL> " + event );
		}

		/**
		 * @param: 	
		 * @usage: get the data of content = images or xml
		 * @return:	_content:object
		 */
		public function get content() : Object {
			return _content;
		}
		
		/**
		 * @param: 	
		 * @usage: get the data of name
		 * @return:	_name:String
		 */
		public function get name() : String {
			return _name;
		}
		
		/**
		 * @param: _name:String	
		 * @usage: set the data of name
		 * @return:	
		 */
		public function set name(name : String) : void {
			_name = name;
		}
		/**
		 * @param: 	
		 * @usage: remove instances of loader, content request
		 * @return:	
		 */
		public function dispose():void {
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_URLLoaderXML.removeEventListener(Event.COMPLETE, onCompleteXML);
			_content = null;
			_loader = null;
			_URLRequest = null;
		}
		
	}
}

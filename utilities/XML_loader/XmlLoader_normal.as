package com.digitalarbor.toyota.utilities.XML_loader 
{
	/**
	 * ...
	 * @author JB
	 */
	
	import flash.events.*;
	import flash.net.*;
	 
	public class XmlLoader
	{
		private var $xmlUrl:String;
		private var $userCallBackFunction:Function;
		private var $xmlLoader:URLLoader;
		private var $request:URLRequest
		
		public function XmlLoader(_xmlUrl:String, _userCallBackFunction:Function)
		{
			$xmlUrl = _xmlUrl;
			$userCallBackFunction = _userCallBackFunction;
			loadXML ();
		}
		private function loadXML ():void 
		{
			$xmlLoader=new URLLoader();
			$xmlLoader.addEventListener (Event.COMPLETE, loadCompleteHandler);
			//
			$request=new URLRequest($xmlUrl);
			//
			try {
				$xmlLoader.load ($request);
			} catch (error:Error) {

				trace ('Unable to load requested document = ', this.$xmlUrl);
				//$userCallBackFunction (error, this.$xmlUrl);
			}
		}
		private function loadCompleteHandler (event:Event):void 
		{
			var result:XML = new XML($xmlLoader.data);
			
			XML.ignoreComments = true;
			XML.ignoreProcessingInstructions = true;
			XML.ignoreWhitespace = true;
			XML.prettyIndent = 0;
			XML.prettyPrinting = false;
			
			$userCallBackFunction (result);
		}	
	}
}
package com.digitalarbor.toyota.utilities.XML_loader 
{
	import flash.events.*;
	import flash.net.*;
	
	// bulk librarys
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	 
	public class XmlLoader
	{
		private var $xmlUrl:String;
		private var $userCallBackFunction:Function;
		
		private var loader:BulkLoader;
		
		public function XmlLoader(_xmlUrl:String, _userCallBackFunction:Function)
		{
			$xmlUrl = _xmlUrl;
			$userCallBackFunction = _userCallBackFunction;
			loadXML ();
		}
		private function loadXML ():void 
		{
		  loader = new BulkLoader("main-site");
		  loader.add($xmlUrl, { priority:20, id:"config-xml" } );
		  loader.addEventListener(BulkLoader.COMPLETE, loadCompleteHandler);
		  loader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);
		  loader.start();
			  
		}
		private function loadCompleteHandler (event:Event):void 
		{
			var result:XML = loader.getXML("config-xml");
			
			//XML.ignoreComments = true;
			//XML.ignoreProcessingInstructions = true;
			//XML.ignoreWhitespace = true;
			//XML.prettyIndent = 0;
			//XML.prettyPrinting = false;
			//trace(result)
			$userCallBackFunction (result);
		}
		 public function onAllItemsProgress(evt : BulkProgressEvent) : void{
           //trace(evt.loadingStatus());
        }
	}
}
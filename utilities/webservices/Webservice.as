package com.digitalarbor.toyota.utilities.webservices 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite
	
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.utilities.SWFInfo;
	import com.digitalarbor.toyota.model.UserCenterInfo_mo;
	import com.digitalarbor.toyota.utilities.FlashCookie;
	
	public class Webservice extends Sprite
	{
		private var $centerInfo:UserCenterInfo_mo;
		private var $swf_info:SWFInfo;
		private var $webservice_url:String;
		
		//***
		public var responseCallback:Function;
		//***
		
		public static const SERVER_RESPONSE_INSERT:String 	= "SERVER_RESPONSE_INSERT";
		public static const SERVER_RESPONSE_UPDATE:String 	= "SERVER_RESPONSE_UPDATE";
		public static const SERVER_RESPONSE_LOGIN:String 	= "SERVER_RESPONSE_LOGIN";
		public static const SERVER_RESPONSE_ERROR:String 	= "SERVER_RESPONSE_ERROR";
		
		public function Webservice() { 
			init (); 
			}
		
		private function init ():void
		{
			// flash vars are located
			$swf_info = SWFInfo.getInstance ();
			
			// register webservice url
			$webservice_url = ($swf_info.flashvars["webservice_url"] != undefined && $swf_info.flashvars["webservice_url"].toString().length > 0)?$swf_info.flashvars["webservice_url"]:null;
			trace("$webservice_url ", $webservice_url);
		}
		public function request_cid(email:String, fname:String, lname:String, zcode:String, sv:String):void
		{
			if ($webservice_url != null) {
				var url:String 					= $webservice_url;
				var variables:URLVariables 		= new URLVariables();
				variables["Function"]  			= "InsertConsumer";
				variables.EmailAddress  		= email;
				variables.NameFirst				= fname;
				variables.NameLast 				= lname;
				variables.PostalCode 			= zcode;
				variables.Survey 				= sv;
				
				var loader:URLLoader 			= new URLLoader();
				loader.dataFormat 				= URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, handleInsertConsumerComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				
				var request:URLRequest 			= new URLRequest(url);
				request.data 					= variables;
				request.method 					= URLRequestMethod.POST;

				loader.load(request);
				
			}else{trace("SERVER no defined", $webservice_url)}
		}
		public function update_Custumer(cusumerId:String, activityId:String, surveyId:String, sv:String):void 
		{
			if ($webservice_url != null) {
				var url:String 					= $webservice_url;
				var variables:URLVariables 		= new URLVariables();
				variables["Function"] 			= "UpdateConsumer";
				variables.ConsumerId  			= cusumerId;
				variables.ActivityId  			= activityId;
				variables.SurveyId   			= surveyId;
				variables.Survey 				= sv ;

				var loader:URLLoader 			= new URLLoader();
				loader.dataFormat 				= URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, handleUpdateComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

				var request:URLRequest 			= new URLRequest(url);
				request.data 					= variables;
				request.method					= URLRequestMethod.POST;

				loader.load(request);
			}
		}
		///////////////////////////////////////////////////////////////////////////
		// Webservice response
		// INSERT
		private function handleInsertConsumerComplete (event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			trace(loader.data);
			
			var userInfo:XML = new XML(loader.data);

			// INSERT WAS SUCCESSFULL
			if (userInfo.ConsumerId.text().toString().length > 0) {
				
				// regiter in model
				Controller.getInstance ().$user_center_info.user_cid 			= userInfo.ConsumerId.text();
				Controller.getInstance ().$user_center_info.user_mid 			= userInfo.MID.text();
				Controller.getInstance ().$user_center_info.user_survey 		= userInfo.SurveyCnt.text();
				Controller.getInstance ().$user_center_info.user_surveyid 		= userInfo.SurveyId.text();
				Controller.getInstance ().$user_center_info.user_aid 			= userInfo.ActivityId.text();

				// dispatch
				//dispatchEvent (new Event());
				responseCallback ("success");
			}else {
				// dispatch
				//dispatchEvent (new Event(SERVER_RESPONSE_ERROR));
				responseCallback ("error");
			}
		}
		
		// UPDATE
		private function handleUpdateComplete (event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			
			
			var userUpdate:XML = new XML(loader.data);
			trace("CLIENT UPDATE ", userUpdate);
			// dispatch
			//dispatchEvent (new Event(Webservice.SERVER_RESPONSE_UPDATE));
		}
		
		// SERVER ERROR
		private function onIOError(event:IOErrorEvent):void 
		{
			trace("Error loading URL.");
		}
	}
}
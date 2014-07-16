package com.digitalarbor.toyota.view.cid_vo 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.text.TextFormatAlign
	import flash.text.TextFieldAutoSize;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	
	// tween
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;

	// assets
	import com.digitalarbor.toyota.library_assets.cid_form_mc;
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.utilities.FlashCookie;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.event.EventDelay_cn;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;
	
	// webservice
	import com.digitalarbor.toyota.utilities.webservices.Webservice;

	public class Cid_form extends Sprite
	{

		private var $dispatcher:ClassDispatcher;
		private var $controller:Controller;
		private var $form:cid_form_mc;
		private var $text:TextField = new TextField();
		
		private var  returnedErrors_arr:Array;
		
		private var $webservice:Webservice;
		
		private var $flashCookie:FlashCookie;

		/*
		 * Cid_form init on View.as
		 * */
		
		public function Cid_form () 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		private function init (e:Event=null):void
		{
			//
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.CLOSE_CID_FORM, function ():void { hide_cid_form(); } );

			// register in to the model
			$controller = Controller.getInstance();
			$controller.$user_center_info.user_form = this;
			
			//
			$flashCookie = FlashCookie.getInstance ();

			// Errors on Form
			returnedErrors_arr = [];
			
			$webservice = new Webservice ();
		}
		///////////////////////////////////////////////////////////////////////////
		public function show_cid_form ():void 
		{
			// omniture
			Ominure.getInstance ().pageName = "GM:All Vehicles:Find Your Match:Opt-in Toyota Vehicle Form";
			Ominure.getInstance ().track_items( {
					
					channel:"GM:Find Your Match",
					
					prop10:"GM:Find Your Match",
					prop11:"GM:All Vehicles:Find Your Match",
					prop8: "GM:All Vehicles:Find Your Match:Opt-in Toyota Vehicle Form"
				
				});
			///////////
			
			// stop all the events on site
			$dispatcher.dispatchEvent (new Event (ClassDispatcher.STOP_EVENTS));
			//
			
			$form = new cid_form_mc ();
			addChild ($form);
			setTextFieldsEvents();

			// close btn
			$form.close_btn.buttonMode = true;
			$form.close_btn.addEventListener (MouseEvent.CLICK, close_form);
			
			// close btn
			$form.skip_btn.addEventListener (MouseEvent.CLICK, clickHandler);
			
			// submit btn
			$form.submit_btn.addEventListener (MouseEvent.CLICK, function ():void { submit(); } );
			
			$form.headerText.autoSize = TextFieldAutoSize.LEFT;
			$form.headerText.multiline = true;
			$form.headerText.text = "For special offers and updates on the Toyota " + Controller.getInstance().$map_co.selected_car_name + ", please complete the fields below.";
			$form.headerText.y -=  $form.headerText.textHeight - 15;
			
			setValidations();

		}
		public function hide_cid_form ():void 
		{
			
			// start again all disabled events on site
			$dispatcher.dispatchEvent (new Event (ClassDispatcher.START_EVENTS));
			//
			
			if ($form != null) {				
					var request:URLRequest = new URLRequest(Controller.getInstance ().$cars_co.get_car_url (Controller.getInstance().$map_co.selected_car_name));
					try {
						navigateToURL(request, '_blank');
					} catch (error:Error) {
						trace("<error> :onClick CidForm:");
					}
				removeChild ($form);
				$form = null;
			}
		}
		private function clickHandler(e:MouseEvent):void 
		{
			hide_cid_form ();
		}
		public function close_form (event:Event):void 
		{
			
			// start again all disabled events on site
			$dispatcher.dispatchEvent (new Event (ClassDispatcher.START_EVENTS));
			//
			
			if ($form != null) {
				removeChild ($form);
				$form = null;
			}
		}
		///////////////////////////////////////////////////////////////////////////
		private function submit ():void
		{
			///////////
			// reset errors container
			returnedErrors_arr = [];
			
			///
			collect_user_info ();
		}
		///////////////////////////////////////////////////////////////////////////
		public function collect_user_info ():void
		{
			if($form != null){
				
				// email
				var email:Boolean = ($form.email_txt.text.length > 5 && (isValidEmail($form.email_txt.text)))?true:changeColor($form.email_txt);
				
				// first name
				var fname:Boolean = (trim($form.fname_txt.text) > 1 && ($form.fname_txt.text != "First name" && $form.fname_txt.text != "Name must be provided."))?true:changeColor($form.fname_txt);
				
				// last name
				var lname:Boolean = (trim($form.lname_txt.text) > 1  && ($form.lname_txt.text != "Last name" && $form.lname_txt.text != "Last name must be provided."))?true:changeColor($form.lname_txt);
				
				// zip code
				var zcode:Boolean = (trim($form.zcode_txt.text) == 5 && ($form.zcode_txt.text != "Zip code" && $form.zcode_txt.text !="Zip code must be provided."))?true:changeColor($form.zcode_txt);
				
				// if all the variables ( true );
				if (email && fname && lname && zcode) {
					request_cid ();
				}
				else {
					//
					trace("email", email);
					trace("fname", fname);
					trace("lname", lname);
					trace("zcode", zcode);

					// 
					invalidData();
					submitFail_omniture ();
				}
			}
		}
		private function changeColor(input:TextField): Boolean {
			
			 input.background = true;
			 input.backgroundColor = 0xEA1C23;
			 input.textColor = 0xFFFFFF;
			 
			 trace("from changecolor==> ", input.name);
			  switch(input.name) {
				   case "email_txt":
				     input.text = "E-mail must be provided.";
					 returnedErrors_arr.push (input.text);
				   break;
				   case "fname_txt":
				    input.text = "Name must be provided.";
					returnedErrors_arr.push (input.text);
				   break;
				   case "lname_txt":
				    input.text = "Last name must be provided.";
					returnedErrors_arr.push (input.text);
				   break;
				   case "zcode_txt":
				    input.text = "Zip code must be provided.";
					returnedErrors_arr.push (input.text);
				   break;
				  }
				  
				  
				  //trace("carname ", Controller.getInstance().$map_co.selected_car_name);
			 return false;
			 
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////
		public function request_cid():void
		{
				// user message
				var tempFormat:TextFormat = new TextFormat ()
				tempFormat.align = TextFormatAlign.CENTER;
				$form.headerText.text = "Sending your submission";
				$form.headerText.setTextFormat(tempFormat);
				
				// web service request
				$webservice.responseCallback = function (serverResponse:String):void
				{
					switch (serverResponse) {
						case "success":
							request_insert_success ();
							
							// write cookie counter
							var formCalledBy:String = $controller.$user_center_info.formOpenBy;
							$flashCookie.click_counter (formCalledBy);
							trace("formCalledBy", formCalledBy);
							//////////////////////
						break;
						case "error":
							request_error ();
						break;
					}
				}
				
				var svCODE:String = "76:1139";
				$webservice.request_cid($form.email_txt.text, $form.fname_txt.text, $form.lname_txt.text, $form.zcode_txt.text, svCODE);
		}
		private function request_insert_success (e:Event = null):void 
		{
			trace("Request Success")
			var tempFormat:TextFormat = new TextFormat ()
			tempFormat.align = TextFormatAlign.LEFT;
			$form.headerText.text = "Thank you! Your request has been submitted. We will redirect you in three seconds, or just click continue."
			$form.headerText.setTextFormat (tempFormat);
			$form.headerText.y = 260;

			//
			
			// omniture event confirmation
			submitOk_omniture ();
			
			// 3 seconds delay for hide the form and redirect to the car selected page info
			var redirect:EventDelay_cn = new EventDelay_cn (3000, function ():void {
					hide_cid_form ();
				});
		}
		private function request_error (e:Event = null):void
		{
			trace("Request Error")
			var tempFormat:TextFormat = new TextFormat ()
			tempFormat.align = TextFormatAlign.CENTER;
			$form.headerText.text = "Error inserting on DB!!"
			$form.headerText.setTextFormat (tempFormat);
			$form.headerText.y = 260;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////
		private function trim(str:String):int {
			var strTrim:String;
			strTrim = str.replace(/^\s*(.*?)\s*$/g, "$1");
			return strTrim.length;
       }
		private function invalidData():void 
		{
			TweenLite.from($form, .8, { alpha:.8, ease:Sine.easeIn } );
		}
		private function setValidations():void 
		{
			  $form.email_txt.maxChars = 100;
			  $form.fname_txt.maxChars = 30;
			  $form.fname_txt.restrict = "^0-9";
			  $form.lname_txt.maxChars = 30;
			  $form.lname_txt.restrict = "^0-9";
			  $form.zcode_txt.restrict = "0-9";
			  $form.zcode_txt.maxChars = 5;	
		}
		private function setTextFieldsEvents():void {
			$form.email_txt.addEventListener(FocusEvent.FOCUS_IN, turnWhite);
			$form.fname_txt.addEventListener(FocusEvent.FOCUS_IN, turnWhite);
			$form.lname_txt.addEventListener(FocusEvent.FOCUS_IN, turnWhite);
			$form.zcode_txt.addEventListener(FocusEvent.FOCUS_IN, turnWhite);

			$form.email_txt.addEventListener(FocusEvent.FOCUS_OUT, checkText);
			$form.fname_txt.addEventListener(FocusEvent.FOCUS_OUT, checkText);
			$form.lname_txt.addEventListener(FocusEvent.FOCUS_OUT, checkText);
			$form.zcode_txt.addEventListener(FocusEvent.FOCUS_OUT, checkText);
		}
		private function turnWhite(event:Event):void {
		 
			event.target.backgroundColor = 0xFFFFFF;
			event.target.textColor = 0x999999;
			event.target.text = "";

		}
		private	function checkText(event:Event):void 
		{
			switch (event.target.name) {
			case "email_txt":
			  if (trim(event.target.text) == 0 || !isValidEmail(event.target.text)) {
				  event.target.text = "E-mail address";
				  changeColor($form.email_txt);
				  }
			break;
			case "fname_txt":
			if (trim(event.target.text) == 0 ) 
				  event.target.text = "First name";
			break;
			case "lname_txt":
			   if (trim(event.target.text) == 0 ) 
				  event.target.text = "Last name";
			break;
			case "zcode_txt":
				if (trim(event.target.text) == 0 )
				  event.target.text = "Zip code";
			break;
			}
		}
		///////////////////////////////////////////////////////////////////////////
		// validations
		private function isValidEmail(email:String):Boolean 
		{
			var emailExpression:RegExp =  /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
			return emailExpression.test(email);
		}
		///////////////////////////////////////////////////////////////////////////
		// top message update
		private function updateTitleForm ():void
		{
			
		}
		///////////////////////////////////////////////////////////////////////////
		// OMNITURE submits
		public function submitFail_omniture ():void
		{			
			// omniture
			Ominure.getInstance ().pageName = "GM:All Vehicles:Find Your Match:Opt-in Toyota Vehicle Form";
			Ominure.getInstance ().tracklink_items( {

				// custom obj variables
				prop29:"GM:All Vehicles:Find Your Match:Opt-in Toyota Vehicle Form",
				prop30:returnedErrors_arr.toString ()
				
			},{

				// variables of custom link
				lnk_o:"o",
				pev2:"Tcom_Find Your Match_Opt in Form_Formerrors"

			});
		}
		public function submitOk_omniture ():void
		{
			// omniture
			Ominure.getInstance ().pageName = "GM:All Vehicles:Find Your Match:Opt-in Toyota Vehicle Form Confirmation";
			Ominure.getInstance ().track_items( {
					
					channel:"GM:Find Your Match",
					
					prop10:"GM:Find Your Match",
					prop11:"GM:All Vehicles:Find Your Match",
					prop8: "GM:All Vehicles:Find Your Match:Opt-in Toyota Vehicle Form Confirmation",
					
					eVar41:"Find Your Match Campaign"
				
				});
			///////////
		}
	}
}
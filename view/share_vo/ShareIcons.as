package com.digitalarbor.toyota.view.share_vo 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	
	//assets
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.library_assets.share_container_mc;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;
	
	public class ShareIcons extends share_container_mc
	{	
		public function ShareIcons() 
		{ 	
			
			Controller.getInstance ().$share_co.share_class = this;
			
			this.x = 840;
			this.y = 30;
			
			// properties
			tweet_btn.buttonMode = true;
			tweet_btn.addEventListener (MouseEvent.CLICK, function ():void { call_tweeter() } );
			tweet_btn.addEventListener (MouseEvent.ROLL_OVER, rolloverHandler);
			tweet_btn.addEventListener (MouseEvent.ROLL_OUT, rolloutHandler);
			
			facebook_btn.buttonMode = true;
			facebook_btn.addEventListener (MouseEvent.CLICK, function ():void { call_facebook() } );
			facebook_btn.addEventListener (MouseEvent.ROLL_OVER, rolloverHandler);
			facebook_btn.addEventListener (MouseEvent.ROLL_OUT, rolloutHandler);

		}

		private function rolloverHandler (e:MouseEvent):void
		{
		}
		private function rolloutHandler (e:MouseEvent):void
		{
		}
		
		//*************** calls
		public function call_facebook (_modelSelected:String = ""):void
		{
			trace("call facebook")
			var modelSelected:String = _modelSelected;
			var msg_toshare:String = "";
			
			if (_modelSelected.length > 0) {
				msg_toshare = "The "+modelSelected+" is my perfect ride. Uncover yours at toyota.com/whatdrivesyou."
			}else {
				// omniture
				Ominure.getInstance ().pageName = "";
				Ominure.getInstance ().tracklink_items( {

					// custom obj variables
					prop22:"GM:All Vehicles:Find Your Match:CTA:Share on Facebook",
					prop46:"GM:All Vehicles:Find Your Match:Share on Facebook"

				},{

					// variables of custom link
					lnk_o:"o",
					pev2:"Tcom_Find Your Match_Cta_Share on Facebook"

				});
				///////////
				msg_toshare = "Find your Toyota match. Uncover your perfect ride based on who you are and what you like at toyota.com/whatdrivesyou.";
			}
			
			
			if(ExternalInterface){
				ExternalInterface.call("shareFacebook(window.location.href,'" + modelSelected + "','" + msg_toshare + "')");
			}
		}
		public function call_tweeter (_modelSelected:String = ""):void
		{
			trace("call tweeter")
			var modelSelected:String = _modelSelected;
			var msg_toshare:String = "";
			
			if (_modelSelected.length > 0) {
				msg_toshare = "The "+modelSelected+" is my perfect ride. Uncover yours at toyota.com/whatdrivesyou."
			}else {
				// omniture
				Ominure.getInstance ().pageName = "";
				Ominure.getInstance ().tracklink_items( {

					// custom obj variables
					prop22:"GM:All Vehicles:Find Your Match:CTA:Share on Twitter",
					prop46:"GM:All Vehicles:Find Your Match:Share on Twitter"
					
				},{

					// variables of custom link
					lnk_o:"o",
					pev2:"Tcom_Find Your Match_Cta_Share on Twitter"

				});
				///////////
					msg_toshare = "Find your Toyota match. Uncover your perfect ride based on who you are and what you like at toyota.com/whatdrivesyou.";
				}
			
			if (ExternalInterface) {
				ExternalInterface.call("shareTwitter(window.location.href,'" + modelSelected + "','" + msg_toshare + "')");
			}
		}

	}
}
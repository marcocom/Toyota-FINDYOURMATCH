package com.digitalarbor.toyota.model 
{
	import com.digitalarbor.toyota.utilities.SWFInfo;
	import com.digitalarbor.toyota.view.cid_vo.Cid_form;
	import com.digitalarbor.toyota.utilities.FlashCookie;
	
	public class UserCenterInfo_mo
	{
		private var $swf_info:SWFInfo;
		private var $flashCookie:FlashCookie;
		private var $user_form:Cid_form;
		private var $user_cid:String;
		private var $user_mid:String;
		private var $user_surveyid:String;
		private var $user_survey:String;
		private var $user_aid:String;
		
		private var $formOpenBy:String;

		public function UserCenterInfo_mo()
		{
			$swf_info = SWFInfo.getInstance ();
			$flashCookie = FlashCookie.getInstance ();
			
			// register user cid
			if ($swf_info.flashvars["cid"] != undefined && $swf_info.flashvars["cid"].toString().length > 0) {
				user_cid = $swf_info.flashvars["cid"];
			} else {
				user_cid = ($flashCookie.read_variable("user_cid") != undefined)?$flashCookie.read_variable("user_cid"):null;				
			}
			trace("$user_cid ", user_cid);
			
			// register user mid
			if ($swf_info.flashvars["mid"] != undefined && $swf_info.flashvars["mid"].toString().length > 0) {
				user_mid = $swf_info.flashvars["mid"];
			} else {
				user_mid = ($flashCookie.read_variable("user_mid") != undefined)?$flashCookie.read_variable("user_mid"):null;
			}
			trace("$user_mid ", user_mid);
			
			// 
			// the surver returned by DB always it's in 0, (this can cause an error), RAPP fix
			if ($swf_info.flashvars["survey"] != undefined && $swf_info.flashvars["survey"].toString().length > 0) {
				user_survey = $swf_info.flashvars["survey"];
			} else {
				user_survey = ($flashCookie.read_variable("user_survey") != undefined)?$flashCookie.read_variable("user_survey"):null;
			}
			trace("$user_survey ", user_survey);
			
			////////////////////////////////////////////////////
			user_aid = ($flashCookie.read_variable("user_aid") != undefined)?$flashCookie.read_variable("user_aid"):null;
			user_surveyid = ($flashCookie.read_variable("user_surveyid") != undefined)?$flashCookie.read_variable("user_surveyid"):null;
		}
		
		// CID
		public function get user_cid():String 
		{
			return $user_cid;
		}
		
		public function set user_cid(value:String):void 
		{
			trace("register $user_cid", value)
			$user_cid = value;
			
			// register cookie
			writeCookie ("user_cid", value);
		}
		
		// MID
		public function get user_mid():String 
		{
			return $user_mid;
		}
		
		public function set user_mid(value:String):void 
		{
			trace("register $user_mid", value)
			$user_mid = value;
			
			// register cookie
			writeCookie ("user_mid", value);
		}
		
		// SURVEY ID
		public function get user_surveyid():String 
		{
			return $user_surveyid;
		}
		
		public function set user_surveyid(value:String):void 
		{
			trace("register $user_surveyid", value)
			$user_surveyid = value;
			
			// register cookie
			writeCookie ("user_surveyid", value);
		}
		
		// SURVEY 
		public function get user_survey():String 
		{
			return $user_survey;
		}
		
		public function set user_survey(value:String):void 
		{
			trace("register $user_survey", value)
			$user_survey = value;
			
			// register cookie
			writeCookie ("user_survey",value);
		}
		
		// ACTIVITY
		public function get user_aid():String 
		{
			return $user_aid;
		}
		
		public function set user_aid(value:String):void 
		{
			trace("register $user_aid", value)
			$user_aid = value;
			
			// register cookie
			writeCookie ("user_aid", value);
		}
		
		// FORM
 		public function get user_form():Cid_form 
		{
			return $user_form;
		}
		
		public function set user_form(value:Cid_form):void 
		{
			$user_form = value;
		}
		
		// FORM OPEN BY
		public function get formOpenBy():String 
		{
			return $formOpenBy;
		}
		public function set formOpenBy(value:String):void 
		{
			$formOpenBy = value;
		}
		//////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////
		public function writeCookie (varName:String,varValue:String):void
		{
			$flashCookie.write_variable (varName, varValue);
		}
	}
}
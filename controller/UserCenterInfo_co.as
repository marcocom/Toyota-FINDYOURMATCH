package com.digitalarbor.toyota.controller 
{
	import com.digitalarbor.toyota.model.Model;
	import com.digitalarbor.toyota.view.cid_vo.Cid_form;
	import com.digitalarbor.toyota.utilities.webservices.Webservice;
	public class UserCenterInfo_co 
	{
		private var $webservice:Webservice;
		
		public function UserCenterInfo_co():void
		{
			$webservice = new Webservice ();
		}
		
		// user form ( reques new user info )
		public function open_cid_form ():void
		{
			user_form.show_cid_form();
		}
		public function close_cid_form ():void
		{
			user_form.hide_cid_form ();
		}
		
		// webservice entry
		public function update_consumer ():void 
		{
			//
			var cusumerId:String = user_cid;
			var activityId:String = user_aid; //user_aid;
			var surveyId:String = user_surveyid; //user_surveyid;
			var sv:String = "76:1139"
			
			trace("//////////////////////////////////////UserCenterInfo_co ")
			trace("cid:"+cusumerId)
			trace("aid:"+activityId)
			trace("sid:"+surveyId)
			trace("sv"+sv)
			trace("//////////////////////////////////////")
			
			if (cusumerId != null && activityId != null && surveyId != null && sv != null ) {
				$webservice.responseCallback = function (serverResponse:String):void {
						switch (serverResponse) {
							case "success":
								updated_request_success ();
							break;
							case "error":
								updated_request_error ();
							break;
						}
				} 
				$webservice.update_Custumer (cusumerId, activityId, surveyId, sv);
			}else {
				trace("Error! on update consumer");
				trace(cusumerId);
				trace(activityId);
				trace(surveyId);
				trace(sv);
			}
		}
		public function updated_request_success ():void
		{
			trace("success")
		}
		public function updated_request_error ():void
		{
			trace("Error")
		}
		/////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////
		public function set user_form (value:Cid_form):void
		{
			Model.getInstance ().$user_center_info.user_form = value;
		}
		public function get user_form ():Cid_form
		{
			return Model.getInstance ().$user_center_info.user_form;
		}
		// CID
		public function get user_cid():String 
		{
			return Model.getInstance ().$user_center_info.user_cid;
		}
		
		public function set user_cid(value:String):void 
		{
			Model.getInstance ().$user_center_info.user_cid = value;
		}
		
		// MID
		public function get user_mid():String 
		{
			return Model.getInstance ().$user_center_info.user_mid;
		}
		
		public function set user_mid(value:String):void 
		{
			Model.getInstance ().$user_center_info.user_mid = value;
		}
		
		// SURVEY ID
		public function get user_surveyid():String 
		{
			return Model.getInstance ().$user_center_info.user_surveyid;
		}
		
		public function set user_surveyid(value:String):void 
		{
			Model.getInstance ().$user_center_info.user_surveyid = value;
		}
		
		// SURVEY
		public function get user_survey():String 
		{
			return Model.getInstance ().$user_center_info.user_survey;
		}
		
		public function set user_survey(value:String):void 
		{
			Model.getInstance ().$user_center_info.user_survey = value;
		}
		
		// ACTIVITY
		public function get user_aid():String 
		{
			return Model.getInstance ().$user_center_info.user_aid;
		}
		
		public function set user_aid(value:String):void 
		{
			 Model.getInstance ().$user_center_info.user_aid = value;
		}
		
		//  FORM OPEN BY
		public function get formOpenBy():String 
		{
			return Model.getInstance ().$user_center_info.formOpenBy;
		}
		public function set formOpenBy(value:String):void 
		{
			Model.getInstance ().$user_center_info.formOpenBy =  value;
		}
	}
}
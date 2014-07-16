package com.digitalarbor.toyota.controller 
{
	import com.digitalarbor.toyota.view.share_vo.ShareIcons;
	import com.digitalarbor.toyota.model.Model;
	
	public class Share_co 
	{
		public function Share_co() {}
		public function get share_class():ShareIcons 
		{
			return Model.getInstance().$share_mo.share_class;
		}
		
		public function set share_class(value:ShareIcons):void 
		{
			Model.getInstance().$share_mo.share_class = value;
		}
	}
}
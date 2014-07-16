package com.digitalarbor.toyota.model 
{
	import com.digitalarbor.toyota.view.share_vo.ShareIcons;
	
	public class Share_mo 
	{
		private var $share_class:ShareIcons
		
		public function Share_mo() { };
		public function get share_class():ShareIcons 
		{
			return $share_class;
		}
		public function set share_class(value:ShareIcons):void 
		{
			$share_class = value;
		}
	}
}
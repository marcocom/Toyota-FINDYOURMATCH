package com.digitalarbor.toyota.controller 
{
	import com.digitalarbor.toyota.model.Model
	public class Click_counter_co 
	{
		public function Click_counter_co() {}
		/**
		 * Regiter on ShareObject how many times user are click on X selection.
		 * If selection was register return true, else return false.
		 * 
		 * @value:String = section (carrousel / resultPage)
		 **/
		public function user_click_on (value:String):Boolean
		{
			return Model.getInstance ().$flashCookie.click_counter (value);
		}
	}
}
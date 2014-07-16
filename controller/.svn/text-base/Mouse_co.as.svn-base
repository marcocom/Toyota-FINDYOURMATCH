package com.digitalarbor.toyota.controller 
{
	import flash.events.Event;
	
	import com.digitalarbor.toyota.utilities.Custom_cursor;
	import com.digitalarbor.toyota.model.Model;

	public class Mouse_co 
	{
		public function Mouse_co() { }

		public function show_mouse ():void 
		{
			mouseClass.down_handler ();
		}
		public function hide_mouse ():void
		{
			mouseClass.up_handler ();
		}
		public function move_mouse ():void
		{
			mouseClass.move_handler ();
		}
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		public function get mouseClass():Custom_cursor 
		{
			return Model.getInstance ().$mouse_mo.mouse_class;
		}
		
		public function set mouseClass(value:Custom_cursor):void 
		{
			Model.getInstance ().$mouse_mo.mouse_class = value;
		}
	}

}
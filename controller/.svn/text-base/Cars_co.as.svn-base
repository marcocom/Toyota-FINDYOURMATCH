package com.digitalarbor.toyota.controller 
{
	import com.digitalarbor.toyota.model.Model;
	public class Cars_co 
	{
		public function Cars_co() {}
		public function set carrousel_cars (value:Array):void
		{
			Model.getInstance ().$cars_mo.carrousel_cars = value;
		}
		public function get carrousel_cars ():Array
		{
			return Model.getInstance ().$cars_mo.carrousel_cars;
		}
		
		/*
		 * if(value==""), return all the register car names available, else return the URL of specific car
		 * */
		public function get_car_url (value:String=""):*
		{
			var car_url:String = '';
			for each (var car:* in carrousel_cars) {
				if (car.title.toLowerCase() == value.toLowerCase()) {
					car_url = car.url_link;
				}
			}
			return car_url;
		}
		
	}

}
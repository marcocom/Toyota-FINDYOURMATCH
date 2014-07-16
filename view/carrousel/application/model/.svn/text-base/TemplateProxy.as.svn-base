package com.digitalarbor.toyota.view.carrousel.application.model {

	import com.digitalarbor.toyota.view.carrousel.application.model.vo.DataItemCar;	
	import com.digitalarbor.toyota.view.carrousel.application.view.components.ItemCar;	
	import com.digitalarbor.toyota.view.carrousel.application.model.vo.Template;

	public class TemplateProxy 
	{
		public static const NAME:String = "TemplateProxy";
		public var data:Object;
		
		public function TemplateProxy()
		{
			setDefaults();
		}
		
		public function setDefaults():void
		{
			var template:Template = new Template();
			template.icon_min = 60;//48
			template.icon_max = 100;//96
			template.icon_size = 100;//128;
			template.icon_spacing = -5;//2;
			template.trend = 0;
			template.layout = "bottom";
			template.items = [];
			
			this.data = template;
		}
		
		public function changeLayout(layout:String):void
		{
			this.data.layout = layout;
		}
		
				/**
		 * Set the data object
		 */
		public function setData( data:Object ):void 
		{
			this.data = data;
		}
		
		/**
		 * Get the data object
		 */
		public function getData():Object 
		{
			return data;
		}		
		
		
	}
}
package com.digitalarbor.toyota.view.carrousel.application.model {
	
	import com.digitalarbor.toyota.view.carrousel.application.model.vo.DataItemCar;	
	
	
	/**
	 * @author denis.gonzalez
	 */
	public class ParserItemCar  {
		
		private static var itemsXml : Array;

		public function ParserItemCar() {
						
		}
		
		public static function xmlParseItemCar (xml:XML):Array {
			itemsXml = new Array();
			for each (var item:XML in xml..item){
				var data:DataItemCar = new DataItemCar();
				data.filterAnswers = item.@ans_sequence.toString().split(",");
				data.idItemcar = item.@id;
				data.isEnable = item.@enable;
				data.title = item.title.text();
				data.url_imagen_down = item.url_imagen_down.text();
				data.url_imagen_over = item.url_imagen_over.text();
				data.url_imagen_up = item.url_imagen_up.text();
				data.url_link = item.link.text();
				itemsXml.push(data);
            }
            
            return itemsXml;
		}
		
	}
}

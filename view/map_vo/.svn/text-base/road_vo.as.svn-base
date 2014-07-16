package com.digitalarbor.toyota.view.map_vo 
{
	
	import com.digitalarbor.toyota.library_assets.road_mc
	
	public class road_vo extends road_mc 
	{
		public function road_vo() { 
			for (var i:int = 0; i < this.numChildren; i++) {
				if (this.getChildAt(i).name.indexOf ("mc_") != -1) {
					this.getChildAt(i).visible = false;
				};
			}
		};
	}
}
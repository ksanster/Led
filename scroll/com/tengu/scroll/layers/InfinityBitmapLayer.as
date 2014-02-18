package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	
	public class InfinityBitmapLayer extends BaseLayer implements IGameContainer
	{
		private var bitmapName:String;
		
		public function set bitmap(value:String):void 
		{
			bitmapName = value;
		}
		
		public function get bitmap():String 
		{
			return bitmapName;
		}
		
		public function InfinityBitmapLayer()
		{
			super();
		}
	}
}
package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class InfinityBitmapLayer extends BaseLayer implements IGameContainer
	{
		private var bitmapData:BitmapData;
		
		public function set bitmap(value:BitmapData):void 
		{
			bitmapData = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get bitmap():BitmapData 
		{
			return bitmapData;
		}
		
		public function InfinityBitmapLayer()
		{
			super();
		}
		
		public override function load(value:XML):void
		{
			
		}
		
		public override function save():XML
		{
			
		}
	}
}
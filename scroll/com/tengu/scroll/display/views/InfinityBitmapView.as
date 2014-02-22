package com.tengu.scroll.display.views
{
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class InfinityBitmapView extends BaseDisplayContainerView
	{
		public function InfinityBitmapView()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			
			var shape:Shape = new Shape();
			var graphix:Graphics = shape.graphics;
			graphix.beginFill(0xFFF);
			graphix.drawCircle(0, 0, 10);
			graphix.endFill();

			holder.addChild(shape);
		}
	}
}
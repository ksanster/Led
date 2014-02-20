package com.tengu.scroll.display.views
{
	public class InfinityBitmapView extends BaseDisplayContainerView
	{
		public function InfinityBitmapView()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			graphics.beginFill(0xFFF);
			graphics.drawCircle(100, 100, 10);
			graphics.endFill();
		}
	}
}
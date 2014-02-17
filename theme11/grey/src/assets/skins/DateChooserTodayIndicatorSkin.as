package assets.skins
{
	import flash.display.Graphics;
	
	import mx.skins.Border;

	public class DateChooserTodayIndicatorSkin extends Border
	{
		public function DateChooserTodayIndicatorSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var w : Number = unscaledWidth;
			var h : Number = unscaledHeight;
			
			var g : Graphics = graphics;
			g.clear();
			
			drawCrosslines(w, h, g);
		}
		
		private function drawCrosslines(w:Number, h:Number, g:Graphics):void
		{
			g.moveTo(0, 0);
			g.beginFill(0x333333, 0.5);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			g.moveTo(0, 0);
			g.beginFill(0x333333, 0.8);
			g.lineTo(7, 0);
			g.lineTo(0, 7);
			g.lineTo(0, 0);
			g.endFill();
			
			g.moveTo(w, h-7);
			g.beginFill(0x333333, 0.8);
			g.lineTo(w, h);
			g.lineTo(w-7, h);
			g.lineTo(w, h-7);
			g.endFill();
		}
	}
}
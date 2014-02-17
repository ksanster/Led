package assets.skins
{
	import flash.display.Graphics;
	
	import mx.skins.Border;

	public class DateCooserSelectionSkin extends Border
	{
		public function DateCooserSelectionSkin()
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
			
			drawLines(w, h, g);
		}
		
		private function drawLines(w:Number, h:Number, g:Graphics):void
		{
			g.moveTo(0, 0);
			g.beginFill(0x333333, 0.2);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			g.moveTo(1, 0);
			g.lineStyle(1, 0x333333, 0.5);
			g.lineTo(1, h);
			g.moveTo(4, 0);
			g.lineTo(4, h);
			
			g.moveTo(w-4, 0);
			g.lineTo(w-4, h);
			g.moveTo(w-1, 0);
			g.lineTo(w-1, h);
			
			g.moveTo(0, 1);
			g.lineTo(w, 1);
			g.moveTo(0, 4);
			g.lineTo(w, 4);
			
			g.moveTo(0, h-4);
			g.lineTo(w, h-4);
			g.moveTo(0, h-1);
			g.lineTo(w, h-1);			
		}
	}
}
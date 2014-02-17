package assets.skins
{
	import flash.display.GradientType;
	
	import mx.skins.Border;

	public class ScrollThumbSkin extends Border
	{
		public function ScrollThumbSkin()
		{
			super();
		}
		
		override public function get measuredWidth():Number
		{
			return 16;
		}
		
		override public function get measuredHeight():Number
		{
			return 10;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var fillColors:Array = [0x4E4E4E, 0x4E4E4E];
			graphics.clear();
			
			var fillAlpha:Number = 1;
		
			drawRoundRect(
				0, 0, w, h, 0,
				[ 0x4E4E4E, 0x4E4E4E ], fillAlpha,
				verticalGradientMatrix(0, 0, w, h),
				GradientType.LINEAR, null,
				{ x: 1, y: 1, w: w - 2, h: h - 2, r: 0 }); 
	
			// fill
			drawRoundRect(
				1, 1, w - 2, h - 2, 0,
				fillColors, fillAlpha, 
				horizontalGradientMatrix(1, 1, w / 3 * 2, h - 2)); 
		}
		
	}
}
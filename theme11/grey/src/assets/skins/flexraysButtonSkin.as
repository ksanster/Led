package assets.skins
{
	import flash.display.Graphics;
	
	import mx.controls.Button;
	import mx.core.UIComponent;

	public class flexraysButtonSkin extends UIComponent
	{
		public function flexraysButtonSkin()
		{
			super();
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			   super.updateDisplayList(unscaledWidth,unscaledHeight);
			   
			   var w:Number = unscaledWidth;
			   var h:Number = unscaledHeight;
			   
			   var g:Graphics = graphics;
			   g.clear();
			   
			   switch (name) {
					case "upSkin":
						drawButtonSkin(w, h, g, 0x333333, 0x333333, 0xFDFDFD, 0.7, 0.5, 0.9);
						break;
					case "overSkin":
						drawButtonSkin(w, h, g, 0x333333, 0x333333, 0xFDFDFD, 0.8, 1, 0.8);
						break;
					case "downSkin":
						drawButtonSkin(w, h, g, 0x333333, 0x333333, 0xFDFDFD, 0.9, 0.9, 0.9);
						break;
					case "disabledSkin":
						drawButtonSkin(w, h, g, 0x333333, 0x333333, 0xFDFDFD, 0.4, 0.4, 0.4);
						break;
				}					   
		}
		
		private function drawButtonSkin(w:Number, 
										h: Number, 
										g:Graphics, 
										colorDown: uint, 
										colorUp: uint,
										colorMiddle : uint,
										alphaDown: Number,
										alphaUp: Number,
										alphaMiddle: Number):void
		{
			
			/* g.moveTo(0, 0);
			g.beginFill(colorDown, alphaDown);
			g.lineTo(w, h);
			g.lineTo(0, h);
			g.lineTo(0, 0);
			g.endFill(); 
			
			g.moveTo(0, 0);
			g.beginFill(colorUp, alphaUp);
			g.lineTo(w, 0);
			g.lineTo(w, h);
			g.lineTo(0, 0);
			g.endFill(); */
			
			g.moveTo(0, 0);
			g.beginFill(colorDown, alphaDown);
			g.lineTo(5, h-5);
			g.lineTo(w, h);
			g.lineTo(0, h);
			g.lineTo(0, 0);
			g.endFill();
			
			g.moveTo(0, 0);
			g.beginFill(colorMiddle, alphaMiddle);
			g.lineTo(5, h-5);
			g.lineTo(w, h);
			g.lineTo(w-5, 5);
			g.lineTo(0, 0);
			g.endFill();
			
			g.moveTo(0, 0);
			g.beginFill(colorUp, alphaUp);
			g.lineTo(w, 0);
			g.lineTo(w, h);
			g.lineTo(w-5, 5);
			g.lineTo(0, 0);
			g.endFill();
			
		}
		
		private function drawButtonDownSkin(w:Number, 
										h: Number, 
										g:Graphics, 
										colorDown: uint, 
										colorUp: uint,
										colorMiddle : uint, 
										alphaDown: Number,
										alphaUp: Number,
										alphaMiddle: Number):void
		{
			g.moveTo(0, 0);
			g.beginFill(colorDown, alphaDown);
			g.lineTo(5, h-5);
			g.lineTo(w, h);
			g.lineTo(0, h);
			g.lineTo(0, 0);
			g.endFill();
			
			g.moveTo(0, 0);
			g.beginFill(colorMiddle, alphaMiddle);
			g.lineTo(5, h-5);
			g.lineTo(w, h);
			g.lineTo(0, 0);
			g.endFill();
			
			
			g.moveTo(0, 0);
			g.beginFill(colorUp, alphaUp);
			g.lineTo(w, 0);
			g.lineTo(w, h);
			g.lineTo(0, 0);
			g.endFill();
		}
	}
}
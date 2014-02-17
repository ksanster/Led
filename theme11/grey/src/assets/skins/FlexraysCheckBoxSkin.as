package assets.skins
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;

	public class FlexraysCheckBoxSkin extends UIComponent
	{
		public function FlexraysCheckBoxSkin()
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
						drawCheckBoxSkin(w, h, g, 0x333333, 0.9);
						break;
					case "overSkin":
						drawCheckBoxSkin(w, h, g, 0x333333, 0.9);
						break;
					case "downSkin":
						drawCheckBoxSkin(w, h, g, 0x333333, 0.9);
						break;
					case "disabledSkin":
						drawCheckBoxSkin(w, h, g, 0x333333, 0.9);
						break;
				}	
		}
		
		private function drawCheckBoxSkin(w:Number, 
											h: Number, 
											g:Graphics, 
											color: uint, 
											alpha : Number):void
		{
			
			g.moveTo(0, 0);
			g.beginFill(color, alpha);
			g.lineTo(0, 3);
			g.lineTo(w, 0);
			g.lineTo(0, 0);
			g.endFill();
												
		}
		
	}
}
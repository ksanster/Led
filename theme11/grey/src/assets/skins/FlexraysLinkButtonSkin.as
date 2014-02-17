package assets.skins
{
	import flash.display.Graphics;
	
	import mx.skins.halo.LinkButtonSkin;

	public class FlexraysLinkButtonSkin extends LinkButtonSkin
	{
		public function FlexraysLinkButtonSkin()
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
						drawLinkButtonSkin(w, h, g, 0x333333, 0.6);
						break;
					
					case "selectedUpSkin":
                	case "selectedOverSkin":
					case "overSkin":
						drawLinkButtonSkin(w, h, g, 0x333333, 0.8);
						break;

					case "selectedDownSkin":
					case "downSkin":
						drawLinkButtonSkin(w, h, g, 0x333333, 1);
						break;
					
					case "selectedDisabledSkin":
					case "disabledSkin":
						drawLinkButtonSkin(w, h, g, 0x333333, 0.3);
						break;
				}					
		}
		
		private function drawLinkButtonSkin( w:Number,
											 h:Number,
											 g : Graphics,
											 bgColor : uint,
											 alpha : Number	):void
		{
			g.moveTo(0, 0);
			g.beginFill(bgColor, 0.4);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}	   
		
	}
}
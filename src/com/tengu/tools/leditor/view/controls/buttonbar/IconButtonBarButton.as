package com.tengu.tools.leditor.view.controls.buttonbar
{
	import spark.components.ButtonBarButton;
	import spark.primitives.BitmapImage;
	
	public class IconButtonBarButton extends ButtonBarButton
	{
		[SkinPart(required = "false")]
		public var iconElement:BitmapImage;

		public function IconButtonBarButton()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String 
		{
			var state:String = super.getCurrentSkinState();
			
			iconElement.source = data.icon;
//
//			if (state == "downAndSelected" || state == "overAndSelected" || state == "upAndSelected") {
//				iconElement.source = data.iconActive;
//			} else {
//				iconElement.source = data.iconNormal;
//			}
			
			return state;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (data !== null && instance == iconElement) {
				iconElement.source = data.icon;
			}
		}

	}
}
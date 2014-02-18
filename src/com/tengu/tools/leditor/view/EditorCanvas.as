package com.tengu.tools.leditor.view
{
	import flash.display.Sprite;
	
	public class EditorCanvas extends Sprite
	{
		public function EditorCanvas()
		{
			super();
			
			graphics.beginFill(0xFFFF00);
			graphics.drawRect(0, 0, 40, 70);
			graphics.endFill();
		}
	}
}
package com.tengu.tools.leditor
{
	import com.tengu.glue.core.impl.Context;
	import com.tengu.tools.leditor.view.controls.EditorCanvas;
	
	import flash.display.Sprite;
	
	public class EditorContext extends Context
	{
		private var mainApp:LevelEditor;
		public function EditorContext()
		{
			super();
		}
		
		protected override function initialize(contextView:Sprite):void
		{
			mainApp = (contextView as LevelEditor);
			mainApp.canvas.addChild(new EditorCanvas());

			super.initialize(contextView);
		}
		
		protected override function configureInjector():void
		{
			super.configureInjector();
		}
	}
}
package com.tengu.tools.leditor
{
	import com.tengu.glue.core.impl.Context;
	import com.tengu.log.LogFactory;
	import com.tengu.log.targets.TraceTarget;
	import com.tengu.tools.leditor.view.EditorCanvas;
	
	import flash.display.Sprite;
	
	public class EditorContext extends Context
	{
		private var mainApp:Led;
		public function EditorContext()
		{
			super();
		}
		
		protected override function initialize(contextView:Sprite):void
		{
			LogFactory.addTarget(new TraceTarget());
			mainApp = (contextView as Led);
			mainApp.canvas.addChild(new EditorCanvas());

			super.initialize(contextView);
		}
		
		protected override function configureInjector():void
		{
			super.configureInjector();
		}
	}
}
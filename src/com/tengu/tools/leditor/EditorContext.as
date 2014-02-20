package com.tengu.tools.leditor
{
	import com.tengu.glue.core.impl.Context;
	import com.tengu.log.LogFactory;
	import com.tengu.log.targets.TraceTarget;
	import com.tengu.scroll.view.Screen2D;
	import com.tengu.tools.leditor.logic.LedController;
	import com.tengu.tools.leditor.logic.api.IEditorController;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class EditorContext extends Context
	{
		private var mainApp:Led;
		private var screen2D:Screen2D;
		
		public function EditorContext()
		{
			super();
		}
		
		private function createScene(contextView:Sprite):void
		{
			const holder:DisplayObjectContainer = (contextView as Led).canvas;
			const ndBounds:Rectangle = new Rectangle(holder.x, holder.y, holder.width, holder.height);
			
			mainApp = (contextView as Led);
			screen2D = new Screen2D(ndBounds);
			
			holder.addChild(screen2D);
		}
		
		protected override function initialize(contextView:Sprite):void
		{
			LogFactory.addTarget(new TraceTarget());

			createScene(contextView);
			super.initialize(contextView);
		}
		
		protected override function configureInjector():void
		{
			super.configureInjector();
			injector.map(IEditorController).toSingleton(LedController);
			injector.map(Screen2D).toValue(screen2D);
		}
		
		public override function start():void
		{
			injector.injectInto(mainApp.toolsPanel.layersPanel);
			super.start();
		}
	}
}
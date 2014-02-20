package com.tengu.tools.leditor
{
	import com.tengu.calllater.api.ICallLaterManager;
	import com.tengu.calllater.impl.CallLaterManager;
	import com.tengu.glue.core.impl.Context;
	import com.tengu.log.LogFactory;
	import com.tengu.log.targets.TraceTarget;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IViewFactory;
	import com.tengu.scene.api.IViewport;
	import com.tengu.scene.objects.GameContainer;
	import com.tengu.scroll.display.NativeViewFactory;
	import com.tengu.scroll.display.views.SceneDisplayView;
	import com.tengu.tools.leditor.logic.LedController;
	import com.tengu.tools.leditor.logic.api.IEditorController;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class EditorContext extends Context
	{
		private var mainApp:Led;
		
		private var scene:GameContainer;
		private var sceneView:SceneDisplayView;
		private var viewFactory:IViewFactory;
		
		private var callLaterManager:ICallLaterManager;
		
		public function EditorContext()
		{
			super();
		}
		
		private function createScene(contextView:Sprite):void
		{
			const holder:DisplayObjectContainer = (contextView as Led).canvas;
			const ndBounds:Rectangle = new Rectangle(holder.x, holder.y, holder.width, holder.height);
			
			mainApp = (contextView as Led);
			callLaterManager = new CallLaterManager();
			callLaterManager.stage = contextView.stage;
			
			scene = new GameContainer();
			
			viewFactory = new NativeViewFactory();
			
			sceneView = new SceneDisplayView();
			sceneView.setViewFactory(viewFactory);
			sceneView.assignObject(scene);
			
			holder.addChild(sceneView);
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
			injector.map(ICallLaterManager).toValue(callLaterManager);
			
			injector.map(IViewFactory).toValue(viewFactory);
			injector.map(IGameContainer, "mainScene").toValue(scene);
			injector.map(IViewport).toValue(sceneView.viewport);
		}
		
		public override function start():void
		{
			injector.injectInto(mainApp.toolsPanel.layersPanel);
			injector.injectInto(viewFactory);
			super.start();
		}
	}
}
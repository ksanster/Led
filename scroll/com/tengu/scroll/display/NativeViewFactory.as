package com.tengu.scroll.display
{
	import com.tengu.di.api.IInjector;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IObjectView;
	import com.tengu.scene.api.IViewFactory;
	import com.tengu.scene.render.ViewFactory;
	import com.tengu.scroll.display.views.ImageTileView;
	import com.tengu.scroll.display.views.InfinityBitmapView;
	import com.tengu.scroll.layers.ImageTileLayer;
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	
	public class NativeViewFactory extends ViewFactory implements IViewFactory
	{
		[Inject]
		public var injector:IInjector;
		
		public function NativeViewFactory()
		{
			super();
			
			registerView(InfinityBitmapLayer, InfinityBitmapView);
			registerView(ImageTileLayer, ImageTileView);
		}
		
		public override function createView(object:IGameObject):IObjectView
		{
			const result:IObjectView = super.createView(object);
			injector.injectInto(result);
			return result;
		}
	}
}
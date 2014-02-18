package com.tengu.scene.render
{
	
	import com.tengu.scene.api.IContainerView;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IObjectView;
	import com.tengu.scene.api.IViewFactory;
	
	import flash.utils.Dictionary;

	public class ViewFactory implements IViewFactory
	{
		private var viewCache:Dictionary = null;
		protected var defaultObjectViewClass:Class = null;
		protected var defaultContainerViewClass:Class = null;
		
		protected var map:Dictionary = null;
		
		public function ViewFactory()
		{
			map = new Dictionary();
			viewCache = new Dictionary();
		}
		
		private function create (viewClass:Class):IObjectView
		{
			var result:IObjectView = null;
			var createdViews:Vector.<IObjectView> = viewCache[viewClass];
			if (createdViews.length == 0)
			{
				result = new viewClass();
				if (result is IContainerView)
				{
					(result as IContainerView).setViewFactory(this);
				}
				return result;
			}
			return createdViews.pop();			
		}
		
		public function setDefaultView(objectViewClass:Class, containerViewClass:Class):void
		{
			defaultObjectViewClass = objectViewClass;
			defaultContainerViewClass = containerViewClass;
			viewCache[objectViewClass] = new Vector.<IObjectView>();
			viewCache[containerViewClass] = new Vector.<IObjectView>();
		}
		
		public function registerView (objectClass:Class, viewClass:Class):void
		{
			map[objectClass] = viewClass;
			viewCache[viewClass] = new Vector.<IObjectView>();
		}
		
		public function createView (object:IGameObject):IObjectView
		{
			var viewClass:Class = map[Object(object).constructor];
			if (viewClass == null)
			{
				viewClass = (object is IGameContainer) ? defaultContainerViewClass : defaultObjectViewClass;
			}
			var view:IObjectView = create(viewClass);
			view.assignObject(object);
			return view;
		}
		
		public function disposeView (view:IObjectView):void
		{
			var createdViews:Vector.<IObjectView> = viewCache[Object(view).constructor];
			createdViews[createdViews.length] = view;
		}
	}
}
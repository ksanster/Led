package com.tengu.scroll.display.views
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IScrolledViewport;
	import com.tengu.scene.api.IViewport;
	import com.tengu.scene.events.GameContainerEvent;
	import com.tengu.scroll.display.DisplayViewport;
	import com.tengu.tools.leditor.api.ILayer;
	
	import flash.utils.Dictionary;

	public class SceneDisplayView extends BaseDisplayContainerView
	{
		protected var children:Dictionary;
		protected var sceneViewport:IScrolledViewport;
		
		public function get viewport():IViewport 
		{
			return sceneViewport;
		}
		public function SceneDisplayView()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			children = new Dictionary();
			
			sceneViewport = new DisplayViewport(this);
			sceneViewport.focalLength = 300;
		}
		
		protected override function onChildAdded(event:GameContainerEvent):void
		{
			const child:IGameObject = event.gameObject;
			const focalIndex:int = (child as ILayer).focalIndex;
			const view:BaseDisplayContainerView = viewFactory.createView(child) as BaseDisplayContainerView;
			if (view != null)
			{
				children[child] = view;
				sceneViewport.addSceneView(view, focalIndex, focalIndex);
			}
		}
		
		protected override function onChildRemoved(event:GameContainerEvent):void
		{
			const child:IGameObject = event.gameObject;
			const childView:BaseDisplayContainerView = children[child];
			
			delete children[event.gameObject];
			
			if (childView != null && childView.parent == this)
			{
				sceneViewport.removeSceneView(childView);
			}
		}
		
		protected override function onChildBoundsChanged(event:GameContainerEvent):void
		{
			
		}

	}
}
package com.tengu.scroll.display
{
	import com.tengu.scene.api.ICameraView;
	import com.tengu.scene.api.IViewport;
	import com.tengu.scene.render.ParallaxViewport;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DisplayViewport extends ParallaxViewport implements IViewport
	{
		private var container:DisplayObjectContainer;
		
		public function DisplayViewport(container:DisplayObjectContainer)
		{
			super();
			this.container = container;
		}
		
		protected override function addToContainer(value:ICameraView):void
		{
			const child:DisplayObject = value as DisplayObject;
			container.addChild(child);
		}
		
		protected override function removeFromContainer(value:ICameraView):void
		{
			const child:DisplayObject = value as DisplayObject;
			if (child.parent == container)
			{
				container.removeChild(child);
			}
		}
	}
}
package com.tengu.tools.leditor
{
	import com.tengu.glue.core.api.IContext;
	import com.tengu.glue.core.api.IFrameworkExtension;
	import com.tengu.scene.api.IViewport;
	import com.tengu.tools.leditor.model.api.ILedModel;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class MouseExtension implements IFrameworkExtension
	{
		private var oldX:Number;
		private var oldY:Number;
		
		[Inject]
		public var stage:Stage;
		
		[Inject (name="canvas")]
		public var canvas:DisplayObject;
		
		[Inject]
		public var model:ILedModel;
		
		[Inject]
		public var viewport:IViewport;
		
		public function MouseExtension()
		{
		}
		
		public function configure(context:IContext):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function inBounds (x:Number, y:Number):Boolean
		{
			return (x > 0) && (y > 0) && (x < canvas.width) && (y < canvas.height);
		}
		
		private function endDrag():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;

			if (!inBounds(x, y))
			{
				return;
			}
			
			oldX = x;
			oldY = y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if (model.activeLayer != null)
			{
				model.activeLayer.mouseDown(x, y);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;
			
			viewport.moveBy(x - oldX, y - oldY);
			
			oldX = x;
			oldY = y;

			if (model.activeLayer != null)
			{
				model.activeLayer.mouseMove(x, y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;

			if (model.activeLayer != null)
			{
				model.activeLayer.mouseUp(x, y);
			}

			endDrag();
		}
	}
}
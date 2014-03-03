package com.tengu.tools.leditor
{
	import com.tengu.glue.core.api.IContext;
	import com.tengu.glue.core.api.IFrameworkExtension;
	import com.tengu.scene.api.IViewport;
	import com.tengu.tools.leditor.model.LedModel;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MouseExtension implements IFrameworkExtension
	{
		private static const TWEEN_EASING:Number = .85;
		private static const MIN:Number = .1;
		private const shape:Shape = new Shape(); 

		private var oldX:Number;
		private var oldY:Number;

		private var tweenX:Number;
		private var tweenY:Number;
		
		private var isTween:Boolean = false;
		
		[Inject]
		public var stage:Stage;
		
		[Inject (name="canvasHolder")]
		public var canvas:DisplayObject;
		
		[Inject]
		public var model:LedModel;
		
		[Inject]
		public var viewport:IViewport;
		
		public function MouseExtension()
		{
			super();
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
		
		private function startTween ():void
		{
			if (shape.hasEventListener(Event.ENTER_FRAME))
			{
				return;
			}
			shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function stopTween ():void
		{
			if (!shape.hasEventListener(Event.ENTER_FRAME))
			{
				return;
			}
			tweenX = 0;
			tweenY = 0;
			shape.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
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
			
			if (model.layers.activeLayer != null)
			{
				model.layers.activeLayer.mouseDown(x, y);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;
			
			tweenX = x - oldX;
			tweenY = y - oldY;
			
			viewport.moveBy(tweenX, tweenY);
			
			oldX = x;
			oldY = y;

			if (model.layers.activeLayer != null)
			{
				model.layers.activeLayer.mouseMove(x, y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;

			if (model.layers.activeLayer != null)
			{
				model.layers.activeLayer.mouseUp(x, y);
			}

			endDrag();
			
			if (tweenX != 0 || tweenY != 0)
			{
				startTween();
			}
		}
		
		
		private function onEnterFrame(event:Event):void
		{
			tweenX = tweenX * TWEEN_EASING;
			tweenY = tweenY * TWEEN_EASING;
			
			viewport.moveBy(tweenX, tweenY);
			
			if (Math.abs(tweenX) < MIN)
			{
				tweenX = 0;
			}
			if (Math.abs(tweenY) < MIN)
			{
				tweenY = 0;
			}
			if (tweenX == 0 && tweenY == 0)
			{
				stopTween();
			}
		}

	}
}
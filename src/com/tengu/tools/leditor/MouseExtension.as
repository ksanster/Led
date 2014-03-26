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
		
		private var moveStarted:Boolean;
		
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
			return (x > 0) && (y > 0) && (x < model.screenSettings.viewportWidth) && (y < model.screenSettings.viewportHeight);
		}
		
		private function endDrag():void
		{
			moveStarted = false;
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
			
			const layerX:Number = (x - model.screenSettings.viewportWidth * .5) + viewport.centerX;
			const layerY:Number = (y - model.screenSettings.viewportHeight * .5) + viewport.centerY;
			
			if (!inBounds(x, y) || model.screenSettings.locked)
			{
				return;
			}
			
			moveStarted = !(model.layers.activeLayer != null &&
							model.layers.activeLayer.mouseDown(layerX, layerY) );

			tweenX = 0;
			tweenY = 0;
			
			oldX = x;
			oldY = y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;
			
			const layerX:Number = (x - model.screenSettings.viewportWidth * .5) + viewport.centerX;
			const layerY:Number = (y - model.screenSettings.viewportHeight * .5) + viewport.centerY;

			const newCenterX:Number = viewport.centerX + x - oldX; 
			const newCenterY:Number = viewport.centerY + y - oldY; 
			
			const levelHalfWidth:Number = model.screenSettings.levelWidth * .5;
			const viewportHalfWidth:Number = model.screenSettings.viewportWidth * .5;
			const levelHalfHeight:Number = model.screenSettings.levelHeight * .5;
			const viewportHalfHeight:Number = model.screenSettings.viewportHeight * .5;
			
			const leftXBound:Number = - levelHalfWidth + viewportHalfWidth;
			const rightXBound:Number = levelHalfWidth - viewportHalfWidth;
			const topYBound:Number = - levelHalfHeight + viewportHalfHeight;
			const bottomYBound:Number = levelHalfHeight - viewportHalfHeight;
			
			if (newCenterX < leftXBound)
			{
				oldX = x - (leftXBound - viewport.centerX);
			}
			if (newCenterX > rightXBound)
			{
				oldX = x - (rightXBound - viewport.centerX);
			}
			if (newCenterY < topYBound)
			{
				oldY = y - (topYBound - viewport.centerY);
			}
			if (newCenterY > bottomYBound)
			{
				oldY = y - (bottomYBound - viewport.centerY);
			}
			
			if (moveStarted)
			{
				tweenX = x - oldX;
				tweenY = y - oldY;
	
				viewport.moveBy(- tweenX, - tweenY);
				
				oldX = x;
				oldY = y;
			}

			if (model.layers.activeLayer != null)
			{
				model.layers.activeLayer.mouseMove(layerX, layerY);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			const x:Number = event.stageX - canvas.x;
			const y:Number = event.stageY - canvas.y;
			
			const layerX:Number = (x - model.screenSettings.viewportWidth * .5) + viewport.centerX;
			const layerY:Number = (y - model.screenSettings.viewportHeight * .5) + viewport.centerY;

			if (model.layers.activeLayer != null)
			{
				model.layers.activeLayer.mouseUp(layerX, layerY);
			}

			if (moveStarted && (tweenX != 0 || tweenY != 0))
			{
				startTween();
			}

			endDrag();
		}
		
		
		private function onEnterFrame(event:Event):void
		{
			tweenX = tweenX * TWEEN_EASING;
			tweenY = tweenY * TWEEN_EASING;
			viewport.moveBy(- tweenX, - tweenY);
			
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
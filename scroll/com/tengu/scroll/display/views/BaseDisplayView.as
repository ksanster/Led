package com.tengu.scroll.display.views
{
	import com.tengu.calllater.api.ICallLaterManager;
	import com.tengu.calllater.api.IDeferredCaller;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.events.GameObjectEvent;
	
	import flash.display.Sprite;
	
	public class BaseDisplayView extends Sprite implements IDeferredCaller
	{
		public static const VALIDATION_FLAG_ALL:uint 		= 0xFF;
		public static const VALIDATION_FLAG_POSITION:uint 	= 0x1;
		public static const VALIDATION_FLAG_BOUNDS:uint 	= 0x2;
		public static const VALIDATION_FLAG_SCALE:uint 		= 0x4;
		public static const VALIDATION_FLAG_ROTATION:uint 	= 0x8;
		public static const VALIDATION_FLAG_VIEWPORT:uint 	= 0x10;
		public static const VALIDATION_FLAG_SORT:uint 		= 0x20;

		private var validating:Boolean  = false;

		protected var validationFlags:uint 	= 0;
		protected var isSleeping:Boolean 	= true;
		
		protected var gameObject:IGameObject;

		[Inject]
		public var callLaterManager:ICallLaterManager;

		public function BaseDisplayView()
		{
			super();
			initialize();
		}
		
		protected function initialize():void
		{
			mouseEnabled = false;
			
		}
		
		protected final function isInvalid(flag:uint):Boolean
		{
			return (validationFlags & flag) != 0;
		}
		
		protected final function setValidationFlag (flag:uint):void
		{
			validationFlags = validationFlags | flag;
		}
		
		protected final function unsetValidationFlag (flag:uint):void
		{
			validationFlags = validationFlags & ~flag;
		}
		
		protected final function render ():void
		{
			validating = true;
			validate();
			validationFlags = 0;
			validating = false;
		}
		
		
		protected function updatePosition():void
		{
			x = gameObject.x;
			y = gameObject.y;
		}
		
		protected function updateBounds():void
		{
			// Abstract
		}
		
		protected function updateScale():void
		{
			// Abstract
		}
		
		protected function updateRotation():void
		{
			// Abstract
		}
		
		protected function updateViewport():void
		{
			// Abstract
		}

		public function get sleeping():Boolean
		{
			return isSleeping;
		}
		
		public function get object():IGameObject 
		{
			return gameObject;
		}
		
		public function assignObject(value:IGameObject):void
		{
			removeObject();
			
			gameObject = value;
			
			updatePosition();
			
			gameObject.addEventListener(GameObjectEvent.OBJECT_COORDS_CHANGED, onCoordsChanged);
			gameObject.addEventListener(GameObjectEvent.OBJECT_BOUNDS_CHANGED, onBoundsChanged);
			gameObject.addEventListener(GameObjectEvent.OBJECT_FINALIZED, onFinalizeObject);
		}
		
		public function removeObject():void
		{
			if (gameObject == null)
			{
				return;
			}
			gameObject.removeEventListener(GameObjectEvent.OBJECT_COORDS_CHANGED, onCoordsChanged);
			gameObject.removeEventListener(GameObjectEvent.OBJECT_BOUNDS_CHANGED, onBoundsChanged);
			gameObject.removeEventListener(GameObjectEvent.OBJECT_FINALIZED, onFinalizeObject);
			gameObject = null;
		}
		
		public function awake():void
		{
			isSleeping = false;
		}
		
		public function sleep():void
		{
			isSleeping = true;
		}
		
		public function invalidate(...flags):void
		{
			var renderLater:Boolean = false;
			if (flags.length == 0)
			{
				flags[flags.length] = VALIDATION_FLAG_ALL;
			}
			
			for each (var flag:uint in flags)
			{
				if (!validating || !isInvalid(flag))
				{
					renderLater = true;
					setValidationFlag(flag);
				}
			}
			if (renderLater)
			{
				callLater(render);
			}

		}
		
		public function validate():void
		{
			const coordsInvalid:Boolean = isInvalid(VALIDATION_FLAG_POSITION);
			const boundsInvalid:Boolean = isInvalid(VALIDATION_FLAG_BOUNDS);
			const scaleInvalid:Boolean = isInvalid(VALIDATION_FLAG_SCALE);
			const angleInvalid:Boolean = isInvalid(VALIDATION_FLAG_ROTATION);
			const viewportInvalid:Boolean = isInvalid(VALIDATION_FLAG_VIEWPORT);
			
			if (coordsInvalid)
			{
				updatePosition();
				unsetValidationFlag(VALIDATION_FLAG_POSITION);
			}

			if (boundsInvalid)
			{
				updateBounds();
				unsetValidationFlag(VALIDATION_FLAG_BOUNDS);
			}

			if (scaleInvalid)
			{
				updateScale();
				unsetValidationFlag(VALIDATION_FLAG_SCALE);
			}

			if (angleInvalid)
			{
				updateRotation();
				unsetValidationFlag(VALIDATION_FLAG_ROTATION);
			}
			
			if (viewportInvalid)
			{
				updateViewport();
				unsetValidationFlag(VALIDATION_FLAG_VIEWPORT);
			}
			
		}
		
		public final function get canApplyDeferredCalls ():Boolean
		{
			return !isSleeping;
		}
		
		public final function callLater (method:Function, ...rest):void
		{
			callLaterManager.callLater(this, method);
		}
		
		public function finalize ():void
		{
			sleep();
			removeObject();
			validationFlags = 0;
		}
		
		protected function onCoordsChanged(event:GameObjectEvent):void
		{
			invalidate(VALIDATION_FLAG_POSITION);
		}
		
		protected function onBoundsChanged(event:GameObjectEvent):void
		{
			invalidate(VALIDATION_FLAG_BOUNDS);
		}
		
		private function onFinalizeObject(event:GameObjectEvent):void
		{
			finalize();
		}
	}
}
package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.objects.GameContainer;
	import com.tengu.tools.leditor.api.IEditableLayer;
	
	public class BaseLayer extends GameContainer implements IGameContainer, IEditableLayer
	{
		private var layerType:String;
		public function BaseLayer()
		{
			super();
		}
		
		public function set type (value:String):void
		{
			layerType = value;
		}
		
		public function get type():String
		{
			return layerType;
		}
		
		[Bindable]
		public function set focalIndexAsString (value:String):void
		{
			focalIndex = parseInt(value);
		}
		
		public function get focalIndexAsString():String 
		{
			return String(focalIndex);
		}
		
		public function set focalIndex(value:int):void 
		{
			zCoord = value;
			dispatchGameObjectEvent("focalIndexChanged", this);
		}
		
		public function get focalIndex():int 
		{
			return int(zCoord);
		}
		
		public function mouseDown (xCoord:Number, yCoord:Number):Boolean
		{
			return false;
		}
		
		public function mouseMove (dx:Number, dy:Number):void
		{
			//Abstract
		}
		
		public function mouseUp (xCoord:Number, yCoord:Number):void
		{
			//Abstract
		}
	}
}
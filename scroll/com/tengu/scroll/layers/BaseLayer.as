package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.objects.GameContainer;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.api.ISelectable;
	
	import flash.events.Event;
	
	public class BaseLayer extends GameContainer implements IGameContainer, IEditableLayer, ISelectable
	{
		private var layerType:String;
		private var isSelected:Boolean;
		
		public function BaseLayer()
		{
			super();
		}

		public function set selected (value:Boolean):void
		{
			if (isSelected == value)
			{
				return;
			}
			isSelected = value;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selected ():Boolean
		{
			return isSelected;
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
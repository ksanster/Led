package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.objects.GameContainer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.api.ILayerInfo;
	
	public class BaseLayer extends GameContainer implements IGameContainer, ILayer
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
		
		public function get focalIndex():int 
		{
			return int(zCoord);
		}
	}
}
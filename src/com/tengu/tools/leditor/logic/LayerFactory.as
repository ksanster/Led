package com.tengu.tools.leditor.logic
{
	import com.tengu.log.LogFactory;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import mx.core.UIComponent;
	
	public class LayerFactory implements ILayerFactory
	{
		private var layerClasses:Object;
		private var controlClasses:Object;
		public function LayerFactory()
		{
			initialize();
		}
		
		private function initialize():void
		{
			layerClasses = {};
			controlClasses = {};
			
			layerClasses[LayerType.INFINITE_BITMAP] = InfinityBitmapLayer;

			layerClasses[LayerType.INFINITE_BITMAP] = InfinityBitmapLayer;
		}
		
		public function create(layerType:String, zIndex:int):ILayer
		{
			var result:IGameContainer;
			var layerClass:Class = layerClasses[layerType];
			
			if (layerClass == null)
			{
				LogFactory.getLogger(this).error("Layer class not found. Layer type:" + layerType);
				return null;
			}
			
			result = new layerClass();
			(result as ILayer).type = layerType;
			result.move(0, 0, zIndex);
			return result as ILayer;
		}
		
		public function createControls (layerType:String):UIComponent
		{
			
		}
	}
}
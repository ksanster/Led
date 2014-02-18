package com.tengu.tools.leditor.logic
{
	import com.tengu.log.LogFactory;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	public class LayerFactory implements ILayerFactory
	{
		private var classes:Object;
		public function LayerFactory()
		{
			initialize();
		}
		
		private function initialize():void
		{
			classes = {};
			classes[LayerType.INFINITE_BITMAP] = InfinityBitmapLayer;
		}
		
		public function create(layerType:String, zIndex:int):ILayer
		{
			var result:IGameContainer;
			var layerClass:Class = classes[layerType];
			
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
	}
}
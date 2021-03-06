package com.tengu.tools.leditor.logic
{
	import com.tengu.log.LogFactory;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scroll.layers.ImageTileLayer;
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.enum.LayerType;
	import com.tengu.tools.leditor.view.controls.ImageTileLayerSettings;
	import com.tengu.tools.leditor.view.controls.InfinityBitmapSettings;
	
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
			controlClasses[LayerType.INFINITE_BITMAP] = InfinityBitmapSettings;

			layerClasses[LayerType.IMAGE_TILES] = ImageTileLayer;
			controlClasses[LayerType.IMAGE_TILES] = ImageTileLayerSettings;
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
			const componentClass:Class = controlClasses[layerType];
			return new componentClass();
		}
	}
}
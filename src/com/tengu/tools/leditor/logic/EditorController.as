package com.tengu.tools.leditor.logic
{
	import com.tengu.log.LogFactory;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.logic.api.IEditorController;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.LedModel;
	import com.tengu.tools.leditor.model.api.ILedModel;

	public class EditorController implements IEditorController
	{
		private var model:ILedModel;
		private var layerFactory:ILayerFactory;
		
		public function EditorController()
		{
			initialize();
		}
		
		private function initialize():void
		{
			model = LedModel.instance;
			layerFactory = new LayerFactory();
		}
		
		public function addLayer (layerType:String, zIndex:int):void
		{
			LogFactory.getLogger(this).info("Layer added: [type:" + layerType + ", zIndex:" + zIndex + "]");
			
			const layer:ILayer = layerFactory.create(layerType, zIndex);
			if (layer != null)
			{
				model.layers.addItem(layer);
			}
		}
		
		public function removeLayer (index:int):void
		{
			LogFactory.getLogger(this).debug("remove", model.layers.getItemAt(index) );
			
			model.layers.removeItemAt(index);
		}
	}
}
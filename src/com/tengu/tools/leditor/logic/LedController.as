package com.tengu.tools.leditor.logic
{
	import com.tengu.log.LogFactory;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IViewport;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.logic.api.IEditorController;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.LedModel;
	import com.tengu.tools.leditor.model.api.ILedModel;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class LedController implements IEditorController
	{
		private var model:ILedModel;
		private var layerFactory:ILayerFactory;
		
		[Inject(name="mainScene")]
		public var scene:IGameContainer;
		
		[Inject]
		public var viewport:IViewport;
		
		[Inject(name="layerControlsHolder")]
		public var layerControlsHolder:Group;
		
		public function LedController()
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
				scene.add(layer as IGameObject);				
			}
		}
		
		public function removeLayer (index:int):void
		{
			LogFactory.getLogger(this).debug("remove", model.layers.getItemAt(index) );
			
			const layer:IGameObject = model.layers.removeItemAt(index) as IGameObject;
			scene.remove(layer);
		}
		
		public function setActiveLayer (layer:IEditableLayer):void
		{
			layerControlsHolder.removeChildren();
			if (layer != null)
			{
				model.activeLayer = layer;
				const controls:UIComponent = layerFactory.createControls(layer.type);
				if (controls != null)
				{
					controls.percentWidth = 100;
					layerControlsHolder.addElement(controls);
				}
			}
			else
			{
				model.activeLayer = null;
			}
		}
		
		public function moveCameraToCenter():void
		{
			viewport.moveTo(0, 0);
		}
	}
}
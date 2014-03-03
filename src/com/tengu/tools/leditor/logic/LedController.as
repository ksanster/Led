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
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class LedController implements IEditorController
	{
		private var model:LedModel;
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
				model.layers.layerList.addItem(layer);
				scene.add(layer as IGameObject);				
			}
		}
		
		public function removeLayer (index:int):void
		{
			LogFactory.getLogger(this).debug("remove", model.layers.layerList.getItemAt(index) );
			
			const layer:IGameObject = model.layers.layerList.removeItemAt(index) as IGameObject;
			scene.remove(layer);
		}
		
		public function setActiveLayer (layer:IEditableLayer):void
		{
			layerControlsHolder.removeAllElements();
			if (layer != null)
			{
				model.layers.activeLayer = layer;
				const controls:UIComponent = layerFactory.createControls(layer.type);
				if (controls != null)
				{
					controls.percentWidth = 100;
					layerControlsHolder.addElement(controls);
				}
			}
			else
			{
				model.layers.activeLayer = null;
			}
		}
		
		public function moveCameraToCenter():void
		{
			viewport.moveTo(0, 0);
		}
		
		public function clearAll():void
		{
			
		}
		
		public function saveProject ():void
		{
			
		}
	}
}
package com.tengu.tools.leditor.logic
{
	import com.tengu.di.api.IInjector;
	import com.tengu.log.LogFactory;
	import com.tengu.net.api.ILoaderProcess;
	import com.tengu.net.contents.XMLLoaderContent;
	import com.tengu.net.errors.LoaderErrorInfo;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IViewport;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.logic.api.IEditorController;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.logic.external.ExternalManager;
	import com.tengu.tools.leditor.model.ActionModel;
	import com.tengu.tools.leditor.model.LedModel;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class LedController implements IEditorController
	{
		private var fileManager:FileManager;
		private var externalManager:ExternalManager;

		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var layerFactory:ILayerFactory;
		
		[Inject]
		public var model:LedModel;
		
		[Inject(name="mainScene")]
		public var scene:IGameContainer;
		
		[Inject]
		public var mainApp:Led;
		
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
			//empty
		}
		
		private function importLayers(xml:XML):void
		{
			const layers:Vector.<ILayer> = externalManager.importLayers(xml);	
			
			for each (var layer:ILayer in layers)
			{
				model.layers.layerList.addItem(layer);
				scene.add(layer as IGameObject);				
			}
		}
		
		[PostConstruct]
		public function postConstruct ():void
		{
			fileManager = injector.makeInstance(FileManager) as FileManager;
			externalManager = injector.makeInstance(ExternalManager) as ExternalManager;
		}
		
		public function addLayer (layerType:String, zIndex:int):void
		{
			LogFactory.getLogger(this).info("Layer added: [type:" + layerType + ", zIndex:" + zIndex + "]");
			
			const layer:ILayer = layerFactory.create(layerType, zIndex);
			if (layer != null)
			{
				injector.injectInto(layer);
				model.layers.layerList.addItem(layer);
				scene.add(layer as IGameObject);				
				
				model.files.saved = false;
			}
		}
		
		public function removeLayer (index:int):void
		{
			LogFactory.getLogger(this).debug("remove", model.layers.layerList.getItemAt(index) );
			
			const layer:IGameObject = model.layers.layerList.removeItemAt(index) as IGameObject;
			scene.remove(layer);
			if (model.layers.activeLayer == layer)
			{
				setActiveLayer(null);
			}
			model.files.saved = (model.layers.layerList.length > 0);
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
				mainApp.mainButtonBar.currentState = layer.type;
			}
			else
			{
				model.layers.activeLayer = null;
				mainApp.mainButtonBar.currentState = ActionModel.DEFAULT_BUTTONBAR_STATE;
			}
		}
		
		public function moveCameraToCenter():void
		{
			viewport.moveTo(0, 0);
		}
		
		public function clearAll():void
		{
			mainApp.mainButtonBar.currentState = ActionModel.DEFAULT_BUTTONBAR_STATE;
			layerControlsHolder.removeAllElements();
			model.layers.layerList.removeAll();
			scene.removeAll();
		}
		
		public function saveProject (saveAs:Boolean = false):void
		{
			const xml:XML = externalManager.exportLayers(model.layers.layerList);
			if (saveAs)
			{
				model.files.projectFileName = null;
			}
			fileManager.saveConfigs(xml);
		}
		
		public function loadProject ():void
		{
			const process:ILoaderProcess = fileManager.loadConfigs();
			if (process != null)
			{
				process.addCompleteHandler(onCompleteLoad);
			}
		}
		
		private function onCompleteLoad(process:ILoaderProcess, content:XMLLoaderContent, error:LoaderErrorInfo):void
		{
			process.removeCompleteHandler(onCompleteLoad);
			if (error != null)
			{
				throw new Error(error.message);
			}
			
			importLayers(content.xml);
			model.files.saved = true;
		}		
	}
}
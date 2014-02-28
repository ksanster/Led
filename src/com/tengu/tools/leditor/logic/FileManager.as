package com.tengu.tools.leditor.logic
{
	import com.tengu.net.XMLLoader;
	import com.tengu.net.api.ILoaderProcess;
	import com.tengu.net.contents.XMLLoaderContent;
	import com.tengu.net.errors.LoaderErrorInfo;
	import com.tengu.tools.leditor.model.LedModel;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	
	import mx.collections.XMLListCollection;

	public class FileManager
	{
		private var model:LedModel = LedModel.instance;
		private var fillsConfig:XML = null;
		private var swfConfig:ApplicationDomain = null;
		private var cssConfig:String = null;
		private var markupConfig:XML = null;
		
		public function FileManager()
		{
			//Empty
		}
		
		public function saveConfigs():void
		{
			var file:File = null;
			var stream:FileStream = null;
			file = new File(model.projectFileName);
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(new XML("<components>" + model.currentMarkup.toXMLString() + "</components>"));		
			stream.close();
		}
		
		public function loadConfigs():void
		{
			var file:File = null;

			file = new File(model.projectFileName);
			if (file.exists)
			{
				loadProjectConfig(file.url);
			}
			else
			{
				model.currentMarkup = new XMLListCollection();
			}
		}
		
		private function loadProjectConfig(url:String):void
		{
			var loader:XMLLoader = new XMLLoader();
			loader.loadURL(url);
			loader.addCompleteHandler(onCompleteProject);
		}
		
		private function onCompleteProject(process:ILoaderProcess, content:XMLLoaderContent, error:LoaderErrorInfo):void
		{
			process.removeCompleteHandler(onCompleteProject);
			if (error != null)
			{
				throw new Error(error.message);
			}
			model.currentMarkup = new XMLListCollection(content.xml.children());
			markupConfig = content.xml;
			checkIsAllComplete();
		}		

	}
}
package com.tengu.tools.leditor.logic
{
	import com.tengu.net.LoaderProcess;
	import com.tengu.net.XMLLoader;
	import com.tengu.net.api.ILoaderProcess;
	import com.tengu.net.contents.LoaderContent;
	import com.tengu.net.contents.XMLLoaderContent;
	import com.tengu.net.errors.LoaderErrorInfo;
	import com.tengu.tools.leditor.logic.external.FileLoaderProcess;
	import com.tengu.tools.leditor.model.LedModel;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;

	public class FileManager
	{
		private var model:LedModel = LedModel.instance;
		
		private var fileOpenDialog:File;
		private var fileSaveDialog:File;
		private var fileFilter:FileFilter
		
		private var loaderProcess:FileLoaderProcess;
		public function FileManager()
		{
			fileFilter = new FileFilter("Config (.xml)", "*.xml");
			fileOpenDialog = File.applicationDirectory;
			fileSaveDialog = File.applicationDirectory;

			fileOpenDialog.addEventListener(Event.SELECT, onSelectFileForOpen);
			fileSaveDialog.addEventListener(Event.SELECT, onSelectFileForSave);
		}
		
		public function saveConfigs(configs:XML):void
		{
			model.files.content = configs;
			if (model.files.projectFileName == null)
			{
				fileSaveDialog.browseForSave("Select file");
				return;
			}
			save();
		}
		
		public function loadConfigs():ILoaderProcess
		{
			if (loaderProcess != null)
			{
				loaderProcess.completeWithError("New process started");
			}
			model.files.projectFileName = null;

			loaderProcess = new FileLoaderProcess();
			fileOpenDialog.browseForOpen("Select file for open", [fileFilter]);
			
			return loaderProcess;
		}
		
		private function load ():void
		{
			var loader:XMLLoader;
			var file:File = null;
			
			if (model.files.projectFileName == null)
			{
				loaderProcess.completeWithError("File not selected");
				loaderProcess = null;
				return;
			}
		
			file = new File(model.files.projectFileName);
			if (file.exists)
			{
				loader = new XMLLoader();
				loader.addCompleteHandler(onLoadComplete);
				loader.loadURL(file.url);
			}
			else
			{
				loaderProcess.completeWithError("File not exists");
				loaderProcess = null;
			}
			
		}
		
		private function save ():void
		{
			var file:File = new File(model.files.projectFileName);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(new XML("<components>" + model.files.content.toXMLString() + "</components>"));		
			stream.close();
			model.files.saved = true;
		}
		
		private function onSelectFileForOpen(event:Event):void
		{
			model.files.projectFileName = fileOpenDialog.nativePath;
			load();
		}
		
		private function onSelectFileForSave(event:Event):void
		{
			model.files.projectFileName = fileSaveDialog.nativePath;
			save();
		}
		
		
		private function onLoadComplete(process:ILoaderProcess, content:XMLLoaderContent, error:LoaderErrorInfo):void
		{
			if (error != null)
			{
				loaderProcess.completeWithError(error.message);
			}
			else
			{
				loaderProcess.completeWithSuccess(content);
			}
			loaderProcess = null;
		}
	}
}
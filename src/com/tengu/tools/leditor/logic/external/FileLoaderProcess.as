package com.tengu.tools.leditor.logic.external
{
	import com.tengu.net.LoaderProcess;
	import com.tengu.net.api.ILoaderProcess;
	import com.tengu.net.contents.XMLLoaderContent;
	import com.tengu.net.enum.LoaderErrorType;
	import com.tengu.net.errors.LoaderErrorInfo;
	
	public class FileLoaderProcess extends LoaderProcess implements ILoaderProcess
	{
		public function FileLoaderProcess()
		{
			super();
		}
		
		public function completeWithSuccess (content:XMLLoaderContent):void
		{
			complete(content);
		}
		
		public function completeWithError(error:String):void
		{
			const errorInfo:LoaderErrorInfo = new LoaderErrorInfo(LoaderErrorType.CONTENT, error);
			fault(errorInfo);
		}
	}
}
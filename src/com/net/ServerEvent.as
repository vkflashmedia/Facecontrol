package com.net
{
	import flash.events.Event;

	public class ServerEvent extends Event
	{
		public static const ERROR:String = 'ERROR';
		public static const TOP_LOAD_COMPLETED:String = 'TOP_LOAD_COMPLETED';
		public static const REG_USER_COMPLETED:String = 'REG_USER_COMPLETED';
		
		public var errorCode:int;
		public var errorMessage:String;
		public var response:Object;
		
		public function ServerEvent(type:String, response:Object=null, errorCode:int=0, errorMessage:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.response = response;
			this.errorCode = errorCode;
			this.errorMessage = errorMessage;
		}
		
	}
}
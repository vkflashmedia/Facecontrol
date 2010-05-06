package com.net
{
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class Server extends EventDispatcher
	{
//		private static const SERVER_URL:String = 'http://facecontrol/';
		private static const SERVER_URL:String = 'http://www.public.facecontrol/';
		
		private const topLoader:URLLoader = new URLLoader();
		private const regLoader:URLLoader = new URLLoader();
		
		public function Server()
		{
			topLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			topLoader.addEventListener(Event.COMPLETE, onTopLoaded);
			
			regLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			regLoader.addEventListener(Event.COMPLETE, onRegistred);
		}
		
		private static function request(vars:URLVariables, loader:URLLoader):void {
			var request: URLRequest = new URLRequest();
			request.url = SERVER_URL;
			request.data = vars;
			loader.load(request);
		}
		
		private function checkOnError(json:Object):void {
			if (json.hasOwnProperty('error')) {
				json = json.error;
				var errorCode:int = json.err_code;
				var errorMessage:String = null;
				
				if (json.hasOwnProperty('err_msg')) {
					errorMessage = json.err_msg;
				}
				dispatchEvent(new ServerEvent(ServerEvent.ERROR, null, errorCode, errorMessage));
			}
		}
		
		private function onError(event:IOErrorEvent):void {
			dispatchEvent(new ServerEvent(ServerEvent.ERROR, null, 255, event.text));
		}
		
		public function getTop(uid:uint):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			vars['uid'] = uid;
			request(vars, topLoader);
		}
		
		private function onTopLoaded(event:Event):void {
			trace(topLoader.data);
			try {
				var json:Object = JSON.deserialize(topLoader.data);
				checkOnError(json);
				if (json.hasOwnProperty('response')) {
					dispatchEvent(new ServerEvent(ServerEvent.TOP_LOAD_COMPLETED, json.response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new ServerEvent(ServerEvent.ERROR, null, 254, e.message));
			}
		}
		
		public function registerUser(uid:int, fname:String, lname:String, nickname:String, sex:int, bdate:String, city:int, country:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'reg_user';
			vars['uid'] = uid;
			vars['fname'] = fname;
			vars['lname'] = lname;
			
			if (nickname) vars['nickname'] = nickname;
			vars['sex'] = sex;
			
			if (bdate) vars['bdate'] = bdate;
			vars['city'] = city;
			vars['country'] = country;
			
			request(vars, regLoader);
		}
		
		private function onRegistred(event:Event):void {
			trace('onRegistred: ' + regLoader.data);
			try {
				var json:Object = JSON.deserialize(regLoader.data);
				checkOnError(json);
				if (json.hasOwnProperty('response')) {
					dispatchEvent(new ServerEvent(ServerEvent.REG_USER_COMPLETED, json.response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new ServerEvent(ServerEvent.ERROR, null, 254, e.message));
			}
		}
	}
}
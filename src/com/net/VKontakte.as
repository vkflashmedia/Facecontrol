package com.net
{
	import com.gsolo.encryption.MD5;
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class VKontakte extends EventDispatcher
	{
		public static const STATE_NONE:uint = 0;
		public static const STATE_GET_PROFILES:uint = 1;
		public static const STATE_GET_APP_FRIENDS:uint = 2;
		public static const STATE_GET_FRIENDS:uint = 3;
		
		private static const FC_API_SERVER:String = 'http://api.vkontakte.ru/api.php';
		private const loader:URLLoader = new URLLoader();
		
		public var state:uint = STATE_NONE;
		
		public function VKontakte()
		{
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function request(vars:URLVariables):void
		{
			var request: URLRequest = new URLRequest();
			request.url = FC_API_SERVER;
			request.data = vars;
			loader.load(request);
		}
		
		private function errorHandler(e:IOErrorEvent):void {
			dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, null, 255));
			state = STATE_NONE;
		}
		
		private function completeHandler(event:Event):void
		{
			trace(loader.data);
			try {
				var response:Object = JSON.deserialize(loader.data);
				
				if (response.hasOwnProperty('error')) {
					response = response.error;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, null, null, response.error_code, response.error_msg));
				}
				else if (response.hasOwnProperty('response')) {
					var method:String;
					switch (state) {
						case STATE_GET_PROFILES:
							method = 'getProfiles';
						break;
						case STATE_GET_APP_FRIENDS:
							method = 'getAppFriends';
						break;
						case STATE_GET_FRIENDS:
							method = 'getFriends';
						break;
					}
					response = response.response;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.COMPLETED, method, response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, null, null, 254, e.message));
			}
			state = STATE_NONE;
		}
		
		public function getProfiles(uid:int):void {
			if (state == STATE_NONE) {
				state = STATE_GET_PROFILES;
				
				var vars: URLVariables = new URLVariables();
				var fields:String = 'uid,first_name,last_name,nickname,sex,bdate,city,photo_big,country';
				var sig:String = '57856825'+'api_id=1827403'+
					'fields='+fields+
					'format=json'+
					'method=getProfiles'+'test_mode=1'+'uids='+uid+'v=2.0'+'EqKl8Wg2be';
					
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'getProfiles';
				vars['uids'] = uid;
				vars['fields'] = fields;
				vars['format'] = 'json';
				vars['test_mode'] = 1;
				vars['sig'] = MD5.encrypt(sig);
				
				request(vars);
			}
		}
		
		public function isAppUser():void {
			if (state == STATE_NONE) {
				state = STATE_GET_PROFILES;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=isAppUser'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'isAppUser';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request(vars);
			}
		}
		
		public function getFriends():void {
			if (state == STATE_NONE) {
				state = STATE_GET_FRIENDS;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=getFriends'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'getFriends';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request(vars);
			}
		}
		
		public function getAppFriends():void {
			if (state == STATE_NONE) {
				state = STATE_GET_APP_FRIENDS;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=getAppFriends'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'getAppFriends';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request(vars);
			}
		}
	}
}
package com.facecontrol.api
{
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	public class Api extends EventDispatcher
	{
		private static const FC_API_SERVER:String = 'http://facecontrol/';
		private const loader:URLLoader = new URLLoader();
		
		public function Api()
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
		
		private function errorHandler(e:IOErrorEvent):void
		{
			dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, 255));
		}
		
		private function completeHandler(event:Event):void
		{
			try
			{
				var response:Object = JSON.deserialize(loader.data);
				response = response['response'];
				if (response.hasOwnProperty('err_code'))
				{
					var errorCode:int = response.err_code;
					dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, errorCode));
				}
				else
				{
					dispatchEvent(new ApiEvent(ApiEvent.COMPLETED, response));
				}
			}
			catch (e:Error)
			{
				dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, 254, e.message));
			}
		}
		
		public function registerUser(uid:int, fname:String, lname:String, nickname:String, sex:int, bdate:String, city:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'reg_user';
			vars['uid'] = uid;
			vars['fname'] = fname;
			vars['lname'] = lname;
			if (nickname != null) vars['nickname'] = nickname;
			vars['sex'] = sex;
			if (bdate != null) vars['bdate'] = bdate;
			vars['city'] = city;
			
			request(vars);
		}
		
		public function saveSettings(uid:int, sex:int=0, minAge:int=8, maxAge:int=99, city:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'save_settings';
			vars['uid'] = uid;
			vars['sex'] = sex;
			vars['age_min'] = minAge;
			vars['max_age'] = maxAge;
			if (city != null) vars['city'] = city;
			
			request(vars);
		}
		
		public function loadSettings(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'load_settings';
			vars['uid'] = uid;
			
			request(vars);
		}
		
		public function addPhoto(uid:int, src:String, src_small:String, src_big:String, comment:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'add_photo';
			vars['uid'] = uid;
			vars['src'] = src;
			vars['src_small'] = src_small;
			vars['src_big'] = src_big;
			if (comment != null) vars['comment'] = comment;
			
			request(vars);
		}
		
		public function getPhotos(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'get_photos';
			vars['uid'] = uid;
			
			request(vars);
		}
		
		public function deletePhoto(pid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'del_photo';
			vars['pid'] = pid;
			
			request(vars);
		}
		
		public function editPhoto(pid:int, src:String, src_small:String, src_big:String, comment:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'edit_photo';
			vars['pid'] = pid;
			vars['src'] = src;
			vars['src_small'] = src_small;
			vars['src_big'] = src_big;
			if (comment != null) vars['comment'] = comment;
			
			request(vars);
		}
		
		public function vote(uid:int, pid:String, rating:int=1):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'vote';
			vars['uid'] = uid;
			vars['pid'] = pid;
			vars['rating'] = rating;
			
			request(vars);
		}
		
		public function setMain(pid:String):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_main';
			vars['pid'] = pid;
			
			request(vars);
		}
		
		public function nextPhoto(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'next_photo';
			vars['uid'] = uid;
			
			request(vars);
		}
		
		public function top100():void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			
			request(vars);
		}
		
		public function bottom100():void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			
			request(vars);
		}
	}
}
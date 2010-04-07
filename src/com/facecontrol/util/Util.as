package com.facecontrol.util
{
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.flashmedia.basics.GameScene;
	
	public class Util
	{
		public static var userId:uint = 1;
		public static var multiLoader: MultiLoader = new MultiLoader();
		public static var scene:GameScene;
		public static var api:Api = new Api();
	}
}
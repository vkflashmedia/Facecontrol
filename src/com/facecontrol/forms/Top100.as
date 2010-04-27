package com.facecontrol.forms
{
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;

	public class Top100 extends GameLayer
	{
		private static var _instance:Top100 = null;
		
		public static function get instance():Top100 {
			if (!_instance) _instance = new Top100(Util.scene);
			return _instance;
		}
		
		public function Top100(value:GameScene)
		{
			super(value);
			visible = false;
		}
		
	}
}
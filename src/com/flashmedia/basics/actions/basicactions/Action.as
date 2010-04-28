package com.flashmedia.basics.actions.basicactions
{
	import com.flashmedia.basics.GameScene;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class Action extends EventDispatcher
	{
		protected var _scene: GameScene;
		protected var _name: String;
		protected var _dispObject: DisplayObject;
		
		public function Action(scene: GameScene, name: String, dispObject: DisplayObject)
		{
			_scene = scene;
			_name = name;
			_dispObject = dispObject;
		}

		public function get nameAction(): String {
			return _name;
		}
		
	}
}
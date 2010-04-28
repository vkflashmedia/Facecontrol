package com.flashmedia.basics
{
	import flash.events.Event;
	
	public class GameSceneEvent extends Event
	{
		public static const TYPE_TICK: String = 'type_tick';
		
		private var _scene: GameScene;
		
		public function GameSceneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get scene(): GameScene {
			return _scene;
		}
		
		public function set scene(value: GameScene): void {
			_scene = value;
		}
	}
}
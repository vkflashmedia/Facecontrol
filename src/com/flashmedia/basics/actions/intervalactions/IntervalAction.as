package com.flashmedia.basics.actions.intervalactions
{
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	import com.flashmedia.basics.actions.basicactions.Action;
	
	import flash.display.DisplayObject;

	public class IntervalAction extends Action
	{
		public const STATE_STOPPED: uint = 10;
		public const STATE_STARTED: uint = 11;
		public const STATE_PAUSED: uint = 12;
		
		protected var _state: uint;
		protected var _iterationsCount: int;
		protected var _curIteration: int;
		
		public function IntervalAction(scene: GameScene, name:String, dispObject: DisplayObject)
		{
			super(scene, name, dispObject);
			_iterationsCount = 1;
			_curIteration = 0;
			_state = STATE_STOPPED;
			_scene.addEventListener(GameSceneEvent.TYPE_TICK, onTick);
		}
		
		protected function get isActive(): Boolean {
			return _state == STATE_STARTED;
		}
		
		protected function get isStopped(): Boolean {
			return _state == STATE_STOPPED;
		}
		
		protected function get isPaused(): Boolean {
			return _state == STATE_PAUSED;
		}
		
		protected function _startIntervalAction(iterationsCount: int = 1): void {
			switch (_state) {
				case STATE_STARTED:
				case STATE_PAUSED:
					_stopIntervalAction();
				break;
				case STATE_STOPPED:
				
				break;
			}
			_iterationsCount = iterationsCount;
			if (_iterationsCount != 0) {
				_state = STATE_STARTED;
			}
			//todo dispatch
		}
		
		protected function _pauseIntervalAction(): void {
			_state = STATE_PAUSED;
			//todo dispatch
		}
		
		protected function _stopIntervalAction(): void {
			_curIteration = 0;
			_state = STATE_STOPPED;
			//todo dispaltch
		}
		
		protected function _endIntervalAction(): void {
			if (_iterationsCount < 0 || _curIteration < (_iterationsCount - 1)) {
				_curIteration++;
				_state = STATE_STARTED;
			}
			else {
				_stopIntervalAction();
			}
			//todo dispaltch
		}
		
		protected function onTick(event: GameSceneEvent): void {
			switch (_state) {
				case STATE_STOPPED:
				
				break;
				case STATE_STARTED:
				
				break;
				case STATE_PAUSED:
				
				break;
			}
		}
		
		//		protected function _stopIterationIntervalAction(): void {
//			//todo dispatch
//			if (_curIteration < (_iterationsCount - 1)) {
//				_curIteration++;
//				_startIterationIntervalAction();
//			}
//			else {
//				_stopIntervalAction();
//			}
//		}
//		
	}
}
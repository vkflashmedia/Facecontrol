package com.flashmedia.basics
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * Базовый слой со специальными возможностями по управлению объектами.
	 */
	public class GameScene extends Sprite
	{
		public const FPS_DEF: uint = 30;
		public const TPS_DEF: uint = 30;
		public const DEBUG_TEXT_COLOR: uint = 0xff0000;
		
		private const MODAL_BLOCK_LAYER_Z_ORDER: int = GameObject.MAX_Z_ORDER + 1;
		private const MODAL_GAME_OBJECT_Z_ORDER: int = MODAL_BLOCK_LAYER_Z_ORDER + 1;
		
		protected var _fps: uint;
		protected var _tps: uint;
		protected var _realFps: uint;
		protected var _realTps: uint;
		protected var _realFpsCount: uint;
		protected var _realTpsCount: uint;
		protected var _isModalShow: Boolean;
		private var _framesTimeStamp: Number;
		private var _ticksTimeStamp: Number;
		private var _modalBlockLayer: GameLayer;
		private var _savedModalGameObjectsAttrs: Array;
		
		protected var _debug: Boolean;
		protected var _debugText: TextField;

		protected var _selectedGameObject: GameObject;		
		protected var _timer: Timer;
		
		public function GameScene() {
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.NORMAL;
			stage.stageFocusRect = false;
			fps = FPS_DEF;
			tps = TPS_DEF;
			_debug = false;
			_realFps = 0;
			_realTps = 0;
			_realFpsCount = 0;
			_realTpsCount = 0;
			_framesTimeStamp = 0;
			_ticksTimeStamp = 0;
			_isModalShow = false;
			_savedModalGameObjectsAttrs = new Array();
			stage.addEventListener(MouseEvent.CLICK, mouseClickListener);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_timer = new Timer(1000 / _tps, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		public function destroy(): void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
		}
		
		/**
		 * Получить любой игровой объект со сцены по имени.
		 */
		public function getGameObject(value: String): void {
			//TODO глобальный список всех объектов, которые только есть на сцене.
		}
		
		public override function addChild(value: DisplayObject): DisplayObject {
			super.addChild(value);
			if (_isModalShow) {
				super.addChild(_modalBlockLayer);
			}
			return value;
		}
		
		public function get fps(): uint {
			return _fps;
		}
		
		public function set fps(value: uint): void {
			_fps = value;
			stage.frameRate = _fps;
		}
		
		public function get tps(): uint {
			return _tps;
		}
		
		public function set tps(value: uint): void {
			_tps = value;
		}
		
		public override function set width(value:Number):void {
			//throw new IllegalOperationError('Can not set \'width\' property for \'GameScene\' object');
		}
		
		public override function set height(value:Number):void {
			//throw new IllegalOperationError('Can not set \'height\' property for \'GameScene\' object');
		}
		
		public function get selectedGameObject(): GameObject {
			return _selectedGameObject;
		}

		/**
		 * Установить фокус на игровой объект
		 */		
		public function set selectedGameObject(value: GameObject): void {
			if (_selectedGameObject == value) {
				return;
			}
			if (_selectedGameObject) {
				_selectedGameObject.focus = false;
			}
			_selectedGameObject = value;
			if (_selectedGameObject) {
				_selectedGameObject.focus = true;
			}
		}
		
		/**
		 * Показать в модальном режиме игровой объект.
		 * Объект на время оказывается поверх всех. Выделение остальных объектов невозможно.
		 * Объект может быть уже добавлен в сцену, а может быть и совершенно новым.
		 */ 
		public function showModal(value: GameObject): void {
			_isModalShow = true;
			updateModalBlockLayer();
			var attrs: Object = new Object();
			attrs.zOrder = value.zOrder;
			value.internalZOrder = MODAL_GAME_OBJECT_Z_ORDER;
			if (!value.gameLayer) {
				_modalBlockLayer.addChild(value);
				attrs.added = true;
			}
			else {
				attrs.added = false;
			}
			_savedModalGameObjectsAttrs.push(attrs);
			selectedGameObject = null;
		}
		
		/**
		 * Отменить модальный показ объекта.
		 * Объекту возвращается его предыдущий zOrder.
		 * Если перед показом объект ыл добавлен на сцену, то удаляем его со сцены.
		 */
		public function resetModal(value: GameObject): void {
			_isModalShow = false;
			updateModalBlockLayer();
			var attrs: Object = _savedModalGameObjectsAttrs.pop();
			value.internalZOrder = attrs.zOrder;
			if (attrs.added) {
				value.setGameLayer(null);
				_modalBlockLayer.removeChild(value);
			}
		}
		
		public function get isModalShow(): Boolean {
			return _isModalShow;
		}
		
		protected function onTimer(event: TimerEvent): void {
			if (_debug) {
				var now: Date = new Date();
				if (now.time - _ticksTimeStamp >= 1000) {
					_realTps = _realTpsCount;
					_realTpsCount = 0;
					_ticksTimeStamp = now.time;
					drawDebugInfo();
				}
				else {
					_realTpsCount++;
				}
			}
		}
		
		//TODO render
		protected function onEnterFrame(event: Event): void {
			if (_debug) {
				var now: Date = new Date();
				if (now.time - _framesTimeStamp >= 1000) {
					_realFps = _realFpsCount;
					_realFpsCount = 0;
					_framesTimeStamp = now.time;
					drawDebugInfo();
				}
				else {
					_realFpsCount++;
				}
			}
		}
		
		protected function drawDebugInfo(): void {
			graphics.clear();
			if (_debug) {
				if (!_debugText) {
					_debugText = new TextField();
					_debugText.wordWrap = true;
					_debugText.selectable = false;
					_debugText.autoSize = TextFieldAutoSize.LEFT;
					_debugText.setTextFormat(new TextFormat('Arial', 10));
					_debugText.textColor = DEBUG_TEXT_COLOR;
					_debugText.x = 10;
					_debugText.y = 10;
				}
				_debugText.text = '';
				//TODO сделать статистику по объектам
				// System.totalMemory
				_debugText.appendText('FPS: ' + _realFps + '\n\r');
				_debugText.appendText('TPS: ' + _realTps + '\n\r');
				_debugText.appendText('Memory: \n\r');
				_debugText.appendText('GameObjects: \n\r');
				_debugText.appendText('GameLayers: \n\r');
				_debugText.appendText('Sprites: \n\r');
				_debugText.appendText('Bitmaps: \n\r');
				if (!contains(_debugText)) {
					super.addChild(_debugText);
				}
				graphics.lineStyle(1, GameObject.BORDERS_COLOR);
				graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			}
			else {
				if (_debugText) {
					removeChild(_debugText);
				}
			}
		}
		
		protected function mouseClickListener(event: MouseEvent): void {
			selectedGameObject = null;
		}
		
		protected function keyDownListener(event: KeyboardEvent): void {
			
		}
		
		private function updateModalBlockLayer(): void {
			if (!_modalBlockLayer) {
	    		_modalBlockLayer = new GameLayer(this);
	    		_modalBlockLayer.internalZOrder = MODAL_BLOCK_LAYER_Z_ORDER;
	  		}
	  		_modalBlockLayer.visible = _isModalShow;
	  		if (_isModalShow) {
		  		_modalBlockLayer.graphics.beginFill(0xffffff, 0.0);
		  		_modalBlockLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		  		_modalBlockLayer.graphics.endFill();
				super.addChild(_modalBlockLayer); // делаем каждый раз, чтобы слой оказывался на верху
	  		}
		}
	}
}
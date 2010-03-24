package com.flashmedia.basics
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	//TODO возможно потребуется кроп слоя по краям
	public class GameLayer extends GameObject
	{
		public static const SCROLL_POLICY_NONE: String = 'scroll_policy_none';
		public static const SCROLL_POLICY_AUTO: String = 'scroll_policy_auto';
		public static const SCROLL_STEP: uint = 10;
		
		protected var _horizontalScrollPolicy: String;
		protected var _verticalScrollPolicy: String;
		protected var _horizontalScrollStep: uint;
		protected var _verticalScrollStep: uint;
		protected var _smoothScroll: Number;
//		protected var _cropBySize: Boolean;
		protected var _topScrollIndent: Number;
		protected var _leftScrollIndent: Number;
		protected var _rightScrollIndent: Number;
		protected var _bottomScrollIndent: Number;
		// позиция прокрутки по горизонтали и вертикали в процентах от (0.0 - 1.0)
		protected var _horizontalPosition: uint;
		protected var _verticalPosition: uint;
		
		public function GameLayer(value: GameScene)
		{
			super(value);
//			_cropBySize = true;
			_type = 'GameLayer';
			_horizontalScrollPolicy = SCROLL_POLICY_AUTO;
			_verticalScrollPolicy = SCROLL_POLICY_AUTO;
			_horizontalScrollStep = SCROLL_STEP;
			_verticalScrollStep = SCROLL_STEP;
			_smoothScroll = 0;
			_topScrollIndent = 0;
			_leftScrollIndent = 0;
			_rightScrollIndent = 0;
			_bottomScrollIndent = 0;
		}
		
//		public function get cropBySize(): Boolean {
//			return _cropBySize;
//		}
//		
//		public function set cropBySize(value: Boolean): void {
//			_cropBySize = value;
//		}
		
		public override function addChild(child: DisplayObject): DisplayObject {
			super.addChild(child);
			if (child is GameObject) {
				(child as GameObject).setGameLayer(this);
			}
			sortChildsByZ();
			return child;
		}
		
		public function set verticalScrollPolicy(value: String): void {
			_verticalScrollPolicy = value;
		}
		
		public function get verticalScrollPolicy(): String {
			return _verticalScrollPolicy;
		}
		
		public function set horizontalScrollPolicy(value: String): void {
			_horizontalScrollPolicy = value;
		}
		
		public function get horizontalScrollPolicy(): String {
			return _horizontalScrollPolicy;
		}
		
		public function set verticalScrollStep(value: uint): void {
			_verticalScrollStep = value;
		}
		
		public function get verticalScrollStep(): uint {
			return _verticalScrollStep;
		}
		
		public function set horizontalScrollStep(value: uint): void {
			_horizontalScrollStep = value;
		}
		
		public function get horizontalScrollStep(): uint {
			return _horizontalScrollStep;
		}
		
		/**
		 * Плавность прокрутки. Значение (0.0 - 1.0)
		 */
		public function set smoothScroll(value: Number): void {
			//TODO реализация плавности - это уже анимация. Потом сделать.
			if (value > 1) {
				value = 1;
			}
			else if (value < 0) {
				value = 0;
			}
			_smoothScroll = value;
		}
		
		public function get smoothScroll(): Number {
			return _smoothScroll;
		}

		/**
		 * Установить допустимые отступы для прокрутки с каждой стороны.
		 */
		public function scrollIndents(topScrollIndent: Number, leftScrollIndent: Number, rightScrollIndent: Number, bottomScrollIndent: Number): void {
			_topScrollIndent = topScrollIndent;
			_leftScrollIndent = leftScrollIndent;
			_rightScrollIndent = rightScrollIndent;
			_bottomScrollIndent = bottomScrollIndent;
			scroll(_leftScrollIndent, _topScrollIndent);
		}
		
		/**
		 * Прокрутить слой на заданную величину
		 */
		public function scroll(deltaX: int, deltaY: int): void {
			if (scrollRect) {
				var rect: Rectangle = scrollRect;
				rect.x += deltaX;
				rect.y += deltaY;
				if (rect.y < _topScrollIndent) {
					rect.y = _topScrollIndent;
				}
				if (rect.y > _height - rect.height - _bottomScrollIndent) {
					rect.y = _height - rect.height - _bottomScrollIndent;
				}
				if (rect.x < _leftScrollIndent) {
					rect.x = _leftScrollIndent;
				}
				if (rect.x > _width - rect.width - _rightScrollIndent) {
					rect.x = _width - rect.width - _rightScrollIndent;
				}
				scrollRect = rect;
			}
		}
		
		public function get verticalPosition(): Number {
			if (scrollRect) {
				return (scrollRect.y - _topScrollIndent) / (_height - _topScrollIndent - _bottomScrollIndent - scrollRect.height);
			}
			return 0;
		}
		
		public function get horizontalPosition(): Number {
			if (scrollRect) {
				return (scrollRect.x - _leftScrollIndent) / (_width - _leftScrollIndent - _rightScrollIndent - scrollRect.width);
			}
			return 0;
		}

//		/**
//		 * Установить область прокрутки.
//		 * Размер области прокрутки не может быть больше самого слоя.
//		 */
//		public override function set scrollRect(value: Rectangle): void {
//			
//		}
		
		internal function sortChildsByZ(): void {
			var count: int = numChildren;
			var tempChilds: Array = new Array();
			for (var i: int = 0; i < count; i++) {
				if (getChildAt(i) is GameObject) {
					tempChilds.push(getChildAt(i) as GameObject);
				}
			}
			tempChilds.sortOn('zOrder', Array.NUMERIC);
			for (i = 0; i < tempChilds.length; i++) {
				super.addChild(tempChilds[i]);
			}
		}

		protected override function keyboardListener(event: KeyboardEvent): void {
			super.keyboardListener(event);
			if (_verticalScrollPolicy == GameLayer.SCROLL_POLICY_AUTO) {
				if (event.keyCode == Keyboard.UP) {
					scroll(0, -_verticalScrollStep);
				}
				else if (event.keyCode == Keyboard.DOWN) {
					scroll(0, _verticalScrollStep);
				}
			}
			if (_horizontalScrollPolicy == GameLayer.SCROLL_POLICY_AUTO) {
				if (event.keyCode == Keyboard.LEFT) {
					scroll(-_horizontalScrollStep, 0);
				}
				else if (event.keyCode == Keyboard.RIGHT) {
					scroll(_horizontalScrollStep, 0);
				}
			}
		}
		
		protected override function drawDebugInfo(): void {
			//TODO дописать функция, чтобы было видно scrollRect, top\left\right\bottom-Indent, positions
			super.drawDebugInfo();
		}
	}
}
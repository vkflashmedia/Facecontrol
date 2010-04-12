package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ScrollBar extends GameObject
	{
		public static const TYPE_VERTICAL: String = 'type_vertical';
		public static const TYPE_HORIZONTAL: String = 'type_horizontal';
		public const VIEW_TOP_ICON: int = 2;
		public const VIEW_BOTTOM_ICON: int = 4;
		public const VIEW_BACKGROUND: int = 8;
		public const VIEW_ALL: int = 16;
		
		private var _topIcon: Sprite;
		private var _bottomIcon: Sprite;
		private var _scrollImage: Sprite;
		private var _backImage: Sprite;
		private var _position: Number;
		private var _scrollType: String;
		private var _isActive: Boolean;
		private var _viewImagesPolicy: int;
		private var _draggingScroll: Boolean;
		
		public function ScrollBar(value: GameScene, x: int, y: int, width: int, height: int, scrollType: String = TYPE_VERTICAL, isActive: Boolean = true, viewImagesPolicy: int = VIEW_ALL)
		{
			super(value);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			//setSelect(true);
			_position = 0;
			_scrollType = scrollType;
			_viewImagesPolicy = viewImagesPolicy;
			_isActive = isActive;
			_draggingScroll = false;
			update();
		}
		
		//TODO горизонтальный скролл
		
		//TODO эффективное задание интерфейса бара 
		
		//TODO настройка шага перемещения 
		
		public override function set height(value: Number): void {
			super.height = value;
			update();
		}
		
		public override function set width(value: Number): void {
			super.width = value;
			update();
		}
		
		public function set position(value: Number): void {
			if (value > 1.0) {
				value = 1.0;
			}
			else if (value < 0) {
				value = 0;
			}
			if (value != _position) {
				_position = value;
				update();
				var event: ScrollBarEvent = new ScrollBarEvent(ScrollBarEvent.TYPE_SCROLL);
				event.position = position;
				dispatchEvent(event);
			}
		}
		
		public function get position(): Number {
			return _position;
		}
		
//		public function set topIcon(value: Bitmap): void {
//			//_topIcon = value;
//		}
		
		private function update(): void {
			if ((_viewImagesPolicy & VIEW_BACKGROUND) == VIEW_BACKGROUND || (_viewImagesPolicy & VIEW_ALL) == VIEW_ALL) {
				if (!_backImage) {
					_backImage = getStandartBackground();
					_view.addDisplayObject(_backImage, 'back', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER);
				}
			}
			if ((_viewImagesPolicy & VIEW_TOP_ICON) == VIEW_TOP_ICON || (_viewImagesPolicy & VIEW_ALL) == VIEW_ALL) {
				if (!_topIcon) {
					_topIcon = getStandartIcon();
					if (_isActive) {
						_topIcon.addEventListener(MouseEvent.MOUSE_DOWN, onTopIconMouseDown);
					}
					_view.addDisplayObject(_topIcon, 'topIcon', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER, View.ALIGN_VER_TOP | View.ALIGN_HOR_LEFT);
				}
			}
			if ((_viewImagesPolicy & VIEW_BOTTOM_ICON) == VIEW_BOTTOM_ICON || (_viewImagesPolicy & VIEW_ALL) == VIEW_ALL) {
				if (!_bottomIcon) {
					_bottomIcon = getStandartIcon();
					if (_isActive) {
						_bottomIcon.addEventListener(MouseEvent.MOUSE_DOWN, onBottomIconMouseDown);
					}
					_view.addDisplayObject(_bottomIcon, 'bottomIcon', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER, View.ALIGN_VER_BOTTOM | View.ALIGN_HOR_RIGHT);
				}
			}
			if (!_scrollImage) {
				_scrollImage = new Sprite();
				_scrollImage.tabEnabled = true;
				if (_isActive) {
					_scrollImage.addEventListener(MouseEvent.MOUSE_DOWN, onScrollImageMouseDown);
					_scrollImage.addEventListener(MouseEvent.MOUSE_MOVE, onScrollImageMouseMove);
					_scrollImage.addEventListener(MouseEvent.MOUSE_UP, onScrollImageMouseUp);
				}
				_view.addDisplayObject(_scrollImage, 'scroll', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER);
			}
			_scrollImage.graphics.clear();
			_scrollImage.graphics.beginFill(0xff0000, GameObject.FOCUS_ALPHA);
			if (_scrollType == TYPE_HORIZONTAL) {
				_scrollImage.graphics.drawRect(0, 0, width / 5, height);
				_scrollImage.x = ((_topIcon) ? _topIcon.width : 0) + getScrollAreaLength() * _position;
			}
			else {
				_scrollImage.graphics.drawRect(0, 0, width, height / 5);
				_scrollImage.y = ((_topIcon) ? _topIcon.height : 0) + getScrollAreaLength() * _position;
			}
			_scrollImage.graphics.endFill();
		}
		
		private function getScrollAreaLength(): uint {
			var result: int = 0;
			if (_scrollType == TYPE_HORIZONTAL) {
				result = width - 
					((_topIcon) ? _topIcon.width : 0 ) - 
					((_bottomIcon) ? _bottomIcon.width : 0 ) -
					((_scrollImage) ? _scrollImage.width : 0 );
			}
			else {
				result = height - 
					((_topIcon) ? _topIcon.height : 0 ) - 
					((_bottomIcon) ? _bottomIcon.height : 0 ) -
					((_scrollImage) ? _scrollImage.height : 0 );
			}
			return result;
		}
		
		private function onTopIconMouseDown(event: MouseEvent): void {
			position -= 0.1;
		}
		
		private function onBottomIconMouseDown(event: MouseEvent): void {
			position += 0.1;
		}
		
		private function onScrollImageMouseDown(event: MouseEvent): void {
			_draggingScroll = true;
		}
		
		private function onScrollImageMouseMove(event: MouseEvent): void {
//			if (_draggingScroll) {
//				if (event.localY >= _topIcon.height && event.localY <= (height - _bottomIcon.height)) {
//					_scrollImage.y = event.localY;
//				}
//				 _position = (_scrollImage.y - _topIcon.height) / getScrollAreaHeight(); 
//				//TODO событие onScroll
//				
//			}
		}
		
		private function onScrollImageMouseUp(event: MouseEvent): void {
			_draggingScroll = false;
		}
		
		private function getStandartIcon(): Sprite {
			var s: Sprite = new Sprite();
			s.tabEnabled = true;
			s.graphics.beginFill(FOCUS_COLOR);
			if (_scrollType == TYPE_HORIZONTAL) {
				s.graphics.drawRect(0, 0, height, height);
			}
			else {
				s.graphics.drawRect(0, 0, width, width);
			}
			s.graphics.endFill();
			return s;
		}
		
		private function getStandartBackground(): Sprite {
			var s: Sprite = new Sprite();
			s.graphics.beginFill(GameObject.HOVER_COLOR, GameObject.HOVER_ALPHA);
			s.graphics.drawRect(0, 0, width, height);
			s.graphics.endFill();
			return s;
		}
		
//		private function getStandartScroll(): Sprite {
//			var s: Sprite = new Sprite();
//			s.tabEnabled = true;
//			s.graphics.beginFill(GameObject.FOCUS_COLOR, GameObject.FOCUS_ALPHA);
//			s.graphics.drawRect(0, 0, width, height / 5);
//			s.graphics.endFill();
//			return s;
//		}
	}
}
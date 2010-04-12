package com.flashmedia.gui
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameLayerEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class Form extends GameLayer
	{
		public static const SCROLL_STEP_VERTICAL: uint = 10;
		public static const SCROLL_STEP_HORIZONTAL: uint = 10;
		
		public static const PADDING_LEFT: uint = 5;
		public static const PADDING_TOP: uint = 5;
		public static const PADDING_RIGHT: uint = 5;
		public static const PADDING_BOTTOM: uint = 5;
		
		//TODO политика прокрутки
		private var _style: int;
		private var _verticalScrollBar: ScrollBar;
		private var _horizontalScrollBar: ScrollBar;
		private var _contentLayer: GameLayer;
		
		public function Form(value: GameScene, x: int, y: int, width: int, height: int)
		{
			super(value);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			fillBackground(BACKGROUNG_COLOR, 0.9);
			updateContentLayer();
		}
		
		public override function set width(value: Number): void {
			super.width = value;
			updateContentLayer();
		}
		
		public override function set height(value: Number): void {
			super.height = value;
			updateContentLayer();
		}
		
		public function get content(): GameLayer {
			return _contentLayer;
		}
		
		public function addComponent(child: DisplayObject): DisplayObject {
			if (child.x + child.width > _contentLayer.width) {
				_contentLayer.width = child.x + child.width;
			}
			if (child.y + child.height > _contentLayer.height) {
				_contentLayer.height = child.y + child.height;
			}
			updateContentLayer();
			return _contentLayer.addChild(child);
		}
		
//		public override function addChildAt(child: DisplayObject, index: int): DisplayObject {
//			return _contentLayer.addChildAt(child, index);
//		}
		
		private function updateContentLayer(): void {
			if (!_contentLayer) {
				_contentLayer = new GameLayer(scene);
				_contentLayer.addEventListener(GameLayerEvent.TYPE_SCROLL, onContentLayerScroll);
				_contentLayer.debug = true;
				_contentLayer.setSelect(true);
				_contentLayer.verticalScrollStep = SCROLL_STEP_VERTICAL;
				_contentLayer.horizontalScrollStep = SCROLL_STEP_HORIZONTAL;
				_contentLayer.scrollIndents(0, 0, 0, 0);
				_view.addDisplayObject(_contentLayer, 'contentLayer', VISUAL_DISPLAY_OBJECT_Z_ORDER);
			}
			_contentLayer.x = PADDING_LEFT;
			_contentLayer.y = PADDING_TOP;
			var scrollRectWidth: int = width - PADDING_LEFT - PADDING_RIGHT;
			var scrollRectHeight: int = height - PADDING_BOTTOM - PADDING_TOP;
			if (_contentLayer.height > scrollRectHeight) {
				//TODO задание полосы прокрутки, ее интерфейса
				if (!_verticalScrollBar) {
					_verticalScrollBar = new ScrollBar(scene, 0, 0, 15, 10);
					_verticalScrollBar.addEventListener(ScrollBarEvent.TYPE_SCROLL, onVerticalScrollBarScroll);
				}
				scrollRectWidth -= _verticalScrollBar.width;
				if (!_view.contains('verticalScroll')) {
					_view.addDisplayObject(_verticalScrollBar, 'verticalScroll', VISUAL_DISPLAY_OBJECT_Z_ORDER);
				}
				_verticalScrollBar.x = PADDING_LEFT + scrollRectWidth;
				_verticalScrollBar.y = PADDING_TOP;
				_verticalScrollBar.height = scrollRectHeight;
				if (_contentLayer.width > scrollRectWidth) {
					_verticalScrollBar.height -= 15;
				}
			}
			else {
				_view.removeDisplayObject('verticalScroll');
			}
			if (_contentLayer.width > scrollRectWidth) {
				//TODO задание полосы прокрутки, ее интерфейса
				if (!_horizontalScrollBar) {
					_horizontalScrollBar = new ScrollBar(scene, 0, 0, 15, 15, ScrollBar.TYPE_HORIZONTAL);
					_horizontalScrollBar.addEventListener(ScrollBarEvent.TYPE_SCROLL, onHorizontalScrollBarScroll);
				}
				scrollRectHeight -= _horizontalScrollBar.height;
				if (!_view.contains('horizontalScroll')) {
					_view.addDisplayObject(_horizontalScrollBar, 'horizontalScroll', VISUAL_DISPLAY_OBJECT_Z_ORDER);
				}
				_horizontalScrollBar.x = PADDING_LEFT;
				_horizontalScrollBar.y = PADDING_TOP + scrollRectHeight;
				_horizontalScrollBar.width = scrollRectWidth;
//				if (_contentLayer.height > scrollRectHeight) {
//					_horizontalScrollBar.width -= 15;
//				}
			}
			else {
				_view.removeDisplayObject('horizontalScroll');
			}
			_contentLayer.scrollRect = new Rectangle(0, 0, scrollRectWidth, scrollRectHeight);
			_contentLayer.verticalScrollPolicy = GameLayer.SCROLL_POLICY_AUTO;
			_contentLayer.horizontalScrollPolicy = GameLayer.SCROLL_POLICY_AUTO;
		}
		
		private function onContentLayerScroll(event: GameLayerEvent): void {
			if (_verticalScrollBar) {
				_verticalScrollBar.position = event.verticalPosition;
			}
			if (_horizontalScrollBar) {
				_horizontalScrollBar.position = event.horizontalPosition;
			}
		}
		
		private function onVerticalScrollBarScroll(event: ScrollBarEvent): void {
			_contentLayer.verticalPosition = event.position;
		}
		
		private function onHorizontalScrollBarScroll(event: ScrollBarEvent): void {
			_contentLayer.horizontalPosition = event.position;
		}
	}
}
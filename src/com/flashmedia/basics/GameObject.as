package com.flashmedia.basics
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/*
		TODO недостаточно настроек для задания фокуса. Нет смещения по x y, выравнивания, растяжения по ширине высоте и т.п.
		TODO разобраться как правильно рисовать прямоугольник (width - 1) или width
		TODO изменить все координаты и размеры на Number, так как идет потеря точности.
		Например в GridBox между выделением иногда появляются пробелы.
	*/
	/**
	 * Наследуемся от Sprite, чтобы получать пользовательские события (Мышь, Клавиатура ...)
	 * Автоматическое масштабирование, поворот
	 * Альфа, наложения, фильтры, маскирование
	 * Видимость-невидимость
	 */
	public class GameObject extends Sprite
	{
		public static const VISUAL_SELECT_MASK_Z_ORDER: int = 1200;
		public static const VISUAL_SELECT_Z_ORDER: int = 1100;
		public static const VISUAL_DEBUG_CONTAINER_Z_ORDER: int = 1000;
		public static const VISUAL_DISPLAY_OBJECT_Z_ORDER: int = 801;
		public static const VISUAL_TEXT_FIELD_Z_ORDER: int = 800;
		public static const VISUAL_BORDER_Z_ORDER: int = 700;
		public static const VISUAL_BITMAP_MASK_Z_ORDER: int = 500;
		public static const VISUAL_BITMAP_Z_ORDER: int = 400;
		public static const VISUAL_FOCUS_Z_ORDER: int = 300;
		public static const VISUAL_HOVER_Z_ORDER: int = 200;
		
		public static const NAME_SELECT_MASK: String = 'game_object_select_mask';
		public static const NAME_SELECT: String = 'game_object_select';
		public static const NAME_DEBUG_CONTAINER: String = 'game_object_debug_container';
		public static const NAME_TEXT_FIELD: String = 'game_object_text_field';
		public static const NAME_BORDER: String = 'game_object_border';
		public static const NAME_BITMAP_MASK: String = 'game_object_bitmap_mask';
		public static const NAME_BITMAP: String = 'game_object_bitmap';
		public static const NAME_FOCUS: String = 'game_object_focus';
		public static const NAME_HOVER: String = 'game_object_hover';
		
		//TODO remove
//		public static const HORIZONTAL_ALIGN_NONE: String = 'hor_align_none';
//		public static const HORIZONTAL_ALIGN_LEFT: String = 'hor_align_left';
//		public static const HORIZONTAL_ALIGN_CENTER: String = 'hor_align_center';
//		public static const HORIZONTAL_ALIGN_RIGHT: String = 'hor_align_right';
//		public static const VERTICAL_ALIGN_NONE: String = 'vert_align_none';
//		public static const VERTICAL_ALIGN_TOP: String = 'vert_align_top';
//		public static const VERTICAL_ALIGN_CENTER: String = 'vert_align_center';
//		public static const VERTICAL_ALIGN_BOTTOM: String = 'vert_align_bottom';
		
		public static const HOVER_INDENT: uint = 7;
		public static const HOVER_COLOR: uint = 0x57c8d5;
		public static const HOVER_ALPHA: Number = 0.2;
		public static const FOCUS_INDENT: uint = 7;
		public static const FOCUS_COLOR: uint = 0x57c8d5;
		public static const FOCUS_ALPHA: Number = 0.6;
		public static const BACKGROUNG_COLOR: uint = 0xfefefe;
		public static const SELECT_COLOR: uint = 0xffdd00;
		public static const BORDERS_COLOR: uint = 0x0000ff;
		public static const MAX_Z_ORDER: int = 9999;
		
		public static const SIZE_MODE_BORDER: String = 'size_mode_border';
		public static const SIZE_MODE_SELECT: String = 'size_mode_select';
		
//		protected var _speedX: int;
//		protected var _speedY: int;
//		protected var _stationary: Boolean; //
//		protected var _interactive: Boolean; //
//		protected var _mass: uint;
//		protected var _elasticity: uint = 1; // упругость [0..1]
//		private var states: Array; // визуальные состояния

		public static const MIN_WIDTH: Number = 1;
		public static const MIN_HEIGHT: Number = 1;

		protected var _width: Number;
		protected var _height: Number;
		// ширина и высота определяются автоматически по графическомуу содержимому
		protected var _autoSize: Boolean;
		protected var _zOrder: int;
		protected var _type: String; // произвольный пользовательский тип
		// отладка
		protected var _debug: Boolean;
		protected var _debugText: TextField;
		protected var _debugContainer: Sprite;
		
		protected var _scene: GameScene;
		// графическое содержимое
		protected var _bitmap: Bitmap;
		//потом сделать более сложное выделение - произвольную область, а по умолчанию по границам.
		
		// текстовое содержимое
		protected var _textField: TextField;
		// область выделения
		protected var _select: Sprite;
		// объект маска для выделения. Позволяет задать выделению форму, отличную от прямоугольника.
		protected var _selectMask: Sprite;
		// границы объ_selectекта - отдельный объект, так как при изменении границ нужно удалить, пересоздать и заново добавлять его
		protected var _border: Sprite;
		// объект маска для маскирования (отсечения)
		protected var _bitmapMask: Sprite;
		// слой, на котором располагается игровой объект
		protected var _gameLayer: GameLayer;
		// настройка свойств селекта
		protected var _selectable: Boolean;
		protected var _selectAutosize: Boolean;
		protected var _selectRect: Rectangle;
		// настройка свойств фокуса
		protected var _focusEnabled: Boolean;
		protected var _viewFocus: Boolean;
		protected var _isDefaultFocus: Boolean;
		protected var _focus: DisplayObject;
		protected var _focusSizeMode: String;
		protected var _focusLayout: int;
		// настройка свойств рамки при наведении
		protected var _hoverEnabled: Boolean;
		protected var _viewHover: Boolean;
		protected var _isDefaultHover: Boolean;
		protected var _hover: DisplayObject;
		protected var _hoverSizeMode: String;
		protected var _hoverLayout: int;
		// цвет фона
		protected var _fillBackground: Boolean;
		protected var _backgroundColor: uint;
		protected var _backgroundAlpha: Number;
		// слои игрового обекта
		protected var _view: View;
		
		
		public function GameObject(value: GameScene)
		{
			super();
			_scene = value;
			_view = new View(this);
			_debug = false;
			_autoSize = true;
			setSelect(false, true);
			setFocus(false, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, SIZE_MODE_BORDER);
			setHover(false, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, SIZE_MODE_BORDER);
			_type = 'GameObject';
			_backgroundColor = BACKGROUNG_COLOR;
			_backgroundAlpha = 1.0;
			_fillBackground = false;
			_zOrder = 1;
			// границы объекта
			_width = MIN_WIDTH;
			_height = MIN_HEIGHT;
			width = 100;
			height = 100;
		}
		
		public function destroy(): void {
			if (_focus) {
				_view.removeDisplayObject(NAME_FOCUS);
				_focus = null;
			}
			if (_hover) {
				_view.removeDisplayObject(NAME_HOVER);
				_hover = null;
			}
			if (_border) {
				_view.removeDisplayObject(NAME_BORDER);
				_border = null;
			}
			if (_bitmap) {
				_view.removeDisplayObject(NAME_BITMAP);
				_bitmap = null;
			}
			if (_bitmapMask) {
				_view.removeDisplayObject(NAME_BITMAP_MASK);
				_bitmapMask = null;
			}
			if (_textField) {
				_view.removeDisplayObject(NAME_TEXT_FIELD);
				_textField = null;
			}
			if (_select) {
				_select.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardListener);
				_select.removeEventListener(MouseEvent.CLICK, mouseClickListener);
				_select.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
				_select.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
				_select.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
				_view.removeDisplayObject(NAME_SELECT);
				_select = null;
			}
			if (_selectMask) {
				_view.removeDisplayObject(NAME_SELECT_MASK);
				_selectMask = null;
			}
			if (_debugContainer) {
				_view.removeDisplayObject(NAME_DEBUG_CONTAINER);
				_debugContainer = null;
			}
			_gameLayer = null;
		}
		
		public function get view(): View {
			return _view;
		}
		
		public function set debug(value: Boolean): void {
			_debug = value;
			drawDebugInfo();
//			sortSprites();
		}
		
		public function get debug(): Boolean {
			return _debug;
		}
		
		public override function get width(): Number {
			return _width;
		}
		
		public override function set width(value: Number): void {
			if (value < MIN_WIDTH) {
				value = MIN_WIDTH;
			}
			if (_width != value) {
				_width = value;
				updateBorder();
				if (_selectAutosize) {
					_selectRect = new Rectangle(0, 0, _width, _height);
		    		updateSelection();
		  		}
		  		updateFocus();
		  		updateHover();
	//	  		updateTextFieldAlign();
		    	drawDebugInfo();
	//	    	sortSprites();
				_view.layoutVisuals();
				var event: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_SIZE_CHANGED);
				event.gameObject = this;
				dispatchEvent(event);
			}
		}
		
		public override function get height(): Number {
			return _height;
		}
		
		public override function set height(value: Number): void {
			if (value < MIN_HEIGHT) {
				value = MIN_HEIGHT;
			}
	    	if (_height != value) {
	    		_height = value;
		    	updateBorder();
		    	if (_selectAutosize) {
		    		_selectRect = new Rectangle(0, 0, _width, _height);
		    		updateSelection();
		  		}
		  		updateFocus();
		  		updateHover();
	//	  		updateTextFieldAlign();
		    	drawDebugInfo();
	//	    	sortSprites();
				_view.layoutVisuals();
				var event: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_SIZE_CHANGED);
				event.gameObject = this;
				dispatchEvent(event);
	    	}
		}
		
		public function get zOrder(): int {
			return _zOrder;
		}
		
		/**
		 * Свойство zOrder имеет смысл, если объект находится на слое GameLayer 
		 */
		public function set zOrder(value: int): void {
			if (value > MAX_Z_ORDER) {
				value = MAX_Z_ORDER;
			}
			internalZOrder = value;
		}
		
		public function get type(): String {
			return _type;
		}
		
		public function set type(value: String): void {
			_type = value;
			drawDebugInfo();
		}
		
		public function fillBackground(valueColor: uint, valueAlpha: Number): void {
			_fillBackground = true;
			_backgroundColor = valueColor;
			_backgroundAlpha = valueAlpha;
			updateBorder();
//			sortSprites();
		}
		
		public function clearBackground(): void {
			_fillBackground = false;
			updateBorder();
//			sortSprites();
		}
		
		public function set bitmapMask(value: Sprite): void {
			if (_bitmapMask) {
//				removeChild(_bitmapMask);
				_view.removeDisplayObject(NAME_BITMAP_MASK);
			}
			_bitmapMask = value;
			_view.addDisplayObject(_bitmapMask, NAME_BITMAP_MASK, VISUAL_BITMAP_MASK_Z_ORDER);
//			addChild(_bitmapMask);
			if (_bitmap) {
				_bitmap.mask = _bitmapMask;
			}
//			sortSprites();
		}
		
		public function set bitmap(value: Bitmap): void {
			if (_bitmap) {
//				removeChild(_bitmap);
				_view.removeDisplayObject(NAME_BITMAP);
			}
			_bitmap = value;
			_view.addDisplayObject(_bitmap, NAME_BITMAP, VISUAL_BITMAP_Z_ORDER);
//			addChild(_bitmap);
			if (_bitmapMask) {
				_bitmap.mask = _bitmapMask;
			}
			if (_autoSize) {
				width = _bitmap.width;
				height = _bitmap.height;
			}
			drawDebugInfo();
//			sortSprites();
		}
		
		public function setTextField(value: TextField, layoutMode: int = 0): void {
			if (_textField) {
				_view.removeDisplayObject(NAME_TEXT_FIELD);
			}
			if (value) {
				_textField = value;
				_view.addDisplayObject(_textField, NAME_TEXT_FIELD, VISUAL_TEXT_FIELD_Z_ORDER, layoutMode);
			}
		}
		public function get bitmap(): Bitmap {
			if (_bitmap) {
				return _bitmap;
			}
			return null
		}
		
//		public function set textField(value: TextField): void {
//			if (_textField) {
////				removeChild(_textField);
//				_view.removeDisplayObject(NAME_TEXT_FIELD);
//			}
//			if (value) {
//				_textField = value;
////				updateTextFieldAlign();
////				addChild(_textField);
//				_view.addDisplayObject(_textField, NAME_TEXT_FIELD, VISUAL_TEXT_FIELD_Z_ORDER, layoutMode);
////				sortSprites();
//			}
//		}
		
		public function get textField(): TextField {
			return _textField;
		}
		
//		public function set textHorizontalAlign(value: String): void {
//			_textHorizontalAlign = value;
//			updateTextFieldAlign();
//		}
//		
//		public function set textVerticalAlign(value: String): void {
//			_textVerticalAlign = value;
//			updateTextFieldAlign();
//		}
		
		public function set autoSize(value: Boolean): void {
			_autoSize = value;
		}
		
		public function get autoSize(): Boolean {
			return _autoSize;
		}
		
		public function setSelect(selectable: Boolean, autoSize: Boolean = true, selectMask: Sprite = null, selectRect: Rectangle = null): void {
			_selectable = selectable;
			if (_selectable) {
				_selectAutosize = autoSize;
				_selectRect = selectRect;
				if (_selectAutosize || !_selectRect) {
					_selectRect = new Rectangle(0, 0, _width, _height);
				}
				if (_selectMask) {
					_view.removeDisplayObject(NAME_SELECT_MASK);
				}
				_selectMask = selectMask;
				if (_selectMask) {
					_view.addDisplayObject(_selectMask, NAME_SELECT_MASK, VISUAL_SELECT_MASK_Z_ORDER);
				}
				if (_selectRect && _selectMask) {
					_selectMask.x = _selectRect.x;
					_selectMask.y = _selectRect.y;
				}
			}
			updateSelection();
			updateFocus();
	  		updateHover();
			drawDebugInfo();
//			sortSprites();
		}
		
//		public function set selectable(value: Boolean): void {
//			_selectable = value;
//			updateSelection();
//			updateFocus();
//	  		updateHover();
//			drawDebugInfo();
//			sortSprites();
//		}
		
		public function get selectable(): Boolean {
			return _selectable;
		}
		
		/**
		 * Если сбросить свойство selectAutosize, выделение не будет следить за изменением габаритов объекта
		 */
//		public function set selectAutosize(value: Boolean): void {
//			_selectAutosize = value;
//			if (_selectAutosize) {
//				_selectRect = new Rectangle(0, 0, _width, _height);
//				updateSelection();
//				updateFocus();
//	  			updateHover();
//				drawDebugInfo();
//			}
//			sortSprites();
//		}
//		
//		public function set selectRect(value: Rectangle): void {
//			_selectAutosize = false;
//			_selectRect = value;
//			if (_selectMask) {
//				_selectMask.x = _selectRect.x;
//				_selectMask.y = _selectRect.y;
//			}
//			updateSelection();
//			updateFocus();
//	  		updateHover();
//			drawDebugInfo();
//			sortSprites();
//		}
//		
//		public function set selectMask(value: Sprite): void {
//			if (_selectMask) {
////				removeChild(_selectMask);
//				removeDisplayObject(NAME_SELECT_MASK);
//			}
//			_selectMask = value;
//			_selectMask.name = NAME_SELECT_MASK;
//			if (_selectRect) {
//				_selectMask.x = _selectRect.x;
//				_selectMask.y = _selectRect.y;
//			}
////			addChild(_selectMask);
//			if (_select) {
//				_select.mask = _selectMask;
//				addDisplayObject(_selectMask, VISUAL_SELECT_MASK_Z_ORDER);
//			}
////			sortSprites();
//		}
		
		public function setFocus(enabled: Boolean, viewFocus: Boolean = true, focusDisplayObject: DisplayObject = null, layout: int = 0, sizeMode: String = SIZE_MODE_BORDER): void {
			_focusEnabled = enabled;
			_viewFocus = viewFocus;
			_isDefaultFocus = !focusDisplayObject;
			_focus = focusDisplayObject;
			_focusLayout = layout;
			_focusSizeMode = sizeMode;
			updateFocus();
		}
		
//		public function set canFocus(value: Boolean): void {
//			_focusEnabled = value;
//			updateFocus();
//			sortSprites();
//		}
		
		public function get canFocus(): Boolean {
			return _focusEnabled;
		}
		
//		public function set focusSprite(value: Sprite): void {
//			_focus = value;
//			//_view.addDisplayObject(_focus, NAME_FOCUS, VISUAL_FOCUS_Z_ORDER);
//			updateFocus();
//			//sortSprites();
//		}
		
		public function set focus(value: Boolean): void {
			if (_focusEnabled) {
				if (_viewFocus) {
					_focus.visible = value;
				}
				var eventType: String = GameObjectEvent.TYPE_LOST_FOCUS;
				if (value) {
					eventType = GameObjectEvent.TYPE_SET_FOCUS;
				}
				var goEvent: GameObjectEvent = new GameObjectEvent(eventType);
				goEvent.gameObject = this;
				dispatchEvent(goEvent);
			}
		}
		
//		public function set focusSizeMode(value: String): void {
//			_focusSizeMode = value;
//			updateFocus();
//			//sortSprites();
//		}
		
		public function setHover(enabled: Boolean, viewHover: Boolean = true, hoverDisplayObject: DisplayObject = null, layout: int = 0, sizeMode: String = SIZE_MODE_BORDER): void {
			_hoverEnabled = enabled;
			_viewHover = viewHover;
			_isDefaultHover = !hoverDisplayObject;
			_hover = hoverDisplayObject;
			_hoverLayout = layout;
			_hoverSizeMode = sizeMode;
			updateHover();
		}
		
//		public function set canHover(value: Boolean): void {
//			_hoverEnabled = value;
//			updateHover();
////			sortSprites();
//		}
		
//		public function set hoverSprite(value: Sprite): void {
//			_hover = value;
//			updateHover();
//			sortSprites();
//		}
		
		public function get canHover(): Boolean {
			return _hoverEnabled;
		}
		
		public function set hover(value: Boolean): void {
			if (_hoverEnabled && _viewHover) {
				_hover.visible = value;
			}
		}
		
//		public function set hoverSizeMode(value: String): void {
//			_hoverSizeMode = value;
//			updateHover();
//			sortSprites();
//		}
		
		public function get gameLayer(): GameLayer {
			return _gameLayer;
		}
		
		public function get scene(): GameScene {
			return _scene;
		}
		
		internal function setGameLayer(value: GameLayer): void {
			_gameLayer = value;
		}
		
		internal function set internalZOrder(value: int): void {
			_zOrder = value;
			if (_gameLayer) {
				_gameLayer.sortChildsByZ();
			}
		}
		
		protected function drawDebugInfo(): void {
			if (_debug) {
				if (!_debugContainer) {
					_debugContainer = new Sprite();
//					addChild(_debugContainer);
					_view.addDisplayObject(_debugContainer, NAME_DEBUG_CONTAINER);
				}
				_debugContainer.graphics.clear();
				if (!_debugText) {
					_debugText = new TextField();
					_debugText.selectable = false;
					_debugText.autoSize = TextFieldAutoSize.CENTER;
					_debugText.setTextFormat(new TextFormat('Arial', 8));
					_debugText.textColor = BORDERS_COLOR;
				}
				_debugText.text = '[';
				_debugText.appendText((_type is String) ? 'type:' +_type : '');
				_debugText.appendText((name is String) ? ' name:' + name : '');
				_debugText.appendText(']');
				_debugText.x = (_width - _debugText.textWidth) / 2;
				_debugText.y = (_height - _debugText.textHeight) / 2;
				if (!_debugContainer.contains(_debugText)) {
					_debugContainer.addChild(_debugText);
				}
				// main sprite
//				_debugContainer.graphics.lineStyle(1, 0x0000ff);
//				_debugContainer.graphics.drawRect(0, 0, width, height);
				// border sprite
				_debugContainer.graphics.lineStyle(1, BORDERS_COLOR);
				_debugContainer.graphics.drawRect(0, 0, _width - 1, _height - 1);
				// selection
				if (_select) {
					_select.alpha = 0.5;
				}
			}
			else {
				if (_debugContainer) {
					_debugContainer.graphics.clear();
					_debugContainer.removeChild(_debugText);
				}
				if (_select) {
					_select.alpha = 0.0;
				}
			}
		}
		
		private function updateBorder(): void {
			if (!_border) {
	    		_border = new Sprite();
	    		_view.addDisplayObject(_border, NAME_BORDER, VISUAL_BORDER_Z_ORDER, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, null, true);
	  		}
	  		_border.graphics.clear();
			_border.graphics.lineStyle(1, BORDERS_COLOR, 0.0);
			_border.graphics.drawRect(0, 0, _width, _height);
			if (_fillBackground) {
				_border.graphics.beginFill(_backgroundColor, _backgroundAlpha);
				_border.graphics.drawRect(0, 0, _width, _height);
				_border.graphics.endFill();	
			}
//			if (!contains(_border)) {
//				addChild(_border);
//			}
		}
		
		private function updateSelection(): void {
			if (_selectable) {
				if (!_select) {
					_select = new Sprite();
					_select.addEventListener(KeyboardEvent.KEY_DOWN, keyboardListener);
					_select.addEventListener(MouseEvent.CLICK, mouseClickListener);
					_select.addEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
					_select.addEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
					_select.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
					_view.addDisplayObject(_select, NAME_SELECT, VISUAL_SELECT_Z_ORDER);
				}
				_select.tabEnabled = true;
				_select.graphics.clear();
				_select.graphics.beginFill(SELECT_COLOR);
				_select.graphics.drawRect(_selectRect.x, _selectRect.y, _selectRect.width, _selectRect.height);
				_select.graphics.endFill();
				_select.alpha = 0.0;
				if (_selectMask) {
					_select.mask = _selectMask;
				}
				else {
					_select.mask = null
				}
//				if (!contains(_select)) {
//					addChild(_select);
//				}
			}
			else {
				if (_select) {
					_select.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardListener);
					_select.removeEventListener(MouseEvent.CLICK, mouseClickListener);
					_select.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
					_select.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
					_select.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
					//removeChild(_select);
					_view.removeDisplayObject(NAME_SELECT);
					_select = null;
				}
			}
		}
		
		private function updateFocus(): void {
			if (_focusEnabled) {
				if (_isDefaultFocus) {
					if (!_focus) {
						var s: Sprite = new Sprite();
						s.visible = false;
						_focus = s;
					}
					(_focus as Sprite).graphics.clear();
					(_focus as Sprite).graphics.lineStyle(1, FOCUS_COLOR);
					(_focus as Sprite).graphics.beginFill(FOCUS_COLOR, FOCUS_ALPHA);
					switch (_focusSizeMode) {
						case SIZE_MODE_SELECT:
							if (_select) {
								(_focus as Sprite).graphics.drawRect(_selectRect.x, _selectRect.y, _selectRect.width - 1, _selectRect.height - 1);
								break;
							}
						default:
							(_focus as Sprite).graphics.drawRect(-FOCUS_INDENT, - FOCUS_INDENT, _width + 2 * FOCUS_INDENT - 1, _height + 2 * FOCUS_INDENT - 1);						
					}
					(_focus as Sprite).graphics.endFill();
				}
				_focus.visible = false;
				_view.removeDisplayObject(NAME_FOCUS);
//				if (!_view.contains(NAME_FOCUS)) {
					_view.addDisplayObject(_focus, NAME_FOCUS, VISUAL_FOCUS_Z_ORDER, _focusLayout);
//				}
//				if (!contains(_focus)) {
//					addChild(_focus);
//				}
			}
			else {
				if (_focus) {
//					removeChild(_focus);
					_view.removeDisplayObject(NAME_FOCUS);
					_focus = null;
				}
			}
		}
		
		private function updateHover(): void {
			if (_hoverEnabled) {
				if (_isDefaultHover) {
					if (!_hover) {
						var s: Sprite = new Sprite();
						s.visible = false;
						_hover = s;
					}
					(_hover as Sprite).visible = false;
					(_hover as Sprite).graphics.clear();
					(_hover as Sprite).graphics.lineStyle(1, HOVER_COLOR);
					(_hover as Sprite).graphics.beginFill(HOVER_COLOR, HOVER_ALPHA);
					switch (_hoverSizeMode) {
						case SIZE_MODE_SELECT:
							if (_select) {
								(_hover as Sprite).graphics.drawRect(_selectRect.x, _selectRect.y, _selectRect.width - 1, _selectRect.height - 1);
								break;
							}
						default:
							(_hover as Sprite).graphics.drawRect(-HOVER_INDENT, - HOVER_INDENT, _width + 2 * HOVER_INDENT - 1, _height + 2 * HOVER_INDENT - 1);						
					}
					(_hover as Sprite).graphics.endFill();
//					if (!contains(_hover)) {
//						addChild(_hover);
//					}
				}
				_hover.visible = false;
				_view.removeDisplayObject(NAME_HOVER);
				//if (!_view.contains(NAME_HOVER)) {
					_view.addDisplayObject(_hover, NAME_HOVER, VISUAL_HOVER_Z_ORDER, _hoverLayout);
				//}
			}
			else {
				if (_hover) {
					_view.removeDisplayObject(NAME_HOVER);
//					removeChild(_hover);
					_hover = null;
				}
			}
		}
		
//		private function updateTextFieldAlign(): void {
//			if (_textField) {
//				switch (_textHorizontalAlign) {
//					case HORIZONTAL_ALIGN_LEFT:
//						_textField.x = 0;
//					break;
//					case HORIZONTAL_ALIGN_RIGHT:
//						_textField.x = width - _textField.width;
//					break;
//					case HORIZONTAL_ALIGN_CENTER:
//					default:
//						_textField.x = (width - _textField.width) / 2;
//				}
//				switch (_textVerticalAlign) {
//					case VERTICAL_ALIGN_TOP:
//						_textField.y = 0;
//					break;
//					case VERTICAL_ALIGN_BOTTOM:
//						_textField.y = height - _textField.height;
//					break;
//					case VERTICAL_ALIGN_CENTER:
//					default:
//						_textField.y = (height - _textField.height) / 2;
//				}
//			}
//		}
//		private function updateTextFieldAlign(): void {
//			if (_textField) {
//				switch (_textHorizontalAlign) {
//					case HORIZONTAL_ALIGN_LEFT:
//						_textField.x = 0;
//					break;
//					case HORIZONTAL_ALIGN_RIGHT:
//						_textField.x = width - _textField.width;
//					break;
//					case HORIZONTAL_ALIGN_CENTER:
////					default:
//						_textField.x = (width - _textField.width) / 2;
//				}
//				switch (_textVerticalAlign) {
//					case VERTICAL_ALIGN_TOP:
//						_textField.y = 0;
//					break;
//					case VERTICAL_ALIGN_BOTTOM:
//						_textField.y = height - _textField.height;
//					break;
//					case VERTICAL_ALIGN_CENTER:
////					default:
//						_textField.y = (height - _textField.height) / 2;
//				}
//			}
//		}
		
		/**
		 * Сортировка составляющих игрового объекта. Каждый спрайт должен находиться на своем месте.
		 * Например выделение с его маской выше всех, чтобы обрабатывать действия пользователя.
		 * bitmap - bitmapMask - border - debugContainer - select - selectMask
		 */
//		private function sortSprites(): void {
			//_view.sortVisuals();
			//front
//			if (_selectMask) {
//				setChildIndex(_selectMask, 0);
//			}
//			if (_select) {
//				setChildIndex(_select, 0);
//			}
//			if (_debugContainer) {
//				setChildIndex(_debugContainer, 0);
//			}
//			if (_textField) {
//				setChildIndex(_textField, 0);
//			}
//			if (_border) {
//				setChildIndex(_border, 0);
//			}
//			if (_bitmapMask) {
//				setChildIndex(_bitmapMask, 0);
//			}
//			if (_bitmap) {
//				setChildIndex(_bitmap, 0);
//			}
//			if (_focus) {
//				setChildIndex(_focus, 0);
//			}
//			if (_hover) {
//				setChildIndex(_hover, 0);
//			}
			//back
//		}
		
		protected function keyboardListener(event: KeyboardEvent): void {
			var goEvent: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_KEY_DOWN);
			goEvent.gameObject = this;
			goEvent.keyCode = event.keyCode;
			dispatchEvent(goEvent);
		}
		
		protected function mouseClickListener(event: MouseEvent): void {
			if (_selectable && _focusEnabled) {
				_scene.selectedGameObject = this;
				event.stopPropagation(); // отменяет дальнейшую обработку события - сцена не снимет выделение
			}
			var goEvent: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_MOUSE_CLICK);
			goEvent.gameObject = this;
			dispatchEvent(goEvent);
		}
		
		protected function mouseOverListener(event: MouseEvent): void {
			if (_selectable && _hoverEnabled) {
				if (_viewHover) {
					_hover.visible = true;
				}
				var goEvent: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_SET_HOVER);
				goEvent.gameObject = this;
				dispatchEvent(goEvent);
			}
		}
		
		protected function mouseOutListener(event: MouseEvent): void {
			if (_selectable && _hoverEnabled) {
				if (_viewHover) {
					_hover.visible = false;
				}
				var goEvent: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_LOST_HOVER);
				goEvent.gameObject = this;
				dispatchEvent(goEvent);
			}
		}
		
		protected function mouseMoveListener(event: MouseEvent): void {
			var goEvent: GameObjectEvent = new GameObjectEvent(GameObjectEvent.TYPE_MOUSE_MOVE);
			goEvent.gameObject = this;
			goEvent.mouseX = event.localX;
			goEvent.mouseY = event.localY;
			dispatchEvent(goEvent);
		}
	}
}
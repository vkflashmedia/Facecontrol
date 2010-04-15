package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;

	//TODO удаление компонентов с GridBox
	//TODO при установке итема более тонкая настройка его фокуса, выделения и т.д
	public class GridBox extends Form
	{
		/**
		 * Высота ряда вычисляется на основании элемента с наибольшей высотой.
		 * Высота различных рядов может быть разной.
		 */
		public static const ROW_HEIGHT_POLICY_BY_MAX_CELL: String = 'row_height_policy_by_max_size';
		/**
		 * Высота всех рядов одинакова. Элемент с наибольшей высотой в GridBox будет определять высоту всех рядов.
		 */
		public static const ROW_HEIGHT_POLICY_ALL_SAME: String = 'row_height_policy_all_same';
		/**
		 * Ширина столбца вычисляется на основании элемента с наибольшей шириной.
		 * Ширина различных столбцов может быть разной.
		 */
		public static const COLUMN_WIDTH_POLICY_BY_MAX_CELL: String = 'column_width_policy_by_max_size';
		/**
		 * Ширина всех столбцов одинакова. Элемент с наибольшей шириной в GridBox будет определять ширину всех рядов.
		 */
		public static const COLUMN_WIDTH_POLICY_ALL_SAME: String = 'column_width_policy_all_same';
		/**
		 * Ширина имеет абсолютное значение, заданное пользователем. Не зависит от содержимого.
		 * Если содержимое выходит за пределы, то возможна прокрутка.
		 */
		public static const WIDTH_POLICY_ABSOLUTE: String = 'width_policy_absolute';
		/**
		 * Ширина выставляется автоматически на основе содержимого.
		 */
		public static const WIDTH_POLICY_AUTO_SIZE: String = 'width_policy_auto_size';
		/**
		 * Ширина имеет абсолютное значение. Ячейки "пытаются" растянуться так, чтобы заполнить заданную ширину.
		 * Или "сжаться" так, чтобы уместиться в заданную пользователем ширину.
		 */
		public static const WIDTH_POLICY_STRETCH_BY_WIDTH: String = 'width_policy_stretch_by_width';
		/**
		 * Высота имеет абсолютное значение, заданное пользователем. Не зависит от содержимого.
		 * Если содержимое выходит за пределы, то возможна прокрутка.
		 */
		public static const HEIGHT_POLICY_ABSOLUTE: String = 'height_policy_absolute';
		/**
		 * Высота выставляется автоматически на основе содержимого.
		 */
		public static const HEIGHT_POLICY_AUTO_SIZE: String = 'height_policy_auto_size';
		/**
		 * Высота имеет абсолютное значение. Ячейки "пытаются" растянуться так, чтобы заполнить заданную высоту.
		 * Или "сжаться" так, чтобы уместиться в заданную пользователем высоту.
		 */
		public static const HEIGHT_POLICY_STRETCH_BY_HEIGHT: String = 'height_policy_stretch_by_height';
		
		private static const PADDING_ITEM: uint = 5;
		private static const INDENT_BETWEEN_ITEMS: uint = 5;
		
		private static const COLUMNS_DEF_COUNT: uint = 8;
		private static const ROWS_DEF_COUNT: uint = undefined;
		
		private var _maxColumnsCount: uint;
		private var _maxRowsCount: uint;
		private var _selectedItem: *;
		private var _selectedColumnIndex: uint;
		private var _selectedRowIndex: uint;
		
		private var _maxItemWidth: uint;
		private var _maxItemHeight: uint;
		private var _paddingItem: uint;
		private var _indentBetweenCols: uint;
		private var _indentBetweenRows: uint;
		private var _horizontalItemsAlign: int;
		private var _verticalItemsAlign: int;
		private var _rowHeightPolicy: String;
		private var _columnWidthPolicy: String;
		private var _widthPolicy: String;
		private var _heightPolicy: String;
		
		private var _items: Array;
		private var _gameObjects: Array;
//		private var _originGameObjectWidth: Array;
//		private var _originGameObjectHeight: Array;
		private var _columnsWidth: Array;
		private var _rowsHeight: Array;
		private var _textFormat: TextFormat;
		private var _embed:Boolean = false;
		private var _antiAliasType:String = AntiAliasType.NORMAL;
		
		public function GridBox(value:GameScene, maxColumnsCount: uint = COLUMNS_DEF_COUNT, maxRowsCount: uint = ROWS_DEF_COUNT)
		{
			super(value, 0, 0, 100, 100);
			_paddingLeft = 0;
			_paddingTop = 0;
			_paddingBottom = 0;
			_paddingRight = 0
			_items = new Array();
			_gameObjects = new Array();
//			_originGameObjectWidth = new Array();
//			_originGameObjectHeight = new Array();
			_columnsWidth = new Array();
			_rowsHeight = new Array();
			_selectedColumnIndex = undefined;
			_selectedRowIndex = undefined;
			_maxColumnsCount = maxColumnsCount;
			_maxRowsCount = maxRowsCount;
			_maxItemWidth = undefined;
			_maxItemHeight = undefined;
			_paddingItem = PADDING_ITEM;
			_indentBetweenCols = INDENT_BETWEEN_ITEMS;
			_indentBetweenRows = INDENT_BETWEEN_ITEMS;
			_horizontalItemsAlign = View.ALIGN_HOR_CENTER;
			_verticalItemsAlign = View.ALIGN_VER_CENTER;
			_rowHeightPolicy = ROW_HEIGHT_POLICY_BY_MAX_CELL;
			_columnWidthPolicy = COLUMN_WIDTH_POLICY_BY_MAX_CELL;
			_widthPolicy = WIDTH_POLICY_AUTO_SIZE;
			_heightPolicy = HEIGHT_POLICY_AUTO_SIZE;
		}
		
		public function addItem(value: *): void {
			//TODO сделать произвольный тип
			_items.push(value);
			if (value is String) {
				var label: Label = new Label(scene, value);
				
				if (_textFormat) {
					label.setTextFormat(_textFormat, _embed, _antiAliasType);
				}
				label.setSelect(true);
				label.setHover(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				label.setFocus(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				label.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, itemMouseClickListener);
				_gameObjects.push(label);
//				_originGameObjectWidth.push(label.width);
//				_originGameObjectHeight.push(label.height);
			}
			else if (value is Bitmap) {
				var go: GameObject = new GameObject(scene);
				go.bitmap = value;
				go.width = value.width;
				go.height = value.height;
				go.setSelect(true);
				go.setHover(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				go.setFocus(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, itemMouseClickListener);
				_gameObjects.push(go);
//				_originGameObjectWidth.push(go.width);
//				_originGameObjectHeight.push(go.height);
			}
			else if (value is GameObject) {
				value.setSelect(true);
//				value.setFocus(true, true, null, GameObject.SIZE_MODE_SELECT);
//				value.setHover(true, true, null, GameObject.SIZE_MODE_SELECT);
				value.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, itemMouseClickListener);
				_gameObjects.push(value);
				//TODO теперь можно отказаться от  _originGameObjectWidth
//				_originGameObjectWidth.push(value.width);
//				_originGameObjectHeight.push(value.height);
			}
			else {
				throw ArgumentError('Illegal argument type');
			}
			updateLayout(true, true);
		}
		
		public function removeAllItems(): void {
			_items = new Array();
			for each (var go: GameObject in _gameObjects) {
				removeComponent(go);
			}
			_gameObjects = new Array();
			updateLayout(true, true);
		}
		
		/**
		 * Список gameObjects - список визуальных объектов, содержимого GridBox 
		 */
		public function get gameObjects(): Array {
			return _gameObjects;
		}
		
		/**
		 * Выделенный объект GameObject.
		 */
		public function get selectedGameObject(): GameObject {
			var index: int = _items.indexOf(_selectedItem);
			if (index != -1) {
				return _gameObjects[index];
			}
			return null;
		}
		
		/**
		 * Список значений, установленных в GridBox.
		 * Не одно и тоже с gameObjects.
		 */
		public function get items(): Array {
			return _items;
		}
		
		/**
		 * Тукущее значение GridBox.
		 */
		public function get selectedItem(): * {
			return _selectedItem;
		}
		
		public function set selectedItem(value:*): void {
			var index: uint = _items.indexOf(value);
			if (index != -1) {
				selectItem(_gameObjects[index]);
			}
		}
		
//		public function setItemFocus(value: DisplayObject, layout: int = 0): void {
//			for each (var go: GameObject in _gameObjects) {
//				go.setFocus(true, true, value, layout);
//			}
//		}
		
		public function get selectedColumnIndex(): uint {
			return _selectedColumnIndex;
		}
		
		public function get selectedRowIndex(): uint {
			return _selectedRowIndex;
		}
		
		public function get columnsCount(): uint {
			if (!_columnsWidth) {
				return undefined;
			}
			return _columnsWidth.length;
		}
		
		public function get rowsCount(): uint {
			if (!_rowsHeight) {
				return undefined;
			}
			return _rowsHeight.length;
		}
		
		public function getColumnWidth(value: uint): uint {
			if (!_columnsWidth[value]) {
				return undefined;
			}
			return _columnsWidth[value] + 2 * _paddingItem;
		}
		
		public function getRowHeight(value: uint): uint {
			if (!_rowsHeight[value]) {
				return undefined;
			}
			return _rowsHeight[value] + 2 * _paddingItem;
		}
		
		public function set padding(value: uint): void {
			_paddingItem = value;
			updateLayout(true, true);
		}
		
		public function set indentBetweenCols(value: uint): void {
			_indentBetweenCols = value;
			updateLayout(true, true);
		}
		
		public function set indentBetweenRows(value: uint): void {
			_indentBetweenRows = value;
			updateLayout(true, true);
		}
		
		public function set horizontalItemsAlign(value: int): void {
			_horizontalItemsAlign = value;
			updateLayout(true, true);
		}
		
		public function set verticalItemsAlign(value: int): void {
			_verticalItemsAlign = value;
			updateLayout(true, true);
		}
		
		public function set columnWidthPolicy(value: String): void {
			_columnWidthPolicy = value;
			updateLayout(true, true);
		}
		
		public function set rowHeightPolicy(value: String): void {
			_rowHeightPolicy = value;
			updateLayout(true, true);
		}
		
		public function set widthPolicy(value: String): void {
			_widthPolicy = value;
			updateLayout(true, false);
		}
		
		public function set heightPolicy(value: String): void {
			_heightPolicy = value;
			updateLayout(false, true);
		}
		
//		public function set textFormat(value: TextFormat): void {
//			if (value) {
//				_textFormat = value;
//				if (_textField) {
//					_textField.setTextFormat(_textFormat);
//				}
//				for each (var go: GameObject in _gameObjects) {
//					if (go is Label) {
//						(go as Label).textFormat = _textFormat;
//					}
//				}
//				updateLayout(true, true);
//			}
//		}

		public function setTextFormat(value: TextFormat, embed:Boolean = false, antiAliasType:String = AntiAliasType.NORMAL): void {
			_embed = embed;
			_antiAliasType = antiAliasType;
				
			if (value) {
				_textFormat = value;
				
				if (_textField) {
					_textField.setTextFormat(_textFormat);
					_textField.embedFonts = _embed;
					_textField.antiAliasType = _antiAliasType;
				}
				
				for each (var go: GameObject in _gameObjects) {
					var label:Label;
					
					if (go is Label) {
						label = (go as Label);
						label.setTextFormat(_textFormat, _embed, _antiAliasType);
					}
				}
				updateLayout(true, true);
			}
		}
		
		private function updateLayout(updWidthPolicy: Boolean = false, updHeightPolicy: Boolean = false): void {
			_columnsWidth = new Array();
			_rowsHeight = new Array();
			var curCol: uint = 0;
			var curRow: uint = 0;
			// рассчет размеров колонок и рядов
			for (var i: uint; i < _gameObjects.length; i++) {
				var goWidth: uint = (_gameObjects[i] as GameObject).width;
				var goHeight: uint = (_gameObjects[i] as GameObject).height;
				if (_maxColumnsCount && curCol >= _maxColumnsCount) {
					curCol = 0;
					curRow++;
				}
				if (_maxRowsCount && curRow >= _maxRowsCount) {
					break;
				}
				switch (_columnWidthPolicy) {
					case COLUMN_WIDTH_POLICY_ALL_SAME:
						if (!_columnsWidth[curCol]) {
							if (curCol == 0) {
								_columnsWidth[curCol] = 0;
							}
							else {
								_columnsWidth[curCol] = _columnsWidth[0];
							}
						}
						if (goWidth > _columnsWidth[0]) {
							for (var c: uint = 0; c < columnsCount; c++) {
								_columnsWidth[c] = goWidth;
							}
						}
					break;
					default:
					case COLUMN_WIDTH_POLICY_BY_MAX_CELL:
						if (!_columnsWidth[curCol]) {
							_columnsWidth[curCol] = 0;
						}
						if (goWidth > _columnsWidth[curCol]) {
							_columnsWidth[curCol] = goWidth;
						}
					break;
				}
				switch (_rowHeightPolicy) {
					case ROW_HEIGHT_POLICY_ALL_SAME:
						if (!_rowsHeight[curRow]) {
							if (curRow == 0) {
								_rowsHeight[curRow] = 0;
							}
							else {
								_rowsHeight[curRow] = _rowsHeight[0];
							}
						}
						if (goHeight > _rowsHeight[0]) {
							for (var r: uint = 0; r < rowsCount; r++) {
								_rowsHeight[r] = goHeight;
							}
						}
					break;
					default:
					case ROW_HEIGHT_POLICY_BY_MAX_CELL:
						if (!_rowsHeight[curRow]) {
							_rowsHeight[curRow] = 0;
						}
						if (goHeight > _rowsHeight[curRow]) {
							_rowsHeight[curRow] = goHeight;
						}
					break;
				}
				curCol++;
			}
			// рассчет width и height на основе получившихся размеров ячеек
			var w: uint = 0;
			for (i = 0; i < columnsCount; i++) {
				w += getColumnWidth(i);
				if (i < columnsCount - 1) {
					w += _indentBetweenCols;
				}
			}
			var newWidth: uint = w;
			var h: uint = 0;
			for (i = 0; i < rowsCount; i++) {
				h += getRowHeight(i);
				if (i < rowsCount - 1) {
					h += _indentBetweenRows;
				}
			}
			var newHeight: uint = h;
			//изменение _rowsHeight _columnsWidth в соответствии с _widthPolicy _heightPolicy
			if (_columnsWidth.length > 0) {
				if (updWidthPolicy) {
					switch (_widthPolicy) {
						case WIDTH_POLICY_STRETCH_BY_WIDTH:
							var k: Number = width / newWidth;
							var realWidth: uint = 0;
							for (i = 0; i < _columnsWidth.length; i++) {
								_columnsWidth[i] = Math.round(_columnsWidth[i] * k);
								realWidth += _columnsWidth[i] + 2 * _paddingItem;
								if (i < _columnsWidth.length - 1) {
									realWidth += _indentBetweenCols;
								}
							}
							if (realWidth != width) {
								var l: uint = _columnsWidth.length - 1;
								_columnsWidth[l] = _columnsWidth[l] + (width - realWidth);
							}
						break;
						case WIDTH_POLICY_ABSOLUTE:
						
						break;
						case WIDTH_POLICY_AUTO_SIZE:
						default:
							width = newWidth;
						break;
					}
				}
			}
			else if (_widthPolicy == WIDTH_POLICY_AUTO_SIZE) {
				width = GameObject.MIN_WIDTH;
			}
			if (_rowsHeight.length > 0) {
				if (updHeightPolicy) {
					switch (_heightPolicy) {
						case HEIGHT_POLICY_STRETCH_BY_HEIGHT:
							k = height / newHeight;
							var realHeight: uint = 0;
							for (i = 0; i < _rowsHeight.length; i++) {
								_rowsHeight[i] = Math.round(_rowsHeight[i] * k);
								realHeight += _rowsHeight[i] + 2 * _paddingItem;
								if (i < _rowsHeight.length - 1) {
									realHeight += _indentBetweenRows;
								}
							}
							if (realHeight != height) {
								l = _rowsHeight.length - 1;
								_rowsHeight[l] = _rowsHeight[l] + (height - realHeight);
							}
						break;
						case HEIGHT_POLICY_ABSOLUTE:
						
						break;
						case HEIGHT_POLICY_AUTO_SIZE:
						default:
							height = newHeight;
						break;
					}
				}
			}
			else if (_widthPolicy == HEIGHT_POLICY_AUTO_SIZE) {
				height = GameObject.MIN_HEIGHT;
			}
			//_debugContainer.graphics.clear();
			for each(var go: GameObject in _gameObjects) {
				if (contains(go)) {
					//removeChild(go);
					removeComponent(go);
				}
			}
			// заполнение объектами
			curCol = 0;
			curRow = 0;
			var cellRectX: uint = 0;
			var cellRectY: uint = 0;
			for each(go in _gameObjects) {
				if (_maxColumnsCount && curCol >= _maxColumnsCount) {
					cellRectX = 0;
					curCol = 0;
					cellRectY += _rowsHeight[curRow] + 2 * _paddingItem + _indentBetweenRows;
					curRow++;
				}
				if (_maxRowsCount && curRow >= _maxRowsCount) {
					return;
				}
				//go.x = cellRectX + _paddingItem;
				//go.y = cellRectY + _paddingItem;
				//go.width = _columnsWidth[curCol];
				//go.height = _rowsHeight[curRow];
//				go.textHorizontalAlign = _horizontalItemsAlign;
//				go.textVerticalAlign = _verticalItemsAlign;
				switch (_horizontalItemsAlign) {
					case View.ALIGN_HOR_LEFT:
						go.x = cellRectX + _paddingItem;
					break;
					case View.ALIGN_HOR_RIGHT:
						go.x = cellRectX + _paddingItem + _columnsWidth[curCol] - go.width;
					break;
					default:
					case View.ALIGN_HOR_CENTER:
						go.x = cellRectX + _paddingItem + (_columnsWidth[curCol] - go.width) / 2;
					break;
				}
				switch (_verticalItemsAlign) {
					case View.ALIGN_VER_TOP:
						go.y = cellRectY + _paddingItem;
					break;
					case View.ALIGN_VER_BOTTOM:
						go.y = cellRectY + _paddingItem + _rowsHeight[curRow] - go.height;
					break;
					default:
					case View.ALIGN_VER_CENTER:
						go.y = cellRectY + _paddingItem + (_rowsHeight[curRow] - go.height) / 2;
					break;
				}
				//go.selectRect = new Rectangle(-(_columnsWidth[curCol] - go.width) / 2, -(_rowsHeight[curRow] - go.height) / 2, _columnsWidth[curCol] - 1, _rowsHeight[curRow] - 1);
				go.setSelect(true, false, null, new Rectangle(cellRectX - go.x + _paddingItem, cellRectY - go.y + _paddingItem, _columnsWidth[curCol], _rowsHeight[curRow]));
				addComponent(go);
				//addChild(go);
				cellRectX += _columnsWidth[curCol] + 2 * _paddingItem + _indentBetweenCols;
				curCol++;
			}
		}
		
		private function itemMouseClickListener(event: GameObjectEvent): void {
			selectItem(event.gameObject);
		}
		
		private function selectItem(value: GameObject): void {
			var index: int = _gameObjects.indexOf(value);
			if (index != -1) {
				_selectedItem = _items[index];
				_selectedRowIndex = index / columnsCount;
				//_selectedColumnIndex = index - (_selectedRowIndex * columnsCount);
				_selectedColumnIndex = index % columnsCount;
				var gbEvent: GridBoxEvent = new GridBoxEvent(GridBoxEvent.TYPE_ITEM_SELECTED);
				gbEvent.gameObject = value;
				gbEvent.item = _items[index];
				gbEvent.columnIndex = _selectedColumnIndex;
				gbEvent.rowIndex = _selectedRowIndex;
				dispatchEvent(gbEvent);
			}
		}
	}
}
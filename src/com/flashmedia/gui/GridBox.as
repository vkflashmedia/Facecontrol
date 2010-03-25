package ru.flashmedia.gui
{
	import flash.geom.Rectangle;
	
	import ru.flashmedia.basics.GameLayer;
	import ru.flashmedia.basics.GameObject;
	import ru.flashmedia.basics.GameObjectEvent;
	import ru.flashmedia.basics.GameScene;

	public class GridBox extends GameLayer
	{
		public static const ROW_HEIGHT_POLICY_BY_MAX_CELL: String = 'row_height_policy_by_max_size';
		public static const ROW_HEIGHT_POLICY_ALL_SAME: String = 'row_height_policy_all_same';
		public static const COLUMN_WIDTH_POLICY_BY_MAX_CELL: String = 'column_width_policy_by_max_size';
		public static const COLUMN_WIDTH_POLICY_ALL_SAME: String = 'column_width_policy_all_same';
		
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
		private var _indentBetweenItems: uint;
		private var _horizontalItemsAlign: String;
		private var _verticalItemsAlign: String;
		private var _rowHeightPolicy: String;
		private var _columnWidthPolicy: String;
		
		private var _items: Array;
		private var _gameObjects: Array;
		private var _columnsWidth: Array;
		private var _rowsHeight: Array;
		
		public function GridBox(value:GameScene, maxColumnsCount: uint = COLUMNS_DEF_COUNT, maxRowsCount: uint = ROWS_DEF_COUNT)
		{
			super(value);
			_items = new Array();
			_gameObjects = new Array();
			_columnsWidth = new Array();
			_rowsHeight = new Array();
			_selectedColumnIndex = undefined;
			_selectedRowIndex = undefined;
			_maxColumnsCount = maxColumnsCount;
			_maxRowsCount = maxRowsCount;
			_maxItemWidth = undefined;
			_maxItemHeight = undefined;
			_paddingItem = PADDING_ITEM;
			_indentBetweenItems = INDENT_BETWEEN_ITEMS;
			_horizontalItemsAlign = HORIZONTAL_ALIGN_CENTER;
			_verticalItemsAlign = VERTICAL_ALIGN_CENTER;
			_rowHeightPolicy = ROW_HEIGHT_POLICY_BY_MAX_CELL;
			_columnWidthPolicy = COLUMN_WIDTH_POLICY_BY_MAX_CELL;
		}
		
		public function addItem(value: String): void {
			//TODO сделать произвольный тип
			_items.push(value);
			var label: Label = new Label(scene, value);
			//label.debug = true;
			label.selectable = true;
			label.canHover = true;
			label.canFocus = true;
			label.focusSizeMode = GameObject.SIZE_MODE_SELECT;
			label.hoverSizeMode = GameObject.SIZE_MODE_SELECT;
			label.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, itemMouseClickListener);
			_gameObjects.push(label);
			updateLayout();
		}
		
		public function get selectedItem(): * {
			return _selectedItem;
		}
		
		public function set selectedItem(value:*): void {
			var index: uint = _items.indexOf(value);
			if (index != -1) {
				selectItem(_gameObjects[index]);
			}
		}
		
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
			updateLayout();
		}
		
		public function set indentBetweenItems(value: uint): void {
			_indentBetweenItems = value;
			updateLayout();
		}
		
		public function set horizontalItemsAlign(value: String): void {
			_horizontalItemsAlign = value;
			updateLayout();
		}
		
		public function set verticalItemsAlign(value: String): void {
			_verticalItemsAlign = value;
			updateLayout();
		}
		
		public function set columnWidthPolicy(value: String): void {
			_columnWidthPolicy = value;
			updateLayout();
		}
		
		public function set rowHeightPolicy(value: String): void {
			_rowHeightPolicy = value;
			updateLayout();
		}
		
		private function updateLayout(): void {
			_columnsWidth = new Array();
			_rowsHeight = new Array();
			var curCol: uint = 0;
			var curRow: uint = 0;
			for each(var go: GameObject in _gameObjects) {
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
						if (go.width > _columnsWidth[0]) {
							for (var c: uint = 0; c < columnsCount; c++) {
								_columnsWidth[c] = go.width;
							}
						}
					break;
					default:
					case COLUMN_WIDTH_POLICY_BY_MAX_CELL:
						if (!_columnsWidth[curCol]) {
							_columnsWidth[curCol] = 0;
						}
						if (go.width > _columnsWidth[curCol]) {
							_columnsWidth[curCol] = go.width;
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
						if (go.height > _rowsHeight[0]) {
							for (var r: uint = 0; r < rowsCount; r++) {
								_rowsHeight[r] = go.height;
							}
						}
					break;
					default:
					case ROW_HEIGHT_POLICY_BY_MAX_CELL:
						if (!_rowsHeight[curRow]) {
							_rowsHeight[curRow] = 0;
						}
						if (go.height > _rowsHeight[curRow]) {
							_rowsHeight[curRow] = go.height;
						}
					break;
				}
				curCol++;
			}
//			var maxItemWidth: uint = 0;
//			var maxItemHeight: uint = 0;
//			for each(go in _gameObjects) {
//				if (go.width > maxItemWidth) {
//					maxItemWidth = go.width;
//				}
//				if (go.height > maxItemHeight) {
//					maxItemHeight = go.height;
//				}
//			}
//			_maxItemWidth = maxItemWidth;
//			_maxItemHeight = maxItemHeight;
			//_debugContainer.graphics.clear();
			for each(go in _gameObjects) {
				if (contains(go)) {
					removeChild(go);
				}
			}
			curCol = 0;
			curRow = 0;
			var cellRectX: uint = 0;
			var cellRectY: uint = 0;
			for each(go in _gameObjects) {
				if (_maxColumnsCount && curCol >= _maxColumnsCount) {
					cellRectX = 0;
					curCol = 0;
					cellRectY += _rowsHeight[curRow] + 2 * _paddingItem + _indentBetweenItems;
					curRow++;
				}
				if (_maxRowsCount && curRow >= _maxRowsCount) {
					return;
				}
//				var cellRectX: uint = curCol * (cellWidth + _indentBetweenItems);
//				var cellRectY: uint = curRow * (cellHeight + _indentBetweenItems);
//				_debugContainer.graphics.lineStyle(1, BORDERS_COLOR);
//				_debugContainer.graphics.drawRect(cellRectX, cellRectY, cellWidth, cellHeight);
//				var x: uint = curCol * (cellWidth + _indentBetweenItems) + _paddingItem;
//				var y: uint = curRow * (cellHeight + _indentBetweenItems) + _paddingItem;// + (_maxItemHeight - go.height) / 2;
				go.x = cellRectX + _paddingItem;
				go.y = cellRectY + _paddingItem;
				go.width = _columnsWidth[curCol];
				go.height = _rowsHeight[curRow];
				go.textHorizontalAlign = _horizontalItemsAlign;
				go.textVerticalAlign = _verticalItemsAlign;
				go.selectRect = new Rectangle(-(_columnsWidth[curCol] - go.width) / 2, -(_rowsHeight[curRow] - go.height) / 2, _columnsWidth[curCol] - 1, _rowsHeight[curRow]);
				addChild(go);
				cellRectX += _columnsWidth[curCol] + 2 * _paddingItem + _indentBetweenItems;
				curCol++;
			}
			var w: uint = 0;
			for (var i: uint = 0; i < columnsCount; i++) {
				w += getColumnWidth(i);
				if (i < columnsCount - 1) {
					w += _indentBetweenItems;
				}
			}
			width = w;
			var h: uint = 0;
			for (i = 0; i < rowsCount; i++) {
				h += getRowHeight(i);
				if (i < rowsCount - 1) {
					h += _indentBetweenItems;
				}
			}
			height = h;
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
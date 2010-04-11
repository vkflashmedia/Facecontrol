package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	//TODO сделать чтобы можно было добавлять любой объект. Сейчас только текст.
	public class ComboBox extends GameObject
	{
		private var _dropList: GridBox;
		private var _dropIcon: Bitmap;
		private var _savedZOrder: int;
		
		public function ComboBox(value:GameScene)
		{
			super(value);
			width = 100;
			height = 20;
			setSelect(true);
			setFocus(true, false);
//			canHover = true;
			//fillBackground(0xfafaff, 1.0);
			_dropList = new GridBox(value, 1);
			_dropList.fillBackground(0xffffff, 1.0);
			_dropList.visible = false;
			_dropList.x = 0;
			_dropList.y = height;
			_dropList.widthPolicy = GridBox.WIDTH_POLICY_STRETCH_BY_WIDTH;
			_dropList.width = width;
			_dropList.padding = 0;
			_dropList.indentBetweenItems = 0;
			_dropList.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_dropList.verticalItemsAlign = View.ALIGN_VER_CENTER;
			_dropList.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, onItemClickListener);
			addChild(_dropList);
			updateComboBox();
		}
		
		public override function set width(value: Number): void {
			super.width = value;
			if (_dropList) {
				_dropList.width = width;
			}
		}
		
		public override function set height(value: Number): void {
			super.height = value;
			if (_dropList) {
				_dropList.y = height;
			}
		}
		
		public function addItem(value: String): void {
			_dropList.addItem(value);
		}
		
		public override function set bitmap(value: Bitmap): void {
			clearBackground();
			super.bitmap = value;
		}
		
		public function get selectedIndex(): uint {
			return _dropList.selectedRowIndex;
		}
		
		public function set selectedItem(value: String): void {
			_dropList.selectedItem = value;
			updateComboBox();
		}
		
		public function get selectedItem(): * {
			return _dropList.selectedItem;
		}
		
		public override function set focus(value: Boolean): void {
			super.focus = value;
			if (!value) {
				_dropList.visible = false;
				if (zOrder == GameObject.MAX_Z_ORDER) {
					zOrder = _savedZOrder;
				}
			}
		}
		
		public function set dropIcon(value: Bitmap): void {
			var bd: BitmapData = null;
			var b: Bitmap = null;
			if (_bitmap) {
				bd = _bitmap.bitmapData;
				b = _bitmap;
			}
			else {
				bd = new BitmapData(width, height, true, undefined);
				b = new Bitmap(bd);
			}
			var m: Matrix = new Matrix(1, 0, 0, 1, width - value.width, 0);
			bd.draw(value, m);
			bitmap = b;
//			if (_dropIcon) {
////			_dropIcon.removeEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onDropIconClickListener);
//				removeChild(_dropIcon);
//				_dropIcon = null;
//			}
//			_dropIcon = value;
//			_dropIcon.x = width - _dropIcon.width;
//			_dropIcon.y = 0;
//			addChild(_dropIcon);
			
//			_dropIcon = new GameObject(scene);
//			_dropIcon.selectable = true;
//			_dropIcon.canHover = true;
//			_dropIcon.bitmap = value;
//			_dropIcon.x = width - _dropIcon.width;
//			_dropIcon.y = 0;
//			_dropIcon.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onDropIconClickListener);
//			_dropIcon.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onDropIconMouseHoverListener);
//			_dropIcon.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onDropIconMouseLostListener);
//			addChild(_dropIcon);
		}
		
		private function updateComboBox(): void {
			//пока только текст
			//TODO объект из _dropList копируется (клонируется) в область ComboBox, не заботясь о типе
			if (_dropList.selectedItem) {
				var tf: TextField = new TextField();
				tf.text = _dropList.selectedItem as String;
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.width = width;
				tf.height = height;
				setTextField(tf, View.ALIGN_HOR_LEFT | View.ALIGN_VER_CENTER);
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			_dropList.visible = !_dropList.visible;
			if (_dropList.visible) {
				_savedZOrder = zOrder;
				zOrder = GameObject.MAX_Z_ORDER;
			}
			else {
				zOrder = _savedZOrder;
			}
		}
		
		private function onItemClickListener(event: GridBoxEvent): void {
			_dropList.visible = false;
			zOrder = _savedZOrder;
			updateComboBox();
		}
		
//		private function onDropIconClickListener(event: GameObjectEvent): void {
//			focus = true;
//			_dropList.visible = !_dropList.visible;
//		}
//		
//		private function onDropIconMouseHoverListener(event: GameObjectEvent): void {
//			hover = true;
//		}
//		
//		private function onDropIconMouseLostListener(event: GameObjectEvent): void {
//			hover = false;
//		}
	}
}
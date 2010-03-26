package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	//TODO сделать чтобы можно было добавлять любой объект. Сейчас только текст.
	public class ComboBox extends GameObject
	{
		private var _dropList: GridBox;
		private var _dropIcon: Bitmap;
		
		public function ComboBox(value:GameScene)
		{
			super(value);
			width = 100;
			height = 20;
			selectable = true;
			canFocus = true;
			canHover = true;
			fillBackground(0xfafaff, 1.0);
			_dropList = new GridBox(value, 1);
			_dropList.fillBackground(0xffffff, 1.0);
			_dropList.visible = false;
			_dropList.x = x;
			_dropList.y = y + height;
			_dropList.widthPolicy = GridBox.WIDTH_POLICY_STRETCH_BY_WIDTH;
			_dropList.width = width;
			_dropList.padding = 0;
			_dropList.indentBetweenItems = 1;
			_dropList.horizontalItemsAlign = GameObject.HORIZONTAL_ALIGN_LEFT;
			_dropList.verticalItemsAlign = GameObject.VERTICAL_ALIGN_CENTER;
			_dropList.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, onItemClickListener);
			addChild(_dropList);
			updateComboBox();
		}
		
		public function addItem(value: String): void {
			_dropList.addItem(value);
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
			_dropList.visible = false;
		}
		
		public function set dropIcon(value: Bitmap): void {
			_dropIcon = value;
			_dropIcon.x = width - _dropIcon.width;
			_dropIcon.y = 0;
			_dropIcon.addEventListener(MouseEvent.CLICK, super.mouseClickListener);
			addChild(_dropIcon);
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
				textField = tf;
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			_dropList.visible = !_dropList.visible;
		}
		
		private function onItemClickListener(event: GridBoxEvent): void {
			_dropList.visible = false;
			updateComboBox();
		}
	}
}
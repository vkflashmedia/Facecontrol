package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Pagination extends GameObject
	{
		private static const RIGHT_INDENT:uint = 5;
		
		protected var _currentPage:uint;
		
		private var _pagesCount:uint;
		private var _visiblePagesCount:uint;
		private var _currentX:uint;
		
		public function Pagination(value:GameScene, x:uint=0, y:uint=0, _pagesCount:uint=0, _visiblePagesCount:uint=2)
		{
			super(value);
			this.x = x;
			this.y = y;
			this._pagesCount = _pagesCount;
			this._visiblePagesCount = _visiblePagesCount;
			
			_currentPage = 0;
			_currentX = 0;
			
			clear();
			update();
		}
		
		public function clear():void {
			_currentX = 0;
			while (numChildren != 0) {
				removeChildAt(0);
			}
		}
		
		public function update():void {
			var start:uint = 0;
			var end:uint = 0;
			var i:uint = 0;
			
			if (_pagesCount < _visiblePagesCount) {
				for (i = 0; i < _pagesCount; ++i) {
					addButton(new String(i + 1), (i == _currentPage));
				}
			}
			else {
				var max:uint = Math.max(0, _currentPage - _visiblePagesCount);
				var min:uint = Math.min(_pagesCount - 1, _currentPage + _visiblePagesCount);
				
				if (max > 0) addButton("«", false);
		
		        for (i = max; i <= min; ++i) {
		          addButton(new String(i + 1), (i == _currentPage));
		        }
		
		        if (min < _pagesCount - 1) addButton("»", false);
			}
		}
		
		private function addButton(label:String, isCurrent:Boolean):void {
			var b:LinkButton = new LinkButton(_scene, label, _currentX);
			b.setUnderline(isCurrent);
			addChild(b);
			if (isCurrent) b.enabled = false;
			if (!isCurrent) b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, buttonClickListener);
			
			_currentX += b.width + RIGHT_INDENT;
		}
		
		private function buttonClickListener(e:GameObjectEvent):void {
			var o:Object = e.gameObject;
			var buttonIndex:int = o.intVal;
			if (buttonIndex < 0) buttonIndex = _pagesCount - 1;
			else --buttonIndex;
			
			_currentPage = buttonIndex;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
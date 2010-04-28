package com.flashmedia.basics.actions.intervalactions
{
	import com.flashmedia.basics.actions.basicactions.ActionEvent;
	
	public class IntervalActionEvent extends ActionEvent
	{
		/**
		 * Возникает при паузе в выполнении IntervalAction
		 */
		public static const TYPE_PAUSED: String = 'type_paused';
		/**
		 * Возникает при старте Action
		 */
		public static const TYPE_STARTED: String = 'type_started';
		/**
		 * Возникает при старте каждой итерации Action.
		 * Итераций может быть одна, а может и много (зацикливание)
		 */
		public static const TYPE_ITERATION_STARTED: String = 'type_iteration_started';
		/**
		 * Возникает в конце каждой итерации Action
		 */
		public static const TYPE_ITERATION_ENDED: String = 'type_iteration_ended';
		/**
		 * Возникает при полном завершении Action
		 */
		public static const TYPE_ENDED: String = 'type_ended';
		
		public function IntervalActionEvent()
		{
		}

	}
}
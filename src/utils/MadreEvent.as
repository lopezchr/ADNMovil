package utils
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class MadreEvent extends Event
	{
		public var contenido:Object;
		public var collectionResult:ArrayCollection;
		public function MadreEvent(type:String, objeto:Object=null, colle:ArrayCollection=null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type);
			contenido = objeto;
			collectionResult = colle;
		}
	}
}
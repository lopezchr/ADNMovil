package DAO
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.mxml.WebService;
	import utils.Parametros;
	import utils.MadreEvent;
	import utils.Utilidades;
	
	import com.adobe.crypto.HMAC;
	

	public class detalleCartera extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var terceroId:String;
		
		public function detalleCartera()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String):void
		{	
			terceroId = str;
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failDetalleCartera",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			//se genera hash de seguridad
			var hash:String = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+terceroId);
			ws.carteraDetalle(Parametros.IdEmpresa, terceroId,hash);	
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresult);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failDetalleCartera", res[0][0]));
			}else{
				dispatchEvent(new MadreEvent("readyDetalleCartera", res));	
			}
		}
	}
}
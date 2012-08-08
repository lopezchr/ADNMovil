package DAO
{
	import com.adobe.crypto.HMAC;
	import utils.Parametros;
	
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	
	import utils.Utilidades;
	import flash.events.Event;

	public class consultaCliente extends EventDispatcher
	{
		private var inputFilter:String;
		
		private var ws:WebService = new WebService;
		private var hash:String;
		
		public function consultaCliente()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String):void
		{	
			inputFilter = str;
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failCliente",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			//se genera hash de seguridad
			hash = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+Parametros.IdSistema);
			
			ws.cosultaCliente(Parametros.IdEmpresa, inputFilter, Parametros.IdSistema, hash);
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresult);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failCliente", "La consulta no fue efectiva."));
			}else{
				//se regitran los datos de la consulta
				Parametros.ListaCliente = res;		
				dispatchEvent(new Event("readyCliente"));
			}	
		}
	}
}
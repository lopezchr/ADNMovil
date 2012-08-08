package DAO
{
	import com.adobe.crypto.HMAC;
	
	import utils.Parametros;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	
	import utils.Utilidades;

	public class consultaUtilidad extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var inputFilter:String;
		private var sdate:String;
		
		public function consultaUtilidad()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String ,sda:String):void
		{
			sdate = sda;
			inputFilter = str;
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failUtilidad",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			
			//se genera hash de seguridad
			var hash:String = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+Parametros.IdSistema+sdate);
			ws.getUtilidad(Parametros.IdEmpresa, inputFilter, Parametros.IdSistema,sdate, hash);	
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT, onresult);
			
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failUtilidad", "La consulta no fue efectiva."));
			}else{
				Parametros.ListaUtilidad = res;
				dispatchEvent(new Event("readyUtilidad"));
			}
			
			
		}
	}
}
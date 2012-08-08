package DAO
{
	import utils.Parametros;
	import com.adobe.crypto.HMAC;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	
	import utils.Utilidades;
	

	public class consultaInventario extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var inputFilter:String;
		private var groupFilter:String;
		private var bodega :String;
		
		public function consultaInventario()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String , gr:String ,bod:String=""):void
		{	
			inputFilter = str;
			groupFilter = gr ;
			bodega = bod;
			
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failInventario",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			
			//se genera hash de seguridad
			var hash:String = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+Parametros.IdSistema);
			ws.getInventario(Parametros.IdEmpresa, inputFilter,Parametros.IdSistema,groupFilter,bodega,hash);	
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT, onresult);
			
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failInventario", "La consulta no fue efectiva."));
			}else{
				Parametros.ListaInventario = res;
				dispatchEvent(new Event("readyInventario"));
			}
			
			
		}
	}
}
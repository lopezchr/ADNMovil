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

	public class factArticulo extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var hash:String;
		private var idArticulo:String;
		
		public function factArticulo()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failFactArticulo",event.fault.toString()));
		}
		
		public function start(id:String):void
		{
			idArticulo = id;
			ws.loadWSDL();
		}
		
		protected function wsload(event:LoadEvent):void{
			ws.addEventListener(ResultEvent.RESULT , onresultTdoc);
			//ws.addEventListener(FaultEvent.FAULT ,wsfault);
			//se genera hash de seguridad
			
			var params:Object = Parametros.paramsFact;
			hash = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+idArticulo+params.bodega.id+params.lprecios.id);
			
			ws.getFactDetalleArticulo(Parametros.IdEmpresa, idArticulo, params.bodega.id, params.lprecios.id, hash);
		}
		protected function onresultTdoc(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresultTdoc);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failFactArticulo", "La consulta no fue efectiva.t"));
			}else{
				
				dispatchEvent(new MadreEvent("readyFactArticulo",res));
			}
		}
	}
}
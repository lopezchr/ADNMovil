package DAO
{
	import com.adobe.crypto.HMAC;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	import mx.utils.StringUtil;
	
	import utils.LoginEvent;
	import utils.MadreEvent;
	import utils.Parametros;
	import utils.Utilidades;

	public class login extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		
		private var hash:String;
		
		
		public function login()
		{			
			ws.wsdl = Parametros.Wsdl;;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start():void
		{
			ws.loadWSDL();
		}
		
		protected function wsload(event:LoadEvent):void
		{
			//se genera hash de seguridad
			hash = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey, Parametros.Login+Parametros.Pass+Parametros.Empresa);
			
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
			ws.login(Parametros.Login, Parametros.Pass ,Parametros.Empresa, hash);
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new LoginEvent("LoginError",event.fault.toString()));
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT, onresult);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new LoginEvent("LoginError", res[0][0]));
			}else{
				//serecuperan los parametros del login para futuras operaciones
				Parametros.UserId = res[0][0];
				Parametros.IdEmpresa = res[0][1];
				Parametros.AdnPwd = res[0][2];				
								
				//se genera hash de seguridad
				hash = HMAC.hash(Parametros.SecurutyKey,Parametros.UserId+Parametros.IdEmpresa);
				ws.addEventListener(ResultEvent.RESULT, resultSistemas);
				ws.getSistemas(Parametros.UserId, Parametros.IdEmpresa , hash);
			}
		}
		
		protected function resultSistemas(event:ResultEvent):void
		{
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			Parametros.Sistemas = res;
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new LoginEvent("LoginError", res[0][0]));
			}else{
				if(res.length > 1){
					dispatchEvent(new Event("MULTIPLES_SISTEMAS"));
				}else{
					Parametros.IdSistema = StringUtil.trim(res[0][0].toString());
					Parametros.NomEmpresa = res[0][1];
					dispatchEvent(new Event("UNICO_SISTEMA"));
				}
			}
			
		}
	}	
}
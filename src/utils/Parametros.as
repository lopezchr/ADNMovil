package utils
{
	import flash.sampler.NewObjectSample;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	[Bindable]
	public class Parametros
	{
		public static var mobileid:String = "";
		
		
		//http://190.145.31.162:4480
		//http://192.168.10.206:8084
		private static const wsdl:String = "http://192.168.10.206:8084/WS_ADNMovil/ADN_Mobile?wsdl";
		private static const wsdldoc:String = "http://192.168.10.206:8084/WS_ADNMovil/ADN_Document?wsdl";
		
		private static const securityKey:String="key";
		private static var adnDB:String;
		private static var adnPwd:String;
		private static var userId:String;
		
		private static var idEmpresa:String;
		
		private static var idSistema:String;
		private static var nomEmpresa:String;
		
		private static var sistemas:Array;
		private static var opciones:Array = new Array();
		
		private static var listaCartera:Array = new Array;
		private static var listaInventario:Array = new Array;
		private static var listaProveedores:Array = new Array;
		private static var listaBalance:Array = new Array;
		private static var listaMovimientos:Array = new Array;
		private static var listaUtilidad:Array = new Array;
		
		//parametros de login
		
		private static var empresa:String = "";
		private static var login:String = "";
		private static var pass:String = "";
		
		////O.o/////
		private static var listaCliente:Array = new Array;
		public static var paramsFact:Object = {
			tdoc:{id:"",nombre:"",cod:""},
			cliente:{id:"",nombre:"",cod:""},
			ccosto:{id:"",nombre:"",cod:""},
			bodega:{id:"",nombre:""},
			vendedor:{id:"",nombre:"",cod:""},
			lprecios:{id:"",nombre:""}
		};
		
		public static var paramsRecibo:Object = {
			tdoc:{id:"",nombre:"",cod:""},
			cliente:{id:"",nombre:"",cod:""},
			ccosto:{id:"",nombre:"",cod:""},
			vendedor:{id:"",nombre:"",cod:""}
		};
		
		public static var listaMediosPago:ArrayCollection = new ArrayCollection;
		
		public static var listaItemsFactura:ArrayCollection = new ArrayCollection;
		
		public static var listLog:ArrayList = new ArrayList;
		
		//functiones para optencion de datos
		public static function get Empresa():String{
			return empresa;
		}
		public static function get Login():String{
			return login;
		}
		public static function get Pass():String{
			return pass;
		}
		public static function get ListaCliente():Array{
			return listaCliente;
		}
		public static function get ListaMovimientos():Array{
			return listaMovimientos;
		}
		public static function get ListaBalance():Array{
			return listaBalance;
		}
		public static function get ListaCartera():Array{
			return listaCartera;
		}
		public static function get ListaInventario():Array{
			return listaInventario;
		}
		public static function get ListaProveedores():Array{
			return listaProveedores;
		}
		public static function get ListaUtilidad():Array{
			return listaUtilidad;
		}
		public static function get Wsdl():String{
			return wsdl;
		}
		public static function get WsdlDoc():String{
			return wsdldoc;
		}
		public static function get SecurutyKey():String{
			return securityKey;
		}
		public static function get AdnDB():String{
			return adnDB;
		}
		public static function get UserId():String{
			return userId;
		}
		public static function get AdnPwd():String{
			return adnPwd;
		}
		public static function get IdEmpresa():String{
			return idEmpresa;
		}
		public static function get IdSistema():String{
			return idSistema;
		}
		public static function get NomEmpresa():String{
			return nomEmpresa;
		}
		public static function get Sistemas():Array{
			return sistemas;
		}
		public static function get Opciones():Array{
			return opciones;
		}
		
		///Funciones de seteo de variables
		public static function set Empresa(ary:String):void{
			empresa = ary;
		}
		public static function set Login(ary:String):void{
			login = ary;
		}
		public static function set Pass(ary:String):void{
			pass = ary;
		}
		public static function set ListaCliente(ary:Array):void{
			listaCliente = ary;
		}
		public static function set ListaMovimientos(ary:Array):void{
			listaMovimientos = ary;
		}
		public static function set ListaBalance(ary:Array):void{
			listaBalance = ary
		}
		public static function set ListaCartera(ary:Array):void{
			listaCartera = ary;
		}
		public static function set ListaInventario(ary:Array):void{
			listaInventario = ary;
		}
		public static function set ListaProveedores(ary:Array):void{
			listaProveedores = ary;
		}
		public static function set ListaUtilidad(ary:Array):void{
			listaUtilidad = ary;
		}
		public static function set UserId(usr:String):void{
			userId = usr;
		}
		public static function set AdnDB(dbcon:String):void{
			adnDB = dbcon;
		}
		public static function set AdnUserId(user:String):void{
			userId = user;
		}
		public static function set AdnPwd(pwd:String):void{
			adnPwd = pwd;
		}
		public static function set IdEmpresa(empresa:String):void{
			idEmpresa = empresa;
		}
		public static function set IdSistema(sistema:String):void{
			idSistema = sistema;
		}
		public static function set NomEmpresa(nombre:String):void{
			nomEmpresa = nombre;
		}
		public static function set Sistemas(sistems:Array):void{
			sistemas = sistems;
		}
		public static function set Opciones(opc:Array):void{
			opciones = opc;
		}
		
		//funcion de reseteo de informacion
		
		public static function resetListas():void{
			listaBalance = new Array;
			listaCartera = new Array;
			listaInventario = new Array;
			listaMovimientos = new Array;
			listaProveedores = new Array;
			listaUtilidad = new Array;
		}
	}
}
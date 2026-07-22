package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Locale;
import java.util.ResourceBundle;

public class ConexionBDSQLServer {

	// Variable que permite realizar la conexi�n a la base de datos
	public static Connection Conexion = null;
	// Variables globales que se obtendran valores desde archivo propeties
	private static String usuario;
	private static String pwd;
	private static String db;
	private static String ip;
	private static String jdbc;
	private static String port;
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);

	public static void GetParametros() {
		/*	// Se inicializa la variable Properties
		Propiedades = new Properties();
		
		

		try {// Se inicializa la FileReader pasndo como parametro
				// la ruta fisica del archivo propiertie
			RutaFisica = new FileReader("src\\properties\\configSqlServer.properties");				

		} catch (FileNotFoundException eRuta) {
			// TODO Auto-generated catch block
			eRuta.printStackTrace();
		}

		try {
			Propiedades.load(RutaFisica);
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	/*	usuario = Propiedades.getProperty("servidor.usuario");
		pwd = Propiedades.getProperty("servidor.password");
		db = Propiedades.getProperty("bd.name");
		jdbc = Propiedades.getProperty("servidor.control");
		ip = Propiedades.getProperty("ip");
		port = Propiedades.getProperty("servidor.port");*/
		
		usuario = et.getString("servidor.usuario");
		pwd = et.getString("servidor.password");
		db = et.getString("bd.name");
		jdbc = et.getString("servidor.control");
		ip = et.getString("ip");
		port = et.getString("servidor.port");
		
		
	}
	

	public static Connection GetConexion() {
		// Se ejecuta el metodo que optiene los parametros de el archivo propertie
		GetParametros();
		// Inicializa la conexi�n en nulo
		Conexion = null;
		try {

			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			// esta cadena permite determinar configuraciones basi
			// String DbUrl = jdbc + "://" + ip + "\\" + NombreServer + ";databaseName=" +
			// db + ";";
			String DbUrl = jdbc + "://" + ip + ":" + port + ";databaseName=" + db + ";";
			///System.out.println(DbUrl);
			Conexion = DriverManager.getConnection(DbUrl, usuario, pwd);
			// Si la conexión fue exitosa debe devolver una variable con un Valor diferente
			// de Null
			/*
			 * //Solo para imprimir datos del servidor if (Conexion != null) {
			 * DatabaseMetaData dm = Conexion.getMetaData();
			 * System.out.println("Driver name: " + dm.getDriverName()); }
			 */
		} catch (SQLException ex) {
			System.err.println("Error." + ex.getMessage());
			Conexion = null;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Conexion = null;
		}

		return Conexion;
	}

}

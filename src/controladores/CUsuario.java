package controladores;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.JOptionPane;

import conexion.ConexionBDSQLServer;
import modelos.MUsuarios;

public class CUsuario {

	/**
	 * Conexión a la base de datos.
	 */
	public static Connection Conexion = null;
	/**
	 * Sentencia de consulta SQL a ejecutar
	 */
	public static String sql;
	/**
	 * Objeto para ejecutar consulta con parámetros
	 */
	public static PreparedStatement sentencia;

	public static CallableStatement cs;

	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);

	public static boolean validarUsuario(MUsuarios user) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		boolean valido = false;
		try {
			sql = "SELECT * FROM Usuarios WHERE usuario = ? AND contrasena = ? ";
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, user.getNombreUsuario());
			sentencia.setString(2, user.getContraseña());

			ResultSet rs = sentencia.executeQuery();
			if (rs.next()) {
				valido = true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EVU"), "Error", JOptionPane.ERROR_MESSAGE);
		}

		return valido;
	}

	public static void guardarUsuario(MUsuarios usuarionuevo) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		try {
			sql = "INSERT INTO Usuarios (usuario, contrasena, rol) VALUES (?, ?, ?)";
			sentencia = Conexion.prepareStatement(sql);

			sentencia.setString(1, usuarionuevo.getNombreUsuario());
			sentencia.setString(2, usuarionuevo.getContraseña());
			sentencia.setString(3, usuarionuevo.getRol());

			int filasAfectadas = sentencia.executeUpdate();

			// Verificar si la inserción fue exitosa
			if (filasAfectadas > 0) {
				JOptionPane.showMessageDialog(null, et.getString("URE"), et.getString("info"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("NRU"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EGU") + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
		}

	}

	public static String obtenerRolUsuario(MUsuarios usuarioLogin) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		String rol = null;

		try {
			String sql = "SELECT rol FROM Usuarios WHERE usuario = ? AND contrasena = ?";
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, usuarioLogin.getNombreUsuario());
			sentencia.setString(2, usuarioLogin.getContraseña());

			ResultSet rs = sentencia.executeQuery();
			if (rs.next()) {
				rol = rs.getString("rol");
			}

		} catch (SQLException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EOU"), "Error", JOptionPane.ERROR_MESSAGE);
		}

		return rol;
	}

	public static void ejecutarRespaldo(String nombreR, String ruta) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		cs = null;

		try {
			String sql = "{call Respaldo(?, ?)}";
			cs = ConexionBDSQLServer.GetConexion().prepareCall(sql);
			cs.setString(1, nombreR);
			cs.setString(2, ruta);
			cs.execute();
			JOptionPane.showMessageDialog(null, et.getString("RCC"));
		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, et.getString("ECR") + e.getMessage());
		}

	}
}
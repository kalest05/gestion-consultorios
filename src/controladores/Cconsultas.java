
package controladores;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.swing.DefaultComboBoxModel;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

import conexion.ConexionBDSQLServer;
import modelos.MConsultas;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;
import vistas.Consultas;

/**
 * El controlador gestiona las operaciones relacionadas con las consultas en la
 * base de datos del sistema.
 * <p>
 * Esta clase permite utilizando un modelo de tipo {@link MConsultas}, mediante
 * una conexión a SQL Server. <b>Realiza ciertas acciones</b>
 * <li>Modificar los registros de consultas</li>
 * <li>Eliminar los registros de consultas</li>
 * <li>Insertar los registros de consultas</li>
 * 
 * @see vistas.Consultas
 *      </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 * 
 */
public class Cconsultas {

	/**
	 * Conexión a la base de datos
	 */
	public static Connection Conexion = null;
	/**
	 * Sentencia de consulta SQL a ejecutar
	 */
	public static String sql;
	/**
	 * Resultado de la consulta SQL
	 */
	public static ResultSet ResultSet = null;
	/**
	 * Objeto para ejecutar consulta con parámetros
	 */
	public static PreparedStatement sentencia;

	private static int totalRegistros = 0;
	public static Consultas consulta;

	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);

	/**
	 * Carga una lista paginada de registros de la tabla {@code Consultas} y los
	 * muestra en el modelo de tabla proporcionado.
	 * <p>
	 * Se utiliza paginación SQL mediante {@code OFFSET} y {@code FETCH NEXT} para
	 * cargar solo los registros necesarios por página, mejorando el rendimiento en
	 * bases de datos grandes.
	 * </p>
	 *
	 * @param model              El {@code DefaultTableModel} donde se insertarán
	 *                           los registros.
	 * @param paginaActual       Número de la página actual que se desea consultar
	 *                           (inicia en 1).
	 * @param registrosPorPagina Cantidad de registros que se deben cargar por
	 *                           página.
	 * @exception SQLException errores de SQL en base de datos.
	 */
	public void buscarUsuariosConTableModel(DefaultTableModel model, int paginaActual, int registrosPorPagina) {

		PreparedStatement pst = null;// Variable PreparedStatement
		// Se genear una variables que optiene la conexion ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = "SELECT c.idConsulta, ct.idCita, c.fecha, c.diagnostico, c.observaciones, c.presion, c.temp, c.altura, c.peso "
				+ "FROM Consultas c " + "LEFT JOIN Citas ct ON ct.idCita = c.idCita "
				+ "ORDER BY c.idConsulta OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[9];
				for (int i = 0; i < 9; i++)
					fila[i] = rs.getObject(i + 1);
				model.addRow(fila);
			}
			rs.close();
			pst.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	/**
	 * Cuenta la cantidad total de registros en la tabla {@code Consultas} de la
	 * base de datos.
	 *
	 * <p>
	 * Este método es útil en funcionalidades que requieren paginación o
	 * estadísticas, como la visualización paginada en una tabla ({@code JTable}).
	 * </p>
	 *
	 * @return El número total de registros encontrados en la tabla
	 *         {@code Consultas}.
	 * @exception Marca errores en base de datos de SQL
	 */
	public static double contarRegistros() {
		// TODO Auto-generated method stub
		try {
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Consultas");
			if (rs.next())
				totalRegistros = rs.getInt(1);
			rs.close();
			st.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return totalRegistros;
	}

	/**
	 * Modifica un registro existente en la tabla {@code Consultas} con base en su
	 * {@code idConsulta}.
	 * <p>
	 * Los cambios también se reflejan de forma inmediata en el
	 * {@code DefaultTableModel} de la interfaz gráfica si la actualización es
	 * exitosa.}
	 * </p>
	 * 
	 * @exception SQLException Muestra errores de SQL de bases de datos.
	 * @param idConsulta ID de la consulta que se desea actualizar.
	 * @param consultaM  Objeto de tipo {@code MConsultas} con los nuevos datos de
	 *                   la consulta.
	 * @param model      Modelo de tabla donde se visualiza la consulta en una
	 *                   {@code JTable}.
	 * @param indicereg  Índice de la fila a actualizar en el modelo de tabla.
	 */
	public void modificarCon(int idConsulta, MConsultas consultaM, DefaultTableModel model, int indicereg) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("UPDATE Consultas set idCita = ?, fecha=?, diagnostico=?, observaciones=?, presion=?, temp=?, "
				+ "altura=?, peso=? ");

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setInt(1, consultaM.getIdCita());
			java.sql.Date sqlDate = new java.sql.Date(consultaM.getFecha().getTime());
			sentencia.setDate(2, sqlDate);
			sentencia.setString(3, consultaM.getDiagnostico());
			sentencia.setString(4, consultaM.getObservaciones());
			sentencia.setString(5, consultaM.getPresion());
			sentencia.setString(6, consultaM.getTemp());
			sentencia.setString(7, consultaM.getAltura());
			sentencia.setString(8, consultaM.getPeso());

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				model.setValueAt(consultaM.getIdCita(), indicereg, 1);
				model.setValueAt(consultaM.getFecha(), indicereg, 2);
				model.setValueAt(consultaM.getDiagnostico(), indicereg, 3);
				model.setValueAt(consultaM.getObservaciones(), indicereg, 4);
				model.setValueAt(consultaM.getPresion(), indicereg, 5);
				model.setValueAt(consultaM.getTemp(), indicereg, 6);
				model.setValueAt(consultaM.getAltura(), indicereg, 7);
				model.setValueAt(consultaM.getPeso(), indicereg, 8);

				JOptionPane.showMessageDialog(null, et.getString("cmc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emcs"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLCO") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emcs"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Inserta un nuevo registro en la tabla {@code Consultas} con los datos
	 * proporcionados en el objeto {@code MConsultas}.
	 *
	 * <p>
	 * Los campos que se insertan son:
	 * </p>
	 * <ul>
	 * <li><b>idCita</b>: ID de la cita relacionada.</li>
	 * <li><b>fecha</b>: Fecha en que se realiza la consulta.</li>
	 * <li><b>diagnostico</b>: Diagnóstico médico realizado.</li>
	 * <li><b>observaciones</b>: Comentarios adicionales.</li> Entre otras.
	 * </ul>
	 *
	 * <p>
	 * Si la inserción es exitosa, se muestra un mensaje informativo. En caso
	 * contrario, se muestra un mensaje de error.
	 * </p>
	 *
	 * @param nuevaConsulta Objeto de tipo {@code MConsultas} que contiene los datos
	 *                      a insertar.
	 * @return
	 * @exception SQLException Muestra errores de SQL
	 */
	public static int AnCon(MConsultas nuevaConsulta) {
		int idGenerado = -1;
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		// SQL con SELECT SCOPE_IDENTITY() para obtener el ID generado
		sql = "INSERT INTO Consultas (idCita, fecha, diagnostico, observaciones, presion, temp, altura, peso) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?); SELECT SCOPE_IDENTITY();";

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setInt(1, nuevaConsulta.getIdCita());
			java.sql.Date sqlDate = new java.sql.Date(nuevaConsulta.getFecha().getTime());
			sentencia.setDate(2, sqlDate);
			sentencia.setString(3, nuevaConsulta.getDiagnostico());
			sentencia.setString(4, nuevaConsulta.getObservaciones());
			sentencia.setString(5, nuevaConsulta.getPresion());
			sentencia.setString(6, nuevaConsulta.getTemp());
			sentencia.setString(7, nuevaConsulta.getAltura());
			sentencia.setString(8, nuevaConsulta.getPeso());

			// Ejecuta el INSERT + SELECT SCOPE_IDENTITY()
			ResultSet rs = sentencia.executeQuery();

			if (rs.next()) {
				idGenerado = rs.getInt(1); // Recupera el ID generado
				JOptionPane.showMessageDialog(null, et.getString("infog"), et.getString("info"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("ev"), "Error", JOptionPane.ERROR_MESSAGE);
			}

			rs.close(); // Cierra el ResultSet
		} catch (SQLException e) {
			System.err.println(et.getString("SQL") + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("ec"), "Error", JOptionPane.ERROR_MESSAGE);
		}

		return idGenerado;
	}

	/**
	 * Elimina una consulta y todas sus recetas asociadas de la base de datos.
	 * <p>
	 * Primero elimina los registros en la tabla {@code Recetas} que están
	 * relacionados con la consulta especificada mediante {@code idConsulta}, y
	 * luego elimina la consulta de la tabla {@code Consultas}.
	 * </p>
	 * <p>
	 * Si la eliminación es exitosa, también remueve la fila correspondiente del
	 * {@code DefaultTableModel} para reflejar el cambio en la interfaz gráfica.
	 * </p>
	 * 
	 * @param idConsulta El identificador único de la consulta que se desea
	 *                   eliminar.
	 * @param model      El modelo de tabla {@code DefaultTableModel} asociado a la
	 *                   tabla.
	 * @param seleccion  El índice de la fila seleccionada en la tabla que
	 *                   corresponde a la consulta a eliminar.
	 * @exception SQLException Errores de SQL
	 */
	public void eliminarconsulta(int idConsulta, DefaultTableModel model, int seleccion) {

		PreparedStatement stmtreceta = null;
		PreparedStatement stmtconsulta = null;

		Conexion = ConexionBDSQLServer.GetConexion();
		String sqlRecetas = "DELETE FROM Recetas WHERE idConsulta = ?"; // Eliminar las recetas asociadas
		String sqlConsulta = "DELETE FROM Consultas WHERE idConsulta = ?"; // Eliminar la consulta

		try {

			// Luego eliminar las citas asociadas al médico
			stmtreceta = Conexion.prepareStatement(sqlRecetas);
			stmtreceta.setInt(1, idConsulta);
			stmtreceta.executeUpdate();

			stmtconsulta = Conexion.prepareStatement(sqlConsulta);
			stmtconsulta.setInt(1, idConsulta);

			int filasAfectadas = stmtconsulta.executeUpdate();

			if (filasAfectadas > 0) {
				model.removeRow(seleccion);
				JOptionPane.showMessageDialog(null, et.getString("ccr"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eec"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLECO") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eec"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Obtiene todos los IDs de citas de la base de datos y los carga en un modelo
	 * {@code DefaultComboBoxModel<String>} para su uso en un {@code JComboBox}.
	 * <p>
	 * El primer elemento agregado es "Seleccione..." para indicar una opción por
	 * defecto que invita al usuario a seleccionar una cita.
	 * </p>
	 * 
	 * @return Un {@code DefaultComboBoxModel<String>} con los IDs de las citas
	 *         cargados.
	 */
	public static DefaultComboBoxModel<String> llenarCita() {
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT idCita, fecha FROM Citas "
					+ "WHERE CAST(fecha AS DATE) = CAST(GETDATE() AS DATE) " + "ORDER BY CAST(fecha AS TIME)");

			// Se ingresa un dato blanco en el primer campo del Combox
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabal de Combox
				DatosJcombox.addElement(rs.getString("idCita"));
			}
			rs.close();
			Consulta.close();

		} catch (SQLException e) {
			System.err.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("ecc"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Obtiene los nombres completos del paciente y del médico asociados a una cita
	 * específica.
	 *
	 * <p>
	 * Realiza una consulta a la base de datos para obtener los nombres concatenados
	 * (nombre + apellido paterno + apellido materno) tanto del paciente como del
	 * médico relacionados con la cita cuyo ID es {@code idCita}.
	 * </p>
	 *
	 * @param idCita El identificador único de la cita.
	 * @return Un arreglo de {@code String} donde:
	 *         <ul>
	 *         <li>{@code [0]} contiene el nombre completo del paciente.</li>
	 *         <li>{@code [1]} contiene el nombre completo del médico.</li>
	 *         </ul>
	 * @exception SQLException Errores de SQL.
	 */
	public static String[] obtenerNombresPorCita(int idCita) {
		String[] nombres = new String[2]; // [0] = paciente, [1] = médico

		String sql = " SELECT \r\n" + "                p.nombre + ' ' + p.app + ' ' + p.apm AS nombrePaciente,\r\n"
				+ "                m.nombre + ' ' + m.app + ' ' + m.apm AS nombreMedico\r\n"
				+ "            FROM Citas c\r\n" + "            JOIN Pacientes p ON c.idPaciente = p.idPaciente\r\n"
				+ "            JOIN Medicos m ON c.idMedico = m.idMedico\r\n" + "            WHERE c.idCita = ?";
		try {
			Conexion = ConexionBDSQLServer.GetConexion();

			PreparedStatement ps = Conexion.prepareStatement(sql);
			ps.setInt(1, idCita);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				nombres[0] = rs.getString("nombrePaciente");
				nombres[1] = rs.getString("nombreMedico");
			}

			rs.close();
			ps.close();
			Conexion.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return nombres;
	}

	public static void reporteconxmed(int med) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/consultasxmedico.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();

			parametros.put("Medico", med);

			JasperPrint print = JasperFillManager.fillReport(report, parametros, Conexion);

			if (print.getPages() == null || print.getPages().isEmpty()) {
				JOptionPane.showMessageDialog(null, et.getString("NOREP"), et.getString("REPV"),
						JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			JasperViewer.viewReport(print, false);
		} catch (JRException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EGP") + e.getMessage());
		}
	}

	public static void reportebasec() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/consultasbase.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			JasperPrint print = JasperFillManager.fillReport(report, null, Conexion);
			if (print.getPages() == null || print.getPages().isEmpty()) {
				JOptionPane.showMessageDialog(null, et.getString("NOREP"), et.getString("REPV"),
						JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			JasperViewer.viewReport(print, false);
		} catch (JRException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EGP") + e.getMessage());
		}

	}

	public static void repsemanalcon() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/consultasxsem.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			JasperPrint print = JasperFillManager.fillReport(report, null, Conexion);
			if (print.getPages() == null || print.getPages().isEmpty()) {
				JOptionPane.showMessageDialog(null, et.getString("NOREP"), et.getString("REPV"),
						JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			JasperViewer.viewReport(print, false);
		} catch (JRException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EGP") + e.getMessage());
		}
	}

	public static String[] obtenerNombresPorConsulta(int idConsulta) {
		String[] nombres = new String[2]; // [0] = paciente, [1] = médico

		String sql = "SELECT " + "    p.nombre + ' ' + p.app + ' ' + p.apm AS nombrePaciente, "
				+ "    m.nombre + ' ' + m.app + ' ' + m.apm AS nombreMedico " + "FROM Consultas con "
				+ "JOIN Citas c ON con.idCita = c.idCita " + "JOIN Pacientes p ON c.idPaciente = p.idPaciente "
				+ "JOIN Medicos m ON c.idMedico = m.idMedico " + "WHERE con.idConsulta = ?";

		try {
			Conexion = ConexionBDSQLServer.GetConexion();
			PreparedStatement ps = Conexion.prepareStatement(sql);
			ps.setInt(1, idConsulta);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				nombres[0] = rs.getString("nombrePaciente");
				nombres[1] = rs.getString("nombreMedico");
			}

			rs.close();
			ps.close();
			Conexion.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return nombres;
	}

}
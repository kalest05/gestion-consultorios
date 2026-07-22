package controladores;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.swing.DefaultComboBoxModel;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

import conexion.ConexionBDSQLServer;
import modelos.MCitas;
import modelos.MServicios;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

/**
 * El controlador gestiona las operaciones relacionadas con las citas en la base
 * de datos del sistema.
 * <p>
 * Esta clase permite registrar nuevas citasnutilizando un modelo de tipo
 * {@link MCitas}, mediante una conexión a SQL Server.
 * 
 * @see vistas.Citas
 *      </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 * 
 */
public class Ccitas {
	/**
	 * Conexión a la base de datos.
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

	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);

	/**
	 * Este metodo crea un modelo dentro del combobox de {@link vistas.Citas} donde
	 * realiza una busqueda a la tabla pacientes y arroja los id registrados.
	 * 
	 * @return DatosJcombox ComboBox llenado automaticamente con los datos.
	 */
	public static DefaultComboBoxModel<String> llenarpaciente() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Pacientes");

			// Se ingresa un dato blanco en el primer campo del Combox
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabal de Combox
				String paciente = rs.getString("nombre") + " " + rs.getString("app") + " " + rs.getString("apm");
				DatosJcombox.addElement(paciente);
			}
			rs.close();
			Consulta.close();

		} catch (SQLException e) {
			System.err.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("epa"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Este metodo crea un modelo dentro del combobox de {@link vistas.Citas} donde
	 * realiza una busqueda a la tabla medicos y arroja los id registrados.
	 * 
	 * @return DatosJcombox ComboBox llenado automaticamente con los datos.
	 */
	public static DefaultComboBoxModel<String> llenardoctor() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Medicos");

			// Se ingresa un dato blanco en el primer campo del Combox
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabal de Combox
				String medico = rs.getString("nombre") + " " + rs.getString("app") + " " + rs.getString("apm");
				DatosJcombox.addElement(medico);
			}
			rs.close();
			Consulta.close();

		} catch (SQLException e) {
			System.err.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eme"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;

	}

	/**
	 * 
	 * Este metodo realiza la consulta a la base de datos para obtener los registros
	 * de la tabla {@link vistas.Citas} y los carga en un DefaultTableModel.
	 * <p>
	 * Cada fila se carga al modelo de la tabla, permitiendo la vizualización en la
	 * tabla dentro de la vista.
	 * </p>
	 * 
	 * @param model Modelo de tabla donde agregará las filas que sean resultantes de
	 *              la busqueda.
	 * @throws SQLException Si ocurre un error al realizar la consulta a la base de
	 *                      datos.
	 * 
	 */
	public void buscarUsuariosConTableModel(DefaultTableModel model) {
		try {
			Statement estatuto = ConexionBDSQLServer.GetConexion().createStatement();
			sql = ("SELECT " + "Citas.idCita, " + "Pacientes.idPaciente, " + "Medicos.idMedico, " + "Citas.fecha, "
					+ "Citas.motivo, " + "Citas.estadoDeCita, " + "Servicios.nombre, " + "Citas.observacion, "
					+ "Personal.idPersonal, " + "Citas.consultorio " + "FROM Citas "
					+ "JOIN Pacientes ON Citas.idPaciente = Pacientes.idPaciente "
					+ "JOIN Medicos ON Citas.idMedico = Medicos.idMedico "
					+ "JOIN Servicios ON Citas.idServicio = Servicios.idServicio "
					+ "JOIN Personal ON Citas.idPersonal = Personal.idPersonal");
			ResultSet rs = estatuto.executeQuery(sql);

			while (rs.next()) {
				// es para obtener los datos y almacenar las filas
				Object[] fila = new Object[10];
				// para llenar cada columna con lo datos almacenados
				for (int i = 0; i < 10; i++)
					fila[i] = rs.getObject(i + 1);
				// es para cargar los datos en filas a la tabla modelo
				model.addRow(fila);

			}
			rs.close();
			estatuto.close();

		} catch (SQLException e) {
			System.out.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eac"), "Error", JOptionPane.ERROR_MESSAGE);

		}

	}

	/**
	 * Agrega una nueva cita en la base de datos. Este metodo toma los datos
	 * almacenados en un objeto {@link MCitas} y los inserta en la tabla
	 * {@code vistas.Citas} mediante una secuencia SQL.
	 * <p>
	 * Si la inserción es exitosa notifica al usuario mediante un mensaje. En el
	 * caso contrario, se notifica un error.
	 * </p>
	 * 
	 * @pram citan Objeto que contiene todos los datos sobre la cita a registrar.
	 * @throws SQLException Si ocurre un error al insertar los datos en SQL.
	 * @see ConexionBSSQLServer
	 * 
	 */
	public static void anaCita(MCitas citan) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Citas (idPaciente, idMedico, fecha , motivo, idServicio, consultorio, comentarioA)"
				+ " VALUES ((SELECT idPaciente FROM Pacientes WHERE  CONCAT(nombre, ' ', app, ' ', apm)=?), "
				+ "(SELECT idMedico FROM Medicos WHERE CONCAT(nombre, ' ', app, ' ', apm)=?), ?, ?,"
				+ "(SELECT idServicio FROM Servicios where nombre= ?), ?, ?)");

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, citan.getIdPaciente());
			sentencia.setString(2, citan.getIdMedico());
			java.sql.Timestamp sqlTimestamp = new java.sql.Timestamp(citan.getFechaC().getTime());
			sentencia.setTimestamp(3, sqlTimestamp);
			sentencia.setString(4, citan.getMotivo());
			sentencia.setString(5, citan.getServicios());
			sentencia.setString(6, citan.getConsultorios());
			sentencia.setString(7, citan.getComentario());

			// Ejecutar la inserción en SQL
			int filasAfectadas = sentencia.executeUpdate();

			// Verificar si la inserción fue exitosa
			if (filasAfectadas > 0) {
				JOptionPane.showMessageDialog(null, et.getString("infog"), et.getString("info"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("ev"), "Error", JOptionPane.ERROR_MESSAGE);
			}
		} catch (SQLException e) {
			// Manejo de errores SQL
			System.err.println("Error de SQL: " + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("eap"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Este método modifica los datos de las citas existentes en la base de datos y
	 * actualiza los datos de la fila correspondiente en el modelo de la tabla.
	 * 
	 * <p>
	 * La cita es identificada por su id, y sus datos son reemplazados por los
	 * valores obtenidos del objeto {@link MCitas} proporcionado.
	 * </p>
	 * 
	 * @param id        ID unico de la cita a modificar.
	 * @param altercita Objeto que contiene los datos de la cita.
	 * @param model     Modelo de tabla donde se refleja visualmente la
	 *                  modificación.
	 * @param indicereg Indice de la fila en el modelo de la tabla que corresponde a
	 *                  la cita.
	 * @throws SQLException Si ocurre un error durante la modificación.
	 * @see modelos.MCitas
	 * 
	 */

	public void modificarPaciente(int id, MCitas altercita, DefaultTableModel model, int indiceReg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		sql = "UPDATE Citas SET "
				+ "idPaciente = (SELECT idPaciente FROM Pacientes WHERE CONCAT(nombre, ' ', app, ' ', apm) = ?), "
				+ "idMedico = (SELECT idMedico FROM Medicos WHERE CONCAT(nombre, ' ', app, ' ', apm) = ?), "
				+ "fecha = ?, " + "motivo = ?, " + "idServicio = (SELECT idServicio FROM Servicios WHERE nombre = ?), "
				+ "consultorio = ?, " + "comentarioA = ? " + "WHERE idCita = ?";

		try {
			sentencia = Conexion.prepareStatement(sql);

			sentencia.setString(1, altercita.getIdPaciente());
			sentencia.setString(2, altercita.getIdMedico());
			java.sql.Timestamp sqlTimestamp = new java.sql.Timestamp(altercita.getFechaC().getTime());
			sentencia.setTimestamp(3, sqlTimestamp);
			sentencia.setString(4, altercita.getMotivo());
			sentencia.setString(5, altercita.getServicios());
			sentencia.setString(6, altercita.getConsultorios());
			sentencia.setString(7, altercita.getComentario());
			sentencia.setInt(8, id); // ID único de la cita a modificar

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// ✅ Actualizar visualmente la tabla si se requiere
				model.setValueAt(altercita.getIdPaciente(), indiceReg, 1);
				model.setValueAt(altercita.getIdMedico(), indiceReg, 2);
				model.setValueAt(altercita.getFechaC(), indiceReg, 3);
				model.setValueAt(altercita.getMotivo(), indiceReg, 4);
				model.setValueAt(altercita.getServicios(), indiceReg, 5);
				model.setValueAt(altercita.getComentario(), indiceReg, 6);
				model.setValueAt(altercita.getConsultorios(), indiceReg, 7);

				JOptionPane.showMessageDialog(null, et.getString("cm"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emc"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLC") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emc"), "Error", JOptionPane.ERROR_MESSAGE);
			e.printStackTrace();
		}

	}

	/**
	 * Elimina una cita y todas las recetas y citas asociadas a esta en la base de
	 * datos.
	 * <p>
	 * Este metodo realiza múltiples operaciones de manera ordenada con el fin de
	 * mantener la integridad referencial en la base de datos. Tambien actualiza la
	 * vista en la interfaz eliminando la fila correspondiente.
	 * </p>
	 * 
	 * @param id        ID de la cita que se desea eliminar.
	 * @param model     Modelo de tabla de la vista que contiene los datos de la
	 *                  cita.
	 * @param indicereg Indice de la fila correspondiente a la cita en la tabla, que
	 *                  debe ser eliminada de la base de datos.
	 * @throws SQLException Si ocurre un error durante la ejecución de alguna de las
	 *                      sentencias SQL.
	 * 
	 * 
	 */

	public void eliminarcitas(int id, DefaultTableModel model, int indicereg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		// Sentencias SQL para eliminar los registros relacionados
		// Sentencias SQL para eliminar los registros relacionados
		String sqlRecetaMedicamentos = "DELETE FROM RECETAMEDICAMENTOS WHERE idReceta IN ("
				+ "SELECT idReceta FROM Recetas WHERE idConsulta IN ("
				+ "SELECT idConsulta FROM Consultas WHERE idCita = ?))";

		String sqlRecetas = "DELETE FROM Recetas WHERE idConsulta IN ("
				+ "SELECT idConsulta FROM Consultas WHERE idCita = ?)";

		String sqlConsultas = "DELETE FROM Consultas WHERE idCita = ?";



		String sqlCitas = "DELETE FROM Citas WHERE idCita = ?";
		try {

			sentencia = Conexion.prepareStatement(sqlRecetaMedicamentos);
		    sentencia.setInt(1, id);
		    sentencia.executeUpdate();

		    // 2. Eliminar Recetas
		    sentencia = Conexion.prepareStatement(sqlRecetas);
		    sentencia.setInt(1, id);
		    sentencia.executeUpdate();

		    // 3. Eliminar Consultas
		    sentencia = Conexion.prepareStatement(sqlConsultas);
		    sentencia.setInt(1, id);
		    sentencia.executeUpdate();

		    // 6. Finalmente eliminar la cita
		    sentencia = Conexion.prepareStatement(sqlCitas);
		    sentencia.setInt(1, id);
		    int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Eliminar la fila del modelo de la tabla
				model.removeRow(indicereg);
				JOptionPane.showMessageDialog(null, et.getString("cr"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("errec"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLC") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("errec"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Este metodo crea un modelo dentro del combobox de {@link vistas.Citas} donde
	 * realiza una busqueda a la tabla servicios y arroja los nombres registrados.
	 * 
	 * @return DatosJcombox ComboBox llenado automaticamente con los datos.
	 */
	public static DefaultComboBoxModel<String> llenarservicios() {

		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT*FROM Servicios");

			// Se ingresa un dato blanco en el primer campo del Combox
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabal de Combox
				DatosJcombox.addElement(rs.getString("nombre"));
			}
			rs.close();
			Consulta.close();

		} catch (SQLException e) {
			System.err.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("errcs"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;

	}

	/**
	 * 
	 * Realiza una consulta paginada a la tabla {@code Citas} y carga los resultados
	 * en el {@code DefaultTableModel} proporcionado.
	 * <p>
	 * La consulta incluye los campos:
	 * </p>
	 * <ul>
	 * <li>ID de la cita</li>
	 * <li>Nombre completo del paciente (nombre + app + apm)</li>
	 * <li>Nombre completo del médico</li>
	 * <li>Fecha de la cita</li>
	 * <li>Motivo</li>
	 * <li>Servicio asociado</li>
	 * <li>Consultorio</li>
	 * <li>Comentario adicional</li>
	 * </ul>
	 * <p>
	 * Los datos se obtienen mediante una consulta SQL con paginación usando las
	 * cláusulas {@code OFFSET} y {@code FETCH NEXT}, según el número de página y la
	 * cantidad de registros por página solicitados.
	 * </p>
	 *
	 * @param model              El {@code DefaultTableModel} donde se cargarán los
	 *                           datos obtenidos.
	 * @param paginaActual       El número de la página actual (comienza desde 1).
	 * @param registrosPorPagina La cantidad de registros que se mostrarán por cada
	 *                           página.
	 * @exception SQLException Presenta los errores en base de datos.
	 */
	public void buscarUsuariosConTableModel(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;// Variable PreparedStatement
		// Se genear una variables que optiene la conexi�n ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = "SELECT c.idCita, " + "CONCAT(p.nombre, ' ', p.app, ' ', p.apm) AS nombrePaciente, "
				+ "CONCAT(m.nombre, ' ', m.app, ' ', m.apm) AS nombreMedico, "
				+ "c.fecha, c.motivo, s.nombre AS nombreServicio, " + "c.consultorio, c.comentarioA " + "FROM Citas c "
				+ "JOIN Pacientes p ON c.idPaciente = p.idPaciente " + "JOIN Medicos m ON c.idMedico = m.idMedico "
				+ "JOIN Servicios s ON c.idServicio = s.idServicio "
				+ "ORDER BY c.idCita OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[8];
				for (int i = 0; i < 8; i++)
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
	 * Obtiene el número total de registros existentes en la tabla {@code Citas}.
	 * <p>
	 * Este método es útil para calcular el número total de páginas al implementar
	 * una paginación en una tabla de interfaz gráfica, como {@code JTable}.
	 * </p>
	 *
	 * @return Un número entero que representa la cantidad total de registros en
	 *         {@code Citas}.
	 * @exception SQLException Muestra errores de base de datos.
	 */
	public static double contarRegistros() {
		// TODO Auto-generated method stub
		try {
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Citas");
			if (rs.next())
				totalRegistros = rs.getInt(1);
			rs.close();
			st.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return totalRegistros;
	}

	public static void reporteservisddisp() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/servicios.jrxml";
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
		}
	}

	public static void reportebase() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/citasbase.jrxml";
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
		}

	}

	public static void reportecitaxdia(Date dia) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/citaspenxdia.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			Map<String, Object> parametros = new HashMap<String, Object>();
			java.sql.Date fechaLimite = new java.sql.Date(dia.getTime());
			parametros.put("Fecha", fechaLimite);

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

	public static void repnoatendidasxmes() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/citasnoatendidas.jrxml";
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
		}

	}

	public void buscarUsuariosConTableModelo(DefaultTableModel model, int paginaActual, int registrosPorPagina) {

		PreparedStatement pst = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "SELECT idServicio, nombre, descripcion " + "FROM Servicios " + "ORDER BY idServicio "
				+ "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {
			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[3];
				for (int i = 0; i < 3; i++)
					fila[i] = rs.getObject(i + 1);
				model.addRow(fila);
			}
			rs.close();
			pst.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	public void modificarser(int idServicio, MServicios ser, DefaultTableModel model, int seleccion) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlUpdate = "UPDATE Servicios SET nombre = ?, descripcion = ? WHERE idServicio = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlUpdate);
			sentencia.setString(1, ser.getNombre());
			sentencia.setString(2, ser.getDescripcion());
			sentencia.setInt(3, idServicio);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Actualizar también la tabla en la interfaz
				model.setValueAt(ser.getNombre(), seleccion, 1);
				model.setValueAt(ser.getDescripcion(), seleccion, 2);

				JOptionPane.showMessageDialog(null, et.getString("ModI"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emS"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLS") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emS"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Elimina un servicio de la base de datos por su ID.
	 * 
	 * @param idReligion Identificador del servicio a eliminar.
	 * @param model      Modelo de tabla que muestra los servicios.
	 * @param indicereg  Índice de la fila que se eliminará si la operación es
	 *                   exitosa.
	 */

	public void eliminarSer(int idSer, DefaultTableModel model, int seleccion) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		PreparedStatement stmtsub = null;
		String sqlDelete = "DELETE FROM Servicios WHERE idServicio = ?";

		try {

			// Luego eliminar las citas asociadas al médico
			stmtsub = Conexion.prepareStatement(sqlDelete);
			stmtsub.setInt(1, idSer);
			stmtsub.executeUpdate();
			int filasAfectadas = stmtsub.executeUpdate();
			if (filasAfectadas > 0) {
				model.removeRow(seleccion);
				JOptionPane.showMessageDialog(null, et.getString("ccr"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eec"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLSE") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eec"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

}
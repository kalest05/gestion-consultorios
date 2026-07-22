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
import modelos.MDepartamentos;
import modelos.MEspecialidades;
import modelos.MMedicos;
import modelos.MPaciente;
import modelos.MServicios;
import modelos.MSubespecialides;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

/**
 * El controlador gestiona las operaciones relacionadas con los medicos en la
 * base de datos del sistema.
 * <p>
 * Esta clase administra una lista de medcos. Permite agregar, modificar,
 * mostrar y eliminar los datos de los medicos. Esta clase almacena objetos de
 * tipo @link MMedicos Utiliza conexión a SQL Server para hacer todos los
 * procesos.
 * </p>
 * 
 * @see vistas.Medicos
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 * 
 */
public class Cmedicos {

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

	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);

	/**
	 * Agrega un nuevo medico en la base de datos. Este metodo toma los datos
	 * almacenados en un objeto {@link MMedicos} y los inserta en la tabla
	 * {@code vistas.Medicos} mediante una secuencia SQL.
	 * <p>
	 * Si la inserción es exitosa notifica al usuario mediante un mensaje. En el
	 * caso contrario, se notifica un error.
	 * </p>
	 * 
	 * @pram nuevoMedico Objeto que contiene todos los datos sobre el medico a
	 *       registrar.
	 * @throws SQLException Si ocurre un error al insertar los datos en SQL.
	 * @see ConexionBSSQLServer
	 * 
	 */
	public static void AnMed(MMedicos nuevoMedico) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Medicos (nombre, app, apm, idEspecialidad, idDepartamento, idSubespecialidad, "
				+ "correo, cedulaProf, fecNac, telefono, curp, rfc, numCasa, nomCalle, localidad, municipio) "
				+ "VALUES (?, ?, ?, " + "(SELECT idEspecialidad FROM Especialidades WHERE nombre = ?), "
				+ "(SELECT idDepartamento FROM Departamentos WHERE nombre = ?), "
				+ "(SELECT idSubespecialidad FROM Subespecialides WHERE nombre = ?), "
				+ "?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, nuevoMedico.getNombre());
			sentencia.setString(2, nuevoMedico.getApellidoP());
			sentencia.setString(3, nuevoMedico.getApellidoM());
			sentencia.setString(4, nuevoMedico.getEsp());
			sentencia.setString(5, nuevoMedico.getDep());
			sentencia.setString(6, nuevoMedico.getSub());
			sentencia.setString(7, nuevoMedico.getCorreo());
			sentencia.setString(8, nuevoMedico.getCedula());

			java.sql.Date sqlDate = new java.sql.Date(nuevoMedico.getFechaNac().getTime());
			sentencia.setDate(9, sqlDate);

			sentencia.setString(10, nuevoMedico.getTelefono());
			sentencia.setString(11, nuevoMedico.getCURP());
			sentencia.setString(12, nuevoMedico.getRFC());
			sentencia.setInt(13, nuevoMedico.getNumCasa());
			sentencia.setString(14, nuevoMedico.getNomCalle());
			sentencia.setString(15, nuevoMedico.getLoc());
			sentencia.setString(16, nuevoMedico.getMun());

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
			System.err.println(et.getString("SQL") + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("emed"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * 
	 * Este metodo realiza la consulta a la base de datos para obtener los regustros
	 * de la tabla {@link vistas.Medicos} y los carga en un DefaultTableModel.
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

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		try {
			// Sql a ejecutar
			String sqlmostrar = "SELECT m.idMedico, m.nombre, m.app, m.apm, "
					+ "e.nombre AS especialidad, d.nombre AS departamento, "
					+ "c.nombre AS certificacion, m.correo, m.horasTrabajo, " + "m.fecNac, m.telefono "
					+ "FROM Medicos m " + "JOIN Especialidades e ON m.idEspecialidad = e.idEspecialidad "
					+ "JOIN Departamentos d ON m.idDepartamento = d.idDepartamento "
					+ "JOIN Certificaciones c ON m.idCertificacion = c.idCertificacion";

			Statement estatuto = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = estatuto.executeQuery(sqlmostrar);

			while (rs.next()) {
				// es para obtener los datos y almacenar las filas
				Object[] fila = new Object[11];
				// para llenar cada columna con lo datos almacenados
				for (int i = 0; i < 11; i++)
					fila[i] = rs.getObject(i + 1);
				// es para cargar los datos en filas a la tabla modelo
				model.addRow(fila);

			}
			rs.close();
			estatuto.close();

		} catch (SQLException e) {
			System.out.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("ec"), "Error", JOptionPane.ERROR_MESSAGE);

		}

	}

	/**
	 * Elimina un medico y todas las citas asociadas a este en la base de datos.
	 * <p>
	 * Este metodo realiza múltiples operaciones de manera ordenada con el fin de
	 * mantener la integridad referencial en la base de datos. Tambien actualiza la
	 * vista en la interfaz eliminando la fila correspondiente.
	 * </p>
	 * 
	 * @param id        ID del medico que se desea eliminar.
	 * @param model     Modelo de tabla de la vista que contiene los datos del
	 *                  medico.
	 * @param indicereg Indice de la fila correspondiente al medico en la tabla, que
	 *                  debe ser eliminada de la base de datos.
	 * @throws SQLException Si ocurre un error durante la ejecución de alguna de las
	 *                      sentencias SQL.
	 * 
	 * 
	 */
	public void eliminarmedico(int id, DefaultTableModel model, int indicereg) {
		PreparedStatement stmtMedico = null;
		PreparedStatement stmtCitas = null;

		Conexion = ConexionBDSQLServer.GetConexion();
		String sqlCitas = "DELETE FROM Citas WHERE idMedico = ?"; // Eliminar las citas asociadas
		String sqlMedico = "DELETE FROM Medicos WHERE idMedico = ?"; // Luego eliminar el médico

		try {

			// Luego eliminar las citas asociadas al médico
			stmtCitas = Conexion.prepareStatement(sqlCitas);
			stmtCitas.setInt(1, id);
			stmtCitas.executeUpdate();

			// Ahora eliminar el Médico
			stmtMedico = Conexion.prepareStatement(sqlMedico);
			stmtMedico.setInt(1, id);
			int filasAfectadas = stmtMedico.executeUpdate();

			if (filasAfectadas > 0) {
				model.removeRow(indicereg);
				JOptionPane.showMessageDialog(null, et.getString("mrec"), "Éxito", JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eeem"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLME") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eeem"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Este método modifica los datos de los medicos existentes en la base de datos
	 * y actualiza los datos de la fila correspondiente en el modelo de la tabla.
	 * 
	 * <p>
	 * El medico es identificado por su id, y sus datos son reemplazados por los
	 * valores obtenidos del objeto {@link MPaciente} proporcionado.
	 * </p>
	 * 
	 * @param id               ID unico del medico a modificar.
	 * @param medicoModificado Objeto que contiene los datos del medico.
	 * @param model            Modelo de tabla donde se refleja visualmente la
	 *                         modificación.
	 * @param indicereg        Indice de la fila en el modelo de la tabla que
	 *                         corresponde al medico.
	 * @throws SQLException Si ocurre un error durante la modificación.
	 * @see modelos.MMedicos
	 * 
	 */
	public void modificarMed(int id, MMedicos medicoModificado, DefaultTableModel model, int indicereg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		sql = ("UPDATE Medicos SET nombre = ?, app = ?, apm = ?, "
				+ "idEspecialidad = (SELECT idEspecialidad FROM Especialidades WHERE nombre = ?), "
				+ "idDepartamento = (SELECT idDepartamento FROM Departamentos WHERE nombre = ?), "
				+ "idSubespecialidad = (SELECT idSubespecialidad FROM Subespecialides WHERE nombre = ?), "
				+ "correo = ?, cedulaProf = ?, fecNac = ?, telefono = ?, curp = ?, rfc = ?, "
				+ "numCasa = ?, nomCalle = ?, localidad = ?, municipio = ? " + "WHERE idMedico = ?");
		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, medicoModificado.getNombre());
			sentencia.setString(2, medicoModificado.getApellidoP());
			sentencia.setString(3, medicoModificado.getApellidoM());
			sentencia.setString(4, medicoModificado.getEsp());
			sentencia.setString(5, medicoModificado.getDep());
			sentencia.setString(6, medicoModificado.getSub());
			sentencia.setString(7, medicoModificado.getCorreo());
			sentencia.setString(8, medicoModificado.getCedula());

			java.sql.Date sqlDate = new java.sql.Date(medicoModificado.getFechaNac().getTime());
			sentencia.setDate(9, sqlDate);

			sentencia.setString(10, medicoModificado.getTelefono());
			sentencia.setString(11, medicoModificado.getCURP());
			sentencia.setString(12, medicoModificado.getRFC());
			sentencia.setInt(13, medicoModificado.getNumCasa());
			sentencia.setString(14, medicoModificado.getNomCalle());
			sentencia.setString(15, medicoModificado.getLoc());
			sentencia.setString(16, medicoModificado.getMun());
			sentencia.setInt(17, id);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				model.setValueAt(medicoModificado.getNombre(), indicereg, 1);
				model.setValueAt(medicoModificado.getApellidoP(), indicereg, 2);
				model.setValueAt(medicoModificado.getApellidoM(), indicereg, 3);
				model.setValueAt(medicoModificado.getEsp(), indicereg, 4);
				model.setValueAt(medicoModificado.getDep(), indicereg, 5);
				model.setValueAt(medicoModificado.getSub(), indicereg, 6);
				model.setValueAt(medicoModificado.getCorreo(), indicereg, 7);
				model.setValueAt(medicoModificado.getCedula(), indicereg, 8);
				model.setValueAt(medicoModificado.getFechaNac(), indicereg, 9);
				model.setValueAt(medicoModificado.getTelefono(), indicereg, 10);
				model.setValueAt(medicoModificado.getCURP(), indicereg, 11);
				model.setValueAt(medicoModificado.getRFC(), indicereg, 12);
				model.setValueAt(medicoModificado.getNumCasa(), indicereg, 13);
				model.setValueAt(medicoModificado.getNomCalle(), indicereg, 14);
				model.setValueAt(medicoModificado.getLoc(), indicereg, 15);
				model.setValueAt(medicoModificado.getMun(), indicereg, 16);

				JOptionPane.showMessageDialog(null, et.getString("memc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eemm"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMME") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eemm"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Carga una lista paginada de médicos desde la base de datos en el
	 * {@code DefaultTableModel} proporcionado.
	 *
	 * <p>
	 * Este método realiza una consulta a la base de datos que recupera información
	 * detallada de médicos, incluyendo sus datos personales, especialidad,
	 * subespecialidad, departamento, contacto y dirección.
	 * </p>
	 * <p>
	 * Los resultados se insertan en el modelo de tabla de forma paginada,
	 * utilizando {@code OFFSET} y {@code FETCH NEXT} para obtener únicamente los
	 * registros correspondientes a la página actual.
	 * </p>
	 *
	 * @param model              El {@code DefaultTableModel} donde se cargarán los
	 *                           resultados.
	 * @param paginaActual       El número de página actual (comienza en 1).
	 * @param registrosPorPagina La cantidad de registros a mostrar por página.
	 * @exception SQLException Si ocurre un error de SQL
	 */
	public void buscarUsuariosConTableModel(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;// Variable PreparedStatement
		// Se genear una variables que optiene la conexi�n ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = "SELECT m.idMedico, m.nombre, m.app, m.apm, " + "e.nombre, d.nombre, s.nombre, "
				+ "m.correo, m.cedulaProf, m.fecNac, m.telefono, m.curp, m.rfc, "
				+ "m.numCasa, m.nomCalle, m.localidad, m.municipio " + "FROM Medicos m "
				+ "LEFT JOIN Especialidades e ON m.idEspecialidad = e.idEspecialidad "
				+ "LEFT JOIN Departamentos d ON m.idDepartamento = d.idDepartamento "
				+ "LEFT JOIN Subespecialides s ON m.idSubespecialidad = s.idSubespecialidad "
				+ "ORDER BY m.idMedico OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[17];
				for (int i = 0; i < 17; i++)
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
	 * Cuenta el número total de registros en la tabla {@code Medicos}.
	 *
	 * <p>
	 * Este método realiza una consulta SQL para contar todos los registros
	 * existentes en la tabla {@code Medicos} de la base de datos. El valor obtenido
	 * se guarda en la variable {@code totalRegistros} y se retorna como resultado.
	 * </p>
	 *
	 * <p>
	 * Este método es útil para implementar paginación u obtener estadísticas del
	 * sistema.
	 * </p>
	 * 
	 * @exception SQLException Si ocurre un error de SQL
	 * @return El número total de registros encontrados en la tabla {@code Medicos}.
	 */
	public static double contarRegistros() {
		// TODO Auto-generated method stub
		try {
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Medicos");
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
	 * Inserta un nuevo departamento en la tabla {@code Departamentos} de la base de
	 * datos.
	 *
	 * <p>
	 * Este método utiliza un objeto {@link MDepartamentos} para obtener la
	 * información necesaria del nuevo departamento: nombre, número de empleados y
	 * número de extensión telefónica. Luego ejecuta una sentencia SQL de tipo
	 * {@code INSERT} para almacenar los datos en la base de datos.
	 * </p>
	 *
	 * <p>
	 * Si la operación se ejecuta correctamente, se muestra un mensaje de
	 * confirmación al usuario. En caso contrario, se muestra un mensaje de error.
	 * </p>
	 * 
	 * @throws SQLException Si ocurre un error de SQL
	 * @param ndep Objeto de tipo {@link MDepartamentos} que contiene los datos del
	 *             nuevo departamento.
	 */
	public static void anadirDepartamento(MDepartamentos ndep) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Departamentos (nombre, numEmpleados, telExt )" + " VALUES (?, ?, ?)");

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, ndep.getNombre());
			sentencia.setInt(2, ndep.getEmpleados());
			sentencia.setString(3, ndep.getTelExt());

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
			System.err.println(et.getString("SQL") + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("ead"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Inserta un nuevo servicio en la tabla {@code Servicios} de la base de datos.
	 *
	 * <p>
	 * Este método toma un objeto {@link MServicios} que contiene el nombre y la
	 * descripción del servicio, y ejecuta una sentencia {@code INSERT} para
	 * almacenar los datos.
	 * </p>
	 *
	 * <p>
	 * Si la inserción es exitosa, se muestra un mensaje informativo al usuario. En
	 * caso de error, se notifica mediante una ventana de diálogo.
	 * </p>
	 *
	 * @param ndep Objeto de tipo {@link MServicios} que contiene los datos del
	 *             nuevo servicio.
	 * @throws SQLException si ocurre un error de SQL
	 */
	public static void anadirServicios(MServicios ndep) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "INSERT INTO Servicios (nombre, descripcion)" + " VALUES (?, ?)";

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, ndep.getNombre());
			sentencia.setString(2, ndep.getDescripcion());

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
			System.err.println(et.getString("SQL") + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("eas"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Inserta una nueva especialidad médica en la base de datos.
	 *
	 * <p>
	 * Este método recibe un objeto {@link MEspecialidades} que contiene el nombre y
	 * la descripción de la especialidad, y realiza una inserción en la tabla
	 * {@code Especialidades}.
	 * </p>
	 *
	 * <p>
	 * Si la inserción es exitosa, muestra un mensaje de confirmación. En caso
	 * contrario, muestra un mensaje de error.
	 * </p>
	 *
	 * @param ndep Objeto {@link MEspecialidades} con los datos de la nueva
	 *             especialidad a insertar.
	 * @exception SQLException Si ocurre un error de SQL.
	 */
	public static void nuevaesp(MEspecialidades ndep) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "INSERT INTO Especialidades (nombre, descripcion)" + " VALUES (?, ?)";

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, ndep.getNombre());
			sentencia.setString(2, ndep.getDescripcion());

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
			System.err.println(et.getString("SQL") + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("eae"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Añade una nueva subespecialidad médica en la base de datos.
	 *
	 * <p>
	 * Este método recibe un objeto {@link MSubespecialides} que contiene el nombre,
	 * descripción y el nombre de la especialidad a la que pertenece la
	 * subespecialidad. Realiza una inserción en la tabla {@code Subespecialides},
	 * vinculando la subespecialidad con la especialidad correspondiente mediante
	 * una subconsulta.
	 * </p>
	 *
	 * <p>
	 * Si la inserción es exitosa, se muestra un mensaje de confirmación. Si no, se
	 * muestra un mensaje de error.
	 * </p>
	 *
	 * @param ndep Objeto {@link MSubespecialides} con los datos de la nueva
	 *             subespecialidad a insertar.
	 */
	public static void anadirSubespecialidades(MSubespecialides ndep) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "INSERT INTO Subespecialides (nombre, descripcion, idEspecialidad)"
				+ " VALUES (?,?,(SELECT idEspecialidad FROM Especialidades where nombre = ?))";

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, ndep.getNombre());
			sentencia.setString(2, ndep.getDescripcion());
			sentencia.setString(3, ndep.getIdEspecialidad());

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
			System.err.println(et.getString("SQL") + e.getMessage());
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("easb"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Llena un modelo de JComboBox con los nombres de las especialidades
	 * disponibles en la base de datos.
	 *
	 * <p>
	 * Este método consulta la tabla {@code Especialidades} para obtener todos los
	 * nombres registrados, y los agrega a un objeto {@link DefaultComboBoxModel}
	 * para ser utilizado en componentes JComboBox. Además, agrega un primer
	 * elemento "Seleccione..." para indicar una opción por defecto.
	 * </p>
	 * 
	 * @throws SQLException Si ocurre un error de SQL
	 * @return Un {@link DefaultComboBoxModel} con los nombres de las especialidades
	 */

	public static DefaultComboBoxModel<String> llenarSubespecialid() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Especialidades");

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
			JOptionPane.showMessageDialog(null, et.getString("ece"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Obtiene un modelo para JComboBox con los nombres de las especialidades
	 * registradas en la base de datos.
	 *
	 * <p>
	 * Este método realiza una consulta a la tabla {@code Especialidades} para
	 * obtener todos los nombres disponibles, los cuales se agregan a un
	 * {@link DefaultComboBoxModel} que puede ser usado para poblar un JComboBox en
	 * la interfaz gráfica.
	 * </p>
	 *
	 * <p>
	 * Se incluye un elemento inicial "Seleccione..." para representar una opción
	 * por defecto sin selección.
	 * </p>
	 *
	 * @throws SQLException Si ocurre un error de SQL
	 * @return Un {@link DefaultComboBoxModel<String>} con los nombres de las
	 *         especialidades, o {@code null} si ocurre un error durante la
	 *         consulta.
	 */

	public static DefaultComboBoxModel<String> llenarEspe() {

		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Especialidades");

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
			JOptionPane.showMessageDialog(null, et.getString("ece"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Obtiene un modelo para JComboBox con los nombres de los departamentos
	 * registrados en la base de datos.
	 *
	 * <p>
	 * Este método consulta la tabla {@code Departamentos} para recuperar todos los
	 * nombres disponibles, los cuales se agregan a un {@link DefaultComboBoxModel}
	 * que puede ser usado para poblar un JComboBox.
	 * </p>
	 *
	 * <p>
	 * Se incluye un elemento inicial "Seleccione..." para representar una opción
	 * por defecto sin selección.
	 * </p>
	 *
	 * @return Un {@link DefaultComboBoxModel<String>} con los nombres de los
	 *         departamentos
	 */
	public static DefaultComboBoxModel<String> llenarDepto() {
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Departamentos");

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
			JOptionPane.showMessageDialog(null, et.getString("ecd"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Obtiene un modelo para JComboBox con los nombres de las subespecialidades
	 * registradas en la base de datos.
	 *
	 * <p>
	 * Este método consulta la tabla {@code Subespecialides} para recuperar todos
	 * los nombres disponibles, los cuales se agregan a un
	 * {@link DefaultComboBoxModel} que puede ser usado para poblar un JComboBox.
	 * </p>
	 *
	 * <p>
	 * Se incluye un elemento inicial "Seleccione..." para representar una opción
	 * por defecto sin selección.
	 * </p>
	 * 
	 * @throws SQLException Si hay un error de SQL
	 * @return Un {@link DefaultComboBoxModel<String>} con los nombres de las
	 *         subespecialidades
	 */
	public static DefaultComboBoxModel<String> llenarSubespe() {
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Subespecialides");

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
			JOptionPane.showMessageDialog(null, et.getString("ecs"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Obtiene un modelo para JComboBox con los nombres de municipios únicos
	 * registrados en la base de datos.
	 *
	 * <p>
	 * Este método consulta la tabla {@code Sinaloa} para recuperar todos los
	 * municipios distintos, ordenados alfabéticamente, que se agregan a un
	 * {@link DefaultComboBoxModel} para poblar un JComboBox.
	 * </p>
	 *
	 * <p>
	 * Se incluye un elemento inicial "Seleccione..." para representar una opción
	 * por defecto sin selección.
	 * </p>
	 * 
	 * @throws SQLException Si ocurre errores de SQL
	 * @return Un {@link DefaultComboBoxModel<String>} con los nombres de
	 *         municipios.
	 */
	public static DefaultComboBoxModel<String> llenarMun() {
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT DISTINCT D_mnpio FROM dbo.Sinaloa ORDER BY D_mnpio");

			// Se ingresa un dato blanco en el primer campo del Combox
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabal de Combox
				DatosJcombox.addElement(rs.getString("D_mnpio"));
			}
			rs.close();
			Consulta.close();

		} catch (SQLException e) {
			System.err.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emun"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Obtiene un modelo para JComboBox con las colonias (localidades)
	 * correspondientes a un municipio dado.
	 *
	 * <p>
	 * Este método realiza una consulta a la base de datos para obtener las colonias
	 * ({@code d_asenta}) que pertenecen al municipio especificado por el parámetro
	 * {@code poblacion}. Los resultados se agregan a un
	 * {@link DefaultComboBoxModel} que puede ser usado para poblar un JComboBox.
	 * </p>
	 *
	 * <p>
	 * Se incluye un elemento inicial "Seleccione..." para representar una opción
	 * por defecto sin selección.
	 * </p>
	 *
	 * @throws SQLException Si ocurre un error de SQL
	 * @param poblacion El nombre del municipio para filtrar las colonias.
	 * @return Un {@link DefaultComboBoxModel<String>} con los nombres de las
	 *         colonias
	 */
	public static DefaultComboBoxModel<String> llenarLoc(String poblacion) {
		System.out.println("llega con: " + poblacion);
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<>();

		String bus = "SELECT DISTINCT d_asenta FROM Sinaloa WHERE D_mnpio = ? ORDER BY d_asenta";

		try {
			PreparedStatement ps = ConexionBDSQLServer.GetConexion().prepareStatement(bus);
			ps.setString(1, poblacion);
			ResultSet rs = ps.executeQuery();

			DatosJcombox.addElement(et.getString("SEL"));

			while (rs.next()) {
				DatosJcombox.addElement(rs.getString("d_asenta"));
			}

			rs.close();
			ps.close();

		} catch (SQLException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("eccol") + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	public static void generarReporteConParametros(MMedicos dep) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/MedicosD.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			Map<String, Object> parametros = new HashMap<String, Object>();
			parametros.put("Departamento", dep.getDep());

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

	public static void generarReportebase() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/Medicoss.jrxml";
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

	public static void generarReporteConParametros2(MMedicos esp) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/MedicosEs.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			Map<String, Object> parametros = new HashMap<String, Object>();
			parametros.put("Especialidad", esp.getEsp());

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

	public static void reporteespecialidad() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/especialidades.jrxml";
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

	public static void reporteSubespecialidad() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/subespecialidad.jrxml";
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

	public static void reporteDepa() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/departamentos.jrxml";
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

		sql = "SELECT s.idSubespecialidad, s.nombre, s.descripcion, e.nombre AS especialidad "
				+ "FROM subespecialides s " + "JOIN especialidades e ON s.idEspecialidad = e.idEspecialidad "
				+ "ORDER BY idSubespecialidad " + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {
			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[4];
				for (int i = 0; i < 4; i++)
					fila[i] = rs.getObject(i + 1);
				model.addRow(fila);
			}
			rs.close();
			pst.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	public void buscarUsuariosConTableModelo1(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "SELECT idEspecialidad, nombre, descripcion " + "FROM Especialidades " + "ORDER BY idEspecialidad "
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

	public void buscarUsuariosConTableModelo12(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "SELECT idDepartamento, nombre, numEmpleados, telExt " + "FROM Departamentos "
				+ "ORDER BY idDepartamento " + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		try {
			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[4];
				for (int i = 0; i < 4; i++)
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
	 * Modifica los datos de un Subespecialidad existente en la base de datos.
	 * 
	 * @param idSubespecialidad         Identificador de la Subespecialidad a
	 *                                  modificar.
	 * @param SubespecialidadModificado Objeto {@code MSubespecialides} con los
	 *                                  nuevos datos.
	 * @param model                     Modelo de tabla que muestra las
	 *                                  Subespecialidades.
	 * @param indicereg                 Índice de la fila que se modificará en el
	 *                                  modelo.
	 */

	public void modificarsub(int idSubespecialidad, MSubespecialides sub, DefaultTableModel model, int seleccion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlUpdate = "UPDATE Subespecialides SET nombre = ?, descripcion = ?, idEspecialidad = (SELECT idEspecialidad FROM Especialidades where nombre = ?) WHERE idSubespecialidad = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlUpdate);
			sentencia.setString(1, sub.getNombre());
			sentencia.setString(2, sub.getDescripcion());
			sentencia.setString(3, sub.getIdEspecialidad());
			sentencia.setInt(4, idSubespecialidad);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Actualizar también la tabla en la interfaz
				model.setValueAt(sub.getNombre(), seleccion, 1);
				model.setValueAt(sub.getDescripcion(), seleccion, 2);
				model.setValueAt(sub.getIdEspecialidad(), seleccion, 3);

				JOptionPane.showMessageDialog(null, et.getString("ModI"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emSE"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMS") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emSE"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Elimina una Subespecialidad de la base de datos por su ID.
	 * 
	 * @param idSubespecialidad Identificador del Subespecialidad a eliminar.
	 * @param model             Modelo de tabla que muestra las Subespecialidades.
	 * @param indicereg         Índice de la fila que se eliminará si la operación
	 *                          es exitosa.
	 */

	public void eliminarSub(int idSub, DefaultTableModel model, int seleccion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		PreparedStatement stmtsub = null;
		String sqlDelete = "DELETE FROM Subespecialides WHERE idSubespecialidad = ?";

		try {

			// Luego eliminar las citas asociadas al médico
			stmtsub = Conexion.prepareStatement(sqlDelete);
			stmtsub.setInt(1, idSub);
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
			System.err.println(et.getString("SQLEMS") + e.getMessage());

			JOptionPane.showMessageDialog(null, et.getString("eec"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Modifica los datos de una Especialidad existente en la base de datos.
	 * 
	 * @param idEspecialidad         Identificador de la Especialidad a modificar.
	 * @param EspecialidadModificado Objeto {@code MEspecialidades} con los nuevos
	 *                               datos.
	 * @param model                  Modelo de tabla que muestra las Especialidades.
	 * @param indicereg              Índice de la fila que se modificará en el
	 *                               modelo.
	 */

	public void modificarespe(int idEsp, MEspecialidades esp, DefaultTableModel model, int seleccion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlUpdate = "UPDATE Especialidades SET nombre = ?, descripcion = ? WHERE idEspecialidad = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlUpdate);
			sentencia.setString(1, esp.getNombre());
			sentencia.setString(2, esp.getDescripcion());
			sentencia.setInt(3, idEsp);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Actualizar también la tabla en la interfaz
				model.setValueAt(esp.getNombre(), seleccion, 1);
				model.setValueAt(esp.getDescripcion(), seleccion, 2);

				JOptionPane.showMessageDialog(null, et.getString("Emc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emE"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMESP") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emE"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Elimina una Especialidad de la base de datos por su ID.
	 * 
	 * @param idEspecialidad Identificador de la Especialidad a eliminar.
	 * @param model          Modelo de tabla que muestra las Especialidades.
	 * @param indicereg      Índice de la fila que se eliminará si la operación es
	 *                       exitosa.
	 */

	public void eliminarESP(int idESP, DefaultTableModel model, int seleccion) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlDelete = "DELETE FROM Especialidades WHERE idEspecialidad = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlDelete);
			sentencia.setInt(1, idESP);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Quitar la fila del JTable
				model.removeRow(seleccion);
				JOptionPane.showMessageDialog(null, et.getString("EEC"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("EEE"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLEMESP") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("EEE"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Modifica los datos de un Departamento existente en la base de datos.
	 * 
	 * @param idDepartamento         Identificador del Departamento a modificar.
	 * @param DepartamentoModificado Objeto {@code MDepartamentos} con los nuevos
	 *                               datos.
	 * @param model                  Modelo de tabla que muestra los Departamentos.
	 * @param indicereg              Índice de la fila que se modificará en el
	 *                               modelo.
	 */
	public void modificarser(int idDep, MDepartamentos ser, DefaultTableModel model, int seleccion) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlUpdate = "UPDATE Departamentos SET nombre = ?,telExt = ?, numEmpleados = ? WHERE idDepartamento = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlUpdate);
			sentencia.setString(1, ser.getNombre());
			sentencia.setString(2, ser.getTelExt());
			sentencia.setInt(3, ser.getEmpleados());
			sentencia.setInt(4, idDep);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Actualizar también la tabla en la interfaz
				model.setValueAt(ser.getNombre(), seleccion, 1);
				model.setValueAt(ser.getTelExt(), seleccion, 2);
				model.setValueAt(ser.getEmpleados(), seleccion, 3);

				JOptionPane.showMessageDialog(null, et.getString("Dmc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emD"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMD") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emD"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Elimina un Departamento de la base de datos por su ID.
	 * 
	 * @param idDepartamento Identificador del Departamento a eliminar.
	 * @param model          Modelo de tabla que muestra los Departamentos.
	 * @param indicereg      Índice de la fila que se eliminará si la operación es
	 *                       exitosa.
	 */
	public void eliminarDep(int idDep, DefaultTableModel model, int seleccion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlDelete = "DELETE FROM Departamentos WHERE idDepartamento = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlDelete);
			sentencia.setInt(1, idDep);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Quitar la fila del JTable
				model.removeRow(seleccion);
				JOptionPane.showMessageDialog(null, et.getString("DEC"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("EED"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLED") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("EED"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

}
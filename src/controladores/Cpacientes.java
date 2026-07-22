package controladores;

import java.sql.Connection;
import java.sql.Date;
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
import modelos.MPaciente;
import modelos.MReligion;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

/**
 * El controlador gestiona las operaciones relacionadas con los pacientes en la
 * base de datos del sistema.
 * <p>
 * Esta clase administra una lista de pacientes. Permite agregar, modificar,
 * mostrar y eliminar los datos de los medicos. Esta clase almacena objetos de
 * tipo @link MPacientes Utiliza conexión a SQL Server para hacer todos los
 * procesos.
 * </p>
 * 
 * @see vistas.Pacientes
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 * 
 */

public class Cpacientes {
	public static Connection Conexion = null;
	public static String sql;
	public static ResultSet ResultSet = null;
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
	 * Inserta un nuevo paciente en la base de datos.
	 * 
	 * <p>
	 * Este método utiliza un objeto {@code MPaciente} para obtener los datos del
	 * paciente y realiza una inserción en la tabla {@code Pacientes}. El campo
	 * {@code idReligion} se obtiene mediante una subconsulta que busca el nombre de
	 * la religión en la tabla {@code Religiones}.
	 * </p>
	 * <p>
	 * Si la inserción es exitosa, se muestra un mensaje de confirmación. En caso de
	 * error, se muestra un mensaje de <b>ERROR</b>.
	 * </p>
	 * 
	 * @exception SQLException Errores surgidos en la base de datos.
	 * @param nuevoPaciente Objeto de tipo {@code MPaciente} que contiene la
	 *                      información a insertar.
	 */
	public static void AnPac(MPaciente nuevoPaciente) {
		// Validación de los datos del cliente no estén vacíos

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Pacientes (nombre, app, apm, fecNac, edad, curp, genero, alergias, tipoSangre, "
				+ "municipio, localidad, numCasa, nomCalle, idReligion, telefono) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, (SELECT idReligion FROM Religiones WHERE nombre= ?), ?)");

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, nuevoPaciente.getNombre());
			sentencia.setString(2, nuevoPaciente.getApellidoP());
			sentencia.setString(3, nuevoPaciente.getApellidoM());
			sentencia.setDate(4, new java.sql.Date(nuevoPaciente.getFechaNac().getTime()));
			sentencia.setInt(5, nuevoPaciente.getEdad());
			sentencia.setString(6, nuevoPaciente.getCurp());
			sentencia.setString(7, nuevoPaciente.getGenero());
			sentencia.setString(8, nuevoPaciente.getAlergia());
			sentencia.setString(9, nuevoPaciente.getSangre());
			sentencia.setString(10, nuevoPaciente.getMunicipio());
			sentencia.setString(11, nuevoPaciente.getLocalidad());
			sentencia.setInt(12, Integer.parseInt(nuevoPaciente.getNext()));
			sentencia.setString(13, nuevoPaciente.getNumCalle());
			sentencia.setString(14, nuevoPaciente.getReligion());
			sentencia.setString(15, nuevoPaciente.getTelefono());

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
			JOptionPane.showMessageDialog(null, et.getString("eap"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Elimina un paciente de la base de datos según su identificador.
	 * <p>
	 * Este método elimina el paciente donde <b>{@code idPaciente}</b> coincida con
	 * el valor proporcionado. Si la eliminación es exitosa, también remueve la fila
	 * correspondiente del {@code DefaultTableModel} usado en la interfaz gráfica.
	 * </p>
	 * 
	 * @param id        Corresponde al identidicador del paciente que se desea
	 *                  eliminar.
	 * @param model     Es el modelo de la tabla que contiene la lista de pacientes.
	 * @param indicereg El índice de la fila que se eliminará del modelo si la
	 *                  operación fue exitosa.
	 * @exception SQLException Errores surgidos en la base de datos.
	 */
	public void eliminarPaciente(int id, DefaultTableModel model, int indicereg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		String eliminarRecetaMedicamentos = "DELETE FROM RECETAMEDICAMENTOS WHERE idReceta IN ("
				+ "SELECT idReceta FROM Recetas WHERE idConsulta IN ("
				+ "SELECT idConsulta FROM Consultas WHERE idCita IN ("
				+ "SELECT idCita FROM Citas WHERE idPaciente = ?)))";

		String eliminarRecetas = "DELETE FROM Recetas WHERE idConsulta IN ("
				+ "SELECT idConsulta FROM Consultas WHERE idCita IN ("
				+ "SELECT idCita FROM Citas WHERE idPaciente = ?))";

		String eliminarConsultas = "DELETE FROM Consultas WHERE idCita IN ("
				+ "SELECT idCita FROM Citas WHERE idPaciente = ?)";

		String eliminarCitas = "DELETE FROM Citas WHERE idPaciente = ?";

		String eliminarPaciente = "DELETE FROM Pacientes WHERE idPaciente = ?";

		try {
			// 1. Eliminar RECETAMEDICAMENTOS
			sentencia = Conexion.prepareStatement(eliminarRecetaMedicamentos);
			sentencia.setInt(1, id);
			sentencia.executeUpdate();

			// 2. Eliminar Recetas
			sentencia = Conexion.prepareStatement(eliminarRecetas);
			sentencia.setInt(1, id);
			sentencia.executeUpdate();

			// 3. Eliminar Consultas
			sentencia = Conexion.prepareStatement(eliminarConsultas);
			sentencia.setInt(1, id);
			sentencia.executeUpdate();

			// 4. Eliminar Citas
			sentencia = Conexion.prepareStatement(eliminarCitas);
			sentencia.setInt(1, id);
			sentencia.executeUpdate();

			// 5. Eliminar Paciente
			sentencia = Conexion.prepareStatement(eliminarPaciente);
			sentencia.setInt(1, id);
			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Eliminar la fila del modelo de la tabla
				model.removeRow(indicereg);
				JOptionPane.showMessageDialog(null, et.getString("pre"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eep"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLEP") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eep"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	public void buscarUsuariosConTableModel(DefaultTableModel model) {

		try {
			Statement estatuto = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = estatuto.executeQuery("SELECT * FROM Pacientes");

			while (rs.next()) {
				// es para obtener los datos y almacenar las filas
				Object[] fila = new Object[13];
				// para llenar cada columna con lo datos almacenados
				for (int i = 0; i < 13; i++)
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
	 * Modifica la información de un paciente existente en la base de datos.
	 * <p>
	 * Este método actualiza todos los campos del paciente identificado por su ID en
	 * la tabla <b>{@code Pacientes}</b>. También actualiza la fila correspondiente
	 * en el modelo de la tabla de la interfaz gráfica.
	 * </p>
	 * <p>
	 * La columna {@code idReligion} se actualiza a través de una subconsulta que
	 * obtiene el identificador según el nombre de la religión proporcionado.
	 * </p>
	 * 
	 * @param id                 El identificador del paciente a modificar.
	 * @param pacienteModificado Es Objeto {@code MPaciente} que contiene los nuevos
	 *                           datos del paciente.
	 * @param model              Modelo de tabla ({@code DefaultTableModel}) donde
	 *                           se mostrará la información.
	 * @param indicereg          Índice de la fila en el modelo que será actualizada
	 *                           si la operación tiene éxito.
	 * @exception SQLException Errores surgidos en la base de datos.
	 */
	public void modificarPaciente(int id, MPaciente pacienteModificado, DefaultTableModel model, int indicereg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		String Actualiza = "UPDATE Pacientes SET nombre = ?, app = ?, apm = ?, fecNac = ?, edad = ?, curp = ?, "
				+ "genero = ?, alergias = ?, tipoSangre = ?, municipio = ?, localidad = ?, numCasa = ?, "
				+ "nomCalle = ?, idReligion = (SELECT idReligion FROM Religiones WHERE nombre = ?), telefono = ? "
				+ "WHERE idPaciente = ?";
		try {
			sentencia = Conexion.prepareStatement(Actualiza);
			sentencia.setString(1, pacienteModificado.getNombre());
			sentencia.setString(2, pacienteModificado.getApellidoP());
			sentencia.setString(3, pacienteModificado.getApellidoM());
			java.sql.Date sqlDate = new java.sql.Date(pacienteModificado.getFechaNac().getTime());
			sentencia.setDate(4, sqlDate);
			sentencia.setInt(5, pacienteModificado.getEdad());
			sentencia.setString(6, pacienteModificado.getCurp());
			sentencia.setString(7, pacienteModificado.getGenero());
			sentencia.setString(8, pacienteModificado.getAlergia());
			sentencia.setString(9, pacienteModificado.getSangre());
			sentencia.setString(10, pacienteModificado.getMunicipio());
			sentencia.setString(11, pacienteModificado.getLocalidad());
			sentencia.setInt(12, Integer.parseInt(pacienteModificado.getNext()));
			sentencia.setString(13, pacienteModificado.getNumCalle());
			sentencia.setString(14, pacienteModificado.getReligion()); // debe devolver el nombre de la religión
			sentencia.setString(15, pacienteModificado.getTelefono());

			sentencia.setInt(16, id);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				model.setValueAt(pacienteModificado.getNombre(), indicereg, 1);
				model.setValueAt(pacienteModificado.getApellidoP(), indicereg, 2);
				model.setValueAt(pacienteModificado.getApellidoM(), indicereg, 3);
				model.setValueAt(pacienteModificado.getFechaNac(), indicereg, 4);
				model.setValueAt(pacienteModificado.getEdad(), indicereg, 5);
				model.setValueAt(pacienteModificado.getCurp(), indicereg, 6);
				model.setValueAt(pacienteModificado.getGenero(), indicereg, 7);
				model.setValueAt(pacienteModificado.getAlergia(), indicereg, 8);
				model.setValueAt(pacienteModificado.getSangre(), indicereg, 9);
				model.setValueAt(pacienteModificado.getMunicipio(), indicereg, 10);
				model.setValueAt(pacienteModificado.getLocalidad(), indicereg, 11);
				model.setValueAt(pacienteModificado.getNext(), indicereg, 12);
				model.setValueAt(pacienteModificado.getNumCalle(), indicereg, 13);
				model.setValueAt(pacienteModificado.getReligion(), indicereg, 14);
				model.setValueAt(pacienteModificado.getTelefono(), indicereg, 15);

				JOptionPane.showMessageDialog(null, et.getString("pmc"), "Éxito", JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emp"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMP") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emp"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Busca y carga usuarios (pacientes) desde la base de datos en el modelo de
	 * tabla, aplicando paginación.
	 * <p>
	 * Este método realiza una consulta SQL con cláusulas {@code OFFSET} y
	 * {@code FETCH NEXT} para obtener un subconjunto de registros de la tabla
	 * {@code Pacientes}, incluyendo el nombre de la religión desde la tabla
	 * relacionada {@code Religiones}.
	 * </p>
	 * 
	 * @param model              El modelo de tabla que se actualizará con los
	 *                           resultados.
	 * @param paginaActual       Número de la página actual (empezando en 1).
	 * @param registrosPorPagina Número de registros a mostrar por página.
	 */
	public void buscarUsuariosConTableModel(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;// Variable PreparedStatement
		// Se genear una variables que optiene la conexi�n ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = ("SELECT p.idPaciente, p.nombre, p.app, p.apm, p.fecNac, p.edad, p.curp, p.genero, "
				+ "p.alergias, p.tipoSangre, p.municipio, p.localidad, p.numCasa, p.nomCalle, "
				+ "r.nombre AS religion, p.telefono " + "FROM Pacientes p "
				+ "INNER JOIN Religiones r ON p.idReligion = r.idReligion "
				+ "ORDER BY p.idPaciente OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[16];
				for (int i = 0; i < 16; i++)
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
	 * Cuenta el número total de registros existentes en la tabla {@code Pacientes}.
	 * <p>
	 * Este método realiza una consulta SQL con {@code SELECT COUNT(*)} y devuelve
	 * el total de registros encontrados. Es útil para implementar paginación o
	 * estadísticas.
	 * </p>
	 * 
	 * @return El número total de pacientes registrados en la base de datos.
	 * @exception SQLException Errores surgidos en la base de datos.
	 */
	public static double contarRegistros() {
		// TODO Auto-generated method stub
		try {
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Pacientes");
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
	 * Llena un {@code DefaultComboBoxModel} con los nombres de los municipios del
	 * estado de Sinaloa
	 * <p>
	 * Este método realiza una consulta SQL para obtener todos los valores distintos
	 * de la columna {@code D_mnpio}, los ordena alfabéticamente y los añade a un
	 * modelo de combo box que puede usarse directamente en componentes Swing como
	 * {@code JComboBox}.
	 * </p>
	 * <p>
	 * El primer elemento agregado al modelo es {@code "Seleccione..."} para guiar
	 * al usuario en la interfaz. En caso de error al consultar la base de datos, se
	 * muestra un mensaje y se devuelve {@code null}.
	 * </p>
	 * 
	 * @return Un modelo de combo box con los nombres de municipios o {@code null}
	 *         si ocurre un error.
	 * @exception SQLException Errores surgidos en la base de datos.
	 */
	public static DefaultComboBoxModel<String> LlenarComboBoxMun() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
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
	 * Llena un {@code DefaultComboBoxModel} con los nombres de las colonias
	 * (asentamientos) correspondientes al municipio proporcionado.
	 * <p>
	 * Este método realiza una consulta parametrizada sobre la tabla
	 * {@code Sinaloa}, filtrando por el nombre del municipio ({@code D_mnpio}) y
	 * extrayendo los valores únicos de la columna {@code d_asenta}, ordenados
	 * alfabéticamente.
	 * </p>
	 * 
	 * @param poblacion El nombre del municipio valor de la columna {@code D_mnpio})
	 *                  para el cual se obtiene localidades
	 * @return Un modelo de combo box con las colonias correspondientes, o
	 *         {@code null} si ocurre un error.
	 * @exception SQLException Errores surgidos en la base de datos.
	 */
	public static DefaultComboBoxModel<String> LlenarComboBoxPob(String poblacion) {
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

	/**
	 * Añade una nueva religión al catálogo de religiones en la base de datos.
	 * <p>
	 * Este método inserta un nuevo registro en la tabla {@code Religiones}
	 * utilizando los datos proporcionados en un objeto {@code MReligion}. Si la
	 * operación es exitosa, se muestra un mensaje informativo al usuario. En caso
	 * contrario, se muestra un mensaje de error.
	 * </p>
	 * 
	 * @param nuevareligion Objeto {@code MReligion} que contiene el nombre y la
	 *                      descripción de la nueva religión a registrar.
	 * @exception SQLException Errores surgidos en la base de datos.
	 */
	public static void anadirreligion(MReligion nuevareligion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Religiones (nombre,descripcion)" + " VALUES (?, ?)");

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, nuevareligion.getNombre());
			sentencia.setString(2, nuevareligion.getDescripcion());

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
			JOptionPane.showMessageDialog(null, et.getString("eap"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Llena un {@code DefaultComboBoxModel} con los nombres de las religiones
	 * almacenadas en la tabla {@code Religiones}.
	 * <p>
	 * Este método consulta todos los registros de la tabla {@code Religiones} y
	 * extrae el campo {@code nombre} para llenar un modelo de combo box que puede
	 * usarse en interfaces gráficas Swing.
	 * </p>
	 * 
	 * @return Un {@code DefaultComboBoxModel<String>} con las religiones
	 *         disponibles si ocurre un error durante la consulta.
	 */
	public static DefaultComboBoxModel<String> llenareligion() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Religiones");

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
			JOptionPane.showMessageDialog(null, et.getString("ecr"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	public static void reportepacientes() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/PacientesS.jrxml";
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

	public static void reportepacientesConParametros(Date f1, Date f2) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/PacientesS.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			// Mapa de parámetros
			Map<String, Object> parametros = new HashMap<String, Object>();
			parametros.put("F1", f1);
			parametros.put("F2", f2);

			JasperPrint print = JasperFillManager.fillReport(report, parametros, Conexion);

			if (print.getPages() == null || print.getPages().isEmpty()) {
				JOptionPane.showMessageDialog(null, et.getString("NOREP"), et.getString("REPV"),
						JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			JasperViewer.viewReport(print, false);
		} catch (JRException e) {
			e.printStackTrace();
		}

		// TODO Auto-generated method stub

	}

	public static void reportepacientesConParametros(java.util.Date fecha) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/PacientesC.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);

			Map<String, Object> parametros = new HashMap<String, Object>();
			java.sql.Date fechaLimite = new java.sql.Date(fecha.getTime());
			parametros.put("FechaLimite", fechaLimite);

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

	public static void reportepacientesConParametros(MPaciente pac) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/PacientesParametros.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();
			java.sql.Date sqlDate = new java.sql.Date(pac.getFechaNac().getTime());
			parametros.put("FechaLimite", sqlDate);

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

	public static void reportepacientesConParametroNombres(MPaciente pac) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/pacientesNom.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();

			parametros.put("Nombre", pac.getNombre());

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

	public static void reportepacientessin() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/PacientesSP.jrxml";
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

	public static void reportecitaspen() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/paccitaspen.jrxml";
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

	public static void reportehistorialmed(MPaciente pac1) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/pacientesNom.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();

			parametros.put("idPac", pac1.getId());

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

	public static void reporteelig() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/religiones.jrxml";
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

	public void buscarUsuariosConTableModelo(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "SELECT idReligion, nombre, descripcion " + "FROM Religiones " + "ORDER BY idReligion "
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

	/**
	 * Modifica los datos de una religión existente en la base de datos.
	 * 
	 * @param idReligion         Identificador de la religión a modificar.
	 * @param religionModificada Objeto {@code MReligion} con los nuevos datos.
	 * @param model              Modelo de tabla que muestra las religiones.
	 * @param indicereg          Índice de la fila que se modificará en el modelo.
	 */

	public void modificarrel(int idRel, MReligion rel, DefaultTableModel model, int seleccion) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlUpdate = "UPDATE Religiones SET nombre = ?, descripcion = ? WHERE idReligion = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlUpdate);
			sentencia.setString(1, rel.getNombre());
			sentencia.setString(2, rel.getDescripcion());
			sentencia.setInt(3, idRel);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Actualizar también la tabla en la interfaz
				model.setValueAt(rel.getNombre(), seleccion, 1);
				model.setValueAt(rel.getDescripcion(), seleccion, 2);

				JOptionPane.showMessageDialog(null, et.getString("Rmc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emR"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMR") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emR"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Elimina una religión de la base de datos por su ID.
	 * 
	 * @param idReligion Identificador de la religión a eliminar.
	 * @param model      Modelo de tabla que muestra las religiones.
	 * @param indicereg  Índice de la fila que se eliminará si la operación es
	 *                   exitosa.
	 */

	public void eliminarRel(int idRel, DefaultTableModel model, int seleccion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlDelete = "DELETE FROM Religiones WHERE idReligion = ?";

		try {
			sentencia = Conexion.prepareStatement(sqlDelete);
			sentencia.setInt(1, idRel);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Quitar la fila del JTable
				model.removeRow(seleccion);
				JOptionPane.showMessageDialog(null, et.getString("REC"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("EER"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLER") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("EER"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

}
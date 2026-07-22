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
import modelos.MMedicamentos;
import modelos.MPresentacion;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

/**
 * El controlador gestiona las operaciones relacionadas con los medicamentos en
 * la base de datos del sistema.
 * <p>
 * permite agregar, modificar, visualizar y eliminar los datos de los
 * medicamentos. Esta clase almacena objetos de tipo {@link MMedicamentos}
 * Utiliza conexion a SQL Server para hacer todos los procesos.
 * </p>
 * 
 * @see vistas.Medicamentos
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class Cmedicamento {

	/**
	 * Conexion a la base de datos
	 */
	public static Connection Conexion = null;
	/**
	 * Sentencia de consulta SQL a ejecutar
	 */
	public static String sql;
	/**
	 * Resultado de la consulta a SQL
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
	 * Agrega un nuevo medicamento en la base de datos.
	 * <P>
	 * Este metodo toma los datos almacenados en un objeto {@link MMedicamentos} y
	 * los inserta en la tabla {@code vistas.Medicamentos} mediante una secuencia
	 * SQL. Si la inserción es exitosa notifica al usuario mediante un mensaje. En
	 * el caso contrario, se notifica un error.
	 * </p>
	 * 
	 * @param nuevomed objeto que contiene los datos de Nuevo Medicamento.
	 * 
	 * @throws SQLException si ocurre un error al insertar los datos en SQL.
	 * 
	 * @see ConexionBSSQLServer
	 * 
	 */

	public static void AnMedi(MMedicamentos nuevomed) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Medicamentos (idMedicamento, nombre, codigoB, marca, laboratorio, formula , fecVenc, mgUnidad, claveR, idPresentacion)"
				+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, (SELECT idPresentacion FROM PresentacionMed WHERE nombre= ?))");

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setInt(1, nuevomed.getId());
			sentencia.setString(2, nuevomed.getNombreMed());
			sentencia.setString(3, nuevomed.getCodigoB());
			sentencia.setString(4, nuevomed.getMarca());
			sentencia.setString(5, nuevomed.getLaboratorio());
			sentencia.setString(6, nuevomed.getFormula());
			java.sql.Date sqlDate = new java.sql.Date(nuevomed.getFechaVen().getTime());
			sentencia.setDate(7, sqlDate);
			sentencia.setInt(8, nuevomed.getMgUnidad());
			sentencia.setString(9, nuevomed.getClaveR());
			sentencia.setString(10, nuevomed.getIdPresentacion());

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
			JOptionPane.showMessageDialog(null, et.getString("eam"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Elimina los medicamentos en la base de datos y los remueve del modelo de
	 * tabla.
	 * <p>
	 * Este método elimina primero cualquier referencia al medicamento en la tabla.
	 * {@code RECETAMEDICAMENTOS} , luego eliminael medicamento en la tabla
	 * {@code Medicamentos}. Si la eliminación es exitosa, también elimina la fila
	 * correspondiente del modelo de la tabla y muestra un mensaje de éxito. En caso
	 * contrario, se muestra un mensaje de error.
	 * </p>
	 * 
	 * @param id        Es el id del medicamento a eliminar
	 * @param model     Es el modelo de la tabla donde se va eliminar la vila
	 *                  visual.
	 * @param indicereg El índice de la fila en el modelo que se debe eliminar si la
	 *                  aceptación tiene éxito.
	 */
	public void eliminarmedi(int id, DefaultTableModel model, int indicereg) {
		Conexion = ConexionBDSQLServer.GetConexion();

		try {
			// Elimina referencias al medicamento en la tabla RECETAMEDICAMENTOS
			String sqlrecmedi = "DELETE FROM RECETAMEDICAMENTOS WHERE idMedicamento = ?";
			PreparedStatement eliminarRecet = Conexion.prepareStatement(sqlrecmedi);
			eliminarRecet.setInt(1, id);
			eliminarRecet.executeUpdate();

			// Eliminar el medicamento de la tabla Medicamentos
			String sqlmedi = "DELETE FROM Medicamentos WHERE idMedicamento = ?";
			PreparedStatement eliminarMedi = Conexion.prepareStatement(sqlmedi);
			eliminarMedi.setInt(1, id);

			int filasAfectadas = eliminarMedi.executeUpdate();

			if (filasAfectadas > 0) {
				// Eliminar la fila del modelo de la tabla si la operación fue exitosa
				model.removeRow(indicereg);
				JOptionPane.showMessageDialog(null, et.getString("mec"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eem"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLM") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eem"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Modifica los datos de un medicamento existente en la base de datos y
	 * actualiza la fila correspondiente en el modelo de la tabla.
	 * 
	 * <p>
	 * Este método actualiza la información de un medicamento en la tabla
	 * {@code Medicamentos} utilizando los valores contenidos en el objeto
	 * {@code MMedicamentos}. Si la modificación es exitosa, también se actualizan
	 * los datos mostrados en el {@code DefaultTableModel} que representa la tabla
	 * en la interfaz gráfica.
	 * <p>
	 * 
	 * @param id        Es el ID del medicamento que se va modificar.
	 * @param modimed   Es el objeto {@code MMedicamentos} que contiene los nuevos
	 *                  datos del medicamento.
	 * @param model     Es el modelo de la tabla que contiene los datos visuales
	 *                  mostrados al usuario.
	 * @param indicereg El índice de la fila que debe actualizarse en el modelo de
	 *                  la tabla.
	 */
	public void modificarPaciente(int id, MMedicamentos modimed, DefaultTableModel model, int indicereg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		sql = ("UPDATE Medicamentos SET idMedicamento=?, nombre=?, codigoB=?, marca=?, laboratorio=?, formula=?, fecVenc=?, mgUnidad=?, claveR=?, "
				+ "idPresentacion=(SELECT idPresentacion FROM PresentacionMed WHERE nombre= ?) ");

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setInt(1, modimed.getId());
			sentencia.setString(2, modimed.getNombreMed());
			sentencia.setString(3, modimed.getCodigoB());
			sentencia.setString(4, modimed.getMarca());
			sentencia.setString(5, modimed.getLaboratorio());
			sentencia.setString(6, modimed.getFormula());
			java.sql.Date sqlDate = new java.sql.Date(modimed.getFechaVen().getTime());
			sentencia.setDate(7, sqlDate);
			sentencia.setInt(8, modimed.getMgUnidad());
			sentencia.setString(9, modimed.getClaveR());
			sentencia.setString(10, modimed.getIdPresentacion());

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				model.setValueAt(modimed.getId(), indicereg, 1);
				model.setValueAt(modimed.getNombreMed(), indicereg, 2);
				model.setValueAt(modimed.getCodigoB(), indicereg, 3);
				model.setValueAt(modimed.getMarca(), indicereg, 4);
				model.setValueAt(modimed.getLaboratorio(), indicereg, 5);
				model.setValueAt(modimed.getFormula(), indicereg, 6);
				model.setValueAt(modimed.getFechaVen(), indicereg, 7);
				model.setValueAt(modimed.getMgUnidad(), indicereg, 8);
				model.setValueAt(modimed.getClaveR(), indicereg, 9);
				model.setValueAt(modimed.getIdPresentacion(), indicereg, 10);

				JOptionPane.showMessageDialog(null, et.getString("mmc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emm"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMM") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emm"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Este metodo realiza la consulta a la base de datos para obtener los
	 * registros.
	 * <p>
	 * {@link vistas.Medicamentos} y los carga en un DefaultTableModel Busca y
	 * muestra toda la informacion registrada en la base de datos sobre todos los
	 * medicamentos.
	 * </p>
	 * 
	 * @param model Modelo de tabla donde agregará las filas.
	 * 
	 * @throws SQLException Si ocurre un error al realizar la consulta.
	 */

	public void buscarUsuariosConTableModel(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;// Variable PreparedStatement
		// Se genear una variables que optiene la conexi�n ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = "SELECT m.idMedicamento, m.nombre, m.codigoB, m.marca, m.laboratorio, m.formula, m.fecVenc, m.mgUnidad, m.claveR, p.nombre "
				+ "FROM Medicamentos m " + "INNER JOIN PresentacionMed p ON m.idPresentacion = p.idPresentacion "
				+ "ORDER BY m.idMedicamento OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[10];
				for (int i = 0; i < 10; i++)
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
	 * Cuenta el número total de registros en la tabla {@code Medicamentos}.
	 * 
	 * <p>
	 * Este método realiza una consulta SQL con la instrucción
	 * {@code SELECT COUNT(*)} para determinar cuántos medicamentos existen
	 * actualmente en la base de datos.
	 * </p>
	 *
	 * <p>
	 * El resultado se almacena en la variable estática {@code totalRegistros}, que
	 * es retornada al finalizar. En caso de que ocurra una excepción de tipo
	 * {@code SQLException}, esta será capturada y el valor retornado será el último
	 * valor de {@code totalRegistros}, probablemente 0 si no se estableció
	 * previamente.
	 * </p>
	 *
	 * @return el número total de registros existentes en la tabla
	 *         {@code Medicamentos}.
	 * @exception SQLException Errores de SQL
	 */
	public static double contarRegistros() {
		// TODO Auto-generated method stub

		try {
			sentencia = Conexion.prepareStatement(sql);
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Medicamentos");
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
	 * Añade una nueva presentación de medicamento en la tabla
	 * {@code PresentacionMed}.
	 * <p>
	 * Este método utiliza un objeto de tipo {@code MPresentacion} para insertar sus
	 * atributos en la base de datos, específicamente el nombre y la descripción de
	 * la presentación. Se utiliza una sentencia SQL {@code INSERT INTO} con
	 * parámetros preparados para mayor seguridad.
	 * </p>
	 * <p>
	 * En caso de que la operación sea exitosa (una o más filas afectadas), se
	 * mostrará un mensaje de confirmación al usuario mediante {@code JOptionPane}.
	 * De lo contrario, se notificará con un mensaje de error. Si ocurre una
	 * excepción {@code SQLException}, esta será registrada en la consola y se
	 * mostrará un mensaje de error al usuario.
	 * </p>
	 * 
	 * @exception SQLException Si ocurre un error de SQL
	 * @param nuevapre el objeto {@code MPresentacion} que contiene el nombre y la
	 *                 descripción de la nueva presentación.
	 */
	public static void anadirpre(MPresentacion nuevapre) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO PresentacionMed (nombre,descripcion)" + " VALUES (?, ?)");

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, nuevapre.getNombre());
			sentencia.setString(2, nuevapre.getDescripcion());

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
			JOptionPane.showMessageDialog(null, et.getString("eapr"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	/**
	 * Llena un {@link DefaultComboBoxModel} con los nombres de las presentaciones
	 * de medicamentos.
	 * <p>
	 * Este método realiza una consulta a la tabla {@code PresentacionMed} y agrega
	 * cada valor de la columna {@code nombre} al modelo de combo box. Se añade un
	 * primer elemento "Seleccione..." como opción por defecto.
	 * </p>
	 * 
	 * @return un {@link DefaultComboBoxModel} con los nombres de las presentaciones
	 * @exception SQLException Si ocurre un error de SQL
	 */
	public static DefaultComboBoxModel<String> llenarprese() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM PresentacionMed");

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
			JOptionPane.showMessageDialog(null, et.getString("ecp"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Busca un medicamento en la base de datos usando su código de barras.
	 * <p>
	 * Realiza una consulta que une las tablas Medicamentos y PresentacionMed para
	 * obtener los datos del medicamento correspondiente.
	 * </p>
	 * 
	 * @param codigo El código de barras del medicamento.
	 * @return Un objeto {@link MMedicamentos} con los datos encontrados
	 * @exception SQLException Si ocurre un error de SQL
	 */
	public static MMedicamentos buscarPorCodigoBarras(String codigo) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		MMedicamentos medicamento = null;

		try {
			con = ConexionBDSQLServer.GetConexion();
			String busqueda = ("SELECT m.idMedicamento, m.nombre, m.codigoB, m.marca, m.laboratorio, m.formula, m.fecVenc, m.mgUnidad, m.claveR, p.nombre AS nomp "
					+ "FROM Medicamentos m " + "INNER JOIN PresentacionMed p ON m.idPresentacion = p.idPresentacion "
					+ "WHERE m.codigoB = ?");
			ps = con.prepareStatement(busqueda);
			ps.setString(1, codigo);
			rs = ps.executeQuery();

			if (rs.next()) {
				medicamento = new MMedicamentos();
				medicamento.setId(rs.getInt("idMedicamento"));
				medicamento.setNombreMed(rs.getString("nombre"));
				medicamento.setMarca(rs.getString("marca"));
				medicamento.setLaboratorio(rs.getString("laboratorio"));
				medicamento.setFormula(rs.getString("formula"));
				medicamento.setClaveR(rs.getString("claveR"));
				medicamento.setFechaVen(rs.getDate("fecVenc"));
				medicamento.setMgUnidad(rs.getInt("mgUnidad"));
				medicamento.setPresentacion(rs.getString("nomp"));
				medicamento.setCodigoB(rs.getString("codigoB"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
			}
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e) {
			}
			try {
				if (con != null)
					con.close();
			} catch (Exception e) {
			}
		}

		return medicamento;
	}

	/**
	 * Modifica la información de un medicamento existente en la base de datos.
	 * <p>
	 * Este método actualiza los campos del medicamento identificado por su ID,
	 * incluyendo nombre, código de barras, marca, laboratorio, fórmula, fecha de
	 * vencimiento, miligramos por unidad, clave y presentación.
	 * </p>
	 * 
	 * @param idMedicamento El ID del medicamento a modificar.
	 * @param modimed       Un objeto {@code MMedicamentos} que contiene los nuevos
	 *                      valores que se asignarán al medicamento.
	 * @throws SQLException Si ocurre un error durante la actualización en la base
	 *                      de datos.
	 */
	public void modificarPacientev2(int idMedicamento, MMedicamentos modimed) {

		sql = "UPDATE Medicamentos SET nombre = ?, codigoB = ?, marca = ?, laboratorio = ?, formula = ?, fecVenc = ?, mgUnidad = ?, claveR = ?, "
				+ "idPresentacion = (SELECT idPresentacion FROM PresentacionMed WHERE nombre = ?) WHERE idMedicamento = ?";

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, modimed.getNombreMed());
			sentencia.setString(2, modimed.getCodigoB());
			sentencia.setString(3, modimed.getMarca());
			sentencia.setString(4, modimed.getLaboratorio());
			sentencia.setString(5, modimed.getFormula());
			java.sql.Date sqlDate = new java.sql.Date(modimed.getFechaVen().getTime());
			sentencia.setDate(6, sqlDate);
			sentencia.setInt(7, modimed.getMgUnidad());
			sentencia.setString(8, modimed.getClaveR());
			sentencia.setString(9, modimed.getIdPresentacion());
			sentencia.setInt(10, idMedicamento);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				JOptionPane.showMessageDialog(null, et.getString("mmc"));
			} else {
				JOptionPane.showMessageDialog(null, et.getString("nem"));
			}

		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, et.getString("emm") + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
			e.printStackTrace();
		}

	}

	/**
	 * Elimina un medicamento y su inventario asociado de la base de datos.
	 * <p>
	 * Este método elimina primero los registros del inventario relacionados al
	 * medicamento y posteriormente elimina el medicamento en sí. Se utiliza el ID
	 * del medicamento como referencia para ambas eliminaciones.
	 * </p>
	 * 
	 * @param id El ID del medicamento que se desea eliminar.
	 * @throws SQLException Si ocurre un error durante el proceso de eliminación en
	 *                      la base de datos.
	 */
	public static void eliminarmedver2(int id) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		String eliminamed = ("DELETE FROM Medicamentos WHERE idMedicamento = ?");
		String medin = "DELETE FROM Inventario WHERE idMedicamento= ?";

		try {

			sentencia = Conexion.prepareStatement(medin);
			sentencia.setInt(1, id);
			sentencia.executeUpdate();
			sentencia = Conexion.prepareStatement(eliminamed);
			sentencia.setInt(1, id);

			int filasAfectadas = sentencia.executeUpdate();
			if (filasAfectadas > 0) {
				JOptionPane.showMessageDialog(null, et.getString("eee"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("ev"), "Error", JOptionPane.ERROR_MESSAGE);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("eem"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	public static void reportepacientesConParametros(MMedicamentos pac) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/mediven.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();
			java.sql.Date sqlDate = new java.sql.Date(pac.getFechaVen().getTime());
			parametros.put("Fecha Limite", sqlDate);

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

	public static void reportebase() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/MedicamentosNo.jrxml";
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

	public static void reporteporpresentacion() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/medicamentopres.jrxml";
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

	public static void reportepresentaciones() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/presentaciones.jrxml";
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

	/**
	 * Obtiene un modelo de tabla con todas las presentaciones registradas.
	 * 
	 * @param paginaActual Página que se quiere mostrar (paginación).
	 * @return DefaultTableModel con los datos.
	 */

	public void buscarUsuariosConTableModelo(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = "SELECT * FROM PresentacionMed " + "ORDER BY idPresentacion OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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

	public void modificarser(int idPre, MPresentacion meD, DefaultTableModel model, int seleccion) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		sql = "UPDATE PresentacionMed SET nombre = ?, descripcion = ? WHERE idPresentacion = ?";

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setString(1, meD.getNombre());
			sentencia.setString(2, meD.getDescripcion());
			sentencia.setInt(3, idPre);

			int filasAfectadas = sentencia.executeUpdate();
			if (filasAfectadas > 0) {
				JOptionPane.showMessageDialog(null, et.getString("PMC"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("EMP"), "Error", JOptionPane.ERROR_MESSAGE);
			}
		} catch (SQLException e) {
			System.err.println(et.getString("SQLP") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("EMP"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	public void eliminarSer(int idPre, DefaultTableModel model, int seleccion) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		sql = "DELETE FROM PresentacionMed WHERE idPresentacion = ?";

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setInt(1, idPre);

			int filasAfectadas = sentencia.executeUpdate();
			if (filasAfectadas > 0) {
				JOptionPane.showMessageDialog(null, et.getString("Pec"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eeP"), "Error", JOptionPane.ERROR_MESSAGE);
			}
		} catch (SQLException e) {
			System.err.println(et.getString("SQLEP") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eeP"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}
}

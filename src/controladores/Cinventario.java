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
import modelos.MInventario;
import modelos.MMedicamentos;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

/**
 * El controlador gestiona las operaciones relacionadas con el inventario en la
 * base de datos del sistema.
 * <p>
 * Esta clase permite utilizando un modelo de tipo {@link MInventario}, mediante
 * una conexión a SQL Server. <b>Realiza ciertas acciones</b>
 * <li>Modificar los registros de inventario</li>
 * <li>Eliminar los registros de inventario</li>
 * <li>Insertar los registros de inventario</li>
 * 
 * @see vistas.Inventario
 *      </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 * 
 */
public class Cinventario {

	public static Connection Conexion = null;
	public static String sql;
	public static ResultSet ResultSet = null;
	public static PreparedStatement sentencia;
	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);

	private static int totalRegistros = 0;

	/**
	 * Carga una lista paginada de registros de la tabla {@code Inventario} y los
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
		// Se genear una variables que optiene la conexi�n ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = ("SELECT i.idInventario, m.nombre AS Medicamento, i.CantidadDisp, i.FechaIngreso, i.Estado, i.lote "
				+ "FROM Inventario i " + "INNER JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento "
				+ "ORDER BY i.idInventario OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[6];
				for (int i = 0; i < 6; i++)
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
	 * <p>
	 * Este método es útil en funcionalidades que requieren paginación o
	 * estadísticas, como la visualización paginada en una tabla ({@code JTable}).
	 * </p>
	 *
	 * @return El número total de registros encontrados en la tabla
	 *         {@code Inventario}.
	 * @exception Marca errores en base de datos de SQL
	 */
	public static double contarRegistros() {
		// TODO Auto-generated method stub
		try {
			sentencia = Conexion.prepareStatement(sql);
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Inventario");
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
	 * Obtiene todos los IDs de inventario de la base de datos y los carga en un
	 * modelo {@code DefaultComboBoxModel<String>} para su uso en un JComboBox.
	 * <p>
	 * El primer elemento agregado es "Seleccione..." para indicar una opción por
	 * defecto que invita al usuario a seleccionar un inventario.
	 * </p>
	 * 
	 * @return Un {@code DefaultComboBoxModel<String>} con los IDs del inventario.
	 */
	public static DefaultComboBoxModel<String> llenarmedicamentos() {
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta.executeQuery("SELECT * FROM Medicamentos");

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
			JOptionPane.showMessageDialog(null, et.getString("ecmd"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Inserta un nuevo registro en la tabla {@code Inventario} con los datos del
	 * objeto {@code MInventario}.
	 * <p>
	 * Este método realiza una inserción donde el {@code idMedicamento} se obtiene a
	 * partir del nombre del medicamento asociado. En caso de éxito, muestra un
	 * mensaje informativo; de lo contrario, muestra un mensaje de error.
	 * </p>
	 * 
	 * @param nuevoin Objeto de tipo {@code MInventario} que contiene los datos a
	 *                insertar.
	 * @return {@code true} si la operación se ejecutó (independientemente de éxito
	 *         real de la inserción), {@code false} podría implementarse para
	 *         indicar fallo en futuras mejoras.
	 * @exception SQLException Errores de SQL
	 */
	public static boolean agregarinv(MInventario nuevoin) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		sql = ("INSERT INTO Inventario (idMedicamento,CantidadDisp,FechaIngreso,lote)"
				+ " VALUES ((SELECT idMedicamento FROM Medicamentos where nombre= ?), " + "?, ?, ?)");

		try {
			sentencia = Conexion.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			sentencia.setString(1, nuevoin.getMedicamento());
			sentencia.setInt(2, nuevoin.getCantidad());
			java.sql.Date sqlDate = new java.sql.Date(nuevoin.getFecha().getTime());
			sentencia.setDate(3, sqlDate);
			sentencia.setString(4, nuevoin.getLote());

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
			JOptionPane.showMessageDialog(null, et.getString("eai"), "Error", JOptionPane.ERROR_MESSAGE);
		}
		return true;
	}

	/**
	 * Modifica un registro existente en la tabla {@code Inventario} con los datos
	 * proporcionados.
	 *
	 * <p>
	 * Actualiza el registro identificado por {@code idinv} con los nuevos valores
	 * del objeto {@code MInventario} y actualiza el {@code DefaultTableModel} para
	 * reflejar los cambios en la interfaz gráfica.
	 * </p>
	 *
	 * <p>
	 * El campo {@code idMedicamento} se obtiene mediante una subconsulta basada en
	 * el nombre del medicamento.
	 * </p>
	 *
	 * @param idinv                Identificador único del inventario que se desea
	 *                             modificar.
	 * @param inventarioModificado Objeto {@code MInventario} que contiene los
	 *                             nuevos datos a guardar.
	 * @param model                Modelo de tabla {@code DefaultTableModel} que se
	 *                             actualizará para reflejar los cambios.
	 * @param filaTabla            Índice de la fila en el modelo que corresponde al
	 *                             registro modificado.
	 * @exception SQLException Errores de SQL
	 */
	public void modificarin(int idinv, MInventario inventarioModificado, DefaultTableModel model, int filaTabla) {
		sql = "UPDATE Inventario SET idMedicamento = (SELECT idMedicamento FROM Medicamentos WHERE nombre = ?), "
				+ "CantidadDisp = ?, FechaIngreso = ?, lote = ? WHERE idInventario = ?";

		try {
			sentencia = Conexion.prepareStatement(sql);

			sentencia.setString(1, inventarioModificado.getMedicamento()); // nombre del medicamento
			sentencia.setInt(2, inventarioModificado.getCantidad());
			java.sql.Date sqlDate = new java.sql.Date(inventarioModificado.getFecha().getTime());
			sentencia.setDate(3, sqlDate);
			sentencia.setString(4, inventarioModificado.getLote());
			sentencia.setInt(5, idinv);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Actualizar la tabla visual
				model.setValueAt(inventarioModificado.getMedicamento(), filaTabla, 1);
				model.setValueAt(inventarioModificado.getCantidad(), filaTabla, 2);
				model.setValueAt(inventarioModificado.getFecha(), filaTabla, 3);
				model.setValueAt(inventarioModificado.getLote(), filaTabla, 4);

				JOptionPane.showMessageDialog(null, et.getString("imc"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emi"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLI") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emi"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Elimina un registro del inventario en la base de datos y actualiza el modelo
	 * de tabla.
	 * <p>
	 * Elimina el registro de la tabla {@code Inventario} correspondiente al
	 * {@code idInventario} proporcionado y elimina la fila asociada en el modelo
	 * {@code DefaultTableModel} para reflejar el cambio en la interfaz gráfica.
	 * </p>
	 * 
	 * @param id        Identificador único del registro de inventario a eliminar.
	 * @param model     Modelo de tabla {@code DefaultTableModel} asociado a la
	 *                  vista que muestra el inventario.
	 * @param indicereg Índice de la fila en el modelo que corresponde al registro a
	 *                  eliminar.
	 * @exception SQLException Errores de SQL
	 */
	public void eliminarin(int id, DefaultTableModel model, int indicereg) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlPaciente = "DELETE FROM Inventario WHERE idInventario = ?";

		try {

			// Ahora eliminar el paciente
			sentencia = Conexion.prepareStatement(sqlPaciente);
			sentencia.setInt(1, id);
			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				// Eliminar la fila del modelo de la tabla
				model.removeRow(indicereg);
				JOptionPane.showMessageDialog(null, et.getString("diec"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eei"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLEI") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eei"), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	public static void reporteagotados() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/inventarioagotado.jrxml";
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

	public static void reportebase() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/inventariobase.jrxml";
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

	public static void reporteinventariopormed(MMedicamentos pac) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/inventarioespecifico.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();

			parametros.put("Nombre", pac.getNombreMed());

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

}
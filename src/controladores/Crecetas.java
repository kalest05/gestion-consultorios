package controladores;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

import javax.swing.DefaultComboBoxModel;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

import conexion.ConexionBDSQLServer;
import modelos.MReceta;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.view.JasperViewer;

/**
 * El Controlador es el que gestiona las operaciones relacionadas con los
 * pacientes en la base de datos del sistema.
 * <p>
 * Esta clase contiene metodos necesarios para gestionar recetas medicas incluye
 * la creación, modificación, visualización y eliminación de recetas Esta clase
 * tambien permite autocompletar listas desplegables con datos de medicamentos y
 * citas {@link vistas.Recetas}.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class Crecetas {

	/**
	 * Variable maneja conexion a la base de datos
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

	public static CallableStatement cs;

	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma = Locale.getDefault();
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et = ResourceBundle.getBundle("properties/dic", Idioma);
	private static int idReceta;

	/**
	 * Llena y retorna un objeto con los nombres de los medicamentos obtenidos desde
	 * una base de datos SQL Server.
	 * <p>
	 * Este método se utiliza para poblar un componente JComboBox con los nombres de
	 * los medicamentos almacenados en la tabla Medicamentos. El primer elemento
	 * añadido es "Seleccione...", que sirve como opción por defecto para que el
	 * usuario seleccione.
	 * </p>
	 * 
	 * @return Un modelo mostrado en el JComboBox con los datos encontrados en la
	 *         base de datos.
	 *
	 * @throws SQLException Se maneja el error si falla al consultar y se anula el
	 *                      modelo.
	 * 
	 * @see vistas.Recetas
	 */
	public static DefaultComboBoxModel<String> llenarmedicamento() {

		/**
		 * Modelo de datos para un cuadro combinado que permite agregar, eliminar y
		 * actualizar elementos en la lista desplegable.
		 */
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			// Se crea una sentencia SQL para ejecutar la consulta.
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			// Se ejecuta la consulta para obtener todos los registros de la tabla
			// Medicamentos.
			String busq = "SELECT m.nombre " + "FROM Medicamentos m "
					+ "JOIN Inventario i ON m.idMedicamento = i.idMedicamento "
					+ "WHERE i.CantidadDisp > 0 ORDER BY i.CantidadDisp";
			ResultSet rs = Consulta.executeQuery(busq);

			// Se ingresa un dato blanco en el primer campo del Combobox.
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabla de combobox.
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
	 * Llena y retorna un objeto con los nombres de los medicamentos obtenidos desde
	 * una base de datos SQL Server.
	 * <p>
	 * Este método se utiliza para poblar un componente JComboBox con los nombres de
	 * las citas almacenados en la tabla Medicamentos. El primer elemento añadido es
	 * "Seleccione...", que sirve como opción por defecto para que el usuario
	 * seleccione.
	 * </p>
	 * 
	 * @return Modelo para JComboBox con ID de citas.
	 * @throws SQLException Se maneja el error si falla al consultar y se anula el
	 *                      modelo.
	 */
	public static DefaultComboBoxModel<String> llenarcitacb() {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> DatosJcombox = new DefaultComboBoxModel<String>();

		try {
			Statement Consulta = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = Consulta
					.executeQuery("SELECT * FROM Consultas WHERE CAST(fecha AS DATE) = CAST(GETDATE() AS DATE)");

			// Se ingresa un dato blanco en el primer campo del Combox
			DatosJcombox.addElement(et.getString("SEL"));
			while (rs.next()) {
				// se llena con todos los elementos devueltos de la tabal de Combox
				DatosJcombox.addElement(rs.getString("idConsulta"));
			}
			rs.close();
			Consulta.close();

		} catch (SQLException e) {
			System.err.println(e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("ecco"), "Error", JOptionPane.ERROR_MESSAGE);
			DatosJcombox = null;
		}

		return DatosJcombox;
	}

	/**
	 * Busca y muestra toda la informacion registarda en a base de datos sobre todas
	 * las recetas
	 * <p>
	 * Este metódo realiza una consulta a las tablas las tablas
	 * {@link vistas.Recetas} y {@link vistas.Recetas} para obtene detalles como ID
	 * de receta, ID de cita, los ID con subconsultas fecha, dosis, duración,
	 * instrucciones, nombre del medicamento y cantidad.
	 * </p>
	 * 
	 * @param model modelo de tabla donde se cargarán los datos de la receta
	 */
	public void buscarUsuariosConTableModel(DefaultTableModel model) {
		try {
			Statement estatuto = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = estatuto.executeQuery(
					"SELECT r.idReceta, r.idConsulta, r.fecha, r.dosis, r.duracion, r.instruccion, m.nombre, rm.cantidad "
							+ "FROM Recetas r " + "JOIN RECETAMEDICAMENTOS rm ON r.idReceta = rm.idReceta "
							+ "JOIN Medicamentos m ON rm.idMedicamento = m.idMedicamento");

			while (rs.next()) {
				// es para obtener los datos y almacenar las filas
				Object[] fila = new Object[8];
				// para llenar cada columna con lo datos almacenados
				for (int i = 0; i < 8; i++)
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
	 * Agrega una nueva receta junto con su medicamento asociado en la base de datos
	 * <p>
	 * Este metodo inserta un registro en la tabla con los datos proporcionados por
	 * el objeto {@link MReceta} Luego obtiene el ID generado automáticamente para
	 * esta receta y utiliza ese ID para insertar los medicamentos correspondientes
	 * en la tabla.
	 * </p>
	 * 
	 * @param nr                objeto que contiene todos los datos de la receta
	 *                          registrada.
	 * @param listaMedicamentos
	 * @param listaCantidades
	 * @throws SQLException Si ocurre un error al insertar datos.
	 */
	public static void nuevaReceta(MReceta nr, ArrayList<Integer> listaCantidades,
			ArrayList<String> listaMedicamentos) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		cs = null;
		String sqlReceta = "INSERT INTO Recetas (idConsulta, fecha, diagnostico, instruccion) VALUES (?, ?, ?, ?)";

		try {
			// 1. Insertar receta
			sentencia = Conexion.prepareStatement(sqlReceta, Statement.RETURN_GENERATED_KEYS);
			sentencia.setInt(1, nr.getIdcita());
			java.sql.Date sqlDate = new java.sql.Date(nr.getFecha().getTime());
			sentencia.setDate(2, sqlDate);
			sentencia.setString(3, nr.getDuracion());
			sentencia.setString(4, nr.getNstruccion());

			int filasAfectadas = sentencia.executeUpdate();
			int idReceta = -1;

			if (filasAfectadas > 0) {
				ResultSet rs = sentencia.getGeneratedKeys();
				if (rs.next()) {
					idReceta = rs.getInt(1);
				}
			}

			// Llamar al procedimiento almacenado para cada medicamento
			cs = Conexion.prepareCall("{ call sp_RegistrarRecetaMedicamento(?, ?, ?) }");

			for (int i = 0; i < listaMedicamentos.size(); i++) {
				int cantidad = listaCantidades.get(i);
				String nombreMed = listaMedicamentos.get(i);

				// Buscar el ID del medicamento por nombre
				String sqlIdMed = "SELECT idMedicamento FROM Medicamentos WHERE nombre = ?";
				PreparedStatement psBuscarId = Conexion.prepareStatement(sqlIdMed);
				psBuscarId.setString(1, nombreMed);
				ResultSet rsMed = psBuscarId.executeQuery();

				if (rsMed.next()) {
					int idMedicamento = rsMed.getInt("idMedicamento");

					try {
						cs.setInt(1, idReceta);
						cs.setInt(2, idMedicamento);
						cs.setInt(3, cantidad);
						cs.execute();

					} catch (SQLException ex) {
						String errorMsg = ex.getMessage();
						if (errorMsg.contains(et.getString("ns")) || errorMsg.contains(et.getString("ni"))) {
							JOptionPane.showMessageDialog(null, et.getString("em") + nombreMed + "':\n" + errorMsg,
									et.getString("is"), JOptionPane.ERROR_MESSAGE);
							return; // Detener el registro si falla uno
						} else {
							JOptionPane.showMessageDialog(null, et.getString("ei") + nombreMed + "': " + errorMsg,
									"Error", JOptionPane.ERROR_MESSAGE);
							return;
						}
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("emd") + nombreMed + et.getString("ne"), "Error",
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				psBuscarId.close();
			}

			JOptionPane.showMessageDialog(null, et.getString("rrc"));

		} catch (SQLException e) {
			System.err.println(et.getString("SQL") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("er") + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
		} finally {
			try {
				if (sentencia != null)
					sentencia.close();
				if (Conexion != null)
					Conexion.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * Modifica los datos de una receta existente y su medicamento asociado en la
	 * base de datos
	 * <p>
	 * Este metodo realiza modificaciones a los registros de la base de datos,
	 * tomado el parametro {@code id} como el identificador unico para encontrar el
	 * registro a modificar ejecutando la sentencia descrita, ejecutandola en cada
	 * campo de la tabla de la base de datos.
	 * </p>
	 * 
	 * @param id                ID de la receta a modificar enviado de
	 *                          {@link vistas.Recetas}.
	 * @param recetaAc          objeto con los nuevos datos de la receta
	 * @param model             modelo de tabla donde se cargarán los cambios
	 * @param indicereg         indice de la fila a actualizar en el modelo
	 * @param listaMedicamentos
	 * @param listaCantidades
	 */
	public void modificarReceta(int id, MReceta recetaAc, DefaultTableModel model, int indicereg,
			ArrayList<Integer> listaCantidades, ArrayList<String> listaMedicamentos) {
		sentencia = null;
		cs = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		// Variable que almacena la sentencia UPDATE para ejecutar en la base de datos
		String sql = "UPDATE Recetas SET idConsulta = ?, fecha = ?, diagnostico = ?, instruccion = ? WHERE idReceta = ?";
		try {
			// Preparar la sentencia para actualizar la receta
			sentencia = Conexion.prepareStatement(sql);
			// Establecer los valores de la receta
			sentencia.setInt(1, recetaAc.getIdcita());
			java.sql.Date sqlDate = new java.sql.Date(recetaAc.getFecha().getTime());
			sentencia.setDate(2, sqlDate);
			sentencia.setString(3, recetaAc.getDuracion());
			sentencia.setString(4, recetaAc.getNstruccion());
			sentencia.setInt(5, id); // ID de la receta que queremos actualizar

			// Ejecutar la actualización de la receta
			int filasAfectadas = sentencia.executeUpdate();
			if (filasAfectadas > 0) {
				// Si la receta se actualizó correctamente, actualizamos los medicamentos
				model.setValueAt(recetaAc.getIdcita(), indicereg, 1);
				model.setValueAt(new SimpleDateFormat("dd/MM/yyyy").format(recetaAc.getFecha()), indicereg, 2);
				model.setValueAt(recetaAc.getDuracion(), indicereg, 3);
				model.setValueAt(recetaAc.getNstruccion(), indicereg, 4);
				// Actualizar los medicamentos
				String sqlDetalle = "UPDATE RECETAMEDICAMENTOS SET cantidad = ? WHERE idReceta = ? AND idMedicamento = ?";
				PreparedStatement psDetalle = Conexion.prepareStatement(sqlDetalle); // Obtener el ID generado
				for (int i = 0; i < listaMedicamentos.size(); i++) {
					psDetalle.setInt(1, listaCantidades.get(i)); // Establecer la cantidad
					psDetalle.setInt(2, id); // Establecer el ID de la receta
					psDetalle.setString(3, listaMedicamentos.get(i)); // Establecer el ID del medicamento
					psDetalle.executeUpdate();
				}
				// Mostrar mensaje de éxito
				JOptionPane.showMessageDialog(null, et.getString("rerac"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("emr"), "Error", JOptionPane.ERROR_MESSAGE);
			}
		} catch (SQLException e) {
			System.err.println(et.getString("SQLMREC") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emr"), "Error", JOptionPane.ERROR_MESSAGE);
		} finally {
			// Cerrar recursos
			try {
				if (sentencia != null) {
					sentencia.close();
				}
				if (Conexion != null) {
					Conexion.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * Elimina una receta y sus medicamentos asociados de la base de datos
	 * 
	 * @param id        ID de la receta a eliminar
	 * @param model     modelo de la tabla donde se cargará la eliminación
	 * @param indicereg indice de la fila a eliminar en el modelo de la tabla
	 */
	public void eliminarRe(int id, DefaultTableModel model, int indicereg) {
		sentencia = null;
		cs = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sqlredmed = "DELETE FROM RECETAMEDICAMENTOS WHERE idReceta = ?";
		String sqlReceta = "DELETE FROM Recetas WHERE idReceta = ?";

		try {
			// Primero eliminar los medicamentos
			PreparedStatement eliminarMed = Conexion.prepareStatement(sqlredmed);
			eliminarMed.setInt(1, id);
			eliminarMed.executeUpdate();

			// Luego eliminar la receta
			PreparedStatement eliminarReceta = Conexion.prepareStatement(sqlReceta);
			eliminarReceta.setInt(1, id);
			int filasAfectadas = eliminarReceta.executeUpdate();

			if (filasAfectadas > 0) {
				// Eliminar la fila del modelo de la tabla
				model.removeRow(indicereg);
				JOptionPane.showMessageDialog(null, et.getString("rerec"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eerr"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLEREC") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eerr"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Llena un {@link DefaultTableModel} con los registros de la tabla Recetas,
	 * paginados.
	 *
	 * <p>
	 * Este método consulta la base de datos y obtiene un conjunto de registros de
	 * la tabla {@code Recetas} ordenados por {@code idReceta}. Se utilizan las
	 * cláusulas OFFSET y FETCH para paginar los resultados de acuerdo a la página
	 * actual y el número de registros por página especificados.
	 * </p>
	 *
	 * <p>
	 * Los datos obtenidos se agregan fila por fila al modelo .
	 * </p>
	 *
	 * @param model              El modelo de tabla que será llenado con los datos
	 *                           obtenidos.
	 * @param paginaActual       El número de la página que se desea consultar
	 * @param registrosPorPagina El número de registros a mostrar por página.
	 * @throws SQLException Si ocurre un error de SQL
	 */

	public void buscarUsuariosConTableModel(DefaultTableModel model, int paginaActual, int registrosPorPagina) {
		PreparedStatement pst = null;// Variable PreparedStatement
		// Se genear una variables que optiene la conexi�n ala base de Datos
		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		sql = "SELECT * FROM Recetas ORDER BY idReceta OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {

			pst = Conexion.prepareStatement(sql);
			pst.setInt(1, (paginaActual - 1) * registrosPorPagina);
			pst.setInt(2, registrosPorPagina);

			ResultSet rs = pst.executeQuery();

			model.setRowCount(0); // Limpiar tabla
			while (rs.next()) {
				Object[] fila = new Object[5];
				for (int i = 0; i < 5; i++)
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
	 * Cuenta el número total de registros existentes en la tabla {@code Recetas}.
	 *
	 * <p>
	 * Este método realiza una consulta SQL para obtener el conteo total de filas en
	 * la tabla {@code Recetas}. Utiliza un objeto {@link Statement} para ejecutar
	 * la consulta y devuelve el total de registros encontrados.
	 * </p>
	 *
	 * @return el número total de registros en la tabla {@code Recetas}.
	 */

	public static double contarRegistros() {
		// TODO Auto-generated method stub
		try {
			Statement st = ConexionBDSQLServer.GetConexion().createStatement();
			ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Recetas");
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
	 * Llena el {@link DefaultTableModel} con los medicamentos y sus cantidades
	 * asociados a una receta específica.
	 * 
	 * <p>
	 * Realiza una consulta a la base de datos para obtener el nombre y la cantidad
	 * de medicamentos relacionados con el ID de receta proporcionado, y luego
	 * agrega estos datos al modelo de tabla para su visualización.
	 * </p>
	 * 
	 * @exception SQLException Si ocurre un error de SQL
	 * @param idRecetaSel El ID de la receta cuyos medicamentos se desean obtener.
	 * @param modelMedi   El {@link DefaultTableModel} que será llenado con los
	 *                    datos.
	 */
	public void buscarUsuariosConTableModel(int idRecetaSel, DefaultTableModel modelMedi) {

		modelMedi.setRowCount(0);

		Conexion = ConexionBDSQLServer.GetConexion(); // sqlserver
		String sql = "SELECT m.nombre, rm.cantidad " + "FROM RECETAMEDICAMENTOS rm "
				+ "inner JOIN Medicamentos m ON m.idMedicamento = rm.idMedicamento " + "WHERE rm.idReceta = ?";
		try {

			PreparedStatement ps = Conexion.prepareStatement(sql);
			ps.setInt(1, idRecetaSel);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				String nombre = rs.getString("nombre");
				int cantidad = rs.getInt("cantidad");

				modelMedi.addRow(new Object[] { nombre, cantidad });
			}

		} catch (Exception e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("ecmr"));
		}
	}

	/**
	 * Elimina todos los medicamentos asociados a una receta específica de la base
	 * de datos y actualiza el modelo de tabla eliminando la fila correspondiente.
	 *
	 * @param idrec El identificador de la receta cuyos medicamentos se desean
	 *              eliminar.
	 * @param model El modelo de la tabla (DefaultTableModel) que contiene los datos
	 *              visibles en la interfaz.
	 * @param fila  El índice de la fila en el modelo que se eliminará tras la
	 *              operación.
	 * @throws SQLException Si ocurre un error durante la ejecución de la consulta
	 *                      SQL.
	 */
	public void eliminarMed(int idrec, DefaultTableModel model, int fila) throws SQLException {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		String sqlDelete = "DELETE FROM RECETAMEDICAMENTOS WHERE idReceta = ?";

		try {
			// Primero eliminar los medicamentos
			PreparedStatement psDelete = Conexion.prepareStatement(sqlDelete);
			psDelete.setInt(1, idrec);
			psDelete.executeUpdate();

			int filasAfectadas = psDelete.executeUpdate();

			if (filasAfectadas > 0) {
				// Eliminar la fila del modelo de la tabla
				model.removeRow(fila);
				JOptionPane.showMessageDialog(null, et.getString("mec"), et.getString("ex"),
						JOptionPane.INFORMATION_MESSAGE);
			} else {
				JOptionPane.showMessageDialog(null, et.getString("eem"), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQL") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("eem"), "Error", JOptionPane.ERROR_MESSAGE);
		}

	}

	/**
	 * Modifica una receta existente y añade medicamentos nuevos asociados a ella.
	 * <p>
	 * Actualiza los datos de la receta identificada por {@code idrec} con la
	 * información contenida en {@code recetaAc}. Además, agrega nuevos medicamentos
	 * listados en {@code listaMedicamentos} junto con sus cantidades en
	 * {@code listaCantidades}, evitando duplicados. También actualiza el modelo de
	 * tabla {@code model} para reflejar los cambios visualmente.
	 * </p>
	 * 
	 * @exception SQLException Si ocurre un error de SQL.
	 * @param idrec             Identificador de la receta a modificar.
	 * @param recetaAc          Objeto {@code MReceta} con los datos actualizados de
	 *                          la receta.
	 * @param model             Modelo de tabla {@code DefaultTableModel} que
	 *                          representa la vista de recetas y se actualizará.
	 * @param model2            Segundo modelo de tabla (no usado explícitamente en
	 *                          el método).
	 * @param listaCantidades   Lista de cantidades correspondientes a cada
	 *                          medicamento a añadir.
	 * @param listaMedicamentos Lista de nombres de medicamentos a añadir a la
	 *                          receta.
	 * @param seleccion         Índice de fila en el modelo {@code model} que será
	 *                          actualizado con la nueva información.
	 * @param seleccion1        Parámetro no utilizado (puede ser removido si no es
	 *                          necesario).
	 */

	public static void Modi(int idrec, MReceta recetaAc, DefaultTableModel model, DefaultTableModel model2,
			ArrayList<Integer> listaCantidades, ArrayList<String> listaMedicamentos, int seleccion, int seleccion1) {

		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();

		String sql = "UPDATE Recetas SET idConsulta = ?, fecha = ?, diagnostico = ?, instruccion = ? WHERE idReceta = ?";

		try {
			sentencia = Conexion.prepareStatement(sql);
			sentencia.setInt(1, recetaAc.getIdcita());
			java.sql.Date sqlDate = new java.sql.Date(recetaAc.getFecha().getTime());
			sentencia.setDate(2, sqlDate);
			sentencia.setString(3, recetaAc.getDuracion());
			sentencia.setString(4, recetaAc.getNstruccion());
			sentencia.setInt(5, idrec);

			int filasAfectadas = sentencia.executeUpdate();

			if (filasAfectadas > 0) {
				model.setValueAt(recetaAc.getIdcita(), seleccion, 1);
				model.setValueAt(new SimpleDateFormat("dd/MM/yyyy").format(recetaAc.getFecha()), seleccion, 2);
				model.setValueAt(recetaAc.getDuracion(), seleccion, 3);
				model.setValueAt(recetaAc.getNstruccion(), seleccion, 4);

				cs = Conexion.prepareCall("{ call sp_RegistrarRecetaMedicamento(?, ?, ?) }");

// Para evitar mostrar mensaje repetido, guardamos los ya notificados
				Set<String> yaNotificados = new HashSet<String>();

				for (int i = 0; i < listaMedicamentos.size(); i++) {
					int cantidad = listaCantidades.get(i);
					String nombreMed = listaMedicamentos.get(i);

					if (yaNotificados.contains(nombreMed)) {
						continue;
					}

					String sqlBuscarId = "SELECT idMedicamento FROM Medicamentos WHERE nombre = ?";
					PreparedStatement psBuscar = Conexion.prepareStatement(sqlBuscarId);
					psBuscar.setString(1, nombreMed);
					ResultSet rs = psBuscar.executeQuery();

					if (rs.next()) {
						int idMedicamento = rs.getInt("idMedicamento");

						String sqlExiste = "SELECT COUNT(*) FROM RecetaMedicamentos WHERE idReceta = ? AND idMedicamento = ?";
						PreparedStatement psExiste = Conexion.prepareStatement(sqlExiste);
						psExiste.setInt(1, idrec);
						psExiste.setInt(2, idMedicamento);
						ResultSet rsExiste = psExiste.executeQuery();
						rsExiste.next();
						boolean yaExiste = rsExiste.getInt(1) > 0;
						psExiste.close();

						if (yaExiste) {
							if (!yaNotificados.contains(nombreMed)) {
								JOptionPane.showMessageDialog(null,
										et.getString("emd") + nombreMed + et.getString("yrr"), et.getString("av"),
										JOptionPane.INFORMATION_MESSAGE);
							}
							yaNotificados.add(nombreMed);
							continue;
						}

						try {
							cs.setInt(1, idrec);
							cs.setInt(2, idMedicamento);
							cs.setInt(3, cantidad);
							cs.execute();
						} catch (SQLException ex) {
							String errorMsg = ex.getMessage();
							JOptionPane.showMessageDialog(null, et.getString("em") + nombreMed + "':\n" + errorMsg,
									"Error", JOptionPane.ERROR_MESSAGE);
							return;
						}

					} else {
						JOptionPane.showMessageDialog(null, et.getString("emd") + nombreMed + et.getString("nxb"),
								"Error", JOptionPane.ERROR_MESSAGE);
						return;
					}

					psBuscar.close();
					yaNotificados.add(nombreMed);
				}

				JOptionPane.showMessageDialog(null, et.getString("rmmn"), "Éxito", JOptionPane.INFORMATION_MESSAGE);
			}

		} catch (SQLException e) {
			System.err.println(et.getString("SQLMREC") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("emr"), "Error", JOptionPane.ERROR_MESSAGE);
		} finally {
			try {
				if (sentencia != null)
					sentencia.close();
				if (Conexion != null)
					Conexion.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public static void repbase() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/recetabase.jrxml";
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

	public static void reportehistorialfarmaco(int parseInt) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/historialfar.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();

			parametros.put("idPac", parseInt);

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

	public static void reporteserxrec() {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/recetaxservicio.jrxml";
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

	public static ArrayList<String[]> obtenerMedicamentosPorReceta(int idReceta) {
		ArrayList<String[]> listita = new ArrayList<>();

		try {
			Conexion = ConexionBDSQLServer.GetConexion();
			String sql = "SELECT m.nombre, rm.cantidad " + "FROM RECETAMEDICAMENTOS rm "
					+ "JOIN Medicamentos m ON rm.idMedicamento = m.idMedicamento " + "WHERE rm.idReceta = ?";
			PreparedStatement ps = Conexion.prepareStatement(sql);
			ps.setInt(1, idReceta);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				String nombre = rs.getString("nombre");
				String cantidad = String.valueOf(rs.getInt("cantidad"));
				listita.add(new String[] { nombre, cantidad });
			}

			rs.close();
			ps.close();
			Conexion.close();

		} catch (SQLException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EOM") + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
		}

		return listita;
	}

	/**
	 * Metodo para reinvertir el inventario al modificar y restar lo modificado
	 */
	public static void revertirInventario(int idReceta) throws SQLException {
		Connection conn = ConexionBDSQLServer.GetConexion();

		String sql = "SELECT idMedicamento, cantidad FROM RecetaMedicamentos WHERE idReceta = ?";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setInt(1, idReceta);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			int idMed = rs.getInt("idMedicamento");
			int cantidad = rs.getInt("cantidad");

			String sqlUpdate = "UPDATE Inventario SET CantidadDisp = CantidadDisp + ? WHERE idMedicamento = ?";
			PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
			psUpdate.setInt(1, cantidad);
			psUpdate.setInt(2, idMed);
			psUpdate.executeUpdate();
		}

		ps.close();
		conn.close();
	}

	public static void ModificarActualizado(int idrec, MReceta recetaAc, DefaultTableModel model,
			ArrayList<Integer> listaCantidades, ArrayList<String> listaMedicamentos, int seleccion) {

		Connection conn = null;
		PreparedStatement ps = null;
		CallableStatement cs = null;

		try {
			conn = ConexionBDSQLServer.GetConexion();
			conn.setAutoCommit(false); // Iniciar transacción

			// 1. Revertir inventario anterior
			revertirInventario(idrec);

			// 2. Eliminar medicamentos anteriores
			String sqlDelete = "DELETE FROM RecetaMedicamentos WHERE idReceta = ?";
			ps = conn.prepareStatement(sqlDelete);
			ps.setInt(1, idrec);
			ps.executeUpdate();
			ps.close();

			// 3. Actualizar receta
			String sqlUpdate = "UPDATE Recetas SET idConsulta = ?, fecha = ?, diagnostico = ?, instruccion = ? WHERE idReceta = ?";
			ps = conn.prepareStatement(sqlUpdate);
			ps.setInt(1, recetaAc.getIdcita());
			ps.setDate(2, new java.sql.Date(recetaAc.getFecha().getTime()));
			ps.setString(3, recetaAc.getDuracion());
			ps.setString(4, recetaAc.getNstruccion());
			ps.setInt(5, idrec);
			ps.executeUpdate();
			ps.close();

			// 4. Insertar nuevos medicamentos con PA
			cs = conn.prepareCall("{ call sp_RegistrarRecetaMedicamento(?, ?, ?) }");

			for (int i = 0; i < listaMedicamentos.size(); i++) {
				String nombreMed = listaMedicamentos.get(i);
				int cantidad = listaCantidades.get(i);

				String sqlBuscarId = "SELECT idMedicamento FROM Medicamentos WHERE nombre = ?";
				ps = conn.prepareStatement(sqlBuscarId);
				ps.setString(1, nombreMed);
				ResultSet rsMed = ps.executeQuery();

				if (rsMed.next()) {
					int idMed = rsMed.getInt("idMedicamento");

					try {
						cs.setInt(1, idrec);
						cs.setInt(2, idMed);
						cs.setInt(3, cantidad);
						cs.execute();
					} catch (SQLException ex) {
						conn.rollback();
						JOptionPane.showMessageDialog(null, et.getString("em") + nombreMed + "':\n" + ex.getMessage(),
								et.getString("is"), JOptionPane.ERROR_MESSAGE);
						return;
					}

				} else {
					conn.rollback();
					JOptionPane.showMessageDialog(null, et.getString("emd") + nombreMed + et.getString("ne"), "Error",
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				ps.close();
			}

			conn.commit(); // Confirmar transacción

			// 5. Actualizar tabla visual
			model.setValueAt(recetaAc.getIdcita(), seleccion, 1);
			model.setValueAt(new SimpleDateFormat("dd/MM/yyyy").format(recetaAc.getFecha()), seleccion, 2);
			model.setValueAt(recetaAc.getDuracion(), seleccion, 3);
			model.setValueAt(recetaAc.getNstruccion(), seleccion, 4);

			JOptionPane.showMessageDialog(null, et.getString("rmmn"), "Éxito", JOptionPane.INFORMATION_MESSAGE);

		} catch (SQLException e) {
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
			JOptionPane.showMessageDialog(null, et.getString("emr") + "\n" + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
		} finally {
			try {
				if (cs != null)
					cs.close();
				if (conn != null)
					conn.setAutoCommit(true);
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

	}

	public static int nuevaRecetaImp(MReceta nr, ArrayList<Integer> listaCantidades,
			ArrayList<String> listaMedicamentos) {
		sentencia = null;
		Conexion = ConexionBDSQLServer.GetConexion();
		cs = null;
		String sqlReceta = "INSERT INTO Recetas (idConsulta, fecha, diagnostico, instruccion) VALUES (?, ?, ?, ?)";

		try {
			// 1. Insertar receta
			sentencia = Conexion.prepareStatement(sqlReceta, Statement.RETURN_GENERATED_KEYS);
			sentencia.setInt(1, nr.getIdcita());
			java.sql.Date sqlDate = new java.sql.Date(nr.getFecha().getTime());
			sentencia.setDate(2, sqlDate);
			sentencia.setString(3, nr.getDuracion());
			sentencia.setString(4, nr.getNstruccion());

			int filasAfectadas = sentencia.executeUpdate();
			idReceta = -1;

			if (filasAfectadas > 0) {
				ResultSet rs = sentencia.getGeneratedKeys();
				if (rs.next()) {
					idReceta = rs.getInt(1);
				}
			}

			// Llamar al procedimiento almacenado para cada medicamento
			cs = Conexion.prepareCall("{ call sp_RegistrarRecetaMedicamento(?, ?, ?) }");

			for (int i = 0; i < listaMedicamentos.size(); i++) {
				int cantidad = listaCantidades.get(i);
				String nombreMed = listaMedicamentos.get(i);

				// Buscar el ID del medicamento por nombre
				String sqlIdMed = "SELECT idMedicamento FROM Medicamentos WHERE nombre = ?";
				PreparedStatement psBuscarId = Conexion.prepareStatement(sqlIdMed);
				psBuscarId.setString(1, nombreMed);
				ResultSet rsMed = psBuscarId.executeQuery();

				if (rsMed.next()) {
					int idMedicamento = rsMed.getInt("idMedicamento");

					try {
						cs.setInt(1, idReceta);
						cs.setInt(2, idMedicamento);
						cs.setInt(3, cantidad);
						cs.execute();

					} catch (SQLException ex) {
						String errorMsg = ex.getMessage();
						if (errorMsg.contains(et.getString("ns")) || errorMsg.contains(et.getString("ni"))) {
							JOptionPane.showMessageDialog(null, et.getString("em") + nombreMed + "':\n" + errorMsg,
									et.getString("is"), JOptionPane.ERROR_MESSAGE);
							return -1; // Detener el registro si falla uno
						} else {
							JOptionPane.showMessageDialog(null, et.getString("ei") + nombreMed + "': " + errorMsg,
									"Error", JOptionPane.ERROR_MESSAGE);
							return -1;
						}
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("emd") + nombreMed + et.getString("ne"), "Error",
							JOptionPane.ERROR_MESSAGE);
					return -1;
				}

				psBuscarId.close();
			}

			JOptionPane.showMessageDialog(null, et.getString("rrc"));

		} catch (SQLException e) {
			System.err.println(et.getString("SQL") + e.getMessage());
			JOptionPane.showMessageDialog(null, et.getString("er") + e.getMessage(), "Error",
					JOptionPane.ERROR_MESSAGE);
		} finally {
			try {
				if (sentencia != null)
					sentencia.close();
				if (Conexion != null)
					Conexion.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return idReceta;
	}

	public static void generarReceta(int idRec) {
		Conexion = ConexionBDSQLServer.GetConexion();
		try {
			String reportPath = "src/myReports/Rece.jrxml";
			JasperReport report = JasperCompileManager.compileReport(reportPath);
			Map<String, Object> parametros = new HashMap<String, Object>();

			parametros.put("idRece", idRec);

			JasperPrint print = JasperFillManager.fillReport(report, parametros, Conexion);
			JasperViewer.viewReport(print, false);
		} catch (JRException e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, et.getString("EGP") + e.getMessage());
		}

	}

	public static DefaultComboBoxModel<String> obtenerRecetasPorFecha(Date fecha) {
		// Se inicializa un objeto de tipo DefaultComboBoxModel
		DefaultComboBoxModel<String> modelo = new DefaultComboBoxModel<String>();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String fechaFormateada = sdf.format(fecha);

		try (Connection conn = ConexionBDSQLServer.GetConexion();
				PreparedStatement ps = conn.prepareStatement(
						"SELECT DISTINCT p.nombre + ' ' + p.app + ' ' + ISNULL(p.apm, '') AS nombreCompleto "
								+ "FROM Recetas r " + "JOIN Consultas c ON r.idConsulta = c.idConsulta "
								+ "JOIN Citas ci ON c.idCita = ci.idCita "
								+ "JOIN Pacientes p ON ci.idPaciente = p.idPaciente "
								+ "WHERE CAST(r.fecha AS DATE) = ?")) {

			ps.setString(1, fechaFormateada);
			ResultSet rs = ps.executeQuery();

			modelo.addElement(et.getString("SEL"));
			while (rs.next()) {
				modelo.addElement(rs.getString("nombreCompleto"));
			}

		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, et.getString("EOP") + e.getMessage());
		}

		return modelo;
	}

	public static int buscaridreceta(String nombreCompleto, Date fecha) {

		int idReceta = -1;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String fechaFormateada = sdf.format(fecha);

		String query = "SELECT TOP 1 r.idReceta " + "FROM Recetas r "
				+ "JOIN Consultas c ON r.idConsulta = c.idConsulta " + "JOIN Citas ci ON c.idCita = ci.idCita "
				+ "JOIN Pacientes p ON ci.idPaciente = p.idPaciente " + "WHERE CAST(r.fecha AS DATE) = ? AND "
				+ "      RTRIM(LTRIM(p.nombre + ' ' + p.app + ' ' + ISNULL(p.apm, ''))) = ?";

		try (Connection conn = ConexionBDSQLServer.GetConexion(); PreparedStatement ps = conn.prepareStatement(query)) {

			ps.setString(1, fechaFormateada);
			ps.setString(2, nombreCompleto.trim());

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				idReceta = rs.getInt("idReceta");
			} else {
				JOptionPane.showMessageDialog(null, et.getString("NER"));
			}

		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, et.getString("EBI") + e.getMessage());
		}

		return idReceta;
	}

}
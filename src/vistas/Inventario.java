package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import org.jdesktop.swingx.autocomplete.AutoCompleteDecorator;

import com.toedter.calendar.JDateChooser;

import controladores.Cinventario;
import modelos.MInventario;
import java.awt.Toolkit;

/**
 * Clase que representa la interfaz gráfica para la gestión del inventario de
 * medicamentos.
 * <p>
 * Esta clase extiende {@link JFrame} y proporciona una ventana para visualizar
 * y administrar el inventario de medicamentos disponibles. Incluye componentes
 * para seleccionar medicamentos, indicar cantidades disponibles, mostrar fechas
 * y estados, así como una tabla paginada para listar los registros del
 * inventario.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Inventario extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JLabel jlIdmed;
	private JComboBox<String> JCMedi;
	private DefaultComboBoxModel<String> medicamento;
	private JLabel jlcantdisp;
	private JLabel tituloCit;
	private JSpinner Cantidad;
	private JLabel jlFecha;
	private JLabel jlEstado;
	private JDateChooser Calendario;
	private JTable Tabla;
	private JLabel jlmod;
	private JButton btnsig;
	private JButton btnant;
	private JLabel jlpagina;

	/**
	 * Página actual en la paginación de resultados.
	 */
	private int paginaActual = 1;
	/**
	 * Registros mostrados por paginas
	 */
	private final int registrosPorPagina = 5;
	private int totalPaginas;
	/**
	 * Variable para bandera para cerrar al guardar medicamento desde
	 * {@code vistas.Medicamentos}
	 */
	public boolean cerrarAlGuardar = false;

	/**
	 * Variable que toma el idioma predeterminado del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;

	/**
	 * Botón que permite modificar un elemento de la tabla
	 */
	private JButton btnModificar;
	/**
	 * Botón que permite eliminar un elemento de la tabla
	 */
	private JButton btnEliminar;

	/**
	 * Botón que permite guardar un elemento en la tyabla.
	 */
	private JButton btnGuardar;

	/**
	 * Panel de desplazamiento que contiene el area de texto para ingresar
	 * instrucciones
	 */
	private JScrollPane scrollPane;
	private JLabel lblEstado;
	private JLabel lblLote;
	private JTextField txtlote;
	private int seleccion;
	private int idinv;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Inventario frame = new Inventario();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * 
	 * Configura las propiedades basicas de la ventana.
	 * <p>
	 * Inicializa y agrega las configuraciones visuales de los componentes al
	 * contenedor principal. Establece los componentes Swing como etiquetas, tablas,
	 * campos de texto, botones, calendarios y combo boxes, además de sus eventos
	 * asociados.
	 * </p>
	 * 
	 */
	public Inventario() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Inventario.class.getResource("/imagenes/icons8-en-inventario-24.png")));
		// Se obtiene el idioma predeterminado del sistema
		Idioma = Locale.getDefault();

		// Se cargan los textos traducio¿dos desde un archivo properties
		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 801, 510);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setLocationRelativeTo(null);

		setContentPane(contentPane);
		contentPane.setLayout(null);

		tituloCit = new JLabel(et.getString("inv"));
		tituloCit.setForeground(new Color(0, 0, 139));
		tituloCit.setHorizontalAlignment(SwingConstants.CENTER);
		tituloCit.setFont(new Font("Times New Roman", Font.BOLD, 30));
		tituloCit.setBounds(70, 11, 645, 30);
		contentPane.add(tituloCit);

		jlIdmed = new JLabel(et.getString("Medi"));
		jlIdmed.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlIdmed.setBounds(37, 91, 142, 23);
		contentPane.add(jlIdmed);

		jlcantdisp = new JLabel(et.getString("canti"));
		jlcantdisp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlcantdisp.setBounds(225, 91, 160, 23);
		contentPane.add(jlcantdisp);

		Cantidad = new JSpinner();
		Cantidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		Cantidad.setBounds(252, 124, 70, 30);
		contentPane.add(Cantidad);

		medicamento = new DefaultComboBoxModel<String>();
		medicamento = Cinventario.llenarmedicamentos();

		JCMedi = new JComboBox<String>(medicamento);
		JCMedi.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JCMedi.setBounds(25, 125, 182, 30);
		contentPane.add(JCMedi);
		AutoCompleteDecorator.decorate(this.JCMedi);

		jlFecha = new JLabel(et.getString("fein"));
		jlFecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlFecha.setBounds(420, 92, 126, 23);
		contentPane.add(jlFecha);

		Calendario = new JDateChooser(new Date());
		Calendario.setBounds(401, 125, 139, 30);
		((JTextField) Calendario.getDateEditor().getUiComponent()).setEditable(false);
		contentPane.add(Calendario);

		jlEstado = new JLabel(et.getString("est"));
		jlEstado.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlEstado.setBounds(528, 51, 80, 23);
		contentPane.add(jlEstado);

		btnGuardar = new JButton(et.getString("Gu"));
		// btnGuardar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-floppy-disk-24.png")));
		btnGuardar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnGuardar.setBackground(Color.WHITE);
		btnGuardar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnGuardar.setBounds(100, 190, 139, 30);
		contentPane.add(btnGuardar);

		btnModificar = new JButton(et.getString("mod"));
		// btnModificar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-floppy-disk-24
		// (1).png")));
		btnModificar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnModificar.setBounds(300, 190, 139, 30);
		contentPane.add(btnModificar);

		btnEliminar = new JButton(et.getString("Eli"));
		// btnEliminar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-eliminar-propiedad-24
		// (2).png")));
		btnEliminar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnEliminar.setBounds(500, 190, 139, 30);
		contentPane.add(btnEliminar);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(100, 307, 478, 117);
		contentPane.add(scrollPane);

		Tabla = new JTable();
		scrollPane.setColumnHeaderView(Tabla);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 11));
		jlmod.setBounds(184, 281, 333, 14);
		contentPane.add(jlmod);

		jlpagina = new JLabel(et.getString("pagina"));
		jlpagina.setBounds(500, 424, 84, 14);
		contentPane.add(jlpagina);

		btnsig = new JButton(et.getString("sig"));
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnsig.setBounds(200, 434, 105, 23);
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnant.setBounds(347, 434, 105, 23);
		contentPane.add(btnant);

		lblEstado = new JLabel("");
		lblEstado.setFont(new Font("Tahoma", Font.PLAIN, 14));
		lblEstado.setBounds(594, 51, 160, 20);
		contentPane.add(lblEstado);

		lblLote = new JLabel(et.getString("lote"));
		lblLote.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		lblLote.setBounds(593, 91, 142, 23);
		contentPane.add(lblLote);

		txtlote = new JTextField();
		txtlote.setFont(new Font("Tahoma", Font.PLAIN, 14));
		txtlote.setBounds(572, 124, 143, 30);
		contentPane.add(txtlote);
		txtlote.setColumns(10);

		Seleccion escuchador = new Seleccion();
		Tabla.getSelectionModel().addListSelectionListener(escuchador);

		ManejarBotones escuchadorb = new ManejarBotones();
		btnEliminar.addActionListener(escuchadorb);
		btnGuardar.addActionListener(escuchadorb);
		btnModificar.addActionListener(escuchadorb);
		btnsig.addActionListener(escuchadorb);
		btnant.addActionListener(escuchadorb);

		Manejadorclick eschuchadorc = new Manejadorclick();
		Tabla.addMouseListener(eschuchadorc);
		Manejadorkey escuchadrk = new Manejadorkey();
		txtlote.addKeyListener(escuchadrk);

		MostrarDatos();

		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

	}

	/**
	 * Configura y muestra los datos del inventario de medicamentos en la tabla
	 * gráfica.
	 * <p>
	 * Este método crea un nuevo {@link DefaultTableModel} para la tabla
	 * {@code Tabla}, establece las columnas con etiquetas descriptivas, deshabilita
	 * el reordenamiento de columnas y configura el modo de redimensionamiento
	 * automático.
	 * </p>
	 * <p>
	 * Luego, utiliza un objeto controlador {@code Cinventario} para cargar los
	 * datos paginados correspondientes a la página actual y número de registros por
	 * página.
	 * </p>
	 */
	public void MostrarDatos() {
		DefaultTableModel model;
		model = new DefaultTableModel();// definimos el objeto tableModel

		// Se establece el modelo en la tabla y se agrega las columnas con sus etiquetas
		// localizadas
		Tabla.setModel(model);
		model.addColumn("ID");
		model.addColumn("Medicamento");
		model.addColumn("Cantidad Disponible");
		model.addColumn("Fecha de Ingreso");
		model.addColumn("Estado");
		model.addColumn("Lote");
		// configuración de la tabla
		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		Tabla.getTableHeader().setReorderingAllowed(false);

		// Instancia de clase controladora que carga los datos
		Cinventario inventario = new Cinventario();

		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// medica.buscarUsuariosConTableModel(model);
		inventario.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane.setViewportView(Tabla);

	}

	/**
	 * Clase que implementa para manejar eventos de botones en la interfaz gráfica
	 * del inventario de medicamentos.
	 * <p>
	 * Controla la navegación paginada (botones "anterior" y "siguiente"), así como
	 * las operaciones de guardar, modificar y eliminar registros del inventario.
	 * Incluye validaciones básicas antes de ejecutar las acciones correspondientes,
	 * muestra mensajes de error y actualiza la tabla de datos en la interfaz.
	 * </p>
	 */
	public class ManejarBotones implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent Evento) {
			if (Evento.getSource() == btnant)

			{
				paginaActual--;
				MostrarDatos();
			}
			if (Evento.getSource() == btnsig) {
				paginaActual++;
				MostrarDatos();
			}

			if (Evento.getSource().equals(btnGuardar)) {
				if (Cantidad.getValue().toString().trim().isEmpty() || Calendario.getDate() == null
						|| txtlote.getText().isEmpty() || JCMedi.getSelectedIndex() <= 0) {
					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					MInventario nuevoin = new MInventario();
					// Asignar el nombre del paciente al objeto
					nuevoin.setLote((txtlote.getText().trim()));
					nuevoin.setCantidad((int) Cantidad.getValue());
					nuevoin.setFecha(Calendario.getDate());
					nuevoin.setMedicamento(JCMedi.getSelectedItem().toString());

					boolean exito = Cinventario.agregarinv(nuevoin);

					if (exito) {
						if (cerrarAlGuardar) {
							dispose();
						}
					}
				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorGuardar"), "Error",
							JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					limpiar();
					MostrarDatos();
				}

			}

			if (Evento.getSource().equals(btnModificar)) {
				if (Cantidad.getValue().toString().trim().isEmpty() || Calendario.getDate() == null
						|| txtlote.getText().isEmpty() || JCMedi.getSelectedIndex() <= 0) {
					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionado
					try {
						idinv = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// Asignar el nombre del paciente al objeto
						MInventario actuin = new MInventario();
						actuin.setLote((txtlote.getText().trim()));
						actuin.setCantidad((int) Cantidad.getValue());
						actuin.setFecha(Calendario.getDate());
						actuin.setMedicamento(JCMedi.getSelectedItem().toString());
						Cinventario controlador = new Cinventario();
						controlador.modificarin(idinv, actuin, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("ERM"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneIModi"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					idinv = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cinventario controlador = new Cinventario();
					controlador.eliminarin(idinv, (DefaultTableModel) Tabla.getModel(), seleccion);
					limpiar();
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneIEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				limpiar();
			}

		}

		/**
		 * Limpia y restablece los campos del formulario de inventario a sus valores
		 * iniciales.
		 * <p>
		 * Este método borra el texto del campo lote, establece la cantidad en cero,
		 * resetea la fecha al día actual y selecciona la opción predeterminada
		 * "Seleccione..." en el combo de medicamentos.
		 * </p>
		 */
		private void limpiar() {
			txtlote.setText("");
			Cantidad.setValue(0);
			Calendario.setDate(new Date());
			JCMedi.setSelectedItem(et.getString("SEL"));

		}

	}

	/**
	 * Selecciona un medicamento en el combo {@code JCMedi} basado en el nombre
	 * proporcionado.
	 * <p>
	 * Recorre los elementos del combo y selecciona el que coincida (ignorando
	 * mayúsculas y minúsculas) con el nombre dado. Si no encuentra coincidencia, no
	 * cambia la selección.
	 * </p>
	 * 
	 * @param nombre El nombre del medicamento que se desea seleccionar en el combo.
	 */
	public void seleccionarMedicamentoPorNombre(String nombre) {
		for (int i = 0; i < JCMedi.getItemCount(); i++) {
			String item = JCMedi.getItemAt(i).toString();
			if (item.equalsIgnoreCase(nombre)) {
				JCMedi.setSelectedIndex(i);
				break;
			}
		}
	}

	/**
	 * Clase que implementa para manejar eventos de selección en la tabla de
	 * medicamentos o inventario.
	 * <p>
	 * Esta clase controla la habilitación o deshabilitación de botones de la
	 * interfaz en función de si hay una fila seleccionada en la tabla
	 * {@code Tabla}.
	 * </p>
	 */
	public class Seleccion implements ListSelectionListener {

		/**
		 * Se ejecuta cuando se produce un cambio en la selección de filas de la tabla.
		 * 
		 * @param e el evento que describe el cambio en la selección de la lista.
		 */
		public void valueChanged(ListSelectionEvent e) {
			// TODO Auto-generated method stub

			if (Tabla.getSelectedRow() != -1) {
				// Activar los botones
				btnModificar.setEnabled(true);
				btnEliminar.setEnabled(true);
				btnGuardar.setEnabled(false);
			} else {
				// Desactivar los botones si no hay selección
				btnModificar.setEnabled(false);
				btnEliminar.setEnabled(false);
				btnGuardar.setEnabled(true);
			}
		}

	}

	/**
	 * Clase que implementa {@link MouseListener} para manejar eventos de clic del
	 * mouse sobre la tabla {@code Tabla} en la interfaz de inventario.
	 * 
	 * <p>
	 * Cuando se detecta un clic en una fila de la tabla, se cargan los datos
	 * correspondientes a esa fila en los campos del formulario para permitir su
	 * visualización o edición.
	 * </p>
	 */
	public class Manejadorclick implements MouseListener {
		/**
		 * Se ejecuta al hacer clic con el mouse. Invoca el método para mostrar los
		 * datos de la fila seleccionada en la tabla.
		 *
		 * @param e Evento de mouse clic.
		 */
		@Override
		public void mouseClicked(MouseEvent e) {
			mostrodatos();

		}

		/**
		 * Obtiene los datos de la fila seleccionada en la tabla y los carga en los
		 * campos del formulario. Si no hay fila seleccionada, muestra un mensaje de
		 * error.
		 */
		private void mostrodatos() {

			int filaSeleccionada = Tabla.getSelectedRow();

			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}
			JCMedi.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 1).toString());
			Cantidad.setValue(Integer.parseInt(Tabla.getValueAt(filaSeleccionada, 2).toString()));
			try {
				String fechaString = Tabla.getValueAt(filaSeleccionada, 3).toString();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date fecha = sdf.parse(fechaString);
				Calendario.setDate(fecha);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			txtlote.setText(Tabla.getValueAt(filaSeleccionada, 5).toString());
		}

		@Override
		public void mousePressed(MouseEvent e) {
			// TODO Auto-generated method stub

		}

		@Override
		public void mouseReleased(MouseEvent e) {
			// TODO Auto-generated method stub

		}

		@Override
		public void mouseEntered(MouseEvent e) {
			// TODO Auto-generated method stub

		}

		@Override
		public void mouseExited(MouseEvent e) {
			// TODO Auto-generated method stub

		}

	}

	/**
	 * Actualiza el estado de los botones de navegación de página y la etiqueta que
	 * indica la página actual en la interfaz de usuario.
	 *
	 * <p>
	 * Calcula el total de páginas basado en el número total de registros obtenidos
	 * desde {@code Cmedicos.contarRegistros()} y el número de registros por página.
	 * Luego actualiza la etiqueta de página y habilita o deshabilita los botones
	 * "anterior" y "siguiente" según corresponda.
	 * </p>
	 */
	public void actualizarEstadoBotones() {
		// TODO Auto-generated method stub
		totalPaginas = (int) Math.ceil((double) Cinventario.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

	}

	public class Manejadorkey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == txtlote) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE) {

					JOptionPane.showMessageDialog(null, et.getString("loter"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}
			}
		}

		@Override
		public void keyPressed(KeyEvent e) {
			// TODO Auto-generated method stub

		}

		@Override
		public void keyReleased(KeyEvent e) {
			txtlote.setText(txtlote.getText().toUpperCase());

		}

	}
}
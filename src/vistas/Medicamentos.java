package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
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
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;
//import javax.swing.text.MaskFormatter;

import org.jdesktop.swingx.autocomplete.AutoCompleteDecorator;

import com.toedter.calendar.JDateChooser;

import controladores.Cmedicamento;
import modelos.MMedicamentos;

/**
 * Vista gráfica para el registro de medicamentos.
 * <p>
 * Esta ventana permite ingresar información de nuevos medicamentos para
 * registrarlas en el sistema, mediante la parte visual donde el usuario
 * interactua de forma dinamica con la tabla Recetas.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahí Tapia García
 * 
 * @version 1.0
 * @since 05-06-2025
 */
public class Medicamentos extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	/**
	 * Variable que toma el idioma predeterminado del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;
	/**
	 * Variable Entera para verificacion de JTable
	 */
	private int filaSeleccionada;
	/**
	 * Campo de texto donde el usuario puede ingresar el nombre del medicamento
	 */
	private JTextField textNombre;
	private JLabel jLNom;
	/**
	 * Variable estática que representa la opción seleccionada por el usuario.
	 */
	public static int seleccion;
	/**
	 * Variable que almacena el id del objeto seleccionado para modificar
	 * {@code btnModificar}
	 */
	public static int idMedicamento;
	/**
	 * Variable que almacena el id del objeto seleccionado para eliminar
	 * {@code btnEliminar}
	 */
	public static int idmedi;
	private JLabel jLFecha;
	/**
	 * Selector de fecha (Calendario) para elegir la fecha relacionada al medicameto
	 * (Como vencimiento)
	 */
	private JDateChooser Calendario;
	private JLabel jLPresentacion;
	private JComboBox<String> Presentacion;

	private JButton btnLimpiar;

	/**
	 * Botón que permite guardar un elemento en la tyabla.
	 */
	private JButton btnGuardar;
	/**
	 * Variable que toma la fecha actual en el sistema.
	 */
	private Date Hoy;
	// private MaskFormatter PatronPrecio;
	private JLabel tituloMed;
	/**
	 * Panel de desplazamiento que contiene el area de texto para ingresar
	 * instrucciones
	 */
	private JScrollPane scrollPane;
	/**
	 * Botón que permite modificar un elemento de la tabla
	 */
	private JButton btnModificar;
	/**
	 * Botón que permite eliminar un elemento de la tabla
	 */
	private JButton btnEliminar;
	/**
	 * Tabla que muestra la lista de medicamentos registrados
	 */
	private JTable Tabla;

	private int paginaActual = 1;
	private final int registrosPorPagina = 5;
	private int totalPaginas;
	private JLabel jlpagina;
	private JButton btnsig;
	private JButton btnant;
	private JTextField textBarras;
	private JLabel jlMarca;
	private JLabel jlBarras;
	private JLabel jlmod;
	private JTextField textMarca;
	private JTextField textLab;
	private JTextField textFormula;
	private JTextField textClave;
	private JLabel jlClave;
	private JLabel jlFormula;
	private JLabel jlLab;
	private JButton btnPresentacion;
	private DefaultComboBoxModel<String> prese;
	private Presentaciones abrirP;
	private JLabel jlUnidad;
	private JSpinner Unidad;
	private JLabel jid;
	private JTextField textId;

	/**
	 * Inicia la interfaz gráfica de usuario ejecutando la creación y visualización
	 * del frame principal "Medicamentos".
	 * 
	 * @param args argumentos de linea de comandos.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Medicamentos frame = new Medicamentos();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Inicializa y configura la interfaz gráfica para el registro, modificación y
	 * eliminación de medicamentos.
	 * 
	 * <p>
	 * <b>Entre sus principales funciones están:</b>
	 * <ul>
	 * <li>Inicializar componentes visuales como etiquetas, combo box, spinners y
	 * tabla.</li>
	 * <li>Aplicar internacionalización cargando textos desde archivos .properties
	 * según el idioma del sistema.</li>
	 * <li>Asignar escuchadores de eventos para los botones y campos.</li>
	 * <li>Configura el calendario para el minimo dia a seleccionar.</li>
	 * <li>Configurar la tabla con datos mediante el método
	 * <b>{@code MostrarDatos()}</b>.</li>
	 * </ul>
	 * </p>
	 */
	public Medicamentos() {
		// Inicializacion de la tabla
		Tabla = new JTable();// creamos la instancia de la tabla
		// Se obtiene el idioma predeterminado del sistema
		Idioma = Locale.getDefault();

		// Se cargan los textos traducio¿dos desde un archivo properties
		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		// Configuración de la ventana
		setIconImage(Toolkit.getDefaultToolkit().getImage(Menu.class.getResource("/imagenes/medicamentos.png")));
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(40, 1, 1206, 656);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setToolTipText("");
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setLocationRelativeTo(null);

		setContentPane(contentPane);
		contentPane.setLayout(null);

		// Titulo principal de la ventana
		tituloMed = new JLabel(et.getString("medicamentos"));
		tituloMed.setForeground(new Color(0, 0, 139));
		tituloMed.setHorizontalAlignment(SwingConstants.CENTER);
		tituloMed.setFont(new Font("Times New Roman", Font.BOLD, 30));
		tituloMed.setBounds(364, 27, 532, 30);
		contentPane.add(tituloMed);

		// fecha del día
		Hoy = new Date();

		// Etiqueta yy campo para el nombre del medicamento
		jLNom = new JLabel(et.getString("nomb"));
		jLNom.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jLNom.setBounds(20, 150, 84, 23);
		contentPane.add(jLNom);

		textNombre = new JTextField();
		textNombre.setForeground(new Color(50, 50, 50));
		textNombre.setBackground(Color.WHITE);
		textNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textNombre.setBounds(105, 150, 178, 30);
		contentPane.add(textNombre);
		textNombre.setColumns(10);

		// Calendario para seleccionar la fecha de vencimiento
		Calendario = new JDateChooser();
		Calendario.setBounds(630, 250, 112, 30);
		Calendario.setDateFormatString("dd/MM/yyyy");
		Calendario.setDate(Hoy);
		Calendario.setMinSelectableDate(Hoy);
		((JTextField) Calendario.getDateEditor().getUiComponent()).setEditable(false);
		contentPane.add(Calendario);

		jLFecha = new JLabel(et.getString("Vencimiento"));
		jLFecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jLFecha.setBounds(430, 250, 191, 30);
		contentPane.add(jLFecha);

		// Presentacion del medicamento
		jLPresentacion = new JLabel(et.getString("presentacion"));
		jLPresentacion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jLPresentacion.setBounds(20, 250, 112, 26);
		contentPane.add(jLPresentacion);

		prese = new DefaultComboBoxModel<String>();
		prese = Cmedicamento.llenarprese();

		Presentacion = new JComboBox<String>(prese);
		Presentacion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		Presentacion.setBounds(142, 250, 170, 30);
		contentPane.add(Presentacion);
		AutoCompleteDecorator.decorate(this.Presentacion);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(114, 450, 754, 117);
		contentPane.add(scrollPane);

		Tabla = new JTable();
		scrollPane.setColumnHeaderView(Tabla);
		// Botón para guardar
		btnGuardar = new JButton(et.getString("Gu"));
		// btnGuardar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-floppy-disk-24.png")));
		btnGuardar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnGuardar.setBackground(Color.WHITE);
		btnGuardar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnGuardar.setBounds(1045, 189, 139, 30);
		contentPane.add(btnGuardar);

		// Botón para guardar
		btnModificar = new JButton(et.getString("mod"));
		// btnModificar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-floppy-disk-24
		// (1).png")));
		btnModificar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnModificar.setBounds(1045, 289, 139, 30);
		contentPane.add(btnModificar);

		btnEliminar = new JButton(et.getString("Eli"));
		// btnEliminar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-eliminar-propiedad-24
		// (2).png")));
		btnEliminar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnEliminar.setBounds(1045, 389, 139, 30);
		contentPane.add(btnEliminar);

		btnLimpiar = new JButton(et.getString("limp"));
		btnLimpiar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnLimpiar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnLimpiar.setBackground(Color.WHITE);
		btnLimpiar.setBounds(1045, 489, 139, 30);
		contentPane.add(btnLimpiar);

		jlpagina = new JLabel(et.getString("pagina"));
		jlpagina.setBounds(650, 570, 84, 14);
		contentPane.add(jlpagina);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 11));
		jlmod.setBounds(300, 435, 333, 14);
		contentPane.add(jlmod);

		btnsig = new JButton(et.getString("sig"));
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnsig.setBounds(265, 580, 105, 23);
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnant.setBounds(412, 580, 105, 23);
		contentPane.add(btnant);

		jlBarras = new JLabel(et.getString("code"));
		jlBarras.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlBarras.setBounds(20, 350, 132, 23);
		contentPane.add(jlBarras);

		textBarras = new JTextField();
		textBarras.setBounds(162, 350, 161, 30);
		contentPane.add(textBarras);
		textBarras.setColumns(10);

		SwingUtilities.invokeLater(() -> textBarras.requestFocusInWindow());

		jlMarca = new JLabel(et.getString("marca"));
		jlMarca.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlMarca.setBounds(370, 350, 84, 23);
		contentPane.add(jlMarca);

		textMarca = new JTextField();
		textMarca.setBounds(460, 350, 130, 30);
		contentPane.add(textMarca);
		textMarca.setColumns(10);

		jlLab = new JLabel(et.getString("lab"));
		jlLab.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlLab.setBounds(680, 150, 112, 23);
		contentPane.add(jlLab);

		textLab = new JTextField();
		textLab.setBounds(800, 150, 170, 30);
		contentPane.add(textLab);
		textLab.setColumns(10);

		jlFormula = new JLabel(et.getString("form"));
		jlFormula.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlFormula.setBounds(340, 150, 100, 23);
		contentPane.add(jlFormula);

		textFormula = new JTextField();
		textFormula.setBounds(450, 150, 170, 30);
		contentPane.add(textFormula);
		textFormula.setColumns(10);

		jlClave = new JLabel(et.getString("CR"));
		jlClave.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlClave.setBounds(640, 350, 122, 23);
		contentPane.add(jlClave);

		jid = new JLabel(et.getString("idmedi"));
		jid.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jid.setBounds(40, 40, 132, 23);
		contentPane.add(jid);

		textId = new JTextField();
		textId.setColumns(10);
		textId.setBounds(30, 70, 161, 30);
		contentPane.add(textId);

		textClave = new JTextField();
		textClave.setBounds(770, 350, 170, 30);
		contentPane.add(textClave);
		textClave.setColumns(10);

		jlUnidad = new JLabel(et.getString("dosis"));
		jlUnidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlUnidad.setBounds(805, 250, 76, 23);
		contentPane.add(jlUnidad);

		Unidad = new JSpinner();
		Unidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		Unidad.setBounds(927, 250, 48, 23);
		contentPane.add(Unidad);

		btnPresentacion = new JButton("");
		btnPresentacion.setForeground(Color.WHITE);
		btnPresentacion.setBackground(Color.WHITE);
		btnPresentacion.setIcon(new ImageIcon(Medicamentos.class.getResource("/imagenes/añadirsub.png")));
		btnPresentacion.setBounds(322, 246, 35, 34);
		contentPane.add(btnPresentacion);

		// Configuración de manejadores (Listeners)
		ManejadorBoton Escuchador = new ManejadorBoton();
		btnGuardar.addActionListener(Escuchador);
		btnEliminar.addActionListener(Escuchador);
		btnModificar.addActionListener(Escuchador);
		btnant.addActionListener(Escuchador);
		btnsig.addActionListener(Escuchador);
		btnPresentacion.addActionListener(Escuchador);
		btnLimpiar.addActionListener(Escuchador);

		ManejadorKey EscuchadorKey = new ManejadorKey();
		textNombre.addKeyListener(EscuchadorKey);
		textId.addKeyListener(EscuchadorKey);
		textLab.addKeyListener(EscuchadorKey);
		textMarca.addKeyListener(EscuchadorKey);
		textBarras.addKeyListener(EscuchadorKey);
		textFormula.addKeyListener(EscuchadorKey);
		textClave.addKeyListener(EscuchadorKey);

		Escuchadorc clicked = new Escuchadorc();
		Tabla.addMouseListener(clicked);

		// Estado inicial de los botones
		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

		MostrarDatos();

		// Agrega un listener a la selección de filas de la tabla
		seleccion seleccionm = new seleccion();
		Tabla.getSelectionModel().addListSelectionListener(seleccionm);

		// Componentes
		deshabilitarCampos();

	}

	/**
	 * Clase interna que se implementa, para manejar los cambios en la selección de
	 * filas en la vista.
	 * <p>
	 * Su propósito es habilitar o deshabilitar los botones de acción según si hay
	 * una fila seleccionada o no.
	 * </p>
	 * <b>Botones afectados:</b>
	 * <ul>
	 * <li>btnModificar: habilitado si hay una fila seleccionada</li>
	 * <li>btnEliminar: habilitado si hay una fila seleccionada</li>
	 * <li>btnGuardar: deshabilitado si hay una fila seleccionada</li>
	 * </ul>
	 * 
	 */
	public class seleccion implements ListSelectionListener {
		/**
		 * Se ejecuta cuando se produce un cambio en la selección de filas de la tabla.
		 * 
		 * @param e el evento que describe el cambio en la selección de la lista.
		 */
		public void valueChanged(ListSelectionEvent e) {
			// Verifica que haya una fila seleccionada
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
				btnLimpiar.setEnabled(true);
			}

			if (Tabla.getSelectedRow() != -1) {

				textNombre.setEnabled(true);
				textMarca.setEnabled(true);
				textLab.setEnabled(true);
				textFormula.setEnabled(true);
				textClave.setEnabled(true);
				Calendario.setEnabled(true);
				Presentacion.setEnabled(true);
				Unidad.setEnabled(true);
				btnModificar.setEnabled(true);
				btnEliminar.setEnabled(true);
				btnPresentacion.setEnabled(true);
				textId.setEditable(true);

			}

		}

	}

	/**
	 * Clase que implementa el listener para eventos del Mouse sobre componentes,
	 * específicamente para detectar clics en la tabla de medicamentos.
	 * <p>
	 * Esta clase se utiliza para manejar el evento cuando el usuario hace clic en
	 * una fila de la tabla, y permite cargar los datos del medicamento seleccionado
	 * en los campos del formulario.
	 * </p>
	 * 
	 */
	public class Escuchadorc implements MouseListener {

		/**
		 * Método que se ejecuta cuando se detecta un clic del mouse. Llama al método
		 * <b>{@code mostrodatosmedi()}</b> para mostrar los datos del medicamento
		 * seleccionado en la tabla.
		 *
		 */
		@Override
		public void mouseClicked(MouseEvent e) {
			System.out.println("Entro a la clicked");
			mostrodatosmedi();

		}

		@Override
		public void mousePressed(MouseEvent e) {

		}

		/**
		 * Metodo que implementa <b>{@code Mouselistener}</b> para mejar los clics en la
		 * tabla de medicamentos.
		 * <p>
		 * Permite cargar los datos del medicamento seleccionado en los campos del
		 * formulario. Si no hay una fila seleccionada, muestra un mensaje de error.
		 * </p>
		 * <ul>
		 * 
		 * <li>Muestra un mensaje de error si no hay selección.</li>
		 * <li>Asigna los valores de nombre, dosis, precio, fecha de vencimiento,
		 * presentación y stock a sus respectivos componentes.</li>
		 * </ul>
		 * </p>
		 * <p>
		 * El formato de la fecha se espera en formato <b>{@code yyyy-MM-dd}</b>. Si la
		 * conversión falla, se imprime el error en la consola.
		 * </p>
		 */

		public void mostrodatosmedi() {
			seleccion = Tabla.getSelectedRow();
			filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);

			}
			// Obtener los datos de la fila seleccionada
			textId.setText(Tabla.getValueAt(filaSeleccionada, 0).toString());
			textNombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
			textBarras.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());
			textMarca.setText(Tabla.getValueAt(filaSeleccionada, 3).toString());
			textLab.setText(Tabla.getValueAt(filaSeleccionada, 4).toString());
			textFormula.setText(Tabla.getValueAt(filaSeleccionada, 5).toString());

			try {
				// Asignar la fecha correctamente
				String fechaString = Tabla.getValueAt(filaSeleccionada, 6).toString();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date fecha = sdf.parse(fechaString);
				Calendario.setDate(fecha);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			Unidad.setValue(Integer.parseInt(Tabla.getValueAt(filaSeleccionada, 7).toString()));
			textClave.setText(Tabla.getValueAt(filaSeleccionada, 8).toString());
			Presentacion.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 9).toString());

		}

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
	 * Este metodo muestra en la interfaz lod datos guardados Este metodo configura
	 * el modelo de la tabla.
	 * <p>
	 * Se define un <b>{@code DefaultTableModel}</b> con las columnas
	 * correspondientes a los atributos de los medicamentos, incluyendo ID, nombre,
	 * dosis, precio, vencimiento, presentación y stock.
	 * </p>
	 * <p>
	 * Luego, se instancia un objeto de <b>{@code Cmedicamentos}</b>, el cual carga
	 * los datos el modelo mediante el método
	 * <b>{@code buscadorUsuariosConTableModel()}</b>.
	 * </p>
	 * Se asigna la tabla al <b>{@code JScrollPane}</b> para que se muestre
	 * correctamente en la interfaz.
	 */

	public void MostrarDatos() {
		DefaultTableModel model;
		model = new DefaultTableModel();// definimos el objeto tableModel

		// Se establece el modelo en la tabla y se agrega las columnas con sus etiquetas
		// localizadas
		Tabla.setModel(model);
		model.addColumn("ID");
		model.addColumn(et.getString("nomb"));
		model.addColumn(et.getString("code"));
		model.addColumn(et.getString("marca"));
		model.addColumn(et.getString("lab"));
		model.addColumn(et.getString("form"));
		model.addColumn(et.getString("Vencimiento"));
		model.addColumn(et.getString("dosis"));
		model.addColumn(et.getString("CR"));
		model.addColumn(et.getString("presentacion"));

		// configuración de la tabla
		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		Tabla.getTableHeader().setReorderingAllowed(false);

		// Instancia de clase controladora que carga los datos
		Cmedicamento medica = new Cmedicamento();

		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// medica.buscarUsuariosConTableModel(model);
		medica.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane.setViewportView(Tabla);

	}

	public void actualizarEstadoBotones() {
		// TODO Auto-generated method stub
		totalPaginas = (int) Math.ceil((double) Cmedicamento.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

	}

	/**
	 * Manejador de eventos para los botones en la interfaz. Se encarga de responder
	 * a acciones como agregar, modificar o eliminar un medicamento.
	 * <p>
	 * La clase implementa para manejar los eventos de acción generados al hacer
	 * clic en los botones de una interfaz gráfica relacionada con medicamentos.
	 * </p>
	 * <ul>
	 * <li><b>Guardar</b>: Registra una nueva receta.</li>
	 * <li><b>Modificar</b>: Actualiza los datos de una receta seleccionada.</li>
	 * <li><b>Eliminar</b>: Borra una receta seleccionada de la tabla.</li>
	 * </ul>
	 * <p>
	 * Se utilizan objetos del modelo {@link MMedicamento} para representar la
	 * receta, y del controlador {@link controladores.Cmedicamento} para realizar
	 * operaciones de base de datos.
	 * </p>
	 * 
	 */
	public class ManejadorBoton implements ActionListener {// clase fuera del metodo principal pero dentro de la

		/**
		 * Este método se ejecuta automáticamente cuando se hace clic en cualquiera de
		 * los botones asociados a este ActionListener.
		 * 
		 * @param Evento Evento de acción generada.
		 * @throws Exception Si ocurre un error al guardar los datos en el objeto.
		 */
		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnPresentacion)) {
				abrirP = new Presentaciones();
				abrirP.addWindowListener(new WindowAdapter() {
					@Override
					// para refrescar el combo
					public void windowClosed(WindowEvent e) {
						prese = Cmedicamento.llenarprese();
						Presentacion.setModel(prese);
					}
				});
				abrirP.setVisible(true);

			}

			if (Evento.getSource() == btnant)

			{
				paginaActual--;
				MostrarDatos();
			}
			if (Evento.getSource() == btnsig) {
				paginaActual++;
				MostrarDatos();
			}

			if (Evento.getSource() == btnLimpiar)

			{
				limpiar();

			}

			if (Evento.getSource().equals(btnModificar)) {

				// Acción: Modificar medicamentos existente
				if (textNombre.getText().trim().isEmpty() || Presentacion.getSelectedIndex() <= 0
						|| Calendario == null) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Obtener el ID directamente del campo textId
					idMedicamento = Integer.parseInt(textId.getText().trim());

					// Crear el objeto del modelo
					MMedicamentos modimed = new MMedicamentos();
					modimed.setId(idMedicamento);
					modimed.setNombreMed(textNombre.getText().trim());
					modimed.setFechaVen(Calendario.getDate());
					modimed.setIdPresentacion(Presentacion.getSelectedItem().toString());
					modimed.setCodigoB(textBarras.getText().trim());
					modimed.setClaveR(textClave.getText().trim());
					modimed.setFormula(textFormula.getText().trim());
					modimed.setLaboratorio(textLab.getText().trim());
					modimed.setMarca(textMarca.getText().trim());
					modimed.setMgUnidad((int) Unidad.getValue());

					// Llama al controlador
					Cmedicamento controlador = new Cmedicamento();
					controlador.modificarPacientev2(idMedicamento, modimed);

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("ERM"), et.getString("err"),
							JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					limpiar();
					deshabilitarCampos();
					MostrarDatos();
					SwingUtilities.invokeLater(() -> textBarras.requestFocusInWindow());

				}

				return;

			}

			if (Evento.getSource().equals(btnEliminar)) {
				if (textId.getText().trim().isEmpty()) {
					JOptionPane.showMessageDialog(null, et.getString("DEM"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					idMedicamento = Integer.parseInt(textId.getText().trim());
					Cmedicamento.eliminarmedver2(idMedicamento);

				} catch (Exception e2) {
					JOptionPane.showMessageDialog(null, et.getString("ERE"), "Error", JOptionPane.ERROR_MESSAGE);
					e2.printStackTrace();
				} finally {
					limpiar();
					deshabilitarCampos();
					MostrarDatos();
					SwingUtilities.invokeLater(() -> textBarras.requestFocusInWindow());

				}
			}

			if (Evento.getSource().equals(btnGuardar)) {

				if (textNombre.getText().trim().isEmpty() || Presentacion.getSelectedIndex() <= 0
						|| Calendario == null) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				try {
					// Crear un nuevo objeto MPaciente
					MMedicamentos nuevomedicamento = new MMedicamentos();
					// Asignar el nombre del paciente al objeto
					// Cambiar elnuevoMedic
					nuevomedicamento.setId(Integer.parseInt(textId.getText().trim()));
					nuevomedicamento.setNombreMed(textNombre.getText().trim());
					nuevomedicamento.setFechaVen(Calendario.getDate());
					nuevomedicamento.setIdPresentacion(Presentacion.getSelectedItem().toString());
					nuevomedicamento.setCodigoB(textBarras.getText().trim());
					nuevomedicamento.setClaveR(textClave.getText().trim());
					nuevomedicamento.setFormula(textFormula.getText().trim());
					nuevomedicamento.setLaboratorio(textLab.getText().trim());
					nuevomedicamento.setMarca(textMarca.getText().trim());
					nuevomedicamento.setMgUnidad((int) Unidad.getValue());

					// Llamar al método estático para añadir el paciente
					Cmedicamento.AnMedi(nuevomedicamento);

					// Preguntar al usuario si desea agregar inventario
					int respuesta = JOptionPane.showConfirmDialog(null, et.getString("AGRI"), et.getString("AIN"),
							JOptionPane.YES_NO_OPTION);

					if (respuesta == JOptionPane.YES_OPTION) {
						Inventario ventanaInv = new Inventario();
						ventanaInv.setVisible(true);
						ventanaInv.cerrarAlGuardar = true;
						ventanaInv.seleccionarMedicamentoPorNombre(textNombre.getText().trim());
					}

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorGuardar"), et.getString("err"),
							JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					/* Actualizamos siempre las tablas despues del registro */

					limpiar();
					deshabilitarCampos();
					MostrarDatos();
					SwingUtilities.invokeLater(() -> textBarras.requestFocusInWindow());

				}
			}
		}
	}

	/**
	 * 
	 * Restablece los campos del formulario a sus valores iniciales.
	 * <p>
	 * Este método se utiliza para limpiar el contenido ingresado por el usuario y
	 * preparar el formulario para una nueva entrada.
	 * </p>
	 */
	public void limpiar() {

		textId.setText("");
		textNombre.setText("");
		textLab.setText("");
		textMarca.setText("");
		textBarras.setText("");
		textFormula.setText("");
		Calendario.setDate(new Date()); // reinicia al día de hoy
		Unidad.setValue(0);
		textClave.setText("");
		Presentacion.setSelectedItem(et.getString("SEL"));

	}

	/**
	 * Clase que implementa {@code KeyListener} para manejar eventos de teclado en
	 * campos específicos.
	 * <p>
	 * Controla la validación de caracteres ingresados en los campos
	 * {@code textNombre} y {@code textId}, mostrando mensajes de error si se
	 * ingresan caracteres inválidos. Además, detecta la tecla Enter para buscar un
	 * medicamento por código de barras y actualizar la interfaz gráfica con sus
	 * datos.
	 * </p>
	 */
	public class ManejadorKey implements KeyListener {

		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == textNombre) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE) {

					JOptionPane.showMessageDialog(null, et.getString("nombre"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}

			}
			if (EventKey.getSource() == textId) {

				if (!Character.isDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE) {

					JOptionPane.showMessageDialog(null, et.getString("SAN"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}

			}

			if (EventKey.getSource() == textLab) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textLab.getText().trim().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nombre"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textLab.requestFocus();
				}
			}
			if (EventKey.getSource() == textFormula) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != ','
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textFormula.getText().trim().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nom3"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textFormula.requestFocus();

				}
			}
			if (EventKey.getSource() == textClave) {
				if (!Character.isDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != '.'
						|| textClave.getText().trim().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("clav"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textClave.requestFocus();
				}
			}
			if (EventKey.getSource() == textMarca) {
				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textMarca.getText().trim().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nombre"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textMarca.requestFocus();
				}
			}
		}

		@Override
		public void keyPressed(KeyEvent e) {
			// codigo de barra

			if (e.getKeyCode() == KeyEvent.VK_ENTER) {
				String codigo = textBarras.getText().trim();
				MMedicamentos med = Cmedicamento.buscarPorCodigoBarras(codigo);

				if (med != null) {
					// Mostrar datos si se encontró
					textId.setText(String.valueOf(med.getId()));
					textNombre.setText(med.getNombreMed());
					textMarca.setText(med.getMarca());
					textLab.setText(med.getLaboratorio());
					textFormula.setText(med.getFormula());
					textClave.setText(med.getClaveR());
					Calendario.setDate(med.getFechaVen());
					Unidad.setValue(med.getMgUnidad());
					Presentacion.setSelectedItem(med.getPresentacion());

					habilitarCampos();
					btnModificar.setEnabled(true);
					btnEliminar.setEnabled(true);
					btnGuardar.setEnabled(false);
					JOptionPane.showMessageDialog(null, et.getString("MedEN"));
				} else {
					limpiar2();
					habilitarCampos();
					btnGuardar.setEnabled(true);
					btnModificar.setEnabled(false);
					btnEliminar.setEnabled(false);
					JOptionPane.showMessageDialog(null, et.getString("MedNoEN"));
					SwingUtilities.invokeLater(() -> textId.requestFocusInWindow());

				}
			}

		}

		/**
		 * Restablece el formulario de medicamento a su estado inicial.
		 * <p>
		 * Limpia todos los campos del formulario de medicamento, restableciendo valores
		 * a sus estados iniciales o vacíos. La fecha se resetea a la fecha actual, y
		 * unidades se establece en 1.
		 * </p>
		 */
		public void limpiar2() {

			textId.setText("");
			textNombre.setText("");
			textLab.setText("");
			textMarca.setText("");
			textFormula.setText("");
			Calendario.setDate(new Date()); // reinicia al día de hoy
			Unidad.setValue(1);
			textClave.setText("");
			Presentacion.setSelectedItem(et.getString("SEL"));

		}

		/**
		 * Activa todos los campos y botones necesarios para la entrada o modificación
		 * de datos de medicamentos.
		 * <p>
		 * Habilita todos los campos de entrada y botones relacionados con la gestión de
		 * medicamentos, permitiendo al usuario introducir o modificar datos.
		 * </p>
		 */

		public void habilitarCampos() {
			textNombre.setEnabled(true);
			textMarca.setEnabled(true);
			textLab.setEnabled(true);
			textFormula.setEnabled(true);
			textClave.setEnabled(true);
			Calendario.setEnabled(true);
			Presentacion.setEnabled(true);
			Unidad.setEnabled(true);
			btnPresentacion.setEnabled(true);
			textId.setEditable(true);

		}

		@Override
		public void keyReleased(KeyEvent e) {
			// TODO Auto-generated method stub

		}

	}

	/**
	 * Controla la desactivación de todos los campos y botones relacionados con la
	 * gestión de medicamentos.
	 * <p>
	 * Deshabilita todos los campos de entrada y botones relacionados con la gestión
	 * de medicamentos, para evitar modificaciones o entradas de datos por parte del
	 * usuario.
	 * </p>
	 */
	public void deshabilitarCampos() {
		textNombre.setEnabled(false);
		textMarca.setEnabled(false);
		textLab.setEnabled(false);
		textFormula.setEnabled(false);
		textClave.setEnabled(false);
		Calendario.setEnabled(false);
		Presentacion.setEnabled(false);
		Unidad.setEnabled(false);
		btnGuardar.setEnabled(false);
		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnPresentacion.setEnabled(false);
		textId.setEditable(false);

	}

}
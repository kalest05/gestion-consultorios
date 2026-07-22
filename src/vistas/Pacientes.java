package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.ButtonGroup;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.MaskFormatter;

import org.jdesktop.swingx.autocomplete.AutoCompleteDecorator;

import com.toedter.calendar.JDateChooser;

import controladores.Cpacientes;
import modelos.MPaciente;

/**
 * Clase que representa la interfaz gráfica para la gestión de pacientes.
 * <p>
 * Esta clase extiende y proporciona una ventana para la visualización,
 * creación, modificación y eliminación de registros de pacientes. Incluye
 * formularios para la captura de datos personales, tabla para mostrar los
 * pacientes existentes, y funcionalidades de validación, búsqueda y paginación.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Pacientes extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	/**
	 * Variable que determina el idioma del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable que busca el diccionario del idioma en el paquete {@link properties}
	 */
	private static ResourceBundle et;
	private JLabel jlfecha;
	private JLabel jltitulo;
	private JTextField textNombre;
	private JLabel jlnombre;
	private JLabel jlapp;
	private JTextField textApp;
	private JTextField textApm;
	/**
	 * Variable de tipo Date para validar el componente de JDateChooser
	 */
	private Date Hoy;
	private JLabel jlapm;
	private JDateChooser Calendario;
	private JTextField textCURP;
	private JLabel jlcurp;
	private JSpinner edad;
	private JLabel jledad;
	private JLabel jlgenero;
	private JRadioButton Femenino;
	private JRadioButton Masculino;
	/**
	 * Variable de tipo {@code ButtonGroup} para agrupar jradio button.
	 */
	private ButtonGroup AgrupadorBootonbox = new ButtonGroup();
	private JLabel jlmunicipio;
	private JTextField textNomCalle;
	private JLabel jllocalidad;
	private JLabel jlnumcalle;
	private JLabel jlreligion;
	private JComboBox<String> religion_1;
	private JLabel jltelefono;
	private JTextField textTelefono;
	private JButton btnGuardar;
	private JTable Tabla;
	private JScrollPane scrollPane;
	private JButton btnModificar;
	private JButton btnEliminar;
	/**
	 * Variable que almacena el registro seleccionado en la tabla
	 */
	public int seleccion;
	/**
	 * Variable de tipo {@code MaskFormatter} para crear formato de telefono.
	 */
	private MaskFormatter PatronTelefono;
	private JComboBox<String> municipio;
	private JComboBox<String> localidad;
	private JTextField textNumex;
	private JLabel jlalergia;
	private JButton btnsig;
	private JButton btnLimpiar;

	private JButton btnant;
	/**
	 * Variable de tipo entero para guardar el numero de pagina en
	 * <b>"Paginación"</b>
	 */
	private int paginaActual = 1;
	/**
	 * Variable de tipo entero para almacenar cuantos registros por pagina se pueden
	 * visualizar
	 */
	private final int registrosPorPagina = 4;
	private JTextField Sangre;
	private JLabel jlsangre;
	private int totalPaginas;
	private JLabel jlpagina;
	private JLabel jlmod;
	private JCheckBox chno;
	private JLabel jlnumext;
	/**
	 * Variable para cargar el objeto de jcombobox y cargar los municipios
	 */
	public DefaultComboBoxModel<String> DatosJcomboxMunicipios;
	/**
	 * Variable para cargar el objeto de jcombobox y cargar localidades segun el
	 * municipio seleccionado
	 */
	public DefaultComboBoxModel<String> DatosJcomboxPoblacion;
	/**
	 * Variable para cargar las religiones insertadas
	 */
	public DefaultComboBoxModel<String> datosreligion;
	private JTextField txtAlergias;
	private JButton btnreligion;
	/**
	 * Variable de tipo Religion para abrir ventana hija
	 */
	private Religion abrirR;
	private JLabel lblNewLabel;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Pacientes frame = new Pacientes();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Constructor de componentes de la interfaz visual.
	 */
	public Pacientes() {
		Tabla = new JTable();// creamos la instancia de la tabla
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setIconImage(Toolkit.getDefaultToolkit().getImage(Menu.class.getResource("/imagenes/informe-medico.png")));

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(40, 1, 1206, 656);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setToolTipText("");
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setLocationRelativeTo(null);

		setContentPane(contentPane);
		contentPane.setLayout(null);

		jlnombre = new JLabel(et.getString("nom"));
		jlnombre.setBounds(20, 126, 125, 21);
		jlnombre.setForeground(new Color(50, 50, 50));
		jlnombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlnombre);

		textNombre = new JTextField();
		textNombre.setBounds(10, 158, 209, 30);
		textNombre.setHorizontalAlignment(SwingConstants.CENTER);
		textNombre.setForeground(new Color(50, 50, 50));
		textNombre.setBackground(new Color(255, 255, 255));
		textNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(textNombre);
		textNombre.setColumns(10);

		jltitulo = new JLabel(et.getString("pacientes"));
		jltitulo.setBounds(334, 40, 555, 30);
		jltitulo.setForeground(new Color(0, 0, 139));
		jltitulo.setHorizontalAlignment(SwingConstants.CENTER);
		jltitulo.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(jltitulo);

		textApp = new JTextField();
		textApp.setBounds(270, 158, 209, 30);
		textApp.setBackground(new Color(255, 255, 255));
		textApp.setForeground(new Color(50, 50, 50));
		textApp.setHorizontalAlignment(SwingConstants.CENTER);
		textApp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(textApp);
		textApp.setColumns(10);

		textApm = new JTextField();
		textApm.setBounds(530, 158, 209, 30);
		textApm.setBackground(new Color(255, 255, 255));
		textApm.setForeground(new Color(50, 50, 50));
		textApm.setHorizontalAlignment(SwingConstants.CENTER);
		textApm.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(textApm);
		textApm.setColumns(10);

		jlapp = new JLabel(et.getString("app"));
		jlapp.setBounds(280, 126, 194, 21);
		jlapp.setForeground(new Color(50, 50, 50));
		jlapp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlapp);

		jlapm = new JLabel(et.getString("apm"));
		jlapm.setBounds(540, 126, 204, 30);
		jlapm.setForeground(new Color(50, 50, 50));
		jlapm.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlapm);

		Hoy = new Date();
		Calendario = new JDateChooser();
		Calendario.setBounds(790, 156, 99, 25);
		Calendario.setDateFormatString("dd/MM/yyyy");
		Calendario.setDate(Hoy);
		Calendario.setMaxSelectableDate(Hoy);
		((JTextField) Calendario.getDateEditor().getUiComponent()).setEditable(false);
		contentPane.add(Calendario);

		jlfecha = new JLabel(et.getString("fec"));
		jlfecha.setBounds(800, 126, 197, 21);
		jlfecha.setForeground(new Color(50, 50, 50));
		jlfecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlfecha);

		jlcurp = new JLabel(et.getString("curp"));
		jlcurp.setBounds(20, 221, 65, 21);
		jlcurp.setForeground(new Color(50, 50, 50));
		jlcurp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlcurp);

		textCURP = new JTextField();
		textCURP.setBounds(10, 243, 209, 30);
		textCURP.setBackground(new Color(255, 255, 255));
		textCURP.setForeground(new Color(50, 50, 50));
		textCURP.setHorizontalAlignment(SwingConstants.CENTER);
		textCURP.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(textCURP);
		textCURP.setColumns(10);

		jledad = new JLabel(et.getString("edad"));
		jledad.setBounds(280, 221, 46, 21);
		jledad.setForeground(new Color(50, 50, 50));
		jledad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jledad);

		edad = new JSpinner();
		edad.setBounds(270, 248, 68, 30);
		edad.setForeground(new Color(50, 50, 50));
		edad.setBackground(new Color(255, 228, 225));
		edad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		((JSpinner.DefaultEditor) edad.getEditor()).getTextField().setEditable(false);
		contentPane.add(edad);

		jlgenero = new JLabel(et.getString("gen"));
		jlgenero.setBounds(460, 221, 65, 19);
		jlgenero.setForeground(new Color(50, 50, 50));
		jlgenero.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlgenero);

		Femenino = new JRadioButton(et.getString("f"));
		Femenino.setBounds(400, 250, 97, 30);
		Femenino.setForeground(SystemColor.textHighlightText);
		Femenino.setBackground(new Color(0, 0, 139));
		AgrupadorBootonbox.add(Femenino);
		Femenino.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(Femenino);

		Masculino = new JRadioButton(et.getString("m"));
		Masculino.setBounds(510, 250, 97, 30);
		Masculino.setForeground(SystemColor.textHighlightText);
		Masculino.setBackground(new Color(0, 0, 139));
		AgrupadorBootonbox.add(Masculino);
		Masculino.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(Masculino);

		jlmunicipio = new JLabel(et.getString("mun"));
		jlmunicipio.setBounds(230, 316, 92, 21);
		jlmunicipio.setForeground(new Color(50, 50, 50));
		jlmunicipio.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlmunicipio);

		jllocalidad = new JLabel(et.getString("loc"));
		jllocalidad.setBounds(400, 316, 114, 21);
		jllocalidad.setForeground(new Color(50, 50, 50));
		jllocalidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jllocalidad);

		jlnumcalle = new JLabel(et.getString("numCalle"));
		jlnumcalle.setBounds(660, 316, 139, 21);
		jlnumcalle.setForeground(new Color(50, 50, 50));
		jlnumcalle.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlnumcalle);

		textNomCalle = new JTextField();
		textNomCalle.setBounds(650, 336, 256, 30);
		textNomCalle.setBackground(new Color(255, 255, 255));
		textNomCalle.setForeground(new Color(50, 50, 50));
		textNomCalle.setHorizontalAlignment(SwingConstants.CENTER);
		textNomCalle.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(textNomCalle);
		textNomCalle.setColumns(10);

		jlreligion = new JLabel(et.getString("rel"));
		jlreligion.setBounds(660, 221, 115, 21);
		jlreligion.setForeground(new Color(50, 50, 50));
		jlreligion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlreligion);

		datosreligion = new DefaultComboBoxModel<String>();
		datosreligion = Cpacientes.llenareligion();

		religion_1 = new JComboBox<String>(datosreligion);
		religion_1.setBounds(650, 250, 130, 30);
		religion_1.setBackground(new Color(255, 250, 250));
		religion_1.setForeground(new Color(50, 50, 50));
		religion_1.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(religion_1);
		AutoCompleteDecorator.decorate(this.religion_1);

		jltelefono = new JLabel(et.getString("tel"));
		jltelefono.setBounds(20, 316, 142, 21);
		jltelefono.setForeground(new Color(50, 50, 50));
		jltelefono.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jltelefono);
		try {
			PatronTelefono = new MaskFormatter("(###) ###-####");
		} catch (ParseException e) {
			// formato telefono
			e.printStackTrace();
		}
		textTelefono = new JFormattedTextField(PatronTelefono);
		textTelefono.setBounds(10, 336, 156, 30);
		textTelefono.setBackground(new Color(255, 255, 255));
		textTelefono.setForeground(new Color(50, 50, 50));
		textTelefono.setFont(new Font("Comic Sans MS", Font.PLAIN, 13));
		contentPane.add(textTelefono);
		textTelefono.setColumns(10);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(55, 486, 1097, 91);
		contentPane.add(scrollPane);

		Tabla = new JTable();
		scrollPane.setColumnHeaderView(Tabla);

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
		btnModificar.setBounds(1045, 261, 139, 30);
		contentPane.add(btnModificar);

		btnEliminar = new JButton(et.getString("Eli"));
		// btnEliminar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-eliminar-propiedad-24
		// (2).png")));
		btnEliminar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnEliminar.setBounds(1045, 321, 139, 30);
		contentPane.add(btnEliminar);

		btnLimpiar = new JButton(et.getString("limp"));
		btnLimpiar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnLimpiar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnLimpiar.setBackground(Color.WHITE);
		btnLimpiar.setBounds(1045, 381, 139, 30);
		contentPane.add(btnLimpiar);
		DatosJcomboxMunicipios = new DefaultComboBoxModel<String>();
		DatosJcomboxPoblacion = new DefaultComboBoxModel<String>();

		DatosJcomboxMunicipios = Cpacientes.LlenarComboBoxMun();
		DatosJcomboxPoblacion = Cpacientes.LlenarComboBoxPob(DatosJcomboxMunicipios.getSelectedItem().toString());

		municipio = new JComboBox<String>(DatosJcomboxMunicipios);
		municipio.setBounds(176, 336, 194, 30);
		contentPane.add(municipio);
		AutoCompleteDecorator.decorate(this.municipio);

		localidad = new JComboBox<String>(DatosJcomboxPoblacion);
		localidad.setBounds(390, 336, 216, 30);
		contentPane.add(localidad);
		AutoCompleteDecorator.decorate(this.localidad);

		jlnumext = new JLabel(et.getString("numext"));
		jlnumext.setBounds(20, 406, 197, 21);
		jlnumext.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlnumext);

		textNumex = new JTextField();
		textNumex.setBounds(10, 430, 156, 30);
		contentPane.add(textNumex);
		textNumex.setColumns(10);

		jlalergia = new JLabel(et.getString("aler"));
		jlalergia.setBounds(200, 406, 122, 22);
		jlalergia.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlalergia);

		chno = new JCheckBox(et.getString("no"));
		chno.setBounds(225, 428, 52, 31);
		chno.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(chno);

		txtAlergias = new JTextField();
		txtAlergias.setBounds(293, 435, 130, 21);
		txtAlergias.setVisible(false);
		contentPane.add(txtAlergias);
		txtAlergias.setColumns(10);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setBounds(303, 467, 333, 14);
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 11));
		contentPane.add(jlmod);

		btnsig = new JButton(et.getString("sig"));
		btnsig.setBounds(331, 580, 105, 35);
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setBounds(562, 580, 105, 35);
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		contentPane.add(btnant);

		btnreligion = new JButton("");
		btnreligion.setBackground(Color.WHITE);
		btnreligion.setIcon(new ImageIcon(Pacientes.class.getResource("/imagenes/añadirsub.png")));
		btnreligion.setBounds(790, 248, 37, 35);
		contentPane.add(btnreligion);

		jlpagina = new JLabel(et.getString("pagina"));
		jlpagina.setBounds(967, 580, 79, 14);
		contentPane.add(jlpagina);

		Sangre = new JTextField();
		Sangre.setBounds(871, 248, 79, 25);
		Sangre.setBackground(new Color(255, 255, 255));
		Sangre.setForeground(new Color(50, 50, 50));
		Sangre.setHorizontalAlignment(SwingConstants.CENTER);
		Sangre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(Sangre);

		jlsangre = new JLabel(et.getString("San"));
		jlsangre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlsangre.setBounds(871, 221, 126, 21);
		contentPane.add(jlsangre);

		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

		lblNewLabel = new JLabel(et.getString("si"));
		lblNewLabel.setBounds(154, 391, 325, 14);
		contentPane.add(lblNewLabel);

		MostrarDatos();

		ManejadorBoton Escuchador = new ManejadorBoton();
		btnGuardar.addActionListener(Escuchador);
		btnEliminar.addActionListener(Escuchador);
		btnModificar.addActionListener(Escuchador);
		btnant.addActionListener(Escuchador);
		btnsig.addActionListener(Escuchador);
		btnreligion.addActionListener(Escuchador);
		btnLimpiar.addActionListener(Escuchador);

		ManejadorKey escuchadork = new ManejadorKey();
		textNombre.addKeyListener(escuchadork);
		textApp.addKeyListener(escuchadork);
		textApm.addKeyListener(escuchadork);
		textNomCalle.addKeyListener(escuchadork);
		textNumex.addKeyListener(escuchadork);
		textCURP.addKeyListener(escuchadork);
		Sangre.addKeyListener(escuchadork);

		ManejadorFocus EscuchadorFocus = new ManejadorFocus();
		textTelefono.addFocusListener(EscuchadorFocus);
		textCURP.addFocusListener(EscuchadorFocus);

		escuchadorc Click = new escuchadorc();
		Tabla.addMouseListener(Click);

		ManejadorCombox EscuchadorComboBox = new ManejadorCombox();
		municipio.addItemListener(EscuchadorComboBox);

		chno.addItemListener(EscuchadorComboBox);
		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);

	}

	/**
	 * Muestra los datos de los pacientes en una tabla dentro de la interfaz
	 * gráfica.
	 * <p>
	 * Este método configura un {@link DefaultTableModel} con las columnas
	 * correspondientes a los atributos de un paciente, utiliza el controlador
	 * {@code Cpacientes} para llenar el modelo con los datos de la base de datos,
	 * considerando la paginación definida por {@code paginaActual} y
	 * {@code registrosPorPagina}.
	 * </p>
	 */
	public void MostrarDatos() {
		DefaultTableModel model = new DefaultTableModel();// definimos el objeto tableModel;
		Tabla.setModel(model);
		model.addColumn("ID"); // idPaciente
		model.addColumn(et.getString("nom"));
		model.addColumn(et.getString("app"));
		model.addColumn(et.getString("apm"));
		model.addColumn(et.getString("fec")); // fecNac
		model.addColumn(et.getString("edad")); // edad
		model.addColumn(et.getString("curp"));
		model.addColumn(et.getString("gen")); // genero
		model.addColumn(et.getString("aLER")); // alergias
		model.addColumn(et.getString("San")); // tipoSangre
		model.addColumn(et.getString("mun"));
		model.addColumn(et.getString("loc"));
		model.addColumn(et.getString("numc"));
		model.addColumn(et.getString("nocall"));
		model.addColumn(et.getString("rel"));
		model.addColumn(et.getString("tel"));

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Cpacientes pacientes = new Cpacientes();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		pacientes.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane.setViewportView(Tabla);

	}

	public class Seleccion implements ListSelectionListener {

		@Override
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
	 * Clase que implementa {@link ItemListener} para manejar eventos de cambio en
	 * elementos de tipo {@code JComboBox} y de selección en un {@code JCheckBox}.
	 * <p>
	 * Esta clase actualiza dinámicamente el contenido del combobox
	 * {@code localidad} según la selección realizada en el combobox
	 * {@code municipio}. Además, gestiona la visibilidad y estado del campo de
	 * texto {@code txtAlergias} según si el checkbox {@code chno} está
	 * seleccionado.
	 * </p>
	 * <p>
	 * Si el checkbox {@code chno} está seleccionado, se habilita el campo
	 * {@code txtAlergias} y se cambia el texto a "Sí". De lo contrario, se oculta y
	 * deshabilita el campo, y se limpia su contenido.
	 * </p>
	 */
	private class ManejadorCombox implements ItemListener {

		@Override
		public void itemStateChanged(ItemEvent EvetComboBox) {
			if (EvetComboBox.getSource().equals(municipio)) {
				DatosJcomboxPoblacion = Cpacientes
						.LlenarComboBoxPob(DatosJcomboxMunicipios.getSelectedItem().toString());
				localidad.setModel(DatosJcomboxPoblacion);
			}
			if (chno.isSelected()) {
				chno.setText(et.getString("Si"));
				txtAlergias.setVisible(true);
				txtAlergias.setEnabled(true);
			} else {
				chno.setText("No");
				txtAlergias.setVisible(false);
				txtAlergias.setEnabled(false);
				txtAlergias.setText("");
			}

		}
	}

	/**
	 * Actualiza el estado de los botones de navegación de páginas en la interfaz.
	 * <p>
	 * Este método calcula el número total de páginas basado en la cantidad de
	 * registros obtenidos desde la base de datos mediante el controlador
	 * {@code Cpacientes} la cantidad de registros mostrados por página
	 * <b>{@code registrosPorPagina}</b>.
	 * </p>
	 */
	public void actualizarEstadoBotones() {
		// TODO Auto-generated method stub
		totalPaginas = (int) Math.ceil((double) Cpacientes.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

	}

	/**
	 * Clase que implementa {@link MouseListener} para escuchar clics en la tabla de
	 * pacientes.
	 * <p>
	 * Cuando el usuario hace clic sobre una fila, se recuperan los datos de esa
	 * fila y se cargan en los campos correspondientes del formulario para su
	 * edición o visualización.
	 * </p>
	 * <b> Método invocado cuando se hace clic sobre la tabla. <b/>
	 */
	public class escuchadorc implements MouseListener {

		public void mouseClicked(MouseEvent e) {
			mostrodatos();

		}// mouse clicked

		private void mostrodatos() {
			seleccion = Tabla.getSelectedRow();
			int filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}

			// Obtener los datos de la fila seleccionada

			textNombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
			textApp.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());
			textApm.setText(Tabla.getValueAt(filaSeleccionada, 3).toString());

			try {
				String fechaString = Tabla.getValueAt(filaSeleccionada, 4).toString();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date fecha = sdf.parse(fechaString);
				Calendario.setDate(fecha);
			} catch (ParseException e) {
				e.printStackTrace();
			}

			edad.setValue(Integer.parseInt(Tabla.getValueAt(filaSeleccionada, 5).toString()));
			textCURP.setText(Tabla.getValueAt(filaSeleccionada, 6).toString());

			String gen = Tabla.getValueAt(filaSeleccionada, 7).toString();
			if (gen.equalsIgnoreCase("Femenino")) {
				Femenino.setSelected(true);
			} else if (gen.equalsIgnoreCase("Masculino")) {
				Masculino.setSelected(true);
			}

			String alergia = Tabla.getValueAt(filaSeleccionada, 8).toString();
			if (alergia.equalsIgnoreCase("No tiene Alergias")) {
				chno.setSelected(false);
				chno.setText("No");
				txtAlergias.setText("");
				txtAlergias.setVisible(false);
				txtAlergias.setEnabled(false);
			} else {
				chno.setSelected(true);
				chno.setText("Sí");
				txtAlergias.setText(alergia);
				txtAlergias.setVisible(true);
				txtAlergias.setEnabled(true);
			}

			Sangre.setText(Tabla.getValueAt(filaSeleccionada, 9).toString().toString());
			municipio.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 10).toString());
			localidad.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 11).toString());
			textNomCalle.setText(Tabla.getValueAt(filaSeleccionada, 13).toString());
			textNumex.setText(Tabla.getValueAt(filaSeleccionada, 12).toString());
			religion_1.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 14).toString());
			textTelefono.setText(Tabla.getValueAt(filaSeleccionada, 15).toString());
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
	 * Clase que implementa {@link ActionListener} para manejar los eventos de los
	 * botones de la interfaz de gestión de pacientes.
	 * <p>
	 * Dependiendo del botón que se presione, este manejador realiza operaciones
	 * como: abrir la ventana para registrar una nueva religión, navegar entre
	 * páginas de pacientes, modificar, eliminar, limpiar el formulario o guardar un
	 * nuevo paciente.
	 * </p>
	 * * Maneja las acciones de los botones en la interfaz.
	 * <ul>
	 * <li>{@code btnreligion}: Abre la ventana para registrar una religión y
	 * actualiza el combo al cerrarla.</li>
	 * <li>{@code btnant}: Cambia a la página anterior de pacientes.</li>
	 * <li>{@code btnsig}: Cambia a la siguiente página de pacientes.</li>
	 * <li>{@code btnModificar}: Llama al método {@link #modificarPac()} para
	 * modificar un paciente.</li>
	 * <li>{@code btnLimpiar}: Limpia los campos del formulario.</li>
	 * <li>{@code btnEliminar}: Elimina al paciente seleccionado.</li>
	 * <li>{@code btnGuardar}: Valida los datos y guarda un nuevo paciente si son
	 * válidos.</li>
	 * </ul>
	 *
	 */
	private class ManejadorBoton implements ActionListener {// clase fuera del metodo principal pero dentro de la

		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnreligion)) {
				abrirR = new Religion();
				abrirR.addWindowListener(new WindowAdapter() {
					@Override
					// para refrescar el combo
					public void windowClosed(WindowEvent e) {
						datosreligion = Cpacientes.llenareligion();
						religion_1.setModel(datosreligion);
					}
				});
				abrirR.setVisible(true);
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

			if (Evento.getSource().equals(btnModificar)) {
				modificarPac();

			}

			if (Evento.getSource().equals(btnLimpiar)) {
				limpiar();
			}

			if (Evento.getSource().equals(btnEliminar)) {
				eliminarpaci();
			}

			if (Evento.getSource().equals(btnGuardar)) {

				if (textNombre.getText().trim().isEmpty() || textCURP.getText().trim().isEmpty()
						|| textTelefono.getText().trim().isEmpty() || edad.getValue().toString().trim().isEmpty()
						|| religion_1.getSelectedItem().toString().trim().isEmpty()
						|| textApm.getText().trim().isEmpty() || textApp.getText().trim().isEmpty()
						|| textNomCalle.getText().trim().isEmpty() || AgrupadorBootonbox.isSelected(null)
						|| Calendario == null || Sangre.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto MPaciente
					MPaciente nuevoPaciente = new MPaciente();
					// Asignar el nombre del paciente al objeto
					nuevoPaciente.setNombre(textNombre.getText().trim());
					nuevoPaciente.setApellidoP(textApp.getText().trim());
					nuevoPaciente.setApellidoM(textApm.getText().trim());
					nuevoPaciente.setFechaNac(Calendario.getDate());
					nuevoPaciente.setEdad((int) edad.getValue());
					nuevoPaciente.setCurp(textCURP.getText().trim());
					nuevoPaciente.setGenero(Femenino.isSelected() ? Femenino.getText() : Masculino.getText());
					if (chno.isSelected() && chno.getText().equals("Sí")) {
						nuevoPaciente.setAlergia(txtAlergias.getText().trim());
					} else {
						nuevoPaciente.setAlergia("No tiene Alergias");
					}
					nuevoPaciente.setSangre(Sangre.getText().trim());
					nuevoPaciente.setLocalidad(localidad.getSelectedItem().toString());
					nuevoPaciente.setMunicipio(municipio.getSelectedItem().toString());
					nuevoPaciente.setNext(textNumex.getText().trim());
					nuevoPaciente.setNumCalle(textNomCalle.getText().trim());
					nuevoPaciente.setReligion(religion_1.getSelectedItem().toString());
					nuevoPaciente.setTelefono(textTelefono.getText().trim());
					// Llamar al método estático para añadir el paciente
					Cpacientes.AnPac(nuevoPaciente);

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorGuardar"), et.getString("err"),
							JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					/* Actualizamos siempre las tablas despues del registro */
					MostrarDatos();
					limpiar();
				}

			}

		}
	}

	private void modificarPac() {

		if (textNombre.getText().trim().isEmpty() || textCURP.getText().trim().isEmpty()
				|| textTelefono.getText().trim().isEmpty() || edad.getValue().toString().trim().isEmpty()
				|| religion_1.getSelectedItem().toString().trim().isEmpty() || textApm.getText().trim().isEmpty()
				|| textApp.getText().trim().isEmpty() || textNomCalle.getText().trim().isEmpty()
				|| AgrupadorBootonbox.isSelected(null) || Calendario == null || Sangre.getText().trim().isEmpty()) {

			JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
					JOptionPane.ERROR_MESSAGE);
			return;
		}

		seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
		if (seleccion != -1) {// verificar si hay seleccionado
			try {
				int idPacientes = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
				// tomar con modelo
				MPaciente pacienteModificado = new MPaciente();
				pacienteModificado.setNombre(textNombre.getText().trim());
				pacienteModificado.setApellidoP(textApp.getText().trim());
				pacienteModificado.setApellidoM(textApm.getText().trim());
				pacienteModificado.setFechaNac(Calendario.getDate());
				pacienteModificado.setEdad((int) edad.getValue());
				pacienteModificado.setCurp(textCURP.getText().trim());
				pacienteModificado.setGenero(Femenino.isSelected() ? Femenino.getText() : Masculino.getText());
				if (chno.isSelected() && chno.getText().equals(et.getString("Si"))) {
					pacienteModificado.setAlergia(txtAlergias.getText().trim());
				} else {
					pacienteModificado.setAlergia(et.getString("nOTA"));
				}
				pacienteModificado.setSangre(Sangre.getText().trim());
				pacienteModificado.setLocalidad(localidad.getSelectedItem().toString());
				pacienteModificado.setMunicipio(municipio.getSelectedItem().toString());
				pacienteModificado.setNext(textNumex.getText().trim());
				pacienteModificado.setNumCalle(textNomCalle.getText().trim());
				pacienteModificado.setReligion(religion_1.getSelectedItem().toString());
				pacienteModificado.setTelefono(textTelefono.getText().trim());
				// Llamar al método estático para añadir el paciente
				// LLamar al controlador de Pacientes para metodo actualizar
				Cpacientes controlador = new Cpacientes();
				controlador.modificarPaciente(idPacientes, pacienteModificado, (DefaultTableModel) Tabla.getModel(),
						seleccion);

			} catch (Exception e) {
				JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModPaciente"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				e.printStackTrace();
			} finally {
				MostrarDatos();
				limpiar();
			}

		} else {
			JOptionPane.showMessageDialog(null, et.getString("SeleccionePaciente"), et.getString("Adv"),
					JOptionPane.WARNING_MESSAGE);
		}

	}

	/**
	 * Limpia y reinicia todos los campos del formulario de registro o edición de
	 * pacientes.
	 * <p>
	 * Este método borra los textos de los campos de nombre, apellidos, CURP,
	 * teléfono, número de calle, y otros campos del formulario. Además:
	 * </p>
	 */
	public void limpiar() {
		textApp.setText("");
		textApm.setText("");
		textNombre.setText("");
		textCURP.setText("");
		textTelefono.setText("");
		Sangre.setText("");
		textNomCalle.setText("");
		localidad.setSelectedIndex(0);
		municipio.setSelectedIndex(0);
		chno.setSelected(false);
		textNumex.setText("");
		edad.setValue(0);
		religion_1.setSelectedItem(et.getString("SEL"));
		Calendario.setDate(new Date()); // reinicia al día de hoy
		AgrupadorBootonbox.clearSelection();
		// comboBox.setSelectedIndex(0);

	}

	/**
	 * Elimina al paciente seleccionado de la tabla y de la base de datos.
	 * <p>
	 * Este método obtiene el índice de la fila seleccionada en la tabla y, si hay
	 * una fila válida seleccionada, extrae el ID del paciente desde la primera
	 * columna. Luego, llama al método {@code eliminarPaciente()} del controlador
	 * {@code Cpacientes} para realizar la eliminación en la base de datos y
	 * actualizar el {@code DefaultTableModel}.
	 * </p>
	 * <p>
	 * Después de la eliminación, limpia los campos del formulario mediante
	 * {@link #limpiar()}. Si no se ha seleccionado ninguna fila, muestra un mensaje
	 * de advertencia al usuario.
	 * </p>
	 */
	private void eliminarpaci() {

		seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
		if (seleccion != -1) {
			int idPaciente = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
			Cpacientes controlador = new Cpacientes();
			controlador.eliminarPaciente(idPaciente, (DefaultTableModel) Tabla.getModel(), seleccion);
			limpiar();
		} else {
			JOptionPane.showMessageDialog(null, et.getString("SeleccionePacienteEli"), et.getString("Adv"),
					JOptionPane.WARNING_MESSAGE);
		}
		limpiar();
	}

	/**
	 * La clase {@code ManejadorFocus} para validar campos específicos cuando
	 * pierden el foco.
	 * <p>
	 * En particular, valida el formato del CURP y del número de teléfono, mostrando
	 * un mensaje de error si el formato es incorrecto.
	 * </p>
	 * <p>
	 * Esta clase utiliza expresiones regulares para verificar que los datos
	 * introducidos cumplan con los formatos esperados:
	 * </p>
	 * <ul>
	 * <li>CURP: Formato oficial de 18 caracteres alfanuméricos.</li>
	 * <li>Teléfono: Formato (999) 999-9999.</li>
	 * </ul>
	 * 
	 * <p>
	 */
	public class ManejadorFocus implements FocusListener {

		public void focusGained(FocusEvent e) {
			// TODO Auto-generated method stub

		}

		@Override
		public void focusLost(FocusEvent EventoFocus) {

			if (EventoFocus.getSource().equals(textCURP)) {
				Pattern PatronCurp = Pattern
						.compile("^[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[HM]{1}"
								+ "(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)"
								+ "[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$");
				Matcher MatchCurp = PatronCurp.matcher(textCURP.getText().trim());

				if (!MatchCurp.matches()) {
					JOptionPane.showMessageDialog(null, et.getString("curpfocus"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					textCURP.requestFocus();
				}
			}
			if (EventoFocus.getSource().equals(textTelefono)) {

				Pattern PatronTelefono = Pattern.compile("^\\([0-9]{3}\\)\\s*[0-9]{3}-[0-9]{4}$");
				Matcher MatchTelefono = PatronTelefono.matcher(textTelefono.getText());

				if (!MatchTelefono.matches()) {
					JOptionPane.showMessageDialog(null, et.getString("telefonofocus"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					textTelefono.requestFocus();
				}

			}

		}
	}

	public class ManejadorKey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {
			// se validan cuadros blancos
			if (EventKey.getSource() == textNombre || EventKey.getSource() == textApp
					|| EventKey.getSource() == textApm) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						|| textNombre.getText().length() >= 49 || textApm.getText().length() >= 49
						|| textApp.getText().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nombre"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}

			}

			// Validacion sangre
			if (EventKey.getSource() == Sangre) {
				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != '+'
						&& EventKey.getKeyChar() != '-' || Sangre.getText().trim().length() >= 15) {

					JOptionPane.showMessageDialog(null, et.getString("TDS"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textNomCalle.requestFocus();

				}
			}
			if (EventKey.getSource() == textNomCalle) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						|| textNomCalle.getText().trim().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nom3"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textNomCalle.requestFocus();

				}
			}
			if (EventKey.getSource() == textNumex) {
				if (!Character.isDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textNumex.getText().trim().length() >= 10) {

					JOptionPane.showMessageDialog(null, et.getString("numex"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textNumex.requestFocus();
				}
			}
			
			if (EventKey.getSource() == textCURP) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textCURP.getText().trim().length() >= 18) {

					JOptionPane.showMessageDialog(null, et.getString("curppane"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textCURP.requestFocus();

				}

				EventKey.setKeyChar(Character.toUpperCase(EventKey.getKeyChar()));

			}

			

		}

		@Override
		public void keyPressed(KeyEvent e) {
			// TODO Auto-generated method stub

		}

		@Override
		public void keyReleased(KeyEvent e) {
			// Convertir automáticamente a mayúsculas
			textCURP.setText(textCURP.getText().toUpperCase());
			Sangre.setText(Sangre.getText().toUpperCase());

		}

	}
}
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

import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
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

import controladores.Cmedicos;
import modelos.MMedicos;

/**
 * 
 * Vista gráfica para el registro de medicos.
 * <p>
 * Esta ventana permite ingresar informacion de nuevos medicos para registrarlos
 * en el sistema. La clase Medicos es una interfaz grafica que permite al
 * usuario interactuar con la base de datos de forma intutitiva y dinamica.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Medicos extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;
	private JLabel JLFecha;
	private JLabel titulo;
	private JTextField textNombre;
	private JLabel App;
	private JTextField textApp;
	/**
	 * Variable que almacena el id del objeto seleccionado para eliminar
	 * {@code btnEliminar}
	 */
	public static int idmed;
	private JTextField textApm;
	/**
	 * Variable que toma la fecha actual en el sistema.
	 */
	private Date Hoy;
	private JLabel Apm;
	private JDateChooser Calendario;
	private JLabel Nom;
	/**
	 * Variable que almacena el id del objeto seleccionado para modificar
	 * {@code btnModificar}
	 */
	public static int idMedico;
	private JLabel JLCorreo;
	private JTextField textCorreo;
	private JLabel JLTelefono;
	private JTextField textTelefono;
	/**
	 * Botón que permite guardar la información ingresada.
	 */
	private JButton btnGuardar;
	/**
	 * Botón que permite modifica la información ingresada.
	 */
	private JButton btnModificar;
	/**
	 * Botón que permite eliminar un elemento de la tabla.
	 */
	private JButton btnEliminar;
	private JComboBox<String> JEspecialidad;
	private DefaultComboBoxModel<String> Espe;
	private JLabel JLEspecialidad;
	private JComboBox<String> JDepartamentos;
	private DefaultComboBoxModel<String> Subespe;
	private JLabel JLDepartamento;
	private JComboBox<String> JSubespecialidad;
	private DefaultComboBoxModel<String> Depto;
	private JLabel JLSubesp;
	/**
	 * Tabla que muestra la lista de recetas registradas.
	 */
	private JTable Tabla;
	/**
	 * Panel de desplazamiento que contiene la tabla que muestra las recetas.
	 */
	private JScrollPane scrollPane;
	/**
	 * Variable para colocar el formato de <b>{@code textTelefono}</b>
	 */
	private MaskFormatter PatronTelefono;
	/**
	 * Variable que toma el indice de la fila seleccionada en la tabla.
	 */
	public static int seleccion;
	/**
	 * Variable entera para verificacion de jtable.
	 */
	public static int filaSeleccionada;
	private JButton btnsig;
	private JButton btnant;
	private JLabel jlpagina;
	private JButton btnLimpiar;

	private int paginaActual = 1;
	private final int registrosPorPagina = 3;
	private int totalPaginas;
	private JLabel jlcedula;
	private JLabel jlcurp;
	private JLabel jlrfc;
	private JLabel jlmod;
	private JLabel jlnumext;
	private JLabel jlnomcalle;
	private JLabel jllocalidad;
	private JLabel jlmun;
	private JTextField textCURP;
	private JTextField textCedProf;
	private JTextField textRFC;
	private JTextField textNomCalle;
	private JTextField textNumExt;
	private JComboBox<String> jMunicipio;
	private DefaultComboBoxModel<String> Mun;
	private JComboBox<String> jLocalidad;
	private DefaultComboBoxModel<String> Loc;
	private JButton btnEsp;
	private JButton btnSubEsp;
	private JButton btnDepto;
	private Especialidades abrirE;
	private Subespecialidad abrirS;
	private Departamentos abrirD;

	/**
	 * Inicia la interfaz gráfica de usuario ejecutando la creación y visualización
	 * del frame principal "Medicos".
	 * 
	 * @param args argumentos de linea de comandos.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Medicos frame = new Medicos();
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
	 * <p>
	 * <b>Algunas de las funcionalidades que se establecen:</b>
	 * </p>
	 * <ul>
	 * <li>Establece el idioma del sistema para internacionalización con
	 * <b>{@code et}</b></li>
	 * <li>Configura la ventana principal y sus componentes (JLabels, JTextFields,
	 * JTable, etc.)</li>
	 * <li>Agrega escuchadores para botones, tabla y campos de texto</li>
	 * <li>Carga datos de especialidades, departamentos y certificaciones en los
	 * ComboBox</li>
	 * <li>Establece el día minimo a seleccionar en el jdate chooser y no habilitar
	 * el uso de teclado para seleccionar fecha.</li>
	 * </ul>
	 */
	public Medicos() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Medicos.class.getResource("/imagenes/medicos.png")));

		Idioma = Locale.getDefault();
		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(40, 1, 1206, 656);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setToolTipText("");
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setLocationRelativeTo(null);

		setContentPane(contentPane);
		contentPane.setLayout(null);

		Hoy = new Date();

		Nom = new JLabel(et.getString("nom"));
		Nom.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		Nom.setForeground(new Color(50, 50, 50));
		Nom.setBounds(20, 75, 116, 22);
		contentPane.add(Nom);

		textNombre = new JTextField();
		textNombre.setHorizontalAlignment(SwingConstants.CENTER);
		textNombre.setForeground(new Color(50, 50, 50));
		textNombre.setBackground(Color.WHITE);
		textNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textNombre.setBounds(10, 108, 126, 28);
		contentPane.add(textNombre);
		textNombre.setColumns(10);

		titulo = new JLabel(et.getString("tituloM"));
		titulo.setForeground(new Color(0, 0, 139));
		titulo.setHorizontalAlignment(SwingConstants.CENTER);
		titulo.setFont(new Font("Times New Roman", Font.BOLD, 30));
		titulo.setBounds(323, 23, 413, 22);
		contentPane.add(titulo);

		textApp = new JTextField();
		textApp.setHorizontalAlignment(SwingConstants.CENTER);
		textApp.setForeground(new Color(50, 50, 50));
		textApp.setBackground(Color.WHITE);
		textApp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textApp.setBounds(250, 108, 126, 28);
		contentPane.add(textApp);
		textApp.setColumns(10);

		textApm = new JTextField();
		textApm.setHorizontalAlignment(SwingConstants.CENTER);
		textApm.setForeground(new Color(50, 50, 50));
		textApm.setBackground(Color.WHITE);
		textApm.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textApm.setBounds(500, 108, 126, 28);
		contentPane.add(textApm);
		textApm.setColumns(10);

		App = new JLabel(et.getString("app"));
		App.setForeground(new Color(50, 50, 50));
		App.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		App.setBounds(250, 75, 143, 22);
		contentPane.add(App);

		Apm = new JLabel(et.getString("apm"));
		Apm.setForeground(new Color(50, 50, 50));
		Apm.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		Apm.setBounds(500, 75, 155, 22);
		contentPane.add(Apm);

		Calendario = new JDateChooser();
		Calendario.setBounds(800, 108, 88, 20);
		Calendario.setDateFormatString("dd/MM/yyyy");
		Calendario.setDate(Hoy);
		Calendario.setMaxSelectableDate(Hoy);
		((JTextField) Calendario.getDateEditor().getUiComponent()).setEditable(false);
		contentPane.add(Calendario);

		JLFecha = new JLabel(et.getString("fec"));
		JLFecha.setForeground(new Color(50, 50, 50));
		JLFecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JLFecha.setBounds(800, 75, 167, 22);
		contentPane.add(JLFecha);

		JLCorreo = new JLabel(et.getString("correo"));
		JLCorreo.setForeground(new Color(50, 50, 50));
		JLCorreo.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JLCorreo.setBounds(20, 171, 70, 22);
		contentPane.add(JLCorreo);

		textCorreo = new JTextField();
		textCorreo.setHorizontalAlignment(SwingConstants.CENTER);
		textCorreo.setForeground(new Color(50, 50, 50));
		textCorreo.setBackground(Color.WHITE);
		textCorreo.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textCorreo.setBounds(10, 204, 126, 28);
		contentPane.add(textCorreo);
		textCorreo.setColumns(10);

		JLTelefono = new JLabel(et.getString("tel"));
		JLTelefono.setForeground(new Color(50, 50, 50));
		JLTelefono.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JLTelefono.setBounds(205, 171, 70, 22);
		contentPane.add(JLTelefono);
		try {
			PatronTelefono = new MaskFormatter("(###) ###-####");
		} catch (ParseException e) {
			// formato telefono
			e.printStackTrace();
		}
		textTelefono = new JFormattedTextField(PatronTelefono);
		textTelefono.setForeground(new Color(50, 50, 50));
		textTelefono.setBackground(Color.WHITE);
		textTelefono.setFont(new Font("Comic Sans MS", Font.PLAIN, 13));
		textTelefono.setBounds(200, 204, 106, 25);
		contentPane.add(textTelefono);
		textTelefono.setColumns(10);

		btnGuardar = new JButton(et.getString("Gu"));
		// btnGuardar.setIcon(new
		// ImageIcon(Pacientes.class.getResource("/imagenes/icons8-floppy-disk-24.png")));
		btnGuardar.setHorizontalTextPosition(SwingConstants.LEFT);
		btnGuardar.setBackground(Color.WHITE);
		btnGuardar.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		btnGuardar.setBounds(1045, 189, 139, 30);
		contentPane.add(btnGuardar);

		Espe = new DefaultComboBoxModel<String>();
		Espe = Cmedicos.llenarEspe();

		JEspecialidad = new JComboBox<String>(Espe);
		JEspecialidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JEspecialidad.setBackground(new Color(224, 224, 224));
		AutoCompleteDecorator.decorate(this.JEspecialidad);

		JEspecialidad.setBounds(10, 400, 177, 28);
		contentPane.add(JEspecialidad);

		JLEspecialidad = new JLabel(et.getString("Esp"));
		JLEspecialidad.setForeground(new Color(50, 50, 50));
		JLEspecialidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JLEspecialidad.setBounds(20, 380, 96, 14);
		contentPane.add(JLEspecialidad);

		Depto = new DefaultComboBoxModel<String>();
		Depto = Cmedicos.llenarDepto();

		JDepartamentos = new JComboBox<String>(Depto);
		JDepartamentos.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JDepartamentos.setBackground(new Color(224, 224, 224));
		AutoCompleteDecorator.decorate(this.JDepartamentos);

		JDepartamentos.setBounds(588, 400, 175, 28);
		contentPane.add(JDepartamentos);

		JLDepartamento = new JLabel(et.getString("Dep"));
		JLDepartamento.setForeground(new Color(50, 50, 50));
		JLDepartamento.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JLDepartamento.setBounds(610, 380, 111, 14);
		contentPane.add(JLDepartamento);

		Subespe = new DefaultComboBoxModel<String>();
		Subespe = Cmedicos.llenarSubespe();

		JSubespecialidad = new JComboBox<String>(Subespe);
		JSubespecialidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JSubespecialidad.setBackground(new Color(224, 224, 224));
		JSubespecialidad.setBounds(275, 400, 221, 28);
		contentPane.add(JSubespecialidad);
		AutoCompleteDecorator.decorate(this.JSubespecialidad);

		JLSubesp = new JLabel(et.getString("Sub"));
		JLSubesp.setForeground(new Color(50, 50, 50));
		JLSubesp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JLSubesp.setBounds(276, 380, 116, 14);
		contentPane.add(JLSubesp);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(58, 464, 964, 113);
		contentPane.add(scrollPane);

		Tabla = new JTable();
		scrollPane.setColumnHeaderView(Tabla);

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

		btnsig = new JButton(et.getString("sig"));
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnsig.setBounds(341, 588, 105, 23);
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnant.setBounds(500, 588, 105, 23);
		contentPane.add(btnant);

		jlpagina = new JLabel(et.getString("pagina"));
		jlpagina.setBounds(708, 579, 70, 14);
		contentPane.add(jlpagina);

		jlcedula = new JLabel(et.getString("cedprof"));
		jlcedula.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlcedula.setBounds(365, 171, 167, 22);
		contentPane.add(jlcedula);

		jlcurp = new JLabel("CURP");
		jlcurp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlcurp.setBounds(750, 171, 49, 22);
		contentPane.add(jlcurp);

		jlrfc = new JLabel("RFC");
		jlrfc.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlrfc.setBounds(555, 171, 49, 22);
		contentPane.add(jlrfc);

		jlnumext = new JLabel(et.getString("numc"));
		jlnumext.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlnumext.setBounds(753, 277, 143, 14);
		contentPane.add(jlnumext);

		jlnomcalle = new JLabel(et.getString("nocall"));
		jlnomcalle.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlnomcalle.setBounds(520, 277, 167, 14);
		contentPane.add(jlnomcalle);

		jllocalidad = new JLabel(et.getString("loc"));
		jllocalidad.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jllocalidad.setBounds(210, 277, 107, 14);
		contentPane.add(jllocalidad);

		jlmun = new JLabel(et.getString("mun"));
		jlmun.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlmun.setBounds(20, 277, 116, 14);
		contentPane.add(jlmun);

		textCURP = new JTextField();
		textCURP.setBounds(750, 204, 168, 28);
		contentPane.add(textCURP);
		textCURP.setColumns(10);

		textCedProf = new JTextField();
		textCedProf.setBounds(360, 204, 126, 28);
		contentPane.add(textCedProf);
		textCedProf.setColumns(10);

		textRFC = new JTextField();
		textRFC.setBounds(550, 204, 126, 28);
		contentPane.add(textRFC);
		textRFC.setColumns(10);

		Mun = new DefaultComboBoxModel<String>();
		Mun = Cmedicos.llenarMun();

		jMunicipio = new JComboBox<String>(Mun);
		jMunicipio.setBounds(10, 302, 126, 28);
		contentPane.add(jMunicipio);
		AutoCompleteDecorator.decorate(this.jMunicipio);

		Loc = new DefaultComboBoxModel<String>();
		Loc = Cmedicos.llenarLoc(jMunicipio.getSelectedItem().toString());

		jLocalidad = new JComboBox<String>(Loc);
		jLocalidad.setBounds(200, 302, 250, 28);
		contentPane.add(jLocalidad);
		AutoCompleteDecorator.decorate(this.jLocalidad);

		textNomCalle = new JTextField();
		textNomCalle.setBounds(520, 302, 175, 28);
		contentPane.add(textNomCalle);
		textNomCalle.setColumns(10);

		textNumExt = new JTextField();
		textNumExt.setBounds(750, 302, 110, 28);
		contentPane.add(textNumExt);
		textNumExt.setColumns(10);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 11));
		jlmod.setBounds(300, 450, 333, 14);
		contentPane.add(jlmod);

		btnEsp = new JButton("");
		btnEsp.setBackground(Color.WHITE);
		btnEsp.setIcon(new ImageIcon(Medicos.class.getResource("/imagenes/añadirsub.png")));
		btnEsp.setBounds(197, 397, 35, 34);
		contentPane.add(btnEsp);

		btnSubEsp = new JButton("");
		btnSubEsp.setBackground(Color.WHITE);
		btnSubEsp.setIcon(new ImageIcon(Medicos.class.getResource("/imagenes/añadirsub.png")));
		btnSubEsp.setBounds(506, 400, 35, 34);
		contentPane.add(btnSubEsp);

		btnDepto = new JButton("");
		btnDepto.setBackground(Color.WHITE);
		btnDepto.setIcon(new ImageIcon(Medicos.class.getResource("/imagenes/añadirsub.png")));
		btnDepto.setBounds(774, 397, 35, 34);
		contentPane.add(btnDepto);

		ManejadorBoton Escuchador = new ManejadorBoton();
		btnGuardar.addActionListener(Escuchador);
		btnModificar.addActionListener(Escuchador);
		btnEliminar.addActionListener(Escuchador);
		btnant.addActionListener(Escuchador);
		btnsig.addActionListener(Escuchador);
		btnEsp.addActionListener(Escuchador);
		btnSubEsp.addActionListener(Escuchador);
		btnDepto.addActionListener(Escuchador);

		ManejadorKey EscuchadorKey = new ManejadorKey();
		textNombre.addKeyListener(EscuchadorKey);
		textTelefono.addKeyListener(EscuchadorKey);
		textApp.addKeyListener(EscuchadorKey);
		textApm.addKeyListener(EscuchadorKey);
		textCorreo.addKeyListener(EscuchadorKey);
		textCedProf.addKeyListener(EscuchadorKey);
		textRFC.addKeyListener(EscuchadorKey);
		textCURP.addKeyListener(EscuchadorKey);
		textNomCalle.addKeyListener(EscuchadorKey);
		textNumExt.addKeyListener(EscuchadorKey);

		ManejadorFocus EscuchadorFocus = new ManejadorFocus();
		textCorreo.addFocusListener(EscuchadorFocus);
		textTelefono.addFocusListener(EscuchadorFocus);
		textCURP.addFocusListener(EscuchadorFocus);
		textRFC.addFocusListener(EscuchadorFocus);
		
		ManejadorMouse clicked = new ManejadorMouse();
		Tabla.addMouseListener(clicked);

		ManejadorCombox EscuchadorComboBox = new ManejadorCombox();
		jMunicipio.addItemListener(EscuchadorComboBox);

		MostrarDatos();

		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);

	}

	/**
	 * Clase que implementa {@link MouseListener} para manejar eventos con el mouse.
	 * <p>
	 * Esta clase está diseñada para detectar cuando el usuario seleccione una fila
	 * de la tabla y ejecutar una acción específica, como mostrar datos relacionados
	 * con un medico.
	 * </p>
	 */
	public class ManejadorMouse implements MouseListener {

		@Override
		/**
		 * Método invocado cuando ocurre un clic sobre un registro en Jtable.
		 * <p>
		 * Se imprime un mensaje en consola cuando presionan con el mouse un registro en
		 * la vista y llama al metodo para ejecutarlo.
		 * </p>
		 * 
		 */
		public void mouseClicked(MouseEvent e) {
			// Seleccionar y mostrar en componentes
			mostrodatosm();
		}

		/**
		 * Muestra los datos de un medico seleccionado en la tabla {@code Tabla}.
		 * <p>
		 * Este método carga los datos correspondientes de la fila seleccionada en los
		 * campos del formulario. Si no se selecciona ninguna fila, se detiene el
		 * proceso. También convierte la fecha obtenida desde la tabla a un objeto
		 * {@link java.util.Date}.
		 * </p>
		 *
		 * @throws ParseException Si la fecha obtenida desde la tabla no tiene el
		 *                        formato indicado.
		 */
		public void mostrodatosm() {
			// mostrar datos de los medicos
			seleccion = Tabla.getSelectedRow();
			filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}

			// Obtener los datos de la fila seleccionada
			textNombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
			textApp.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());
			textApm.setText(Tabla.getValueAt(filaSeleccionada, 3).toString());
			JEspecialidad.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 4).toString());
			JDepartamentos.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 5).toString());
			JSubespecialidad.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 6).toString());
			textCorreo.setText(Tabla.getValueAt(filaSeleccionada, 7).toString());
			textCedProf.setText(Tabla.getValueAt(filaSeleccionada, 8).toString());

			try {
				// Asignar la fecha correctamente
				String fechaString = Tabla.getValueAt(filaSeleccionada, 9).toString();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date fecha = sdf.parse(fechaString);
				Calendario.setDate(fecha);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			textTelefono.setText(Tabla.getValueAt(filaSeleccionada, 10).toString());
			textCURP.setText(Tabla.getValueAt(filaSeleccionada, 11).toString());
			textRFC.setText(Tabla.getValueAt(filaSeleccionada, 12).toString());
			textNumExt.setText(Tabla.getValueAt(filaSeleccionada, 13).toString());
			textNomCalle.setText(Tabla.getValueAt(filaSeleccionada, 14).toString());
			jMunicipio.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 16).toString());
			Cmedicos.llenarLoc(jMunicipio.getSelectedItem().toString());
			jLocalidad.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 15).toString());
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

	}// fin manejador mouse

	/**
	 * 
	 * Este metodo muestra en la interfaz los datos guardados de los Medicos
	 * registrados.
	 * <p>
	 * Este método configura un model con las columnas necesarias para representar
	 * los campos de las tablas medicos se llama al método con el controlador
	 * {@link controladores.Cmedicos} para llenar el jtable con los datos
	 * recuperados.
	 * </p>
	 * 
	 */
	public void MostrarDatos() {
		DefaultTableModel model;
		model = new DefaultTableModel();// definimos el objeto tableModel

		Tabla.setModel(model);
		model.addColumn("ID");
		model.addColumn(et.getString("nom"));
		model.addColumn(et.getString("app"));
		model.addColumn(et.getString("apm"));
		model.addColumn(et.getString("Esp"));
		model.addColumn(et.getString("Dep"));
		model.addColumn(et.getString("Sub"));
		model.addColumn(et.getString("correo"));
		model.addColumn(et.getString("cedprof"));
		model.addColumn(et.getString("fec"));
		model.addColumn(et.getString("tel"));
		model.addColumn(et.getString("curp"));
		model.addColumn(et.getString("rfc"));
		model.addColumn(et.getString("numc"));
		model.addColumn(et.getString("nocall"));
		model.addColumn(et.getString("loc"));
		model.addColumn(et.getString("mun"));

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Cmedicos medicos = new Cmedicos();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// medicos.buscarUsuariosConTableModel(model);

		medicos.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane.setViewportView(Tabla);

	}

	/**
	 * Actualiza el estado de los botones de navegación de página y la etiqueta que
	 * indica la página actual en la interfaz de usuario.
	 * <p>
	 * Calcula el total de páginas basado en el número total de registros obtenidos
	 * desde {@code Cmedicos.contarRegistros()} y el número de registros por página.
	 * Luego actualiza la etiqueta de página y habilita o deshabilita los botones
	 * "anterior" y "siguiente" según corresponda.
	 * </p>
	 */
	public void actualizarEstadoBotones() {
		// TODO Auto-generated method stub
		totalPaginas = (int) Math.ceil((double) Cmedicos.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

	}

	/**
	 * Manejador de eventos para los botones en la interfaz. Se encarga de responder
	 * a acciones como agregar, modificar o eliminar una receta.
	 * <p>
	 * La clase implementa para manejar los eventos de acción generados al hacer
	 * clic en los botones de una interfaz gráfica relacionada con recetas médicas.
	 * </p>
	 * <ul>
	 * <li><b>Guardar</b>: Registra un nuevo medico.</li>
	 * <li><b>Modificar</b>: Actualiza los datos de unm medico seleccionado.</li>
	 * <li><b>Eliminar</b>: Borra un medico seleccionado de la tabla.</li>
	 * </ul>
	 * <p>
	 * Se utilizan objetos del modelo {@link MMedicos} para representar la receta, y
	 * del controlador {@link controladores.Cmedicos} para realizar operaciones de
	 * base de datos.
	 * </p>
	 * 
	 */
	public class ManejadorBoton implements ActionListener {// clase fuera del metodo principal pero dentro de la
		// clase principal

		/**
		 * Este método se ejecuta automáticamente cuando se hace clic en cualquiera de
		 * los botones asociados a este ActionListener.
		 * 
		 * @param Evento Evento de acción generada.
		 * @throws Exception Si ocurre un error al guardar los datos en el objeto.
		 */
		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnEsp)) {
				abrirE = new Especialidades();
				abrirE.addWindowListener(new WindowAdapter() {
					@Override
					// para refrescar el combo
					public void windowClosed(WindowEvent e) {
						Espe = Cmedicos.llenarEspe();
						JEspecialidad.setModel(Espe);
					}
				});
				abrirE.setVisible(true);

			}

			if (Evento.getSource().equals(btnSubEsp)) {
				abrirS = new Subespecialidad();
				abrirS.addWindowListener(new WindowAdapter() {
					@Override
					// para refrescar el combo
					public void windowClosed(WindowEvent e) {
						Subespe = Cmedicos.llenarSubespe();
						JSubespecialidad.setModel(Subespe);
					}
				});
				abrirS.setVisible(true);

			}

			if (Evento.getSource().equals(btnDepto)) {
				abrirD = new Departamentos();
				abrirD.addWindowListener(new WindowAdapter() {
					@Override
					// para refrescar el combo
					public void windowClosed(WindowEvent e) {
						Depto = Cmedicos.llenarDepto();
						JDepartamentos.setModel(Depto);
					}
				});
				abrirD.setVisible(true);

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

			if (Evento.getSource() == btnLimpiar) {
				limpiar();
			}

			if (Evento.getSource().equals(btnModificar)) {

				if (textNombre.getText().trim().isEmpty() || textCorreo.getText().trim().isEmpty()
						|| textTelefono.getText().trim().isEmpty() || JEspecialidad.getSelectedIndex() <= 0
						|| textApm.getText().trim().isEmpty() || textApp.getText().trim().isEmpty()
						|| JDepartamentos.getSelectedIndex() <= 0 || Calendario == null
						|| JSubespecialidad.getSelectedIndex() <= 0 || textCedProf.getText().trim().isEmpty()
						|| textCURP.getText().trim().isEmpty() || textRFC.getText().trim().isEmpty()
						|| textNumExt.getText().trim().isEmpty() || textNomCalle.getText().trim().isEmpty()
						|| jLocalidad.getSelectedIndex() <= 0 || jMunicipio.getSelectedIndex() <= 0) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						idMedico = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MMedicos MedicoModificado = new MMedicos();
						// Asignar el nombre del paciente al objeto
						MedicoModificado.setNombre(textNombre.getText().trim());
						MedicoModificado.setApellidoP(textApp.getText().trim());
						MedicoModificado.setApellidoM(textApm.getText().trim());
						MedicoModificado.setEsp(JEspecialidad.getSelectedItem().toString());
						MedicoModificado.setDep(JDepartamentos.getSelectedItem().toString());
						MedicoModificado.setSub(JSubespecialidad.getSelectedItem().toString());
						MedicoModificado.setCorreo(textCorreo.getText().trim());
						MedicoModificado.setFechaNac(Calendario.getDate());
						MedicoModificado.setTelefono(textTelefono.getText());
						MedicoModificado.setCedula(textCedProf.getText().trim());
						MedicoModificado.setCURP(textCURP.getText().trim());
						MedicoModificado.setRFC(textRFC.getText().trim());
						MedicoModificado.setNumCasa(Integer.parseInt(textNumExt.getText().trim()));
						MedicoModificado.setNomCalle(textNomCalle.getText().trim());
						MedicoModificado.setLoc(jLocalidad.getSelectedItem().toString());
						MedicoModificado.setMun(jMunicipio.getSelectedItem().toString());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cmedicos contmed = new Cmedicos();
						contmed.modificarMed(idMedico, MedicoModificado, (DefaultTableModel) Tabla.getModel(),
								seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModMeD"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneMEModi"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;

			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					idmed = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cmedicos controlador = new Cmedicos();
					controlador.eliminarmedico(idmed, (DefaultTableModel) Tabla.getModel(), seleccion);
					limpiar();
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneMEEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;

			}

			if (Evento.getSource().equals(btnGuardar)) {
				if (textNombre.getText().trim().isEmpty() || textCorreo.getText().trim().isEmpty()
						|| textTelefono.getText().trim().isEmpty() || JEspecialidad.getSelectedIndex() <= 0
						|| textApm.getText().trim().isEmpty() || textApp.getText().trim().isEmpty()
						|| JDepartamentos.getSelectedIndex() <= 0 || Calendario == null
						|| JSubespecialidad.getSelectedIndex() <= 0 || textCedProf.getText().trim().isEmpty()
						|| textCURP.getText().trim().isEmpty() || textRFC.getText().trim().isEmpty()
						|| textNumExt.getText().trim().isEmpty() || textNomCalle.getText().trim().isEmpty()
						|| jLocalidad.getSelectedIndex() <= 0 || jMunicipio.getSelectedIndex() <= 0) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto MPaciente
					MMedicos nuevoMedico = new MMedicos();
					// Asignar el nombre del paciente al objeto
					nuevoMedico.setNombre(textNombre.getText().trim());
					nuevoMedico.setApellidoP(textApp.getText().trim());
					nuevoMedico.setApellidoM(textApm.getText().trim());
					nuevoMedico.setEsp(JEspecialidad.getSelectedItem().toString());
					nuevoMedico.setDep(JDepartamentos.getSelectedItem().toString());
					nuevoMedico.setSub(JSubespecialidad.getSelectedItem().toString());
					nuevoMedico.setCorreo(textCorreo.getText().trim());
					nuevoMedico.setFechaNac(Calendario.getDate());
					nuevoMedico.setTelefono(textTelefono.getText());
					nuevoMedico.setCedula(textCedProf.getText().trim());
					nuevoMedico.setCURP(textCURP.getText().trim());
					nuevoMedico.setRFC(textRFC.getText().trim());
					nuevoMedico.setNumCasa(Integer.parseInt(textNumExt.getText().trim()));
					nuevoMedico.setNomCalle(textNomCalle.getText().trim());
					nuevoMedico.setLoc(jLocalidad.getSelectedItem().toString());
					nuevoMedico.setMun(jMunicipio.getSelectedItem().toString());

					// Llamar al método estático para añadir el paciente
					Cmedicos.AnMed(nuevoMedico);

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("ErrorGuardMedico"), et.getString("err"),
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

	/**
	 * 
	 * Restablece los campos del formulario a sus valores iniciales.
	 * <p>
	 * Este método se utiliza para limpiar el contenido ingresado por el usuario y
	 * preparar el formulario para una nueva entrada.
	 * </p>
	 */
	public void limpiar() {
		// Metodo limpiar componentes
		textApp.setText("");
		textApm.setText("");
		textNombre.setText("");
		textTelefono.setText("");
		textCorreo.setText("");
		JEspecialidad.setSelectedItem(et.getString("SEL"));
		JDepartamentos.setSelectedItem(et.getString("SEL"));
		JSubespecialidad.setSelectedItem(et.getString("SEL"));
		Calendario.setDate(new Date()); // reinicia al día de hoy
		textCedProf.setText("");
		textCURP.setText("");
		textRFC.setText("");
		textNumExt.setText("");
		textNomCalle.setText("");
		jLocalidad.setSelectedItem(et.getString("SEL"));
		jMunicipio.setSelectedItem(et.getString("SEL"));

	}

	/**
	 * Clase que implementa {@link ListSelectionListener} para manejar los eventos
	 * de selección en una tabla.
	 * <p>
	 * Esta clase agrega un listener a la tabla para detectar la selección de filas.
	 * Hablilita los botones Modificar y Eliminar cuando se selecciona una fila de
	 * la tabla. Mientras no se seleccione una fila, el boton Guardar será el único
	 * habilitado.
	 * </p>
	 * <b>Botones afectados:</b>
	 * <ul>
	 * <li>btnModificar: habilitado si hay una fila seleccionada</li>
	 * <li>btnEliminar: habilitado si hay una fila seleccionada</li>
	 * <li>btnGuardar: deshabilitado si hay una fila seleccionada</li>
	 * </ul>
	 * 
	 */
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
	 * Clase interna que maneja eventos de teclado para componentes.
	 * <p>
	 * Esta clase interna que maneja los eventos del teclado para ciertos
	 * componentes del formulario.
	 * </p>
	 * <b>Funciónes de esta clase</b>
	 * <p>
	 * Implementa la interfaz con un Key Listener y se encarga de validar que los
	 * caracteres ingresados sean permitidos (letras, números, espacio, algunos
	 * caracteres especiales).
	 * </p>
	 */

	public class ManejadorKey implements KeyListener {

		/**
		 * 
		 * Verifica que todos los caracteres ingresados sean validos.
		 * <p>
		 * Se ejecuta cuando el usuario escribe un carácter. Este método verifica que el
		 * carácter ingresado sea válido (letra, número, espacio, retroceso, enter,
		 * delete, coma o punto).
		 * </p>
		 * 
		 * @param EventKey Evento del teclado generado por el usuario.
		 */
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == textNombre || EventKey.getSource() == textApp
					|| EventKey.getSource() == textApm) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textNombre.getText().length() >= 80
						|| textApm.getText().length() >= 49 || textApp.getText().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nombre"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}

			}

			if (EventKey.getSource() == textNomCalle) {
				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE
						|| textNomCalle.getText().trim().length() >= 49) {

					JOptionPane.showMessageDialog(null, et.getString("nombre"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textNomCalle.requestFocus();

				}
			}
			if (EventKey.getSource() == textNumExt) {
				if (!Character.isDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textNumExt.getText().trim().length() >= 10) {

					JOptionPane.showMessageDialog(null, et.getString("numex"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textNumExt.requestFocus();
				}
			}
			if (EventKey.getSource() == textRFC) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE
						||  textRFC.getText().trim().length() >= 13) {

					
					EventKey.consume();
					textRFC.requestFocus();

				}
			}
			if (EventKey.getSource() == textCedProf) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textCedProf.getText().trim().length() >= 8) {

					JOptionPane.showMessageDialog(null, et.getString("numex"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					textCedProf.requestFocus();
				}
			}

			if (EventKey.getSource().equals(textTelefono)) {

				if (!Character.isDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_DELETE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE) {

					if (textTelefono.getText().trim().length() <= 10 && EventKey.getKeyChar() == KeyEvent.VK_ENTER) {
						JOptionPane.showMessageDialog(null, et.getString("telefono"), et.getString("tituloerror"),
								JOptionPane.ERROR_MESSAGE);
					}
				}

			}
			if (EventKey.getSource().equals(textCorreo)) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != '@'
						&& EventKey.getKeyChar() != '_' && EventKey.getKeyChar() != '.'
						&& EventKey.getKeyChar() != KeyEvent.VK_ENTER && EventKey.getKeyChar() != KeyEvent.VK_DELETE) {
					JOptionPane.showMessageDialog(null, et.getString("CaracterNoValidCorreo"), et.getString("err"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();// el evento consume evita que se aplique la tecla presionada
					textCorreo.requestFocus();

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
			textCURP.setText(textCURP.getText().toUpperCase());
			textRFC.setText(textRFC.getText().toUpperCase());

		}
	}

	private class ManejadorCombox implements ItemListener {

		@Override
		public void itemStateChanged(ItemEvent EvetComboBox) {
			if (EvetComboBox.getSource().equals(jMunicipio)) {
				Loc = Cmedicos.llenarLoc(jMunicipio.getSelectedItem().toString());
				jLocalidad.setModel(Loc);
			}
		}
	}

	/**
	 * Se ejecuta cuando un componente pierde el foco.
	 * <p>
	 * Si el componente que pierde el foco es el campo de texto, este método valida
	 * que el contenido ingresado sea válido.
	 * 
	 * </p>
	 * 
	 * @param EventoFocus el evento que indica que un componente ha perdido el foco.
	 */
	public class ManejadorFocus implements FocusListener {

		public void focusGained(FocusEvent e) {
			// TODO Auto-generated method stub

		}

		@Override

		public void focusLost(FocusEvent EventoFocus) {

			if (EventoFocus.getSource().equals(textCorreo)) {

				Pattern Patron = Pattern.compile("^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
						+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$");

				Matcher mather = Patron.matcher(textCorreo.getText().trim());
				if (!mather.matches()) {
					JOptionPane.showMessageDialog(null, et.getString("CorrNoValido"), et.getString("err"),
							JOptionPane.ERROR_MESSAGE);
					textCorreo.requestFocus();
				}

			}
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
			
			if (EventoFocus.getSource().equals(textRFC)) {

				Pattern PatronRFC = Pattern.compile("^([A-ZÑ\\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1]))([A-Z\\d]{3})?$");
				Matcher MatchRFC = PatronRFC.matcher(textRFC.getText());

				if (!MatchRFC.matches()) {
					JOptionPane.showMessageDialog(null, et.getString("RFCfocus"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					textRFC.requestFocus();
				}

			}
			
			
		}
	}
}
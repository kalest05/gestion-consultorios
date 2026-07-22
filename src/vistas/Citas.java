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
import java.sql.Timestamp;
import java.text.ParseException;
import java.time.LocalDateTime;
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
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import org.jdesktop.swingx.autocomplete.AutoCompleteDecorator;

import com.github.lgooddatepicker.components.DatePickerSettings;
import com.github.lgooddatepicker.components.DateTimePicker;

import controladores.Ccitas;
import modelos.MCitas;

/**
 * 
 * Vista gráfica para el registro de citas. Esta ventana permite ingresar
 * informacion de nuevas citas para registrarlas en el sistema.
 * <p>
  * Esta clase extiende  y proporciona una ventana para la
 * visualización, creación, modificación y eliminación de registros de
 * citas. Incluye formularios para la captura de datos, tabla
 * para mostrar los citas existentes, y funcionalidades de validación,
 * búsqueda y paginación.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 05-06-2025
 */
public class Citas extends JFrame {

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
	/**
	 * Variable que toma el indice de la fila seleccionada en la tabla.
	 */
	public static int seleccion;
	/**
	 * Variable entera para verificacion de jtable
	 */
	public static int filaSeleccionada;
	private JLabel tituloCit;
	/**
	 * Variable que toma la fecha actual en el sistema.
	 */
	// private Date Hoy;
	/**
	 * Variable que almacena el id de la Cita en la clase {@code ManejadorBoton} a
	 * partir del indice 0 de la tabla.
	 */
	public static int idc;
	private JLabel jlfecha;
	private JTextArea textArea;
	private JTextArea textArea2;
	private JLabel jlmotivo;
	private JComboBox<String> JServicios;
	private JLabel jLConsultorio;
	/**
	 * Panel de desplazamiento que contiene la tabla que muestra las citas
	 * registradas.
	 */
	private JScrollPane scrollPanemot;
	private JScrollPane scrollPane2come;

	private JLabel jLServicios;
	private JTable Tabla;
	private JScrollPane scrollPane3;
	private JLabel jlidpaciente;
	private JLabel jlidmedico;
	private JComboBox<String> idpaciente;
	private JComboBox<String> idmedico;
	
	private JButton btnLimpiar;

	
	/**
	 * Botón que permite eliminar un elemento de la tabla.
	 */
	private JButton btnEliminar;
	/**
	 * Botón que permite modifica la información ingresada.
	 */
	private JButton btnModificar;
	/**
	 * Botón que permite guardar la información ingresada.
	 */
	private JButton btnGuardar;
	/**
	 * Modelo de datos para el combobox que contiene la lista de servicios
	 * registrados.
	 */
	private DefaultComboBoxModel<String> servicio;
	/**
	 * Modelo de datos para el combobox que contiene la lista de doctores
	 * registrados.
	 */
	private DefaultComboBoxModel<String> datosdoctor;
	/**
	 * Modelo de datos para el combobox que contiene la lista de pacientes
	 * registrados.
	 */
	private DefaultComboBoxModel<String> datospaciente;
	/**
	 * Modelo de datos para el combobox que contiene la lista de personal
	 * registrado.
	 */

	private int paginaActual = 1;
	private final int registrosPorPagina = 3;
	private int totalPaginas;
	private JButton btnsig;
	private JButton btnant;
	private JLabel jlpagina;
	private JLabel jlmod;
	private JTextField textConsultorio;
	private JLabel jlComent;
	private DateTimePicker dateTime;
	private JButton btnServi;
	private DatePickerSettings configd;
	private Servicios abrirS;

	/**
	 * Inicia la interfaz gráfica de usuario ejecutando la creación y visualización
	 * del frame principal "Citas".
	 * 
	 * @param args argumentos de linea de comandos.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Citas frame = new Citas();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
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
	 * <li>Carga datos de pacientes, doctores, personal y servicios en los
	 * ComboBox</li>
	 * <li>Establece el día minimo a seleccionar en el jdate chooser y no habilitar
	 * el uso de teclado para seleccionar fecha.</li>
	 * </ul>
	 */
	public Citas() {
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);

		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setIconImage(Toolkit.getDefaultToolkit().getImage(Citas.class.getResource("/imagenes/cita.png")));

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(40, 1, 1206, 656);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setToolTipText("");
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setLocationRelativeTo(null);

		setContentPane(contentPane);
		contentPane.setLayout(null);

		tituloCit = new JLabel(et.getString("RegistroCitas"));
		tituloCit.setForeground(new Color(0, 0, 139));
		tituloCit.setHorizontalAlignment(SwingConstants.CENTER);
		tituloCit.setFont(new Font("Times New Roman", Font.BOLD, 30));
		tituloCit.setBounds(214, 11, 645, 30);
		contentPane.add(tituloCit);

		// Hoy = new Date();

		jlfecha = new JLabel(et.getString("fech"));
		jlfecha.setForeground(new Color(50, 50, 50));
		jlfecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlfecha.setBounds(700, 89, 79, 14);
		contentPane.add(jlfecha);
		textArea = new JTextArea();
		textArea.setFont(new Font("Monospaced", Font.PLAIN, 17));

		scrollPanemot = new JScrollPane();
		scrollPanemot.setBounds(60, 280, 324, 126);
		scrollPanemot.setForeground(new Color(50, 50, 50));
		scrollPanemot.setBackground(Color.WHITE);
		scrollPanemot.setViewportView(textArea);
		contentPane.add(scrollPanemot);
		scrollPanemot.setViewportView(textArea);
		textArea2 = new JTextArea();
		textArea2.setFont(new Font("Monospaced", Font.PLAIN, 17));

		scrollPane2come = new JScrollPane();
		scrollPane2come.setBounds(600, 280, 324, 126);
		scrollPane2come.setForeground(new Color(50, 50, 50));
		scrollPane2come.setBackground(Color.WHITE);
		scrollPane2come.setViewportView(textArea2);
		contentPane.add(scrollPane2come);

		jlmotivo = new JLabel(et.getString("motivo"));
		jlmotivo.setForeground(new Color(50, 50, 50));
		jlmotivo.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlmotivo.setBounds(150, 250, 70, 14);
		contentPane.add(jlmotivo);

		servicio = new DefaultComboBoxModel<String>();
		servicio = Ccitas.llenarservicios();
		JServicios = new JComboBox<String>(servicio);
		JServicios.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JServicios.setBackground(new Color(255, 250, 250));
		JServicios.setForeground(new Color(50, 50, 50));
		JServicios.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		JServicios.setBounds(330, 195, 238, 30);
		contentPane.add(JServicios);
		AutoCompleteDecorator.decorate(this.JServicios);

		jLServicios = new JLabel(et.getString("servicios"));
		jLServicios.setForeground(new Color(50, 50, 50));
		jLServicios.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jLServicios.setBounds(350, 170, 91, 14);
		contentPane.add(jLServicios);

		

		jLConsultorio = new JLabel(et.getString("consul"));
		jLConsultorio.setForeground(new Color(50, 50, 50));
		jLConsultorio.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jLConsultorio.setBounds(23, 170, 150, 14);
		contentPane.add(jLConsultorio);

		scrollPane3 = new JScrollPane();
		scrollPane3.setBounds(260, 493, 651, 84);
		contentPane.add(scrollPane3);

		Tabla = new JTable();
		scrollPane3.setColumnHeaderView(Tabla);

		datospaciente = new DefaultComboBoxModel<String>();
		datosdoctor = new DefaultComboBoxModel<String>();

		datospaciente = Ccitas.llenarpaciente();
		datosdoctor = Ccitas.llenardoctor();

		jlidpaciente = new JLabel(et.getString("pacien"));
		jlidpaciente.setForeground(new Color(50, 50, 50));
		jlidpaciente.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlidpaciente.setBounds(20, 85, 118, 22);
		contentPane.add(jlidpaciente);

		idpaciente = new JComboBox<String>(datospaciente);
		idpaciente.setBackground(new Color(255, 250, 250));
		idpaciente.setForeground(new Color(50, 50, 50));
		idpaciente.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		idpaciente.setBounds(10, 110, 297, 30);
		contentPane.add(idpaciente);
		AutoCompleteDecorator.decorate(this.idpaciente);

		jlidmedico = new JLabel(et.getString("medic"));
		jlidmedico.setForeground(new Color(50, 50, 50));
		jlidmedico.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlidmedico.setBounds(350, 85, 132, 22);
		contentPane.add(jlidmedico);

		idmedico = new JComboBox<String>(datosdoctor);
		idmedico.setBackground(new Color(255, 250, 250));
		idmedico.setForeground(new Color(50, 50, 50));
		idmedico.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		idmedico.setBounds(340, 110, 284, 30);
		contentPane.add(idmedico);
		AutoCompleteDecorator.decorate(this.idmedico);

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

		btnsig = new JButton(et.getString("sig"));
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnsig.setBounds(440, 588, 105, 23);
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnant.setBounds(600, 588, 105, 23);
		contentPane.add(btnant);

		jlpagina = new JLabel(et.getString("pagina"));
		jlpagina.setBounds(830, 577, 79, 14);
		contentPane.add(jlpagina);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 11));
		jlmod.setBounds(400, 477, 333, 14);
		contentPane.add(jlmod);

		textConsultorio = new JTextField();
		textConsultorio.setBounds(10, 191, 130, 30);
		contentPane.add(textConsultorio);
		textConsultorio.setColumns(10);

		jlComent = new JLabel(et.getString("comad"));
		jlComent.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlComent.setBounds(680, 250, 152, 22);
		contentPane.add(jlComent);

		configd = new DatePickerSettings(Idioma);
		configd.setFormatForDatesCommonEra("dd-MM-yyyy");
		dateTime = new DateTimePicker(configd, null);
		dateTime.setDateTimeStrict(LocalDateTime.now());
		dateTime.getDatePicker().getComponentToggleCalendarButton().setText("▼");
		dateTime.setBounds(650, 114, 274, 30);
		contentPane.add(dateTime);

		btnServi = new JButton("");
		btnServi.setBackground(Color.WHITE);
		btnServi.setIcon(new ImageIcon(Citas.class.getResource("/imagenes/añadirsub.png")));
		btnServi.setBounds(578, 195, 35, 34);
		contentPane.add(btnServi);

		ManejadorBoton Escuchador = new ManejadorBoton();
		btnGuardar.addActionListener(Escuchador);
		btnEliminar.addActionListener(Escuchador);
		btnModificar.addActionListener(Escuchador);
		btnant.addActionListener(Escuchador);
		btnsig.addActionListener(Escuchador);
		btnServi.addActionListener(Escuchador);

		escuchadorc Click = new escuchadorc();
		Tabla.addMouseListener(Click);


		ManejadorKey EscuchadorKey = new ManejadorKey();
		textArea.addKeyListener(EscuchadorKey);
		textArea2.addKeyListener(EscuchadorKey);
		textConsultorio.addKeyListener(EscuchadorKey);
		
		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

		MostrarDatos();

		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);

	}

	/**
	 * Este metodo muestra en la interfaz los datos guardados de las citas.
	 * <p>
	 * Este método configura un model con las columnas necesarias para representar
	 * los campos de las tablas citas se llama al método con el controlador
	 * {@link Ccitas} para llenar el jtable con los datos recuperados.
	 * </p>
	 */
	public void MostrarDatos() {
		DefaultTableModel model = new DefaultTableModel();// definimos el objeto tableModel;
		Tabla.setModel(model);
		model.addColumn(et.getString("idcita"));
		model.addColumn(et.getString("idPaciente"));
		model.addColumn(et.getString("idMed"));
		model.addColumn(et.getString("fech"));
		model.addColumn(et.getString("motivo"));
		model.addColumn(et.getString("servicios"));
		model.addColumn(et.getString("comad"));
		model.addColumn(et.getString("consul"));

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Ccitas citas = new Ccitas();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// citas.buscarUsuariosConTableModel(model);
		citas.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane3.setViewportView(Tabla);

	}

	/**
	 * Actualiza el estado de los botones de navegación de página y la etiqueta que indica
	 * la página actual en la interfaz de usuario.
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
		totalPaginas = (int) Math.ceil((double) Ccitas.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

	}

	/**
	 * Manejador de eventos para los botones en la interfaz. Se encarga de responder
	 * a acciones como agregar, modificar o eliminar una receta.
	 * <p>
	 * La clase implementa para manejar los eventos de acción generados al hacer
	 * clic en los botones de una interfaz gráfica relacionada con citas médicas.
	 * Para realizar estas acciones, se usan los componentes. Esta clase también
	 * valida los campos para asegurarse de que no estén vacíos antes de guardar o
	 * modificar.
	 * </p>
	 * <ul>
	 * <li><b>Guardar</b>: Registra una nueva cita.</li>
	 * <li><b>Modificar</b>: Actualiza los datos de una cita seleccionada.</li>
	 * <li><b>Eliminar</b>: Borra una cita seleccionada de la tabla.</li>
	 * </ul>
	 * <p>
	 * Se utilizan objetos del modelo {@link MCitas} para representar la cita, y del
	 * controlador {@link controladores.Ccitas} para realizar operaciones de base de
	 * datos.
	 * </p>
	 */
	public class ManejadorBoton implements ActionListener {
		/**
		 * Este método se ejecuta automáticamente cuando se hace clic en cualquiera de
		 * los botones asociados a este ActionListener.
		 * 
		 * @param Evento Evento de acción generada.
		 * @throws Exception Si ocurre un error al guardar los datos en el objeto.
		 */
		public void actionPerformed(ActionEvent Evento) {
			
			 if (Evento.getSource().equals(btnServi)) {
				abrirS = new Servicios();
				abrirS.addWindowListener(new WindowAdapter() {
					@Override
					// para refrescar el combo
					public void windowClosed(WindowEvent e) {
						servicio = Ccitas.llenarservicios();
						JServicios.setModel(servicio);
					}
				});
				abrirS.setVisible(true);
			}
			 

			if (Evento.getSource() == btnant)

			{
				paginaActual--;
				MostrarDatos();
			}
			if (Evento.getSource() == btnLimpiar)

			{
				limpiar();
			}
			
			if (Evento.getSource() == btnsig) {
				paginaActual++;
				MostrarDatos();
			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idCitas = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Ccitas controladorec = new Ccitas();
					controladorec.eliminarcitas(idCitas, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionePacienteEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;
			}

			if (Evento.getSource().equals(btnModificar)) {

				if (idpaciente.getSelectedIndex() <= 0 || idmedico.getSelectedIndex() <= 0
						|| textArea.getText().isEmpty() || JServicios.getSelectedIndex() <= 0
						|| textConsultorio.getText().isEmpty() || textArea2.getText().isEmpty()
						|| dateTime.getDateTimePermissive().toString().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;

				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionado
					try {
						idc = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo
						MCitas altercita = new MCitas();
						
						LocalDateTime fechaSeleccionada = dateTime.getDateTimePermissive();
						Timestamp fechaSQL = Timestamp.valueOf(fechaSeleccionada);

						altercita.setIdPaciente(idpaciente.getSelectedItem().toString());
						altercita.setIdMedico(idmedico.getSelectedItem().toString());
						altercita.setMotivo(textArea.getText());
						altercita.setServicios(JServicios.getSelectedItem().toString());
						altercita.setComentario(textArea2.getText());
						altercita.setConsultorios(textConsultorio.getText());
						altercita.setFechaC(fechaSQL);

						// LLamar al controlador de Pacientes para metodo actualizar
						Ccitas controladorc = new Ccitas();
						controladorc.modificarPaciente(idc, altercita, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrModCit"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}
					return;

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneCita"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
			}

			if (Evento.getSource().equals(btnGuardar)) {
				if (idpaciente.getSelectedIndex() <= 0 || idmedico.getSelectedIndex() <= 0
						|| textArea.getText().isEmpty() || JServicios.getSelectedIndex() <= 0
						|| textConsultorio.getText().isEmpty() || textArea2.getText().isEmpty()
						||dateTime.getDateTimePermissive().toString().isEmpty()) {
					
					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;

				}
				if (dateTime.getDateTimePermissive() == null) {
					System.out.println("Fecha seleccionada: " + dateTime.getDateTimePermissive());
				}

				try {
					// Crear un nuevo objeto MPaciente
					MCitas nuevaCita = new MCitas();
					LocalDateTime fechaSeleccionada = dateTime.getDateTimePermissive();
					Timestamp fechaSQL = Timestamp.valueOf(fechaSeleccionada);
					// Asignar el nombre del paciente al objeto
					nuevaCita.setIdPaciente(idpaciente.getSelectedItem().toString());
					nuevaCita.setIdMedico(idmedico.getSelectedItem().toString());
					nuevaCita.setMotivo(textArea.getText());
					nuevaCita.setServicios(JServicios.getSelectedItem().toString());
					nuevaCita.setComentario(textArea2.getText());
					nuevaCita.setConsultorios(textConsultorio.getText());
					nuevaCita.setFechaC(fechaSQL);
					// Llamar a Controlador Cita

					Ccitas.anaCita(nuevaCita);

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

	/**
	 * 
	 * Restablece los campos del formulario a sus valores iniciales.
	 * <p>
	 * Este método se utiliza para limpiar el contenido ingresado por el usuario y
	 * preparar el formulario para una nueva entrada.
	 * </p>
	 */
	public void limpiar() {
		idpaciente.setSelectedIndex(0); // reinicia al día de hoy
		textArea.setText("");
		JServicios.setSelectedIndex(0);
		textConsultorio.setText("");
		textArea2.setText("");
		idmedico.setSelectedIndex(0);
		dateTime.setDateTimeStrict(LocalDateTime.now());
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
	 * Clase que implementa {@link MouseListener} para manejar eventos con el mouse.
	 * <p>
	 * Esta clase está diseñada para detectar cuando el usuario seleccione una fila
	 * de la tabla y ejecutar una acción específica, como mostrar datos relacionados
	 * con una cita.
	 * </p>
	 */
	public class escuchadorc implements MouseListener {
		/**
		 * Método invocado cuando ocurre un clic sobre un registro en Jtable.
		 * <p>
		 * Se imprime un mensaje en consola cuando presionan con el mouse un registro en
		 * la vista y llama al metodo para ejecutarlo.
		 * </p>
		 * 
		 */
		public void mouseClicked(MouseEvent e) {
			mostrodatoscita();

		}

		/**
		 * Muestra los datos de una receta seleccionada en la tabla {@code Tabla}.
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
		public void mostrodatoscita() {
			seleccion = Tabla.getSelectedRow();
			filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}
			idpaciente.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 1));
			idmedico.setSelectedItem( Tabla.getValueAt(filaSeleccionada, 2));
			Object valorFecha = Tabla.getValueAt(filaSeleccionada, 3);
			if (valorFecha instanceof Timestamp) {
			    dateTime.setDateTimePermissive(((Timestamp) valorFecha).toLocalDateTime());
			} else if (valorFecha instanceof String) {
			    // Ajustar formato
			    LocalDateTime fechaHora = LocalDateTime.parse((String) valorFecha);
			    dateTime.setDateTimePermissive(fechaHora);
			}
			textArea.setText(Tabla.getValueAt(filaSeleccionada, 4).toString());
			JServicios.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 5));
			textConsultorio.setText(Tabla.getValueAt(filaSeleccionada, 6).toString());
			textArea2.setText(Tabla.getValueAt(filaSeleccionada, 7).toString());

		}

		public void mousePressed(MouseEvent e) {
		}

		public void mouseReleased(MouseEvent e) {
			// TODO Auto-generated method stub

		}

		public void mouseEntered(MouseEvent e) {
			// TODO Auto-generated method stub

		}

		public void mouseExited(MouseEvent e) {
			// TODO Auto-generated method stub

		}

	}

	public class ManejadorKey implements KeyListener {
		/**
		 * Verifica que todos los caracteres ingresados sean validos.
		 * 
		 * @param EventKey Evento del teclado generado por el usuario.
		 */
		public void keyTyped(KeyEvent EventKey) {

		      //Validación texto
			
			if (EventKey.getSource() == textConsultorio) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textConsultorio.getText().length() >= 10) {

					JOptionPane.showMessageDialog(null, et.getString("descydom"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					}
				}
			
			if (EventKey.getSource() == textArea) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != ','
						&& EventKey.getKeyChar() != '.' || textArea.getText().length() > 250) {

					JOptionPane.showMessageDialog(null, et.getString("descydom"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
				}

			}
			if (EventKey.getSource() == textArea2) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != ',' 
						&& EventKey.getKeyChar() != '*' && EventKey.getKeyChar() != '-' && EventKey.getKeyChar() != '/' 
						&& EventKey.getKeyChar() != '.' || textArea2.getText().length() > 100) {

					JOptionPane.showMessageDialog(null, et.getString("descydom"), et.getString("tituloerror"),
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
			// TODO Auto-generated method stub

			}
		}
}
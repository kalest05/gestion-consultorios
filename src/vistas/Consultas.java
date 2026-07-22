package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.Window;
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
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import org.jdesktop.swingx.autocomplete.AutoCompleteDecorator;

import com.toedter.calendar.JDateChooser;

import controladores.Cconsultas;
import controladores.Cmedicos;
import modelos.MConsultas;
import java.awt.Toolkit;

/**
 * Clase representa la interfaz gráfica para el módulo de gestión de consultas
 * médicas.
 * <p>
 * Esta ventana permite registrar, modificar, eliminar y visualizar consultas
 * realizadas a pacientes. Incluye campos para diagnóstico, observaciones,
 * signos vitales (presión, temperatura, peso, altura), así como la fecha de la
 * consulta y la cita relacionada.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class Consultas extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JLabel tituloMed;
	/**
	 * Variable que toma el idioma predeterminado del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;
	private JLabel jlidpaciente;
	private JComboBox<String> idcita;
	private JLabel jlpaciente;
	private JLabel jlNomPaci;
	private JLabel jlMed;
	private JLabel jlNomMed;
	private JTextArea textArea;
	private JTextArea textArea2;
	private JScrollPane scrollPane;
	private JScrollPane scrollPane3;
	private JScrollPane scrollPane2com;
	private JLabel jlDiagnostico;
	private JLabel jlObservaciones;
	private JLabel jlpresion;
	private JTextField textPresion;
	private JLabel jlAltura;
	private JLabel jlTemperatura;
	private JTextField textTemp;
	private JLabel jlPeso;
	private JTextField textPeso;
	private JButton btnGuardar;
	private JButton btnModificar;
	private JButton btnEliminar;
	private JTable Tabla;
	private JLabel jlmod;
	private JLabel jlpagina;
	private JButton btnsig;
	private JButton btnant;
	private JLabel jlFecha;
	private JDateChooser fecha;
	private JButton btnLimpiar;
	private JSpinner Altura;
	/**
	 * Pagina donde se encuentra
	 */
	private int paginaActual = 1;
	/**
	 * Registros mostrados por paginas
	 */
	private final int registrosPorPagina = 3;
	/**
	 * Paginas totales segun la cantidad de registros por cada una
	 */
	private int totalPaginas;
	/**
	 * Variable entera donde se guarda la seleccion e la tabla
	 */
	public static int seleccion;
	/**
	 * Variable entera almacena el id de consulta
	 */
	public static int idConsulta;
	/**
	 * Variable para verificar la fila en la tabla
	 */
	public static int filaSeleccionada;
	private DefaultComboBoxModel<String> cita;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Consultas frame = new Consultas();
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
	public Consultas() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Consultas.class.getResource("/imagenes/icons8-texto-seo-24.png")));
		Idioma = Locale.getDefault();

		// Se cargan los textos traducio¿dos desde un archivo properties
		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(40, 1, 1206, 656);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setToolTipText("");
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		tituloMed = new JLabel(et.getString("cons"));
		tituloMed.setForeground(new Color(0, 0, 139));
		tituloMed.setHorizontalAlignment(SwingConstants.CENTER);
		tituloMed.setFont(new Font("Times New Roman", Font.BOLD, 30));
		tituloMed.setBounds(315, 29, 532, 30);
		contentPane.add(tituloMed);

		jlidpaciente = new JLabel(et.getString("idcita"));
		jlidpaciente.setForeground(new Color(50, 50, 50));
		jlidpaciente.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlidpaciente.setBounds(42, 85, 118, 22);
		contentPane.add(jlidpaciente);

		cita = new DefaultComboBoxModel<String>();
		cita = Cconsultas.llenarCita();

		idcita = new JComboBox<String>(cita);
		idcita.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		idcita.setBackground(new Color(224, 224, 224));
		idcita.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		idcita.setBounds(10, 110, 150, 30);
		contentPane.add(idcita);
		AutoCompleteDecorator.decorate(this.idcita);

		jlNomPaci = new JLabel("");
		jlNomPaci.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlNomPaci.setBounds(210, 110, 303, 30);
		contentPane.add(jlNomPaci);

		jlNomMed = new JLabel("");
		jlNomMed.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlNomMed.setBounds(545, 110, 303, 30);
		contentPane.add(jlNomMed);

		jlpaciente = new JLabel(et.getString("pacien"));
		jlpaciente.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlpaciente.setBounds(225, 85, 180, 22);
		contentPane.add(jlpaciente);

		jlMed = new JLabel(et.getString("medic"));
		jlMed.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlMed.setBounds(550, 85, 150, 22);
		contentPane.add(jlMed);

		// AutoCompleteDecorator.decorate(this.idpaciente);

		jlObservaciones = new JLabel(et.getString("obs"));
		jlObservaciones.setForeground(new Color(50, 50, 50));
		jlObservaciones.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlObservaciones.setBounds(87, 240, 180, 14);
		contentPane.add(jlObservaciones);

		jlDiagnostico = new JLabel(et.getString("diag"));
		jlDiagnostico.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlDiagnostico.setBounds(90, 350, 152, 22);
		contentPane.add(jlDiagnostico);

		textArea = new JTextArea();
		textArea.setBackground(new Color(255, 255, 255));

		scrollPane = new JScrollPane();
		scrollPane.setBounds(32, 260, 911, 85);
		scrollPane.setForeground(new Color(50, 50, 50));
		scrollPane.setBackground(new Color(255, 255, 255));
		scrollPane.add(textArea);
		scrollPane.setViewportView(textArea);

		contentPane.add(scrollPane);

		textArea2 = new JTextArea();

		scrollPane2com = new JScrollPane();
		scrollPane2com.setBounds(32, 370, 591, 85);
		scrollPane2com.setForeground(new Color(50, 50, 50));
		scrollPane2com.setBackground(new Color(224, 224, 224));
		scrollPane2com.add(textArea2);
		scrollPane2com.setViewportView(textArea2);

		contentPane.add(scrollPane2com);

		jlpresion = new JLabel(et.getString("prec"));
		jlpresion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlpresion.setBounds(20, 160, 150, 22);
		contentPane.add(jlpresion);

		textPresion = new JTextField();
		textPresion.setBounds(20, 190, 96, 30);
		contentPane.add(textPresion);
		textPresion.setColumns(10);

		jlAltura = new JLabel(et.getString("altura"));
		jlAltura.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlAltura.setBounds(287, 160, 96, 22);
		contentPane.add(jlAltura);

		Altura = new JSpinner();
		Altura.setBounds(280, 190, 60, 22);
		contentPane.add(Altura);

		jlTemperatura = new JLabel(et.getString("temp"));
		jlTemperatura.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlTemperatura.setBounds(540, 160, 111, 22);
		contentPane.add(jlTemperatura);

		textTemp = new JTextField();
		textTemp.setBounds(540, 190, 96, 30);
		contentPane.add(textTemp);
		textTemp.setColumns(10);

		jlPeso = new JLabel(et.getString("peso"));
		jlPeso.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlPeso.setBounds(890, 160, 70, 22);
		contentPane.add(jlPeso);

		textPeso = new JTextField();
		textPeso.setBounds(870, 190, 96, 30);
		contentPane.add(textPeso);
		textPeso.setColumns(10);

		scrollPane3 = new JScrollPane();
		scrollPane3.setBounds(42, 493, 901, 84);
		contentPane.add(scrollPane3);

		Tabla = new JTable();
		scrollPane3.setColumnHeaderView(Tabla);

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
		jlpagina.setBounds(799, 577, 84, 14);
		contentPane.add(jlpagina);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 11));
		jlmod.setBounds(350, 475, 333, 14);
		contentPane.add(jlmod);

		btnsig = new JButton(et.getString("sig"));
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnsig.setBounds(360, 587, 105, 23);
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnant.setBounds(557, 587, 105, 23);
		contentPane.add(btnant);

		jlFecha = new JLabel(et.getString("Fch"));
		jlFecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlFecha.setBounds(890, 85, 62, 14);
		contentPane.add(jlFecha);

		fecha = new JDateChooser(new Date());
		fecha.setBounds(870, 110, 180, 30);
		contentPane.add(fecha);

		ManejadorBoton Escuchador = new ManejadorBoton();
		btnGuardar.addActionListener(Escuchador);
		btnModificar.addActionListener(Escuchador);
		btnEliminar.addActionListener(Escuchador);
		btnant.addActionListener(Escuchador);
		btnsig.addActionListener(Escuchador);
		btnLimpiar.addActionListener(Escuchador);
		idcita.addActionListener(Escuchador);

		ManejadorKey keyListener = new ManejadorKey();
		textTemp.addKeyListener(keyListener);
		textPresion.addKeyListener(keyListener);
		textPeso.addKeyListener(keyListener);
		textArea.addKeyListener(keyListener);
		textArea2.addKeyListener(keyListener);

		ManejadorMouse clicked = new ManejadorMouse();
		Tabla.addMouseListener(clicked);

		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);

		MostrarDatos();

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
	 * Luego, utiliza un objeto controlador {@code Cconsultas} para cargar los datos
	 * paginados correspondientes a la página actual y número de registros por
	 * página.
	 * </p>
	 */
	public void MostrarDatos() {
		DefaultTableModel model;
		model = new DefaultTableModel();// definimos el objeto tableModel

		Tabla.setModel(model);
		model.addColumn("ID");
		model.addColumn(et.getString("idcita"));
		model.addColumn(et.getString("Fch"));
		model.addColumn(et.getString("diag"));
		model.addColumn(et.getString("obs"));
		model.addColumn(et.getString("prec"));
		model.addColumn(et.getString("temp"));
		model.addColumn(et.getString("altura"));
		model.addColumn(et.getString("peso"));

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Cconsultas consultas = new Cconsultas();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// medicos.buscarUsuariosConTableModel(model);

		consultas.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane3.setViewportView(Tabla);

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
		totalPaginas = (int) Math.ceil((double) Cmedicos.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

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
		textPresion.setText("");
		textTemp.setText("");
		textPeso.setText("");
		textArea2.setText("");
		textArea.setText("");
		Altura.setValue(0);
		fecha.setDate(new Date()); // reinicia al día de hoy
		idcita.setSelectedItem(et.getString("SEL"));

	}

	/**
	 * Clase interna que implementa {@link ListSelectionListener} para manejar los
	 * eventos de selección de filas en la tabla de consultas.
	 * 
	 * <p>
	 * Esta clase permite activar o desactivar botones de acción dependiendo de si
	 * una fila de la tabla está seleccionada. Específicamente, activa los botones
	 * de modificar y eliminar cuando hay una selección, y desactiva el botón de
	 * guardar.
	 * </p>
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
	 * Clase que implementa la interfaz {@link MouseListener} para manejar eventos
	 * de clic sobre la tabla de consultas médicas.
	 * <p>
	 * Su propósito es capturar cuando el usuario hace clic en un registro (fila) de
	 * la tabla y cargar los datos del registro en los campos del formulario para su
	 * visualización o edición.
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
			idcita.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 1).toString());

			try {
				// Asignar la fecha correctamente
				String fechaString = Tabla.getValueAt(filaSeleccionada, 2).toString();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date fechas = sdf.parse(fechaString);
				fecha.setDate(fechas);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			textArea.setText(Tabla.getValueAt(filaSeleccionada, 3).toString());
			textArea2.setText(Tabla.getValueAt(filaSeleccionada, 4).toString());

			textPresion.setText(Tabla.getValueAt(filaSeleccionada, 5).toString());
			textTemp.setText(Tabla.getValueAt(filaSeleccionada, 6).toString());
			Altura.setValue(Integer.parseInt(Tabla.getValueAt(filaSeleccionada, 7).toString()));
			textPeso.setText(Tabla.getValueAt(filaSeleccionada, 8).toString());
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
	 * Clase que implementa {@link ActionListener} para manejar las acciones de los
	 * botones en la vista de consultas médicas.
	 * <p>
	 * Esta clase controla los eventos generados por botones como: guardar,
	 * modificar, eliminar, limpiar y navegación por páginas. Además, actualiza los
	 * nombres del paciente y médico cuando se selecciona una cita.
	 * </p>
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

			if (idcita.getSelectedIndex() > 0) {
				try {
					int idCita = Integer.parseInt(idcita.getSelectedItem().toString());
					String[] nombres = Cconsultas.obtenerNombresPorCita(idCita);

					if (nombres != null) {
						jlNomPaci.setText(nombres[0]);
						jlNomMed.setText(nombres[1]);
					}
				} catch (NumberFormatException ex) {
					System.out.println(et.getString("IDNV"));
				}
			} else {
				jlNomPaci.setText("");
				jlNomMed.setText("");
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

				if (textPresion.getText().trim().isEmpty() || textTemp.getText().trim().isEmpty()
						|| textPeso.getText().trim().isEmpty() || idcita.getSelectedIndex() <= 0
						|| textArea2.getText().trim().isEmpty() || textArea.getText().trim().isEmpty() || fecha == null
						|| Altura.getValue().toString().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						idConsulta = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MConsultas ConsultaM = new MConsultas();
						// Asignar el nombre del paciente al objeto

						ConsultaM.setAltura(Altura.getValue().toString().trim());
						ConsultaM.setDiagnostico(textArea.getText().trim());
						ConsultaM.setFecha(fecha.getDate());
						ConsultaM.setIdCita(Integer.parseInt(idcita.getSelectedItem().toString()));
						ConsultaM.setObservaciones(textArea2.getText().trim());
						ConsultaM.setPeso(textPeso.getText().trim());
						ConsultaM.setPresion(textPresion.getText().trim());
						ConsultaM.setTemp(textTemp.getText().trim());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cconsultas contcon = new Cconsultas();
						contcon.modificarCon(idConsulta, ConsultaM, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModPaciente"),
								et.getString("err"), JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionePacienteEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;

			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					idConsulta = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cconsultas controlador = new Cconsultas();
					controlador.eliminarconsulta(idConsulta, (DefaultTableModel) Tabla.getModel(), seleccion);
					limpiar();
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionePacienteEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;

			}

			if (Evento.getSource().equals(btnGuardar)) {
				if (textPresion.getText().trim().isEmpty() || textTemp.getText().trim().isEmpty()
						|| textPeso.getText().trim().isEmpty() || idcita.getSelectedIndex() <= 0
						|| textArea2.getText().trim().isEmpty() || textArea.getText().trim().isEmpty() || fecha == null
						|| Altura.getValue().toString().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto MPaciente
					MConsultas nuevaConsulta = new MConsultas();
					// Asignar el nombre del paciente al objeto

					nuevaConsulta.setAltura(Altura.getValue().toString().trim());
					nuevaConsulta.setDiagnostico(textArea.getText().trim());
					nuevaConsulta.setFecha(fecha.getDate());
					nuevaConsulta.setIdCita(Integer.parseInt(idcita.getSelectedItem().toString()));
					nuevaConsulta.setObservaciones(textArea2.getText().trim());
					nuevaConsulta.setPeso(textPeso.getText().trim());
					nuevaConsulta.setPresion(textPresion.getText().trim());
					nuevaConsulta.setTemp(textTemp.getText().trim());

					// Llamar al método estático para añadir el paciente
					// Cconsultas.AnCon(nuevaConsulta);

					int idConsultaGenerada = Cconsultas.AnCon(nuevaConsulta);

					if (idConsultaGenerada != -1) {
						int respuesta = JOptionPane.showConfirmDialog(null, et.getString("ANC"), et.getString("AR"),
								JOptionPane.YES_NO_OPTION);

						if (respuesta == JOptionPane.YES_OPTION) {
							Recetas ventanaRecetas = new Recetas();
							ventanaRecetas.llenacomboauto(idConsultaGenerada);
							ventanaRecetas.mandaid(idConsultaGenerada);
							ventanaRecetas.setVisible(true);
							Window ventana = SwingUtilities.getWindowAncestor(btnGuardar);
							if (ventana != null) {
								ventana.dispose();
							}
						}
					}
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

	public class ManejadorKey implements KeyListener {
		/**
		 * Verifica que todos los caracteres ingresados sean validos.
		 * 
		 * @param EventKey Evento del teclado generado por el usuario.
		 */
		public void keyTyped(KeyEvent EventKey) {

			// Validación texto

			if (EventKey.getSource() == textTemp) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != '°'
						&& EventKey.getKeyChar() != '.' || textTemp.getText().length() >= 10) {

					JOptionPane.showMessageDialog(null, et.getString("descydom"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
				}
			}

			if (EventKey.getSource() == textPresion) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != '/'
						&& EventKey.getKeyChar() != '.' || textPresion.getText().length() >= 30) {

					JOptionPane.showMessageDialog(null, et.getString("descydom"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
				}
			}
			if (EventKey.getSource() == textPeso) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_ENTER
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE && EventKey.getKeyChar() != '.'
						|| textPeso.getText().length() >= 6) {

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
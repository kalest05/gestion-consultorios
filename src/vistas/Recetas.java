package vistas;

import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.BoxLayout;
import javax.swing.ComboBoxModel;
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
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import org.jdesktop.swingx.autocomplete.AutoCompleteDecorator;

import com.toedter.calendar.JDateChooser;

import controladores.Cconsultas;
import controladores.Crecetas;
import modelos.MReceta;

/**
 * 
 * Interfaz gráfica para el registro de recetas.
 * <p>
 * Esta ventana permite ingresar informacion de nuevas recetas para registrarlas
 * en el sistema, mediante la parte visual donde el usuario interactua de forma
 * dinamica con la tabla Recetas.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Recetas extends JFrame {

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
	private JLabel jltitulo;
	private JLabel idcita;
	private JLabel jlmod;

	private JLabel fecha;
	/**
	 * Variable que almacena el id de la Receta en la clase {@code ManejadorBoton} a
	 * partir del indice 0 de la tabla.
	 */
	public static int idrec;
	/**
	 * Variable que toma la fecha actual en el sistema.
	 */
	private Date Hoy;
	public JDateChooser Calendario;
	private JLabel instruccion;
	/**
	 * Variable que toma el indice de la fila seleccionada en la tabla.
	 */
	public int seleccion;
	/**
	 * Panel de desplazamiento que que contiene el area de texto para ingresar
	 * instrucciones.
	 */
	private JScrollPane scrollPane;
	private JTextArea textArea;
	/**
	 * Botón que permite guardar la información ingresada.
	 */
	private JButton btnGuardar;
	/**
	 * Botón que permite eliminar un elemento de la tabla.
	 */
	private JButton btnEliminar;
	/**
	 * Tabla que muestra la lista de recetas registradas.
	 */
	private JTable Tabla;
	/**
	 * Panel de desplazamiento que contiene la tabla que muestra las recetas.
	 */
	private JScrollPane scrollPane2;
	/**
	 * Modelo de datos para el combobox que contiene la lista de medicamentos
	 * disponibles.
	 */
	private DefaultComboBoxModel<String> medicamento;
	/**
	 * Modelo de datos para el combobox que contiene la lista de citas registradas.
	 */
	private DefaultComboBoxModel<String> citas;
	private JComboBox<String> CCitas;
	private JButton btnLimpiar;
	/**
	 * Botón que permite modifica la información ingresada.
	 */
	private JButton btnModificar;
	/**
	 * Variable Entera para verificacion de JTable
	 */
	private int filaSeleccionada;
	private JButton btnsig;
	private JButton btnant;
	private JLabel jlpagina;
	private int paginaActual = 1;
	private final int registrosPorPagina = 3;
	private int totalPaginas;
	private JLabel jnombrep;

	private JScrollPane scrollPaneOb;
	private JTextArea textAreaOb;
	private JLabel jlObs;
	private JLabel jnombrem;
	private ArrayList<String> medicamentos = new ArrayList<>();
	private ArrayList<Integer> cantidades = new ArrayList<>();
	private ArrayList<JPanel> panelesGrupos = new ArrayList<>();
	private JLabel pac;
	private JLabel lblMedico;
	private JScrollPane scrollPaneM;
	private JButton btnAnadir;
	private JPanel panelMedicamentos;
	JComboBox<String> combom;
	private JLabel lblMedic;
	private int idRecetaparamostrar;
	private JButton btnReimprimir;

	/**
	 * Inicia la interfaz gráfica de usuario ejecutando la creación y visualización
	 * del frame principal "Recetas".
	 * 
	 * @param args argumentos de linea de comandos.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Recetas frame = new Recetas();
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
	 * Inicializa y agrega las configuraciones visuales delos componentes al
	 * contenedor principal. establece los componentes Swing como etiquetas, tablas,
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
	 * <li>Carga datos de citas y medicamentos en los ComboBox</li>
	 * <li>Establece el día minimo a seleccionar en el jdate chooser y no
	 * inhabilitar el uso de teclado para seleccionar fecha.</li>
	 * <li>Se declaran variables para añadirlos a las clases manejadoras</li>
	 * </ul>
	 */
	public Recetas() {
		Tabla = new JTable();
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setIconImage(Toolkit.getDefaultToolkit().getImage(Menu.class.getResource("/imagenes/receta.png")));

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(45, 10, 1206, 638);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(255, 255, 255));
		contentPane.setToolTipText("");
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		jltitulo = new JLabel(et.getString("recetas"));
		jltitulo.setForeground(new Color(0, 0, 139));
		jltitulo.setHorizontalAlignment(SwingConstants.CENTER);
		jltitulo.setFont(new Font("Times New Roman", Font.BOLD, 30));
		jltitulo.setBounds(379, 11, 421, 30);
		contentPane.add(jltitulo);

		idcita = new JLabel(et.getString("idconsulta"));
		idcita.setBounds(20, 70, 150, 22);
		idcita.setForeground(new Color(50, 50, 50));
		idcita.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(idcita);

		fecha = new JLabel(et.getString("fech"));
		fecha.setForeground(new Color(50, 50, 50));
		fecha.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		fecha.setBounds(1034, 34, 121, 21);
		contentPane.add(fecha);

		Hoy = new Date();
		Calendario = new JDateChooser();
		Calendario.setBounds(1019, 62, 150, 30);
		Calendario.setDateFormatString("dd/MM/yyyy");
		Calendario.setDate(Hoy);
		Calendario.setMinSelectableDate(Hoy);
		((JTextField) Calendario.getDateEditor().getUiComponent()).setEditable(false);
		contentPane.add(Calendario);

		instruccion = new JLabel(et.getString("Ins"));
		instruccion.setForeground(new Color(50, 50, 50));
		instruccion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		instruccion.setBounds(34, 145, 168, 22);
		contentPane.add(instruccion);

		scrollPane = new JScrollPane();
		scrollPane.setFont(new Font("Colonna MT", Font.PLAIN, 17));
		scrollPane.setBounds(34, 177, 405, 107);

		contentPane.add(scrollPane);

		textArea = new JTextArea();
		scrollPane.setViewportView(textArea);

		textAreaOb = new JTextArea();

		scrollPaneOb = new JScrollPane();
		scrollPaneOb.setFont(new Font("Comic Sans MS", Font.PLAIN, 17));
		scrollPaneOb.setBounds(512, 177, 433, 107);
		scrollPaneOb.add(textAreaOb);
		scrollPaneOb.setViewportView(textAreaOb);

		contentPane.add(scrollPaneOb);

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

		Tabla = new JTable();

		scrollPane2 = new JScrollPane();
		scrollPane2.setBounds(143, 449, 854, 98);
		scrollPane2.add(Tabla);
		contentPane.add(scrollPane2);
		scrollPane2.setColumnHeaderView(Tabla);

		citas = new DefaultComboBoxModel<String>();
		citas = Crecetas.llenarcitacb();

		CCitas = new JComboBox<String>(citas);
		CCitas.setBounds(20, 102, 150, 30);
		contentPane.add(CCitas);
		AutoCompleteDecorator.decorate(this.CCitas);

		btnsig = new JButton(et.getString("sig"));
		btnsig.setHorizontalTextPosition(SwingConstants.LEFT);
		btnsig.setForeground(SystemColor.window);
		btnsig.setBackground(new Color(153, 204, 255));
		btnsig.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnsig.setBounds(10, 508, 105, 25);
		contentPane.add(btnsig);

		btnant = new JButton(et.getString("ant"));
		btnant.setHorizontalTextPosition(SwingConstants.LEFT);
		btnant.setForeground(SystemColor.textHighlightText);
		btnant.setForeground(SystemColor.window);
		btnant.setBackground(new Color(153, 204, 255));
		btnant.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		btnant.setBounds(10, 469, 105, 25);
		contentPane.add(btnant);

		jlpagina = new JLabel(et.getString("pagina"));
		jlpagina.setBounds(918, 553, 78, 14);
		contentPane.add(jlpagina);

		jlmod = new JLabel(et.getString("nota"));
		jlmod.setFont(new Font("Tahoma", Font.PLAIN, 15));
		jlmod.setBounds(272, 557, 584, 22);
		contentPane.add(jlmod);

		jnombrep = new JLabel("");
		jnombrep.setBounds(203, 102, 363, 30);
		contentPane.add(jnombrep);

		jnombrem = new JLabel("");
		jnombrem.setBounds(568, 102, 401, 30);
		contentPane.add(jnombrem);

		jlObs = new JLabel(et.getString("diag"));
		jlObs.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jlObs.setBounds(578, 145, 139, 22);
		contentPane.add(jlObs);

		btnModificar.setEnabled(false);
		btnEliminar.setEnabled(false);
		btnGuardar.setEnabled(true);

		pac = new JLabel(et.getString("pac"));
		pac.setForeground(new Color(50, 50, 50));
		pac.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		pac.setBounds(250, 70, 150, 22);
		contentPane.add(pac);

		lblMedico = new JLabel(et.getString("med"));
		lblMedico.setForeground(new Color(50, 50, 50));
		lblMedico.setFont(new Font("Comic Sans MS", Font.BOLD, 15));
		lblMedico.setBounds(580, 70, 150, 22);
		contentPane.add(lblMedico);

		scrollPaneM = new JScrollPane();
		scrollPaneM.setBounds(382, 315, 474, 115);
		contentPane.add(scrollPaneM);

		panelMedicamentos = new JPanel();
		panelMedicamentos.setBackground(Color.WHITE);
		panelMedicamentos.setLayout(new BoxLayout(panelMedicamentos, BoxLayout.Y_AXIS));
		scrollPaneM.setViewportView(panelMedicamentos);

		btnAnadir = new JButton(et.getString("anmed"));
		btnAnadir.setForeground(new Color(0, 0, 0));
		btnAnadir.setBackground(new Color(153, 204, 255));		
		btnAnadir.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnAnadir.setBounds(100, 365, 168, 30);
		contentPane.add(btnAnadir);

		lblMedic = new JLabel(et.getString("ingrese"));
		lblMedic.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		lblMedic.setBounds(21, 333, 379, 22);
		contentPane.add(lblMedic);

		btnReimprimir = new JButton(et.getString("rei"));
		btnReimprimir.setBounds(1045, 567, 137, 23);
		btnReimprimir.setFont(new Font("Tahoma", Font.PLAIN, 14));
		contentPane.add(btnReimprimir);

		// METODOS ESCUCHADORES
		ManejadorMouse Escuchadorm = new ManejadorMouse();
		Tabla.addMouseListener(Escuchadorm);

		ManejadorBoton Escuchadorbtn = new ManejadorBoton();
		btnGuardar.addActionListener(Escuchadorbtn);
		btnEliminar.addActionListener(Escuchadorbtn);
		btnModificar.addActionListener(Escuchadorbtn);
		btnant.addActionListener(Escuchadorbtn);
		btnsig.addActionListener(Escuchadorbtn);
		CCitas.addActionListener(Escuchadorbtn);
		btnAnadir.addActionListener(Escuchadorbtn);
		btnReimprimir.addActionListener(Escuchadorbtn);

		ManejadorKey escuchadork = new ManejadorKey();
		textAreaOb.addKeyListener(escuchadork);

		// instruccion.addKeyListener(EscuchadorKey);

		Seleccion escuchador = new Seleccion();
		Tabla.getSelectionModel().addListSelectionListener(escuchador);
		MostrarDatos();

	}

	/**
	 * 
	 * Este metodo muestra en la interfaz los Medicamentos guardados de las Recetas.
	 * <p>
	 * Este método configura un model con las columnas necesarias para representar
	 * los campos de la tabla RECETAMEDICAMENTOS, se llama al método con el
	 * controlador para llenar el jtable con los datos recuperados.
	 * </p>
	 * 
	 */

	/**
	 * 
	 * Este metodo muestra en la interfaz los datos guardados de las Recetas
	 * registradas.
	 * <p>
	 * Este método configura un model con las columnas necesarias para representar
	 * los campos de las tablas recetas se llama al método con el controlador
	 * {@link controladores.Crecetas} para llenar el jtable con los datos
	 * recuperados.
	 * </p>
	 * 
	 */
	public void MostrarDatos() {
		DefaultTableModel model = new DefaultTableModel();// definimos el objeto tableModel;
		Tabla.setModel(model);

		model.addColumn("ID");
		model.addColumn(et.getString("idconsulta"));
		model.addColumn(et.getString("fech"));
		model.addColumn(et.getString("diag"));
		model.addColumn(et.getString("inst"));

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Crecetas recetas = new Crecetas();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// recetas.buscarUsuariosConTableModel(model);

		recetas.buscarUsuariosConTableModel(model, paginaActual, registrosPorPagina);
		actualizarEstadoBotones();

		scrollPane2.setViewportView(Tabla);

	}

	private void actualizarEstadoBotones() {
		// TODO Auto-generated method stub
		totalPaginas = (int) Math.ceil((double) Crecetas.contarRegistros() / registrosPorPagina);
		jlpagina.setText(et.getString("pagina") + paginaActual + "/" + totalPaginas);
		btnant.setEnabled(paginaActual > 1);
		btnsig.setEnabled(paginaActual < totalPaginas);

	}

	/**
	 * Clase que implementa {@link MouseListener} para manejar eventos con el mouse.
	 * <p>
	 * Esta clase está diseñada para detectar cuando el usuario seleccione una fila
	 * de la tabla y ejecutar una acción específica, como mostrar datos relacionados
	 * con una receta.
	 * </p>
	 */
	public class ManejadorMouse implements MouseListener {

		/**
		 * Método invocado cuando ocurre un clic sobre un registro en Jtable.
		 * <p>
		 * Se imprime un mensaje en consola cuando presionan con el mouse un registro en
		 * la vista y llama al metodo para ejecutarlo.
		 * </p>
		 * 
		 */
		public void mouseClicked(MouseEvent e) {
			if (e.getSource() == Tabla) {
				mostrodatosrecetita();
			}

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
		public void mostrodatosrecetita() {
			seleccion = Tabla.getSelectedRow();
			filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("SeleccioneReglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}

			// Obtener los datos de la fila seleccionada
			CCitas.setSelectedItem((int) Tabla.getValueAt(filaSeleccionada, 1));
			String fechaString = Tabla.getValueAt(filaSeleccionada, 2).toString();

			try {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date fecha = sdf.parse(fechaString);
				if (Calendario != null) {
					Calendario.setDate(fecha);
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}

			textAreaOb.setText(Tabla.getValueAt(filaSeleccionada, 3).toString());
			textArea.setText(Tabla.getValueAt(filaSeleccionada, 4).toString());
			// Mostrar medicamentos y cantidades en paneles para medicamentos LIST JPANEL
			idRecetaparamostrar = Integer.parseInt(Tabla.getValueAt(filaSeleccionada, 0).toString());
			mostrarMedicamentosDeReceta(idRecetaparamostrar);

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
	 * Manejador de eventos para los botones en la interfaz. Se encarga de responder
	 * a acciones como agregar, modificar o eliminar una receta.
	 * <p>
	 * La clase implementa para manejar los eventos de acción generados al hacer
	 * clic en los botones de una interfaz gráfica relacionada con recetas médicas.
	 * </p>
	 * <ul>
	 * <li><b>Guardar</b>: Registra una nueva receta.</li>
	 * <li><b>Modificar</b>: Actualiza los datos de una receta seleccionada.</li>
	 * <li><b>Eliminar</b>: Borra una receta seleccionada de la tabla.</li>
	 * </ul>
	 * <p>
	 * Se utilizan objetos del modelo {@link MReceta} para representar la receta, y
	 * del controlador {@link controladores.Crecetas} para realizar operaciones de
	 * base de datos.
	 * </p>
	 * 
	 */
	public class ManejadorBoton implements ActionListener {

		private ComboBoxModel<String> Recetasm;
		private JComboBox<String> comboRecetas;

		/**
		 * Este método se ejecuta automáticamente cuando se hace clic en cualquiera de
		 * los botones asociados a este ActionListener.
		 * 
		 * @param Evento Evento de acción generada.
		 * @throws Exception Si ocurre un error al guardar los datos en el objeto.
		 */
		public void actionPerformed(ActionEvent Evento) {
			if (CCitas.getSelectedIndex() > 0) {
				try {
					int idCita = Integer.parseInt(CCitas.getSelectedItem().toString());
					String[] nombres = Cconsultas.obtenerNombresPorConsulta(idCita);

					if (nombres != null) {
						jnombrep.setText(nombres[0]);
						jnombrem.setText(nombres[1]);
					}
				} catch (NumberFormatException ex) {
					System.out.println("ID de cita no válido.");
				}
			} else {
				jnombrem.setText("");
				jnombrep.setText("");
			}

			if (Evento.getSource() == btnReimprimir) {
				JDateChooser dateChooser = new JDateChooser();
				dateChooser.setDateFormatString("yyyy-MM-dd");

				int opcionFecha = JOptionPane.showConfirmDialog(null, dateChooser, "Seleccione la fecha de búsqueda",
						JOptionPane.OK_CANCEL_OPTION);

				if (opcionFecha == JOptionPane.OK_OPTION) {
					Date fechaSeleccionada = dateChooser.getDate();
					if (fechaSeleccionada == null) {
						JOptionPane.showMessageDialog(null, "Debe seleccionar una fecha válida.");
						return;
					}

					 Recetasm = new DefaultComboBoxModel<String>();
						Recetasm=Crecetas.obtenerRecetasPorFecha(fechaSeleccionada);

					if (Recetasm.getSize() == 0) {
						JOptionPane.showMessageDialog(null, "No hay recetas registradas en esa fecha.");
						return;
					}

					comboRecetas = new JComboBox<String>(Recetasm);
					AutoCompleteDecorator.decorate(comboRecetas);

					int opcionReceta = JOptionPane.showConfirmDialog(null, comboRecetas,
					        "Seleccione una receta del paciente", JOptionPane.OK_CANCEL_OPTION);

					if (opcionReceta == JOptionPane.OK_OPTION) {
					    String seleccionado = comboRecetas.getSelectedItem().toString();
					    try {
					        int idReceta = Crecetas.buscaridreceta(seleccionado, fechaSeleccionada);
					        if (idReceta != -1) {
					            Crecetas.generarReceta(idReceta);
					        } else {
					            JOptionPane.showMessageDialog(null, "No se encontró receta para ese paciente en esa fecha.");
					        }
					    } catch (NumberFormatException e) {
					        JOptionPane.showMessageDialog(null, "Error al interpretar el ID de la receta.");
					    }
					}
				}
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

			if (Evento.getSource().equals(btnAnadir)) {
				agregarMedicamento();
			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow();
				if (seleccion != -1) {
					idrec = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Crecetas controlador = new Crecetas();
					controlador.eliminarRe(idrec, (DefaultTableModel) Tabla.getModel(), seleccion);
					limpiar();
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionRectEliminar"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;

			}

			if (Evento.getSource().equals(btnModificar)) {
				// Recolectar medicamentos y cantidades actualizados
				recolectarMedicamentos();

				// Validar campos obligatorios
				if (CCitas.getSelectedItem().toString().isEmpty() || medicamentos.isEmpty() || Calendario == null
						|| textArea.getText().isEmpty() || cantidades.isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}
				// Obtener la fila seleccionada
				seleccion = Tabla.getSelectedRow();
				if (seleccion != -1) {
					try {
						// Obtener el ID de la receta desde la tabla
						idrec = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());

						// Crear objeto receta actualizado
						MReceta recetaAc = new MReceta();
						recetaAc.setIdcita(Integer.parseInt(CCitas.getSelectedItem().toString()));
						recetaAc.setFecha(Calendario.getDate());
						recetaAc.setDuracion(textAreaOb.getText());
						recetaAc.setNstruccion(textArea.getText());

						// Llamar al nuevo método Modi
						Crecetas.ModificarActualizado(idrec, recetaAc, (DefaultTableModel) Tabla.getModel(), cantidades,
								medicamentos, seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModificar"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos(); // Refrescar tabla
						limpiar(); // Limpiar campos
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneRec"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
			}

			if (Evento.getSource().equals(btnGuardar)) {
				recolectarMedicamentos();

				if (CCitas.getSelectedItem().toString().isEmpty() || medicamentos.isEmpty() || Calendario == null
						|| textArea.getText().isEmpty() || cantidades.isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;

				}

				try {
					// Crear un nuevo objeto MPaciente
					MReceta nuevareceta = new MReceta();
					// Asignar el nombre del paciente al objeto
					nuevareceta.setIdcita(Integer.parseInt(CCitas.getSelectedItem().toString()));
					nuevareceta.setFecha(Calendario.getDate());
					nuevareceta.setDuracion(textAreaOb.getText());
					nuevareceta.setNstruccion(textArea.getText());

					// Crecetas.nuevaReceta(nuevareceta, cantidades, medicamentos);
					int idRecetaGenerada = Crecetas.nuevaRecetaImp(nuevareceta, cantidades, medicamentos);
					// Crecetas.nuevaReceta(nuevareceta, cantidades, medicamentos);
					if (idRecetaGenerada != -1) {
						int respuesta = JOptionPane.showConfirmDialog(null, et.getString("GREI"), et.getString("Conf"),
								JOptionPane.YES_NO_OPTION);

						if (respuesta == JOptionPane.YES_OPTION) {
							Crecetas.generarReceta(idRecetaGenerada);
						}
					}

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

	public void agregarMedicamento() {
		JPanel panelGrupo = new JPanel();
		panelGrupo.setLayout(new FlowLayout(FlowLayout.LEFT, 10, 10));
		panelGrupo.setPreferredSize(new Dimension(470, 45));
		panelGrupo.setMaximumSize(new Dimension(470, 45));
		panelGrupo.setBackground(new Color(220, 235, 250));

		JLabel lbl = new JLabel(et.getString("Medi"));
		lbl.setFont(new Font("Tahoma", Font.PLAIN, 12));
		panelGrupo.add(lbl);

		medicamento = new DefaultComboBoxModel<String>();
		medicamento = Crecetas.llenarmedicamento();

		combom = new JComboBox<String>(medicamento);
		combom.setFont(new Font("Tahoma", Font.PLAIN, 12));
		combom.setPreferredSize(new Dimension(150, 25));
		panelGrupo.add(combom);
		AutoCompleteDecorator.decorate(this.combom);

		JLabel lblCantidad = new JLabel(et.getString("cant"));
		lblCantidad.setFont(new Font("Tahoma", Font.PLAIN, 12));
		panelGrupo.add(lblCantidad);

		JSpinner spinner = new JSpinner(new SpinnerNumberModel(1, 1, 100, 1));
		spinner.setFont(new Font("Tahoma", Font.PLAIN, 12));
		spinner.setPreferredSize(new Dimension(50, 25));
		panelGrupo.add(spinner);

		JButton btnEliminar = new JButton(et.getString("elimedi"));
		btnEliminar.setFont(new Font("Tahoma", Font.PLAIN, 11));
		btnEliminar.setPreferredSize(new Dimension(75, 25));
		panelGrupo.add(btnEliminar);

		final int index = medicamentos.size() - 1;

		btnEliminar.addActionListener(e -> {
			panelMedicamentos.remove(panelGrupo);
			panelesGrupos.remove(panelGrupo);

			if (index >= 0 && index < medicamentos.size()) {
				medicamentos.remove(index);
				cantidades.remove(index);
			}

			panelMedicamentos.revalidate();
			panelMedicamentos.repaint();
		});

		panelMedicamentos.add(panelGrupo);
		panelesGrupos.add(panelGrupo);
		panelMedicamentos.revalidate();
		panelMedicamentos.repaint();

		SwingUtilities.invokeLater(() -> {
			scrollPaneM.getVerticalScrollBar().setValue(scrollPaneM.getVerticalScrollBar().getMaximum());
		});

	}

	public void recolectarMedicamentos() {
		medicamentos.clear();
		cantidades.clear();

		for (JPanel panel : panelesGrupos) {
			JComboBox<?> combo = null;
			JSpinner spinner = null;

			for (Component comp : panel.getComponents()) {
				if (comp instanceof JComboBox) {
					combo = (JComboBox<?>) comp;
				} else if (comp instanceof JSpinner) {
					spinner = (JSpinner) comp;
				}
			}

			if (combo != null && spinner != null && combo.getSelectedItem() != null) {
				String nombreMed = combo.getSelectedItem().toString().trim();
				int cantidad = (Integer) spinner.getValue();

				if (!nombreMed.isEmpty() && cantidad > 0) {
					medicamentos.add(nombreMed);
					cantidades.add(cantidad);
				}
			}
		}
	}// fin recolector

	public void mostrarMedicamentosDeReceta(int idReceta) {
		panelMedicamentos.removeAll();
		panelesGrupos.clear();
		medicamentos.clear();
		cantidades.clear();

		ArrayList<String[]> lista = Crecetas.obtenerMedicamentosPorReceta(idReceta);
		for (String[] datos : lista) {
			String nombreMed = datos[0];
			int cantidad = Integer.parseInt(datos[1]);

			JPanel panelGrupo = new JPanel();
			panelGrupo.setLayout(new FlowLayout(FlowLayout.LEFT, 10, 10));
			panelGrupo.setPreferredSize(new Dimension(470, 45));
			panelGrupo.setMaximumSize(new Dimension(470, 45));
			panelGrupo.setBackground(new Color(220, 235, 250));

			JLabel lbl = new JLabel(et.getString("Medi"));
			lbl.setFont(new Font("Tahoma", Font.PLAIN, 12));
			panelGrupo.add(lbl);

			JComboBox<String> combo = new JComboBox<>(Crecetas.llenarmedicamento());
			combo.setSelectedItem(nombreMed);
			combo.setFont(new Font("Tahoma", Font.PLAIN, 12));
			combo.setPreferredSize(new Dimension(150, 25));
			panelGrupo.add(combo);

			JLabel lblCantidad = new JLabel(et.getString("cant"));
			lblCantidad.setFont(new Font("Tahoma", Font.PLAIN, 12));
			panelGrupo.add(lblCantidad);

			JSpinner spinner = new JSpinner(new SpinnerNumberModel(cantidad, 1, 100, 1));
			spinner.setFont(new Font("Tahoma", Font.PLAIN, 12));
			spinner.setPreferredSize(new Dimension(50, 25));
			panelGrupo.add(spinner);

			JButton btnEliminar = new JButton(et.getString("elimedi"));
			btnEliminar.setFont(new Font("Tahoma", Font.PLAIN, 11));
			btnEliminar.setPreferredSize(new Dimension(75, 25));
			panelGrupo.add(btnEliminar);

			btnEliminar.addActionListener(e -> {
				panelMedicamentos.remove(panelGrupo);
				panelesGrupos.remove(panelGrupo);
				panelMedicamentos.revalidate();
				panelMedicamentos.repaint();
			});

			panelMedicamentos.add(panelGrupo);
			panelesGrupos.add(panelGrupo);
			medicamentos.add(nombreMed);
			cantidades.add(cantidad);
		}

		panelMedicamentos.revalidate();
		panelMedicamentos.repaint();
	}// fin mostrarmedicant

	/**
	 * 
	 * Restablece los campos del formulario a sus valores iniciales.
	 * <p>
	 * Este método se utiliza para limpiar el contenido ingresado por el usuario y
	 * preparar el formulario para una nueva entrada.
	 * </p>
	 */
	public void limpiar() {
		CCitas.setSelectedIndex(0);
		Calendario.setDate(Hoy); // reinicia al día de hoy
		textArea.setText("");
		textAreaOb.setText("");
		panelMedicamentos.removeAll();
		panelesGrupos.clear();
		medicamentos.clear();
		cantidades.clear();
		panelMedicamentos.revalidate();
		panelMedicamentos.repaint();
		CCitas.setEnabled(true);
	}

	public class ManejadorKey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {
			// se validan cuadros blancos
			if (EventKey.getSource() == textArea) {

				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textArea.getText().length() >= 199) {

					JOptionPane.showMessageDialog(null, et.getString("nom3"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}

			}

			if (EventKey.getSource() == textAreaOb) {
				if (!Character.isLetterOrDigit(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_DELETE
						|| textAreaOb.getText().length() >= 199) {

					JOptionPane.showMessageDialog(null, et.getString("nom3"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
					scrollPaneOb.requestFocus();

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

	public void llenacomboauto(int idConsulta) {
		CCitas.setSelectedItem(String.valueOf(idConsulta));
		CCitas.setEnabled(false);

	}

	public void mandaid(int idConsulta) {
		System.out.println(et.getString("EIDCE") + idConsulta);

		String[] nombres = Cconsultas.obtenerNombresPorConsulta(idConsulta);

		if (nombres != null) {
			jnombrep.setText(nombres[0]);
			jnombrem.setText(nombres[1]);
		} else {
			jnombrep.setText("");
			jnombrem.setText("");
		}
	}
}
package vistas;

import java.awt.Color;
import java.awt.Component;
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
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.ImageIcon;
import javax.swing.JButton;
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

import controladores.Cmedicos;
import modelos.MEspecialidades;
import java.awt.Toolkit;

/**
 * La clase representa una ventana gráfica que permite registrar especialidades
 * médicas o de otro tipo dentro de una organización.
 * 
 * <p>
 * Esta interfaz permite ingresar el nombre y una descripción de la
 * especialidad. Incluye soporte para internacionalización mediante archivos de
 * recursos y configuración regional.
 * </p>
 * 
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class Especialidades extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField nombre;
	private JLabel tituloEsp;
	private JLabel NombreEsp;
	private JLabel DescripEsp;
	private JScrollPane scrollPaneD;
	private JTextArea textDescripcion;
	private JButton btnañadir;
	private JScrollPane scrollPane2;
	private JTable Tabla;
	private JButton btnModificar;
	private JButton btnEliminar;
	private Component lblSenalamiento;
	private JButton btnAnterior;
	private JButton btnSiguiente;
	private final int registrosPorPagina = 4;
	public int seleccion;

	/**
	 * Variable que toma el idioma predeterminado del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;

	private int paginaActual = 1;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Especialidades frame = new Especialidades();
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
	public Especialidades() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Especialidades.class.getResource("/imagenes/icons8-esfigmomanómetro-24.png")));
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 569, 565);
		setLocationRelativeTo(null);
		contentPane = new JPanel();
		contentPane.setBackground(SystemColor.inactiveCaption);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		tituloEsp = new JLabel(et.getString("Esp"));
		tituloEsp.setBounds(128, 11, 240, 32);
		tituloEsp.setForeground(new Color(0, 0, 139));
		tituloEsp.setHorizontalAlignment(SwingConstants.CENTER);
		tituloEsp.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(tituloEsp);

		NombreEsp = new JLabel(et.getString("nom"));
		NombreEsp.setBounds(31, 80, 121, 32);
		NombreEsp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(NombreEsp);

		DescripEsp = new JLabel(et.getString("desc"));
		DescripEsp.setBounds(170, 131, 94, 24);
		DescripEsp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(DescripEsp);

		nombre = new JTextField();
		nombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		nombre.setBounds(128, 80, 326, 32);
		contentPane.add(nombre);
		nombre.setColumns(10);

		scrollPaneD = new JScrollPane();
		scrollPaneD.setBounds(31, 165, 423, 68);
		contentPane.add(scrollPaneD);

		textDescripcion = new JTextArea();
		textDescripcion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		scrollPaneD.setViewportView(textDescripcion);

		btnañadir = new JButton();
		btnañadir.setIcon(new ImageIcon(Especialidades.class.getResource("/imagenes/icons8-save-50.png")));
		btnañadir.setBounds(470, 53, 54, 59);
		btnañadir.setBackground(Color.WHITE);
		btnañadir.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(btnañadir);

		scrollPane2 = new JScrollPane();
		scrollPane2.setBounds(10, 304, 537, 160);
		contentPane.add(scrollPane2);

		Tabla = new JTable();
		scrollPane2.setViewportView(Tabla);

		btnModificar = new JButton("");
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setIcon(new ImageIcon(Especialidades.class.getResource("/imagenes/icons8-edit-pencil-50.png")));
		btnModificar.setBounds(470, 121, 54, 59);
		contentPane.add(btnModificar);

		btnEliminar = new JButton("");
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setIcon(new ImageIcon(Especialidades.class.getResource("/imagenes/icons8-trash-50.png")));
		btnEliminar.setBounds(470, 190, 54, 59);
		contentPane.add(btnEliminar);

		btnSiguiente = new JButton(et.getString("sig"));
		btnSiguiente.setBounds(31, 481, 103, 21);
		contentPane.add(btnSiguiente);

		btnAnterior = new JButton(et.getString("ant"));
		btnAnterior.setBounds(449, 481, 85, 21);
		contentPane.add(btnAnterior);

		lblSenalamiento = new JLabel(et.getString("nota"));
		lblSenalamiento.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblSenalamiento.setBounds(83, 281, 396, 13);
		contentPane.add(lblSenalamiento);

		Manejadorkey escuchadokey = new Manejadorkey();
		nombre.addKeyListener(escuchadokey);
		textDescripcion.addKeyListener(escuchadokey);

		Manejadorboton escuchadorboton = new Manejadorboton();
		btnañadir.addActionListener(escuchadorboton);
		btnModificar.addActionListener(escuchadorboton);
		btnEliminar.addActionListener(escuchadorboton);
		ManejadorMouse clicked = new ManejadorMouse();
		Tabla.addMouseListener(clicked);
		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);
		MostrarDatos();
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

			if (!e.getValueIsAdjusting() && Tabla.getSelectedRow() != -1) {
				// Activar los botones
				btnModificar.setEnabled(true);
				btnEliminar.setEnabled(true);
				btnañadir.setEnabled(false);
			} else {
				// Desactivar los botones si no hay selección
				btnModificar.setEnabled(false);
				btnEliminar.setEnabled(false);
				btnañadir.setEnabled(true);
			}

			Tabla.getSelectionModel().addListSelectionListener(new Seleccion());
		}

	}

	/**
	 * Clase que maneja las acciones de los botones en la interfaz. Implementa
	 * {@link ActionListener} para controlar eventos de botón.
	 * 
	 * <p>
	 * En particular, maneja el evento de añadir una nueva especialidad cuando se
	 * presiona el botón {@code btnañadir}. Valida que los campos {@code nombre} y
	 * {@code textDescripcion} estén llenos, crea un objeto {@code MEspecialidades},
	 * lo guarda mediante {@code Cmedicos.nuevaesp} y cierra la ventana actual.
	 * </p>
	 * 
	 */
	public class Manejadorboton implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent Evento) {
			if (Evento.getSource().equals(btnañadir)) {

				if (nombre.getText().trim().isEmpty() || textDescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto Mspecialidades
					MEspecialidades nuevaEspecialidad = new MEspecialidades();
					// Asignar el nombre del paciente al objeto
					nuevaEspecialidad.setNombre(nombre.getText().trim());
					nuevaEspecialidad.setDescripcion(textDescripcion.getText());

					// Llamar al método estático para añadir el paciente
					Cmedicos.nuevaesp(nuevaEspecialidad);

					dispose();
				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorGuardar"), "Error",
							JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					limpiar();

				}

			}

			if (Evento.getSource().equals(btnModificar)) {
				if (nombre.getText().trim().isEmpty() || textDescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						int idEsp = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MEspecialidades Esp = new MEspecialidades();
						// Asignar el nombre del paciente al objeto
						Esp.setNombre(nombre.getText().trim());
						Esp.setDescripcion(textDescripcion.getText().trim());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cmedicos servi = new Cmedicos();
						servi.modificarespe(idEsp, Esp, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("ERM"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneEModi"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}

			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idESP = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cmedicos SerM = new Cmedicos();
					SerM.eliminarESP(idESP, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneEEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;
			}
		}
	}

	public void MostrarDatos() {
		DefaultTableModel model = new DefaultTableModel();// definimos el objeto tableModel;
		Tabla.setModel(model);
		model.addColumn("ID"); // idPaciente
		model.addColumn(et.getString("nomb")); // nombre
		model.addColumn(et.getString("desc")); // app

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Cmedicos medicO1 = new Cmedicos();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		medicO1.buscarUsuariosConTableModelo1(model, paginaActual, registrosPorPagina);
		scrollPane2.setViewportView(Tabla);

	}

	/**
	 * Clase interna que implementa {@link KeyListener} para validar la entrada de
	 * teclado en los campos donde se involucre teclado.
	 * <p>
	 * En {@code textDescripcion} permite únicamente letras, espacios, retroceso,
	 * suprimir y limita la longitud a 100 caracteres.
	 * </p>
	 */
	public class Manejadorkey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == textDescripcion) {

				if ((!Character.isLetter(EventKey.getKeyChar()) || textDescripcion.getText().length() > 99)
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textDescripcion.getText().length() >= 100) {
					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}
			}
			if (EventKey.getSource() == nombre) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || nombre.getText().length() >= 80) {

					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
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

	/**
	 * Metodo interno para limpiar campos enviandolos a estado inicial.
	 */
	public void limpiar() {
		nombre.setText("");
		textDescripcion.setText("");

	}

	/**
	 * Clase que implementa la interfaz {@link MouseListener} para manejar eventos
	 * de clic sobre la tabla.
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
			int filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}

			// Obtener los datos de la fila seleccionada

			nombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
			textDescripcion.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());

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
}

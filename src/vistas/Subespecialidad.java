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

import controladores.Cmedicos;
import modelos.MSubespecialides;
import java.awt.Toolkit;

/**
 * Clase que representa la ventana de Subespecialidad en la aplicación.
 * <p>
 * Se extiende y contiene campos para ingresar el nombre y la descripción, junto
 * a encadenarse con una especialidad principal, además de un botón para añadir
 * una nueva presentación.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Subespecialidad extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField nombre;
	private JLabel titSubEsp;
	private JLabel NomSubEsp;
	private JComboBox<String> idEspecialidad;
	private DefaultComboBoxModel<String> especialidad;
	private JLabel DescripSubEsp;
	private JLabel IdEsp;
	private JScrollPane scrollPane;
	private JTextArea textArea;
	private JButton btnañadir;
	private JButton btnModificar;
	private JButton btnEliminar;
	private JButton btnSiguiente;
	private Component lblSenalamiento;
	private final int registrosPorPagina = 4;
	public int seleccion;
	public static int idSubespecialidad;

	private JButton btnAnterior;
	private static Locale Idioma;
	private static ResourceBundle et;

	private int paginaActual = 1;
	private JTable Tabla;
	private JScrollPane scrollPane_1;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Subespecialidad frame = new Subespecialidad();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Constructor de componentes que aparecen en la vista {@code Subespecialidad}
	 */
	public Subespecialidad() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Subespecialidad.class.getResource("/imagenes/icons8-esfigmomanómetro-24.png")));

		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 569, 480);
		setLocationRelativeTo(null);
		contentPane = new JPanel();
		contentPane.setBackground(SystemColor.inactiveCaption);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		titSubEsp = new JLabel(et.getString("Sub"));
		titSubEsp.setForeground(new Color(0, 0, 139));
		titSubEsp.setBounds(114, 10, 306, 43);
		titSubEsp.setHorizontalAlignment(SwingConstants.CENTER);
		titSubEsp.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(titSubEsp);

		NomSubEsp = new JLabel(et.getString("nomb"));
		NomSubEsp.setBounds(30, 60, 93, 27);
		NomSubEsp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(NomSubEsp);

		DescripSubEsp = new JLabel(et.getString("desc"));
		DescripSubEsp.setBounds(32, 129, 137, 27);
		DescripSubEsp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(DescripSubEsp);

		IdEsp = new JLabel(et.getString("IDE"));
		IdEsp.setBounds(262, 60, 182, 27);
		IdEsp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(IdEsp);

		especialidad = new DefaultComboBoxModel<String>();
		especialidad = Cmedicos.llenarSubespecialid();

		idEspecialidad = new JComboBox<String>(especialidad);
		idEspecialidad.setBounds(262, 91, 186, 27);
		contentPane.add(idEspecialidad);
		AutoCompleteDecorator.decorate(this.idEspecialidad);

		nombre = new JTextField();
		nombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		nombre.setBounds(29, 91, 211, 27);
		contentPane.add(nombre);
		nombre.setColumns(10);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(30, 165, 414, 60);
		contentPane.add(scrollPane);

		textArea = new JTextArea();
		textArea.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		scrollPane.setViewportView(textArea);

		btnañadir = new JButton();
		btnañadir.setIcon(new ImageIcon(Subespecialidad.class.getResource("/imagenes/icons8-save-50.png")));
		btnañadir.setBounds(470, 53, 54, 59);
		btnañadir.setBackground(Color.WHITE);
		btnañadir.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(btnañadir);

		btnModificar = new JButton("");
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setIcon(new ImageIcon(Subespecialidad.class.getResource("/imagenes/icons8-edit-pencil-50.png")));
		btnModificar.setBounds(470, 121, 54, 59);
		contentPane.add(btnModificar);

		btnEliminar = new JButton("");
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setIcon(new ImageIcon(Subespecialidad.class.getResource("/imagenes/icons8-trash-50.png")));
		btnEliminar.setBounds(470, 190, 54, 59);
		contentPane.add(btnEliminar);

		btnSiguiente = new JButton(et.getString("sig"));
		btnSiguiente.setBounds(118, 406, 103, 21);
		contentPane.add(btnSiguiente);

		btnAnterior = new JButton(et.getString("ant"));
		btnAnterior.setBounds(345, 406, 85, 21);
		contentPane.add(btnAnterior);

		lblSenalamiento = new JLabel(et.getString("nota"));
		lblSenalamiento.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblSenalamiento.setBounds(83, 281, 396, 13);
		contentPane.add(lblSenalamiento);

		scrollPane_1 = new JScrollPane();
		scrollPane_1.setBounds(55, 310, 442, 85);
		contentPane.add(scrollPane_1);

		Tabla = new JTable();
		scrollPane_1.setColumnHeaderView(Tabla);

		Manejadorkey escuchadokey = new Manejadorkey();
		nombre.addKeyListener(escuchadokey);
		textArea.addKeyListener(escuchadokey);

		Manejadorboton escuchadorboton = new Manejadorboton();
		btnañadir.addActionListener(escuchadorboton);
		btnModificar.addActionListener(escuchadorboton);
		btnEliminar.addActionListener(escuchadorboton);
		ManejadorMouse clicked = new ManejadorMouse();
		Tabla.addMouseListener(clicked);
		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);

		// Seleccion escuchador = new Seleccion();
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
	 * Maneja el evento del botón <b>Añadir</b> en el formulario de
	 * subespecialidades.
	 * <p>
	 * Valida que los campos {@code nombre}, {@code textArea} e
	 * {@code idEspecialidad} estén correctamente llenos.
	 * </p>
	 * <p>
	 * Si son válidos, crea un objeto {@code MSubespecialides}, lo envía al
	 * controlador {@code Cmedicos} para ser guardado y luego cierra la ventana.
	 * </p>
	 */

	public class Manejadorboton implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent Evento) {
			if (Evento.getSource().equals(btnañadir)) {

				if (nombre.getText().trim().isEmpty() || textArea.getText().trim().isEmpty()
						|| idEspecialidad.getSelectedIndex() <= 0) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto Mspecialidades
					MSubespecialides NuevoSubespecialides = new MSubespecialides();
					// Asignar el nombre del medico al objeto
					NuevoSubespecialides.setNombre(nombre.getText().trim());
					NuevoSubespecialides.setDescripcion(textArea.getText());
					NuevoSubespecialides.setIdEspecialidad(idEspecialidad.getSelectedItem().toString());

					// Llamar al método estático para añadir el
					Cmedicos.anadirSubespecialidades(NuevoSubespecialides);

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

				if (nombre.getText().trim().isEmpty() || textArea.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						idSubespecialidad = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MSubespecialides Sub = new MSubespecialides();
						// Asignar el nombre del paciente al objeto
						Sub.setNombre(nombre.getText().trim());
						Sub.setDescripcion(textArea.getText().trim());
						Sub.setIdEspecialidad(idEspecialidad.getSelectedItem().toString());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cmedicos modsub = new Cmedicos();
						modsub.modificarsub(idSubespecialidad, Sub, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModSu"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneSub"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;
			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idSub = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cmedicos MedicOSub = new Cmedicos();
					MedicOSub.eliminarSub(idSub, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneSuEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
				return;
			}
		}
	}

	public void MostrarDatos() {
		DefaultTableModel model;
		model = new DefaultTableModel();
		Tabla.setModel(model);

		model.addColumn("ID"); // idPaciente
		model.addColumn(et.getString("nomb")); // nombre
		model.addColumn(et.getString("desc"));
		model.addColumn(et.getString("IDE"));

		Cmedicos medicO = new Cmedicos();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		medicO.buscarUsuariosConTableModelo(model, paginaActual, registrosPorPagina);
		scrollPane_1.setViewportView(Tabla);
	}

	/**
	 * Valida el ingreso de texto en los campos {@code nombre} y {@code textArea}.
	 * <p>
	 * <b>Restricciones:</b>
	 * </p>
	 * <ul>
	 * <li><b>textArea:</b> Solo letras, espacio, retroceso o delete. Máx. 100
	 * caracteres.</li>
	 * <li><b>nombre:</b> Solo letras, espacio, retroceso o delete.</li>
	 * </ul>
	 * <p>
	 * Si se detecta un carácter no permitido, muestra un mensaje de error y bloquea
	 * la entrada.
	 * </p>
	 */
	public class Manejadorkey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == textArea) {

				if ((!Character.isLetter(EventKey.getKeyChar()) || textArea.getText().length() > 99)
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE) {

					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}
			}

			if (EventKey.getSource() == nombre) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textArea.getText().length() > 79) {

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
	 * Limpia los campos del formulario.
	 */
	private void limpiar() {
		nombre.setText("");
		textArea.setText("");
		idEspecialidad.setSelectedItem(et.getString("SEL"));
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
			int filaSeleccionada = Tabla.getSelectedRow();
			if (filaSeleccionada == -1) {
				JOptionPane.showMessageDialog(null, et.getString("PFseleccionereglon"), et.getString("err"),
						JOptionPane.ERROR_MESSAGE);
				return;
			}

			// Obtener los datos de la fila seleccionada

			nombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
			idEspecialidad.setSelectedItem(Tabla.getValueAt(filaSeleccionada, 3));
			textArea.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());

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

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
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import controladores.Cmedicamento;
import modelos.MPresentacion;
import java.awt.Toolkit;

/**
 * Clase que representa la ventana de Presentaciones en la aplicación. Se
 * extiende y contiene campos para ingresar el nombre y la descripción, además
 * de un botón para añadir una nueva presentación.
 * <p>
 * Soporta internacionalización mediante {@link ResourceBundle} para mostrar
 * textos en el idioma del sistema.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Presentaciones extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JLabel jltitulo;
	private JLabel lblNombre;
	private JTextField txtNombre;
	private JLabel lblDescripcion;
	private JTextField txtDescripcion;
	private JButton btnañadir;
	private JScrollPane scrollPane;
	private JButton btnModificar;
	private JButton btnEliminar;
	private JButton btnSiguiente;
	private JButton btnAnterior;
	private final int registrosPorPagina = 4;
	public int seleccion;

	private Component lblSenalamiento;
	/**
	 * Variable que determina el idioma del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable que busca el diccionario del idioma en el paquete {@link properties}
	 */
	private static ResourceBundle et;

	private int paginaActual = 1;
	private JTable Tabla;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Presentaciones frame = new Presentaciones();
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
	public Presentaciones() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Presentaciones.class.getResource("/imagenes/icons8-medicamentos-externos-cirugia-cosmetica-victoruler-plano-victoruler-24.png")));

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

		jltitulo = new JLabel(et.getString("presentacion"));
		jltitulo.setBounds(134, 10, 289, 35);
		jltitulo.setForeground(new Color(0, 0, 139));
		jltitulo.setHorizontalAlignment(SwingConstants.CENTER);
		jltitulo.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(jltitulo);

		lblNombre = new JLabel(et.getString("nomb"));
		lblNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 16));
		lblNombre.setBounds(45, 108, 92, 23);
		contentPane.add(lblNombre);

		txtNombre = new JTextField();
		txtNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		txtNombre.setBounds(134, 104, 326, 32);
		contentPane.add(txtNombre);

		lblDescripcion = new JLabel(et.getString("desc"));
		lblDescripcion.setFont(new Font("Comic Sans MS", Font.PLAIN, 16));
		lblDescripcion.setBounds(198, 157, 91, 23);
		contentPane.add(lblDescripcion);

		txtDescripcion = new JTextField();
		txtDescripcion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		txtDescripcion.setBounds(31, 190, 393, 46);
		contentPane.add(txtDescripcion);

		btnañadir = new JButton();
		btnañadir.setIcon(new ImageIcon(Presentaciones.class.getResource("/imagenes/icons8-save-50.png")));
		btnañadir.setBounds(470, 53, 54, 59);
		btnañadir.setBackground(Color.WHITE);
		btnañadir.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(btnañadir);

		btnModificar = new JButton("");
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setIcon(new ImageIcon(Presentaciones.class.getResource("/imagenes/icons8-edit-pencil-50.png")));
		btnModificar.setBounds(470, 121, 54, 59);
		contentPane.add(btnModificar);

		btnEliminar = new JButton("");
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setIcon(new ImageIcon(Presentaciones.class.getResource("/imagenes/icons8-trash-50.png")));
		btnEliminar.setBounds(470, 190, 54, 59);
		contentPane.add(btnEliminar);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(10, 305, 537, 160);
		contentPane.add(scrollPane);

		Tabla = new JTable();
		scrollPane.setViewportView(Tabla);

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

		Manejadorboton escuchadorboton = new Manejadorboton();
		btnañadir.addActionListener(escuchadorboton);
		btnModificar.addActionListener(escuchadorboton);
		btnEliminar.addActionListener(escuchadorboton);

		ManejadorMouse clicked = new ManejadorMouse();
		Tabla.addMouseListener(clicked);
		Seleccion escuchador = new Seleccion();

		Tabla.getSelectionModel().addListSelectionListener(escuchador);

		Manejadorkey escuchadorKey = new Manejadorkey();
		txtDescripcion.addKeyListener(escuchadorKey);
		txtNombre.addKeyListener(escuchadorKey);

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

				if (txtNombre.getText().trim().isEmpty() || txtDescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto MPaciente
					MPresentacion nuevapre = new MPresentacion();
					// Asignar el nombre del paciente al objeto
					nuevapre.setNombre(txtNombre.getText().trim());
					nuevapre.setDescripcion(txtDescripcion.getText());

					// Llamar al método estático para añadir el paciente
					Cmedicamento.anadirpre(nuevapre);

					dispose();
				} catch (Exception e2) {
					JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorGuardar"), "Error",
							JOptionPane.ERROR_MESSAGE);
					e2.printStackTrace();
				} finally {
					limpiar();
				}

			}

			if (Evento.getSource().equals(btnModificar)) {
				if (txtNombre.getText().trim().isEmpty() || txtDescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						int idPre = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MPresentacion MeD = new MPresentacion();
						// Asignar el nombre del paciente al objeto
						MeD.setNombre(txtNombre.getText().trim());
						MeD.setDescripcion(txtDescripcion.getText().trim());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cmedicamento prec = new Cmedicamento();
						prec.modificarser(idPre, MeD, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModP"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionePEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}

			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idPre = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cmedicamento PreM = new Cmedicamento();
					PreM.eliminarSer(idPre, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionePEli"), et.getString("Adv"),
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
		Cmedicamento medicamentoS = new Cmedicamento();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		medicamentoS.buscarUsuariosConTableModelo(model, paginaActual, registrosPorPagina);
		scrollPane.setViewportView(Tabla);

	}

	public class Manejadorkey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == txtDescripcion) {

				if ((!Character.isLetter(EventKey.getKeyChar()) || txtDescripcion.getText().length() > 99)
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || txtDescripcion.getText().length() >= 70) {
					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
				}
			}

			if (EventKey.getSource() == txtNombre) {
				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || txtNombre.getText().length() >= 49) {
					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
					EventKey.consume();
				}
			}
		}

		@Override
		public void keyPressed(KeyEvent e) {
			// No necesario
		}

		@Override
		public void keyReleased(KeyEvent e) {
			// No necesario
		}
	}

	/**
	 * Limpia los campos de nombre y descripción.
	 */
	private void limpiar() {
		txtDescripcion.setText("");
		txtNombre.setText("");
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

			txtNombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
			txtDescripcion.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());

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
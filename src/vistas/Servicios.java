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

import controladores.Ccitas;
import controladores.Cmedicos;
import modelos.MServicios;
import java.awt.Toolkit;

/**
 * Clase que representa la ventana de Servicios en la aplicación.
 * <p>
 * Se extiende y contiene campos para ingresar el nombre y la descripción,
 * además de un botón para añadir una nueva presentación. Soporta
 * internacionalización mediante {@link ResourceBundle} para mostrar textos en
 * el idioma del sistema.
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * 
 * @version 2.0
 * @since 01-07-2025
 */
public class Servicios extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField textNombre;
	private JLabel titServicios;
	private JLabel NombrServ;
	private JLabel DescripServ;
	private JButton btnañadir;
	private JTextField textDescripcion;
	private JScrollPane scrollPane2;
	private final int registrosPorPagina = 4;
	public int seleccion;

	private JTable Tabla;
	private JButton btnModificar;
	private JButton btnEliminar;
	private JButton btnSiguiente;
	private JButton btnAnterior;
	private JLabel lblSenalamiento;

	private static Locale Idioma;
	private static ResourceBundle et;

	private int paginaActual = 1;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Servicios frame = new Servicios();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Constructor de componentes que aparecen en la vista {@code Servicios}
	 */
	public Servicios() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Servicios.class.getResource("/imagenes/icons8-herramientas-del-administrador-24.png")));
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

		textNombre = new JTextField();
		textNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textNombre.setBounds(148, 98, 288, 28);
		contentPane.add(textNombre);
		textNombre.setColumns(10);

		titServicios = new JLabel(et.getString("servicios"));
		titServicios.setBounds(154, 10, 218, 28);
		titServicios.setForeground(new Color(0, 0, 139));
		titServicios.setHorizontalAlignment(SwingConstants.CENTER);
		titServicios.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(titServicios);

		NombrServ = new JLabel(et.getString("nomb"));
		NombrServ.setBounds(65, 103, 73, 19);
		NombrServ.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(NombrServ);

		DescripServ = new JLabel(et.getString("desc"));
		DescripServ.setBounds(218, 149, 121, 28);
		DescripServ.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(DescripServ);

		textDescripcion = new JTextField();
		textDescripcion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		textDescripcion.setBounds(31, 190, 430, 49);
		contentPane.add(textDescripcion);
		textDescripcion.setColumns(10);
		;

		scrollPane2 = new JScrollPane();
		scrollPane2.setBounds(10, 304, 537, 160);
		contentPane.add(scrollPane2);

		Tabla = new JTable();
		scrollPane2.setViewportView(Tabla);

		btnañadir = new JButton();
		btnañadir.setIcon(new ImageIcon(Servicios.class.getResource("/imagenes/icons8-save-50.png")));
		btnañadir.setBounds(470, 53, 54, 59);
		btnañadir.setBackground(Color.WHITE);
		btnañadir.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(btnañadir);

		btnModificar = new JButton("");
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setIcon(new ImageIcon(Servicios.class.getResource("/imagenes/icons8-edit-pencil-50.png")));
		btnModificar.setBounds(470, 121, 54, 59);
		contentPane.add(btnModificar);

		btnEliminar = new JButton("");
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setIcon(new ImageIcon(Servicios.class.getResource("/imagenes/icons8-trash-50.png")));
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
		textNombre.addKeyListener(escuchadokey);
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
	 * Maneja el evento del botón <b>Añadir</b> en la interfaz de servicios médicos.
	 * <p>
	 * <b>Validación:</b> Verifica que los campos {@code textNombre} y
	 * {@code textDescripcion} no estén vacíos.
	 * </p>
	 * <p>
	 * <b>Acción:</b> Si son válidos, crea un objeto {@code MServicios}, lo envía al
	 * controlador {@code Cmedicos} mediante {@code anadirServicios}, cierra la
	 * ventana y limpia los campos.
	 * </p>
	 */
	public class Manejadorboton implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent Evento) {
			if (Evento.getSource().equals(btnañadir)) {

				if (textNombre.getText().trim().isEmpty() || textDescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto MMedicos
					MServicios NuevoServicio = new MServicios();
					// Asignar el nombre del medico al objeto
					NuevoServicio.setNombre(textNombre.getText().trim());
					NuevoServicio.setDescripcion(textDescripcion.getText());

					// Llamar al método estático para añadir el paciente
					Cmedicos.anadirServicios(NuevoServicio);

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
				if (textNombre.getText().trim().isEmpty() || textDescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						int idServicio = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MServicios Ser = new MServicios();
						// Asignar el nombre del paciente al objeto
						Ser.setNombre(textNombre.getText().trim());
						Ser.setDescripcion(textDescripcion.getText().trim());

						// LLamar al controlador de Pacientes para metodo actualizar
						Ccitas servi = new Ccitas();
						servi.modificarser(idServicio, Ser, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModS"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneSer"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}

			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idSer = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Ccitas SerM = new Ccitas();
					SerM.eliminarSer(idSer, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneSEli"), et.getString("Adv"),
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
		Ccitas citA = new Ccitas();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		citA.buscarUsuariosConTableModelo(model, paginaActual, registrosPorPagina);
		scrollPane2.setViewportView(Tabla);

	}

	/**
	 * Maneja la validación de teclas en los campos {@code textDescripcion} y
	 * {@code textNombre}.
	 * 
	 * <p>
	 * <b>Restricciones:</b>
	 * </p>
	 * <ul>
	 * <li><b>textDescripcion:</b> Solo letras, espacio, backspace, delete. Máx. 150
	 * caracteres.</li>
	 * <li><b>textNombre:</b> Solo letras, espacio, backspace, delete.</li>
	 * </ul>
	 * 
	 * <p>
	 * Si se ingresa un carácter inválido, se muestra un mensaje y se cancela la
	 * entrada.
	 * </p>
	 */
	public class Manejadorkey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == textDescripcion) {

				if ((!Character.isLetter(EventKey.getKeyChar()) || textDescripcion.getText().length() > 150)
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE) {

					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}
			}
			if (EventKey.getSource() == textNombre) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || textDescripcion.getText().length() > 49) {

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

			textNombre.setText(Tabla.getValueAt(filaSeleccionada, 1).toString());
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

	/**
	 * Metodo interno para limpiar componentes graficos.
	 */
	private void limpiar() {
		textNombre.setText("");
		textDescripcion.setText("");

	}
}
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
import javax.swing.JTextPane;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import controladores.Cpacientes;
import modelos.MReligion;
import java.awt.Toolkit;

public class Religion extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JLabel jltitulo;
	private JTextField textNombre;
	private JLabel jlapp;
	private JLabel jldescripcion;
	private JTextPane txtdescripcion;
	private JButton btnañadir;
	private JScrollPane scrollPane2;
	private JTable Tabla;
	private JButton btnModificar;
	private JButton btnEliminar;
	private JButton btnSiguiente;
	private JButton btnAnterior;
	private JLabel lblSenalamiento;
	private static Locale Idioma;
	private static ResourceBundle et;
	private final int registrosPorPagina = 4;
	public int seleccion;

	private int paginaActual = 1;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Religion frame = new Religion();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public Religion() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Religion.class.getResource("/imagenes/icons8-religions-24.png")));
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

		jltitulo = new JLabel(et.getString("rel"));
		jltitulo.setBounds(58, 10, 398, 43);
		jltitulo.setForeground(new Color(0, 0, 139));
		jltitulo.setHorizontalAlignment(SwingConstants.CENTER);
		jltitulo.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(jltitulo);

		textNombre = new JTextField();
		textNombre.setBounds(125, 83, 310, 27);
		textNombre.setHorizontalAlignment(SwingConstants.CENTER);
		textNombre.setForeground(new Color(50, 50, 50));
		textNombre.setBackground(new Color(255, 255, 255));
		textNombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(textNombre);
		textNombre.setColumns(10);

		jlapp = new JLabel(et.getString("nom"));
		jlapp.setBounds(32, 87, 150, 21);
		jlapp.setForeground(new Color(50, 50, 50));
		jlapp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(jlapp);

		jldescripcion = new JLabel(et.getString("desc"));
		jldescripcion.setForeground(new Color(50, 50, 50));
		jldescripcion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		jldescripcion.setBounds(190, 125, 127, 21);
		contentPane.add(jldescripcion);

		txtdescripcion = new JTextPane();
		txtdescripcion.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		txtdescripcion.setBackground(Color.WHITE);
		txtdescripcion.setForeground(Color.BLACK);
		txtdescripcion.setBounds(28, 157, 415, 63);
		contentPane.add(txtdescripcion);

		btnañadir = new JButton();
		btnañadir.setIcon(new ImageIcon(Departamentos.class.getResource("/imagenes/icons8-save-50.png")));
		btnañadir.setBounds(470, 53, 54, 59);
		btnañadir.setBackground(Color.WHITE);
		btnañadir.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(btnañadir);

		btnModificar = new JButton("");
		btnModificar.setBackground(Color.WHITE);
		btnModificar.setIcon(new ImageIcon(Departamentos.class.getResource("/imagenes/icons8-edit-pencil-50.png")));
		btnModificar.setBounds(470, 121, 54, 59);
		contentPane.add(btnModificar);

		btnEliminar = new JButton("");
		btnEliminar.setBackground(Color.WHITE);
		btnEliminar.setIcon(new ImageIcon(Departamentos.class.getResource("/imagenes/icons8-trash-50.png")));
		btnEliminar.setBounds(470, 190, 54, 59);
		contentPane.add(btnEliminar);

		scrollPane2 = new JScrollPane();
		scrollPane2.setBounds(10, 304, 537, 160);
		contentPane.add(scrollPane2);

		Tabla = new JTable();
		scrollPane2.setViewportView(Tabla);

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
		txtdescripcion.addKeyListener(escuchadokey);

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

	public class Manejadorkey implements KeyListener {

		@Override
		public void keyTyped(KeyEvent EventKey) {

			if (EventKey.getSource() == txtdescripcion) {

				if ((!Character.isLetter(EventKey.getKeyChar()) || txtdescripcion.getText().length() > 99)
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE) {

					JOptionPane.showMessageDialog(null, et.getString("SAL"), "Error", JOptionPane.ERROR_MESSAGE);
					EventKey.consume();

				}
			}
			if (EventKey.getSource() == textNombre) {

				if (!Character.isLetter(EventKey.getKeyChar()) && EventKey.getKeyChar() != KeyEvent.VK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || txtdescripcion.getText().length() > 49) {

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

	public class Manejadorboton implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent Evento) {
			if (Evento.getSource().equals(btnañadir)) {

				if (textNombre.getText().trim().isEmpty() || txtdescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {
					// Crear un nuevo objeto MPaciente
					MReligion nuevareligion = new MReligion();
					// Asignar el nombre del paciente al objeto
					nuevareligion.setNombre(textNombre.getText().trim());
					nuevareligion.setDescripcion(txtdescripcion.getText());

					// Llamar al método estático para añadir el paciente
					Cpacientes.anadirreligion(nuevareligion);

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
				if (textNombre.getText().trim().isEmpty() || txtdescripcion.getText().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						int idRel = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MReligion Rel = new MReligion();
						// Asignar el nombre del paciente al objeto
						Rel.setNombre(textNombre.getText().trim());
						Rel.setDescripcion(txtdescripcion.getText().trim());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cpacientes reli = new Cpacientes();
						reli.modificarrel(idRel, Rel, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModR"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccionePacienteEli"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}
			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idRel = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cpacientes RelM = new Cpacientes();
					RelM.eliminarRel(idRel, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneRel"), et.getString("Adv"),
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
		Cpacientes pacientE = new Cpacientes();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		pacientE.buscarUsuariosConTableModelo(model, paginaActual, registrosPorPagina);
		scrollPane2.setViewportView(Tabla);

	}

	private void limpiar() {
		textNombre.setText("");
		txtdescripcion.setText("");

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
			txtdescripcion.setText(Tabla.getValueAt(filaSeleccionada, 2).toString());

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
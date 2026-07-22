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
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.MaskFormatter;

import controladores.Cmedicos;
import modelos.MDepartamentos;
import java.awt.Toolkit;

/**
 * La clase representa una interfaz gráfica para registrar información
 * relacionada con departamentos dentro de una organización.
 * <p>
 * Incluye campos para ingresar el nombre del departamento, su número de
 * extensión telefónica y el número de empleados. También permite añadir la
 * información mediante un botón. La interfaz está localizada utilizando
 * archivos de recursos.
 * </p>
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class Departamentos extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JLabel TitDepartamentos;
	private JTextField nombre;
	private JLabel NomDep;
	private JFormattedTextField telExt;
	private JLabel TelExt;
	private JLabel NumEmpleados;
	private JButton btnañadir;
	private JSpinner spinnerEmp;
	private MaskFormatter PatronTelefono;
	/**
	 * Variable que toma el idioma predeterminado del sistema
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;
	private JScrollPane scrollPane;
	private JTable Tabla;
	private JButton btnAnterior;
	private JButton btnModificar;
	private JButton btnEliminar;
	private JLabel lblSenalamiento;
	private JButton btnSiguiente;
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
					Departamentos frame = new Departamentos();
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
	 */
	public Departamentos() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Departamentos.class.getResource("/imagenes/icons8-departamento-24.png")));
		setTitle("Departamentos");
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 569, 565);
		contentPane = new JPanel();
		contentPane.setBackground(SystemColor.inactiveCaption);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setLocationRelativeTo(null);

		setContentPane(contentPane);
		contentPane.setLayout(null);

		TitDepartamentos = new JLabel(et.getString("Dep"));
		TitDepartamentos.setBounds(156, 11, 189, 43);
		TitDepartamentos.setForeground(new Color(0, 0, 139));
		TitDepartamentos.setHorizontalAlignment(SwingConstants.CENTER);
		TitDepartamentos.setFont(new Font("Times New Roman", Font.BOLD, 30));
		contentPane.add(TitDepartamentos);

		nombre = new JTextField();
		nombre.setBounds(138, 103, 235, 26);
		nombre.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(nombre);
		nombre.setColumns(10);

		NomDep = new JLabel(et.getString("nomb"));
		NomDep.setBounds(220, 65, 96, 26);
		NomDep.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(NomDep);

		TelExt = new JLabel(et.getString("tel"));
		TelExt.setBounds(66, 140, 134, 26);
		TelExt.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(TelExt);

		NumEmpleados = new JLabel(et.getString("NumE"));
		NumEmpleados.setBounds(283, 142, 177, 22);
		NumEmpleados.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(NumEmpleados);

		try {
			PatronTelefono = new MaskFormatter("(###) ###-####");
		} catch (ParseException e) {
			// formato telefono
			e.printStackTrace();
		}

		telExt = new JFormattedTextField(PatronTelefono);
		telExt.setBounds(38, 177, 162, 26);
		telExt.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		contentPane.add(telExt);
		telExt.setColumns(10);
		contentPane.add(telExt);

		spinnerEmp = new JSpinner();
		spinnerEmp.setBounds(320, 178, 80, 25);
		spinnerEmp.setFont(new Font("Comic Sans MS", Font.PLAIN, 15));
		spinnerEmp.setModel(new SpinnerNumberModel(Integer.valueOf(1), Integer.valueOf(1), null, Integer.valueOf(1)));
		contentPane.add(spinnerEmp);

		scrollPane = new JScrollPane();
		scrollPane.setBounds(10, 304, 537, 160);
		contentPane.add(scrollPane);

		Tabla = new JTable();
		scrollPane.setViewportView(Tabla);

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

		btnSiguiente = new JButton(et.getString("sig"));
		btnSiguiente.setBounds(31, 481, 105, 21);
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
		telExt.addKeyListener(escuchadokey);

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

	public class Manejadorboton implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnañadir)) {

				if (nombre.getText().trim().isEmpty() || telExt.getText().trim().isEmpty()) {
					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}
				try {

					// Crear un nuevo objeto MEspecialidades
					MDepartamentos nuevoDepartamento = new MDepartamentos();
					// Asignar el nombre del Departamento al objeto
					nuevoDepartamento.setNombre(nombre.getText().trim());
					nuevoDepartamento.setTelExt(telExt.getText());
					nuevoDepartamento.setEmpleados((int) spinnerEmp.getValue());

					// Llamar al método estático para añadir el paciente
					Cmedicos.anadirDepartamento(nuevoDepartamento);
					JOptionPane.showMessageDialog(null, et.getString("guardado"), et.getString("info"),
							JOptionPane.INFORMATION_MESSAGE);
					dispose();

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorGuardar"), "Error",
							JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					limpiar();
					MostrarDatos();
				}
			}

			if (Evento.getSource().equals(btnModificar)) {
				if (nombre.getText().trim().isEmpty() || telExt.getText().trim().isEmpty()
						|| spinnerEmp.getValue().toString().trim().isEmpty()) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), et.getString("tituloerror"),
							JOptionPane.ERROR_MESSAGE);
					return;
				}

				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada
				if (seleccion != -1) {// verificar si hay seleccionad

					try {
						int idDep = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
						// tomar con modelo

						MDepartamentos Ser = new MDepartamentos();
						// Asignar el nombre del paciente al objeto
						Ser.setNombre(nombre.getText().trim());
						Ser.setEmpleados((int) spinnerEmp.getValue());
						Ser.setTelExt(telExt.getText().trim());

						// LLamar al controlador de Pacientes para metodo actualizar
						Cmedicos servi = new Cmedicos();
						servi.modificarser(idDep, Ser, (DefaultTableModel) Tabla.getModel(), seleccion);

					} catch (Exception e) {
						JOptionPane.showMessageDialog(null, et.getString("OcurrioErrorModD"), et.getString("err"),
								JOptionPane.ERROR_MESSAGE);
						e.printStackTrace();
					} finally {
						MostrarDatos();
						limpiar();
					}

				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneDModi"), et.getString("Adv"),
							JOptionPane.WARNING_MESSAGE);
				}

			}

			if (Evento.getSource().equals(btnEliminar)) {
				seleccion = Tabla.getSelectedRow(); // Obtener la fila seleccionada en la tabla para idPaciente
				if (seleccion != -1) {
					int idDep = Integer.parseInt(Tabla.getValueAt(seleccion, 0).toString());
					Cmedicos SerM = new Cmedicos();
					SerM.eliminarDep(idDep, (DefaultTableModel) Tabla.getModel(), seleccion);
				} else {
					JOptionPane.showMessageDialog(null, et.getString("SeleccioneDEli"), et.getString("Adv"),
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
		model.addColumn(et.getString("NumE")); // app
		model.addColumn(et.getString("TE")); // app

		Tabla.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		Tabla.getTableHeader().setReorderingAllowed(false);
		Cmedicos medicO12 = new Cmedicos();
		/*
		 * enviamos el objeto TableModel, como mandamos el objeto podemos manipularlo
		 * desde el metodo
		 */
		// pacientes.buscarUsuariosConTableModel(model);

		medicO12.buscarUsuariosConTableModelo12(model, paginaActual, registrosPorPagina);
		scrollPane.setViewportView(Tabla);

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

			if (EventKey.getSource() == telExt) {

				if ((!Character.isDigit(EventKey.getKeyChar()) || telExt.getText().length() > 99)
						&& EventKey.getKeyChar() != KeyEvent.VK_SPACE && EventKey.getKeyChar() != KeyEvent.VK_BACK_SPACE
						&& EventKey.getKeyChar() != KeyEvent.VK_DELETE || telExt.getText().length() >= 100) {
					JOptionPane.showMessageDialog(null, et.getString("SAN"), "Error", JOptionPane.ERROR_MESSAGE);
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

	private void limpiar() {
		nombre.setText("");
		telExt.setText("");
		spinnerEmp.setValue(1);
		Tabla.clearSelection();// Deselecciona la fila

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
			spinnerEmp.setValue(Integer.parseInt(Tabla.getValueAt(filaSeleccionada, 2).toString()));

			telExt.setText(Tabla.getValueAt(filaSeleccionada, 3).toString());

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
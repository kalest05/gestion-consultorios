package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.AbstractButton;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.filechooser.FileNameExtensionFilter;

import controladores.CUsuario;


/**
 * Clase principal que representa el menú principal de la aplicación.
 * <p>
 * Extiende y contiene botones para acceder a diferentes módulos como Pacientes,
 * Médicos, Medicamentos, Recetas, Citas, Consultas e Inventario.
 * </p>
 * <p>
 * Soporta internacionalización mediante {@link ResourceBundle} para cargar
 * textos según el idioma predeterminado del sistema.
 * </p>
 */
public class Menu extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;

	private JButton btnMedicos, btnMedicamentos, btnCitas, btnConsultas, btnInventario, btnReportes;
	private JButton btnReceta;
	private AbstractButton btnpac;
	private JLabel lblTitulo;
	private JLabel lblmenu;

	public static Pacientes paciente;
	public static Medicos medico;
	public static Medicamentos medi;
	public static Recetas receta;
	public static Citas citas;
	public static Consultas consultas;
	public static Inventario inventario;
	public static MenuReportes reportes;
	public static Login Usu;
	public static AñadirUsu AU;

	

	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;
	private JButton btnUsu;
	private JButton btnRespaldo;

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			try {
				Menu frame = new Menu();
				frame.setVisible(true);
			} catch (Exception e) {
				e.printStackTrace();
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
	 * @param usuarioLogin 
	 * 
	 */
	public Menu() {
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setIconImage(
				Toolkit.getDefaultToolkit().getImage(Menu.class.getResource("/imagenes/icons8-hospital-3-40.png")));
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 769, 552);
		setLocationRelativeTo(null);

		contentPane = new JPanel();
		contentPane.setBackground(Color.WHITE);
		contentPane.setLayout(null); // Layout absoluto
		setContentPane(contentPane);

		// Título
		lblTitulo = new JLabel(et.getString("hospital"), JLabel.CENTER);
		lblTitulo.setFont(new Font("Georgia", Font.BOLD, 28));
		lblTitulo.setForeground(new Color(0, 0, 128));
		lblTitulo.setBounds(300, 30, 400, 40);
		contentPane.add(lblTitulo);

		// Subtítulo
		lblmenu = new JLabel(et.getString("MP"), JLabel.CENTER);
		lblmenu.setFont(new Font("Segoe UI", Font.BOLD, 20));
		lblmenu.setForeground(new Color(0, 0, 180));
		lblmenu.setBounds(410, 75, 180, 30);
		contentPane.add(lblmenu);

		// Botón Pacientes
		btnpac = new JButton(et.getString("AP"));
		btnpac.setBounds(0, 0, 250, 60);
		btnpac.setBackground(new Color(0, 0, 205));
		btnpac.setForeground(Color.WHITE);
		btnpac.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnpac.setFocusPainted(false);
		contentPane.add(btnpac);

		// Botón Médicos
		btnMedicos = new JButton(et.getString("AM"));
		btnMedicos.setBounds(0, 65, 250, 60);
		btnMedicos.setBackground(new Color(0, 0, 205));
		btnMedicos.setForeground(Color.WHITE);
		btnMedicos.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnMedicos.setFocusPainted(false);
		contentPane.add(btnMedicos);

		// Botón Medicamentos
		btnMedicamentos = new JButton(et.getString("AMD"));
		btnMedicamentos.setBounds(0, 325, 250, 60);
		btnMedicamentos.setBackground(new Color(0, 0, 205));
		btnMedicamentos.setForeground(Color.WHITE);
		btnMedicamentos.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnMedicamentos.setFocusPainted(false);
		contentPane.add(btnMedicamentos);

		// Botón Recetas
		btnReceta = new JButton(et.getString("AR"));
		btnReceta.setBounds(0, 130, 250, 60);
		btnReceta.setBackground(new Color(0, 0, 205));
		btnReceta.setForeground(Color.WHITE);
		btnReceta.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnReceta.setFocusPainted(false);
		contentPane.add(btnReceta);

		// Botón Citas
		btnCitas = new JButton(et.getString("AC"));
		btnCitas.setBounds(0, 195, 250, 60);
		btnCitas.setBackground(new Color(0, 0, 205));
		btnCitas.setForeground(Color.WHITE);
		btnCitas.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnCitas.setFocusPainted(false);
		contentPane.add(btnCitas);

		// Botón Consultas
		btnConsultas = new JButton(et.getString("ACO"));
		btnConsultas.setBounds(0, 390, 250, 60);
		btnConsultas.setBackground(new Color(0, 0, 205));
		btnConsultas.setForeground(Color.WHITE);
		btnConsultas.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnConsultas.setFocusPainted(false);
		contentPane.add(btnConsultas);

		// Botón Inventario
		btnInventario = new JButton(et.getString("AI"));
		btnInventario.setBounds(0, 260, 250, 60);
		btnInventario.setBackground(new Color(0, 0, 205));
		btnInventario.setForeground(Color.WHITE);
		btnInventario.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnInventario.setFocusPainted(false);
		contentPane.add(btnInventario);

		// Botón Reportes
		btnReportes = new JButton(et.getString("RP"));
		btnReportes.setBounds(0, 455, 250, 60);
		btnReportes.setBackground(new Color(0, 0, 205));
		btnReportes.setForeground(Color.WHITE);
		btnReportes.setFont(new Font("Segoe UI", Font.BOLD, 16));
		btnReportes.setFocusPainted(false);
		contentPane.add(btnReportes);

		JLabel lblNewLabel = new JLabel("");
		lblNewLabel.setIcon(new ImageIcon(Menu.class.getResource("/imagenes/hos.png")));
		lblNewLabel.setBounds(250, 116, 505, 418);
		contentPane.add(lblNewLabel);

		btnUsu = new JButton("");
		btnUsu.setIcon(new ImageIcon(Menu.class.getResource("/imagenes/icons8-añadir-usuario-masculino-48.png")));
		btnUsu.setBounds(704, 0, 51, 60);
		contentPane.add(btnUsu);
		
		btnRespaldo = new JButton(et.getString("RDD"));
		btnRespaldo.setBounds(610, 102, 145, 23);
		btnRespaldo.setBackground(new Color(0, 0, 205));
		btnRespaldo.setForeground(Color.WHITE);
		contentPane.add(btnRespaldo);
		
	

		// Asignar eventos
		ManejadorBoton escuchador = new ManejadorBoton();
		btnpac.addActionListener(escuchador);
		btnMedicos.addActionListener(escuchador);
		btnMedicamentos.addActionListener(escuchador);
		btnReceta.addActionListener(escuchador);
		btnCitas.addActionListener(escuchador);
		btnConsultas.addActionListener(escuchador);
		btnInventario.addActionListener(escuchador);
		btnReportes.addActionListener(escuchador);
		btnUsu.addActionListener(escuchador);
		btnRespaldo.addActionListener(escuchador);
	} 

	/**
	 * Clase interna que implementa {@link ActionListener} para manejar los eventos
	 * de los botones del menú principal.
	 * 
	 * <p>
	 * Al pulsar un botón, crea y muestra la ventana correspondiente (Pacientes,
	 * Médicos, Medicamentos, Recetas, Citas, Consultas o Inventario).
	 * </p>
	 */
	public class ManejadorBoton implements ActionListener {

		/**
		 * Método que se ejecuta cuando se presiona un botón.
		 * 
		 * @param Evento Evento generado al realizar la acción (clic en botón).
		 */
		@Override
		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnpac)) {
				paciente = new Pacientes();
				paciente.setVisible(true);
			}

			if (Evento.getSource().equals(btnMedicos)) {
				medico = new Medicos();
				medico.setVisible(true);
			}

			if (Evento.getSource().equals(btnMedicamentos)) {
				medi = new Medicamentos();
				medi.setVisible(true);
			}

			if (Evento.getSource().equals(btnReceta)) {
				receta = new Recetas();
				receta.setVisible(true);
			}

			if (Evento.getSource().equals(btnCitas)) {
				citas = new Citas();
				citas.setVisible(true);
			}

			if (Evento.getSource().equals(btnConsultas)) {
				consultas = new Consultas();
				consultas.setVisible(true);
			}
			

			if (Evento.getSource().equals(btnInventario)) {
				inventario = new Inventario();
				inventario.setVisible(true);
			}

			if (Evento.getSource().equals(btnReportes)) {
				reportes = new MenuReportes();
				reportes.setVisible(true);
			}
			
			if (Evento.getSource().equals(btnUsu)) {
				AU = new AñadirUsu();

				AU.setVisible(true);
			}
			
			if (Evento.getSource().equals(btnRespaldo)) {
				
			     FileNameExtensionFilter filtroBackup = new FileNameExtensionFilter(et.getString("NoRES"), "bak");

			    JFileChooser selector = new JFileChooser();
			    selector.setDialogTitle(et.getString("UBI"));
			    selector.setFileFilter(filtroBackup);

			   

			    int seleccion = selector.showSaveDialog(null);

			    if (seleccion == JFileChooser.APPROVE_OPTION) {
			        File archivo = selector.getSelectedFile();

			   
			        String nombreArchivo = archivo.getName();
			        if (!nombreArchivo.toLowerCase().endsWith(".bak")) {
			            archivo = new File(archivo.getAbsolutePath() + ".bak");
			        }

			        String ruta = archivo.getParent(); 
			        String nombreRespaldo = archivo.getName().replace(".bak", ""); 

			        CUsuario.ejecutarRespaldo(ruta, nombreRespaldo);
			    }
			}
			
		}

	}
	



	public void configurarParaAdministrador() {
	
		btnInventario.setEnabled(true);
		btnConsultas.setEnabled(true);
		btnCitas.setEnabled(true);
		btnReportes.setEnabled(true);
		btnReceta.setEnabled(true);
		btnMedicos.setEnabled(true);
		btnMedicamentos.setEnabled(true);
		btnpac.setEnabled(true);
		btnUsu.setEnabled(true);
		btnRespaldo.setEnabled(true);

		
	}

	public void configurarParaMedico() {
		btnInventario.setEnabled(false);
		btnConsultas.setEnabled(true);
		btnCitas.setEnabled(false);
		btnReportes.setEnabled(true);
		btnReceta.setEnabled(true);
		btnMedicos.setEnabled(false);
		btnMedicamentos.setEnabled(false);
		btnpac.setEnabled(true);
		btnUsu.setEnabled(false);
		btnRespaldo.setEnabled(false);

		
	}

	public void configurarParaRecepción() {
		btnInventario.setEnabled(false);
		btnConsultas.setEnabled(true);
		btnCitas.setEnabled(true);
		btnReportes.setEnabled(true);
		btnReceta.setEnabled(false);
		btnMedicos.setEnabled(true);
		btnMedicamentos.setEnabled(false);
		btnpac.setEnabled(true);
		btnUsu.setEnabled(false);
		btnRespaldo.setEnabled(false);

		
	}
	
	public void configurarParaFarmaceutico() {
		btnInventario.setEnabled(true);
		btnConsultas.setEnabled(false);
		btnCitas.setEnabled(false);
		btnReportes.setEnabled(true);
		btnReceta.setEnabled(true);
		btnMedicos.setEnabled(false);
		btnMedicamentos.setEnabled(true);
		btnpac.setEnabled(false);
		btnUsu.setEnabled(false);
		btnRespaldo.setEnabled(false);
	}
	
	
}


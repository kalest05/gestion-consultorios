package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Date;
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
import javax.swing.JTextField;
import javax.swing.border.EmptyBorder;

import com.toedter.calendar.JDateChooser;

import controladores.Ccitas;
import controladores.Cconsultas;
import controladores.Cinventario;
import controladores.Cmedicamento;
import controladores.Cmedicos;
import controladores.Cpacientes;
import controladores.Crecetas;
import modelos.MMedicamentos;
import modelos.MMedicos;
import modelos.MPaciente;
import java.awt.Toolkit;

public class MenuReportes extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JButton Citas;
	private JButton Consultas;
	private JButton Especialidades;
	private JButton Inventario;
	private JButton Medicamentos;
	private JButton Medicos;
	private JButton Pacientes;
	private JButton Presentaciones;
	private JButton Recetas;
	private JButton Religiones;
	private JButton Servicios;
	private JButton Subespecialidades;
	private JLabel lblTitulo;
	private JLabel lblmenu;
	private static Locale Idioma;
	private static ResourceBundle et;
	private JButton Departamentos;
	private DefaultComboBoxModel<String> Depto;
	private DefaultComboBoxModel<String> Espe;
	private JDateChooser Calendario2;
	private JDateChooser Calendario;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					MenuReportes frame = new MenuReportes();
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
	public MenuReportes() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(MenuReportes.class.getResource("/imagenes/icons8-plan-de-tratamiento-24.png")));
		Idioma = Locale.getDefault();
		et = ResourceBundle.getBundle("properties/dic", Idioma);

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 898, 433);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		contentPane.setBackground(Color.WHITE);
		contentPane.setLayout(null);
		setContentPane(contentPane);

		lblTitulo = new JLabel(et.getString("hospital"), JLabel.CENTER);
		lblTitulo.setFont(new Font("Georgia", Font.BOLD, 28));
		lblTitulo.setForeground(new Color(0, 0, 128));
		lblTitulo.setBounds(-11, 15, 400, 40);
		contentPane.add(lblTitulo);

		// Subtítulo
		lblmenu = new JLabel(et.getString("rep"), JLabel.CENTER);
		lblmenu.setFont(new Font("Segoe UI", Font.BOLD, 20));
		lblmenu.setForeground(new Color(0, 0, 180));
		lblmenu.setBounds(66, 62, 234, 30);
		contentPane.add(lblmenu);

		Citas = new JButton(et.getString("C"));
		Citas.setBounds(392, 65, 200, 30);
		estiloBoton(Citas);
		contentPane.add(Citas);

		Consultas = new JButton(et.getString("CO"));
		Consultas.setBounds(392, 105, 200, 30);
		estiloBoton(Consultas);
		contentPane.add(Consultas);

		Especialidades = new JButton(et.getString("E"));
		Especialidades.setBounds(392, 228, 200, 30);
		estiloBoton(Especialidades);
		contentPane.add(Especialidades);

		Inventario = new JButton(et.getString("I"));
		Inventario.setBounds(640, 269, 200, 30);
		estiloBoton(Inventario);
		contentPane.add(Inventario);

		Medicamentos = new JButton(et.getString("M"));
		Medicamentos.setBounds(640, 187, 200, 30);
		estiloBoton(Medicamentos);
		contentPane.add(Medicamentos);

		Subespecialidades = new JButton(et.getString("S"));
		Subespecialidades.setBounds(392, 269, 200, 30);
		estiloBoton(Subespecialidades);
		contentPane.add(Subespecialidades);

		Servicios = new JButton(et.getString("SE"));
		Servicios.setBounds(392, 146, 200, 30);
		estiloBoton(Servicios);
		contentPane.add(Servicios);

		Religiones = new JButton(et.getString("R"));
		Religiones.setBounds(640, 105, 200, 30);
		estiloBoton(Religiones);
		contentPane.add(Religiones);

		Recetas = new JButton(et.getString("RE"));
		Recetas.setBounds(640, 146, 200, 30);
		estiloBoton(Recetas);
		contentPane.add(Recetas);

		Presentaciones = new JButton(et.getString("P"));
		Presentaciones.setBounds(640, 228, 200, 30);
		estiloBoton(Presentaciones);
		contentPane.add(Presentaciones);

		Pacientes = new JButton(et.getString("PA"));
		Pacientes.setBounds(640, 67, 200, 30);
		estiloBoton(Pacientes);
		contentPane.add(Pacientes);

		Medicos = new JButton(et.getString("ME"));
		Medicos.setBounds(392, 187, 200, 30);
		estiloBoton(Medicos);
		contentPane.add(Medicos);

		JLabel lblNewLabel = new JLabel("");
		lblNewLabel.setIcon(new ImageIcon(MenuReportes.class.getResource("/imagenes/rep4.png")));
		lblNewLabel.setBounds(30, 103, 250, 255);
		contentPane.add(lblNewLabel);

		Departamentos = new JButton(et.getString("D"));
		Departamentos.setBounds(392, 310, 200, 30);
		estiloBoton(Departamentos);
		contentPane.add(Departamentos);

		ManejadorBotones escuchador = new ManejadorBotones();
		Citas.addActionListener(escuchador);
		Consultas.addActionListener(escuchador);
		Departamentos.addActionListener(escuchador);
		Especialidades.addActionListener(escuchador);
		Inventario.addActionListener(escuchador);
		Medicamentos.addActionListener(escuchador);
		Medicos.addActionListener(escuchador);
		Pacientes.addActionListener(escuchador);
		Presentaciones.addActionListener(escuchador);
		Recetas.addActionListener(escuchador);
		Religiones.addActionListener(escuchador);
		Servicios.addActionListener(escuchador);
		Subespecialidades.addActionListener(escuchador);
	}

	public class ManejadorBotones implements ActionListener {
		
		public void actionPerformed(ActionEvent evento) {
			
			if(evento.getSource().equals(Consultas)) {
				int opcion = JOptionPane.showConfirmDialog(null,
						et.getString("RCON"), et.getString("GNRE"),
						JOptionPane.YES_NO_OPTION);

				if (opcion == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("CONMED"), et.getString("REPCON")};
					JComboBox<String> med = new JComboBox<String>(opciones);
					int seleccion = JOptionPane.showConfirmDialog(null, med, et.getString("SUF"),
							JOptionPane.OK_CANCEL_OPTION);

					if (seleccion == JOptionPane.OK_OPTION) {
						if (med.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (med.getSelectedIndex()) {
						case 1:
							JTextField nomM = new JTextField();
							int opcionmm = JOptionPane.showConfirmDialog(null, nomM, et.getString("IDMD"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcionmm == JOptionPane.OK_OPTION) {
								Cconsultas.reporteconxmed(Integer.parseInt(nomM.getText()));
							}
							break;
						case 2:
							Cconsultas.repsemanalcon();
							break;
						
						}
					}

				} else {
					Cconsultas.reportebasec();
				}
				
			}
			
			if(evento.getSource().equals(Recetas)) {
				int opcion = JOptionPane.showConfirmDialog(null,
						et.getString("RREC"), et.getString("GNRE"),
						JOptionPane.YES_NO_OPTION);

				if (opcion == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("HFP"), et.getString("RRSS")};
					JComboBox<String> med = new JComboBox<String>(opciones);
					int seleccion = JOptionPane.showConfirmDialog(null, med, et.getString("SUF"),
							JOptionPane.OK_CANCEL_OPTION);

					if (seleccion == JOptionPane.OK_OPTION) {
						if (med.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (med.getSelectedIndex()) {
						case 1:
							JTextField nomM = new JTextField();
							int opcionmm = JOptionPane.showConfirmDialog(null, nomM, et.getString("IIDP"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcionmm == JOptionPane.OK_OPTION) {
								Crecetas.reportehistorialfarmaco(Integer.parseInt(nomM.getText()));
							}
							break;
						case 2:
							Crecetas.reporteserxrec();
						}
					}

				} else {
					Crecetas.repbase();
				}
				
			}
			
			if(evento.getSource().equals(Citas)) {
				int opcion = JOptionPane.showConfirmDialog(null,
						et.getString("GRFC"), et.getString("GNRE"),
						JOptionPane.YES_NO_OPTION);

				if (opcion == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("CPPD"), et.getString("CNAS")};
					JComboBox<String> med = new JComboBox<String>(opciones);
					int seleccion = JOptionPane.showConfirmDialog(null, med, et.getString("SUF"),
							JOptionPane.OK_CANCEL_OPTION);

					if (seleccion == JOptionPane.OK_OPTION) {
						if (med.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (med.getSelectedIndex()) {
						case 1:
							Calendario2= new JDateChooser(new Date());
							int opcion2 = JOptionPane.showConfirmDialog(null, Calendario2, et.getString("IFRB"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion2 == JOptionPane.OK_OPTION) {
								Ccitas.reportecitaxdia(Calendario2.getDate());
							}
							break;
						case 2:
							Ccitas.repnoatendidasxmes();
						}
					}

				} else {
					Ccitas.reportebase();
				}
				
			}
			
			if(evento.getSource().equals(Servicios)) {
				Ccitas.reporteservisddisp();
			}
			if(evento.getSource().equals(Presentaciones)) {
				Cmedicamento.reportepresentaciones();
			}
			if(evento.getSource().equals(Religiones)) {
				Cpacientes.reporteelig();
			}
			
			if(evento.getSource().equals(Departamentos)) {
				Cmedicos.reporteDepa();
			}
			if(evento.getSource().equals(Especialidades)) {
				Cmedicos.reporteespecialidad();
			}
			if(evento.getSource().equals(Subespecialidades)) {
				Cmedicos.reporteSubespecialidad();
			}
			

			if (evento.getSource().equals(Medicamentos)) {
			
				int opcion = JOptionPane.showConfirmDialog(null,
						et.getString("GRFM"), et.getString("GNRE"),
						JOptionPane.YES_NO_OPTION);

				if (opcion == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("MVFE"), et.getString("MPTP")};
					JComboBox<String> med = new JComboBox<String>(opciones);
					int seleccion = JOptionPane.showConfirmDialog(null, med, et.getString("SUF"),
							JOptionPane.OK_CANCEL_OPTION);

					if (seleccion == JOptionPane.OK_OPTION) {
						if (med.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (med.getSelectedIndex()) {
						case 1:
							Calendario2= new JDateChooser(new Date());
							int opcion2 = JOptionPane.showConfirmDialog(null, Calendario2, et.getString("IFRB"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion2 == JOptionPane.OK_OPTION) {
								MMedicamentos pac = new MMedicamentos();
								pac.setFechaVen(Calendario2.getDate());
								Cmedicamento.reportepacientesConParametros(pac);
							}
							break;
						case 2:
							Cmedicamento.reporteporpresentacion();
						}
					}

				} else {
					Cmedicamento.reportebase();
				}
			}

			if (evento.getSource().equals(Medicos)) {
				int opcion = JOptionPane.showConfirmDialog(null,
						et.getString("GRFD"), et.getString("GNRE"),
						JOptionPane.YES_NO_OPTION);

				if (opcion == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("PORD"), et.getString("PORE"), };
					JComboBox<String> med = new JComboBox<String>(opciones);
					int seleccion = JOptionPane.showConfirmDialog(null, med, et.getString("SUF"),
							JOptionPane.OK_CANCEL_OPTION);

					if (seleccion == JOptionPane.OK_OPTION) {
						if (med.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (med.getSelectedIndex()) {
						case 1:
							Depto = new DefaultComboBoxModel<String>();
							Depto = Cmedicos.llenarDepto();
							JComboBox<String> depa = new JComboBox<String>(Depto);
							int opcion2 = JOptionPane.showConfirmDialog(null, depa, et.getString("PARAM"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion2 == JOptionPane.OK_OPTION) {
								MMedicos dep = new MMedicos();
								dep.setDep(depa.getSelectedItem().toString());
								Cmedicos.generarReporteConParametros(dep);
							}
							break;
						case 2:

							Espe = new DefaultComboBoxModel<String>();
							Espe = Cmedicos.llenarEspe();
							JComboBox<String> Espec = new JComboBox<String>(Espe);
							int opcion21 = JOptionPane.showConfirmDialog(null, Espec, et.getString("PARAMS"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion21 == JOptionPane.OK_OPTION) {
								MMedicos esp = new MMedicos();
								esp.setEsp(Espec.getSelectedItem().toString());
								Cmedicos.generarReporteConParametros2(esp);
							}
							break;
							
					
							

						}
					}

				} else {
					Cmedicos.generarReportebase();
				}
			}
			
			if (evento.getSource().equals(Inventario)) {
				int opcion = JOptionPane.showConfirmDialog(null,
						et.getString("GRFI"), et.getString("GNRE"),
						JOptionPane.YES_NO_OPTION);

				if (opcion == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("MEDAGO"), et.getString("LOTMED")};
					JComboBox<String> med = new JComboBox<String>(opciones);
					int seleccion = JOptionPane.showConfirmDialog(null, med, et.getString("SUF"),
							JOptionPane.OK_CANCEL_OPTION);

					if (seleccion == JOptionPane.OK_OPTION) {
						if (med.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (med.getSelectedIndex()) {
						case 1:
							Cinventario.reporteagotados();
							break;
						
						case 2:
							JTextField nomM = new JTextField();

							int opcionmm = JOptionPane.showConfirmDialog(null, nomM, et.getString("INM"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcionmm == JOptionPane.OK_OPTION) {
								MMedicamentos pac = new MMedicamentos();
								pac.setNombreMed(nomM.getText());
								Cinventario.reporteinventariopormed(pac);
							}
							break;
							
						}
					}

				} else {
					Cinventario.reportebase();
				}
			}

			if (evento.getSource().equals(Pacientes)) {
				int respuesta = JOptionPane.showConfirmDialog(null,
						et.getString("GRPF"), et.getString("PARAMS"), JOptionPane.YES_NO_OPTION);

				if (respuesta == JOptionPane.YES_OPTION) {
					String[] opciones = { et.getString("SEL"), et.getString("SCA"), et.getString("BPN"), et.getString("PCP"), et.getString("GHM") };
					JComboBox<String> nom = new JComboBox<String>(opciones);

					int opcion = JOptionPane.showConfirmDialog(null, nom, et.getString("FLT"), JOptionPane.OK_CANCEL_OPTION,
							JOptionPane.PLAIN_MESSAGE);

					if (opcion == JOptionPane.OK_OPTION) {
						if (nom.getSelectedItem().toString().equals(et.getString("SEL"))) {
							JOptionPane.showMessageDialog(null, et.getString("SUO"),
									et.getString("tituloerror"), JOptionPane.ERROR_MESSAGE);
							return;
						}
						switch (nom.getSelectedIndex()) {

						case 1:
							Calendario = new JDateChooser(new Date());
							int opcion2 = JOptionPane.showConfirmDialog(null, Calendario, et.getString("PDF"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion2 == JOptionPane.OK_OPTION) {
								// Date fecha = Calendario.getDate();
								MPaciente pac = new MPaciente();
								pac.setFechaNac(Calendario.getDate());
								Cpacientes.reportepacientesConParametros(pac);

								// Cpacientes.reporteproc(pac);
								// PruebitaPa.reportepacientesConParametros(pac);
							}
							break;

						case 2:
							JTextField nom2 = new JTextField();

							int opcion22 = JOptionPane.showConfirmDialog(null, nom2, et.getString("IEN"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion22 == JOptionPane.OK_OPTION) {
								MPaciente pac = new MPaciente();
								pac.setNombre(nom2.getText());
								Cpacientes.reportepacientesConParametroNombres(pac);
							}
							break;
						case 3:
							Cpacientes.reportecitaspen();
							break;

						case 4:
							JTextField nom4 = new JTextField();

							int opcion4 = JOptionPane.showConfirmDialog(null, nom4, et.getString("IIDP"),
									JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

							if (opcion4 == JOptionPane.OK_OPTION) {
								MPaciente pac1 = new MPaciente();
								pac1.setId(Integer.parseInt(nom4.getText()));
								Cpacientes.reportehistorialmed(pac1);
							}
							break;	
						
						}
					}
				} else {
					Cpacientes.reportepacientessin();
				}
			}

		}

	}

	private void estiloBoton(JButton boton) {
		boton.setBackground(new Color(0, 0, 205));
		boton.setForeground(Color.WHITE);
		boton.setFont(new Font("Segoe UI", Font.BOLD, 14));
		boton.setFocusPainted(false);
	}
}
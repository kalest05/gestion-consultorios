package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;

import controladores.CUsuario;
import modelos.MUsuarios;

public class Login extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField txtUsuario;
	private JButton btnLogin;
	private JLabel lblUsuario;
	private JLabel lblContrasena;
	private JLabel lblTitulo;
	private JLabel lblNewLabel;
	private JPasswordField passwordField;
	public JComboBox<String> rol;
	public static Menu Menu;
	public static String Rol;
	/**
	 * Variable que toma el idioma predeterminado del sistema.
	 */
	private static Locale Idioma;
	/**
	 * Variable utilizada para la internacionalización.
	 */
	private static ResourceBundle et;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Login frame = new Login();
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
	public Login() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(Login.class.getResource("/imagenes/icons8-clínica-24.png")));
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");

		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setSize(400, 500);
		contentPane = new JPanel();
		contentPane.setBackground(Color.WHITE);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setBackground(new Color(245, 245, 245));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		setLocationRelativeTo(null);

		lblTitulo = new JLabel(et.getString("hospital"), SwingConstants.CENTER);
		lblTitulo.setFont(new Font("SansSerif", Font.BOLD, 26));
		lblTitulo.setBounds(0, 36, 386, 30);
		contentPane.add(lblTitulo);

		lblUsuario = new JLabel(et.getString("usuario"));
		lblUsuario.setBounds(28, 230, 80, 25);
		contentPane.add(lblUsuario);

		txtUsuario = new JTextField();
		txtUsuario.setBounds(118, 230, 200, 30);
		contentPane.add(txtUsuario);

		lblContrasena = new JLabel(et.getString("contra"));
		lblContrasena.setBounds(28, 290, 80, 25);
		contentPane.add(lblContrasena);

		btnLogin = new JButton(et.getString("IS"));
		btnLogin.setBounds(134, 387, 140, 35);
		btnLogin.setBackground(new Color(0, 153, 153));
		btnLogin.setForeground(Color.WHITE);
		contentPane.add(btnLogin);

		lblNewLabel = new JLabel("");
		lblNewLabel.setIcon(new ImageIcon(Login.class.getResource("/imagenes/icons8-hospital-100.png")));
		lblNewLabel.setBounds(150, 91, 100, 90);
		contentPane.add(lblNewLabel);

		passwordField = new JPasswordField();
		passwordField.setBounds(118, 290, 200, 30);
		contentPane.add(passwordField);

		ManejadorBoton Escuchador = new ManejadorBoton();
		btnLogin.addActionListener(Escuchador);

	}

	private class ManejadorBoton implements ActionListener {// clase fuera del metodo principal pero dentro de la

		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnLogin)) {

				if (txtUsuario.getText().trim().isEmpty() || passwordField.getPassword().length == 0) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}

				try {
					char[] passChars = passwordField.getPassword();
					String contrasena = new String(passChars);

					// Crear objeto del modelo
					MUsuarios usuarioLogin = new MUsuarios();
					usuarioLogin.setNombreUsuario(txtUsuario.getText().trim());
					usuarioLogin.setContraseña(contrasena);

					// Metodo validar login
					boolean accesoValido = CUsuario.validarUsuario(usuarioLogin);

					if (accesoValido) {
						Rol = CUsuario.obtenerRolUsuario(usuarioLogin);
						JOptionPane.showMessageDialog(null, et.getString("BVN") + Rol);

						Menu = new Menu();
						Window ventana = SwingUtilities.getWindowAncestor(btnLogin);
				        if (ventana != null) {
				            ventana.dispose();
				        }

						switch (Rol) {
						case "Administrador":

							Menu.configurarParaAdministrador();
							Menu.setVisible(true);

							System.out.print("Menu");
							break;

						case "Medico":
							Menu.configurarParaMedico();
							Menu.setVisible(true);

							break;

						case "Recepcionista":
							Menu.configurarParaRecepción();
							Menu.setVisible(true);
							break;

						case "Farmaceutico":
							Menu.configurarParaFarmaceutico();
							Menu.setVisible(true);

						default:
							JOptionPane.showMessageDialog(null, et.getString("RNR"), "Error",
									JOptionPane.ERROR_MESSAGE); 
							return;
						} 
					} else {
						JOptionPane.showMessageDialog(null, "Credenciales incorrectas o rol inválido", "Error",
								JOptionPane.ERROR_MESSAGE);
					}

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("RIN"), "Error", JOptionPane.ERROR_MESSAGE);
					
					JOptionPane.showMessageDialog(null, e.toString(), "Error", JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				} finally {
					limpiar();
				}

			}

		}

		private void limpiar() {
			txtUsuario.setText("");
			passwordField.setText("");

		}
	}

}
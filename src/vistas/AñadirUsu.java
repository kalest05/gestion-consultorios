package vistas;

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
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
import javax.swing.border.EmptyBorder;

import controladores.CUsuario;
import modelos.MUsuarios;
import java.awt.Toolkit;

public class AñadirUsu extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField txtUsuario;
	private JLabel lblUsuario;
	private JLabel lblContrasena;
	private JLabel lblTitulo;
	private JLabel lblNewLabel;
	private JPasswordField passwordField;
	private JLabel lblNewLabel_1;
	public JComboBox<String> rol;
	public JButton btnAnUsu;
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
					AñadirUsu frame = new AñadirUsu();
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
	public AñadirUsu() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(AñadirUsu.class.getResource("/imagenes/icons8-añadir-usuario-24.png")));
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

		lblNewLabel = new JLabel("");
		lblNewLabel.setIcon(new ImageIcon(Login.class.getResource("/imagenes/icons8-hospital-100.png")));
		lblNewLabel.setBounds(150, 91, 100, 90);
		contentPane.add(lblNewLabel);

		passwordField = new JPasswordField();
		passwordField.setBounds(118, 290, 200, 30);
		contentPane.add(passwordField);

		lblNewLabel_1 = new JLabel(et.getString("rol"));
		lblNewLabel_1.setBounds(28, 362, 49, 14);
		contentPane.add(lblNewLabel_1);

		rol = new JComboBox<String>(
				new String[] { et.getString("SEL"), et.getString("MEDIc"), et.getString("FARM"), et.getString("RECP") });
		rol.setBounds(118, 358, 150, 30);
		contentPane.add(rol);

		btnAnUsu = new JButton(et.getString("AUSU"));
		btnAnUsu.setForeground(Color.WHITE);
		btnAnUsu.setBackground(new Color(0, 153, 153));
		btnAnUsu.setBounds(134, 417, 140, 35);
		contentPane.add(btnAnUsu);

		ManejadorBoton Escuchador = new ManejadorBoton();
		btnAnUsu.addActionListener(Escuchador);

	}

	private class ManejadorBoton implements ActionListener {// clase fuera del metodo principal pero dentro de la

		public void actionPerformed(ActionEvent Evento) {

			if (Evento.getSource().equals(btnAnUsu)) {

				if (txtUsuario.getText().trim().isEmpty() || passwordField.getPassword().length == 0
						|| rol.getSelectedIndex() <= 0) {

					JOptionPane.showMessageDialog(null, et.getString("nolleno"), "Error", JOptionPane.ERROR_MESSAGE);
					return;
				}

				try {
					char[] passChars = passwordField.getPassword();
					String contrasena = new String(passChars);

					MUsuarios usuarionuevo = new MUsuarios();
					usuarionuevo.setNombreUsuario(txtUsuario.getText().trim());
					usuarionuevo.setContraseña(contrasena);
					usuarionuevo.setRol(rol.getSelectedItem().toString());

					CUsuario.guardarUsuario(usuarionuevo);

				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, et.getString("EIS"), "Error", JOptionPane.ERROR_MESSAGE);
					e.printStackTrace();
				}
				finally {
					limpiar();
				}

			}

		}

	}
	
	private void limpiar() {
		txtUsuario.setText("");
		passwordField.setText("");
		rol.setSelectedItem(et.getString("SEL"));// Deselecciona la fila

	}

}

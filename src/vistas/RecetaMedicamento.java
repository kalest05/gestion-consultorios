package vistas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;



public class RecetaMedicamento extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JScrollPane scrollPane;
	private JPanel panelMedicamentos;
	private JPanel panel2;
	private JButton btnAnadir;

    private ArrayList<String> medicamentos = new ArrayList<>();
    private ArrayList<Integer> cantidades = new ArrayList<>();
    private ArrayList<JPanel> panelesGrupos = new ArrayList<>();

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
					RecetaMedicamento frame = new RecetaMedicamento();
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
	public RecetaMedicamento() {
		Idioma = Locale.getDefault();

		et = ResourceBundle.getBundle("properties/dic", Idioma);
		System.out.println("Registro: " + Idioma.getDisplayName());
		System.out.println("============================================");
		
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setBounds(100, 100, 626, 400);
        contentPane = new JPanel();
        contentPane.setBackground(Color.WHITE);
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        contentPane.setLayout(null);
        setContentPane(contentPane);

        scrollPane = new JScrollPane();
        scrollPane.setBounds(0, 0, 615, 300);
        contentPane.add(scrollPane);

        panelMedicamentos = new JPanel();
        panelMedicamentos.setBackground(new Color(240, 248, 255));
        panelMedicamentos.setLayout(new BoxLayout(panelMedicamentos, BoxLayout.Y_AXIS));
        scrollPane.setViewportView(panelMedicamentos);

        panel2 = new JPanel();
        panel2.setBounds(0, 300, 615, 60);
        panel2.setLayout(null);
        contentPane.add(panel2);

        btnAnadir = new JButton(et.getString("anmed"));
        btnAnadir.setFont(new Font("Tahoma", Font.PLAIN, 14));
        btnAnadir.setBounds(219, 15, 195, 31);
        panel2.add(btnAnadir);

        ManejadorBotones escuchador = new ManejadorBotones();
        btnAnadir.addActionListener(escuchador);
		

	}
	
	public class ManejadorBotones implements ActionListener{

		@Override
		public void actionPerformed(ActionEvent Evento) {
			if(Evento.getSource().equals(btnAnadir)) {
				agregarMedicamento();
			}
			
		}
		
	}
	public void agregarMedicamento() {
	    JPanel panelGrupo = new JPanel();
	    panelGrupo.setPreferredSize(new Dimension(600, 45));
	    panelGrupo.setMaximumSize(new Dimension(600, 45));
	    panelGrupo.setBackground(new Color(220, 235, 250));
	    panelGrupo.setLayout(new FlowLayout(FlowLayout.LEFT, 10, 10)); // margen entre componentes

	    JLabel lbl = new JLabel("Medicamento");
	    lbl.setFont(new Font("Tahoma", Font.PLAIN, 14));
	    panelGrupo.add(lbl);

	    JComboBox<String> combo = new JComboBox<>();
	    combo.setFont(new Font("Tahoma", Font.PLAIN, 14));
	    combo.addItem("Paracetamol");
	    combo.addItem("Ibuprofeno");
	    combo.addItem("Amoxicilina");
	    panelGrupo.add(combo);

	    JLabel lblCantidad = new JLabel("Cantidad:");
	    lblCantidad.setFont(new Font("Tahoma", Font.PLAIN, 14));
	    panelGrupo.add(lblCantidad);

	    JSpinner spinner = new JSpinner(new SpinnerNumberModel(1, 1, 100, 1));
	    spinner.setFont(new Font("Tahoma", Font.PLAIN, 14));
	    spinner.setPreferredSize(new Dimension(60, 25)); // fuerza buen tamaño
	    panelGrupo.add(spinner);

	    JButton btnEliminar = new JButton("Eliminar");
	    btnEliminar.setFont(new Font("Tahoma", Font.PLAIN, 12));
	    panelGrupo.add(btnEliminar);

	    btnEliminar.addActionListener(ae -> {
	        panelMedicamentos.remove(panelGrupo);
	        panelesGrupos.remove(panelGrupo);
	        panelMedicamentos.revalidate();
	        panelMedicamentos.repaint();
	    });

	    panelMedicamentos.add(panelGrupo);
	    panelesGrupos.add(panelGrupo);
	    panelMedicamentos.revalidate();
	    panelMedicamentos.repaint();

	    SwingUtilities.invokeLater(() -> {
	        scrollPane.getVerticalScrollBar().setValue(scrollPane.getVerticalScrollBar().getMaximum());
	    });

	    medicamentos.add((String) combo.getSelectedItem());
	    cantidades.add((Integer) spinner.getValue());
	}

}
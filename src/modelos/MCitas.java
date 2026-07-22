package modelos;

import java.sql.Timestamp;

/**
 * Clase MCitas representa una cita médica registrada en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion
 * registrada. Este encapsula toda la información relacionada con una cita
 * médica, para utilizarse en el controlador {@link controladores.Crecetas} y
 * llevar a cabo acciones mediante la interfaz en {@link vistas.Citas}
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MCitas {
	String idPaciente;
	String idMedico;
	String Motivo;
	String Comentario;
	String Servicios;
	String Consultorios;
	Timestamp FechaC;

	/**
	 * @return the idPaciente
	 */
	public String getIdPaciente() {
		return idPaciente;
	}

	/**
	 * @param idPaciente the idPaciente to set
	 */
	public void setIdPaciente(String idPaciente) {
		this.idPaciente = idPaciente;
	}

	/**
	 * @return the idMedico
	 */
	public String getIdMedico() {
		return idMedico;
	}

	/**
	 * @param idMedico the idMedico to set
	 */
	public void setIdMedico(String idMedico) {
		this.idMedico = idMedico;
	}

	/**
	 * @return the motivo
	 */
	public String getMotivo() {
		return Motivo;
	}

	/**
	 * @param motivo the motivo to set
	 */
	public void setMotivo(String motivo) {
		Motivo = motivo;
	}

	/**
	 * @return the comentario
	 */
	public String getComentario() {
		return Comentario;
	}

	/**
	 * @param comentario the comentario to set
	 */
	public void setComentario(String comentario) {
		Comentario = comentario;
	}

	/**
	 * @return the servicios
	 */
	public String getServicios() {
		return Servicios;
	}

	/**
	 * @param servicios the servicios to set
	 */
	public void setServicios(String servicios) {
		Servicios = servicios;
	}

	/**
	 * @return the consultorios
	 */
	public String getConsultorios() {
		return Consultorios;
	}

	/**
	 * @param consultorios the consultorios to set
	 */
	public void setConsultorios(String consultorios) {
		Consultorios = consultorios;
	}

	/**
	 * @return the fechaC
	 */
	public Timestamp getFechaC() {
		return FechaC;
	}

	/**
	 * @param fechaC the fechaC to set
	 */
	public void setFechaC(Timestamp fechaC) {
		FechaC = fechaC;
	}

}
package modelos;

import java.util.Date;
/**
 * Clase <b>{@code MConsultas}</b> representa una consulta registrada en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion
 * registrada. Este encapsula toda la información relacionada con una 
 * consulta para utilizarse en el controlador {@link controladores.Cconsultas} y
 * llevar a cabo acciones mediante la interfaz en {@link vistas.Consultas}
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MConsultas {
	
	int idCita;
	Date fecha;
	String Diagnostico;
	String Observaciones;
	String Presion;
	String Altura;
	String Temp;
	String Peso;

	
	/**
	 * @return the idCita
	 */
	public int getIdCita() {
		return idCita;
	}
	/**
	 * @param idCita the idCita to set
	 */
	public void setIdCita(int idCita) {
		this.idCita = idCita;
	}
	/**
	 * @return the fecha
	 */
	public Date getFecha() {
		return fecha;
	}
	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	/**
	 * @return the diagnostico
	 */
	public String getDiagnostico() {
		return Diagnostico;
	}
	/**
	 * @param diagnostico the diagnostico to set
	 */
	public void setDiagnostico(String diagnostico) {
		Diagnostico = diagnostico;
	}
	/**
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return Observaciones;
	}
	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		Observaciones = observaciones;
	}
	/**
	 * @return the presion
	 */
	public String getPresion() {
		return Presion;
	}
	/**
	 * @param presion the presion to set
	 */
	public void setPresion(String presion) {
		Presion = presion;
	}
	/**
	 * @return the altura
	 */
	public String getAltura() {
		return Altura;
	}
	/**
	 * @param altura the altura to set
	 */
	public void setAltura(String altura) {
		Altura = altura;
	}
	/**
	 * @return the temp
	 */
	public String getTemp() {
		return Temp;
	}
	/**
	 * @param temp the temp to set
	 */
	public void setTemp(String temp) {
		Temp = temp;
	}
	/**
	 * @return the peso
	 */
	public String getPeso() {
		return Peso;
	}
	/**
	 * @param peso the peso to set
	 */
	public void setPeso(String peso) {
		Peso = peso;
	}
	
}
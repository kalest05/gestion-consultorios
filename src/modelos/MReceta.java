package modelos;

import java.util.Date;

/**
 * Clase MReceta representa una receta que es registrado en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion registrada.
 * Este encapsula toda la información relacionada con los recetas del hospital, utilizarse
 * en el controlador {@link controladores.Crecetas} y llevar a cabo acciones mediante
 * la interfaz en {@link vistas.Recetas}
 * </p>
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 * 
 */
public class MReceta {
	int idcita;
	Date fecha;
	String duracion;
	String nstruccion;
	String idmedicamento;
	int cantidadmed;
	/**
	 * @return el idcita
	 */
	public int getIdcita() {
		return idcita;
	}
	/**
	 * @param idcita el idcita para configurar
	 */
	public void setIdcita(int idcita) {
		this.idcita = idcita;
	}
	/**
	 * @return la fecha
	 */
	public Date getFecha() {
		return fecha;
	}
	/**
	 * @param fecha la fecha a establecer
	 */
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	/**
	 * @return la dosis
	 */
	
	/**
	 * @return la duracion
	 */
	public String getDuracion() {
		return duracion;
	}
	/**
	 * @param duracion la duracion a configuar
	 */
	public void setDuracion(String duracion) {
		this.duracion = duracion;
	}
	/**
	 * @return el nstruccion
	 */
	public String getNstruccion() {
		return nstruccion;
	}
	/**
	 * @param nstruccion the nstruccion a configurar
	 */
	public void setNstruccion(String nstruccion) {
		this.nstruccion = nstruccion;
	}
	/**
	 * @return la idmedicamento
	 */
	public String getIdmedicamento() {
		return idmedicamento;
	}
	/**
	 * @param idmedicamento la idmedicamento para configurar
	 */
	public void setIdmedicamento(String idmedicamento) {
		this.idmedicamento = idmedicamento;
	}
	/**
	 * @return la cantidadmed
	 */
	public int getCantidadmed() {
		return cantidadmed;
	}
	/**
	 * @param cantidadmed la cantidadmed a establecer
	 */
	public void setCantidadmed(int cantidadmed) {
		this.cantidadmed = cantidadmed;
	}

}
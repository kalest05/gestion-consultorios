package modelos;

import java.util.Date;

/**
 * Clase MMedicamentos representa un medicamento que es registrado en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion registrada.
 * Este encapsula toda la información relacionada con los medicamento, para utilizarse
 * en el controlador y llevar a cabo acciones mediante
 * la interfaz en
 * </p>
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Milagros Guadalupe Camacho Camacho
 * @author Lilian Sarahí Tapía García
 * @version 1.0
 */
public class MMedicamentos {

	public String getNombreMed() {
		return nombreMed;
	}
	public void setNombreMed(String nombreMed) {
		this.nombreMed = nombreMed;
	}
	public Date getFechaVen() {
		return fechaVen;
	}
	public void setFechaVen(Date fechaVen) {
		this.fechaVen = fechaVen;
	}
	public String getPresentacion() {
		return presentacion;
	}
	public void setPresentacion(String presentacion) {
		this.presentacion = presentacion;
	}
	public String getCodigoB() {
		return CodigoB;
	}
	public void setCodigoB(String codigoB) {
		CodigoB = codigoB;
	}
	public String getMarca() {
		return Marca;
	}
	public void setMarca(String marca) {
		Marca = marca;
	}
	public String getLaboratorio() {
		return Laboratorio;
	}
	public void setLaboratorio(String laboratorio) {
		Laboratorio = laboratorio;
	}
	public String getFormula() {
		return Formula;
	}
	public void setFormula(String formula) {
		Formula = formula;
	}
	public String getClaveR() {
		return ClaveR;
	}
	public void setClaveR(String claveR) {
		ClaveR = claveR;
	}
	public String getIdPresentacion() {
		return idPresentacion;
	}
	public void setIdPresentacion(String idPresentacion) {
		this.idPresentacion = idPresentacion;
	}
	public int getMgUnidad() {
		return mgUnidad;
	}
	public void setMgUnidad(int mgUnidad) {
		this.mgUnidad = mgUnidad;
	}
	String nombreMed;
	 Date fechaVen;
	 String presentacion;
	 String CodigoB;
	 String Marca;
	 String Laboratorio;
	 String Formula;
	 String ClaveR;
	 String idPresentacion;
	 int mgUnidad;
	 int Id;
	public Integer getId() {
		return Id;
	}
	public void setId(Integer id) {
		Id = id;
	}
	 

}
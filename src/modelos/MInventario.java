package modelos;

import java.util.Date;
/**
 * Clase <b>{@code MInventario}</b> representa una consulta registrada en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion
 * registrada. Este encapsula toda la información relacionada con el 
 * inventario para utilizarse en el controlador {@link controladores.Cconsultas} y
 * llevar a cabo acciones mediante la interfaz en {@link vistas.Inventario}
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MInventario {
	String Medicamento;
	int Cantidad;
	Date Fecha;
	String Lote;
	/**
	 * @return the medicamento
	 */
	public String getMedicamento() {
		return Medicamento;
	}
	/**
	 * @param medicamento the medicamento to set
	 */
	public void setMedicamento(String medicamento) {
		Medicamento = medicamento;
	}
	/**
	 * @return the cantidad
	 */
	public int getCantidad() {
		return Cantidad;
	}
	/**
	 * @param cantidad the cantidad to set
	 */
	public void setCantidad(int cantidad) {
		Cantidad = cantidad;
	}
	/**
	 * @return the fecha
	 */
	public Date getFecha() {
		return Fecha;
	}
	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(Date fecha) {
		Fecha = fecha;
	}
	/**
	 * @return the lote
	 */
	public String getLote() {
		return Lote;
	}
	/**
	 * @param lote the lote to set
	 */
	public void setLote(String lote) {
		Lote = lote;
	}
	

}